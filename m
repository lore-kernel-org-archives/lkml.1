Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYJPVZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYJPVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYJPVZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:25:13 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3960 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbYJPVZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:25:12 -0400
Date: Thu, 16 Oct 2008 23:25:01 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081016212500.GA27228@deprecation.cyrius.com>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E4213E.9090508@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

I tried to reproduce this problem on my ARM machine and it's really
easy to trigger.  See the transcript below.

I tried with 2.6.26.6 (without the ARM old ABI fix) and 2.6.27 (with
the fix), and with xfsprogs 2.9.8-1.

Note that I'm actually using the ARM EABI, and not the old ABI.
I'm not sure what Tobias used.

xfs.ko compiled with -g can be found at http://www.cyrius.com/tmp/xfs.ko.bz2
(3.1 MB)

Here's the transcript.  It's really easy to trigger.  Just copy some
files to the XFS partition (works) and then run 'ls' (oops):

debian:~# modprobe xfs
debian:~# mkfs.xfs -f /dev/sda6
meta-data=/dev/sda6              isize=256    agcount=4, agsize=17778431 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=71113722, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
debian:~# dmesg | tail -n 2
[42949548.970000] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
[42949548.980000] SGI XFS Quota Management subsystem
debian:~# mount /dev/sda6 /mnt
debian:~# dmesg | tail -n 2
[42949596.470000] XFS mounting filesystem sda6
[42949596.610000] Ending clean XFS mount for filesystem: sda6
debian:~# cp /usr/bin/* /mnt/
debian:~# dmesg | tail -n 2
[42949596.470000] XFS mounting filesystem sda6
[42949596.610000] Ending clean XFS mount for filesystem: sda6
debian:~# ls /mnt
ls: reading directory /mnt: Structure needs cleaning
debian:~# dmesg | tail -n 16
[42949596.610000] Ending clean XFS mount for filesystem: sda6
[42949619.790000] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 04 3d 1b fa  XFSB.........=..
[42949619.800000] Filesystem "sda6": XFS internal error xfs_da_do_buf(2) at line 2107 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf148b44
[42949619.820000] [<c002a370>] (dump_stack+0x0/0x14) from [<bf154968>] (xfs_error_report+0x4c/0x5c [xfs])
[42949619.820000] [<bf15491c>] (xfs_error_report+0x0/0x5c [xfs]) from [<bf1549d4>] (xfs_corruption_error+0x5c/0x68 [xfs])
[42949619.830000]  r4:c7914400
[42949619.840000] [<bf154978>] (xfs_corruption_error+0x0/0x68 [xfs]) from [<bf1489b8>] (xfs_da_do_buf+0x554/0x654 [xfs])
[42949619.850000]  r6:bf148b44 r5:00000000 r4:c7073418
[42949619.850000] [<bf148464>] (xfs_da_do_buf+0x0/0x654 [xfs]) from [<bf148b44>] (xfs_da_read_buf+0x34/0x3c [xfs])
[42949619.860000] [<bf148b10>] (xfs_da_read_buf+0x0/0x3c [xfs]) from [<bf14edec>] (xfs_dir2_leaf_getdents+0x480/0x8b4 [xfs])
[42949619.880000] [<bf14e96c>] (xfs_dir2_leaf_getdents+0x0/0x8b4 [xfs]) from [<bf14b07c>] (xfs_readdir+0xcc/0xe0 [xfs])
[42949619.890000] [<bf14afb0>] (xfs_readdir+0x0/0xe0 [xfs]) from [<bf18140c>] (xfs_file_readdir+0x144/0x194 [xfs])
[42949619.900000] [<bf1812c8>] (xfs_file_readdir+0x0/0x194 [xfs]) from [<c009ffb0>] (vfs_readdir+0x84/0xb8)
[42949619.910000] [<c009ff2c>] (vfs_readdir+0x0/0xb8) from [<c00a0050>] (sys_getdents64+0x6c/0xc0)
[42949619.920000] [<c009ffe4>] (sys_getdents64+0x0/0xc0) from [<c0025bc0>] (ret_fast_syscall+0x0/0x3c)
[42949619.930000]  r7:000000d9 r6:0002a01c r5:0002a030 r4:00000000
debian:~#

-- 
Martin Michlmayr
http://www.cyrius.com/
