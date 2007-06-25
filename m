Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXFYKuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXFYKuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbXFYKuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:50:07 -0400
Received: from saeurebad.de ([85.214.36.134]:47312 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXFYKuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:50:05 -0400
Date: Mon, 25 Jun 2007 12:49:56 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: xfs-masters@oss.sgi.com
Subject: [BUG] Lockdep warning with XFS on 2.6.22-rc6
Message-ID: <20070625104956.GA22130@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	xfs-masters@oss.sgi.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this is what just hit the ring buffer when I was surfing with elinks on a
brand-new -rc6.

	Hannes

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lockdep-report.txt"

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.22-rc6 #14
-------------------------------------------------------
elinks/4461 is trying to acquire lock:
 (&(&ip->i_lock)->mr_lock/1){----}, at: [<c01ef3d0>] xfs_ilock+0x50/0xd0

but task is already holding lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<c01ef3d0>] xfs_ilock+0x50/0xd0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_lock)->mr_lock){----}:
       [<c0137e0d>] __lock_acquire+0xe0d/0xfc0
       [<c013802d>] lock_acquire+0x6d/0x90
       [<c012e4f1>] down_write_nested+0x41/0x60
       [<c01ef412>] xfs_ilock+0x92/0xd0
       [<c01eff98>] xfs_iget_core+0x398/0x5c0
       [<c01f027e>] xfs_iget+0xbe/0x120
       [<c02098bd>] xfs_trans_iget+0xfd/0x160
       [<c01f379c>] xfs_ialloc+0xac/0x500
       [<c020a46c>] xfs_dir_ialloc+0x6c/0x2a0
       [<c02109ae>] xfs_create+0x33e/0x630
       [<c021bf7f>] xfs_vn_mknod+0x19f/0x210
       [<c016fd12>] vfs_mknod+0xa2/0xf0
       [<c03c3dbf>] unix_bind+0x1bf/0x2e0
       [<c0373ba4>] sys_bind+0x54/0x80
       [<c037518d>] sys_socketcall+0x7d/0x260
       [<c01029ce>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #0 (&(&ip->i_lock)->mr_lock/1){----}:
       [<c0137c85>] __lock_acquire+0xc85/0xfc0
       [<c013802d>] lock_acquire+0x6d/0x90
       [<c012e6e1>] down_read_nested+0x41/0x60
       [<c01ef3d0>] xfs_ilock+0x50/0xd0
       [<c020dd45>] xfs_lock_inodes+0x175/0x190
       [<c02054af>] xfs_lock_for_rename+0x22f/0x280
       [<c02055af>] xfs_rename+0xaf/0x8c0
       [<c021bb64>] xfs_vn_rename+0x34/0x80
       [<c0170237>] vfs_rename+0x307/0x370
       [<c0171e3b>] sys_renameat+0x1bb/0x1f0
       [<c0171e98>] sys_rename+0x28/0x30
       [<c01029ce>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by elinks/4461:
 #0:  (&inode->i_mutex/1){--..}, at: [<c016f459>] lock_rename+0xe9/0xf0
 #1:  (&inode->i_mutex){--..}, at: [<c03c8a8c>] mutex_lock+0x1c/0x20
 #2:  (&(&ip->i_lock)->mr_lock){----}, at: [<c01ef3d0>] xfs_ilock+0x50/0xd0

stack backtrace:
 [<c010398a>] show_trace_log_lvl+0x1a/0x30
 [<c01046a2>] show_trace+0x12/0x20
 [<c0104765>] dump_stack+0x15/0x20
 [<c0135d4c>] print_circular_bug_tail+0x6c/0x80
 [<c0137c85>] __lock_acquire+0xc85/0xfc0
 [<c013802d>] lock_acquire+0x6d/0x90
 [<c012e6e1>] down_read_nested+0x41/0x60
 [<c01ef3d0>] xfs_ilock+0x50/0xd0
 [<c020dd45>] xfs_lock_inodes+0x175/0x190
 [<c02054af>] xfs_lock_for_rename+0x22f/0x280
 [<c02055af>] xfs_rename+0xaf/0x8c0
 [<c021bb64>] xfs_vn_rename+0x34/0x80
 [<c0170237>] vfs_rename+0x307/0x370
 [<c0171e3b>] sys_renameat+0x1bb/0x1f0
 [<c0171e98>] sys_rename+0x28/0x30
 [<c01029ce>] sysenter_past_esp+0x5f/0x99
 =======================

--ew6BAiZeqk4r7MaW--
