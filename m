Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbYHYPMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbYHYPMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYHYPMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:12:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48881 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYHYPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:12:35 -0400
Date: Mon, 25 Aug 2008 08:12:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
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
Message-ID: <20080825151220.GA6745@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <48AF0735.60402@linux-foundation.org> <20080822195226.GJ6744@linux.vnet.ibm.com> <48AF1B81.3050806@linux-foundation.org> <20080822205339.GK6744@linux.vnet.ibm.com> <1219660291.8515.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219660291.8515.20.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 12:31:31PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-08-22 at 13:53 -0700, Paul E. McKenney wrote:
> > On Fri, Aug 22, 2008 at 03:03:13PM -0500, Christoph Lameter wrote:
> > > Paul E. McKenney wrote:
> > > 
> > > > I was indeed thinking in terms of the free from RCU being specially marked.
> > > 
> > > Isnt there some way to shorten the rcu periods significantly? Critical
> > > sections do not take that long after all.
> > 
> > In theory, yes.  However, the shorter the grace period, the greater the
> > per-update overhead of grace-period detection -- the general approach
> > is to use a per-CPU high-resolution timer to force RCU grace period
> > processing every 100 microseconds or so.  
> 
> You could of course also drive the rcu state machine from
> rcu_read_unlock().

True, and Jim Houston implemented something similar to this some years
back: http://marc.theaimsgroup.com/?l=linux-kernel&m=109387402400673&w=2

This of course greatly increases rcu_read_unlock() overhead.  But
perhaps it is a good implementation for the workloads that Christoph is
thinking of.

> > Also, by definition, the RCU
> > grace period can be no shorter than the longest active RCU read-side
> > critical section.  Nevertheless, I have designed my current hierarchical
> > RCU patch with expedited grace periods in mind, though more for the
> > purpose of reducing latency of long strings of operations that involve
> > synchronize_rcu() than for cache locality.
> 
> Another thing that could be done is more often force a grace period by
> flipping the counters.

Yep.  That is exactly what I was getting at with the high-resolution
timer point above.  This seems to be a reasonable compromise, as it
allows someone to specify how quickly the grace periods happen
dynamically.

But I am not sure that this gets the grace periods to go fast enough to
cover Christoph's use case -- he seems to be in a "faster is better"
space rather than in an "at least this fast" space.  Still, it would
likely help in some important cases.

							Thanx, Paul
