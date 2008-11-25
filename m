Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYKYLoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYKYLoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYKYLoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:44:01 -0500
Received: from colobus.isomerica.net ([216.93.242.10]:46890 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKYLn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:43:59 -0500
Date: Tue, 25 Nov 2008 06:43:57 -0500
From: Dan =?UTF-8?B?Tm/DqQ==?= <dpn@isomerica.net>
To: linux-kernel@vger.kernel.org
Subject: Lockdep warning for iprune_mutex at shrink_icache_memory
Message-ID: <20081125064357.5a4f1420@tuna>
Organization: isomerica.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have experienced the following lockdep warning on 2.6.28-rc6.  I
would be happy to help debug, but I don't know this section of code at
all.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.28-rc6git #1
-------------------------------------------------------
rsync/21485 is trying to acquire lock:
 (iprune_mutex){--..}, at: [<ffffffff80310b14>]
shrink_icache_memory+0x84/0x290

but task is already holding lock:
 (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffffa01fcae5>]
xfs_ilock+0x75/0xb0 [xfs]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_iolock)->mr_lock){----}:  
       [<ffffffff80279939>] __lock_acquire+0xd49/0x11a0
       [<ffffffff80279e21>] lock_acquire+0x91/0xc0
       [<ffffffff8026a557>] down_write_nested+0x57/0x90
       [<ffffffffa01fcb15>] xfs_ilock+0xa5/0xb0 [xfs]
       [<ffffffffa01fccc6>] xfs_ireclaim+0x46/0x90 [xfs]
       [<ffffffffa021a95e>] xfs_finish_reclaim+0x5e/0x1a0 [xfs]
       [<ffffffffa021acbb>] xfs_reclaim+0x11b/0x120 [xfs]
       [<ffffffffa022a29e>] xfs_fs_clear_inode+0xee/0x120 [xfs]
       [<ffffffff80310881>] clear_inode+0xb1/0x130
       [<ffffffff803109a8>] dispose_list+0x38/0x120
       [<ffffffff80310cd3>] shrink_icache_memory+0x243/0x290
       [<ffffffff802c80d5>] shrink_slab+0x125/0x180
       [<ffffffff802cb80a>] kswapd+0x52a/0x680
       [<ffffffff80265dae>] kthread+0x4e/0x90
       [<ffffffff8020d849>] child_rip+0xa/0x11
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (iprune_mutex){--..}:  
       [<ffffffff80279a00>] __lock_acquire+0xe10/0x11a0
       [<ffffffff80279e21>] lock_acquire+0x91/0xc0
       [<ffffffff8052bee3>] __mutex_lock_common+0xb3/0x390
       [<ffffffff8052c2a4>] mutex_lock_nested+0x44/0x50
       [<ffffffff80310b14>] shrink_icache_memory+0x84/0x290
       [<ffffffff802c80d5>] shrink_slab+0x125/0x180
       [<ffffffff802cad3b>] do_try_to_free_pages+0x2bb/0x460
       [<ffffffff802cafd7>] try_to_free_pages+0x67/0x70
       [<ffffffff802c1dfa>] __alloc_pages_internal+0x23a/0x530
       [<ffffffff802e6c5d>] alloc_pages_current+0xad/0x110
       [<ffffffff802f17ab>] new_slab+0x2ab/0x350
       [<ffffffff802f29bc>] __slab_alloc+0x33c/0x440
       [<ffffffff802f2c76>] kmem_cache_alloc+0xd6/0xe0
       [<ffffffff803b962b>] radix_tree_preload+0x3b/0xb0
       [<ffffffff802bc728>] add_to_page_cache_locked+0x68/0x110
       [<ffffffff802bc801>] add_to_page_cache_lru+0x31/0x90
       [<ffffffff8032a08f>] mpage_readpages+0x9f/0x120
       [<ffffffffa02204ff>] xfs_vm_readpages+0x1f/0x30 [xfs]
       [<ffffffff802c5ac1>] __do_page_cache_readahead+0x1a1/0x250
       [<ffffffff802c5f2b>] ondemand_readahead+0x1cb/0x250
       [<ffffffff802c6059>] page_cache_async_readahead+0xa9/0xc0
       [<ffffffff802bd3d7>] generic_file_aio_read+0x447/0x6c0
       [<ffffffffa0229aff>] xfs_read+0x12f/0x2c0 [xfs]
       [<ffffffffa0224e46>] xfs_file_aio_read+0x56/0x60 [xfs]
       [<ffffffff802fad99>] do_sync_read+0xf9/0x140
       [<ffffffff802fb5d8>] vfs_read+0xc8/0x180
       [<ffffffff802fb795>] sys_read+0x55/0x90
       [<ffffffff8020c6ab>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by rsync/21485:
 #0:  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffffa01fcae5>]
xfs_ilock+0x75/0xb0 [xfs] #1:  (shrinker_rwsem){----}, at:
[<ffffffff802c7fe7>] shrink_slab+0x37/0x180

stack backtrace:
Pid: 21485, comm: rsync Not tainted 2.6.28-rc6git #1
Call Trace:
 [<ffffffff802776d7>] print_circular_bug_tail+0xa7/0xf0
 [<ffffffff80279a00>] __lock_acquire+0xe10/0x11a0
 [<ffffffff80279e21>] lock_acquire+0x91/0xc0
 [<ffffffff80310b14>] ? shrink_icache_memory+0x84/0x290
 [<ffffffff8052bee3>] __mutex_lock_common+0xb3/0x390
 [<ffffffff80310b14>] ? shrink_icache_memory+0x84/0x290
 [<ffffffff80310b14>] ? shrink_icache_memory+0x84/0x290
 [<ffffffff80213b93>] ? native_sched_clock+0x13/0x60
 [<ffffffff8052c2a4>] mutex_lock_nested+0x44/0x50
 [<ffffffff80310b14>] shrink_icache_memory+0x84/0x290
 [<ffffffff802c80d5>] shrink_slab+0x125/0x180
 [<ffffffff802cad3b>] do_try_to_free_pages+0x2bb/0x460
 [<ffffffff802cafd7>] try_to_free_pages+0x67/0x70
 [<ffffffff802c9610>] ? isolate_pages_global+0x0/0x260
 [<ffffffff802c1dfa>] __alloc_pages_internal+0x23a/0x530
 [<ffffffff802e6c5d>] alloc_pages_current+0xad/0x110
 [<ffffffff802f17ab>] new_slab+0x2ab/0x350
 [<ffffffff802f29ad>] ? __slab_alloc+0x32d/0x440
 [<ffffffff802f29bc>] __slab_alloc+0x33c/0x440
 [<ffffffff803b962b>] ? radix_tree_preload+0x3b/0xb0
 [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
 [<ffffffff803b962b>] ? radix_tree_preload+0x3b/0xb0
 [<ffffffff802f2c76>] kmem_cache_alloc+0xd6/0xe0
 [<ffffffff803b962b>] radix_tree_preload+0x3b/0xb0
 [<ffffffff802bc728>] add_to_page_cache_locked+0x68/0x110
 [<ffffffff802bc801>] add_to_page_cache_lru+0x31/0x90
 [<ffffffff8032a08f>] mpage_readpages+0x9f/0x120
 [<ffffffffa02200d0>] ? xfs_get_blocks+0x0/0x20 [xfs]
 [<ffffffff802c1cb3>] ? __alloc_pages_internal+0xf3/0x530
 [<ffffffffa02200d0>] ? xfs_get_blocks+0x0/0x20 [xfs]
 [<ffffffffa02204ff>] xfs_vm_readpages+0x1f/0x30 [xfs]
 [<ffffffff802c5ac1>] __do_page_cache_readahead+0x1a1/0x250
 [<ffffffff802c59ea>] ? __do_page_cache_readahead+0xca/0x250
 [<ffffffff802c5f2b>] ondemand_readahead+0x1cb/0x250
 [<ffffffffa0071860>] ? raid1_congested+0x0/0xf0 [raid1]
 [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
 [<ffffffff802c6059>] page_cache_async_readahead+0xa9/0xc0
 [<ffffffff802bd3d7>] generic_file_aio_read+0x447/0x6c0
 [<ffffffff8052df84>] ? _spin_unlock_irqrestore+0x44/0x70
 [<ffffffffa01fcae5>] ? xfs_ilock+0x75/0xb0 [xfs]
 [<ffffffffa0229aff>] xfs_read+0x12f/0x2c0 [xfs]
 [<ffffffffa0224e46>] xfs_file_aio_read+0x56/0x60 [xfs]
 [<ffffffff802fad99>] do_sync_read+0xf9/0x140
 [<ffffffff80266200>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8020c558>] ? ftrace_call+0x5/0x2b
 [<ffffffff80375069>] ? cap_file_permission+0x9/0x10
 [<ffffffff80373fa6>] ? security_file_permission+0x16/0x20
 [<ffffffff802fb5d8>] vfs_read+0xc8/0x180
 [<ffffffff802fb795>] sys_read+0x55/0x90
 [<ffffffff8020c6ab>] system_call_fastpath+0x16/0x1b


Cheers,
Dan

-- 
                    /--------------- - -  -  -   -   -
                   |  Dan Noé
                   |  http://isomerica.net/~dpn/
