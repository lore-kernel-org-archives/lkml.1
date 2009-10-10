Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZJJXKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZJJXKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZJJXKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:10:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbZJJXKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:10:31 -0400
Date: Sun, 11 Oct 2009 01:09:50 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, xfs-masters@oss.sgi.com
Subject: INFO: possible circular locking dependency detected 
Message-ID: <alpine.LFD.2.00.0910110108160.4921@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-rc3 #1
-------------------------------------------------------
mono/3284 is trying to acquire lock:
 (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffffa005b3b8>] xfs_ilock+0x3a/0xa3 [xfs]

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff8111f353>] sys_munmap+0x45/0x83

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
       [<ffffffff8109caff>] __lock_acquire+0xc04/0xde2
       [<ffffffff8109cdc0>] lock_acquire+0xe3/0x114
       [<ffffffff811162cf>] might_fault+0x9f/0xd8
       [<ffffffff810f9047>] file_read_actor+0xdc/0x166
       [<ffffffff810fb743>] generic_file_aio_read+0x381/0x5d5
       [<ffffffffa0082630>] xfs_read+0x185/0x209 [xfs]
       [<ffffffffa007e162>] xfs_file_aio_read+0x72/0x88 [xfs]
       [<ffffffff8114290e>] do_sync_read+0xf9/0x152
       [<ffffffff811435d9>] vfs_read+0xbb/0x12c
       [<ffffffff81143740>] sys_read+0x56/0x93
       [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b

-> #0 (&(&ip->i_iolock)->mr_lock){++++++}:
       [<ffffffff8109c9d7>] __lock_acquire+0xadc/0xde2
       [<ffffffff8109cdc0>] lock_acquire+0xe3/0x114
       [<ffffffff81089d72>] down_write_nested+0x57/0xa2
       [<ffffffffa005b3b8>] xfs_ilock+0x3a/0xa3 [xfs]
       [<ffffffffa0076843>] xfs_free_eofblocks+0x115/0x21a [xfs]
       [<ffffffffa00772ff>] xfs_release+0x146/0x169 [xfs]
       [<ffffffffa007dfc0>] xfs_file_release+0x23/0x3b [xfs]
       [<ffffffff811440ed>] __fput+0x12a/0x1ec
       [<ffffffff811441da>] fput+0x2b/0x41
       [<ffffffff8111df77>] remove_vma+0x5f/0xad
       [<ffffffff8111f2d8>] do_munmap+0x313/0x349
       [<ffffffff8111f361>] sys_munmap+0x53/0x83
       [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by mono/3284:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8111f353>] sys_munmap+0x45/0x83

stack backtrace:
Pid: 3284, comm: mono Not tainted 2.6.32-rc3 #1
Call Trace:
 [<ffffffff8109ba46>] print_circular_bug+0xc2/0xe7
 [<ffffffff8109c9d7>] __lock_acquire+0xadc/0xde2
 [<ffffffffa005b3b8>] ? xfs_ilock+0x3a/0xa3 [xfs]
 [<ffffffffa005b3b8>] ? xfs_ilock+0x3a/0xa3 [xfs]
 [<ffffffff8109cdc0>] lock_acquire+0xe3/0x114
 [<ffffffffa005b3b8>] ? xfs_ilock+0x3a/0xa3 [xfs]
 [<ffffffff81089d72>] down_write_nested+0x57/0xa2
 [<ffffffffa005b3b8>] ? xfs_ilock+0x3a/0xa3 [xfs]
 [<ffffffffa00722af>] ? xfs_trans_alloc+0xa7/0xc8 [xfs]
 [<ffffffffa005b3b8>] xfs_ilock+0x3a/0xa3 [xfs]
 [<ffffffffa0076843>] xfs_free_eofblocks+0x115/0x21a [xfs]
 [<ffffffff8104c1b8>] ? get_parent_ip+0x20/0x67
 [<ffffffffa00772ff>] xfs_release+0x146/0x169 [xfs]
 [<ffffffffa007dfc0>] xfs_file_release+0x23/0x3b [xfs]
 [<ffffffff811440ed>] __fput+0x12a/0x1ec
 [<ffffffff8111ddf1>] ? tlb_finish_mmu+0x6c/0x90
 [<ffffffff811441da>] fput+0x2b/0x41
 [<ffffffff8111df77>] remove_vma+0x5f/0xad
 [<ffffffff8111f2d8>] do_munmap+0x313/0x349
 [<ffffffff81428853>] ? down_write+0x80/0x9d
 [<ffffffff8111f361>] sys_munmap+0x53/0x83
 [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b

