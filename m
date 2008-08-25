Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYHYUEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYHYUEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYHYUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:04:28 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46037 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbYHYUE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:04:28 -0400
Date: Mon, 25 Aug 2008 13:04:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
Message-ID: <20080825200418.GG6745@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <48AF0735.60402@linux-foundation.org> <20080822195226.GJ6744@linux.vnet.ibm.com> <48AF1B81.3050806@linux-foundation.org> <20080822205339.GK6744@linux.vnet.ibm.com> <1219660291.8515.20.camel@twins> <20080825151220.GA6745@linux.vnet.ibm.com> <1219677736.8515.69.camel@twins> <48B2D3BE.40101@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B2D3BE.40101@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 10:46:06AM -0500, Christoph Lameter wrote:
> Peter Zijlstra wrote:
> >
> > If we combine these two cases, and flip the counter as soon as we've
> > enqueued one callback, unless we're already waiting for a grace period
> > to end - which gives us a longer window to collect callbacks.
> > 
> > And then the rcu_read_unlock() can do:
> > 
> >   if (dec_and_zero(my_counter) && my_index == dying)
> >     raise_softirq(RCU)
> > 
> > to fire off the callback stuff.
> > 
> > /me ponders - there must be something wrong with that...
> > 
> > Aaah, yes, the dec_and_zero is non trivial due to the fact that its a
> > distributed counter. Bugger..
> 
> Then lets make it per cpu. If we get the cpu ops in then dec_and_zero would be
> very cheap.

The problem is that we need dec_and_zero on the sum of the per-CPU
counters.  Gets spendy.  One can make a hierarchy, and propagate up.
But still lots of cache misses.

							Thanx, Paul
