Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZGGQy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZGGQy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZGGQyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:54:19 -0400
Received: from cmpxchg.org ([85.214.51.133]:33825 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbZGGQyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:54:19 -0400
Date: Tue, 7 Jul 2009 18:53:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem allocator
Message-ID: <20090707165350.GA2782@cmpxchg.org>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com> <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com> <1246950530.24285.7.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246950530.24285.7.camel@penberg-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 10:08:50AM +0300, Pekka Enberg wrote:
> On Mon, 2009-07-06 at 11:51 +0100, Catalin Marinas wrote:
> > This patch adds kmemleak_alloc/free callbacks to the bootmem allocator.
> > This would allow scanning of such blocks and help avoiding a whole class
> > of false positives and more kmemleak annotations.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Looks good to me!
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> But lets cc Johannes on this too.

> > @@ -597,7 +601,9 @@ restart:
> >  void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
> >  					unsigned long goal)
> >  {
> > -	return ___alloc_bootmem_nopanic(size, align, goal, 0);
> > +	void *ptr =  ___alloc_bootmem_nopanic(size, align, goal, 0);
> > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > +	return ptr;

You may get an object from kzalloc() here, I don't think you want to
track that (again), right?

Pekka already worked out all the central places to catch 'slab already
available' allocations, they can probably help you place the hooks.

> >  static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
> > @@ -631,7 +637,9 @@ static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
> >  void * __init __alloc_bootmem(unsigned long size, unsigned long align,
> >  			      unsigned long goal)
> >  {
> > -	return ___alloc_bootmem(size, align, goal, 0);
> > +	void *ptr = ___alloc_bootmem(size, align, goal, 0);
> > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > +	return ptr;

Same here.

> >  #ifdef CONFIG_SPARSEMEM
> > @@ -707,14 +719,18 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
> >  		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> >  
> >  	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
> > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> >  	if (ptr)
> >  		return ptr;
> >  
> >  	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
> > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> >  	if (ptr)
> >  		return ptr;
> >  
> > -	return __alloc_bootmem_nopanic(size, align, goal);
> > +	ptr = __alloc_bootmem_nopanic(size, align, goal);
> > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > +	return ptr;
> >  }

Can you use a central exit and goto?

> >  #ifndef ARCH_LOW_ADDRESS_LIMIT
> > @@ -737,7 +753,9 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
> >  void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
> >  				  unsigned long goal)
> >  {
> > -	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
> > +	void *ptr =  ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
> > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > +	return ptr;
> >  }

Possible slab object.

> > @@ -758,9 +776,13 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
> >  void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
> >  				       unsigned long align, unsigned long goal)
> >  {
> > +	void *ptr;
> > +
> >  	if (WARN_ON_ONCE(slab_is_available()))
> >  		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> >  
> > -	return ___alloc_bootmem_node(pgdat->bdata, size, align,
> > -				goal, ARCH_LOW_ADDRESS_LIMIT);
> > +	ptr = ___alloc_bootmem_node(pgdat->bdata, size, align,
> > +				    goal, ARCH_LOW_ADDRESS_LIMIT);
> > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);

These GFP_KERNEL startled me.  We know for sure that this code runs in
earlylog mode only and gfp is unused, right?  Can you perhaps just
pass 0 for gfp instead?

	Hannes
