#!/usr/bin/env bash

set -e
set -x

export DEBIAN_FRONTEND=noninteractive
echo "Updating APT cache"
apt-get update

if [ ! -d "/etc/ansible" ]; then

if [ -n "$(dpkg-query -l python-pip 2> /dev/null)" ]; then
    echo "Removing distutils installed 'python-pip' package"
    apt-get -o Dpkg::Options::="--force-confold" remove python-pip --purge -y
fi

echo "Upgrading system"
apt-get -o Dpkg::Options::="--force-confold" upgrade -y

echo "Updating APT cache"
apt-get update

echo "Installing mandatory packages for ansible"
apt-get -o Dpkg::Options::="--force-confold" install \
    sudo                \
    aptitude            \
    git                 \
    python-apt          \
    apt-transport-https \
    python-distutils-extra \
    python-setuptools   \
    python-apt-dev      \
    python-dev          \
    libssl-dev          \
    libffi-dev          \
    build-essential     \
    libperl-dev         \
    -y

echo "Installing pip via easy_install"
for i in 1 2 3 4 5; do easy_install pip && break || sleep 2; done

echo "Installing correct python crypto libs"
pip install -U pyopenssl ndg-httpsclient pyasn1

echo "Installing ansible via pip"
pip install -U pip ansible

mkdir -p /etc/ansible/

fi
