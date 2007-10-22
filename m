Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbXJVOGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbXJVOGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXJVOGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:06:04 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:64397 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXJVOGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:06:01 -0400
Subject: Re: [patch 6/8] pull RT tasks
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <b647ffbd0710210459y6116e85ek3d6feba6ec98231@mail.gmail.com>
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.983272715@goodmis.org>
	 <b647ffbd0710210459y6116e85ek3d6feba6ec98231@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 10:05:28 -0400
Message-Id: <1193061928.1912.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-21 at 13:59 +0200, Dmitry Adamushko wrote:
> On 19/10/2007, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > [ ... ]
> >
> > @@ -2927,6 +2927,13 @@ static void idle_balance(int this_cpu, s
> >         int pulled_task = -1;
> >         unsigned long next_balance = jiffies + HZ;
> >
> > +       /*
> > +        * pull_rt_task returns true if the run queue changed.
> > +        * But this does not mean we have a task to run.
> > +        */
> > +       if (unlikely(pull_rt_task(this_rq)) && this_rq->nr_running)
> > +               return;
> > +
> >         for_each_domain(this_cpu, sd) {
> >                 unsigned long interval;
> >
> > @@ -3614,6 +3621,7 @@ need_resched_nonpreemptible:
> >         if (unlikely(!rq->nr_running))
> >                 idle_balance(cpu, rq);
> >
> > +       schedule_balance_rt(rq, prev);
> 
> we do pull_rt_task() in idle_balance() so, I think, there is no need
> to do it twice.
> i.e.
>          if (unlikely(!rq->nr_running))
>                  idle_balance(cpu, rq);
> +       else
> +               schedule_balance_rt(rq, prev);
> 
> hum?

Ah, yes. That is probably better. We don't need to do the second pull if
the idle_balance is run. Thanks.

> 
> moreover (continuing my previous idea on "don't pull more than 1 task
> at once"), I wonder whether you really see cases when more than 1 task
> have been successfully _pushed_ over to other run-queues at once...
> 
> I'd expect the push/pull algorithm to naturally avoid such a
> possibility. Let's say we have a few RT tasks on our run-queue that
> are currently runnable (but not running)... the question is 'why do
> they still here?'
> 
> (1) because the previous attempt to _push_ them failed;
> (2) because they were not _pulled_ from other run-queues.
> 
> both cases should mean that other run-queues have tasks with higher
> prios running at the moment.
> 
> yes, there is a tiny window in schedule() between deactivate_task() [
> which can make this run-queue to look like we can push over to it ]
> and idle_balance() -> pull_rt_task() _or_ schedule_balance_rt() ->
> pull_rt_task() [ where this run-queue will try to pull tasks on its
> own ]
> 
> _but_ the run-queue is locked in this case so we wait in
> double_lock_balance() (from push_rt_task()) and run into the
> competition with 'src_rq' (which is currently in the 'tiny window' as
> described above trying to run pull_rt_task()) for getting both self_rq
> and src_rq locks...
> 
> this way, push_rt_task() always knows the task to be pushed (so it can
> be a bit optimized) --- as it's either a newly woken up RT task with
> (p->prio > rq->curr->prio) _or_ a preempted RT task (so we know 'task'
> for both cases).
> 
> To sum it up, I think that the pull/push algorithm should be able to
> naturally accomplish the proper job pushing/pulling 1 task at once (as
> described above)... any additional actions are just overhead or there
> is some problem with the algorithm (ah well, or with my understanding
> :-/ )

On wakeup, we can wake up several RT tasks (as my test case does) and if
we only push one task, then the other tasks may not migrate over to the
other run queues. I logged this happening in my tests.

The pull happens when we lower our priority in the scheduler. So we only
pull when we lower the priority since the push of rt tasks would not
push to a rq of higher priority. A waiting rt task may be able to run as
soon as we lower our priority. The only reason we pull more than one is
to cover the race between finding the highest prio runqueue, and having
that still be the highest task on the run queue when we go to pull it.
Although, I admit there are still races here. But hopefully the pushes
cover them.

We then again push on finish_task_switch, simply because we may need to
push the previous running task. On wake up and schedule, we can't push a
running task, so a rt task may wake up a higher priority rt task on the
same CPU as it is running, so when the higher priority rt task preempts
the current rt task, we want to push that current rt task off to another
CPU if possible. The first time this is possible is from
finish_task_switch when that current rt task is no longer running.

I'm currently working on getting RT overload logic to use cpusets, for
better NUMA and large CPU handling. So some of this logic will change in
the next series.

Thanks,

-- Steve

> 
> 

