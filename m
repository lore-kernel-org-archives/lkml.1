Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZBUBlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZBUBlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZBUBk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:40:58 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38133 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbZBUBk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:40:58 -0500
Date: Fri, 20 Feb 2009 17:40:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090221014056.GU6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 12:51:23AM +0100, Vegard Nossum wrote:
> 2009/2/20 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Fri, Feb 20, 2009 at 03:51:28PM +0100, Vegard Nossum wrote:
> >>
> >> I added some printks to __free_vmap_area() and rcu_free_va(), and it
> >> shows that the kfree() is being called immediately (inside the list
> >> traversal). So the call_rcu() is happening immediately (or almost
> >> immediately).
> >>
> >> If I've understood correctly, the RCU processing can happen inside a
> >> spinlock, as long as interrupts are enabled. (Won't the timer IRQ
> >> trigger softirq processing, which triggers RCU callback processing,
> >> for example?)
> >>
> >> And interrupts are enabled when this happens: EFLAGS: 00000292
> >>
> >> Please correct me if I am wrong!
> >
> > If you are using preemptable RCU, and if the read side accesses are not
> > protected by rcu_read_lock(), this can happen.  At least for values of
> > "immediately" in the millisecond range.
> >
> > If you were using classic or hierarchical RCU, the fact that the
> > call_rcu() is within a spinlock (as opposed to mutex) critical section
> > should prevent the grace period from ending.
> >
> > So, what flavor of RCU were you using?
> 
> $ grep RCU .config
> # RCU Subsystem
> # CONFIG_CLASSIC_RCU is not set
> CONFIG_TREE_RCU=y

OK, for this RCU implementation, disabling preemption should prevent
grace periods from completing.

Hmmm...

> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=32
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_PREEMPT_RCU_TRACE is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> 
> And at boot:
> 
> [    0.000000] Initializing CPU#0
> [    0.000000] Experimental hierarchical RCU implementation.
> [    0.000000] Experimental hierarchical RCU init done.
> 
> What I did for this list traversal was to put one print-out in front
> of the traversal, one after the traversal, one inside (so it would be
> called on each iteration), and one in the RCU callback. It looks
> something like this:
> 
> [  449.670460] __purge_vmap_area_lazy() list:
> [  449.671332] __free_vmap_area(c7806a40)
> [  449.674736] __free_vmap_area(c7806a80)
> [  449.675441] rcu_free_va(c7806a40)

This is 4.1 milliseconds, so is quite plausible.  Is the code -really-
disabling preemption for 4.1 milliseconds?

> [  449.677407] __free_vmap_area(c7806ac0)
> [  449.680113] rcu_free_va(c7806a80)

5.4 milliseconds...

> [  449.682821] __free_vmap_area(c7806b00)
> [  449.684264] rcu_free_va(c7806ac0)

6.9 milliseconds...

> [  449.686525] __free_vmap_area(c7806b40)
> [  449.688205] rcu_free_va(c7806b00)

5.4 milliseconds...

> ...and goes on for a long time, until something triggers this:
> 
> [  449.902253] rcu_free_va(c7839d00)
> [  449.903247] WARNING: kmemcheck: Caught 32-bit read from freed
> memory (c7839d20)
> 
> ...and finally:
> 
> [  457.580253] __purge_vmap_area_lazy() end
> [  457.581201] rcu_free_va(c78974c0)

And I don't see the corresponding __free_vmap_area() for either of the
above rcu_free_va() calls.  Would you be willing to forward the
timestamp for the __free_vmap_area() for c7839d20?

> So this is also what I meant by "immediately": The RCU callbacks are
> getting called inside the loop, and they're almost always paired with
> the list removal, or lagging one object behind.
> 
> My guess is that this code posts "too many callbacks", which would
> "force the grace period" according to __call_rcu() in
> kernel/rcutree.c. What do you think about this?

If the code really suppresses preemption across the whole loop, then
any attempt to force the grace period should fail.  Is it possible that
preemption is momentarily enabled somewhere within the loop?  Or that
we are seeing multiple passes through the loop rather than one big long
pass through the loop?

							Thanx, Paul
