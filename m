Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbXKIRCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbXKIRCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXKIRC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:02:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbXKIRC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:02:26 -0500
Subject: Re: dio_get_page() lockdep complaints
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-aio@kvack.org, Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <20070419073828.GB20928@kernel.dk>
References: <20070419073828.GB20928@kernel.dk>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 18:02:22 +0100
Message-Id: <1194627742.6289.175.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 09:38 +0200, Jens Axboe wrote:
> Hi,
> 
> Doing some testing on CFQ, I ran into this 100% reproducible report:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.21-rc7 #5
> -------------------------------------------------------
> fio/9741 is trying to acquire lock:
>  (&mm->mmap_sem){----}, at: [<b018cb34>] dio_get_page+0x54/0x161
> 
> but task is already holding lock:
>  (&inode->i_mutex){--..}, at: [<b038c6e5>] mutex_lock+0x1c/0x1f
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&inode->i_mutex){--..}:
>        [<b013e3fb>] __lock_acquire+0xdee/0xf9c
>        [<b013e600>] lock_acquire+0x57/0x70
>        [<b038c4a5>] __mutex_lock_slowpath+0x73/0x297
>        [<b038c6e5>] mutex_lock+0x1c/0x1f
>        [<b01b17e9>] reiserfs_file_release+0x54/0x447
>        [<b016afe7>] __fput+0x53/0x101
>        [<b016b0ee>] fput+0x19/0x1c
>        [<b015bcd5>] remove_vma+0x3b/0x4d
>        [<b015c659>] do_munmap+0x17f/0x1cf
>        [<b015c6db>] sys_munmap+0x32/0x42
>        [<b0103f04>] sysenter_past_esp+0x5d/0x99
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&mm->mmap_sem){----}:
>        [<b013e259>] __lock_acquire+0xc4c/0xf9c
>        [<b013e600>] lock_acquire+0x57/0x70
>        [<b0137b92>] down_read+0x3a/0x4c
>        [<b018cb34>] dio_get_page+0x54/0x161
>        [<b018d7a9>] __blockdev_direct_IO+0x514/0xe2a
>        [<b01cf449>] ext3_direct_IO+0x98/0x1e5
>        [<b014e8df>] generic_file_direct_IO+0x63/0x133
>        [<b01500e9>] generic_file_aio_read+0x16b/0x222
>        [<b017f8b6>] aio_rw_vect_retry+0x5a/0x116
>        [<b0180147>] aio_run_iocb+0x69/0x129
>        [<b0180a78>] io_submit_one+0x194/0x2eb
>        [<b0181331>] sys_io_submit+0x92/0xe7
>        [<b0103f90>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 1 lock held by fio/9741:
>  #0:  (&inode->i_mutex){--..}, at: [<b038c6e5>] mutex_lock+0x1c/0x1f
> 
> stack backtrace:
>  [<b0104f54>] show_trace_log_lvl+0x1a/0x30
>  [<b0105626>] show_trace+0x12/0x14
>  [<b01056ad>] dump_stack+0x16/0x18
>  [<b013c48d>] print_circular_bug_tail+0x68/0x71
>  [<b013e259>] __lock_acquire+0xc4c/0xf9c
>  [<b013e600>] lock_acquire+0x57/0x70
>  [<b0137b92>] down_read+0x3a/0x4c
>  [<b018cb34>] dio_get_page+0x54/0x161
>  [<b018d7a9>] __blockdev_direct_IO+0x514/0xe2a
>  [<b01cf449>] ext3_direct_IO+0x98/0x1e5
>  [<b014e8df>] generic_file_direct_IO+0x63/0x133
>  [<b01500e9>] generic_file_aio_read+0x16b/0x222
>  [<b017f8b6>] aio_rw_vect_retry+0x5a/0x116
>  [<b0180147>] aio_run_iocb+0x69/0x129
>  [<b0180a78>] io_submit_one+0x194/0x2eb
>  [<b0181331>] sys_io_submit+0x92/0xe7
>  [<b0103f90>] syscall_call+0x7/0xb
>  =======================

I just got pointed at a similar lockdep output from the -rt tree, only
its NFS doing teh funny.

=======================================================
[ INFO: possible circular locking dependency detected ]
[ 2.6.21-50.el5rtdebug #1
-------------------------------------------------------
diotest1/3308 is trying to acquire lock:
 ((struct rw_semaphore *)(&mm->mmap_sem)){----}, at:
[<ffffffff802b7346>] rt_down_read+0xb/0xd

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<ffffffff802234cc>]
generic_file_aio_write+0x4d/0xc3

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&inode->i_mutex){--..}:
       [<ffffffff802aeb1f>] add_lock_to_list+0x82/0xb1
       [<ffffffff802b1084>] __lock_acquire+0x9dd/0xb75
       [<ffffffff802b15e9>] lock_acquire+0x4c/0x65
       [<ffffffff802686a1>] _mutex_lock+0x28/0x34
       [<ffffffff883e71d0>] nfs_revalidate_mapping+0x6d/0xac [nfs]
       [<ffffffff883e4b51>] nfs_file_mmap+0x5c/0x74 [nfs]
       [<ffffffff8020df7e>] do_mmap_pgoff+0x51a/0x817
       [<ffffffff80225d19>] sys_mmap+0x90/0x119
       [<ffffffff80261445>] tracesys+0x151/0x1be
       [<00002aafa52db2aa>] 0x2aafa52db2aa
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 ((struct rw_semaphore *)(&mm->mmap_sem)){----}:
       [<ffffffff802af683>] print_circular_bug_tail+0x39/0x7b
       [<ffffffff802b0f7e>] __lock_acquire+0x8d7/0xb75
       [<ffffffff802b15e9>] lock_acquire+0x4c/0x65
       [<ffffffff802b72ea>] __rt_down_read+0x29/0x6f
       [<ffffffff802b7346>] rt_down_read+0xb/0xd
       [<ffffffff803062f6>] dio_get_page+0x48/0x1fb
       [<ffffffff80306fef>] __blockdev_direct_IO+0x4c3/0xb28
       [<ffffffff880568b2>] ext3_direct_IO+0x10a/0x1a1 [ext3]
       [<ffffffff802d65ea>] generic_file_direct_IO+0xd9/0x11e
       [<ffffffff802204ea>] generic_file_direct_write+0x64/0x104
       [<ffffffff80216ee8>] __generic_file_aio_write_nolock+0x2e1/0x40b
       [<ffffffff802234e3>] generic_file_aio_write+0x64/0xc3
       [<ffffffff88052260>] ext3_file_write+0x24/0xa7 [ext3]
       [<ffffffff80218c4f>] do_sync_write+0xe5/0x129
       [<ffffffff80217425>] vfs_write+0xd8/0x18a
       [<ffffffff80217de3>] sys_write+0x4a/0x76
       [<ffffffff80261445>] tracesys+0x151/0x1be
       [<0000003c5c8c09d0>] 0x3c5c8c09d0
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by diotest1/3308:
 #0:  (&inode->i_mutex){--..}, at: [<ffffffff802234cc>]
