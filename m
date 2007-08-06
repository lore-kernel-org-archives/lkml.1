Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbXHFPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbXHFPe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXHFPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:34:46 -0400
Received: from mail.screens.ru ([213.234.233.54]:48353 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764148AbXHFPeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:34:44 -0400
Date: Mon, 6 Aug 2007 19:36:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070806153655.GA245@tv-sign.ru>
References: <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru> <1186400154.21381.40.camel@ghaskins-t60p.haskins.net> <20070806142616.GA210@tv-sign.ru> <1186412235.21381.82.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186412235.21381.82.camel@ghaskins-t60p.haskins.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Gregory Haskins wrote:
>
> On Mon, 2007-08-06 at 18:26 +0400, Oleg Nesterov wrote:
> 
> > Immediately, A inserts the work on CPU 1.
> 
> Well, if you didn't care about which CPU, that's true.  But suppose we
> want to direct this specifically at CWQ for cpu 0.

please see below...

> > It can livelock if other higher-priority threads add works to this wq
> > repeteadly.
> 
> That's really starvation, though.  I agree with you that it is
> technically possible to happen if the bandwidth of the higher priority
> producer task is greater than the bandwidth of the consumer.  But note
> that the RT priorities already forgo starvation avoidance, so IMO the
> queue can here as well.  E.g. if the system designer runs a greedy app
> at a high RT priority, it can starve as many lower priority items as it
> wants anyway.  This is no different.

OK.

> > > > Actually a niced (so that its priority is lower than cwq->thread's one)
> > > > can deadlock. Suppose it does
> > > > 
> > > > 	lock(LOCK);
> > > > 	flush_workueue(wq);
> > > > 
> > > > and we have a pending work_struct which does:
> > > > 
> > > > 	void work_handler(struct work_struct *self)
> > > > 	{
> > > > 		if (!try_lock(LOCK)) {
> > > > 			// try again later...
> > > > 			queue_work(wq, self);
> > > > 			return;
> > > > 		}
> > > > 
> > > > 		do_something();
> > > > 	}
> > > > 
> > > > Deadlock.
> > > 
> > > That code is completely broken, so I don't think it matters much.  But
> > > regardless, the new API changes will address that.
> > 
> > Sorry. This code is not very nice, but it is correct currently.
> 
> Well, the "trylock+requeue" avoids the obvious recursive deadlock, but
> it introduces a more subtle error: the reschedule effectively bypasses
> the flush.

this is OK, flush_workqueue() should only care about work_struct's that are
already queued.

> E.g. whatever work was being flushed was allowed to escape
> out from behind the barrier.  If you don't care about the flush working,
> why do it at all?

The caller of flush_workueue() doesn't necessary know we have such a work
on list. It just wants to flush its own works.

> But like I said, its moot...we will fix that condition at the API level
> (or move away from overloading the workqueues)

Oh, good :)

> > Well, if we can use smp_call_() we don't need these complications?
> 
> With an RT99 or smp_call() solution, all invocations effectively preempt
> whatever is running on the target CPU.  That is why I said it was the
> opposite problem.  A low priority client can preempt a high-priority
> task, which is just as bad as the current situation.

Aha, now I see what another problem you are trying to solve. I had a false
impression that might_sleep() is the issue.

After reading the couple of Peter's emails, I guess I am starting to
understand another issue. RT has irq threads, and they have different
priorities. So, in that case I agree, it is natural to consider the work
which was queued from the higher-priority irq thread as "more important".
Yes?

Oleg.

