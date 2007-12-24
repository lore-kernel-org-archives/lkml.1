Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbXLXXDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbXLXXDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 18:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXLXXDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 18:03:04 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49121 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXLXXDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 18:03:01 -0500
Date: Mon, 24 Dec 2007 18:02:24 -0500
Message-Id: <200712242302.lBON2O8s011190@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, ext3-users@redhat.com
Subject: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting: ltp-full-20071031, dio01 test on ext3 with Linus's latest tree.
Kernel w/ SMP, preemption, and lockdep configured.

Cheers,
Erez.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc6 #83
-------------------------------------------------------
diotest1/2088 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<c02778a2>] dio_get_page+0x4e/0x15d

but task is already holding lock:
 (jbd_handle){--..}, at: [<c029c7c6>] journal_start+0xcb/0xf8

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (jbd_handle){--..}:
       [<c023068f>] __lock_acquire+0x9cc/0xb95
       [<c0230c2f>] lock_acquire+0x5f/0x78
       [<c029c7e9>] journal_start+0xee/0xf8
       [<c02959d6>] ext3_journal_start_sb+0x48/0x4a
       [<c029152b>] ext3_dirty_inode+0x27/0x6c
       [<c026f701>] __mark_inode_dirty+0x29/0x144
       [<c026817b>] touch_atime+0xb7/0xbc
       [<c023af6d>] generic_file_mmap+0x2d/0x42
       [<c024a5cc>] mmap_region+0x1e6/0x3b4
       [<c024aa6b>] do_mmap_pgoff+0x1fb/0x253
       [<c02067af>] sys_mmap2+0x9b/0xb5
       [<c020275e>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<c023057f>] __lock_acquire+0x8bc/0xb95
       [<c0230c2f>] lock_acquire+0x5f/0x78
       [<c0397d4f>] down_read+0x3a/0x4c
       [<c02778a2>] dio_get_page+0x4e/0x15d
       [<c0278352>] __blockdev_direct_IO+0x431/0xa81
       [<c0291318>] ext3_direct_IO+0x10c/0x1a1
       [<c023c091>] generic_file_direct_IO+0x124/0x139
       [<c023c0fc>] generic_file_direct_write+0x56/0x11c
       [<c023ca15>] __generic_file_aio_write_nolock+0x33d/0x489
       [<c023cbb9>] generic_file_aio_write+0x58/0xb6
       [<c028d4e3>] ext3_file_write+0x27/0x99
       [<c0256d0f>] do_sync_write+0xc5/0x102
       [<c0257463>] vfs_write+0x90/0x119
       [<c0257a25>] sys_write+0x3d/0x61
       [<c02026d6>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by diotest1/2088:
 #0:  (&sb->s_type->i_mutex_key#6){--..}, at: [<c023cba6>] generic_file_aio_write+0x45/0xb6
 #1:  (jbd_handle){--..}, at: [<c029c7c6>] journal_start+0xcb/0xf8

stack backtrace:
Pid: 2088, comm: diotest1 Not tainted 2.6.24-rc6 #83
 [<c020372b>] show_trace_log_lvl+0x1a/0x2f
 [<c02040b4>] show_trace+0x12/0x14
 [<c020498b>] dump_stack+0x6c/0x72
 [<c022ec9b>] print_circular_bug_tail+0x5f/0x68
 [<c023057f>] __lock_acquire+0x8bc/0xb95
 [<c0230c2f>] lock_acquire+0x5f/0x78
 [<c0397d4f>] down_read+0x3a/0x4c
 [<c02778a2>] dio_get_page+0x4e/0x15d
 [<c0278352>] __blockdev_direct_IO+0x431/0xa81
 [<c0291318>] ext3_direct_IO+0x10c/0x1a1
 [<c023c091>] generic_file_direct_IO+0x124/0x139
 [<c023c0fc>] generic_file_direct_write+0x56/0x11c
 [<c023ca15>] __generic_file_aio_write_nolock+0x33d/0x489
 [<c023cbb9>] generic_file_aio_write+0x58/0xb6
 [<c028d4e3>] ext3_file_write+0x27/0x99
 [<c0256d0f>] do_sync_write+0xc5/0x102
 [<c0257463>] vfs_write+0x90/0x119
 [<c0257a25>] sys_write+0x3d/0x61
 [<c02026d6>] sysenter_past_esp+0x5f/0xa5
 =======================
