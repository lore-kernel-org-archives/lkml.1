Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYDRNIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYDRNIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYDRNIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:08:34 -0400
Received: from rrzmta2.rz.uni-regensburg.de ([194.94.155.53]:19974 "EHLO
	rrzmta2.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYDRNId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:08:33 -0400
X-Greylist: delayed 1193 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2008 09:08:33 EDT
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg, Klinikum
To: linux-kernel@vger.kernel.org
Date: Fri, 18 Apr 2008 14:48:27 +0200
MIME-Version: 1.0
Subject: /proc/mounts vs mount inconsistency in 2.6.16 (SLES10 SP1)
Message-ID: <4808B4B2.23552.144FC9C0@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.27/Sophos-P=4.25.0+V=4.25+U=2.07.189+R=07 January 2008+T=335501@20080418.124043Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think I found a little problem in kernel 2.6.16.54-0.2.5-xen (Current SLES10 
SP1):

By mistake I mounted some filesystem read-only over /.

Realizing the mistake, I did an "umount /", which seemed to work.

Then I noticed that / was mounted read-only, while the files being there were 
those of the right root filesystem.

So I did a "Mount  -o remount /" which enabled writes again.

As some other program had odd effects, I did "cat /proc/mounts" which still 
displayed the wrong device and readonly (/dev/system/as2-root / reiserfs ro 0 0), 
while umount refused to unmount it "umount: /dev/system/as2-root: not mounted".

It seems the interface between the mount/umount program and /proc/mounts is a bit 
instable...

Some Details:
Device /dev/system/as2-root is mounted in the privileged domain,
and so cannot be mounted by a guest.
 # mount
/dev/mapper/system-root on / type reiserfs (rw)
[...]
# cat /proc/mounts
rootfs / rootfs rw 0 0
[...]
/dev/system/as2-root / reiserfs ro 0 0
# umount /dev/system/as2-root
umount: /dev/system/as2-root: not mounted
# umount -f /dev/system/as2-root
umount2: Invalid argument
umount: /dev/system/as2-root: not mounted
# mount -o remount /dev/system/root / ### having looked it up in /etc/fstab
# cat /proc/mounts
rootfs / rootfs rw 0 0
[...]
/dev/system/as2-root / reiserfs ro 0 0
# mount /dev/system/root /
# cat /proc/mounts
rootfs / rootfs rw 0 0
[...]
/dev/system/as2-root / reiserfs ro 0 0
# umount / ### succeeds!
# mount /dev/system/root /
mount: /dev/system/root already mounted or / busy
mount: according to mtab, /dev/mapper/system-root is already mounted on /
# cat /proc/mounts
rootfs / rootfs rw 0 0
[...]
/dev/system/as2-root / reiserfs ro 0 0
/dev/system/root / reiserfs ro 0 0
# xm create -c as2
Using config file "/etc/xen/vm/as2".
Error: Device 2049 (vbd) could not be connected.
Device /dev/system/as2-root is mounted in the privileged domain,
and so cannot be mounted by a guest.

S**t: Isn't there a solution other than rebooting Dom0 (XEN talk)?

Regards,
Ulrich
P.S. I'm not subscribed to the kernel list, so if you want to reach me, please CC:

