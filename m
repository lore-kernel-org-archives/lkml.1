Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXJ2DDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXJ2DDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 23:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXJ2DDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 23:03:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40612 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352AbXJ2DDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 23:03:13 -0400
Date: Sun, 28 Oct 2007 20:03:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 09/10] SLUB: Do our own locking via slab_lock and
 slab_unlock.
In-Reply-To: <Pine.LNX.4.64.0710281702140.6766@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0710282001000.28636@schroedinger.engr.sgi.com>
References: <20071028033156.022983073@sgi.com> <20071028033300.479692380@sgi.com>
 <Pine.LNX.4.64.0710281702140.6766@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Pekka J Enberg wrote:

> It would be easier to review the actual locking changes if you did the 
> SlabXXX removal in a separate patch.

There are no locking changes.

> > -static __always_inline void slab_lock(struct page *page)
> > +static __always_inline void slab_unlock(struct page *page,
> > +					unsigned long state)
> >  {
> > -	bit_spin_lock(PG_locked, &page->flags);
> > +	smp_wmb();
> 
> Memory barriers deserve a comment. I suppose this is protecting 
> page->flags but against what?

Its making sure that the changes to page flags are made visible after all 
other changes.

> 
> > +	page->flags = state;
> > +	preempt_enable();
> 
> We don't need preempt_enable for CONFIG_SMP, right?

preempt_enable is needed if preemption is enabled.

> 
> > +	 __release(bitlock);
> 
> This needs a less generic name and maybe a comment explaining that it's 
> not annotating a proper lock? Or maybe we can drop it completely?

Probably.

> > +static __always_inline unsigned long slab_trylock(struct page *page)
> > +{
> > +	unsigned long state;
> > +
> > +	preempt_disable();
> > +	state = page->flags & ~LOCKED;
> > +#ifdef CONFIG_SMP
> > +	if (cmpxchg(&page->flags, state, state | LOCKED) != state) {
> > +		 preempt_enable();
> > +		 return 0;
> > +	}
> > +#endif
> 
> This is hairy. Perhaps it would be cleaner to have totally separate 
> functions for SMP and UP instead?

I think that is reasonably clear. Having code duplicated is not good 
either. Well we may have to clean this up a bit.



