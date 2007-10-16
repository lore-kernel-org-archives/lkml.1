Return-Path: <linux-kernel-owner+w=401wt.eu-S1765600AbXJPIz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765600AbXJPIz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbXJPIzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:55:48 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:20755 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384AbXJPIzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:55:47 -0400
Date: Tue, 16 Oct 2007 12:54:29 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, akpm@osdl.org
Subject: Possible circular locking: ->mmap_sem vs jbd_handle
Message-ID: <20071016085429.GA6352@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got this during LTP's diotest1. Reproducable.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.23-65a6ec0d72a07f16719e9b7a96e1c4bae044b591 #2
-------------------------------------------------------
diotest1/13563 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<c107a7b7>] dio_get_page+0x4b/0x16b

but task is already holding lock:
 (jbd_handle){--..}, at: [<c1099b05>] journal_start+0xf3/0x120

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (jbd_handle){--..}:
       [<c1033b14>] __lock_acquire+0x9b0/0xb7b
       [<c1099b05>] journal_start+0xf3/0x120
       [<c10581a2>] kmem_cache_alloc+0x67/0x9b
       [<c10340a9>] lock_acquire+0x5f/0x77
       [<c1099b05>] journal_start+0xf3/0x120
       [<c1099b28>] journal_start+0x116/0x120
       [<c1099b05>] journal_start+0xf3/0x120
       [<c1090d6a>] ext3_dirty_inode+0x24/0x6d
       [<c10581a2>] kmem_cache_alloc+0x67/0x9b
       [<c10729b3>] __mark_inode_dirty+0x24/0x145
       [<c101d2c2>] current_fs_time+0x13/0x15
       [<c103e0bf>] generic_file_mmap+0x2a/0x3e
       [<c104da6e>] mmap_region+0x200/0x3ee
       [<c104df32>] do_mmap_pgoff+0x209/0x252
       [<c1006a0f>] sys_mmap2+0x9d/0xb7
       [<c10027de>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<c1031966>] print_circular_bug_entry+0x40/0x46
       [<c1033a04>] __lock_acquire+0x8a0/0xb7b
       [<c1033137>] check_noncircular+0x57/0x84
       [<c1056ecc>] check_bytes_and_report+0x26/0xb2
       [<c1032e6f>] debug_check_no_locks_freed+0x134/0x13e
       [<c10340a9>] lock_acquire+0x5f/0x77
       [<c107a7b7>] dio_get_page+0x4b/0x16b
       [<c102c2d8>] down_read+0x38/0x49
       [<c107a7b7>] dio_get_page+0x4b/0x16b
       [<c107a7b7>] dio_get_page+0x4b/0x16b
       [<c10c0c1c>] __spin_lock_init+0x29/0x49
       [<c107b2a3>] __blockdev_direct_IO+0x495/0xad4
       [<c1032b41>] mark_held_locks+0x39/0x53
       [<c1196f3d>] __mutex_unlock_slowpath+0x105/0x127
       [<c1032d18>] trace_hardirqs_on+0x11a/0x13d
       [<c1099b05>] journal_start+0xf3/0x120
       [<c1099b28>] journal_start+0x116/0x120
       [<c1090b81>] ext3_direct_IO+0xfa/0x18a
       [<c108f296>] ext3_get_block+0x0/0xbe
       [<c103f0fd>] generic_file_direct_IO+0xe5/0x116
       [<c103f18a>] generic_file_direct_write+0x5c/0x138
       [<c101d2c2>] current_fs_time+0x13/0x15
       [<c103fbbe>] __generic_file_aio_write_nolock+0x378/0x4dc
       [<c1032d18>] trace_hardirqs_on+0x11a/0x13d
       [<c103fd67>] generic_file_aio_write+0x45/0xb8
       [<c103fd7c>] generic_file_aio_write+0x5a/0xb8
       [<c108cd94>] ext3_file_write+0x24/0x8f
       [<c105af91>] do_sync_write+0xc7/0x10a
       [<c1029231>] autoremove_wake_function+0x0/0x35
       [<c102c39b>] up_read+0x14/0x29
       [<c104d7c2>] do_brk+0x1ad/0x259
       [<c105aeca>] do_sync_write+0x0/0x10a
       [<c105b660>] vfs_write+0x74/0x95
       [<c105baf1>] sys_write+0x41/0x67
       [<c1002756>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by diotest1/13563:
 #0:  (&type->i_mutex_key#3){--..}, at: [<c103fd67>] generic_file_aio_write+0x45/0xb8
 #1:  (jbd_handle){--..}, at: [<c1099b05>] journal_start+0xf3/0x120

stack backtrace:
 [<c1032269>] print_circular_bug_tail+0x5f/0x67
 [<c1033a04>] __lock_acquire+0x8a0/0xb7b
 [<c1033137>] check_noncircular+0x57/0x84
 [<c1056ecc>] check_bytes_and_report+0x26/0xb2
 [<c1032e6f>] debug_check_no_locks_freed+0x134/0x13e
 [<c10340a9>] lock_acquire+0x5f/0x77
 [<c107a7b7>] dio_get_page+0x4b/0x16b
 [<c102c2d8>] down_read+0x38/0x49
 [<c107a7b7>] dio_get_page+0x4b/0x16b
 [<c107a7b7>] dio_get_page+0x4b/0x16b
 [<c10c0c1c>] __spin_lock_init+0x29/0x49
 [<c107b2a3>] __blockdev_direct_IO+0x495/0xad4
 [<c1032b41>] mark_held_locks+0x39/0x53
 [<c1196f3d>] __mutex_unlock_slowpath+0x105/0x127
 [<c1032d18>] trace_hardirqs_on+0x11a/0x13d
 [<c1099b05>] journal_start+0xf3/0x120
 [<c1099b28>] journal_start+0x116/0x120
 [<c1090b81>] ext3_direct_IO+0xfa/0x18a
 [<c108f296>] ext3_get_block+0x0/0xbe
 [<c103f0fd>] generic_file_direct_IO+0xe5/0x116
 [<c103f18a>] generic_file_direct_write+0x5c/0x138
 [<c101d2c2>] current_fs_time+0x13/0x15
 [<c103fbbe>] __generic_file_aio_write_nolock+0x378/0x4dc
 [<c1032d18>] trace_hardirqs_on+0x11a/0x13d
 [<c103fd67>] generic_file_aio_write+0x45/0xb8
 [<c103fd7c>] generic_file_aio_write+0x5a/0xb8
 [<c108cd94>] ext3_file_write+0x24/0x8f
 [<c105af91>] do_sync_write+0xc7/0x10a
 [<c1029231>] autoremove_wake_function+0x0/0x35
 [<c102c39b>] up_read+0x14/0x29
 [<c104d7c2>] do_brk+0x1ad/0x259
 [<c105aeca>] do_sync_write+0x0/0x10a
 [<c105b660>] vfs_write+0x74/0x95
 [<c105baf1>] sys_write+0x41/0x67
 [<c1002756>] sysenter_past_esp+0x5f/0xa5
 =======================

