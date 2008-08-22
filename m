Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYHVPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYHVPMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYHVPMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:12:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49133 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHVPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:12:06 -0400
Date: Fri, 22 Aug 2008 08:11:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
Message-ID: <20080822151156.GA6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AEC6B2.1080701@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 09:01:22AM -0500, Christoph Lameter wrote:
> Pekka Enberg wrote:
> > Hi Ingo,
> > 
> > On Fri, Aug 22, 2008 at 9:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >>
> >>> RCU can only control the lifetime of allocated memory blocks, which
> >>> forces all the call structures to be allocated.  This is expensive
> >>> compared to allocating them on the stack, which is the common case for
> >>> synchronous calls.
> >>>
> >>> This patch takes a different approach.  Rather than using RCU, the
> >>> queues are managed under rwlocks.  Adding or removing from the queue
> >>> requires holding the lock for writing, but multiple CPUs can walk the
> >>> queues to process function calls under read locks.  In the common
> >>> case, where the structures are stack allocated, the calling CPU need
> >>> only wait for its call to be done, take the lock for writing and
> >>> remove the call structure.
> >>>
> >>> Lock contention - particularly write vs read - is reduced by using
> >>> multiple queues.
> >> hm, is there any authorative data on what is cheaper on a big box, a
> >> full-blown MESI cache miss that occurs for every reader in this new
> >> fastpath, or a local SLAB/SLUB allocation+free that occurs with the
> >> current RCU approach?
> > 
> > Christoph might have an idea about it.
> 
> Its on the stack which is presumably hot so no cache miss? If its async then
> presumably we do not need to wait so its okay to call an allocator.
> 
> Generally: The larger the box (longer cacheline acquisition latencies) and the
> higher the contention (cannot get cacheline because of contention) the better
> a slab allocation will be compared to a cacheline miss.
> 
> RCU is problematic because it lets cachelines get cold. A hot cacheline that
> is used frequently read and written to by the same cpu is very good thing for
> performace.

So on your these large boxes, read-only cachelines are preferentially
ejected from the cache, so that one should write to per-CPU data
occasionally to keep it resident?  Or is the issue the long RCU grace
periods which allow the structure being freed to age out of all relevant
caches?  (My guess would be the second.)

							Thanx, Paul
