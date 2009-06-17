Return-Path: <linux-kernel-owner+w=401wt.eu-S932818AbZFQLlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbZFQLlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbZFQLli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:41:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56792 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbZFQLlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:41:37 -0400
Date: Wed, 17 Jun 2009 12:41:36 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at mm/page_alloc.c:1159
	get_page_from_freelist+0x325/0x655()
Message-ID: <20090617114136.GA28529@csn.ul.ie>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org> <20090616223649.719ea378.akpm@linux-foundation.org> <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090617113120.GA5061@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:31:20PM +0200, Ingo Molnar wrote:
> 
> a new warning started popping up today, in the new page allocator 
> code. The allocation came from kmemleak:
> 

This is not my changes as such. As part of another discussion, a warning
was added for high-order __GFP_NOFAIL allocations. The changelog for
commit dab48dab37d2770824420d1e01730a107fade1aa [page-allocator: warn if
__GFP_NOFAIL is used for a large allocation] has more details.

> WARNING: at mm/page_alloc.c:1159 get_page_from_freelist+0x325/0x655()
> Hardware name: System Product Name
> Modules linked in:
> Pid: 4367, comm: ifup Not tainted 2.6.30-tip-04303-g5ada65e-dirty #54431
> Call Trace:
>  [<ffffffff810dba73>] ? get_page_from_freelist+0x325/0x655
>  [<ffffffff8106f140>] warn_slowpath_common+0x88/0xcb
>  [<ffffffff8106f1a5>] warn_slowpath_null+0x22/0x38
>  [<ffffffff810dba73>] get_page_from_freelist+0x325/0x655
>  [<ffffffff810dc18c>] __alloc_pages_nodemask+0x14c/0x5b0
>  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
>  [<ffffffff8103b1c8>] ? native_sched_clock+0x40/0x79
>  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
>  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
>  [<ffffffff81102417>] alloc_pages_current+0xcc/0xeb
>  [<ffffffff81107a78>] alloc_slab_page+0x2a/0x7e
>  [<ffffffff81107b27>] new_slab+0x5b/0x210
>  [<ffffffff811063fa>] ? deactivate_slab+0xe7/0x16b
>  [<ffffffff81108253>] __slab_alloc+0x214/0x3da
>  [<ffffffff8110f58d>] ? kmemleak_alloc+0x83/0x35a
>  [<ffffffff8110f58d>] ? kmemleak_alloc+0x83/0x35a
>  [<ffffffff8110863c>] kmem_cache_alloc+0xac/0x14e
>  [<ffffffff8110f58d>] kmemleak_alloc+0x83/0x35a
>  [<ffffffff812b6436>] ? cfq_get_queue+0x101/0x231

No super sure who is responsible here but could you check
/proc/slabinfo. Is cfq_queue now requiring high-order allocations for
its slabs?

>  [<ffffffff81108511>] kmem_cache_alloc_node+0xf8/0x177
>  [<ffffffff812b6436>] ? cfq_get_queue+0x101/0x231
>  [<ffffffff812b6436>] cfq_get_queue+0x101/0x231
>  [<ffffffff81847362>] ? _spin_lock_irqsave+0x7f/0xa1
>  [<ffffffff812b68b1>] cfq_set_request+0x2a0/0x34c
>  [<ffffffff812a390a>] elv_set_request+0x29/0x4e
>  [<ffffffff812a7e3b>] get_request+0x208/0x2ea
>  [<ffffffff812a8101>] ? __make_request+0x48/0x3c8
>  [<ffffffff812a7f54>] get_request_wait+0x37/0x19c
>  [<ffffffff812a8101>] ? __make_request+0x48/0x3c8
>  [<ffffffff812a8332>] __make_request+0x279/0x3c8
>  [<ffffffff812a6385>] generic_make_request+0x2ed/0x352
>  [<ffffffff812a64bf>] submit_bio+0xd5/0xf2
>  [<ffffffff81137aa8>] submit_bh+0x110/0x14a
>  [<ffffffff81139982>] ll_rw_block+0xc4/0x120
>  [<ffffffff81180bde>] ext3_bread+0x47/0x87
>  [<ffffffff81183f4f>] ext3_find_entry+0x13a/0x5f2
>  [<ffffffff8109999b>] ? __lock_acquire+0x1f2/0x40e
>  [<ffffffff81125ed3>] ? d_alloc+0x19c/0x1ef
>  [<ffffffff81098d7f>] ? lock_release_holdtime+0x3f/0x14c
>  [<ffffffff81125ed3>] ? d_alloc+0x19c/0x1ef
>  [<ffffffff81184cbd>] ext3_lookup+0x43/0x10c
>  [<ffffffff8111b7cf>] do_lookup+0xe4/0x182
>  [<ffffffff8111c652>] __link_path_walk+0x667/0x7d3
>  [<ffffffff8111cdc1>] path_walk+0x78/0xf7
>  [<ffffffff8111e157>] do_path_lookup+0x39/0xac
>  [<ffffffff8111fa5f>] user_path_at+0x61/0xaf
>  [<ffffffff8112c0c1>] ? mntput_no_expire+0x33/0xdb
>  [<ffffffff81116230>] ? cp_new_stat+0xf8/0x119
>  [<ffffffff8111645c>] vfs_fstatat+0x44/0x85
>  [<ffffffff81116622>] vfs_stat+0x29/0x3f
>  [<ffffffff81116661>] sys_newstat+0x29/0x5e
>  [<ffffffff818469c8>] ? lockdep_sys_exit_thunk+0x35/0x67
>  [<ffffffff81032f02>] system_call_fastpath+0x16/0x1b
> ---[ end trace 2fb5866b65128972 ]---
>  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
