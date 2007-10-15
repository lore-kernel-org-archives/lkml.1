Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbXJOSGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbXJOSGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbXJOSFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:05:53 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:56426 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbXJOSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:05:51 -0400
Date: Mon, 15 Oct 2007 14:05:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] RT: Add support for low-priority wake-up to push_rt
 feature
In-Reply-To: <20071013001559.7444.4125.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0710151349290.26495@gandalf.stny.rr.com>
References: <20071013001052.7444.8363.stgit@novell1.haskins.net>
 <20071013001559.7444.4125.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Fri, 12 Oct 2007, Gregory Haskins wrote:

> There are three events that require consideration for redistributing RT
> tasks:
>
> 1) When one or more higher-priority tasks preempts a lower-one from a
>    RQ
> 2) When a lower-priority task is woken up on a RQ
> 3) When a RQ downgrades its current priority
>
> Steve Rostedt's push_rt patch addresses (1).  It hooks in right after
> a new task has been switched-in.  If this was the result of an RT
> preemption, or if more than one task was awoken at the same time, we
> can try to push some of those other tasks away.
>
> This patch addresses (2).  When we wake up a task, we check to see
> if it would preempt the current task on the queue.  If it will not, we
> attempt to find a better suited CPU (e.g. one running something lower
> priority than the task being woken) and try to activate the task there.
>
> Finally, we have (3).  In theory, we only need to balance_rt_tasks() if
> the following conditions are met:
>    1) One or more CPUs are in overload, AND
>    2) We are about to switch to a task that lowers our priority.
>
> (3) will be addressed in a later patch.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/sched.c |   68 ++++++++++++++++++++++++++++++++++----------------------
>  1 files changed, 41 insertions(+), 27 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 62f9f0b..3c71156 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1628,6 +1628,12 @@ out:
>  	return ret;
>  }
>
> +/* Push all tasks that we can to other CPUs */
> +static void push_rt_tasks(struct rq *this_rq)
> +{
> +	while (push_rt_task(this_rq));

Loop conditions like this must be written as:

   while (push_rt_task(this_rq))
	;

So we don't accidently put something inside the loop if we forget to add
the semicolon, like:

   while (push_rt_task(this_rq)

   do_something_not_expected_to_loop();

Of course you end your function after that and thus we would get an
compile error if the semicolon were to be missing. But we might add
code afterwards.

> +}
> +
>  /*
>   * Pull RT tasks from other CPUs in the RT-overload
>   * case. Interrupts are disabled, local rq is locked.
> @@ -1988,7 +1994,33 @@ out_set_cpu:
>  		this_cpu = smp_processor_id();
>  		cpu = task_cpu(p);
>  	}
> -
> +
> +	/*
> +	 * If a newly woken up RT task cannot preempt the
> +	 * current (RT) task (on a target runqueue) then try
> +	 * to find another CPU it can preempt:
> +	 */
> +	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
> +		cpumask_t cpu_mask;
> +		cpus_and(cpu_mask, cpu_online_map, p->cpus_allowed);

Hmm, maybe I should put that mask into the find_lowest_cpu function.
Of course I changed this a little in my last patch.

> +
> +		new_cpu = find_lowest_cpu(&cpu_mask, p, rq);
> +		if ((new_cpu != -1) && (new_cpu != cpu)) {
> +			set_task_cpu(p, new_cpu);
> +			spin_unlock(&rq->lock);
> +
> +			/* The new lock was already acquired in find_lowest */
> +			rq = cpu_rq(new_cpu);
> +			old_state = p->state;
> +			if (!(old_state & state))
> +				goto out;
> +			if (p->se.on_rq)
> +				goto out_running;
> +
> +			this_cpu = smp_processor_id();

Could we have preempted to get a new this_cpu?

> +			cpu = task_cpu(p);
> +		}
> +	}
>  out_activate:
>  #endif /* CONFIG_SMP */
>  	update_rq_clock(rq);
> @@ -2002,30 +2034,13 @@ out_activate:
>  	 * to find another CPU it can preempt:
>  	 */
>  	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
> -		struct rq *this_rq = cpu_rq(this_cpu);
>  		/*
> -		 * Special-case: the task on this CPU can be
> -		 * preempted. In that case there's no need to
> -		 * trigger reschedules on other CPUs, we can
> -		 * mark the current task for reschedule.
> -		 *
> -		 * (Note that it's safe to access this_rq without
> -		 * extra locking in this particular case, because
> -		 * we are on the current CPU.)
> +		 * FIXME: Do we still need to do this here anymore, or
> +		 * does the preemption-check above suffice.  The path
> +		 * that makes my head hurt is when we have the
> +		 * task_running->out_activate path
>  		 */
> -		if (TASK_PREEMPTS_CURR(p, this_rq))
> -			set_tsk_need_resched(this_rq->curr);
> -		else
> -			/*
> -			 * Neither the intended target runqueue
> -			 * nor the current CPU can take this task.
> -			 * Trigger a reschedule on all other CPUs
> -			 * nevertheless, maybe one of them can take
> -			 * this task:
> -			 */
> -			smp_send_reschedule_allbutself_cpumask(p->cpus_allowed);
> -
> -		schedstat_inc(this_rq, rto_wakeup);
> +		push_rt_tasks(rq);

I think the question is, doesn't this make the above not needed? The
push_rt_tasks should do what the previous condition did.

Maybe I'm missing something.

>  	} else {
>  		/*
>  		 * Sync wakeups (i.e. those types of wakeups where the waker
> @@ -2360,13 +2375,12 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	 * the lock was owned by prev, we need to release it
>  	 * first via finish_lock_switch and then reaquire it.
>  	 */
> -	if (unlikely(rt_task(current))) {
> +	if (unlikely(rq->rt_nr_running > 1)) {

Heh, I guess that would work.

-- Steve

>  		spin_lock(&rq->lock);
> -		/* push_rt_task will return true if it moved an RT */
> -		while (push_rt_task(rq))
> -			;
> +		push_rt_tasks(rq);
>  		spin_unlock(&rq->lock);
>  	}
> +
>  #endif
>  	fire_sched_in_preempt_notifiers(current);
>  	trace_stop_sched_switched(current);
>
>
>
