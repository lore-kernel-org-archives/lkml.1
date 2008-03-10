Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYCJPBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYCJPBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYCJPBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:01:25 -0400
Received: from testure.choralone.org ([194.9.77.134]:58635 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYCJPBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:01:24 -0400
Date: Mon, 10 Mar 2008 11:01:16 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 25rc4-git3 blockdev/loopback related lockdep trace.
Message-ID: <20080310150116.GA30584@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.25-0.101.rc4.git3.fc9 #1
-------------------------------------------------------
mount/1208 is trying to acquire lock:
 (&bdev->bd_mutex){--..}, at: [<c04a9119>] __blkdev_put+0x24/0x12f

but task is already holding lock:
 (&lo->lo_ctl_mutex){--..}, at: [<e005c087>] lo_ioctl+0x3d/0xa01 [loop]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&lo->lo_ctl_mutex){--..}:
       [<c04457fc>] __lock_acquire+0xa99/0xc11
       [<c04459de>] lock_acquire+0x6a/0x90
       [<c06378d1>] mutex_lock_nested+0xdb/0x271
       [<e005b1e1>] lo_open+0x23/0x33 [loop]
       [<c04a94ff>] do_open+0x97/0x281
       [<c04a9711>] blkdev_open+0x28/0x51
       [<c0486c24>] __dentry_open+0xcf/0x185
       [<c0486d4b>] nameidata_to_filp+0x1f/0x33
       [<c0486d8d>] do_filp_open+0x2e/0x35
       [<c0486dd4>] do_sys_open+0x40/0xb5
       [<c0486e75>] sys_open+0x16/0x18
       [<c0405d16>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #0 (&bdev->bd_mutex){--..}:
       [<c044571b>] __lock_acquire+0x9b8/0xc11
       [<c04459de>] lock_acquire+0x6a/0x90
       [<c06378d1>] mutex_lock_nested+0xdb/0x271
       [<c04a9119>] __blkdev_put+0x24/0x12f
       [<c04a922e>] blkdev_put+0xa/0xc
       [<c04a9258>] blkdev_close+0x28/0x2b
       [<c048926c>] __fput+0xb3/0x157
       [<c0489327>] fput+0x17/0x19
       [<e005bbde>] loop_clr_fd+0x159/0x16d [loop]
       [<e005c68a>] lo_ioctl+0x640/0xa01 [loop]
       [<c04f0afd>] blkdev_driver_ioctl+0x49/0x5b
       [<c04f12bb>] blkdev_ioctl+0x7ac/0x7c9
       [<c04a8cb4>] block_ioctl+0x16/0x1b
       [<c04929a6>] vfs_ioctl+0x22/0x69
       [<c0492c26>] do_vfs_ioctl+0x239/0x24c
       [<c0492c79>] sys_ioctl+0x40/0x5b
       [<c0405d16>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by mount/1208:
 #0:  (&lo->lo_ctl_mutex){--..}, at: [<e005c087>] lo_ioctl+0x3d/0xa01 [loop]

stack backtrace:
Pid: 1208, comm: mount Not tainted 2.6.25-0.101.rc4.git3.fc9 #1
 [<c0444b4d>] print_circular_bug_tail+0x5b/0x66
 [<c0444a70>] ? print_circular_bug_header+0xa6/0xb1
 [<c044571b>] __lock_acquire+0x9b8/0xc11
 [<c0442f2e>] ? find_usage_backwards+0x92/0xb1
 [<c04459de>] lock_acquire+0x6a/0x90
 [<c04a9119>] ? __blkdev_put+0x24/0x12f
 [<c06378d1>] mutex_lock_nested+0xdb/0x271
 [<c04a9119>] ? __blkdev_put+0x24/0x12f
 [<c04a9119>] ? __blkdev_put+0x24/0x12f
 [<c04a9119>] __blkdev_put+0x24/0x12f
 [<c04a922e>] blkdev_put+0xa/0xc
 [<c04a9258>] blkdev_close+0x28/0x2b
 [<c048926c>] __fput+0xb3/0x157
 [<c0489327>] fput+0x17/0x19
 [<e005bbde>] loop_clr_fd+0x159/0x16d [loop]
 [<e005c68a>] lo_ioctl+0x640/0xa01 [loop]
 [<c040a2f8>] ? native_sched_clock+0xb5/0xd1
 [<c040a02a>] ? sched_clock+0x8/0xb
 [<c0443085>] ? lock_release_holdtime+0x1a/0x115
 [<c04d61f9>] ? avc_has_perm_noaudit+0x3a1/0x3dc
 [<c04d6216>] ? avc_has_perm_noaudit+0x3be/0x3dc
 [<c040a2f8>] ? native_sched_clock+0xb5/0xd1
 [<c040a2f8>] ? native_sched_clock+0xb5/0xd1
 [<c04452bd>] ? __lock_acquire+0x55a/0xc11
 [<c040a2f8>] ? native_sched_clock+0xb5/0xd1
 [<c04452bd>] ? __lock_acquire+0x55a/0xc11
 [<c040a02a>] ? sched_clock+0x8/0xb
 [<c0443085>] ? lock_release_holdtime+0x1a/0x115
 [<c040a2f8>] ? native_sched_clock+0xb5/0xd1
 [<c04452bd>] ? __lock_acquire+0x55a/0xc11
 [<c040a2f8>] ? native_sched_clock+0xb5/0xd1
 [<c040a02a>] ? sched_clock+0x8/0xb
 [<c0443085>] ? lock_release_holdtime+0x1a/0x115
 [<c04d61f9>] ? avc_has_perm_noaudit+0x3a1/0x3dc
 [<c04f0afd>] blkdev_driver_ioctl+0x49/0x5b
 [<c04f12bb>] blkdev_ioctl+0x7ac/0x7c9
 [<c0443085>] ? lock_release_holdtime+0x1a/0x115
 [<c04d80e7>] ? inode_has_perm+0x5b/0x65
 [<c04a9711>] ? blkdev_open+0x28/0x51
 [<c048363e>] ? check_object+0x111/0x184
 [<c04d84c1>] ? file_has_perm+0x7f/0x88
 [<c04a8cb4>] block_ioctl+0x16/0x1b
 [<c04a8c9e>] ? block_ioctl+0x0/0x1b
 [<c04929a6>] vfs_ioctl+0x22/0x69
 [<c0492c26>] do_vfs_ioctl+0x239/0x24c
 [<c04d864d>] ? selinux_file_ioctl+0xa8/0xab
 [<c0492c79>] sys_ioctl+0x40/0x5b
 [<c0405d16>] syscall_call+0x7/0xb

-- 
http://www.codemonkey.org.uk
