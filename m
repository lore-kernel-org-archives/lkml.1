Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbYBGWMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbYBGWMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYBGWM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:12:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:62692 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbYBGWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:12:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LXFeqgwqkKpTiM5vp7asFJuOL6AipyVkJc+4w3L8j3dW91pLOF0GbIq2Eaj/V7TXisHA5KHKLQmRMZRmQWSVDhCMZ85kxIN8RhofiS48tRYrj4o8P2rHq4Va+14CDpYTwZt/JGsuN+eT1YfncQWhDFmPgq3YHHajWejvMlhXJ9A=
Message-ID: <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com>
Date: Thu, 7 Feb 2008 23:12:25 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>
In-Reply-To: <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for taking the time to look at this patch!

On Feb 7, 2008 10:53 PM, Christoph Lameter <clameter@sgi.com> wrote:
> On Thu, 7 Feb 2008, Vegard Nossum wrote:
>
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -28,6 +28,7 @@
> >  #define SLAB_DESTROY_BY_RCU  0x00080000UL    /* Defer freeing slabs to RCU
> > */
> >  #define SLAB_MEM_SPREAD              0x00100000UL    /* Spread some memory
> > over cpuset */
> >  #define SLAB_TRACE           0x00200000UL    /* Trace allocations and frees
> > */
> > +#define SLAB_NOTRACK         0x00400000UL    /* Don't track use of
> > uninitialized memory */
>
> Ok new exception for tracking.

New exception? Please explain.

> > index 3f05667..3b3dfb8 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > +#ifdef CONFIG_KMEMCHECK
> > +     if (s->flags & SLAB_NOTRACK)
> > +             flags |= __GFP_NOTRACK;
> > +
> > +     /* Actually allocate twice as much, since we need to track the
> > +      * status of each byte within the allocation. */
> > +     if (!(flags & __GFP_NOTRACK)) {
> > +             pages += pages;
> > +             order += 1;
> > +     }
>
> Hmmmm... You seem to assume that __GFP_NOTRACK can be passed to slab
> function calls like kmalloc. That is pretty unreliable. Could we add
> __GFP_NOTRACK to the flags on which the slab allocators BUG?

I don't understand. This is the point, __GFP_NOTRACK _can_ be passed
to slab functions like kmalloc. By default, when kmemcheck is enabled
in the config, all other allocations will be tracked implicitly. The
notrack flag exists to exempt certain (critical) allocations from this
feature.

> > @@ -1551,9 +1586,7 @@ static __always_inline void *slab_alloc(struct
> > kmem_cache *s,
> >       local_irq_save(flags);
> >       c = get_cpu_slab(s, smp_processor_id());
> >       if (unlikely(!c->freelist || !node_match(c, node)))
> > -
> >               object = __slab_alloc(s, gfpflags, node, addr, c);
> > -
> >       else {
> >               object = c->freelist;
> >               c->freelist = object[c->offset];
>
> Drop this hunk.

Sorry, a left-over from earlier changes :-)

> > @@ -2344,6 +2393,8 @@ EXPORT_SYMBOL(kmem_cache_destroy);
> >  struct kmem_cache kmalloc_caches[PAGE_SHIFT] __cacheline_aligned;
> >  EXPORT_SYMBOL(kmalloc_caches);
> >
> > +struct kmem_cache cache_cache;
> > +
>
> Why do we need a cache_cache?

The cache_cache is needed so that we have somewhere to allocate
kmem_cache objects from. These objects are accessed from kmemcheck in
the page fault handler. If the caches are allocated from tracked
memory, we get a recursive page fault, which is not nice, to say the
least :-)

> >  #ifdef CONFIG_ZONE_DMA
> >  static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT];
> >  #endif
> > @@ -2391,6 +2442,9 @@ static struct kmem_cache *create_kmalloc_cache(struct
> > kmem_cache *s,
> >       if (gfp_flags & SLUB_DMA)
> >               flags = SLAB_CACHE_DMA;
> >
> > +     if (gfp_flags & __GFP_NOTRACK)
> > +             flags |= SLAB_NOTRACK;
> > +
> >       down_write(&slub_lock);
> >       if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
> >                       flags, NULL))
>
> Drop this one. create_kmalloc_cache is done only during bootstrap and
> kmalloc caches either all have SLAB_NOTRACK set or all do not have it
> set.

No. Exactly one kmalloc_cache is created with the NOTRACK flag set,
namely the cache_cache.

> > @@ -2445,14 +2499,18 @@ static noinline struct kmem_cache
> > *dma_kmalloc_cache(int index, gfp_t flags)
> >       if (kmalloc_caches_dma[index])
> >               goto unlock_out;
> >
> > +#ifdef CONFIG_KMEMCHECK
> > +     flags |= __GFP_NOTRACK;
> > +#endif
> > +
>
> Same here.

No. This is dma_kmalloc_cache(). No DMA memory should ever be tracked
by kmemcheck, because DMA doesn't cause page faults. (So in fact,
tracking DMA is by definition not possible.)


Are you sure you are not confusing tracking with tracing? It's only
one letter different in spelling, but makes a huge difference in
meaning :-)


Kind regards,
Vegard Nossum
