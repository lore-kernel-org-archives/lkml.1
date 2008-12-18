Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752778AbYLREdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYLREdo (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 23:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLREdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 23:33:33 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:50399 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYLREdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 23:33:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hPSfkLbJ6xeO68W136tMEbqBNCmjus23NKg0mfQGqXTNOlGVWHuVmFuef0zM0pKDbb
         q61fl9EDlxVhG0zm5yBba8xZ3vV5bfGBhhaS9d5zzdfIUlgJ47Ol/p4jmzZudjj8Ccyn
         6MeSooLCTjR1eHhUAT/A6zVx0l/XGc1cXsmIY=
Message-ID: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
Date: Wed, 17 Dec 2008 23:33:31 -0500
From: "Dylan Taft" <d13f00l@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: MDADM Software Raid Woes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, apologies ahead of time if this mailing list isn't the correct one...

I'm having two issues here...

I've been trying to configure sofrware raid on my system

Kernel Version: 2.6.28-rc7

cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid0 sdc2[1] sdb2[0]
      1952507776 blocks 64k chunks

md0 : active raid1 sdc1[1] sdb1[0]
      505920 blocks [2/2] [UU]

/dev/sdb and sdc are set up identically, both paritition types set to
"fd" so raid autodetect should work, md and related modules are built
into my kernel

/dev/sdb1               1          63      506016   fd  Linux raid autodetect
/dev/sdb2              64      121601   976253985   fd  Linux raid autodetect

I created the raids with the mdadm tool, originally configured manually
/dev/md0 for sdb1/sdc1 raid1 to be mounted as /boot
/dev/md1 for sdb2/sdc2 raid0

I created 3 partitions on md1, one for future /, one for swap, one for
future /home.
So I had /dev/md0, md1, and /dev/md1p1,/dev/md1p2/dev/md1p3

Upon rebooting, I end up with

d13f00l-desktop proc # ls /dev/md* -al
lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md0 -> md/0
lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1 -> md/1
lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1p1 -> md/1
lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1p2 -> md/2
lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1p3 -> md/3

/dev/md:
total 0
drwxr-xr-x  2 root root    120 Dec 17 19:13 .
drwxr-xr-x 18 root root  14680 Dec 17 19:13 ..
brw-r-----  1 root disk   9, 0 Dec 17 19:13 0
brw-r-----  1 root disk 259, 0 Dec 17 19:13 1
brw-r-----  1 root disk 259, 1 Dec 17 19:13 2
brw-r-----  1 root disk 259, 2 Dec 17 19:13 3


md1 is seen as the first partition on md1, instead of as the physical
raid with the additional partitions on it.
Even if i mdadm --stop md1, and do mdadm -A /dev/md1 /dev/sdb2
/dev/sdc2, md1 is seen as the first partition instead of as the whole
raid

fdisk:
Disk /dev/md1: 30.0 GB, 30000003072 bytes
2 heads, 4 sectors/track, 7324219 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x609b513e


If I do mdadm -A /dev/md4 /dev/sdb2 /dev/sdc2
and then fdisk md4, I see the partitions.
Disk /dev/md4: 1999.3 GB, 1999367962624 bytes
2 heads, 4 sectors/track, 488126944 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0xe96a943b

    Device Boot      Start         End      Blocks   Id  System
/dev/md4p1               1     7324220    29296878   83  Linux
/dev/md4p2         7324221     7568362      976568   82  Linux swap / Solaris
/dev/md4p3         7568363   488126944  1922234328   83  Linux



Is something being autodetected wrong here, or am I doing something
wrong?  Should I not be creating partitions on a software raid device?


The other issue is that I can't get my system to boot off the raid.
cat lilo.conf
# $Header: /var/cvsroot/gentoo-x86/sys-boot/lilo/files/lilo.conf,v 1.2
2004/07/18 04:42:04 dragonheart Exp $
# Author: Ultanium

#
# Start LILO global section
#

# Faster, but won't work on all systems:
#compact
# Should work for most systems, and do not have the sector limit:
lba32
# If lba32 do not work, use linear:
#linear

# MBR to install LILO to:
boot = /dev/md0
raid-extra-boot=/dev/sdb,/dev/sdc
map = /boot/.map

# If you are having problems booting from a hardware raid-array
# or have a unusual setup, try this:
#disk=/dev/ataraid/disc0/disc bios=0x80  # see this as the first BIOS disk
#disk=/dev/sda bios=0x80                 # see this as the second BIOS disk
#disk=/dev/hda bios=0x82                 # see this as the third BIOS disk

# Here you can select the secondary loader to install.  A few
# examples is:
#
#    boot-text.b
#    boot-menu.b
#    boot-bmp.b
#
install = /boot/boot-menu.b   # Note that for lilo-22.5.5 or later you
                              # do not need boot-{text,menu,bmp}.b in
                              # /boot, as they are linked into the lilo
                              # binary.

menu-scheme=Wb
prompt
# If you always want to see the prompt with a 15 second timeout:
#timeout=150
delay = 50
# Normal VGA console
vga = normal
# VESA console with size 1024x768x16:
#vga = 791

#
# End LILO global section
#

#
# Linux bootable partition config begins
#
image = /boot/bzImage
	root = /dev/md/1
	#root = /devices/discs/disc0/part3
	label = Gentoo
	#append = "irqpoll"	
#append = "mtrr_chunk_size=2048M mtrr_gran_size=16M"
	read-only # read-only for checking

image  = /boot/memtest86plus/memtest.bin
label  = Memtest86Plus

#
# Linux bootable partition config ends
#

#
# DOS bootable partition config begins
#
#other = /dev/hda1
#	#other = /devices/discs/disc0/part1
#	label = Windows
#	table = /dev/hda
#
# DOS bootable partition config ends
#

At boot, /dev/md/1 is my root device.  It's an ext3 filesystem.  Ext3
is built into the kernel and all, as is the raid stuff.  When I boot
off sdb, i get a VFS panic, please append correct root= boot option,.
Cannot open device 0x10300

Am I doing something wrong here?

Thanks!

Dylan
