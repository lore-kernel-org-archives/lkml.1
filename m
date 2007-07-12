Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbXGLOKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbXGLOKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761363AbXGLOKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:10:12 -0400
Received: from omr10.networksolutionsemail.com ([205.178.146.60]:38210 "EHLO
	omr10.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761574AbXGLOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:10:10 -0400
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 10:10:10 EDT
From: James <LinuxKernel@jamesplace.net>
Reply-To: LinuxKernel@jamesplace.net
To: linux-kernel@vger.kernel.org
Subject: Problem recovering a failed RIAD5 array with 4-drives.
Date: Thu, 12 Jul 2007 08:49:15 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707120849.16068.LinuxKernel@jamesplace.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies if this is not the correct forum. If there is a better place to 
post this please advise.


Linux localhost.localdomain 2.6.17-1.2187_FC5 #1 Mon Sep 11 01:17:06 EDT 2006 
i686 i686 i386 GNU/Linux

(I was planning to upgrade to FC7 this weekend, but that is currently on hold 
because-)

I've got a problem with a software RIAD5 using mdadm.
Drive sdc failed causing sda to appear failed. Both drives where marked 
as 'spare'.

What follows is a record of the steps I've taken and the results. I'm looking 
for some direction/advice to get the data back. 


I've tried a few cautions things to bring the array back up with the three 
good drives with no luck. 

The last thing attempted had some limited success. I was able to get all 
drives powered up. I checked the Event count on the three good drives and 
they were all equal. So I assumed it would be safe to do the following. I 
hope I was not wrong. I issued the following commands to try to bring the 
array into a usable state.




[]# 
mdadm --create --verbose /dev/md0 --assume-clean --level=raid5 --raid-devices=4 --spare-devices=0  /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

[]# /sbin/mdadm --misc --test --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Jul 11 08:03:20 2007
     Raid Level : raid5
     Array Size : 1465175808 (1397.30 GiB 1500.34 GB)
    Device Size : 488391936 (465.77 GiB 500.11 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jul 11 08:03:47 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : e46beb22:37d329db:dd16ea76:29c07a23
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8        1        2      active sync   /dev/sda1
       3       8       49        3      active sync   /dev/sdd1
[]# mdadm --fail /dev/md0 /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0

[]# /sbin/mdadm --misc --test --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Jul 11 08:03:20 2007
     Raid Level : raid5
     Array Size : 1465175808 (1397.30 GiB 1500.34 GB)
    Device Size : 488391936 (465.77 GiB 500.11 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jul 11 14:37:56 2007
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : e46beb22:37d329db:dd16ea76:29c07a23
         Events : 0.3

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
      10       0        0        0      removed
       2       8        1        2      active sync   /dev/sda1
       3       8       49        3      active sync   /dev/sdd1

       4       8       33        -      faulty spare   /dev/sdc1



[]# mount /dev/md0 /opt
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

In /var/log/messages
Jul 11 14:32:44 localhost kernel: EXT3-fs: md0: couldn't mount because of 
unsupported optional features (4000000).

[]# /sbin/fsck /dev/md0
fsck 1.38 (30-Jun-2005)
e2fsck 1.38 (30-Jun-2005)
fsck.ext3: Filesystem revision too high while trying to open /dev/md0
The filesystem revision is apparently too high for this version of e2fsck.
(Or the filesystem superblock is corrupt)


The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

[]# mke2fs -n /dev/md0
mke2fs 1.38 (30-Jun-2005)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
183156736 inodes, 366293952 blocks
18314697 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=369098752
11179 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848


I tried the following for all Superblock backups with the same result.

[]# e2fsck -b 214990848 /dev/md0
e2fsck 1.38 (30-Jun-2005)
/sbin/e2fsck: Invalid argument while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>


Any advice/direction would be appreciated. 
Thanks much.
