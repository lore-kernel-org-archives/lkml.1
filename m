Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbYECSMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbYECSMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765566AbYECSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:12:13 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50296 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764975AbYECSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:12:12 -0400
Date: Sat, 3 May 2008 11:11:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080503181148.GA16159@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080430112934.GA23203@linux.vnet.ibm.com> <20080430113456.GY12774@kernel.dk> <20080430121712.GR11126@linux.vnet.ibm.com> <20080430123717.GC12774@kernel.dk> <20080502020241.GA26088@linux.vnet.ibm.com> <20080502021233.GC11844@wotan.suse.de> <20080502122955.GB15522@linux.vnet.ibm.com> <20080502124205.GA23680@linux.vnet.ibm.com> <1209733169.13978.157.camel@twins> <20080503054930.GA19664@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503054930.GA19664@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 07:49:30AM +0200, Nick Piggin wrote:
> On Fri, May 02, 2008 at 02:59:29PM +0200, Peter Zijlstra wrote:
> > On Fri, 2008-05-02 at 05:42 -0700, Paul E. McKenney wrote:
> > 
> > > And here is one scenario that makes me doubt that my imagination is
> > > faulty:
> > > 
> > > 1.	CPU 0 disables irqs.
> > > 
> > > 2.	CPU 1 disables irqs.
> > > 
> > > 3.	CPU 0 invokes smp_call_function().  But CPU 1 will never respond
> > > 	because its irqs are disabled.
> > > 
> > > 4.	CPU 1 invokes smp_call_function().  But CPU 0 will never respond
> > > 	because its irqs are disabled.
> > > 
> > > Looks like inherent deadlock to me, requiring that smp_call_function()
> > > be invoked with irqs enabled.
> > > 
> > > So, what am I missing here?
> > 
> > The wish to do it anyway ;-)
> > 
> > I can imagine some situations where I'd like to try anyway and fall back
> > to a slower path when failing.
> > 
> > With the initial design we would simply allocate data, stick it on the
> > queue and call the ipi (when needed).
> > 
> > This is perfectly deadlock free when wait=0 and it just returns -ENOMEM
> > on allocation failure.
> 
> Yeah, I'm just talking about the wait=0 case. (btw. I'd rather the core
> API takes some data rather than allocates some itself, eg because you
> might want to have it on the stack).

But taking data on the stack is safe only in the wait=1 case, right?

> For the wait=1 case, something very clever such as processing pending
> requests in a polling loop might be cool... however I'd rather not add
> such complexity until someone needs it (you could stick a comment in
> there outlining your algorithm). But I'd just rather not have peole rely
> on it yet.

In that case we may need to go back to the global lock with only one
request being processed at a time.  Otherwise, if two wait=1 requests
happen at the same time, they deadlock waiting for each other to process
their request.  (See Keith Owens: http://lkml.org/lkml/2008/5/2/183).

In other words, if you want to allow parallel calls to
smp_call_function(), the simplest way to do it seems to be to do the
polling loop.  The other ways I have come up with thus far are uglier
and less effective (see http://lkml.org/lkml/2008/4/30/164).

Now, what I -could- do would be to prohibit the wait=1 case from
irq-disable state from polling -- that would make sense, as the caller
probably had a reason to mask irqs, and might not take kindly to having
them faked behind the caller's back.  ;-)

> > It it doesn't return -ENOMEM I know its been queued and will be
> > processed at some point, if it does fail, I can deal with it in another
> > way.
> 
> At least with IPIs I think we can guarantee they will be processed on
> the target after we queue them.

OK, so let me make sure I understand what is needed.  One example might be
some code called from scheduler_tick(), which runs with irqs disabled.
Without the ability to call smp_call_function() directly, you have
to fire off a work queue or something.  Now, if smp_call_function()
can hand you an -ENOMEM or (maybe) an -EBUSY, then you still have to
fire off the work queue, but you probably only have to do it rarely,
minimizing the performance impact.

Another possibility is when it is -nice- to call smp_call_function(),
but can just try again on the next scheduler_tick() -- ignoring dynticks
idle for the moment.  In this case, you might still test the error return
to set a flag that you will check on the next scheduler_tick() call.

Is this where you guys are coming from?

And you are all OK with smp_call_function() called with irqs enabled
never being able to fail, right?  (Speaking of spaghetti code, why
foist unnecessary failure checks on the caller...)

> > I know I'd like to do that and I suspect Nick has a few use cases up his
> > sleeve as well.
> 
> It would be handy. The "quickly kick something off on another CPU" is
> pretty nice in mm/ when you have per-cpu queues or caches that might
> want to be flushed.

OK, I think I might be seeing what you guys are getting at.  Here is
what I believe you guys need:

1.	No deadlocks, ever, not even theoretical "low probability"
	deadlocks.

2.	No failure returns when called with irqs enabled.  On the other
	hand, when irqs are disabled, failure is possible.  Though hopefully
	unlikely.

3.	Parallel execution of multiple smp_call_function() requests
	is required, even when called with irqs disabled.

4.	The wait=1 case with irqs disabled is prohibited.

5.	If you call smp_call_function() with irqs disabled, then you
	are guaranteed that no other CPU's smp_call_function() handler
	will be invoked while smp_call_function() is executing.

Anything I am missing?

						Thanx, Paul
