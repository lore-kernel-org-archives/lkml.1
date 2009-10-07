Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZJGCzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZJGCzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZJGCzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:55:24 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:48712 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbZJGCzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:55:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsFAMuZy0pMROOX/2dsb2JhbACBUtNRhCoE
Date: Tue, 6 Oct 2009 22:54:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091007025440.GB4664@Krystal>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091006233733.153341605@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 22:35:46 up 49 days, 13:25,  3 users,  load average: 0.26, 0.27,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* cl@linux-foundation.org (cl@linux-foundation.org) wrote:
> This is a bit of a different tack on things than the last version provided
> by Matheiu.
> 

Hi Christoph,

Btw, my name is "Math-ieu" ;) I'm not offended by you fat-fingering my
name, it's just rather funny. :)

Please see comments below,

> Instead of using a cmpxchg we keep a state variable in the per cpu structure
> that is incremented when we enter the hot path. We can then detect that
> a thread is in the fastpath and fall back to alternate allocation / free
> technique that bypasses fastpath caching.
> 
> A disadvantage is that we have to disable preempt. But if preemt is disabled
> (like on most kernels that I run) then the hotpath becomes very efficient.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> 
> ---
>  include/linux/slub_def.h |    1 
>  mm/slub.c                |   91 +++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 74 insertions(+), 18 deletions(-)
> 
> Index: linux-2.6/include/linux/slub_def.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slub_def.h	2009-10-01 15:53:15.000000000 -0500
> +++ linux-2.6/include/linux/slub_def.h	2009-10-01 15:53:15.000000000 -0500
> @@ -38,6 +38,7 @@ struct kmem_cache_cpu {
>  	void **freelist;	/* Pointer to first free per cpu object */
>  	struct page *page;	/* The slab from which we are allocating */
>  	int node;		/* The node of the page (or -1 for debug) */
> +	int active;		/* Active fastpaths */
>  #ifdef CONFIG_SLUB_STATS
>  	unsigned stat[NR_SLUB_STAT_ITEMS];
>  #endif
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2009-10-01 15:53:15.000000000 -0500
> +++ linux-2.6/mm/slub.c	2009-10-01 15:53:15.000000000 -0500
> @@ -1606,7 +1606,14 @@ static void *__slab_alloc(struct kmem_ca
>  			  unsigned long addr)
>  {
>  	void **object;
> -	struct page *page = __this_cpu_read(s->cpu_slab->page);
> +	struct page *page;
> +	unsigned long flags;
> +	int hotpath;
> +
> +	local_irq_save(flags);
> +	preempt_enable();	/* Get rid of count */

Ugh ? Is that legit ?

check preempt in irq off context might have weird side-effects on
scheduler real-time behavior (at least). You end up quitting a preempt
off section in irq off mode. So the sched check is skipped, and later
you only re-enable interrupts, which depends on having had a timer
interrupt waiting on the interrupt line to ensure scheduler timings.
But if the timer interrupt arrived while you were in the preempt off
section, you're doomed. The scheduler will not be woken up at interrupt
enable.

> +	hotpath = __this_cpu_read(s->cpu_slab->active) != 0;
> +	page = __this_cpu_read(s->cpu_slab->page);
>  
>  	/* We handle __GFP_ZERO in the caller */
>  	gfpflags &= ~__GFP_ZERO;
> @@ -1626,13 +1633,21 @@ load_freelist:
>  		goto another_slab;
>  	if (unlikely(SLABDEBUG && PageSlubDebug(page)))
>  		goto debug;
> -
> -	__this_cpu_write(s->cpu_slab->freelist, get_freepointer(s, object));
> -	page->inuse = page->objects;
> -	page->freelist = NULL;
> -	__this_cpu_write(s->cpu_slab->node, page_to_nid(page));
> +	if (unlikely(hotpath)) {
> +		/* Object on second free list available and hotpath busy */
> +		page->inuse++;
> +		page->freelist = get_freepointer(s, object);
> +	} else {
> +		/* Prepare new list of objects for hotpath */
> +		__this_cpu_write(s->cpu_slab->freelist, get_freepointer(s, object));
> +		page->inuse = page->objects;
> +		page->freelist = NULL;
> +		__this_cpu_write(s->cpu_slab->node, page_to_nid(page));
> +	}
>  unlock_out:
> +	__this_cpu_dec(s->cpu_slab->active);
>  	slab_unlock(page);
> +	local_irq_restore(flags);
>  	stat(s, ALLOC_SLOWPATH);
>  	return object;
>  
> @@ -1642,8 +1657,12 @@ another_slab:
>  new_slab:
>  	page = get_partial(s, gfpflags, node);
>  	if (page) {
> -		__this_cpu_write(s->cpu_slab->page, page);
>  		stat(s, ALLOC_FROM_PARTIAL);
> +
> +		if (hotpath)
> +			goto hot_lock;
> +
> +		__this_cpu_write(s->cpu_slab->page, page);
>  		goto load_freelist;
>  	}
>  
> @@ -1657,6 +1676,10 @@ new_slab:
>  
>  	if (page) {
>  		stat(s, ALLOC_SLAB);
> +
> +		if (hotpath)
> +			 goto hot_no_lock;
> +
>  		if (__this_cpu_read(s->cpu_slab->page))
>  			flush_slab(s, __this_cpu_ptr(s->cpu_slab));
>  		slab_lock(page);
> @@ -1664,6 +1687,10 @@ new_slab:
>  		__this_cpu_write(s->cpu_slab->page, page);
>  		goto load_freelist;
>  	}
> +
> +	__this_cpu_dec(s->cpu_slab->active);
> +	local_irq_restore(flags);
> +
>  	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
>  		slab_out_of_memory(s, gfpflags, node);
>  	return NULL;
> @@ -1675,6 +1702,19 @@ debug:
>  	page->freelist = get_freepointer(s, object);
>  	__this_cpu_write(s->cpu_slab->node, -1);
>  	goto unlock_out;
> +
> +	/*
> +	 * Hotpath is busy and we need to avoid touching
> +	 * hotpath variables
> +	 */
> +hot_no_lock:
> +	slab_lock(page);
> +hot_lock:
> +	__ClearPageSlubFrozen(page);
> +	if (get_freepointer(s, page->freelist))
> +		/* Cannot put page into the hotpath. Instead back to partial */
> +		add_partial(get_node(s, page_to_nid(page)), page, 0);
> +	goto load_freelist;
>  }
>  
>  /*
> @@ -1691,7 +1731,6 @@ static __always_inline void *slab_alloc(
>  		gfp_t gfpflags, int node, unsigned long addr)
>  {
>  	void **object;
> -	unsigned long flags;
>  
>  	gfpflags &= gfp_allowed_mask;
>  
> @@ -1701,19 +1740,21 @@ static __always_inline void *slab_alloc(
>  	if (should_failslab(s->objsize, gfpflags))
>  		return NULL;
>  
> -	local_irq_save(flags);
> +	preempt_disable();
> +	irqsafe_cpu_inc(s->cpu_slab->active);
>  	object = __this_cpu_read(s->cpu_slab->freelist);
> -	if (unlikely(!object || !node_match(s, node)))
> +	if (unlikely(!object || !node_match(s, node) ||
> +			__this_cpu_read(s->cpu_slab->active)))

Interesting approach ! I just wonder about the impact of the
irq off / preempt enable dance.

Mathieu

>  
>  		object = __slab_alloc(s, gfpflags, node, addr);
>  
>  	else {
>  		__this_cpu_write(s->cpu_slab->freelist,
>  			get_freepointer(s, object));
> +		irqsafe_cpu_dec(s->cpu_slab->active);
> +		preempt_enable();
>  		stat(s, ALLOC_FASTPATH);
>  	}
> -	local_irq_restore(flags);
> -
>  	if (unlikely((gfpflags & __GFP_ZERO) && object))
>  		memset(object, 0, s->objsize);
>  
> @@ -1777,6 +1818,11 @@ static void __slab_free(struct kmem_cach
>  {
>  	void *prior;
>  	void **object = (void *)x;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	preempt_enable();	/* Fix up count */
> +	__this_cpu_dec(s->cpu_slab->active);
>  
>  	stat(s, FREE_SLOWPATH);
>  	slab_lock(page);
> @@ -1809,6 +1855,7 @@ checks_ok:
>  
>  out_unlock:
>  	slab_unlock(page);
> +	local_irq_restore(flags);
>  	return;
>  
>  slab_empty:
> @@ -1820,6 +1867,7 @@ slab_empty:
>  		stat(s, FREE_REMOVE_PARTIAL);
>  	}
>  	slab_unlock(page);
> +	local_irq_restore(flags);
>  	stat(s, FREE_SLAB);
>  	discard_slab(s, page);
>  	return;
> @@ -1845,24 +1893,26 @@ static __always_inline void slab_free(st
>  			struct page *page, void *x, unsigned long addr)
>  {
>  	void **object = (void *)x;
> -	unsigned long flags;
>  
>  	kmemleak_free_recursive(x, s->flags);
> -	local_irq_save(flags);
>  	kmemcheck_slab_free(s, object, s->objsize);
>  	debug_check_no_locks_freed(object, s->objsize);
>  	if (!(s->flags & SLAB_DEBUG_OBJECTS))
>  		debug_check_no_obj_freed(object, s->objsize);
>  
> +	preempt_disable();
> +	irqsafe_cpu_inc(s->cpu_slab->active);
>  	if (likely(page == __this_cpu_read(s->cpu_slab->page) &&
> -			__this_cpu_read(s->cpu_slab->node) >= 0)) {
> -		set_freepointer(s, object, __this_cpu_read(s->cpu_slab->freelist));
> +			__this_cpu_read(s->cpu_slab->node) >= 0) &&
> +			!__this_cpu_read(s->cpu_slab->active)) {
> +		set_freepointer(s, object,
> +			__this_cpu_read(s->cpu_slab->freelist));
>  		__this_cpu_write(s->cpu_slab->freelist, object);
> +		irqsafe_cpu_dec(s->cpu_slab->active);
> +		preempt_enable();
>  		stat(s, FREE_FASTPATH);
>  	} else
>  		__slab_free(s, page, x, addr);
> -
> -	local_irq_restore(flags);
>  }
>  
>  void kmem_cache_free(struct kmem_cache *s, void *x)
> @@ -2064,6 +2114,8 @@ static DEFINE_PER_CPU(struct kmem_cache_
>  
>  static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
>  {
> +	int cpu;
> +
>  	if (s < kmalloc_caches + KMALLOC_CACHES && s >= kmalloc_caches)
>  		/*
>  		 * Boot time creation of the kmalloc array. Use static per cpu data
> @@ -2073,6 +2125,9 @@ static inline int alloc_kmem_cache_cpus(
>  	else
>  		s->cpu_slab =  alloc_percpu(struct kmem_cache_cpu);
>  
> +	for_each_possible_cpu(cpu)
> +		per_cpu_ptr(s->cpu_slab, cpu)->active = -1;
> +
>  	if (!s->cpu_slab)
>  		return 0;
>  
> 
> -- 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
