Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbXHWObm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbXHWObm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbXHWObd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:31:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34874 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066AbXHWObc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:31:32 -0400
Date: Thu, 23 Aug 2007 16:31:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Martin Vogt <vogt@itwm.fraunhofer.de>
cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs corruption by doing nothing
In-Reply-To: <46CD92B6.5090900@itwm.fraunhofer.de>
Message-ID: <Pine.LNX.4.64.0708231625360.32316@fbirervta.pbzchgretzou.qr>
References: <46CD92B6.5090900@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 23 2007 15:59, Martin Vogt wrote:
>
>Its unclear if this is a knoppix bug, but reiserfs
>simply tries to "correct something" which is wrong.

I agree that this should not happen, especially not on RAID1
if the RAID superblock is of version 0.90 or 1.0.

>>ReiserFS: sda2: found reiserfs format "3.6" with standard journal
>>ReiserFS: sda2: using ordered data mode
>>ReiserFS: sda2: warning: sh-461: journal_init: wrong transaction max size
>>(144767). Changed to 1024
>
>^^^^^^^^^^here
>
>>ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
>>ReiserFS: sdb2: using ordered data mode
>>ReiserFS: sdb2: warning: sh-461: journal_init: wrong transaction max size
>>(144767). Changed to 1024
>
>^^^^^^^^^^here

>After that the filesystem is completely broken.
>
>The setup:
>
>The fileserver is a mirror raid, two drives:
>
>>DEVICE /dev/sda1 /dev/sdb1 /dev/sda2 /dev/sdb2
>>ARRAY /dev/md0 level=raid1 num-devices=2 devices=/dev/sda1,/dev/sdb1 name=0
>>UUID=bd639458:60844c49:38db9f1f:61e51054
>>ARRAY /dev/md1 level=raid1 num-devices=2 devices=/dev/sda2,/dev/sdb2 name=1
>>UUID=016fdb8b:4d1e2ba7:9734a5c9:f4e84a24
>
>
>So knoppix should _not_ identify the drives in the fstab
>(1. Error)
>fstab:
>># Added by KNOPPIX
>>/dev/sda1 /media/sda1 ext3 noauto,users,exec 0 0
>># Added by KNOPPIX
>>/dev/sda2 /media/sda2 reiserfs noauto,users,exec 0 0
>># Added by KNOPPIX
>>/dev/sdb1 /media/sdb1 ext3 noauto,users,exec 0 0
>># Added by KNOPPIX
>>/dev/sdb2 /media/sdb2 reiserfs noauto,users,exec 0 0
>
>And reiserfs should not try to correct something, without
>even issuing a mount command.
>(2. Error)
>>ReiserFS: sda2: warning: sh-461: journal_init: wrong transaction max size
>>(144767). Changed to 1024
>>ReiserFS: sdb2: warning: sh-461: journal_init: wrong transaction max size
>>(144767). Changed to 1024

I suppose someone did issue a mount. That is what

	mount -t auto /dev/foo /test

will do - it tries all currently loaded filesystems. (And hence, an ext3 might
get recognized as an ext2.) But at least, and thankfully, this will fail if the
md device is already up.

>This is the history of what I typed:
>
>root@Knoppix:/# history
>    1  mdrun
>    2  modprobe raid1
>    3  mdrun
>    4  vgscan
>    5  vgchange -a y
>    6  mkdir /newroot
>    7  mount /dev/system3/slash /newroot/

mdrun - what is that?

>1: failed because the raid1 driver was missing
>The other commands then bring up the root device,
>but a chroot to /newroot fails. (filesystem completely
>broken)
>
>Is this bug reproducible?
>No.
>
>
>I did the same procedure today for, I think 6 times or so,
>this did all work. (same machine, clean raid,lvm,reiserfs)
>I had this bug some weeks ago on another fileserver, with
>different hardware. I thought, well ok. But now its
>on this hardware the same, so there is really something
>broken.
>
>>Linux Knoppix 2.6.19 #7 SMP PREEMPT Sun Dec 17 22:01:07 CET 2006 i686
>>GNU/Linux
>
>I had on this machine software irq lockups, which were gone
>after a BIOS update and disable hyperthreading and L3 cache.
>So maybe its preempt related too?

Does knoppix use PREEMPT_BKL?

>Even if knoppix should not be used as a rescue/live CD, then
>the reiserfs module should not try to correct something,
>this should be done by another tool.(fsck.reiserfs or a module option...)
>
>Well ok, the obvious workaround is not to use reiserfs
>in a setup md->lvm->reiserfs.

Maybe 4kstacks related (although very unlikely)?

>Does XFS or ext3 has such problems?
>
>(dmesg as attachement)
>
>regards,

	Jan
-- 
