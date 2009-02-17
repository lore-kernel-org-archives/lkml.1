Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZBQKMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZBQKMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZBQKLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:11:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:48108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZBQKLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:11:36 -0500
Date: Tue, 17 Feb 2009 11:11:30 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single ipi fallback for smp_call_function_many())
Message-ID: <20090217101130.GA8660@wotan.suse.de>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <20090216204902.GA6924@redhat.com> <1234818201.30178.386.camel@laptop> <20090216213205.GA9098@redhat.com> <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234862974.4744.31.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:29:34AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 00:19 +0100, Oleg Nesterov wrote:
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

But in that case, cpu0 should see list_empty and send another IPI,
because our load of list_empty has moved before the unlock of the
lock, so there can't be another item concurrently put on the list.

But hmm, why even bother with all this complexity? Why not just
remove the outer loop completely? Do the lock and the list_replace_init
unconditionally. It would turn tricky lockless code into simple locked
code... we've already taken an interrupt anyway, so chances are pretty
high that we have work here to do, right?


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

Other architectures can do speculative reads, and several (sparc, ia64,
powerpc AFAIK) do have release barrier semantics for their unlocks so
they could equally have loads passing spin_unlock.

Alpha has split cache I guess processing external cache coherency requests
independently. So it can see a pair of ordered stores coming from one
CPU (or CPUs if you want to get tricky I guess) in the wrong order.
This is not because of the loads being executed speculatively out of
order, although the end result is similar. The big difference why it
isn't hidden behind a regular smp_rmb() is because no CPU supported
by Linux does speculative loads over data dependencies, so we only
define smp_rmb to order loads that have no dependencies or only control
dependencies.

But you probably don't have to care about caches if it makes reasoning
easier. For all purposes it can be treated as Alpha speculatively
executing data dependent loads out of order I think eg.

x = *ptr;
y = array[x];

Then the CPU misses cache on the first load and thinks hmm, every
time I have loaded this it has been 10, so I'll do the 2nd load with
that value and retry if it turns out the prediction was wrong when
the 1st load completes. In the case that the 2nd load completes
first, and the prediction of the 1st load was correct, then the loads
were executed out of order... equivalent to out of order speculative
loads with control deps I guess.

But what actually happens on Alpha is not speculation but simply
the stores get seen in the wrong order.


