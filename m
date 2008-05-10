Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYEJRqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYEJRqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 13:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYEJRqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 13:46:36 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50930 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYEJRqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 13:46:34 -0400
Message-ID: <4825DF71.1030209@linux.vnet.ibm.com>
Date: Sat, 10 May 2008 23:16:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: kernel-testers@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, peterz@infradead.org
Subject: Re: 2.6.26-rc1: possible circular locking dependency
References: <a4423d670805101005x113c4813w2b95c1fb535cf080@mail.gmail.com>
In-Reply-To: <a4423d670805101005x113c4813w2b95c1fb535cf080@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the cc to kernel-list, Ingo Molnar and Peter Zijlstra

Alexander Beregalov wrote:
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc1-00279-g28a4acb #13
> -------------------------------------------------------
> nfsd/3087 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<c016f947>] shrink_icache_memory+0x38/0x19b
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0210b83>] xfs_ilock+0xa2/0xd6
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&(&ip->i_iolock)->mr_lock){----}:
>        [<c01352e6>] __lock_acquire+0xa0c/0xbc6
>        [<c013550a>] lock_acquire+0x6a/0x86
>        [<c012c39a>] down_write_nested+0x33/0x6a
>        [<c0210b5c>] xfs_ilock+0x7b/0xd6
>        [<c0210cd5>] xfs_ireclaim+0x1d/0x59
>        [<c022edfe>] xfs_finish_reclaim+0x173/0x195
>        [<c0230fa3>] xfs_reclaim+0xb3/0x138
>        [<c023b4cb>] xfs_fs_clear_inode+0x55/0x8e
>        [<c016f60b>] clear_inode+0x83/0xd2
>        [<c016f88a>] dispose_list+0x3c/0xc1
>        [<c016fa82>] shrink_icache_memory+0x173/0x19b
>        [<c014a68d>] shrink_slab+0xda/0x14e
>        [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>        [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>        [<c0146b11>] __alloc_pages+0xa/0xc
>        [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>        [<c01484bc>] force_page_cache_readahead+0x4a/0x74
>        [<c014c9b0>] sys_madvise+0x308/0x400
>        [<c0102b25>] sysenter_past_esp+0x6a/0xb1
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (iprune_mutex){--..}:
>        [<c0135203>] __lock_acquire+0x929/0xbc6
>        [<c013550a>] lock_acquire+0x6a/0x86
>        [<c0356a6f>] mutex_lock_nested+0xb4/0x226
>        [<c016f947>] shrink_icache_memory+0x38/0x19b
>        [<c014a68d>] shrink_slab+0xda/0x14e
>        [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>        [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>        [<c0146b11>] __alloc_pages+0xa/0xc
>        [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>        [<c014866c>] ondemand_readahead+0x119/0x127
>        [<c01486cc>] page_cache_async_readahead+0x52/0x5d
>        [<c0178e46>] generic_file_splice_read+0x290/0x4a8
>        [<c0239f06>] xfs_splice_read+0x4b/0x78
>        [<c0237713>] xfs_file_splice_read+0x24/0x29
>        [<c0178182>] do_splice_to+0x45/0x63
>        [<c01783f6>] splice_direct_to_actor+0xab/0x150
>        [<c01ce8e1>] nfsd_vfs_read+0x1ed/0x2d0
>        [<c01ced50>] nfsd_read+0x82/0x99
>        [<c01d42bc>] nfsd3_proc_read+0xdf/0x12a
>        [<c01cb40b>] nfsd_dispatch+0xcf/0x19e
>        [<c033f484>] svc_process+0x3b3/0x68b
>        [<c01cb939>] nfsd+0x168/0x26b
>        [<c0103747>] kernel_thread_helper+0x7/0x10
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 3 locks held by nfsd/3087:
>  #0:  (hash_sem){..--}, at: [<c01d1538>] exp_readlock+0xd/0xf
>  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0210b83>] xfs_ilock+0xa2/0xd6
>  #2:  (shrinker_rwsem){----}, at: [<c014a5d7>] shrink_slab+0x24/0x14e
> 
> stack backtrace:
> Pid: 3087, comm: nfsd Not tainted 2.6.26-rc1-00279-g28a4acb #13
>  [<c0133498>] print_circular_bug_tail+0x5a/0x65
>  [<c0133d99>] ? print_circular_bug_header+0xa8/0xb3
>  [<c0135203>] __lock_acquire+0x929/0xbc6
>  [<c0106c1a>] ? native_sched_clock+0x8b/0x9f
>  [<c013550a>] lock_acquire+0x6a/0x86
>  [<c016f947>] ? shrink_icache_memory+0x38/0x19b
>  [<c0356a6f>] mutex_lock_nested+0xb4/0x226
>  [<c016f947>] ? shrink_icache_memory+0x38/0x19b
>  [<c016f947>] ? shrink_icache_memory+0x38/0x19b
>  [<c016f947>] shrink_icache_memory+0x38/0x19b
>  [<c014a68d>] shrink_slab+0xda/0x14e
>  [<c014a8e5>] try_to_free_pages+0x1e4/0x2a2
>  [<c03583c8>] ? _spin_unlock_irqrestore+0x36/0x58
>  [<c014982f>] ? isolate_pages_global+0x0/0x3e
>  [<c0146997>] __alloc_pages_internal+0x23a/0x39d
>  [<c0146b11>] __alloc_pages+0xa/0xc
>  [<c01483b2>] __do_page_cache_readahead+0xaa/0x16a
>  [<c014866c>] ondemand_readahead+0x119/0x127
>  [<c01486cc>] page_cache_async_readahead+0x52/0x5d
>  [<c0178e46>] generic_file_splice_read+0x290/0x4a8
>  [<c0358305>] ? _spin_unlock+0x27/0x3c
>  [<c0250e55>] ? _atomic_dec_and_lock+0x25/0x30
>  [<c016ed3f>] ? iput+0x24/0x4e
>  [<c0135484>] ? __lock_acquire+0xbaa/0xbc6
>  [<c01cb12a>] ? exportfs_decode_fh+0x9b/0x1a1
>  [<c0178245>] ? spd_release_page+0x0/0xf
>  [<c0239f06>] xfs_splice_read+0x4b/0x78
>  [<c0237713>] xfs_file_splice_read+0x24/0x29
>  [<c0178182>] do_splice_to+0x45/0x63
>  [<c01783f6>] splice_direct_to_actor+0xab/0x150
>  [<c01ce9c4>] ? nfsd_direct_splice_actor+0x0/0xf
>  [<c01ce8e1>] nfsd_vfs_read+0x1ed/0x2d0
>  [<c01ced50>] nfsd_read+0x82/0x99
>  [<c01d42bc>] nfsd3_proc_read+0xdf/0x12a
>  [<c01cb40b>] nfsd_dispatch+0xcf/0x19e
>  [<c033f484>] svc_process+0x3b3/0x68b
>  [<c01cb939>] nfsd+0x168/0x26b
>  [<c01cb7d1>] ? nfsd+0x0/0x26b
>  [<c0103747>] kernel_thread_helper+0x7/0x10
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