generic_file_aio_write+0x4d/0xc3

stack backtrace:

Call Trace:
 [<ffffffff8027074a>] dump_trace+0xaa/0x32a
 [<ffffffff80270a0b>] show_trace+0x41/0x6c
 [<ffffffff80270a4b>] dump_stack+0x15/0x17
 [<ffffffff802af6ba>] print_circular_bug_tail+0x70/0x7b
 [<ffffffff802b0f7e>] __lock_acquire+0x8d7/0xb75
 [<ffffffff802b15e9>] lock_acquire+0x4c/0x65
 [<ffffffff802b72ea>] __rt_down_read+0x29/0x6f
 [<ffffffff802b7346>] rt_down_read+0xb/0xd
 [<ffffffff803062f6>] dio_get_page+0x48/0x1fb
 [<ffffffff80306fef>] __blockdev_direct_IO+0x4c3/0xb28
 [<ffffffff880568b2>] :ext3:ext3_direct_IO+0x10a/0x1a1
 [<ffffffff802d65ea>] generic_file_direct_IO+0xd9/0x11e
 [<ffffffff802204ea>] generic_file_direct_write+0x64/0x104
 [<ffffffff80216ee8>] __generic_file_aio_write_nolock+0x2e1/0x40b
 [<ffffffff802234e3>] generic_file_aio_write+0x64/0xc3
 [<ffffffff88052260>] :ext3:ext3_file_write+0x24/0xa7
 [<ffffffff80218c4f>] do_sync_write+0xe5/0x129
 [<ffffffff80217425>] vfs_write+0xd8/0x18a
 [<ffffffff80217de3>] sys_write+0x4a/0x76
 [<ffffffff80261445>] tracesys+0x151/0x1be
 [<0000003c5c8c09d0>]

INFO: lockdep is turned off.
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------


Looking at the .24-rc2 code I still see NFS taking i_mutex in that path.

