Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZGNOVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZGNOVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZGNOVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:21:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZGNOVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:21:47 -0400
Subject: xfs mr_lock vs mmap_sem lock inversion?
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Jul 2009 16:15:55 +0200
Message-Id: <1247580955.7500.97.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I seem to be getting lots (as in one every boot) of these:

[   84.692079] =======================================================
[   84.692082] [ INFO: possible circular locking dependency detected ]
[   84.692084] 2.6.31-rc2-tip #179
[   84.692086] -------------------------------------------------------
[   84.692088] plasma/7446 is trying to acquire lock:
[   84.692090]  (&mm->mmap_sem){++++++}, at: [<ffffffff812d70d0>] do_page_fault+0x179/0x2a1
[   84.692098]
[   84.692098] but task is already holding lock:
[   84.692100]  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffffa022ae30>] xfs_ilock+0x49/0x7e [xfs]
[   84.692126]
[   84.692127] which lock already depends on the new lock.
[   84.692127]
[   84.692129]
[   84.692129] the existing dependency chain (in reverse order) is:
[   84.692131]
[   84.692131] -> #1 (&(&ip->i_iolock)->mr_lock){++++++}:
[   84.692135]        [<ffffffff8106bd61>] __lock_acquire+0xa62/0xbea
[   84.692140]        [<ffffffff8106bfe5>] lock_acquire+0xfc/0x128
[   84.692143]        [<ffffffff8105e3e7>] down_write_nested+0x2f/0x3b
[   84.692147]        [<ffffffffa022ae13>] xfs_ilock+0x2c/0x7e [xfs]
[   84.692166]        [<ffffffffa0243747>] xfs_free_eofblocks+0x11c/0x20a [xfs]
[   84.692184]        [<ffffffffa0244164>] xfs_release+0x138/0x145 [xfs]
[   84.692203]        [<ffffffffa024a00f>] xfs_file_release+0x15/0x19 [xfs]
[   84.692221]        [<ffffffff810e9e49>] __fput+0xfb/0x1a6
[   84.692225]        [<ffffffff810e9f11>] fput+0x1d/0x1f
[   84.692228]        [<ffffffff810cc45a>] remove_vma+0x3b/0x71
[   84.692232]        [<ffffffff810cd5a7>] do_munmap+0x309/0x32b
[   84.692235]        [<ffffffff810cd60e>] sys_munmap+0x45/0x5e
[   84.692238]        [<ffffffff8102cfcf>] sysenter_dispatch+0x7/0x33
[   84.692242]        [<ffffffffffffffff>] 0xffffffffffffffff
[   84.692260]
[   84.692260] -> #0 (&mm->mmap_sem){++++++}:
[   84.692263]        [<ffffffff8106bc55>] __lock_acquire+0x956/0xbea
[   84.692267]        [<ffffffff8106bfe5>] lock_acquire+0xfc/0x128
[   84.692270]        [<ffffffff812d3232>] down_read+0x34/0x40
[   84.692273]        [<ffffffff812d70d0>] do_page_fault+0x179/0x2a1
[   84.692276]        [<ffffffff812d4bf5>] page_fault+0x25/0x30
[   84.692280]        [<ffffffff810b2389>] generic_file_aio_read+0x364/0x5ba
[   84.692284]        [<ffffffffa024dfb3>] xfs_read+0x18d/0x1fa [xfs]
[   84.692302]        [<ffffffffa024a129>] xfs_file_aio_read+0x64/0x67 [xfs]
[   84.692320]        [<ffffffff810e8ac0>] do_sync_read+0xec/0x132
[   84.692324]        [<ffffffff810e95ba>] vfs_read+0xad/0x107
[   84.692327]        [<ffffffff810e96e2>] sys_read+0x4c/0x75
[   84.692330]        [<ffffffff8102cfcf>] sysenter_dispatch+0x7/0x33
[   84.692333]        [<ffffffffffffffff>] 0xffffffffffffffff
[   84.692337]
[   84.692338] other info that might help us debug this:
[   84.692338]
[   84.692340] 1 lock held by plasma/7446:
[   84.692342]  #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffffa022ae30>] xfs_ilock+0x49/0x7e [xfs]
[   84.692363]
[   84.692364] stack backtrace:
[   84.692366] Pid: 7446, comm: plasma Not tainted 2.6.31-rc2-tip #179
[   84.692368] Call Trace:
[   84.692372]  [<ffffffff8106af89>] print_circular_bug_tail+0x71/0x7c
[   84.692375]  [<ffffffff8106bc55>] __lock_acquire+0x956/0xbea
[   84.692379]  [<ffffffff8106bfe5>] lock_acquire+0xfc/0x128
[   84.692382]  [<ffffffff812d70d0>] ? do_page_fault+0x179/0x2a1
[   84.692385]  [<ffffffff812d3232>] down_read+0x34/0x40
[   84.692388]  [<ffffffff812d70d0>] ? do_page_fault+0x179/0x2a1
[   84.692391]  [<ffffffff812d70d0>] do_page_fault+0x179/0x2a1
[   84.692394]  [<ffffffff812d4bf5>] page_fault+0x25/0x30
[   84.692398]  [<ffffffff810b02e4>] ? file_read_actor+0x3c/0x132
[   84.692401]  [<ffffffff810b0820>] ? __rcu_read_unlock+0x45/0x50
[   84.692404]  [<ffffffff810b2389>] generic_file_aio_read+0x364/0x5ba
[   84.692424]  [<ffffffffa022ae30>] ? xfs_ilock+0x49/0x7e [xfs]
[   84.692442]  [<ffffffffa024dfb3>] xfs_read+0x18d/0x1fa [xfs]
[   84.692461]  [<ffffffffa024a129>] xfs_file_aio_read+0x64/0x67 [xfs]
[   84.692465]  [<ffffffff810e8ac0>] do_sync_read+0xec/0x132
[   84.692468]  [<ffffffff8105ac3b>] ? autoremove_wake_function+0x0/0x3d
[   84.692471]  [<ffffffff810e9ba2>] ? __rcu_read_lock+0x0/0x3f
[   84.692476]  [<ffffffff81155ccc>] ? security_file_permission+0x16/0x18
[   84.692479]  [<ffffffff810e95ba>] vfs_read+0xad/0x107
[   84.692482]  [<ffffffff810e96e2>] sys_read+0x4c/0x75
[   84.692485]  [<ffffffff8102cfcf>] sysenter_dispatch+0x7/0x33
[   84.692489]  [<ffffffff812d3bfc>] ? trace_hardirqs_on_thunk+0x3a/0x3f

