#!/bin/bash

# color
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

# packages
tools="python3-pip steghide seclists ghidra zaproxy neofetch chromium htop libimage-exiftool-perl chisel python3-venv bloodhound pipx"

# pip2
pip2="https://bootstrap.pypa.io/pip/2.7/get-pip.py"

# peas
linpeas="https://github.com/carlospolop/PEASS-ng/releases/download/20220214/linpeas.sh"
winpeasbat="https://github.com/carlospolop/PEASS-ng/releases/download/20220214/winPEAS.bat"
winpeas64="https://github.com/carlospolop/PEASS-ng/releases/download/20220214/winPEASx64.exe"
winpeas86="https://github.com/carlospolop/PEASS-ng/releases/download/20220214/winPEASx86.exe"

# pspy
pspy32="https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32"
pspy64="https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64"
pspy32s="https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32s"
pspy64s="https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64s"

# linux exploit suggester
les="https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh"
les2="https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl"

lse="https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh"
powerview="https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1"

# Clone tools from GitHub.
wes="https://github.com/AonCyberLabs/Windows-Exploit-Suggester.git"
gittools="https://github.com/internetwache/GitTools.git"

if [ $# -eq 0 ]
then
	echo $red"Please give it a directory to put your tools. It'll create a directory automatically."$reset
	echo -e $yellow"\nExample: ./stuff.sh /home/kali/tools"$reset
else
	echo -e $red"\nInstalling $tools from repo... Need root privilege!"$reset
	sudo apt update
	sudo apt install $tools -y
	#echo "\n$tools installation should be finished... Check script output for more info."
	echo -e $yellow"\nInstalling pip2..."$reset
	wget $pip2 -O ~/Downloads/get-pip2.py
	python2 ~/Downloads/get-pip2.py
	
	echo -e $yellow"\nAdding pipx to path and installing mitm6..."$reset
	pipx ensurepath
	pipx install mitm6
	
	echo -e $yellow"\nInstalling evil-winrm..."$reset
	gem install --user-install evil-winrm
	while true;
	do
		echo $red"evil-winrm is installed for current user. Is gem in your path? If not, do you want me to add it to your .zshrc? Y/N?"$reset
		read answer
		if [ $answer == "Y" ] || [ $answer == "y" ]
		then
			echo $green"Adding path to .zshrc... You will likely have to restart your terminal to apply changes."$reset
			echo -e '''\nif which ruby >/dev/null && which gem >/dev/null; then
    PATH="$PATH:$(ruby -r rubygems -e '\'puts Gem.user_dir\'')/bin"
fi\n''' >> ~/.zshrc
			break
		elif [ $answer == "N" ] || [ $answer == "n" ]
		then
			echo $green"Told not to add gem path to .zshrc."$reset
			break
		else
			echo $yellow"Wrong input..."$reset
			continue
		fi
	done
	
	if [ -d "$1" ]
	then
		echo -e $yellow"\n$1 already exists..."$reset
		cd $1
	else
		echo -e $green"\nCreating $1 directory..."$reset
		mkdir $1
		cd $1
	fi
	
	echo $yellow"Downloading tools into $1..."$reset
	
	wget $linpeas
	wget $winpeasbat
	wget $winpeas64
	wget $winpeas86
	wget $pspy32
	wget $pspy64
	wget $pspy32s
	wget $pspy64s
	wget $les -O les.sh
	wget $les2 -O les2.pl
	wget $lse
	wget $powerview

	echo -e $yellow"\nCloning tools from GitHub to /opt/ folder..."$reset
	cd /opt/
	sudo git clone $wes
	sudo chown -R $(whoami):$(whoami) Windows-Exploit-Suggester

	echo -e "\n"

	sudo git clone $gittools
	sudo chown -R $(whoami):$(whoami) GitTools
	
	echo -e $yellow"\nDownloading finished... Check script output if you think any error is occured or for more info..."$reset
	echo $green"Otherwise, you should be good to get started... :D"$reset
fi
