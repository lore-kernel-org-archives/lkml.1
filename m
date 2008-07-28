Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYG1KaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYG1KaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYG1K35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:29:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33822 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYG1K34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:29:56 -0400
Subject: Re: [PATCH 12/30] mm: memory reserve management
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Neil Brown <neilb@suse.de>,
       mpm@selenic.com, cl@linux-foundation.org
In-Reply-To: <1217240224.6331.32.camel@twins>
References: <20080724140042.408642539@chello.nl>
	 <20080724141530.127530749@chello.nl>
	 <1217239564.7813.36.camel@penberg-laptop>  <1217240224.6331.32.camel@twins>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Jul 2008 13:29:54 +0300
Message-Id: <1217240994.7813.53.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, 2008-07-28 at 12:17 +0200, Peter Zijlstra wrote:
> On Mon, 2008-07-28 at 13:06 +0300, Pekka Enberg wrote:
> > Hi Peter,
> > 
> > On Thu, 2008-07-24 at 16:00 +0200, Peter Zijlstra wrote:
> > > +/*
> > > + * alloc wrappers
> > > + */
> > > +
> > 
> > ﻿Hmm, I'm not sure I like the use of __kmalloc_track_caller() (even
> > though you do add the wrappers for SLUB). The functions really are SLAB
> > internals so I'd prefer to see kmalloc_reserve() moved to the
> > allocators.
> 
> See below..
> 
> > > +void *___kmalloc_reserve(size_t size, gfp_t flags, int node, void *ip,
> > > +			 struct mem_reserve *res, int *emerg)
> > > +{
> > 
> > This function could use some comments...
> 
> Yes, my latest does have those.. let me paste the relevant bit:
> 
> +void *___kmalloc_reserve(size_t size, gfp_t flags, int node, void *ip,
> +                        struct mem_reserve *res, int *emerg)
> +{
> +       void *obj;
> +       gfp_t gfp;
> +
> +       /*
> +        * Try a regular allocation, when that fails and we're not entitled
> +        * to the reserves, fail.
> +        */
> +       gfp = flags | __GFP_NOMEMALLOC | __GFP_NOWARN;
> +       obj = __kmalloc_node_track_caller(size, gfp, node, ip);
> +
> +       if (obj || !(gfp_to_alloc_flags(flags) & ALLOC_NO_WATERMARKS))
> +               goto out;
> +
> +       /*
> +        * If we were given a reserve to charge against, try that.
> +        */
> +       if (res && !mem_reserve_kmalloc_charge(res, size)) {
> +               /*
> +                * If we failed to charge and we're not allowed to wait for
> +                * it to succeed, bail.
> +                */
> +               if (!(flags & __GFP_WAIT))
> +                       goto out;
> +
> +               /*
> +                * Wait for a successfull charge against the reserve. All
> +                * uncharge operations against this reserve will wake us up.
> +                */
> +               wait_event(res->waitqueue,
> +                               mem_reserve_kmalloc_charge(res, size));
> +
> +               /*
> +                * After waiting for it, again try a regular allocation.
> +                * Pressure could have lifted during our sleep. If this
> +                * succeeds, uncharge the reserve.
> +                */
> +               obj = __kmalloc_node_track_caller(size, gfp, node, ip);
> +               if (obj) {
> +                       mem_reserve_kmalloc_charge(res, -size);
> +                       goto out;
> +               }
> +       }
> +
> +       /*
> +        * Regular allocation failed, and we've successfully charged our
> +        * requested usage against the reserve. Do the emergency allocation.
> +        */
> +       obj = __kmalloc_node_track_caller(size, flags, node, ip);
> +       WARN_ON(!obj);
> +       if (emerg)
> +               *emerg |= 1;
> +
> +out:
> +       return obj;
> +}

Heh, indeed, looks much better :-).

> 
> > > +	void *obj;
> > > +	gfp_t gfp;
> > > +
> > > +	gfp = flags | __GFP_NOMEMALLOC | __GFP_NOWARN;
> > > +	obj = __kmalloc_node_track_caller(size, gfp, node, ip);
> > > +
> > > +	if (obj || !(gfp_to_alloc_flags(flags) & ALLOC_NO_WATERMARKS))
> > > +		goto out;
> > > +
> > > +	if (res && !mem_reserve_kmalloc_charge(res, size)) {
> > > +		if (!(flags & __GFP_WAIT))
> > > +			goto out;
> > > +
> > > +		wait_event(res->waitqueue,
> > > +				mem_reserve_kmalloc_charge(res, size));
> > > +
> > > +		obj = __kmalloc_node_track_caller(size, gfp, node, ip);
> > > +		if (obj) {
> > > +			mem_reserve_kmalloc_charge(res, -size);
> > 
> > Why do we discharge here?
> 
> because a regular allocation succeeded.
> 
> > > +			goto out;
> > > +		}
> > 
> > If the allocation fails, we try again (but nothing has changed, right?).
> > Why?
> 
> Note the different allocation flags for the two allocations.

Uhm, yeah. I missed that.

> > > +	}
> > > +
> > > +	obj = __kmalloc_node_track_caller(size, flags, node, ip);
> > > +	WARN_ON(!obj);
> > 
> > Why don't we discharge from the reserve here if !obj?
> 
> Well, this allocation should never fail:
>   - we reserved memory
>   - we accounted/throttle its usage
> 
> Thus this allocation should always succeed.

But if it *does* fail, it doesn't help that we mess up the reservation
counts, no?

> > > +	if (emerg)
> > > +		*emerg |= 1;
> > > +
> > > +out:
> > > +	return obj;
> > > +}
> > > +
> > > +void __kfree_reserve(void *obj, struct mem_reserve *res, int emerg)
> > 
> > I don't see 'emerg' used anywhere.
> 
> Patch 19/30 has:
> 
> -       data = kmalloc_node_track_caller(size + sizeof(struct skb_shared_info),
> -                       gfp_mask, node);
> +       data = kmalloc_reserve(size + sizeof(struct skb_shared_info),
> +                       gfp_mask, node, &net_skb_reserve, &emergency);
>         if (!data)
>                 goto nodata;
> 
> @@ -205,6 +211,7 @@ struct sk_buff *__alloc_skb(unsigned int
>          * the tail pointer in struct sk_buff!
>          */
>         memset(skb, 0, offsetof(struct sk_buff, tail));
> +       skb->emergency = emergency;
>         skb->truesize = size + sizeof(struct sk_buff);
>         atomic_set(&skb->users, 1);
>         skb->head = data;
> 
> > > +{
> > > +	size_t size = ksize(obj);
> > > +
> > > +	kfree(obj);
> > 
> > We're trying to get rid of kfree() so I'd __kfree_reserve() could to
> > mm/sl?b.c. Matt, thoughts?
> 
> My issue with moving these helpers into mm/sl?b.c is that it would
> require replicating all this code 3 times. Even though the functionality
> is (or should) be invariant to the actual slab implementation.

Right, I guess we could just rename ksize() to something else then and
keep it internal to mm/.

> > > +	/*
> > > +	 * ksize gives the full allocated size vs the requested size we used to
> > > +	 * charge; however since we round up to the nearest power of two, this
> > > +	 * should all work nicely.
> > > +	 */
> > > +	mem_reserve_kmalloc_charge(res, -size);
> > > +}
> > > 
> > 
> 

