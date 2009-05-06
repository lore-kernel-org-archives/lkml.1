Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbZEFM4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbZEFM4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbZEFM4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:56:41 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:50422 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967AbZEFM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:56:40 -0400
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
From: Kay Sievers <kay.sievers@vrfy.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Jan Blunck <jblunck@suse.de>
In-Reply-To: <1241097822.2516.3.camel@poy>
References: <1241097822.2516.3.camel@poy>
Content-Type: text/plain
Date: Wed, 06 May 2009 14:56:38 +0200
Message-Id: <1241614598.3319.28.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 15:23 +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs

Below are some numbers. Appended the used initramfs /init script, which
gets very simple with devtmpfs, compared what we need do today to handle
and fill an empty /dev after mounting its own tmpfs there.

This simple initramfs example still supports udev by-{label,uuid,id} device
name links, and other setups which need udev to find/setup/assemble
the root device.

Thanks,
Kay


kvm: initramfs mount-by-label
[    2.018622] Freeing unused kernel memory: 2172k freed
[    2.034799] initramfs: starting ...
[    2.093656] initramfs: looking for /dev/disk/by-label/root
[    2.121746] initramfs: starting udev
[    2.141221] udev: starting version 142
[    2.223777] initramfs: trigger block events
[    2.465649] initramfs: mounting /dev/disk/by-label/root
[    2.937051] kjournald starting.  Commit interval 5 seconds
[    2.941167] EXT3 FS on sda1, internal journal
[    2.962522] EXT3-fs: mounted filesystem with writeback data mode.
[    3.122292] initramfs: switching to root filesystem /dev/disk/by-label/root and start /bin/bash

kvm: initramfs mount-by-kernel-node
[    1.939865] Freeing unused kernel memory: 2172k freed
[    1.957918] initramfs: starting ...
[    2.226510] initramfs: looking for /dev/sda1
[    2.249192] initramfs: mounting /dev/sda1
[    2.731584] kjournald starting.  Commit interval 5 seconds
[    2.736040] EXT3 FS on sda1, internal journal
[    2.779422] EXT3-fs: mounted filesystem with writeback data mode.
[    2.866554] initramfs: switching to root filesystem /dev/sda1 and start /bin/bash

kvm: direct kernel mount
[    2.425663] kjournald starting.  Commit interval 5 seconds
[    2.434656] EXT3 FS on sda1, internal journal
[    2.506279] EXT3-fs: mounted filesystem with writeback data mode.
[    2.517395] VFS: Mounted root (ext3 filesystem) on device 259:524288.
[    2.550488] devtmpfs: mounted
[    2.555379] Freeing unused kernel memory: 2172k freed

real box: initramfs and mount-by-label
[    1.513740] Freeing unused kernel memory: 2172k freed
[    1.519782] initramfs: starting ...
[    1.532795] initramfs: looking for /dev/disk/by-label/root
[    1.533226] initramfs: starting udev
[    1.537925] initramfs: trigger block events
[    1.538715] udev: starting version 142
[    1.647484] initramfs: mounting /dev/disk/by-label/root
[    1.657646] kjournald starting.  Commit interval 5 seconds
[    1.657804] EXT3 FS on sda1, internal journal
[    1.657864] EXT3-fs: mounted filesystem with writeback data mode.
[    1.687084] initramfs: switching to root filesystem /dev/disk/by-label/root and start /sbin/init

real box: kernel mount
[    1.329632] kjournald starting.  Commit interval 5 seconds
[    1.329756] EXT3 FS on sda1, internal journal
[    1.329814] EXT3-fs: mounted filesystem with writeback data mode.
[    1.329867] VFS: Mounted root (ext3 filesystem) on device 259:524288.
[    1.330313] devtmpfs: mounted
[    1.330377] async_waiting @ 1
[    1.330381] async_continuing @ 1 after 0 usec
[    1.330424] Freeing unused kernel memory: 2172k freed



#!/bin/sh

# minimal initramfs with persistent device name support
# requires devtmpfs support provided by the kernel

shell() {
	echo "initramfs: dropping to shell"
	exec >/dev/console 2>&1 </dev/console < /dev/console
	sh -i
}

getarg() {
	local o line
	for o in $cmdline; do
		test "$o" = "$1" && return 0
		if test "${o%%=*}" = "${1%=}"; then
			echo ${o#*=}
			return 0
		fi
	done
	return 1
}

export PATH=/sbin:/bin:/usr/sbin:/usr/bin
export TERM=linux

# console redirect
exec >/dev/kmsg 2>&1 </dev/console
echo "initramfs: starting ..."

# mount needed filesystems
mount -t proc /proc /proc >/dev/null
mount -t sysfs /sys /sys >/dev/null
mount -t devpts -o gid=5,mode=620 /dev/pts /dev/pts

# kernel commandline
read cmdline </proc/cmdline;

# root we are looking for
root=$(getarg root=)
echo "initramfs: looking for $root"

# shortcut, in case root is already there 
if test -e "$root"; then
	echo "initramfs: mounting $root"
	mount "$root" /root
	mounted=yes
fi

# we need to start udev to create the symlink we are looking for
if test -z "$mounted"; then
	echo "initramfs: starting udev"
	udevd --daemon --resolve-names=never
	# create links for already existing block devices
	echo "initramfs: trigger block events"
	udevadm trigger --subsystem-match=block
	udevadm settle --timeout=3

	# try if the link is there now
	if test -e "$root"; then
		echo "initramfs: mounting $root"
		mount "$root" /root
		mounted=yes
	fi

	if test -z "$mounted"; then
		# load modules to let the root device show up
		echo "initramfs: trigger module events"
		udevadm trigger --attr-match=modalias

		echo "initramfs: waiting for $root"
		# loop until root shows up
		while test -z "$mounted"; do
			if test -e "$root"; then
				echo "initramfs: mounting $root"
				mount "$root" /root && mounted=yes
			fi
			sleep 0.05
		done
	fi

	# kill udev
	kill $(pidof udevd) >/dev/null 2>&1
fi

# move filesystems over to the mounted root
mount --move /dev /root/dev
mount --move /proc /root/proc
mount --move /sys /root/sys

# move into root
cd /root
init=$(getarg init=)
test -z "$init" && init=/sbin/init
echo "initramfs: switching to root filesystem $root and start $init"
exec run-init -c /dev/console /root $init


