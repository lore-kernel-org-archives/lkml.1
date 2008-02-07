Return-Path: <linux-kernel-owner+w=401wt.eu-S934914AbYBGWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934914AbYBGWxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYBGWxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:53:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55345 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754948AbYBGWxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:53:04 -0500
Date: Thu, 7 Feb 2008 14:53:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/2] kmemcheck v3
In-Reply-To: <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com>
References: <47AB79D4.2070605@gmail.com>  <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com>
 <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Vegard Nossum wrote:

> > > */
> > > +#define SLAB_NOTRACK         0x00400000UL    /* Don't track use of
> > > uninitialized memory */
> >
> > Ok new exception for tracking.
> 
> New exception? Please explain.

SLABs can be excepted from tracking?

> > Hmmmm... You seem to assume that __GFP_NOTRACK can be passed to slab
> > function calls like kmalloc. That is pretty unreliable. Could we add
> > __GFP_NOTRACK to the flags on which the slab allocators BUG?
> 
> I don't understand. This is the point, __GFP_NOTRACK _can_ be passed
> to slab functions like kmalloc. By default, when kmemcheck is enabled
> in the config, all other allocations will be tracked implicitly. The
> notrack flag exists to exempt certain (critical) allocations from this
> feature.

Ok. Then the allocator manages the gfp flag. Then we need to make sure 
to clear that flag at some point. The flag needs to be consistently set 
or cleared for allocations for a certain slab cache.

> > > @@ -2344,6 +2393,8 @@ EXPORT_SYMBOL(kmem_cache_destroy);
> > >  struct kmem_cache kmalloc_caches[PAGE_SHIFT] __cacheline_aligned;
> > >  EXPORT_SYMBOL(kmalloc_caches);
> > >
> > > +struct kmem_cache cache_cache;
> > > +
> >
> > Why do we need a cache_cache?
> 
> The cache_cache is needed so that we have somewhere to allocate
> kmem_cache objects from. These objects are accessed from kmemcheck in
> the page fault handler. If the caches are allocated from tracked
> memory, we get a recursive page fault, which is not nice, to say the
> least :-)

So it breaks recursion. But this adds a new cache that is rarely 
used. There will be only about 50-100 kmem_cache objects in the system. I 
thought you could control the tracking on an per object level? Would not a 
kmalloc with __GFP_NOTRACK work?

> > >       if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
> > >                       flags, NULL))
> >
> > Drop this one. create_kmalloc_cache is done only during bootstrap and
> > kmalloc caches either all have SLAB_NOTRACK set or all do not have it
> > set.
> 
> No. Exactly one kmalloc_cache is created with the NOTRACK flag set,
> namely the cache_cache.

More reasons to drop cache_cache. cache_cache is not a kmalloc array 
cache by the way since it does not support power of two allocs. Its a 
regular kmem_cache element.

> > > @@ -2445,14 +2499,18 @@ static noinline struct kmem_cache
> > > *dma_kmalloc_cache(int index, gfp_t flags)
> > >       if (kmalloc_caches_dma[index])
> > >               goto unlock_out;
> > >
> > > +#ifdef CONFIG_KMEMCHECK
> > > +     flags |= __GFP_NOTRACK;
> > > +#endif
> > > +
> >
> > Same here.
> 
> No. This is dma_kmalloc_cache(). No DMA memory should ever be tracked
> by kmemcheck, because DMA doesn't cause page faults. (So in fact,
> tracking DMA is by definition not possible.)

All slab memory allocations never cause page faults regardless from where 
they are allocated. Only user space pages can be handled by page faults 
and those are not allocated via the slab allocator.

> Are you sure you are not confusing tracking with tracing? It's only
> one letter different in spelling, but makes a huge difference in
> meaning :-)

No I am quite sure what tracking is since the slab allocators have their 
own tracking. 

But you may want to explain things better.
