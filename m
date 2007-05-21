Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbXEURBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbXEURBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbXEURBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:01:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36259 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756365AbXEURBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:01:30 -0400
Date: Mon, 21 May 2007 10:01:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 02/10] SLUB: slab defragmentation and kmem_cache_vacate
In-Reply-To: <20070521141039.GA18474@skynet.ie>
Message-ID: <Pine.LNX.4.64.0705210953440.25871@schroedinger.engr.sgi.com>
References: <20070518181040.465335396@sgi.com> <20070518181119.062736299@sgi.com>
 <20070521141039.GA18474@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Mel Gorman wrote:

> I know I brought up this "less than a quarter" thing before and I
> haven't thought of a better alternative. However, it occurs to be that
> shrink_slab() is called when there is awareness of a reclaim priority.
> It may be worth passing that down so that the fraction of candidates
> pages is calculated based on priority.

Hmmmm.. Yes I am thinking about that one too. Right now I have a system
that triggers reclaim every 10 seconds or after more than 100 objects have 
been reclaimed.
 
> That said..... where is kmem_cache_shrink() ever called? The freeing of
> slab pages seems to be indirect these days. Way back,
> kmem_cache_shrink() used to be called directly but I'm not sure where it
> happens now.

Well, this one only allows manual triggering. To my embarasasment I found 
that the kmem_cache_shrink calls for icache and dentries are only in 2.4. 
They have been removed in 2.6.X. I need to add them back to 2.6.

> >  /*
> > + * Order the freelist so that addresses increase as object are allocated.
> > + * This is useful to trigger the cpu cacheline prefetching logic.
> > + */
> 
> makes sense. However, it occurs to me that maybe this should be a
> separate patch so it can be measured to be sure. It makes sense though.

Ok.

> > +/*
> > + * Vacate all objects in the given slab.
> > + *
> > + * Slab must be locked and frozen. Interrupts are disabled (flags must
> > + * be passed).
> > + *
> 
> It may not hurt to have a VM_BUG_ON() if interrupts are still enabled when
> this is called

Well flags need to be passed and those flags are obtained via disabling 
interrupts.


> > +	/*
> > +	 * Got references. Now we can drop the slab lock. The slab
> > +	 * is frozen so it cannot vanish from under us nor will
> > +	 * allocations be performed on the slab. However, unlocking the
> > +	 * slab will allow concurrent slab_frees to proceed.
> > +	 */
> > +	slab_unlock(page);
> > +	local_irq_restore(flags);
> 
> I recognise that you want to restore interrupts as early as possible but
> it should be noted somewhere that kmem_cache_vacate() disables
> interrupts and __kmem_cache_vacate() enabled them again. I had to go
> searching to see where interrupts are enabled again.
> 
> Maybe even a slab_lock_irq() and slab_unlock_irq() would clarify things
> a little.

Hmmmm... Okay but this is a rare situation in SLUB. Regular slab 
operations always run with interrupts disabled.

> > +
> > +	vector = kmalloc(s->objects * sizeof(void *), GFP_KERNEL);
> > +	if (!vector)
> > +		return 0;
> 
> Is it worth logging this event, returning -ENOMEM or something so that
> callers are aware of why kmem_cache_vacate() failed in this instance?
> 
> Also.. we have called get_page_unless_zero() but if we are out of memory
> here, where have we called put_page()? Maybe we should be "goto out"
> here with a

Ahh. Thanks. Will fix that.

> > +	 * We are holding a lock on a slab page and all operations on the
> > +	 * slab are blocking.
> > +	 */
> > +	if (!s->ops->get || !s->ops->kick)
> > +		goto out_locked;
> > +	freeze_from_list(s, page);
> > +	vacated = __kmem_cache_vacate(s, page, flags, vector) == 0;
> 
> That is a little funky looking. This may be nicer;
> 
> vacated = __kmem_cache_vacate(s, page, flags, vector);
> out:
> ...
> return vacated == 0;
> 

Right. Done.
