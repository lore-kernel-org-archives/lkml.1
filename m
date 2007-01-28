Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXA1Mld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXA1Mld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbXA1Mld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:41:33 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:60056 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXA1Mlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:41:32 -0500
Date: Sun, 28 Jan 2007 13:40:29 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
In-Reply-To: <45BC6740.1000606@tls.msk.ru>
Message-ID: <Pine.LNX.4.61.0701281327180.22295@yvahk01.tjqt.qr>
References: <593246.19408.qm@web52505.mail.yahoo.com>
 <Pine.LNX.4.61.0701271931260.22295@yvahk01.tjqt.qr> <45BC6740.1000606@tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2007 12:05, Michael Tokarev wrote:
>Jan Engelhardt wrote:
>> 
>> That's interesting. I am using Aurora Corona, and all but md0 vanishes.
>> (Reason for that is that udev does not create the nodes md1-md31 on
>> boot, so mdadm cannot assemble the arrays.)
>
>This is nonsense.
>
>Mdadm creates those nodes automa[tg]ically - man mdadm, search for --auto.
>Udev has exactly nothing to do with mdX nodes.

Note that `mdadm -As` _is_ run on FC6 boot.

>In order for an md array to be started up on boot, it has to be specified
>in /etc/mdadm.conf.  With proper DEVICE line in there.  That's all.

That's how it is, and it does not work.

openSUSE 10.2:
no mdadm.conf _at all_, /etc/init.d/boot.d/boot.md is chkconfig'ed _out_,
_no_ md kernel module is loaded, and I still have all the /dev/md nodes.

FC6 standard install:
no mdadm.conf, otherwise regular boot. /dev/md0 exists. Uhuh.

FC6 with two raids:

# fdisk -l
Disk /dev/sdb: 8589 MB, 8589934592 bytes
255 heads, 63 sectors/track, 1044 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1         123      987966   fd  Linux raid autodetect
/dev/sdb2             124         246      987997+  fd  Linux raid autodetect
/dev/sdb3             247         369      987997+  fd  Linux raid autodetect
/dev/sdb4             370        1044     5421937+  fd  Linux raid autodetect

Disk /dev/sdc: 8589 MB, 8589934592 bytes
255 heads, 63 sectors/track, 1044 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1         123      987966   fd  Linux raid autodetect
/dev/sdc2             124         246      987997+  fd  Linux raid autodetect
/dev/sdc3             247         369      987997+  fd  Linux raid autodetect
/dev/sdc4             370        1044     5421937+  fd  Linux raid autodetect

# mdadm -C /dev/md0 -e 1.0 -l 1 -n 2 /dev/sdb1 /dev/sdc1
mdadm: array /dev/md0 started.
# mdadm -C /dev/md1 -e 1.0 -l 1 -n 2 /dev/sdb2 /dev/sdc2
mdadm: error opening /dev/md1: No such file or directory

Showstopper.

# mknod /dev/md1 b 9 1
# mdadm -C /dev/md1 -e 1.0 -l 1 -n 2 /dev/sdb2 /dev/sdc2
mdadm: array /dev/md1 started.
# cat /etc/mdadm.conf
cat: /etc/mdadm.conf: No such file or directory
# echo "DEVICE /dev/sd[a-z][0-9]" >/etc/mdadm.conf
# mdadm --detail --scan >>/etc/mdadm.conf
# cat /etc/mdadm.conf
DEVICE /dev/sd[a-z][0-9]
ARRAY /dev/md0 level=raid1 num-devices=2 name=0 UUID=5ded6a11:3b9072f6:ae46efc7:d1628ea7
ARRAY /dev/md1 level=raid1 num-devices=2 name=1 UUID=2fda5608:d63d8287:761a7a09:68fe743f
# reboot

...
Starting udev: [ OK ]
Loading default keymap (us): [ OK ]
Setting hostname fc6.site: [ OK ]
mdadm: /dev/md0 has been started with 2 drives.
mdadm: error opening /dev/md1: No such file or directory
No devices found
Setting up Logical Volume Management: No volume groups found [ OK ]
...

Now with "DEVICE partitions" in mdadm.conf:

mdadm: /dev/md0 has been started with 2 drives.
mdadm: error opening /dev/md1: No such file or directory

You see, I have all the reason to be confused.

>But in any case, this has exactly nothing to do with kernel.
>It's 100% userspace issues, I'd say distribution-specific issues.

At least I can agree.


	-`J'
-- 
