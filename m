Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYB2BHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYB2BHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762050AbYB2A5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:57:07 -0500
Received: from relay1.sgi.com ([192.48.171.29]:43671 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760742AbYB2A5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:57:04 -0500
Date: Thu, 28 Feb 2008 16:57:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Implement slub fastpath in terms of freebase and freeoffset
In-Reply-To: <20080228232507.GB20319@Krystal>
Message-ID: <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com>
References: <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
 <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
 <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
 <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com>
 <20080228232507.GB20319@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:

> static inline void set_freelist_ptr(struct kmem_cache_cpu *c, void **freelist)
> {
>         unsigned long offset;
> 
>         offset = c->freeoffset + c->off_mask + 1;
>         offset &= ~c->off_mask;
>         offset |= (unsigned long)freelist & c->off_mask;
>         c->freeoffset = offset;
> }
> 
> Which will insure c->freeoffset is always in a valid state, therefore
> allowing interrupts to nest over it.

Ok.

> Should be ok now since we allow interrupts to nest over
> set_freelist_ptr. But I think this is also protected by slab_lock, taken
> both in the slow path and in deactivate_slab.

The slab locks can only be taken with interrupts disabled.
 

> In any case, doing a 
> 
>                 object = get_freelist_ptr(c);
>                 set_freelist_ptr(c, object[c->offset]);
> 
> Like deactivate_slab does should be either protected by disabling
> interrupts or by the slab_lock. Am I right ?

Correct.

> Ah! I think I found the issue. It should become :
> 
> 
>                 newoffset = freeoffset;
>                 newoffset &= ~c->off_mask;
>                 newoffset |= (unsigned long)(object[c->offset]) & c->off_mask;
>         } while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
>                         != freeoffset);

Looks okay.

> Index: linux-2.6-lttng/mm/slub.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/slub.c	2008-02-27 20:41:14.000000000 -0500
> +++ linux-2.6-lttng/mm/slub.c	2008-02-28 18:22:14.000000000 -0500
> @@ -138,6 +138,22 @@ static inline void ClearSlabDebug(struct
>  	page->flags &= ~SLABDEBUG;
>  }
>  
> +static inline void **get_freelist_ptr(struct kmem_cache_cpu *c)
> +{
> +	return (void **)((unsigned long)page_address(c->page)
> +		| (c->freeoffset & c->off_mask));
> +}

Hmmmm... page_address() is an expensive operation.

> @@ -1636,28 +1652,48 @@ static __always_inline void *slab_alloc(
>   */
>  
>  #ifdef SLUB_FASTPATH
> +	unsigned long freeoffset, newoffset;
> +
>  	c = get_cpu_slab(s, raw_smp_processor_id());
>  	do {
> -		object = c->freelist;
> -		if (unlikely(is_end(object) || !node_match(c, node))) {
> +		freeoffset = c->freeoffset;
> +		/*
> +		 * If c->page is changed, freeoffset _must_ have its
> +		 * counter incremented.
> +		 * read freeoffset before c->page (wrt interrupts).
> +		 */
> +		barrier();
> +		if (unlikely(is_end(freeoffset) || !node_match(c, node))) {
>  			object = __slab_alloc(s, gfpflags, node, addr, c);
>  			break;
>  		}
> +		object = (void **)((unsigned long)page_address(c->page)

Expensive op page_address().

> @@ -1779,21 +1815,21 @@ static __always_inline void slab_free(st
>  	struct kmem_cache_cpu *c;
>  
>  #ifdef SLUB_FASTPATH
> -	void **freelist;
> +	unsigned long freeoffset, newoffset;
>  
>  	c = get_cpu_slab(s, raw_smp_processor_id());
>  	debug_check_no_locks_freed(object, s->objsize);
>  	do {
> -		freelist = c->freelist;
> +		freeoffset = c->freeoffset;
>  		barrier();
>  		/*
>  		 * If the compiler would reorder the retrieval of c->page to
> -		 * come before c->freelist then an interrupt could
> -		 * change the cpu slab before we retrieve c->freelist. We
> -		 * could be matching on a page no longer active and put the
> -		 * object onto the freelist of the wrong slab.
> +		 * come before c->freeoffset then an interrupt could change the
> +		 * cpu slab before we retrieve c->freelist. We could be matching
> +		 * on a page no longer active and put the object onto the
> +		 * freelist of the wrong slab.
>  		 *
> -		 * On the other hand: If we already have the freelist pointer
> +		 * On the other hand: If we already have the freeoffset
>  		 * then any change of cpu_slab will cause the cmpxchg to fail
>  		 * since the freelist pointers are unique per slab.
>  		 */
> @@ -1801,9 +1837,15 @@ static __always_inline void slab_free(st
>  			__slab_free(s, page, x, addr, c->offset);
>  			break;
>  		}
> -		object[c->offset] = freelist;
> +		object[c->offset] =
> +			(void **)((unsigned long)page_address(c->page) |
> +					(freeoffset & c->off_mask));
>  		stat(c, FREE_FASTPATH);
> -	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
> +		newoffset = freeoffset + PAGE_SIZE;
> +		newoffset &= ~c->off_mask;
> +		newoffset |= (unsigned long)object & c->off_mask;
> +	} while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
> +			!= freeoffset);

Hmmm.. The cmpxchg_local was intended to check for a change of slab too 
(addresses from different slabs are disjunct). 
That is no longer possible since the upper bits are used by the 
versioning? (Same issue in slab_alloc).

