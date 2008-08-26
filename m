Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbYHZNkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbYHZNkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYHZNkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:40:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42777 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYHZNke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:40:34 -0400
Date: Tue, 26 Aug 2008 06:40:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues
	rather?than rcu
Message-ID: <20080826134030.GD7097@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <1219677736.8515.69.camel@twins> <48B2D3BE.40101@linux-foundation.org> <200808261513.40586.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261513.40586.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 03:13:40PM +1000, Nick Piggin wrote:
> On Tuesday 26 August 2008 01:46, Christoph Lameter wrote:
> > Peter Zijlstra wrote:
> > > If we combine these two cases, and flip the counter as soon as we've
> > > enqueued one callback, unless we're already waiting for a grace period
> > > to end - which gives us a longer window to collect callbacks.
> > >
> > > And then the rcu_read_unlock() can do:
> > >
> > >   if (dec_and_zero(my_counter) && my_index == dying)
> > >     raise_softirq(RCU)
> > >
> > > to fire off the callback stuff.
> > >
> > > /me ponders - there must be something wrong with that...
> > >
> > > Aaah, yes, the dec_and_zero is non trivial due to the fact that its a
> > > distributed counter. Bugger..
> >
> > Then lets make it per cpu. If we get the cpu ops in then dec_and_zero would
> > be very cheap.
> 
> Let's be very careful before making rcu read locks costly. Any reduction
> in grace periods would be great, but IMO RCU should not be used in cases
> where performance depends on the freed data remaining in cache.

Indeed!

But if you were in a situation where read-side overhead was irrelevant
(perhaps a mythical machine with zero-cost atomics and cache misses),
then one approach would be to combine Oleg Nesterov's QRCU with the
callback processing from Andrea Arcangeli's implementation from the 2001
timeframe.  Of course, if your cache misses really were zero cost,
then you wouldn't care about the data remaining in cache.  So maybe
a machine were cache misses to other CPUs' caches are free, but misses
to main memory are horribly expensive?

Anyway, the trick would be to adapt QRCU (http://lkml.org/lkml/2007/2/25/18)
to store the index in the task structure (as opposed to returning it
from rcu_read_lock()), and have a single global queue of callbacks,
guarded by a global lock.  Then rcu_read_unlock() can initiate callback
processing if the counter decrements down to zero, and call_rcu() would
also initiate a counter switch in the case where the non-current counter
was zero -- and this operation would be guarded by the same lock that
guards the callback queue.

But I doubt that this would be satisfactory on 4,096-CPU machines.
At least not in most cases.  ;-)

							Thanx, Paul
