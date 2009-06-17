Return-Path: <linux-kernel-owner+w=401wt.eu-S1765489AbZFQM2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765489AbZFQM2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZFQM2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:28:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50657 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbZFQM2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:28:02 -0400
Date: Wed, 17 Jun 2009 13:28:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at mm/page_alloc.c:1159
	get_page_from_freelist+0x325/0x655()
Message-ID: <20090617122803.GD28529@csn.ul.ie>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org> <20090616223649.719ea378.akpm@linux-foundation.org> <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu> <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:11:17PM +0100, Catalin Marinas wrote:
> On Wed, 2009-06-17 at 13:31 +0200, Ingo Molnar wrote:
> > a new warning started popping up today, in the new page allocator 
> > code. The allocation came from kmemleak:
> > 
> > WARNING: at mm/page_alloc.c:1159 get_page_from_freelist+0x325/0x655()
> > Hardware name: System Product Name
> > Modules linked in:
> > Pid: 4367, comm: ifup Not tainted 2.6.30-tip-04303-g5ada65e-dirty #54431
> > Call Trace:
> >  [<ffffffff810dba73>] ? get_page_from_freelist+0x325/0x655
> >  [<ffffffff8106f140>] warn_slowpath_common+0x88/0xcb
> >  [<ffffffff8106f1a5>] warn_slowpath_null+0x22/0x38
> >  [<ffffffff810dba73>] get_page_from_freelist+0x325/0x655
> >  [<ffffffff810dc18c>] __alloc_pages_nodemask+0x14c/0x5b0
> >  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
> >  [<ffffffff8103b1c8>] ? native_sched_clock+0x40/0x79
> >  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
> >  [<ffffffff811063e1>] ? deactivate_slab+0xce/0x16b
> >  [<ffffffff81102417>] alloc_pages_current+0xcc/0xeb
> >  [<ffffffff81107a78>] alloc_slab_page+0x2a/0x7e
> >  [<ffffffff81107b27>] new_slab+0x5b/0x210
> >  [<ffffffff811063fa>] ? deactivate_slab+0xe7/0x16b
> >  [<ffffffff81108253>] __slab_alloc+0x214/0x3da
> >  [<ffffffff8110f58d>] ? kmemleak_alloc+0x83/0x35a
> >  [<ffffffff8110f58d>] ? kmemleak_alloc+0x83/0x35a
> >  [<ffffffff8110863c>] kmem_cache_alloc+0xac/0x14e
> >  [<ffffffff8110f58d>] kmemleak_alloc+0x83/0x35a
> >  [<ffffffff812b6436>] ? cfq_get_queue+0x101/0x231
> >  [<ffffffff81108511>] kmem_cache_alloc_node+0xf8/0x177
> >  [<ffffffff812b6436>] ? cfq_get_queue+0x101/0x231
> >  [<ffffffff812b6436>] cfq_get_queue+0x101/0x231
> 
> Kmemleak needs to allocate memory for the pointer tracing and it
> currently passes the same gfp flags as those used by the original
> caller. In this case cfq_find_alloc_queue uses __GFP_NOFAIL.
> 
> The reason for this was to avoid GFP_ATOMIC if the caller wasn't
> requiring it. I think the approach below is better:
> 

How about defining a GFP_SLAB_KMEMLEAK_MASK the subset of flags that kmemleak
should use? Based on this patch, the following appears to be it's definition.

__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HIGH

> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 58ec86c..46c9c93 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -462,7 +462,7 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
>  	struct prio_tree_node *node;
>  	struct stack_trace trace;
>  
> -	object = kmem_cache_alloc(object_cache, gfp & ~GFP_SLAB_BUG_MASK);
> +	object = kmem_cache_alloc(object_cache, gfp & (GFP_KERNEL | GFP_ATOMIC));
>  	if (!object) {
>  		kmemleak_panic("kmemleak: Cannot allocate a kmemleak_object "
>  			       "structure\n");
> @@ -636,7 +636,7 @@ static void add_scan_area(unsigned long ptr, unsigned long offset,
>  		return;
>  	}
>  
> -	area = kmem_cache_alloc(scan_area_cache, gfp & ~GFP_SLAB_BUG_MASK);
> +	area = kmem_cache_alloc(scan_area_cache, gfp & (GFP_KERNEL | GFP_ATOMIC));
>  	if (!area) {
>  		kmemleak_warn("kmemleak: Cannot allocate a scan area\n");
>  		goto out;
> 
> -- 
> Catalin
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
