Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbZJHVQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbZJHVQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZJHVP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:15:57 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:41234 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754968AbZJHVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:15:57 -0400
Date: Thu, 8 Oct 2009 17:08:23 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <20091008203724.GA15798@Krystal>
Message-ID: <alpine.DEB.1.10.0910081652190.8030@gentwo.org>
References: <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <1254988350.26976.256.camel@twins> <alpine.DEB.1.10.0910081211050.21951@gentwo.org>
 <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org> <20091008191754.GA12729@Krystal> <alpine.DEB.1.10.0910081520210.8030@gentwo.org> <20091008203724.GA15798@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Mathieu Desnoyers wrote:

> > Index: linux-2.6/mm/slub.c
> > ===================================================================
> > --- linux-2.6.orig/mm/slub.c	2009-10-08 11:35:59.000000000 -0500
> > +++ linux-2.6/mm/slub.c	2009-10-08 14:03:22.000000000 -0500
> > @@ -1606,7 +1606,14 @@ static void *__slab_alloc(struct kmem_ca
> >  			  unsigned long addr)
> >  {
> >  	void **object;
> > -	struct page *page = __this_cpu_read(s->cpu_slab->page);
> > +	struct page *page;
> > +	unsigned long flags;
> > +	int hotpath;
> > +
> > +	local_irq_save(flags);
>
> (Recommend adding)
>
> 	preempt_enable_no_resched();
>
>
> The preempt enable right in the middle of a big function is adding an
> unnecessary barrier(), which will restrain gcc from doing its
> optimizations.  This might hurt performances.

In the middle of the function we have determine that we have to go to the
page allocator to get more memory. There is not much the compiler can do
to speed that up.

> I still recommend the preempt_enable_no_resched() at the beginning of
> __slab_alloc(), and simply putting a check_resched() here (which saves
> us the odd compiler barrier in the middle of function).

Then preemption would be unnecessarily disabled for the page allocator
call?

> >  	if (gfpflags & __GFP_WAIT)
> >  		local_irq_enable();
> >
> > +	preempt_enable();
>
> We could replace the above by:
>
> if (gfpflags & __GFP_WAIT) {
> 	local_irq_enable();
> 	preempt_check_resched();
> }

Which would leave preempt off for the page allocator.

> > +	irqsafe_cpu_inc(s->cpu_slab->active);
> > +	barrier();
> >  	object = __this_cpu_read(s->cpu_slab->freelist);
> > -	if (unlikely(!object || !node_match(s, node)))
> > +	if (unlikely(!object || !node_match(s, node) ||
> > +			__this_cpu_read(s->cpu_slab->active)))
>
> Missing a barrier() here ?

The modifications of the s->cpu_slab->freelist in __slab_alloc() are only
done after interrupts have been disabled and after the slab has been locked.

> The idea is to let gcc know that "active" inc/dec and "freelist" reads
> must never be reordered. Even when the decrement is done in the slow
> path branch.

Right. How could that occur with this code?

> > +		preempt_enable();
> >  		stat(s, FREE_FASTPATH);
> > -	} else
> > +	} else {
>
> Perhaps missing a barrier() in the else ?

Not sure why that would be necessary. __slab_free() does not even touch
s->cpu_slab->freelist if you have the same reasons as in the alloc path.


