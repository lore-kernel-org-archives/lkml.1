Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYDBSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYDBSYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbYDBSYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:24:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57821 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbYDBSYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:24:03 -0400
Date: Wed, 2 Apr 2008 11:23:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402182352.GF9333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> <20080402105539.GA5610@linux.vnet.ibm.com> <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com> <20080402160809.GA4123@linux.vnet.ibm.com> <19f34abd0804020915k210277bbmb6b9aa28f282bb42@mail.gmail.com> <Pine.LNX.4.64.0804021924280.6839@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021924280.6839@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 07:32:26PM +0300, Pekka J Enberg wrote:
> Hi Vegard,
> 
> On Wed, Apr 2, 2008 at 6:08 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > Would the following be an appropriate fix?  It seems to me to be in
> > > the same spirit as the existing check for s->ctor.
> 
> On Wed, 2 Apr 2008, Vegard Nossum wrote:
> > In my opinion, no.
> > 
> > It would fix the false positives, but would in fact also hide cases
> > such as this one with cfq, e.g. the real cases of mis-use.
> 
> Yes, but we might as well put Paul's patch in now and remove that later 
> when we have a proper fix, no?
> 
> On Wed, 2 Apr 2008, Vegard Nossum wrote:
> > Peter Zijlstra suggested this:
> > > It would have to register an call_rcu callback itself in order to mark
> > > it freed - and handle the race with the object being handed out again.
> > 
> > I will try to look into this -- for now, I need to understand RCU
> > first (I've seen your LWN articles -- great work! :-))
> 
> Well, maybe we can add two new states: RCU_FREED and RCU_VALIDATED? The 
> object is flagged with the first one as soon as an object is handed over 
> to kmem_cache_free() and the latter needs to hook to the validation phase 
> of RCU (how is that done btw?). Then kmemcheck could even give a better 
> error message: "RCU-freed object used without validation."
> 
> And with delayed free for kmemcheck we discussed before, we'd hold on to 
> the objects long enough to actually see these error conditions.

Well, one approach would be to add an rcu_head to the kmem_cache
structure, along with a flag stating that the rcu_head is in use.  I hope
that there is a better approach, as this introduces a lock roundtrip
into kmemcheck_slab_free().  Is there a better place to put the rcu_head?
Perhaps into the per-CPU allocator?  But then we have to track which
CPU has which mark pending, and there are only so many bits in a byte,
as the SGI guys would be quick to point out

Which is why I chickened out and submitted the earlier crude patch.

Anyway, here is a -very- rough sketch of the stupid lock-based approach.

							Thanx, Paul

struct kmem_cache {

	. . . /* existing fields */

	struct rcu_head rcu;
	int rcu_available;  /* rcu_head above is available for use. */
	spinlock_t rcu_lock;  /* which of course must be initialized. */
};

Then we need to add a couple of values to the enum shadow:

enum shadow {
	... /* existing values */
	SHADOW_RCU_FREED,
	SHADOW_RCU_FREED_PENDING,
};

Then we have:

void
kmemcheck_slab_free(struct kmem_cache *s, void *object)
{
	unsigned long flags;

	if (s->ctor)
		return;
	if (likely(!(s->flags & SLAB_DESTROY_BY_RCU)))
		kmemcheck_mark_freed(object, s->objsize);
	spin_lock_irqsave(&s->rcu_lock, flags);
	if (s->rcu_available) {
		kmemcheck_mark_rcu_freed(object, s->objsize);
		/* record the address somewhere... */
		call_rcu(&s->rcu, kmemcheck_slab_free_rcu);
	} else {
		kmemcheck_mark_rcu_pending(object, s->objsize);
		/* record the address somewhere... */
	}
	spin_unlock_irqrestore(&s->rcu_lock, flags);
}

void kmemcheck_slab_free_rcu(struct rcu_head *rcu)
{
	unsigned long flags;
	struct kmem_cache *s = container_of(rcu, struct kmem_cache, rcu);
	void *shadow;

	spin_lock_irqsave(&s->rcu_lock, flags);
	/* recover the previously recorded object address. somehow */
	kmemcheck_mark_freed(object, s->objsize);
	if (/* there are pending requests */) {
		/* get the previously recorded object addresses, somehow */
		kmemcheck_mark_rcu_freed(object, s->objsize);
		call_rcu(&s->rcu, kmemcheck_slab_free_rcu);
	}
	spin_unlock_irqrestore(&s->rcu_lock, flags);
}
