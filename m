Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbZJEJqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbZJEJqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 05:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZJEJqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 05:46:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39474 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758748AbZJEJqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:46:00 -0400
Date: Mon, 5 Oct 2009 10:45:27 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 13/20] this_cpu_ops: page allocator conversion
Message-ID: <20091005094527.GB12681@csn.ul.ie>
References: <20091001212521.123389189@gentwo.org> <20091001212600.068637154@gentwo.org> <20091002151437.GP21906@csn.ul.ie> <alpine.DEB.1.10.0910021331020.26189@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910021331020.26189@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 01:39:28PM -0400, Christoph Lameter wrote:
> On Fri, 2 Oct 2009, Mel Gorman wrote:
> 
> > On Thu, Oct 01, 2009 at 05:25:34PM -0400, cl@linux-foundation.org wrote:
> > > Use the per cpu allocator functionality to avoid per cpu arrays in struct zone.
> > >
> > > This drastically reduces the size of struct zone for systems with large
> > > amounts of processors and allows placement of critical variables of struct
> > > zone in one cacheline even on very large systems.
> > >
> >
> > This seems reasonably accurate. The largest shrink is on !NUMA configured
> > systems but the NUMA case deletes a lot of pointers.
> 
> True, the !NUMA case will then avoid allocating pagesets for unused
> zones. But the NUMA case will have the most benefit since the large arrays
> in struct zone are gone.

Indeed. Out of curiousity, has this patchset been performance tested? I
would expect there to be a small but measurable improvement. If there is
a regression, it might point to poor placement of read/write fields in
the zone.

> Removing the pagesets from struct zone also
> increases the cacheability of struct zone information. This is
> particularly useful since the size of the pagesets grew with the addition
> of the various types of allocation queues.
> 
> > > Another effect is that the pagesets of one processor are placed near one
> > > another. If multiple pagesets from different zones fit into one cacheline
> > > then additional cacheline fetches can be avoided on the hot paths when
> > > allocating memory from multiple zones.
> > >
> >
> > Out of curiousity, how common an occurance is it that a CPU allocate from
> > multiple zones? I would have thought it was rare but I never checked
> > either.
> 
> zone allocations are determined by their use. GFP_KERNEL allocs come from
> ZONE_NORMAL whereas typical application pages may come from ZONE_HIGHMEM.
> The mix depends on what the kernel and the application are doing.
> 

I just wouldn't have expected a significant enough mix to make a measurable
performance difference. It's no biggie.

> > >  		pcp = &pset->pcp;
> > > +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> > >  	migratetype = get_pageblock_migratetype(page);
> > >  	set_page_private(page, migratetype);
> > >  	local_irq_save(flags);
> > > @@ -1133,7 +1133,6 @@ static void free_hot_cold_page(struct pa
> > >
> > >  out:
> > >  	local_irq_restore(flags);
> > > -	put_cpu();
> >
> > Previously we get_cpu() to be preemption safe. We then disable
> > interrupts and potentially take a spinlock later.
> 
> Right. WE need to move the local_irq_save() up two lines.

Just so I'm 100% clear, IRQ disabling is considered a preemption point?

> Why disable
> preempt and two instructions later disable interrupts? Isnt this bloating
> the code?
> 

By and large, IRQs are disabled at the last possible moment with the minimum
amount of code in between. While the current location does not make perfect
sense, it was probably many small changes that placed it like this each
person avoiding IRQ-disabling for too long without considering what the cost
of get_cpu() was.

Similar care needs to be taken with the other removals of get_cpu() in
this patch to ensure it's still preemption-safe.

> > this_cpu_ptr() looks up PCP
> > disable interrupts
> > enable interrupts
> 
> Move disable interrupts before the this_cpu_ptr?
> 

In this case, why not move this_cpu_ptr() down until its first use just
before the if (cold) check? It'll still be within the IRQ disabling but
without significantly increasing the amount of time the IRQ is disabled.

> > > +/*
> > > + * Allocate per cpu pagesets and initialize them.
> > > + * Before this call only boot pagesets were available.
> > > + * Boot pagesets will no longer be used after this call is complete.
> >
> > If they are no longer used, do we get the memory back?
> 
> No we need to keep them for onlining new processors.
> 

That comment would appear to disagree.

> > > -	 * as it comes online
> > > +		for_each_possible_cpu(cpu) {
> > > +			struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
> > > +
> > > +			setup_pageset(pcp, zone_batchsize(zone));
> > > +
> > > +			if (percpu_pagelist_fraction)
> > > +				setup_pagelist_highmark(pcp,
> > > +					(zone->present_pages /
> > > +						percpu_pagelist_fraction));
> > > +		}
> > > +	}
> >
> > This would have been easier to review if you left process_zones() where it
> > was and converted it to the new API. I'm assuming this is just shuffling
> > code around.
> 
> Yes I think this was the result of reducing #ifdefs.
> 

Ok.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
