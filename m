Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0AOMDh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283Ab0AOMDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:03:35 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:50867 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757122Ab0AOMDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:03:34 -0500
Date: Fri, 15 Jan 2010 23:02:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com
Subject: lockdep: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
Message-ID: <20100115120253.GH28498@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just got this on a 2.6.33-rc3 kernel during unmount:

[21819.329256] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[21819.349943] kswapd0/407 [HC0[0]:SC0[0]:HE1:SE1] takes:
[21819.349943]  (iprune_sem){+++++-}, at: [<ffffffff81132a92>] shrink_icache_memory+0x82/0x2b0
[21819.349943] {RECLAIM_FS-ON-W} state was registered at:
[21819.349943]   [<ffffffff810824c3>] mark_held_locks+0x73/0x90
[21819.349943]   [<ffffffff810825a5>] lockdep_trace_alloc+0xc5/0xd0
[21819.349943]   [<ffffffff811145f1>] kmem_cache_alloc+0x41/0x150
[21819.349943]   [<ffffffff813504f9>] kmem_zone_alloc+0x99/0xe0
[21819.349943]   [<ffffffff8135055e>] kmem_zone_zalloc+0x1e/0x50
[21819.349943]   [<ffffffff81346148>] _xfs_trans_alloc+0x38/0x80
[21819.349943]   [<ffffffff8134634f>] xfs_trans_alloc+0x9f/0xb0
[21819.349943]   [<ffffffff8134b3d0>] xfs_free_eofblocks+0x120/0x290
[21819.349943]   [<ffffffff8134f353>] xfs_inactive+0x103/0x560
[21819.349943]   [<ffffffff8135e6bf>] xfs_fs_clear_inode+0xdf/0x120
[21819.349943]   [<ffffffff81132615>] clear_inode+0xb5/0x140
[21819.349943]   [<ffffffff81132918>] dispose_list+0x38/0x130
[21819.349943]   [<ffffffff81132de3>] invalidate_inodes+0x123/0x170
[21819.349943]   [<ffffffff8111db4e>] generic_shutdown_super+0x4e/0x100
[21819.349943]   [<ffffffff8111dc31>] kill_block_super+0x31/0x50
[21819.349943]   [<ffffffff8111e455>] deactivate_super+0x85/0xa0
[21819.349943]   [<ffffffff81136f8a>] mntput_no_expire+0xca/0x110
[21819.349943]   [<ffffffff81137374>] sys_umount+0x64/0x370
[21819.349943]   [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b
[21819.349943] irq event stamp: 4151539
[21819.349943] hardirqs last  enabled at (4151539): [<ffffffff81706e04>] _raw_spin_unlock_irqrestore+0x44/0x70
[21819.349943] hardirqs last disabled at (4151538): [<ffffffff81706505>] _raw_spin_lock_irqsave+0x25/0x90
[21819.349943] softirqs last  enabled at (4151312): [<ffffffff8105373b>] __do_softirq+0x18b/0x1e0
[21819.349943] softirqs last disabled at (4150645): [<ffffffff81003e8c>] call_softirq+0x1c/0x50
[21819.349943]
[21819.349943] other info that might help us debug this:
[21819.349943] 1 lock held by kswapd0/407:
[21819.349943]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810e5c5d>] shrink_slab+0x3d/0x180
[21819.349943]
[21819.349943] stack backtrace:
[21819.349943] Pid: 407, comm: kswapd0 Not tainted 2.6.33-rc3-dgc #35
[21819.349943] Call Trace:
[21819.349943]  [<ffffffff81081353>] print_usage_bug+0x183/0x190
[21819.349943]  [<ffffffff81082372>] mark_lock+0x342/0x420
[21819.349943]  [<ffffffff810814c0>] ? check_usage_forwards+0x0/0x100
[21819.349943]  [<ffffffff81083531>] __lock_acquire+0x4d1/0x17a0
[21819.349943]  [<ffffffff8108327f>] ? __lock_acquire+0x21f/0x17a0
[21819.349943]  [<ffffffff810848ce>] lock_acquire+0xce/0x100
[21819.349943]  [<ffffffff81132a92>] ? shrink_icache_memory+0x82/0x2b0
[21819.349943]  [<ffffffff81705592>] down_read+0x52/0x90
[21819.349943]  [<ffffffff81132a92>] ? shrink_icache_memory+0x82/0x2b0
[21819.349943]  [<ffffffff81132a92>] shrink_icache_memory+0x82/0x2b0
[21819.349943]  [<ffffffff810e5d4a>] shrink_slab+0x12a/0x180
[21819.349943]  [<ffffffff810e66d6>] kswapd+0x586/0x990
[21819.349943]  [<ffffffff810e35c0>] ? isolate_pages_global+0x0/0x240
[21819.349943]  [<ffffffff8106c7c0>] ? autoremove_wake_function+0x0/0x40
[21819.349943]  [<ffffffff810e6150>] ? kswapd+0x0/0x990
[21819.349943]  [<ffffffff8106c276>] kthread+0x96/0xa0
[21819.349943]  [<ffffffff81003d94>] kernel_thread_helper+0x4/0x10
[21819.349943]  [<ffffffff8170717c>] ? restore_args+0x0/0x30
[21819.349943]  [<ffffffff8106c1e0>] ? kthread+0x0/0xa0
[21819.349943]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10

I can't work out what the <mumble>RECLAIM_FS<mumble> notations are
supposed to mean from the code and they are not documented at
all, so I need someone to explain what this means before I can
determine if it is a valid warning or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
