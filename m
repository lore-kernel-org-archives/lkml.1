Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZCPQqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZCPQqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbZCPQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:45:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40255 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbZCPQp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:45:56 -0400
Date: Mon, 16 Mar 2009 16:45:50 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 24/35] Convert gfp_zone() to use a table of
	precalculated values
Message-ID: <20090316164550.GL24293@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-25-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161218170.32577@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903161218170.32577@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:19:06PM -0400, Christoph Lameter wrote:
> On Mon, 16 Mar 2009, Mel Gorman wrote:
> 
> > diff --git a/init/main.c b/init/main.c
> > index 8442094..08a5663 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -573,6 +573,7 @@ asmlinkage void __init start_kernel(void)
> >  	 * fragile until we cpu_idle() for the first time.
> >  	 */
> >  	preempt_disable();
> > +	init_gfp_zone_table();
> >  	build_all_zonelists();
> >  	page_alloc_init();
> >  	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index bc491fa..d76f57d 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -70,6 +70,7 @@ EXPORT_SYMBOL(node_states);
> >  unsigned long totalram_pages __read_mostly;
> >  unsigned long totalreserve_pages __read_mostly;
> >  unsigned long highest_memmap_pfn __read_mostly;
> > +int gfp_zone_table[GFP_ZONEMASK] __read_mostly;
> >  int static_num_online_nodes __read_mostly;
> >  int percpu_pagelist_fraction;
> >
> > @@ -4569,7 +4570,7 @@ static void setup_per_zone_inactive_ratio(void)
> >   * 8192MB:	11584k
> >   * 16384MB:	16384k
> >   */
> > -static int __init init_per_zone_pages_min(void)
> > +static int init_per_zone_pages_min(void)
> >  {
> >  	unsigned long lowmem_kbytes;
> >
> > @@ -4587,6 +4588,39 @@ static int __init init_per_zone_pages_min(void)
> >  }
> >  module_init(init_per_zone_pages_min)
> >
> > +static inline int __init gfp_flags_to_zone(gfp_t flags)
> > +{
> > +#ifdef CONFIG_ZONE_DMA
> > +	if (flags & __GFP_DMA)
> > +		return ZONE_DMA;
> > +#endif
> > +#ifdef CONFIG_ZONE_DMA32
> > +	if (flags & __GFP_DMA32)
> > +		return ZONE_DMA32;
> > +#endif
> > +	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
> > +			(__GFP_HIGHMEM | __GFP_MOVABLE))
> > +		return ZONE_MOVABLE;
> > +#ifdef CONFIG_HIGHMEM
> > +	if (flags & __GFP_HIGHMEM)
> > +		return ZONE_HIGHMEM;
> > +#endif
> > +	return ZONE_NORMAL;
> > +}
> > +
> > +/*
> > + * For each possible combination of zone modifier flags, we calculate
> > + * what zone it should be using. This consumes a cache line in most
> > + * cases but avoids a number of branches in the allocator fast path
> > + */
> > +void __init init_gfp_zone_table(void)
> > +{
> > +	gfp_t gfp_flags;
> > +
> > +	for (gfp_flags = 0; gfp_flags < GFP_ZONEMASK; gfp_flags++)
> > +		gfp_zone_table[gfp_flags] = gfp_flags_to_zone(gfp_flags);
> > +}
> > +
> 
> This is all known at compile time. The table can be calculated at compile
> time with some ifdefs and then we do not need the init_gfp_zone_table().
> 

The last discussion didn't come up with something that could generate such
a table and still be correct in all cases. I guess someone could do it all
by hand but it was going to be an error prone exercise. I left the patch
as-is as a result.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
