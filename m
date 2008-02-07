Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbYBGVxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbYBGVxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYBGVxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:53:30 -0500
Received: from relay1.sgi.com ([192.48.171.29]:43025 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754362AbYBGVx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:53:29 -0500
Date: Thu, 7 Feb 2008 13:53:27 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/2] kmemcheck v3
In-Reply-To: <47AB79D4.2070605@gmail.com>
Message-ID: <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com>
References: <47AB79D4.2070605@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Vegard Nossum wrote:

> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -28,6 +28,7 @@
>  #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU
> */
>  #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory
> over cpuset */
>  #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees
> */
> +#define SLAB_NOTRACK		0x00400000UL	/* Don't track use of
> uninitialized memory */

Ok new exception for tracking.

> index 3f05667..3b3dfb8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> +#ifdef CONFIG_KMEMCHECK
> +	if (s->flags & SLAB_NOTRACK)
> +		flags |= __GFP_NOTRACK;
> +
> +	/* Actually allocate twice as much, since we need to track the
> +	 * status of each byte within the allocation. */
> +	if (!(flags & __GFP_NOTRACK)) {
> +		pages += pages;
> +		order += 1;
> +	}

Hmmmm... You seem to assume that __GFP_NOTRACK can be passed to slab 
function calls like kmalloc. That is pretty unreliable. Could we add
__GFP_NOTRACK to the flags on which the slab allocators BUG?

> @@ -1551,9 +1586,7 @@ static __always_inline void *slab_alloc(struct
> kmem_cache *s,
>  	local_irq_save(flags);
>  	c = get_cpu_slab(s, smp_processor_id());
>  	if (unlikely(!c->freelist || !node_match(c, node)))
> -
>  		object = __slab_alloc(s, gfpflags, node, addr, c);
> -
>  	else {
>  		object = c->freelist;
>  		c->freelist = object[c->offset];

Drop this hunk.


> @@ -2344,6 +2393,8 @@ EXPORT_SYMBOL(kmem_cache_destroy);
>  struct kmem_cache kmalloc_caches[PAGE_SHIFT] __cacheline_aligned;
>  EXPORT_SYMBOL(kmalloc_caches);
> 
> +struct kmem_cache cache_cache;
> +

Why do we need a cache_cache?

>  #ifdef CONFIG_ZONE_DMA
>  static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT];
>  #endif
> @@ -2391,6 +2442,9 @@ static struct kmem_cache *create_kmalloc_cache(struct
> kmem_cache *s,
>  	if (gfp_flags & SLUB_DMA)
>  		flags = SLAB_CACHE_DMA;
> 
> +	if (gfp_flags & __GFP_NOTRACK)
> +		flags |= SLAB_NOTRACK;
> +
>  	down_write(&slub_lock);
>  	if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
>  			flags, NULL))

Drop this one. create_kmalloc_cache is done only during bootstrap and 
kmalloc caches either all have SLAB_NOTRACK set or all do not have it 
set.

> @@ -2445,14 +2499,18 @@ static noinline struct kmem_cache
> *dma_kmalloc_cache(int index, gfp_t flags)
>  	if (kmalloc_caches_dma[index])
>  		goto unlock_out;
> 
> +#ifdef CONFIG_KMEMCHECK
> +	flags |= __GFP_NOTRACK;
> +#endif
> +

Same here.
