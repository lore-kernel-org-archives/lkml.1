Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYHZOIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYHZOIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYHZOIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:08:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYHZOIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:08:21 -0400
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080826134348.GE7097@linux.vnet.ibm.com>
References: <20080822182915.GG6744@linux.vnet.ibm.com>
	 <48AF0735.60402@linux-foundation.org>
	 <20080822195226.GJ6744@linux.vnet.ibm.com>
	 <48AF1B81.3050806@linux-foundation.org>
	 <20080822205339.GK6744@linux.vnet.ibm.com> <1219660291.8515.20.camel@twins>
	 <20080825151220.GA6745@linux.vnet.ibm.com> <1219677736.8515.69.camel@twins>
	 <48B2D3BE.40101@linux-foundation.org> <1219679492.8515.77.camel@twins>
	 <20080826134348.GE7097@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 16:07:00 +0200
Message-Id: <1219759620.6462.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 06:43 -0700, Paul E. McKenney wrote:
> On Mon, Aug 25, 2008 at 05:51:32PM +0200, Peter Zijlstra wrote:
> > On Mon, 2008-08-25 at 10:46 -0500, Christoph Lameter wrote:
> > > Peter Zijlstra wrote:
> > > >
> > > > If we combine these two cases, and flip the counter as soon as we've
> > > > enqueued one callback, unless we're already waiting for a grace period
> > > > to end - which gives us a longer window to collect callbacks.
> > > > 
> > > > And then the rcu_read_unlock() can do:
> > > > 
> > > >   if (dec_and_zero(my_counter) && my_index == dying)
> > > >     raise_softirq(RCU)
> > > > 
> > > > to fire off the callback stuff.
> > > > 
> > > > /me ponders - there must be something wrong with that...
> > > > 
> > > > Aaah, yes, the dec_and_zero is non trivial due to the fact that its a
> > > > distributed counter. Bugger..
> > > 
> > > Then lets make it per cpu. If we get the cpu ops in then dec_and_zero would be
> > > very cheap.
> > 
> > Hmm, perhaps that might work for classic RCU, as that disables
> > preemption and thus the counters should always be balanced.
> 
> Unless you use a pair of global counters (like QRCU), you will still
> need to check a large number of counters for zero.  I suppose that one
> approach would be to do something like QRCU, but with some smallish
> number of counter pairs, each of which is shared by a moderate group of
> CPUs.  For example, for 4,096 CPUs, use 64 pairs of counters, each
> shared by 64 CPUs.  My guess is that the rcu_read_lock() overhead would
> make this be a case of "Holy overhead, Batman!!!", but then again, I
> cannot claim to be an expert on 4,096-CPU machines.

right - while the local count will be balanced and will always end up on
zero, you have to check remote counts for zero as well.

But after a counter flip, the dying counter will only reach zero once
per cpu.

So each cpu gets to tickle a softirq once per cycle. That softirq can
then check all remote counters, and kick off the callback list when it
finds them all zero.

Of course, this scan is very expensive, n^2 at worst, each cpu
triggering a full scan, until finally the last cpu is done.

We could optimize this by keeping cpu masks of cpus found to have !0
counts - those who were found to have 0, will always stay zero, so we'll
not have to look at them again.

Another is making use of a scanning hierarchy.

