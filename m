Return-Path: <linux-kernel-owner+w=401wt.eu-S1030188AbXDSHk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188AbXDSHk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031161AbXDSHk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:40:58 -0400
Received: from brick.kernel.dk ([80.160.20.94]:2092 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030188AbXDSHk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:40:57 -0400
Date: Thu, 19 Apr 2007 09:38:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-aio@kvack.org
Subject: dio_get_page() lockdep complaints
Message-ID: <20070419073828.GB20928@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Doing some testing on CFQ, I ran into this 100% reproducible report:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21-rc7 #5
-------------------------------------------------------
fio/9741 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<b018cb34>] dio_get_page+0x54/0x161

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<b038c6e5>] mutex_lock+0x1c/0x1f

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&inode->i_mutex){--..}:
       [<b013e3fb>] __lock_acquire+0xdee/0xf9c
       [<b013e600>] lock_acquire+0x57/0x70
       [<b038c4a5>] __mutex_lock_slowpath+0x73/0x297
       [<b038c6e5>] mutex_lock+0x1c/0x1f
       [<b01b17e9>] reiserfs_file_release+0x54/0x447
       [<b016afe7>] __fput+0x53/0x101
       [<b016b0ee>] fput+0x19/0x1c
       [<b015bcd5>] remove_vma+0x3b/0x4d
       [<b015c659>] do_munmap+0x17f/0x1cf
       [<b015c6db>] sys_munmap+0x32/0x42
       [<b0103f04>] sysenter_past_esp+0x5d/0x99
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<b013e259>] __lock_acquire+0xc4c/0xf9c
       [<b013e600>] lock_acquire+0x57/0x70
       [<b0137b92>] down_read+0x3a/0x4c
       [<b018cb34>] dio_get_page+0x54/0x161
       [<b018d7a9>] __blockdev_direct_IO+0x514/0xe2a
       [<b01cf449>] ext3_direct_IO+0x98/0x1e5
       [<b014e8df>] generic_file_direct_IO+0x63/0x133
       [<b01500e9>] generic_file_aio_read+0x16b/0x222
       [<b017f8b6>] aio_rw_vect_retry+0x5a/0x116
       [<b0180147>] aio_run_iocb+0x69/0x129
       [<b0180a78>] io_submit_one+0x194/0x2eb
       [<b0181331>] sys_io_submit+0x92/0xe7
       [<b0103f90>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by fio/9741:
 #0:  (&inode->i_mutex){--..}, at: [<b038c6e5>] mutex_lock+0x1c/0x1f

stack backtrace:
 [<b0104f54>] show_trace_log_lvl+0x1a/0x30
 [<b0105626>] show_trace+0x12/0x14
 [<b01056ad>] dump_stack+0x16/0x18
 [<b013c48d>] print_circular_bug_tail+0x68/0x71
 [<b013e259>] __lock_acquire+0xc4c/0xf9c
 [<b013e600>] lock_acquire+0x57/0x70
 [<b0137b92>] down_read+0x3a/0x4c
 [<b018cb34>] dio_get_page+0x54/0x161
 [<b018d7a9>] __blockdev_direct_IO+0x514/0xe2a
 [<b01cf449>] ext3_direct_IO+0x98/0x1e5
 [<b014e8df>] generic_file_direct_IO+0x63/0x133
 [<b01500e9>] generic_file_aio_read+0x16b/0x222
 [<b017f8b6>] aio_rw_vect_retry+0x5a/0x116
 [<b0180147>] aio_run_iocb+0x69/0x129
 [<b0180a78>] io_submit_one+0x194/0x2eb
 [<b0181331>] sys_io_submit+0x92/0xe7
 [<b0103f90>] syscall_call+0x7/0xb
 =======================

The test run was fio, the job file used is:

# fio job file snip below
[global]
bs=4k
buffered=0
ioengine=libaio
iodepth=4
thread

[readers]
numjobs=8
size=128m
rw=read
# fio job file snip above

Filesystem was ext3, default mkfs and mount options. Kernel was
2.6.21-rc7 as of this morning, with some CFQ patches applied.

-- 
Jens Axboe

