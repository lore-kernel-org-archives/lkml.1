Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbXHBTvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbXHBTvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbXHBTuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:50:55 -0400
Received: from mail.screens.ru ([213.234.233.54]:53621 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439AbXHBTux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:50:53 -0400
Date: Thu, 2 Aug 2007 23:50:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070802195049.GA361@tv-sign.ru>
References: <20070801181253.GA90@tv-sign.ru> <1185992994.2636.142.camel@imap.mvista.com> <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com> <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Gregory Haskins wrote:
>
> On Thu, 2007-08-02 at 02:22 +0400, Oleg Nesterov wrote:
> 
> > No,
> 
> You sure are a confident one ;)

Yeah, this is a rare case when I am very sure I am right ;)

I strongly believe you guys take a _completely_ wrong approach.
queue_work() should _not_ take the priority of the caller into
account, this is bogus.

Once again. Why do you think that queue_work() from RT99 should
be considered as more important? This is just not true _unless_
this task has to _wait_ for this work.

So, perhaps, perhaps, it makes sense to modify insert_wq_barrier()
so that it temporary raises the priority of cwq->thread to match
that of the caller of flush_workqueue() or cancel_work_sync().

However, I think even this is not needed. Please show us the real
life example why the current implementation sucks.

> > The comment near flush_workqueue() says:
> > 
> > 	* We sleep until all works which were queued on entry have been handled,
> > 	* but we are not livelocked by new incoming ones.
> 
> Dude, of *course* says that.  It would be completely illogical for it to
> say otherwise with the linear priority queue that mainline has.  Since
> we are changing things here you have to read between the lines and ask
> yourself "what is the intention of this barrier logic?".  Generally
> speaking, the point of a barrier is to flush relevant work from your own
> context, sometimes at the granularity of flushing everyone elses work
> inadvertently if the flush mechanism isn't fine grained enough.  But
> that is a side-effect, not a requirement.
> 
> So now my turn:
> 
> No. :P

OK. Suppose that we re-order work_struct's according to the caller's
priority.

Now, a niced thread doing flush_workqueue() can livelock if workqueue
is actively used.

Actually a niced (so that its priority is lower than cwq->thread's one)
can deadlock. Suppose it does

	lock(LOCK);
	flush_workueue(wq);

and we have a pending work_struct which does:

	void work_handler(struct work_struct *self)
	{
		if (!try_lock(LOCK)) {
			// try again later...
			queue_work(wq, self);
			return;
		}

		do_something();
	}

Deadlock. Because now the caller of queue_work() is cwq->thread itself,
so we insert this work ahead of the barrier which should complete
flush_workueue(wq) above.

There are other scenarious scenarios for more subtle deadlocks. Say,
the pending task doesn't touch LOCK itself, but schedules another
work which takes the LOCK.

[... snip a good portion of text which I wasn't able to translate
 and understand ... ;) ]

> > Now, again, why do you think this task should wait?
> 
> I don't think it *should* wait.  It *will* wait and we don't want that.
> And without PI-boost, it could wait indefinitely.  I think the detail
> you are missing is that the RT kernel introduces some new workqueue APIs
> that allow for "RPC" like behavior.  E.g. they are like
> "smp_call_function()", but instead of using an IPI, it uses workqueues
> to dispatch work to other CPUs.

Aha. And this is exactly what I meant above. And this means that flush
should govern the priority boosting, not queueing!

But again, I think we can just create a special workqueue for that and
make it RT99. No re-ordering, no playing games with re-niceing.

Because that workqueue should be "idle" most of the time (no pending
works), otherwise we are doing something wrong. And I don't think this
wq can have many users and work->func() shouldn't be heavy, so perhaps
it is OK if it always runs with the high priority. The latter may be
wrong though.

> However, you seem to have objections to the overall change in general

Well, yes... You propose the complex changes to solve the problem which
doesn't look very common, this makes me unhappy :)

Oleg.

