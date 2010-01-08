Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971Ab0AHFTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0AHFTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802Ab0AHFTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:19:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0AHFTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:19:19 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Andi Kleen <andi@firstfloor.org>
References: <1262896174.2659.3.camel@localhost>
	<87zl4pmxzp.fsf@basil.nowhere.org>
	<1262901198.2659.38.camel@localhost>
	<20100107235149.GD16076@basil.fritz.box>
	<1262909682.2659.45.camel@localhost>
	<alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
	<1262912601.2659.89.camel@localhost>
	<alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
	<1262913752.2659.100.camel@localhost>
	<alpine.LFD.2.00.1001071727490.7821@localhost.localdomain>
Date: Fri, 08 Jan 2010 06:19:07 +0100
In-Reply-To: <alpine.LFD.2.00.1001071727490.7821@localhost.localdomain> (Linus Torvalds's message of "Thu, 7 Jan 2010 17:30:50 -0800 (PST)")
Message-ID: <87r5q1mawk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I've not actually seen the lockdep chain, so I don't know 
> the deails. Pointers?


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.33-rc1-git3-MCE6 #12
-------------------------------------------------------
udevinfo/2562 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<ffffffff81185188>] nfs_revalidate_mapping+0x7c/0xc5

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff810ae75b>] sys_mmap_pgoff+0xd3/0x1a0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
       [<ffffffff81068c48>] __lock_acquire+0x1432/0x1771
       [<ffffffff81069043>] lock_acquire+0xbc/0xd9
       [<ffffffff810b1a90>] might_fault+0x84/0xa4
       [<ffffffff810e3c78>] filldir+0x6a/0xcb
       [<ffffffff81180d58>] nfs_do_filldir+0x39d/0x4ac
       [<ffffffff8118167c>] nfs_readdir+0x815/0x8b6
       [<ffffffff810e3df7>] vfs_readdir+0x6c/0xa1
       [<ffffffff810e3f6a>] sys_getdents+0x7d/0xc9
       [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b

-> #0 (&sb->s_type->i_mutex_key#5){+.+.+.}:
       [<ffffffff8106896d>] __lock_acquire+0x1157/0x1771
       [<ffffffff81069043>] lock_acquire+0xbc/0xd9
       [<ffffffff8149472c>] mutex_lock_nested+0x68/0x2d2
       [<ffffffff81185188>] nfs_revalidate_mapping+0x7c/0xc5
       [<ffffffff81182c0a>] nfs_file_mmap+0x68/0x71
       [<ffffffff810b99bf>] mmap_region+0x311/0x530
       [<ffffffff810b9e6e>] do_mmap_pgoff+0x290/0x2f3
       [<ffffffff810ae77c>] sys_mmap_pgoff+0xf4/0x1a0
       [<ffffffff81006ba2>] sys_mmap+0x1d/0x1f
       [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by udevinfo/2562:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810ae75b>] sys_mmap_pgoff+0xd3/0x1a0

stack backtrace:
Pid: 2562, comm: udevinfo Not tainted 2.6.33-rc1-git3-MCE6 #12
Call Trace:
 [<ffffffff810672c8>] print_circular_bug+0xb3/0xc2
 [<ffffffff8106896d>] __lock_acquire+0x1157/0x1771
 [<ffffffff8105b031>] ? sched_clock_local+0x1c/0x80
 [<ffffffff81069043>] lock_acquire+0xbc/0xd9
 [<ffffffff81185188>] ? nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff8149472c>] mutex_lock_nested+0x68/0x2d2
 [<ffffffff81185188>] ? nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff8105b15e>] ? sched_clock_cpu+0xc9/0xce
 [<ffffffff81185188>] ? nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff810b991c>] ? mmap_region+0x26e/0x530
 [<ffffffff81185188>] nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff81182c0a>] nfs_file_mmap+0x68/0x71
 [<ffffffff810b99bf>] mmap_region+0x311/0x530
 [<ffffffff810b9e6e>] do_mmap_pgoff+0x290/0x2f3
 [<ffffffff810ae77c>] sys_mmap_pgoff+0xf4/0x1a0
 [<ffffffff81495c86>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81006ba2>] sys_mmap+0x1d/0x1f
 [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
