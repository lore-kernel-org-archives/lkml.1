Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZJLN4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZJLN4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbZJLN4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:56:50 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:63939 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355AbZJLN4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:56:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAN3S0kpMROOX/2dsb2JhbACBUdUzgjOBegQ
Date: Mon, 12 Oct 2009 09:56:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091012135600.GB15605@Krystal>
References: <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <1254988350.26976.256.camel@twins> <alpine.DEB.1.10.0910081211050.21951@gentwo.org> <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org> <20091008191754.GA12729@Krystal> <alpine.DEB.1.10.0910081520210.8030@gentwo.org> <20091008203724.GA15798@Krystal> <alpine.DEB.1.10.0910081652190.8030@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910081652190.8030@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:23:43 up 55 days, 13 min,  3 users,  load average: 0.35, 0.23,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Thu, 8 Oct 2009, Mathieu Desnoyers wrote:
> 
> > > Index: linux-2.6/mm/slub.c
> > > ===================================================================
> > > --- linux-2.6.orig/mm/slub.c	2009-10-08 11:35:59.000000000 -0500
> > > +++ linux-2.6/mm/slub.c	2009-10-08 14:03:22.000000000 -0500
> > > @@ -1606,7 +1606,14 @@ static void *__slab_alloc(struct kmem_ca
> > >  			  unsigned long addr)
> > >  {
> > >  	void **object;
> > > -	struct page *page = __this_cpu_read(s->cpu_slab->page);
> > > +	struct page *page;
> > > +	unsigned long flags;
> > > +	int hotpath;
> > > +
> > > +	local_irq_save(flags);
> >
> > (Recommend adding)
> >
> > 	preempt_enable_no_resched();
> >
> >
> > The preempt enable right in the middle of a big function is adding an
> > unnecessary barrier(), which will restrain gcc from doing its
> > optimizations.  This might hurt performances.
> 
> In the middle of the function we have determine that we have to go to the
> page allocator to get more memory. There is not much the compiler can do
> to speed that up.

Indeed, the compiler cannot do much about it. However, the programer
(you) can move the preempt_enable_no_resched() part of the
preempt_enable() to the beginning of the function.

> 
> > I still recommend the preempt_enable_no_resched() at the beginning of
> > __slab_alloc(), and simply putting a check_resched() here (which saves
> > us the odd compiler barrier in the middle of function).
> 
> Then preemption would be unnecessarily disabled for the page allocator
> call?

No ?
preempt_enable_no_resched() enables preemption.

> 
> > >  	if (gfpflags & __GFP_WAIT)
> > >  		local_irq_enable();
> > >
> > > +	preempt_enable();
> >
> > We could replace the above by:
> >
> > if (gfpflags & __GFP_WAIT) {
> > 	local_irq_enable();
> > 	preempt_check_resched();
> > }
> 
> Which would leave preempt off for the page allocator.

Not if you do preempt_enable_no_resched() at the beginnig of the
function, after disabling interrupts.

> 
> > > +	irqsafe_cpu_inc(s->cpu_slab->active);
> > > +	barrier();
> > >  	object = __this_cpu_read(s->cpu_slab->freelist);
> > > -	if (unlikely(!object || !node_match(s, node)))
> > > +	if (unlikely(!object || !node_match(s, node) ||
> > > +			__this_cpu_read(s->cpu_slab->active)))
> >
> > Missing a barrier() here ?
> 
> The modifications of the s->cpu_slab->freelist in __slab_alloc() are only
> done after interrupts have been disabled and after the slab has been locked.

I was concerned about a potential race between
cpu_slab->active/cpu_slab->freelist if an interrupt came in. I
understand that as soon as you get a hint that you must hit the slow
path, you don't care about the order in which these operations have been
done.

> 
> > The idea is to let gcc know that "active" inc/dec and "freelist" reads
> > must never be reordered. Even when the decrement is done in the slow
> > path branch.
> 
> Right. How could that occur with this code?
> 

__slab_alloc calls __this_cpu_dec(s->cpu_slab->active); without any
compiler barrier. But I get that when __slab_alloc is executed, we don't
care about "active" dec to be reordered, because we're not altering fast
path data anymore.

> > > +		preempt_enable();
> > >  		stat(s, FREE_FASTPATH);
> > > -	} else
> > > +	} else {
> >
> > Perhaps missing a barrier() in the else ?
> 
> Not sure why that would be necessary. __slab_free() does not even touch
> s->cpu_slab->freelist if you have the same reasons as in the alloc path.

My intent was to order __this_cpu_read(s->cpu_slab->page) and
irqsafe_cpu_dec(s->cpu_slab->active), but I get that if you run the slow
path, you don't care about some spilling of the slow path over the slab
active critical section.

Thanks,

Mathieu

> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
