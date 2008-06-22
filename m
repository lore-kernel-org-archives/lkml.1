Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYFVWTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYFVWTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYFVWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:19:35 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:7547 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801AbYFVWTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:19:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANNqXkh5LG+u/2dsb2JhbACtQg
X-IronPort-AV: E=Sophos;i="4.27,686,1204464600"; 
   d="scan'208";a="132492337"
Date: Mon, 23 Jun 2008 08:19:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd
	hangs for a few sec)...
Message-ID: <20080622221930.GA11558@disturbed>
Mail-Followup-To: Daniel J Blueman <daniel.blueman@gmail.com>,
	Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com> <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added xfs@oss.sgi.com to cc]

On Sun, Jun 22, 2008 at 10:58:56AM +0100, Daniel J Blueman wrote:
> I'm seeing a similar issue [2] to what was recently reported [1] by
> Alexander, but with another workload involving XFS and memory
> pressure.
> 
> SLUB allocator is in use and config is at http://quora.org/config-client-debug .
> 
> Let me know if you'd like more details/vmlinux objdump etc.
> 
> Thanks,
>  Daniel
> 
> --- [1]
> 
> http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/e673c9173d45a735/db9213ef39e4e11c
> 
> --- [2]
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc7-210c #2
> -------------------------------------------------------
> AutopanoPro/4470 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290
> 
> but task is already holding lock:
>  (&mm->mmap_sem){----}, at: [<ffffffff805e3e15>] do_page_fault+0x255/0x890
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&mm->mmap_sem){----}:
>       [<ffffffff80278f4d>] __lock_acquire+0xbdd/0x1020
>       [<ffffffff802793f5>] lock_acquire+0x65/0x90
>       [<ffffffff805df5ab>] down_read+0x3b/0x70
>       [<ffffffff805e3e3c>] do_page_fault+0x27c/0x890
>       [<ffffffff805e16cd>] error_exit+0x0/0xa9
>       [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #1 (&(&ip->i_iolock)->mr_lock){----}:
>       [<ffffffff80278f4d>] __lock_acquire+0xbdd/0x1020
>       [<ffffffff802793f5>] lock_acquire+0x65/0x90
>       [<ffffffff8026d746>] down_write_nested+0x46/0x80
>       [<ffffffff8039df29>] xfs_ilock+0x99/0xa0
>       [<ffffffff8039e0cf>] xfs_ireclaim+0x3f/0x90
>       [<ffffffff803ba889>] xfs_finish_reclaim+0x59/0x1a0
>       [<ffffffff803bc199>] xfs_reclaim+0x109/0x110
>       [<ffffffff803c9541>] xfs_fs_clear_inode+0xe1/0x110
>       [<ffffffff802d906d>] clear_inode+0x7d/0x110
>       [<ffffffff802d93aa>] dispose_list+0x2a/0x100
>       [<ffffffff802d96af>] shrink_icache_memory+0x22f/0x290
>       [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
>       [<ffffffff8029e0b6>] kswapd+0x3b6/0x560
>       [<ffffffff8026921d>] kthread+0x4d/0x80
>       [<ffffffff80227428>] child_rip+0xa/0x12
>       [<ffffffffffffffff>] 0xffffffffffffffff

You may as well ignore anything invlving this path in XFS until
lockdep gets fixed. The kswapd reclaim path is inverted over the
synchronous reclaim path that is xfs_ilock -> run out of memory ->
prune_icache and then potentially another -> xfs_ilock.

In this case, XFS can *never* deadlock because the second xfs_ilock
is on a different, unreferenced, unlocked inode, but without turning
off lockdep there is nothing in XFS that can be done to prevent
this warning.

Therxp eis a similar bug in the VM w.r.t the mmap_sem in that the
mmap_sem is held across a call to put_filp() which can result in
inversions between the xfs_ilock and mmap_sem.

Both of these cases cannot be solved by changing XFS - lockdep
needs to be made aware of paths that can invert normal locking
order (like prune_icache) so it doesn't give false positives
like this.

> -> #0 (iprune_mutex){--..}:
>       [<ffffffff80278db7>] __lock_acquire+0xa47/0x1020
>       [<ffffffff802793f5>] lock_acquire+0x65/0x90
>       [<ffffffff805dedd5>] mutex_lock_nested+0xb5/0x300
>       [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290
>       [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
>       [<ffffffff8029db38>] try_to_free_pages+0x268/0x3a0
>       [<ffffffff802979d6>] __alloc_pages_internal+0x206/0x4b0
>       [<ffffffff80297c89>] __alloc_pages_nodemask+0x9/0x10
>       [<ffffffff802b2bc2>] alloc_page_vma+0x72/0x1b0
>       [<ffffffff802a3642>] handle_mm_fault+0x462/0x7b0
>       [<ffffffff805e3ecc>] do_page_fault+0x30c/0x890
>       [<ffffffff805e16cd>] error_exit+0x0/0xa9
>       [<ffffffffffffffff>] 0xffffffffffffffff

This case is different in that it įs complaining about mmap_sem vs
iprune_mutex, so I think that we can pretty much ignore the XFS side
of things here - the problem is higher level code....

>  [<ffffffff8029db38>] try_to_free_pages+0x268/0x3a0
>  [<ffffffff8029c240>] ? isolate_pages_global+0x0/0x40
>  [<ffffffff802979d6>] __alloc_pages_internal+0x206/0x4b0
>  [<ffffffff80297c89>] __alloc_pages_nodemask+0x9/0x10
>  [<ffffffff802b2bc2>] alloc_page_vma+0x72/0x1b0
>  [<ffffffff802a3642>] handle_mm_fault+0x462/0x7b0

FWIW, should page allocation in a page fault be allowed to recurse
into the filesystem? If I follow the spaghetti of inline and
compiler inlined functions correctly, this is a GFP_HIGHUSER_MOVABLE
allocation, right? Should we be allowing shrink_icache_memory()
to be called at all in the page fault path?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
