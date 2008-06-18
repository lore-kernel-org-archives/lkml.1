Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYFROCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYFROCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYFROB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:01:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYFROBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:01:55 -0400
Date: Wed, 18 Jun 2008 10:01:53 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: debug_objects: lockdep warnings from 2.6.26-rc6 with debug_objects
 enabled
Message-ID: <20080618100153.6369d784@barsoom.rdu.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to reproduce another problem this morning and I ran across this
easily reproducible lockdep warning when I booted a recent Fedora
rawhide kernel with debug_objects=1.

I seem to consistently get a similar lockdep warning every time I boot,
but sometimes the stack traces look a bit different. The locks involved
do seem to be relatively consistent though.

Let me know if you need any other info...

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-0.74.rc6.git4.fc10.x86_64 #1
-------------------------------------------------------
automount/2337 is trying to acquire lock:
 (&n->list_lock){++..}, at: [<ffffffff810a9540>] unfreeze_slab+0x58/0xb1

but task is already holding lock:
 (&obj_hash[i].lock){++..}, at: [<ffffffff8114ad59>] __debug_object_init+0x2f/0x352

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&obj_hash[i].lock){++..}:
       [<ffffffff81057c5c>] __lock_acquire+0xbcf/0xd5f
       [<ffffffff81057e4a>] lock_acquire+0x5e/0x78
       [<ffffffff812b00a5>] _spin_lock_irqsave+0x36/0x69
       [<ffffffff8114a870>] debug_check_no_obj_freed+0x6d/0x158
       [<ffffffff81087b6c>] free_hot_cold_page+0xe6/0x1d0
       [<ffffffff81087cae>] free_hot_page+0xb/0xd
       [<ffffffff81087cd2>] __free_pages+0x22/0x2b
       [<ffffffff810a9494>] __free_slab+0xf5/0x102
       [<ffffffff810a94e6>] discard_slab+0x45/0x47
       [<ffffffff810aca5b>] kmem_cache_shrink+0x13a/0x21e
       [<ffffffff8116f2ad>] acpi_os_purge_cache+0x9/0xd
       [<ffffffff81186004>] acpi_purge_cached_objects+0x10/0x38
       [<ffffffff8118608a>] acpi_initialize_objects+0x49/0x54
       [<ffffffff8151fdd0>] acpi_init+0x8c/0x221
       [<ffffffff8150175f>] kernel_init+0x1eb/0x344
       [<ffffffff8100cec8>] child_rip+0xa/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&n->list_lock){++..}:
       [<ffffffff81057b5f>] __lock_acquire+0xad2/0xd5f
       [<ffffffff81057e4a>] lock_acquire+0x5e/0x78
       [<ffffffff812aff8f>] _spin_lock+0x26/0x53
       [<ffffffff810a9540>] unfreeze_slab+0x58/0xb1
       [<ffffffff810aaf10>] __slab_alloc+0xf0/0x481
       [<ffffffff810ab3c2>] kmem_cache_alloc+0x62/0xa8
       [<ffffffff8114ae74>] __debug_object_init+0x14a/0x352
       [<ffffffff8114b0a9>] debug_object_init+0x14/0x17
       [<ffffffff8103f947>] init_timer+0x18/0x5b
       [<ffffffffa005c133>] scsi_get_command+0x53/0xa8 [scsi_mod]
       [<ffffffffa0061555>] scsi_setup_fs_cmnd+0x41/0x91 [scsi_mod]
       [<ffffffffa0084d37>] sd_prep_fn+0x72/0x79f [sd_mod]
       [<ffffffff81130101>] elv_next_request+0x158/0x21f
       [<ffffffffa0060bd8>] scsi_request_fn+0x93/0x411 [scsi_mod]
       [<ffffffff811320d8>] __generic_unplug_device+0x27/0x2b
       [<ffffffff811321b1>] generic_unplug_device+0x29/0x39
       [<ffffffff811315ad>] blk_unplug+0x5c/0x63
       [<ffffffffa00c80ef>] dm_table_unplug_all+0x2b/0x3e [dm_mod]
       [<ffffffffa00c7d3c>] dm_unplug_all+0x25/0x32 [dm_mod]
       [<ffffffff811315ad>] blk_unplug+0x5c/0x63
       [<ffffffff811315c1>] blk_backing_dev_unplug+0xd/0xf
       [<ffffffff810d4a6f>] sync_buffer+0x39/0x42
       [<ffffffff812ade39>] __wait_on_bit+0x47/0x79
       [<ffffffff812aded5>] out_of_line_wait_on_bit+0x6a/0x77
       [<ffffffff810d49be>] __wait_on_buffer+0x1f/0x21
       [<ffffffff810d6d02>] __bread+0x9a/0xb4
       [<ffffffffa003e7ee>] ext3_get_branch+0x76/0xe9 [ext3]
       [<ffffffffa003f526>] ext3_get_blocks_handle+0x9d/0x8b1 [ext3]
       [<ffffffffa003fdf8>] ext3_get_block+0xbe/0xfc [ext3]
       [<ffffffff810db3e2>] do_mpage_readpage+0x181/0x4d5
       [<ffffffff810db83b>] mpage_readpages+0xb2/0xf7
       [<ffffffffa003f41f>] ext3_readpages+0x1a/0x1c [ext3]
       [<ffffffff8108a7ca>] __do_page_cache_readahead+0x136/0x1ac
       [<ffffffff8108a896>] do_page_cache_readahead+0x56/0x63
       [<ffffffff81082a41>] filemap_fault+0x16a/0x33a
       [<ffffffff81090d5c>] __do_fault+0x51/0x3a8
       [<ffffffff81092a2b>] handle_mm_fault+0x339/0x6f3
       [<ffffffff812b2867>] do_page_fault+0x4aa/0x8b9
       [<ffffffff812b057d>] error_exit+0x0/0xa9
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

