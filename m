Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZCIP5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZCIP5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZCIP5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:57:30 -0400
Received: from support.balabit.hu ([195.70.41.86]:49206 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751271AbZCIP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:57:30 -0400
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Balazs Scheidler <bazsi@balabit.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236585731.6118.24.camel@marge.simson.net>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 16:57:23 +0100
Message-Id: <1236614243.8114.8.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just an interesting sidenote:

I've ported the quoted patch and
38736f475071b80b66be28af7b44c854073699cc  (the one I've found via
bisect) to 2.6.27 but these didn't resolve my scheduling problem, both
my test program and my application still uses only one CPU. So probably
the rest of the scheduling patches between 2.6.27..2.6.28 have some
effect too.

On Mon, 2009-03-09 at 09:02 +0100, Mike Galbraith wrote:
> On Sun, 2009-03-08 at 18:52 +0100, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Sun, 2009-03-08 at 16:39 +0100, Ingo Molnar wrote:
> > > > * Mike Galbraith <efault@gmx.de> wrote:
> > > > 
> > > > > The problem with your particular testcase is that while one 
> > > > > half has an avg_overlap (what we use as affinity hint for 
> > > > > synchronous wakeups) which triggers the affinity hint, the 
> > > > > other half has avg_overlap of zero, what it was born with, so 
> > > > > despite significant execution overlap, the scheduler treats 
> > > > > them as if they were truly synchronous tasks.
> > > > 
> > > > hm, why does it stay on zero?
> > > 
> > > Wakeup preemption.  Presuming here: heavy task wakes light 
> > > task, is preempted, light task stuffs data into pipe, heavy 
> > > task doesn't block, so no avg_overlap is ever computed.  The 
> > > heavy task uses 100% CPU.
> > > 
> > > Running as SCHED_BATCH (virgin source), it becomes sane.
> > 
> > ah.
> > 
> > I'd argue then that time spent on the rq preempted _should_ 
> > count in avg_overlap statistics. I.e. couldnt we do something 
> > like ... your patch? :)
> > 
> > > >     if (sleep && p->se.last_wakeup) {
> > > >             update_avg(&p->se.avg_overlap,
> > > >                        p->se.sum_exec_runtime - p->se.last_wakeup);
> > > >             p->se.last_wakeup = 0;
> > > > -   }
> > > > +   } else if (p->se.avg_overlap < limit && runtime >= limit)
> > > > +           update_avg(&p->se.avg_overlap, runtime);
> > 
> > Just done unconditionally, i.e. something like:
> > 
> > 	if (sleep) {
> > 		runtime = p->se.sum_exec_runtime - p->se.last_wakeup;
> > 		p->se.last_wakeup = 0;
> > 	} else {
> > 		runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
> > 	}
> > 
> > 	update_avg(&p->se.avg_overlap, runtime);
> > 
> > ?
> 
> OK, I've not seen any problem indications yet, so find patchlet below.
> 
> However! Balazs has stated that this problem is _not_ present in .git,
> and that..
> 
> 	commit 38736f475071b80b66be28af7b44c854073699cc
> 	Author: Gautham R Shenoy <ego@in.ibm.com>
> 	Date:   Sat Sep 6 14:50:23 2008 +0530
> 
> ..is what fixed it.  Willy Tarreau verified this as being the case on
> his HW as well.  It is present in .git with my HW.
> 
> I see it as a problem, but it's your call.  Dunno if I'd apply it or
> hold back, given these conflicting reports.
> 
> Anyway...
> 
> Given a task pair communicating via pipe, if one partner fills/drains such
> that the other does not block for extended periods, avg_overlap can be long
> stale, and trigger affine wakeups despite heavy CPU demand.  This can, and
> does lead to throughput loss in the testcase posted by the reporter.
> 
> Fix this by unconditionally updating avg_overlap at dequeue time instead
> of only updating when a task sleeps.
> 
> See http://lkml.org/lkml/2009/3/7/79 for details/testcase.
> 
> Reported-by: Balazs Scheidler <bazsi@balabit.hu>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
>  kernel/sched.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8e2558c..c670050 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1712,12 +1712,17 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
>  
>  static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
>  {
> +	u64 runtime;
> +
>  	if (sleep && p->se.last_wakeup) {
> -		update_avg(&p->se.avg_overlap,
> -			   p->se.sum_exec_runtime - p->se.last_wakeup);
> +		runtime = p->se.sum_exec_runtime - p->se.last_wakeup;
>  		p->se.last_wakeup = 0;
> +	} else {
> +		runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
>  	}
>  
> +	update_avg(&p->se.avg_overlap, runtime);
> +
>  	sched_info_dequeued(p);
>  	p->sched_class->dequeue_task(rq, p, sleep);
>  	p->se.on_rq = 0;
> 
> 
> 
> 
-- 
Bazsi


