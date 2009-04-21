Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZDUKoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZDUKoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZDUKoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:44:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47882 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZDUKoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:44:05 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 05/25] Break up the allocator entry point into fast and slow paths
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421092912.GJ12713@csn.ul.ie>
References: <20090421150235.F12A.A69D9226@jp.fujitsu.com> <20090421092912.GJ12713@csn.ul.ie>
Message-Id: <20090421191918.F165.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 19:44:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  
> > > -	/* This allocation should allow future memory freeing. */
> > > -
> > > -rebalance:
> > > -	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> > > -			&& !in_interrupt()) {
> > > -		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> > > -nofail_alloc:
> > > -			/* go through the zonelist yet again, ignoring mins */
> > > -			page = get_page_from_freelist(gfp_mask, nodemask, order,
> > > -				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
> > > -			if (page)
> > > -				goto got_pg;
> > > -			if (gfp_mask & __GFP_NOFAIL) {
> > > -				congestion_wait(WRITE, HZ/50);
> > > -				goto nofail_alloc;
> > > -			}
> > > -		}
> > > -		goto nopage;
> > > -	}
> > > +	/* Allocate without watermarks if the context allows */
> > > +	if (is_allocation_high_priority(p, gfp_mask))
> > > +		page = __alloc_pages_high_priority(gfp_mask, order,
> > > +			zonelist, high_zoneidx, nodemask);
> > > +	if (page)
> > > +		goto got_pg;
> > >  
> > >  	/* Atomic allocations - we can't balance anything */
> > >  	if (!wait)
> > >  		goto nopage;
> > >  
> > 
> > old code is below.
> > if PF_MEMALLOC and !in_interrupt() and __GFP_NOMEMALLOC case,
> > old code jump to nopage, your one call reclaim.
> > 
> > I think, if the task have PF_MEMALLOC, it shouldn't call reclaim.
> > if not, endless reclaim recursion happend.
> > 
> > --------------------------------------------------------------------
> > rebalance:
> >         if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> >                         && !in_interrupt()) {
> >                 if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> > nofail_alloc:
> >                         /* go through the zonelist yet again, ignoring mins */
> >                         page = get_page_from_freelist(gfp_mask, nodemask, order,
> >                                 zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
> >                         if (page)
> >                                 goto got_pg;
> >                         if (gfp_mask & __GFP_NOFAIL) {
> >                                 congestion_wait(WRITE, HZ/50);
> >                                 goto nofail_alloc;
> >                         }
> >                 }
> >                 goto nopage;
> >         }
> > --------------------------------------------------------------------
> > 
> 
> I altered the modified version to look like
> 
> static inline int
> is_allocation_high_priority(struct task_struct *p, gfp_t gfp_mask)
> {
>         if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
>                         && !in_interrupt())
>                 return 1;
>         return 0;
> }
> 
> Note the check to __GFP_NOMEMALLOC is no longer there.
> 
> ....
> 
>         /* Allocate without watermarks if the context allows */
>         if (is_allocation_high_priority(p, gfp_mask)) {
> 		/* Do not dip into emergency reserves if specified */
>                 if (!(gfp_mask & __GFP_NOMEMALLOC)) {
>                         page = __alloc_pages_high_priority(gfp_mask, order,
>                                 zonelist, high_zoneidx, nodemask);
>                         if (page)
>                                 goto got_pg;
>                 }
> 
> 		/* Ensure no recursion into the allocator */
>                 goto nopage;
>         }
> 
> 
> Is that better?

nice.



