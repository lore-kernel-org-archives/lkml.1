Return-Path: <linux-kernel-owner+w=401wt.eu-S1759183AbYJILZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbYJILZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYJILZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:25:19 -0400
Received: from moloch.purdy.org ([192.207.141.11]:1472 "EHLO
	moloch.hellmouth.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbYJILZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:25:17 -0400
X-Greylist: delayed 2942 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2008 07:25:16 EDT
Date: Thu, 9 Oct 2008 11:36:10 +0100
From: Sean Purdy <sean-kernel@purdy.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: XFS internal error xfs_trans_cancel in 2.6.27
Message-ID: <20081009113610.F13062@moloch.hellmouth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
X-Comments: Public PGP key available on request
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Further to the discussion (and patching) of an xfs_trans_cancel
issue in June, in kernel < 2.6.26

A similar issue came up on one disk of a 4 x 750GiB machine
with a 2.6.24 kernel.  So I installed 2.6.27-6 and gave it another try.
But I'm still seeing the same problem.  Remounting the drive each time
is fine, and xfs_check shows no errors.

The issue is reproducible, within a few minutes of marking the device
writable in our distributed file system (MogileFS).

There were no memory use issues and a memcheck test passed.

The disk in question is at 94% and has previously been at a
similar utilisation before going down to around 60% and back up.
File sizes stored are anything between 1KB to 1GB

So it could be a fragmentation issue.  But then the other three disks
on that machine have had a similar history.

Frustratingly, I then mounted the disk readwrite elsewhere on
the same machine, and copied a range of files to it from 7672 bytes
to 800Mb and those copied fine.  Then I reintroduced the disk into the
MogileFS system and the issue recurred within a few minutes.
We're using lighttpd to read and write the files for the mogile system.

Output from df and dmesg below.


Disk is /dev/sdd1
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda10           611077760 579544432  31533328  95% /var/mogdata/dev182
/dev/sdb10           611077760 583449400  27628360  96% /var/mogdata/dev183
/dev/sdc1            732272128 686380752  45891376  94% /var/mogdata/dev184
/dev/sdd1            732272128 684888328  47383800  94% /var/mogdata/dev185

Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sda10           126217920   76222 126141698    1% /var/mogdata/dev182
/dev/sdb10           110599968   78265 110521703    1% /var/mogdata/dev183
/dev/sdc1            183656960   82848 183574112    1% /var/mogdata/dev184
/dev/sdd1            189625760   72442 189553318    1% /var/mogdata/dev185


             total       used       free     shared    buffers     cached
Mem:       2071708    1240212     831496          0         40    1097796
-/+ buffers/cache:     142376    1929332
Swap:      1951800         56    1951744


[142880.364261] Filesystem "sdd1": XFS internal error xfs_trans_cancel at line 1164 of file /build/buildd/linux-2.6.27/fs/xfs/xfs_trans.c.  Caller 0xf8b0bd50
[142880.364305] Pid: 17672, comm: lighttpd Not tainted 2.6.27-6-server #1
[142880.364325]  [<f8ae4b03>] xfs_error_report+0x53/0x60 [xfs]
[142880.364369]  [<f8b0bd50>] ? xfs_mkdir+0x2d0/0x470 [xfs]
[142880.364395]  [<f8b05472>] xfs_trans_cancel+0xd2/0xf0 [xfs]
[142880.364423]  [<f8b0bd50>] ? xfs_mkdir+0x2d0/0x470 [xfs]
[142880.364447]  [<f8b0bd50>] xfs_mkdir+0x2d0/0x470 [xfs]
[142880.364483]  [<f8b173f7>] xfs_vn_mknod+0x1e7/0x290 [xfs]
[142880.364506]  [<f8b174ba>] xfs_vn_mkdir+0x1a/0x20 [xfs]
[142880.364520]  [<c01c5a16>] vfs_mkdir+0xa6/0x100
[142880.364526]  [<c038d88d>] ? _spin_lock+0xd/0x10
[142880.364532]  [<c01c790e>] sys_mkdirat+0xce/0xe0
[142880.364535]  [<c01bc04b>] ? fsnotify_access+0x6b/0x80
[142880.364540]  [<c01bcceb>] ? vfs_read+0xab/0x110
[142880.364543]  [<c01c7945>] sys_mkdir+0x25/0x30
[142880.364545]  [<c0109f03>] sysenter_do_call+0x12/0x2f
[142880.364552]  =======================
[142880.364556] xfs_force_shutdown(sdd1,0x8) called from line 1165 of file /build/buildd/linux-2.6.27/fs/xfs/xfs_trans.c.  Return address = 0xf8b0548a
[142880.364566] Filesystem "sdd1": Corruption of in-memory data detected.  Shutting down filesystem: sdd1
[142880.364589] Please umount the filesystem, and rectify the problem(s)
[142907.600040] Filesystem "sdd1": xfs_log_force: error 5 returned.


Thanks,

Sean
