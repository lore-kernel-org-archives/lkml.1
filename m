Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZBQPo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZBQPo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZBQPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:43:54 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51726 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZBQPnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:43:49 -0500
Date: Tue, 17 Feb 2009 07:43:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
Message-ID: <20090217154345.GD6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <20090216204902.GA6924@redhat.com> <1234818201.30178.386.camel@laptop> <20090216213205.GA9098@redhat.com> <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234862974.4744.31.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:29:34AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 00:19 +0100, Oleg Nesterov wrote:
> > On 02/16, Peter Zijlstra wrote:
> > >
> > > On Mon, 2009-02-16 at 23:02 +0100, Oleg Nesterov wrote:
> > > > On 02/16, Peter Zijlstra wrote:
> > > > >
> > > > > On Mon, 2009-02-16 at 22:32 +0100, Oleg Nesterov wrote:
> > > > > > > I was about to write a response, but found it to be a justification for
> > > > > > > the read_barrier_depends() at the end of the loop.
> > > > > >
> > > > > > I forgot to mention I don't understand the read_barrier_depends() at the
> > > > > > end of the loop as well ;)
> > > > >
> > > > > Suppose cpu0 adds to csd to cpu1:
> > > > >
> > > > >
> > > > >  cpu0:                 cpu1:
> > > > >
> > > > > add entry1
> > > > > mb();
> > > > > send ipi
> > > > >                       run ipi handler
> > > > >                       read_barrier_depends()
> > > > >                       while (!list_empty())    [A]
> > > > >                         do foo
> > > > >
> > > > > add entry2
> > > > > mb();
> > > > > [no ipi -- we still observe entry1]
> > > > >
> > > > >                         remove foo
> > > > >                         read_barrier_depends()
> > > > >                       while (!list_empty())      [B]
> > > >
> > > > Still can't understand.
> > > >
> > > > cpu1 (generic_smp_call_function_single_interrupt) does
> > > > list_replace_init(q->lock), this lock is also taken by
> > > > generic_exec_single().
> > > >
> > > > Either cpu1 sees entry2 on list, or cpu0 sees list_empty()
> > > > and sends ipi.
> > >
> > > cpu0:		cpu1:
> > >
> > > spin_lock_irqsave(&dst->lock, flags);
> > > ipi = list_empty(&dst->list);
> > > list_add_tail(&data->list, &dst->list);
> > > spin_unlock_irqrestore(&dst->lock, flags);
> > >
> > > ipi ----->
> > >
> > > 		while (!list_empty(&q->list)) {
> > >                 	unsigned int data_flags;
> > >
> > >                 	spin_lock(&q->lock);
> > >                		list_replace_init(&q->list, &list);
> > > 	                spin_unlock(&q->lock);
> > >
> > >
> > > Strictly speaking the unlock() is semi-permeable, allowing the read of
> > > q->list to enter the critical section, allowing us to observe an empty
> > > list, never getting to q->lock on cpu1.
> > 
> > Hmm. If we take &q->lock, then we alread saw !list_empty() ?
> 
> That's how I read the above code.
> 
> > And the question is, how can we miss list_empty() == F before spin_lock().
> 
> Confusion... my explanation above covers exactly this case. The reads
> determining list_empty() can slip into the q->lock section on the other
> cpu, and observe an empty list.
> 
> > > > Even if I missed something (very possible), then I can't understand
> > > > why we need rmb() only on alpha.
> > >
> > > Because only alpha is insane enough to do speculative reads? Dunno
> > > really :-)
> > 
> > Perhaps...
> > 
> > It would be nice to have a comment which explains how can we miss the
> > first addition without read_barrier_depends(). And why only on alpha.
> 
> Paul, care to once again enlighten us? The best I can remember is that
> alpha has split caches, and the rmb is needed for them to become
> coherent -- no other arch is crazy in exactly that way.

Many architectures use split caches, but Alpha made them independent.  :-/

Suppose that an Alpha system has a cache for each CPU, and that each CPU's
cache is split into banks so that even-numbered cache lines are placed
in one bank and odd-numbered cache lines in the other.  Then suppose
that CPU 0 executes the following code:

	p = malloc(sizeof(*p));
	if (p == NULL)
		deal_with_it();
	p->a = 42;
	smp_wmb(); /* this line and next same as rcu_assign_pointer().  */
	global_p = p;

This code will ensure that CPU 0 will commit the assignment to p->a to
coherent memory before commiting the assignment to global_p.

Suppose further that global_p is located in an even-numbered cache line
and that the newly allocated structure pointed to by p is in an
odd-numbered cache line.  Then suppose that CPU 1 executes the following
code:

	q = global_p;
	t = q->a;

Now, CPU 0 "published" the assignment to ->a before that to global_p,
but suppose that CPU 1's odd-numbered cache bank is very busy, so that
it has not yet processed the invalidation request corresponding to
CPU 0's assignment to p->a.

In this case, CPU 1 will see the new value of global_p, but the old
value of q->a.

This same result can be caused by certain types of value-speculation
compiler optimizations.

For more information, see:

http://www.rdrop.com/users/paulmck/scalability/paper/ordering.2007.09.19a.pdf

> But note that read_barrier_depends() is not quite a NOP for !alpha, it
> does that ACCESS_ONCE() thing, which very much makes a difference, even
> on x86.

You are thinking of rcu_dereference() rather than read_barrier_depends(),
right?

> > And arch/alpha/kernel/smp.c:handle_ipi() does mb() itself...
> 
> Right, but arguing by our memory model, we cannot assume that.

I assert that things like smp_call_function() need to perform whatever
memory barriers are required to ensure that the called function sees
any memory references performed on the originating CPU prior to the
smp_call_function().

						Thanx, Paul