> > >  	/* Atomic allocations - we can't balance anything */
> > >  	if (!wait)
> > >  		goto nopage;
> > >  
> > > -	cond_resched();
> > > -
> > > -	/* We now go into synchronous reclaim */
> > > -	cpuset_memory_pressure_bump();
> > > -
> > > -	p->flags |= PF_MEMALLOC;
> > > -
> > > -	lockdep_set_current_reclaim_state(gfp_mask);
> > > -	reclaim_state.reclaimed_slab = 0;
> > > -	p->reclaim_state = &reclaim_state;
> > > -
> > > -	did_some_progress = try_to_free_pages(zonelist, order,
> > > -						gfp_mask, nodemask);
> > > -
> > > -	p->reclaim_state = NULL;
> > > -	lockdep_clear_current_reclaim_state();
> > > -	p->flags &= ~PF_MEMALLOC;
> > > -
> > > -	cond_resched();
> > > +	/* Try direct reclaim and then allocating */
> > > +	page = __alloc_pages_direct_reclaim(gfp_mask, order,
> > > +					zonelist, high_zoneidx,
> > > +					nodemask,
> > > +					alloc_flags, &did_some_progress);
> > > +	if (page)
> > > +		goto got_pg;
> > >  
> > > -	if (order != 0)
> > > -		drain_all_pages();
> > > +	/*
> > > +	 * If we failed to make any progress reclaiming, then we are
> > > +	 * running out of options and have to consider going OOM
> > > +	 */
> > > +	if (!did_some_progress) {
> > > +		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> > > +			page = __alloc_pages_may_oom(gfp_mask, order,
> > > +					zonelist, high_zoneidx,
> > > +					nodemask);
> > > +			if (page)
> > > +				goto got_pg;
> > 
> > the old code here.
> > 
> > ------------------------------------------------------------------------
> >         } else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> >                 if (!try_set_zone_oom(zonelist, gfp_mask)) {
> >                         schedule_timeout_uninterruptible(1);
> >                         goto restart;
> >                 }
> > 
> >                 /*
> >                  * Go through the zonelist yet one more time, keep
> >                  * very high watermark here, this is only to catch
> >                  * a parallel oom killing, we must fail if we're still
> >                  * under heavy pressure.
> >                  */
> >                 page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
> >                         order, zonelist, high_zoneidx,
> >                         ALLOC_WMARK_HIGH|ALLOC_CPUSET);
> >                 if (page) {
> >                         clear_zonelist_oom(zonelist, gfp_mask);
> >                         goto got_pg;
> >                 }
> > 
> >                 /* The OOM killer will not help higher order allocs so fail */
> >                 if (order > PAGE_ALLOC_COSTLY_ORDER) {
> >                         clear_zonelist_oom(zonelist, gfp_mask);
> >                         goto nopage;
> >                 }
> > 
> >                 out_of_memory(zonelist, gfp_mask, order);
> >                 clear_zonelist_oom(zonelist, gfp_mask);
> >                 goto restart;
> >         }
> > ------------------------------------------------------------------------
> > 
> > if get_page_from_freelist() return NULL and order > PAGE_ALLOC_COSTLY_ORDER,
> > old code jump to nopage, your one jump to restart.
> > 
> 
> Good spot. The new section now looks like
> 
>                         page = __alloc_pages_may_oom(gfp_mask, order,
>                                         zonelist, high_zoneidx,
>                                         nodemask);
>                         if (page)
>                                 goto got_pg;
> 
>                         /*
>                          * The OOM killer does not trigger for high-order allocations
>                          * but if no progress is being made, there are no other
>                          * options and retrying is unlikely to help
>                          */
>                         if (order > PAGE_ALLOC_COSTLY_ORDER)
>                                 goto nopage;
> 
> Better?

very good.




> > > -	/*
> > > -	 * Don't let big-order allocations loop unless the caller explicitly
> > > -	 * requests that.  Wait for some write requests to complete then retry.
> > > -	 *
> > > -	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
> > > -	 * means __GFP_NOFAIL, but that may not be true in other
> > > -	 * implementations.
> > > -	 *
> > > -	 * For order > PAGE_ALLOC_COSTLY_ORDER, if __GFP_REPEAT is
> > > -	 * specified, then we retry until we no longer reclaim any pages
> > > -	 * (above), or we've reclaimed an order of pages at least as
> > > -	 * large as the allocation's order. In both cases, if the
> > > -	 * allocation still fails, we stop retrying.
> > > -	 */
> > > +	/* Check if we should retry the allocation */
> > >  	pages_reclaimed += did_some_progress;
> > > -	do_retry = 0;
> > > -	if (!(gfp_mask & __GFP_NORETRY)) {
> > > -		if (order <= PAGE_ALLOC_COSTLY_ORDER) {
> > > -			do_retry = 1;
> > > -		} else {
> > > -			if (gfp_mask & __GFP_REPEAT &&
> > > -				pages_reclaimed < (1 << order))
> > > -					do_retry = 1;
> > > -		}
> > > -		if (gfp_mask & __GFP_NOFAIL)
> > > -			do_retry = 1;
> > > -	}
> > > -	if (do_retry) {
> > > +	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
> > > +		/* Wait for some write requests to complete then retry */
> > >  		congestion_wait(WRITE, HZ/50);
> > > -		goto rebalance;
> > > +		goto restart;
> > 
> > this change rebalance to restart.
> > 
> 
> True, it's makes more sense to me sensible to goto restart at that point
> after waiting on IO to complete but it's a functional change and doesn't
> belong in this patch. I've fixed it up.
> 
> Very well spotted.

excellent.

thanks.


