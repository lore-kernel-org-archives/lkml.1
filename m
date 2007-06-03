Return-Path: <linux-kernel-owner+w=401wt.eu-S1751177AbXFCSjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbXFCSjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXFCSjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:39:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4501 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750750AbXFCSjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:39:44 -0400
Date: Sun, 3 Jun 2007 14:39:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 & 4 testers
 wanted)
Message-ID: <Pine.LNX.4.44L0.0706031416430.1771-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg:

A while back you asked whether Kay's block-device patch would work 
under FC3 or FC4.  I've got an old FC4 system; the normal kernel-update 
procedure hasn't worked on it for some time.  (I don't remember exactly 
when it stopped working.)

Not for any sinister reason.  The underlying problem seems to be that
the nash script or the nash executable in the initramfs image created
by RedHat's mkinitrd program in FC4 has a few errors.  In particular,
the "--movedev" option to the switchroot command doesn't work right.

On the other hand, I customized that script for myself last year (only
a few changes were needed) and have had no problems booting any kernel
up to and including your current development tree.

For the record, here is the script as created by FC4's last official 
update:

#!/bin/nash

mount -t proc /proc /proc
setquiet
echo Mounted /proc filesystem
echo Mounting sysfs
mount -t sysfs /sys /sys
echo Creating /dev
mount -o mode=0755 -t tmpfs /dev /dev
mknod /dev/console c 5 1
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mkdir /dev/pts
mkdir /dev/shm
echo Starting udev
/sbin/udevstart
echo -n "/sbin/hotplug" > /proc/sys/kernel/hotplug
echo "Loading jbd.ko module"
insmod /lib/jbd.ko 
echo "Loading ext3.ko module"
insmod /lib/ext3.ko 
/sbin/udevstart
echo Creating root device
mkrootdev /dev/root
echo Mounting root filesystem
mount -o defaults --ro -t ext3 /dev/root /sysroot
echo Switching to new root
switchroot --movedev /sysroot

Don't ask me why udevstart is called twice -- it works okay under FC4's 
2.6.17 kernel.

Here is the diff for my customized version:

--- norm/init   2007-06-03 14:02:58.000000000 -0400
+++ test/init   2007-06-03 14:01:13.000000000 -0400
@@ -22,7 +22,10 @@
 /sbin/udevstart
 echo Creating root device
 mkrootdev /dev/root
+umount /sys
 echo Mounting root filesystem
 mount -o defaults --ro -t ext3 /dev/root /sysroot
+mount -t tmpfs --bind /dev /sysroot/dev
 echo Switching to new root
-switchroot --movedev /sysroot
+switchroot /sysroot
+umount /initrd/dev

In all honesty, I should mention that the versions of nash and udev in
my customized initramfs image aren't the same as the ones in the FC4
image.  They are derived from FC6; in fact I use the same initramfs
image for testing new kernels under both FC4 and FC6.  Also the
contents of etc/udev/udev.conf differ in the two images.

Alan Stern

