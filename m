Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbYEPRL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbYEPRL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYEPRLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:11:46 -0400
Received: from mx1.ukfsn.org ([77.75.108.10]:54246 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751934AbYEPRLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:11:45 -0400
Message-ID: <482DC043.5000307@dgreaves.com>
Date: Fri, 16 May 2008 18:11:31 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Regression- XFS won't mount on partitioned md array
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just attempted a kernel upgrade from 2.6.20.7 to 2.6.25.3 and it no longer
mounts my xfs filesystem.

I bisected it to around
a67d7c5f5d25d0b13a4dfb182697135b014fa478
[XFS] Move platform specific mount option parse out of core XFS code

I have a RAID5 array with partitions:

Partition Table for /dev/md_d0

               First       Last
 # Type       Sector      Sector   Offset    Length   Filesystem Type (ID) Flag
-- ------- ----------- ----------- ------ ----------- -------------------- ----
 1 Primary           0  2500288279      4  2500288280 Linux (83)           None
 2 Primary  2500288280  2500483583      0      195304 Non-FS data (DA)     None


when I attempt to mount /media:
/dev/md_d0p1 /media xfs rw,nobarrier,noatime,logdev=/dev/md_d0p2,allocsize=512m 0 0

I get:
 md_d0: p1 p2
XFS mounting filesystem md_d0p1
attempt to access beyond end of device
md_d0p2: rw=0, want=195311, limit=195304
I/O error in filesystem ("md_d0p1") meta-data dev md_d0p2 block 0x2fae7
("xlog_bread") error 5 buf count 512
XFS: empty log check failed
XFS: log mount/recovery failed: error 5
XFS: log mount failed

A repair:
  xfs_repair /dev/md_d0p1 -l /dev/md_d0p2
gives no errors.

Phase 1 - find and verify superblock...
Phase 2 - using external log on /dev/md_d0p2
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
...


David

