Return-Path: <linux-kernel-owner+w=401wt.eu-S965795AbXDGM24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795AbXDGM24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 08:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965818AbXDGM24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 08:28:56 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:52165 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965795AbXDGM2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 08:28:54 -0400
X-Greylist: delayed 98417 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 08:28:54 EDT
From: syrius.ml@no-log.org
To: linux-kernel@vger.kernel.org
Subject: [dm-devel] bio too big device md1 (16 > 8)
Date: Sat, 07 Apr 2007 14:28:53 +0200
Message-ID: <87irc84bcq.87hcrs4bcq@87fy7c4bcq.message.id>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

i'm using 2.6.21-rc5-git9 +
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-merge-max_hw_sector.patch 
( i've been testing with and without it, and first encountered it on
2.6.18-debian )

I've setup a raid1 array md1 (it was created in a degraded mode using
the debian installer)
(md0 is also a small raid1 array created in degraded mode, but i did
not have any issue with it)

md1 hold a lvm physical volume holding a vg and several lvs

mdadm -D /dev/md1:
/dev/md1:
        Version : 00.90.03
  Creation Time : Sun Mar 25 16:34:42 2007
     Raid Level : raid1
     Array Size : 290607744 (277.15 GiB 297.58 GB)
    Device Size : 290607744 (277.15 GiB 297.58 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Apr  3 01:37:23 2007
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : af8d2807:e573935d:04be1e12:bc7defbb
         Events : 0.422096

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       0        0        1      removed


the problem i'm encountering is when i add /dev/md2 to /dev/md1.

mdadm -D /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Sun Apr  1 15:06:43 2007
     Raid Level : linear
     Array Size : 290607808 (277.15 GiB 297.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sun Apr  1 15:06:43 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 64K

           UUID : 887ecdeb:5f205eb6:4cd470d6:4cbda83c (local to host odo)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0      34        4        0      active sync   /dev/hdg4
       1      57        2        1      active sync   /dev/hdk2
       2      91        3        2      active sync   /dev/hds3
       3      89        2        3      active sync   /dev/hdo2

I use mdadm --manage --add /dev/md1 /dev/md2
when I do so here is what happen:
md: bind<md2>
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:hda3
 disk 1, wo:1, o:1, dev:md2
md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) 
for reconstruction.
md: using 128k window, over a total of 290607744 blocks.
bio too big device md1 (16 > 8)
Device dm-7, XFS metadata write error block 0x243ec0 in dm-7
bio too big device md1 (16 > 8)
I/O error in filesystem ("dm-8") meta-data dev dm-8 block 0x1b5b6550       ("xfs_trans_read_buf") error 5 buf count 8192
bio too big device md1 (16 > 8)
I/O error in filesystem ("dm-8") meta-data dev dm-8 block 0x1fb3b00       ("xfs_trans_read_buf") error 5 buf count 8192

every filesystems on md1 get corrupted.
I manually fail md2 then reboot and so i can boot the fs again.
(but md1 is still degraded)

Any idea ?
I can provide more information if needed. (the only weird thing is
/dev/hdo that doesn't seem to be lba48-ready, but i guess that
shouldn't be a geometry issue.)

-- 
