Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXIUACM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXIUACM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXIUAB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:01:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43350 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbXIUAB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:01:57 -0400
Date: Thu, 20 Sep 2007 17:01:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Message-ID: <20070921000155.GI9825@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070919174857.GA11922@linux.vnet.ibm.com> <d120d5000709191149q3d850d07nd8bf864a6e797055@mail.gmail.com> <20070919214110.5d832f28@lappy> <d120d5000709191249w461967d6w8da303dc54f2dd41@mail.gmail.com> <20070919221349.2935f69d@lappy> <d120d5000709191341p1c331e80qf7bad973bc899a0@mail.gmail.com> <20070919231943.4b121361@lappy> <d120d5000709191429n29f5dc78g2746de3ee4e9ca81@mail.gmail.com> <20070919234700.3b532dcd@lappy> <d120d5000709201031o687ac0d5qe4d32406c12a7886@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000709201031o687ac0d5qe4d32406c12a7886@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 01:31:35PM -0400, Dmitry Torokhov wrote:
> On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Wed, 19 Sep 2007 17:29:09 -0400 "Dmitry Torokhov"
> > <dmitry.torokhov@gmail.com> wrote:
> >
> > > On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > On Wed, 19 Sep 2007 16:41:04 -0400 "Dmitry Torokhov"
> > > > <dmitry.torokhov@gmail.com> wrote:
> > > >
> > > > > > If the IRQ handler does rcu_read_lock(),unlock() and the i8042_stop()
> > > > > > function does sync_rcu() instead of _sched(), it should be good again.
> > > > > > It will not affect anything else than the task that calls _stop(). And
> > > > > > even there the only change is that the sleep might be a tad longer.
> > > > >
> > > > > And the IRQ handler needs to do some extra job... Anyway, it looks -rt
> > > > > breaks synchronize_sched() and needs to have it fixed:
> > > > >
> > > > > "/**
> > > > >  * synchronize_sched - block until all CPUs have exited any non-preemptive
> > > > >  * kernel code sequences.
> > > > >  *
> > > > >  * This means that all preempt_disable code sequences, including NMI and
> > > > >  * hardware-interrupt handlers, in progress on entry will have completed
> > > > >  * before this primitive returns."
> > > >
> > > > That still does as it says in -rt. Its just that the interrupt handler
> > > > will be preemptible so the guarantees it gives are useless.
> > >
> > > Please note "... including NMI and hardware-interrupt handlers ..."
> >
> > -rt doesn't run interrupt handlers in hardware irq context anymore.
> 
> OK, then what is the purpose of synchronize_sched() in -rt?

To wait for all preempt-disable, irq-disable, hard-irq, and SMI/NMI code
sequences to complete.

> You really need to provide users with a replacement. There are several
> drivers that use it and for example r8169 is not what you'd call a
> 'low performer'.

I did look at making a synchronize_all_irq() some time back, and all
the approaches I came up with at the time were busted.

But I just took another look, and I think I see a way to handle it.
Either that, or I simply forgot the way in which this approach is
broken...

I will stare at is some more.

> I guess I can switch i8042 to use synchronize_irq(). That still works
> in -rt, doesn't it? That still leaves atkbd...

Yep, looks that way to me.  The only difference that I can see is that
in -rt, concurrent synchronize_irq() calls on the same descriptor mean
that the guy that gets there second has to wait for the next interrupt
to happen.

> > > > > > I find it curious that a driver that is 'low performant' and does not
> > > > > > suffer lock contention pioneers locking schemes. I agree with
> > > > > > optimizing, but this is not the place to push the envelope.
> > > > >
> > > > > Please realize that evey microsecond wasted on a 'low performant'
> > > > > driver is taken from high performers and if we can help it why
> > > > > shouldn't we?
> > > >
> > > > sure, but the cache eviction caused by running the driver will have
> > > > more impact than the added rcu_read_{,un}lock() calls.
> > >
> > > Are you saying that adding rcu_read_{,un}lock() will help with cache
> > > eviction? How?
> >
> > No, I'm saying that its noise compared to the cache eviction overhead
> > it causes for others.
> 
> What about udelay(10)? It is probably also a noise but we shoudl not
> go and sprinkle it through drivers, should we? ;)

Agreed!

On the other hand, udelay(10) is more than two orders of magnitude
slower than an rcu_read_lock() / rcu_read_unlock() round trip in -rt,
and a full three orders of magnitude slower in CONFIG_PREEMPT.
As for non-CONFIG_PREEMPT, well, "free is a very good price".  ;-)

						Thanx, Paul
