Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289Ab0A3T2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0A3T2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078Ab0A3T2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:28:41 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:55447 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab0A3T2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:28:40 -0500
Message-ID: <4B648866.9050407@simon.arlott.org.uk>
Date: Sat, 30 Jan 2010 19:28:38 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lockdep warning: tty_write_message (tty->atomic_write_lock) / __dquot_alloc_space
 (s->s_dquot.dqptr_sem)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hard block quota limit was exceeded at the time.
According to sshd logs I had just logged out when this happened:

30 15:19:49 [ 9670.879506] =======================================================
30 15:19:49 [ 9670.880008] [ INFO: possible circular locking dependency detected ]
30 15:19:49 [ 9670.880008] 2.6.33-rc6-git #22831-gc862701
30 15:19:49 [ 9670.880008] -------------------------------------------------------
30 15:19:49 [ 9670.880008] bash/29957 is trying to acquire lock:
30 15:19:49 [ 9670.880008]  (&tty->atomic_write_lock){+.+.+.}, at: [<c036accf>] tty_write_message+0x1b/0x8c
30 15:19:49 [ 9670.880008] 
30 15:19:49 [ 9670.880008] but task is already holding lock:
30 15:19:49 [ 9670.880008]  (&s->s_dquot.dqptr_sem){++++-.}, at: [<c02be263>] __dquot_alloc_space+0x38/0x194
30 15:19:49 [ 9670.880008] 
30 15:19:49 [ 9670.880008] which lock already depends on the new lock.
30 15:19:49 [ 9670.880008] 
30 15:19:49 [ 9670.939134] 
30 15:19:49 [ 9670.939134] the existing dependency chain (in reverse order) is:
30 15:19:49 [ 9670.939134] 
30 15:19:49 [ 9670.939134] -> #3 (&s->s_dquot.dqptr_sem){++++-.}:
30 15:19:49 [ 9670.939134]        [<c024fab0>] __lock_acquire+0x1099/0x139a
30 15:19:49 [ 9670.939134]        [<c024fdf7>] lock_acquire+0x46/0x5d
30 15:19:49 [ 9670.939134]        [<c050736d>] down_write+0x2c/0x48
30 15:19:49 [ 9670.970138]        [<c02bf959>] dquot_initialize+0x75/0xf3
30 15:19:49 [ 9670.979269]        [<c02d179f>] ext3_new_inode+0x7fd/0x940
30 15:19:49 [ 9670.982079]        [<c02d789f>] ext3_create+0x85/0xeb
30 15:19:49 [ 9670.990593]        [<c0293921>] vfs_create+0xbf/0x103
30 15:19:49 [ 9670.996281]        [<c0295547>] do_filp_open+0x296/0x84f
30 15:19:49 [ 9671.000364]        [<c0289e5d>] do_sys_open+0x4a/0xe7
30 15:19:49 [ 9671.007049]        [<c0289f3c>] sys_open+0x1e/0x26
30 15:19:49 [ 9671.010435]        [<c0202810>] sysenter_do_call+0x12/0x36
30 15:19:49 [ 9671.016425] 
30 15:19:49 [ 9671.016425] -> #2 (jbd_handle){+.+.-.}:
30 15:19:49 [ 9671.020508]        [<c024fab0>] __lock_acquire+0x1099/0x139a
30 15:19:49 [ 9671.029542]        [<c024fdf7>] lock_acquire+0x46/0x5d
30 15:19:49 [ 9671.033066]        [<c02eab04>] start_this_handle+0x30e/0x330
30 15:19:49 [ 9671.040671]        [<c02eac90>] journal_start+0xa1/0xcd
30 15:19:49 [ 9671.046644]        [<c02dbfe0>] ext3_journal_start_sb+0x40/0x42
30 15:19:49 [ 9671.051792]        [<c02d260f>] ext3_dirty_inode+0x24/0x67
30 15:19:49 [ 9671.056714]        [<c02a32e0>] __mark_inode_dirty+0x23/0x115
30 15:19:49 [ 9671.060794]        [<c029b4f8>] file_update_time+0xd2/0xef
30 15:19:49 [ 9671.070868]        [<c02756b3>] do_wp_page+0x775/0x7a5
30 15:19:49 [ 9671.072144]        [<c0276e2f>] handle_mm_fault+0x7dc/0x873
30 15:19:49 [ 9671.080997]        [<c021aa9d>] do_page_fault+0x289/0x2a0
30 15:19:49 [ 9671.087059]        [<c0508e8b>] error_code+0x6b/0x70
30 15:19:49 [ 9671.091070] 
30 15:19:49 [ 9671.091070] -> #1 (&mm->mmap_sem){++++++}:
30 15:19:49 [ 9671.097132]        [<c024fab0>] __lock_acquire+0x1099/0x139a
30 15:19:49 [ 9671.101143]        [<c024fdf7>] lock_acquire+0x46/0x5d
30 15:19:49 [ 9671.111213]        [<c0274427>] might_fault+0x6b/0x88
30 15:19:49 [ 9671.116834]        [<c0320374>] _copy_from_user+0x2e/0x108
30 15:19:49 [ 9671.121281]        [<c036aebb>] tty_write+0x140/0x1d1
30 15:19:49 [ 9671.127360]        [<c036afae>] redirected_tty_write+0x62/0x6f
30 15:19:49 [ 9671.132971]        [<c028bcdb>] vfs_write+0x8a/0x113
30 15:19:49 [ 9671.138966]        [<c028bdfd>] sys_write+0x3b/0x60
30 15:19:49 [ 9671.144516]        [<c0202810>] sysenter_do_call+0x12/0x36
30 15:19:49 [ 9671.150541] 
30 15:19:49 [ 9671.150541] -> #0 (&tty->atomic_write_lock){+.+.+.}:
30 15:19:49 [ 9671.156957]        [<c024f83b>] __lock_acquire+0xe24/0x139a
30 15:19:49 [ 9671.162955]        [<c024fdf7>] lock_acquire+0x46/0x5d
30 15:19:49 [ 9671.168955]        [<c0506edb>] mutex_lock_nested+0x47/0x2b2
30 15:19:49 [ 9671.174950]        [<c036accf>] tty_write_message+0x1b/0x8c
30 15:19:49 [ 9671.180950]        [<c02bd973>] flush_warnings+0xf9/0x1af
30 15:19:49 [ 9671.186512]        [<c02be3a5>] __dquot_alloc_space+0x17a/0x194
30 15:19:49 [ 9671.192944]        [<c02be3db>] dquot_alloc_space+0xd/0xf
30 15:19:49 [ 9671.198553]        [<c02cfde8>] ext3_new_blocks+0x9c/0x5a1
30 15:19:49 [ 9671.204503]        [<c02d38e1>] ext3_get_blocks_handle+0x36e/0x7b2
30 15:19:49 [ 9671.210936]        [<c02d3dc0>] ext3_get_block+0x9b/0xd0
30 15:19:49 [ 9671.216495]        [<c02a923c>] __block_prepare_write+0x147/0x310
30 15:19:49 [ 9671.222931]        [<c02a958a>] block_write_begin+0x75/0xcc
30 15:19:49 [ 9671.228283]        [<c02d50ac>] ext3_write_begin+0xcd/0x1ba
30 15:19:49 [ 9671.232124]        [<c0264474>] generic_file_buffered_write+0xb8/0x1cc
30 15:19:49 [ 9671.241879]        [<c0265ec4>] __generic_file_aio_write+0x3c4/0x3fc
30 15:19:49 [ 9671.248425]        [<c0265f56>] generic_file_aio_write+0x5a/0x9b
30 15:19:49 [ 9671.252277]        [<c028b4a9>] do_sync_write+0x89/0xc7
30 15:19:49 [ 9671.258494]        [<c028bcdb>] vfs_write+0x8a/0x113
30 15:19:49 [ 9671.262348]        [<c028bdfd>] sys_write+0x3b/0x60
30 15:19:49 [ 9671.270834]        [<c0202810>] sysenter_do_call+0x12/0x36
30 15:19:49 [ 9671.274853] 
30 15:19:49 [ 9671.274853] other info that might help us debug this:
30 15:19:49 [ 9671.274853] 
30 15:19:49 [ 9671.284908] 4 locks held by bash/29957:
30 15:19:49 [ 9671.290030]  #0:  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c0265f46>] generic_file_aio_write+0x4a/0x9b
30 15:19:49 [ 9671.298792]  #1:  (jbd_handle){+.+.-.}, at: [<c02eaac7>] start_this_handle+0x2d1/0x330
30 15:19:49 [ 9671.306457]  #2:  (&ei->truncate_mutex){+.+...}, at: [<c02d36c7>] ext3_get_blocks_handle+0x154/0x7b2
30 15:19:49 [ 9671.318454]  #3:  (&s->s_dquot.dqptr_sem){++++-.}, at: [<c02be263>] __dquot_alloc_space+0x38/0x194
30 15:19:49 [ 9671.327887] 
30 15:19:49 [ 9671.327887] stack backtrace:
30 15:19:49 [ 9671.332879] Pid: 29957, comm: bash Not tainted 2.6.33-rc6-git #22831-gc862701
30 15:19:49 [ 9671.340336] Call Trace:
30 15:19:49 [ 9671.342953]  [<c050534e>] ? printk+0xf/0x11
30 15:19:49 [ 9671.346664]  [<c024e5d0>] print_circular_bug+0x90/0x9c
30 15:19:49 [ 9671.351878]  [<c024f83b>] __lock_acquire+0xe24/0x139a
30 15:19:49 [ 9671.357892]  [<c024d1ef>] ? add_lock_to_list+0x63/0x95
30 15:19:49 [ 9671.363441]  [<c024fdf7>] lock_acquire+0x46/0x5d
30 15:19:49 [ 9671.367929]  [<c036accf>] ? tty_write_message+0x1b/0x8c
30 15:19:49 [ 9671.373166]  [<c036accf>] ? tty_write_message+0x1b/0x8c
30 15:19:49 [ 9671.379353]  [<c0506edb>] mutex_lock_nested+0x47/0x2b2
30 15:19:49 [ 9671.384862]  [<c036accf>] ? tty_write_message+0x1b/0x8c
30 15:19:49 [ 9671.390862]  [<c05084c4>] ? _raw_spin_unlock_irqrestore+0x36/0x58
30 15:19:49 [ 9671.396860]  [<c024e025>] ? trace_hardirqs_on_caller+0xff/0x120
30 15:19:49 [ 9671.403353]  [<c024e051>] ? trace_hardirqs_on+0xb/0xd
30 15:19:49 [ 9671.408855]  [<c036accf>] tty_write_message+0x1b/0x8c
30 15:19:49 [ 9671.413981]  [<c02bd973>] flush_warnings+0xf9/0x1af
30 15:19:49 [ 9671.417851]  [<c02be3a5>] __dquot_alloc_space+0x17a/0x194
30 15:19:49 [ 9671.423496]  [<c02be3db>] dquot_alloc_space+0xd/0xf
30 15:19:49 [ 9671.429848]  [<c02cfde8>] ext3_new_blocks+0x9c/0x5a1
30 15:19:49 [ 9671.435411]  [<c0507106>] ? mutex_lock_nested+0x272/0x2b2
30 15:19:49 [ 9671.441407]  [<c050712c>] ? mutex_lock_nested+0x298/0x2b2
30 15:19:49 [ 9671.444841]  [<c02d38e1>] ext3_get_blocks_handle+0x36e/0x7b2
30 15:19:49 [ 9671.450838]  [<c024ddf2>] ? mark_held_locks+0x43/0x5b
30 15:19:49 [ 9671.456834]  [<c0287e76>] ? kmem_cache_alloc+0x89/0xb0
30 15:19:49 [ 9671.463785]  [<c024e025>] ? trace_hardirqs_on_caller+0xff/0x120
30 15:19:49 [ 9671.470000]  [<c02d3dc0>] ext3_get_block+0x9b/0xd0
30 15:19:49 [ 9671.474829]  [<c02a923c>] __block_prepare_write+0x147/0x310
30 15:19:49 [ 9671.480825]  [<c02a958a>] block_write_begin+0x75/0xcc
30 15:19:49 [ 9671.485952]  [<c02d3d25>] ? ext3_get_block+0x0/0xd0
30 15:19:49 [ 9671.490142]  [<c02d50ac>] ext3_write_begin+0xcd/0x1ba
30 15:19:49 [ 9671.495820]  [<c02d3d25>] ? ext3_get_block+0x0/0xd0
30 15:19:49 [ 9671.501817]  [<c0264474>] generic_file_buffered_write+0xb8/0x1cc
30 15:19:49 [ 9671.507814]  [<c02327f7>] ? current_fs_time+0x16/0x19
30 15:19:49 [ 9671.514145]  [<c0265ec4>] __generic_file_aio_write+0x3c4/0x3fc
30 15:19:49 [ 9671.520353]  [<c0507106>] ? mutex_lock_nested+0x272/0x2b2
30 15:19:49 [ 9671.525807]  [<c0265f56>] generic_file_aio_write+0x5a/0x9b
30 15:19:49 [ 9671.531912]  [<c028b4a9>] do_sync_write+0x89/0xc7
30 15:19:49 [ 9671.534817]  [<c027440a>] ? might_fault+0x4e/0x88
30 15:19:49 [ 9671.540506]  [<c0287313>] ? kmem_cache_free+0xf6/0x102
30 15:19:49 [ 9671.546798]  [<c024e051>] ? trace_hardirqs_on+0xb/0xd
30 15:19:49 [ 9671.552360]  [<c02f83ba>] ? security_file_permission+0xf/0x11
30 15:19:49 [ 9671.558794]  [<c028b420>] ? do_sync_write+0x0/0xc7
30 15:19:49 [ 9671.561793]  [<c028bcdb>] vfs_write+0x8a/0x113
30 15:19:49 [ 9671.567790]  [<c028bdfd>] sys_write+0x3b/0x60
30 15:19:49 [ 9671.573356]  [<c0202810>] sysenter_do_call+0x12/0x36

-- 
Simon Arlott
