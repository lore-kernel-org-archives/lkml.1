Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYB1TJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYB1TJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYB1TIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:08:52 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52907 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754204AbYB1TIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:08:51 -0500
Date: Thu, 28 Feb 2008 11:08:49 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Implement slub fastpath in terms of freebase and freeoffset
In-Reply-To: <20080228055510.GA9026@Krystal>
Message-ID: <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
 <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
 <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
 <20080228055510.GA9026@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:

> Yep, I have an experimental patch ready. It would need some thorough
> testing though. I seems to run fine on an x86_32 with and without
> preemption (therefore with and without the slub cmpxchg_local fastpath).

What is the performance impact?

More comments follow...


> freeoffset & PAGE_MASK is the offset of the freelist element within the page.
> freeoffset & ~PAGE_MASK is the counter to detect object re-use.
> freebase is the address of the page in this the object is located. It is a
> multiple of PAGE_SIZE.

How does the page mask work for order 1 and other higher order allocations?
 
> Whenever an object is freed in the cpu slab cache, the counter is incremented.
> Whenever the alloc/free slow paths are modifying the freeoffset or freebase, the
> freeoffset counter is also incremented. It is used to make sure we know if
> freebase has been modified in an interrupt nested over the fast path.

> +	unsigned long freebase;	/*
> +				 * Pointer to the page address
> +				 * containing the first free per cpu
> +				 * object.
> +				 */

This is page_address(c->page)?

>  	struct page *page;	/* The slab from which we are allocating */
>  	int node;		/* The node of the page (or -1 for debug) */
>  	unsigned int offset;	/* Freepointer offset (in word units) */

> +/*
> + * Used when interrupts are disabled, so no memory barriers are needed.
> + */
> +static inline void **get_freelist_ptr(struct kmem_cache_cpu *c)
> +{
> +	return (void **)(c->freebase | (c->freeoffset & PAGE_MASK));
> +}

page_address(c->page) + (c->freeoffset & (PAGE_MASK << s->order)) ?

store the page mask also in the kmem_cache_cpu structure?

> +/*
> + * Updates the freebase and freeoffset concurrently with slub fastpath.
> + * We can nest over the fastpath as an interrupt. Therefore, all the freebase
> + * and freeoffset modifications will appear to have happened atomically from the
> + * fastpath point of view. (those are per-cpu variables)
> + */
> +static inline void set_freelist_ptr(struct kmem_cache_cpu *c, void **freelist)
> +{
> +	c->freebase = (unsigned long)freelist & ~PAGE_MASK;
> +	c->freeoffset += PAGE_SIZE;
> +	c->freeoffset &= ~PAGE_MASK;
> +	c->freeoffset |= (unsigned long)freelist & PAGE_MASK;
> +}

How is this going to show up as an atomic update? You modify multiple per 
cpu fields and an interrupt could happen in between.

> @@ -1411,7 +1411,7 @@ static void deactivate_slab(struct kmem_
>  	struct page *page = c->page;
>  	int tail = 1;
>  
> -	if (c->freelist)
> +	if (get_freelist_ptr(c))
>  		stat(c, DEACTIVATE_REMOTE_FREES);
>  	/*

The original code is wrong. It should be

if (is_end(c->freelist))
	stat(c, DEACTIVATE_REMOTE_FREES)


> -		c->freelist = c->freelist[c->offset];
> +		object = get_freelist_ptr(c);
> +		set_freelist_ptr(c, object[c->offset]);

That use of set_freelist is safe since interrupts are disabled. So the 
function can only be used i interrupts are disabled?

> +		/* No need to increment the MSB counter here, because only
> +		 * object free will lead to counter re-use. */
> +	} while (cmpxchg_local(&c->freeoffset, freeoffset,
> +		(freeoffset + (c->offset * sizeof(void *)))) != freeoffset);

How does this work? You replace the freeoffset with the the once 
incremented by the object offset??? The objects may not be in sequence on 
the freelist and the increment wont get you to the next object anyways 
since c->offset is usually 0.

