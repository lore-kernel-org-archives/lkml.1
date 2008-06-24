Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYFXBIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYFXBIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYFXBH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:07:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46409 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYFXBHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:07:55 -0400
Date: Mon, 23 Jun 2008 21:07:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, dbahi@novell.com
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at least
 one task has moved over
In-Reply-To: <200806241050.12028.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.58.0806232104460.8540@gandalf.stny.rr.com>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
 <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
 <200806241050.12028.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Jun 2008, Nick Piggin wrote:

>
> On Tuesday 24 June 2008 09:04, Gregory Haskins wrote:
> > Inspired by Peter Zijlstra.
>
> Is this really getting tested well? Because at least for SCHED_OTHER
> tasks, the newidle balancer is still supposed to be relatively
> conservative and not over balance too much. By the time you have
> done all this calculation and reached here, it will be a loss to only
> move one task if you could have moved two and halved your newidle
> balance rate...

We've been finding a lot of our high latencies have been coming from the
balancing code. And the newidle balance is a large offender. I don't think
it's much wasted work for what you want. Even if we wasted the work done,
it was during "idle" time. But now we have a task to run, why not run it
now. Especially if that task is an RT task and doesn't like to wait.

The newidle balance should really just get a task to run, the balancing
code should be done at a later time. Ideally when no RT tasks need to run.

-- Steve


>
> > Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> > ---
> >
> >  kernel/sched.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 3efbbc5..c8e8520 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2775,6 +2775,10 @@ static int move_tasks(struct rq *this_rq, int
> > this_cpu, struct rq *busiest, max_load_move - total_load_moved,
> >  				sd, idle, all_pinned, &this_best_prio);
> >  		class = class->next;
> > +
> > +		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
> > +			break;
> > +
> >  	} while (class && max_load_move > total_load_moved);
> >
> >  	return total_load_moved > 0;
> >
> > --
>