3 locks held by automount/2337:
 #0:  (&mm->mmap_sem){----}, at: [<ffffffff812b27af>] do_page_fault+0x3f2/0x8b9
 #1:  (&q->__queue_lock){.+..}, at: [<ffffffff811321a9>] generic_unplug_device+0x21/0x39
 #2:  (&obj_hash[i].lock){++..}, at: [<ffffffff8114ad59>] __debug_object_init+0x2f/0x352

stack backtrace:
Pid: 2337, comm: automount Not tainted 2.6.26-0.74.rc6.git4.fc10.x86_64 #1

Call Trace:
 [<ffffffff81056df2>] print_circular_bug_tail+0x70/0x7b
 [<ffffffff81057b5f>] __lock_acquire+0xad2/0xd5f
 [<ffffffff8114ae74>] ? __debug_object_init+0x14a/0x352
 [<ffffffff81057e4a>] lock_acquire+0x5e/0x78
 [<ffffffff810a9540>] ? unfreeze_slab+0x58/0xb1
 [<ffffffff812aff8f>] _spin_lock+0x26/0x53
 [<ffffffff810a9540>] unfreeze_slab+0x58/0xb1
 [<ffffffff810aaf10>] __slab_alloc+0xf0/0x481
 [<ffffffff8114ae74>] ? __debug_object_init+0x14a/0x352
 [<ffffffff81054fad>] ? lock_release_holdtime+0x1e/0x108
 [<ffffffff8114ae74>] ? __debug_object_init+0x14a/0x352
 [<ffffffff810ab3c2>] kmem_cache_alloc+0x62/0xa8
 [<ffffffff8114ae74>] __debug_object_init+0x14a/0x352
 [<ffffffff8114b0a9>] debug_object_init+0x14/0x17
 [<ffffffff8103f947>] init_timer+0x18/0x5b
 [<ffffffffa005c133>] :scsi_mod:scsi_get_command+0x53/0xa8
 [<ffffffffa0061555>] :scsi_mod:scsi_setup_fs_cmnd+0x41/0x91
 [<ffffffff8114a5e1>] ? list_add+0xc/0xf
 [<ffffffffa0084d37>] :sd_mod:sd_prep_fn+0x72/0x79f
 [<ffffffff81130101>] elv_next_request+0x158/0x21f
 [<ffffffffa0060bd8>] :scsi_mod:scsi_request_fn+0x93/0x411
 [<ffffffff811320d8>] __generic_unplug_device+0x27/0x2b
 [<ffffffff811321b1>] generic_unplug_device+0x29/0x39
 [<ffffffff811315ad>] blk_unplug+0x5c/0x63
 [<ffffffff812afdd6>] ? _read_unlock+0x26/0x2b
 [<ffffffffa00c80ef>] :dm_mod:dm_table_unplug_all+0x2b/0x3e
 [<ffffffffa00c7d3c>] :dm_mod:dm_unplug_all+0x25/0x32
 [<ffffffff811315ad>] blk_unplug+0x5c/0x63
 [<ffffffff811315c1>] blk_backing_dev_unplug+0xd/0xf
 [<ffffffff810d4a6f>] sync_buffer+0x39/0x42
 [<ffffffff812ade39>] __wait_on_bit+0x47/0x79
 [<ffffffff810d4a36>] ? sync_buffer+0x0/0x42
 [<ffffffff810d4a36>] ? sync_buffer+0x0/0x42
 [<ffffffff812aded5>] out_of_line_wait_on_bit+0x6a/0x77
 [<ffffffff8104a610>] ? wake_bit_function+0x0/0x2a
 [<ffffffff810d49be>] __wait_on_buffer+0x1f/0x21
 [<ffffffff810d6d02>] __bread+0x9a/0xb4
 [<ffffffffa003e7ee>] :ext3:ext3_get_branch+0x76/0xe9
 [<ffffffffa003f526>] :ext3:ext3_get_blocks_handle+0x9d/0x8b1
 [<ffffffff810568de>] ? mark_held_locks+0x5c/0x77
 [<ffffffff812afe39>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff81132e2d>] ? __make_request+0x3b2/0x3cf
 [<ffffffff8113142d>] ? generic_make_request+0x3b4/0x3ef
 [<ffffffff81011de7>] ? native_sched_clock+0x50/0x6d
 [<ffffffffa003fdf8>] :ext3:ext3_get_block+0xbe/0xfc
 [<ffffffff81131548>] ? submit_bio+0xe0/0xe9
 [<ffffffff810db3e2>] do_mpage_readpage+0x181/0x4d5
 [<ffffffff8108257d>] ? add_to_page_cache+0x93/0xa2
 [<ffffffff810db83b>] mpage_readpages+0xb2/0xf7
 [<ffffffffa003fd3a>] ? :ext3:ext3_get_block+0x0/0xfc
 [<ffffffffa003fd3a>] ? :ext3:ext3_get_block+0x0/0xfc
 [<ffffffff81088c7f>] ? __alloc_pages_nodemask+0x9/0xb
 [<ffffffffa003f41f>] :ext3:ext3_readpages+0x1a/0x1c
 [<ffffffff8108a7ca>] __do_page_cache_readahead+0x136/0x1ac
 [<ffffffff8108a896>] do_page_cache_readahead+0x56/0x63
 [<ffffffff81082a41>] filemap_fault+0x16a/0x33a
 [<ffffffff81090d5c>] __do_fault+0x51/0x3a8
 [<ffffffff81092a2b>] handle_mm_fault+0x339/0x6f3
 [<ffffffff812b27af>] ? do_page_fault+0x3f2/0x8b9
 [<ffffffff812b2867>] do_page_fault+0x4aa/0x8b9
 [<ffffffff811442d9>] ? __up_write+0xf0/0xff
 [<ffffffff81054fad>] ? lock_release_holdtime+0x1e/0x108
 [<ffffffff812afe7d>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff81056a6f>] ? trace_hardirqs_on+0xf1/0x115
 [<ffffffff811442d9>] ? __up_write+0xf0/0xff
 [<ffffffff812afa6b>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff81056a6f>] ? trace_hardirqs_on+0xf1/0x115
 [<ffffffff812b057d>] error_exit+0x0/0xa9


-- 
Jeff Layton <jlayton@redhat.com>
