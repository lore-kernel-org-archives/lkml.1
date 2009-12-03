Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZLCROI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZLCROI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZLCROH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:14:07 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:50307 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZLCROG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:14:06 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_G2ieXMP7gWs2l245rpSZrA)"
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32
Date: Thu, 03 Dec 2009 12:13:52 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8; KDE/4.3.3; i686; ; )
References: <alpine.LFD.2.00.0912022125400.2872@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.0912022125400.2872@localhost.localdomain>
Message-id: <200912031213.52290.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary_(ID_G2ieXMP7gWs2l245rpSZrA)
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT

On Thursday 03 December 2009, Linus Torvalds wrote:
>This release _feels_ long overdue due to two empty weeks for me (kernel
[...]
What may be a minor niggle during the build using my attached script:
======From the scripts output=========
now making a new initrd.2.6.32.img                            
resolveDevice: device spec expected                           
and copying it to /boot/initrd-2.6.32.img
===============
The 2nd line above is new, but a "man mkinitrd" doesn't address it on this 
F10 box.  Comment?

A cursory scan through the build history shows this unrelated but new 
warning:
--------------------
drivers/acpi/acpica/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
/usr/src/linux-2.6.32/arch/x86/include/asm/string_32.h:74: warning: array 
subscript is above array bounds
-------------------
I haven't rebooted to it yet so I'll save this & send (or expand) when I 
have.
::::::::::
That was fun. I had to reboot twice, first time with the hdwe reset button, 
2nd time by several ctl-alt-del's.

Both shutdowns, from .32-rc8 and from .32 did multiple Oopsen, naming 
dcache.c line 670 as the culprit.  With mount.cifs mentioned also.

That has been present and not a huge problem for several of the 31 and 32-rcX 
kernels.  I could capture with a camera, but I believe I have seen msgs here 
on the list about it already.

The reason for the 2nd reboot is that udev did not enumerate, or initialize, 
any of the devices on an FTDI extension cable that runs to the basement, 
where an elderly color computer 3 lives.  There is an additional hub on the 
end of that cable, with several connections to it, and I had to find that 
cable, unplug it from the local hub and re-plug it before the stuff on the 
other end of the cable materialized.  It is not normally powered, so the 
enumeration usually stops at that hub in the basement (and usb power was on 
it ok), with everything else coming alive as they are powered up.  The 2nd 
reboot was to see if it was all there if it was powered up, and it is.

I'll go back to lurking till next time.  Many thanks to all.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Miksch's Law:
	If a string has one end, then it has another end.

--Boundary_(ID_G2ieXMP7gWs2l245rpSZrA)
Content-type: application/x-shellscript; name=makeit
Content-transfer-encoding: 7bit
Content-disposition: attachment; filename=makeit

#!/bin/sh
## this script assumes you have downloaded, unpacked and linked kernel-whatever.version
## First, edit this to set the version string to match the Makefile setting
# yeah, I know, I should pass it as $1.  Someday...
VER=2.6.32
echo now makeing kernel $VER, if not right, hit ctl+c now && \
sleep 3 && \
## For use with the lm_sensors kit, you'll need the following lines inserted
## into your /etc/rc.d/rc.local script
##------------------
### now do some lm-sensors stuff
## i2c adaptor drivers
#modprobe i2c-via
## i2c chip drivers
#modprobe gl518sm
## alternate chip driver
#modprobe eeprom
##------------------
## And add these lines to /etc/conf.modules
# I2C module options
#alias char-major-89 i2c-dev
##------------------
## Now, the real work.  This assumes you have copied your
## .config and .config.old
## files from the source directory of your previous kernel install, and have
## done 'make oldconfig' in the new source directory and answered all the
## questions, and then do a 'make xconfig' to check/change anything you wanted
## to

## The above is NOT for major version upgrades, you must start from scratch, do NOT
## copy over the older .config's when upping from 2.2.x to 2.4.x or 2.6.x

# I've re-arranged this to be one contiguous command line, because this way if there
# is an error, it dies right there instead of making you scroll back 300k in the
# history to check for errors.
# And, due to changes in the 2.6 way of doing things, the System.map
# stuff has been moved to a point BEFORE the make modules_install
# because make modules_install now has a self-contained depmod command. :(

# Also, one should make sure the DEPMOD declaration in the Makefile
# is NOT hard coded pathwise, so it will find the newer, 2.6 version of depmod

make clean && \
echo && \
echo && \
echo makeing bzImage && \
ccache make -j3 bzImage && \
echo && \
echo && \
echo Now making modules && \
echo && \
echo && \
ccache make -j3 modules && \
echo && \
echo removeing /boot/vmlinuz-$VER-old && \
rm -f /boot/vmlinuz-$VER-old && \
echo touching vmlinuz-$VER && \
touch /boot/vmlinuz-$VER && \
echo mv-ing /boot/vmlinuz-$VER /boot/vmlinuz-$VER-old && \
mv -f /boot/vmlinuz-$VER /boot/vmlinuz-$VER-old && \
echo copying bzImage to /boot/vmlinuz-$VER && \
cp -f arch/i386/boot/bzImage /boot/vmlinuz-$VER && \
echo removeing old lib/modules/$VER.old && \
rm -fR /lib/modules/$VER.old && \
echo touching /lib/modules/$VER && \
touch /lib/modules/$VER && \
echo moving /lib/modules/$VER to /lib/modules/$VER.old && \
mv -f /lib/modules/$VER /lib/modules/$VER.old && \
echo cleaning up in /boot && \
rm -f /boot/System.map && \
echo saveing the System.map-$VER to System.map-$VER.old && \
touch /boot/System.map-$VER && \
mv /boot/System.map-$VER /boot/System.map-$VER.old && \
echo copying in new System.map && \
cp -f System.map /boot/System.map-$VER && \
echo cd-ing to /boot && \
cd /boot && \
echo doing the link of System.map-$VER to System.map && \
ln -s System.map-$VER System.map && \
echo cd-ing back to /usr/src/linux-$VER to do the modules_install && \
cd /usr/src/linux-$VER && \
echo make modules_install && \
ccache make -j3 modules_install && \
echo now making a new initrd.$VER.img && \
touch initrd-$VER.img && \
rm -f initrd-$VER.img && \
mkinitrd -f initrd-$VER.img $VER && \
echo and copying it to /boot/initrd-$VER.img && \
touch /boot/initrd-$VER.img.old && \
rm -f /boot/initrd-$VER.img.old && \
touch /boot/initrd-$VER.img && \
mv /boot/initrd-$VER.img /boot/initrd-$VER.img.old && \
cp initrd-$VER.img /boot/initrd-$VER.img && \
make firmware_install && \
cd /usr/src/linux-$VER && \
depmod -ae -F System.map $VER && \
# Ok, now we need to be saving the .config in /boot and dump the copy in /proc \
touch /boot/config-$VER.gz && \
mv /boot/config-$VER.gz /boot/config-$VER.gz.old && \
gzip -c .config >/boot/config-$VER.gz && \
ls -l /boot/ | grep config-$VER.gz && \
echo All done! Edit grub.conf, reboot and chose your kernel at the grub prompt


--Boundary_(ID_G2ieXMP7gWs2l245rpSZrA)--
