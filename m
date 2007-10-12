Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbXJLRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbXJLRBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbXJLRBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:01:00 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:60290 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbXJLRA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:00:59 -0400
Date: Fri, 12 Oct 2007 13:00:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH RT] push RT tasks when overloaded (via schedule)
In-Reply-To: <1192207194.5797.27.camel@lappy>
Message-ID: <Pine.LNX.4.58.0710121253570.13326@gandalf.stny.rr.com>
References: <1192205153.12339.15.camel@localhost.localdomain>
 <1192207194.5797.27.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Fri, 12 Oct 2007, Peter Zijlstra wrote:

>
> On Fri, 2007-10-12 at 12:05 -0400, Steven Rostedt wrote:
>
> > Index: linux-2.6.23-rt1/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.23-rt1.orig/kernel/sched.c
> > +++ linux-2.6.23-rt1/kernel/sched.c
> > @@ -304,6 +304,7 @@ struct rq {
> >  #ifdef CONFIG_PREEMPT_RT
> >  	unsigned long rt_nr_running;
> >  	unsigned long rt_nr_uninterruptible;
> > +	int curr_prio;
>
> still not convinced we want this PREEMPT_RT only.

Neither am I, but I want testing first ;-)

>
> >  #endif
> >
> >  	unsigned long switch_timestamp;
> > @@ -1484,6 +1485,126 @@ next_in_queue:
> >
> >  static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
> >
> > +/* Only try this algorithm three times */
> > +#define RT_PUSH_MAX_TRIES 3
> > +
> > +/* Will lock the rq it finds */
> > +static int find_lowest_cpu(cpumask_t *cpu_mask, struct task_struct *task,
> > +				 struct rq *this_rq)
> > +{
>
> Eeew, asymetric locking. At the very least name it:
> find_lock_lowest_rq() or something like that.

Hehe, I originally had it that name (well without the lock). But I need
both the found cpu and the rq.  So instead of passing in a pointer to the
dst_cpu I just returned it, since it was simple to do a cpu_rq(). But if
you find this too grotesque, I can just return the cpu via a pointer.


>
> Might as well return struct rq* while we're at it [1].

That's what I originally did.

>
> > +	struct rq *lowest_rq = NULL;
> > +	int dst_cpu = -1;
> > +	int cpu;
> > +	int tries;
> > +
> > +	for (tries = 0; tries < RT_PUSH_MAX_TRIES; tries++) {
> > +		/*
> > +		 * Scan each rq for the lowest prio.
> > +		 */
> > +		for_each_cpu_mask(cpu, *cpu_mask) {
> > +			struct rq *rq = &per_cpu(runqueues, cpu);
> > +
> > +			if (cpu == smp_processor_id())
> > +				continue;
> > +
> > +			/* We look for lowest RT prio or non-rt CPU */
> > +			if (rq->curr_prio >= MAX_RT_PRIO) {
> > +				lowest_rq = rq;
> > +				dst_cpu = cpu;
> > +				break;
> > +			}
> > +
> > +			/* no locking for now */
> > +			if (rq->curr_prio > task->prio &&
> > +			    (!lowest_rq || rq->curr_prio < lowest_rq->curr_prio)) {
> > +				dst_cpu = cpu;
> > +				lowest_rq = rq;
> > +			}
> > +		}
> > +
> > +		if (!lowest_rq) {
> > +			dst_cpu = -1;
> > +			break;
> > +		}
> > +
> > +		/* if the prio of this runqueue changed, try again */
> > +		if (double_lock_balance(this_rq, lowest_rq)) {
> > +			/*
> > +			 * We had to unlock the run queue. In
> > +			 * the mean time, task could have
> > +			 * migrated already or had its affinity changed.
> > +			 */
> > +			if (unlikely(task_rq(task) != this_rq ||
> > +				     !cpu_isset(dst_cpu, task->cpus_allowed))) {
> > +				spin_unlock(&lowest_rq->lock);
> > +				dst_cpu = -1;
> > +				lowest_rq = NULL;
> > +				break;
> > +			}
> > +
> > +		}
> > +
> > +		/* If this rq is still suitable use it. */
> > +		if (lowest_rq->curr_prio > task->prio)
> > +			break;
> > +
> > +		/* try again */
> > +		spin_unlock(&lowest_rq->lock);
> > +		lowest_rq = NULL;
> > +		dst_cpu = -1;
> > +	}
> > +
> > +	return dst_cpu;
> > +}
> > +
> > +/*
> > + * If the current CPU has more than one RT task, see if the non
> > + * running task can migrate over to a CPU that is running a task
> > + * of lesser priority.
> > + */
> > +static int push_rt_task(struct rq *this_rq)
> > +{
> > +	struct task_struct *next_task;
> > +	struct rq *lowest_rq;
> > +	int dst_cpu;
> > +	int ret = 0;
> > +	cpumask_t cpu_mask;
> > +
> > +	assert_spin_locked(&this_rq->lock);
> > +
> > +	next_task = rt_next_highest_task(this_rq);
> > +	if (!next_task)
> > +		return 0;
> > +
> > +	cpus_and(cpu_mask, cpu_online_map, next_task->cpus_allowed);
> > +
> > +	/* We might release this_rq lock */
> > +	get_task_struct(next_task);
> > +
> > +	/* find_lowest_rq locks cpu_rq(dst_cpu) if found */
> > +	dst_cpu = find_lowest_cpu(&cpu_mask, next_task, this_rq);
> > +	if (dst_cpu < 0)
> > +		goto out;
> > +
> > +	lowest_rq = cpu_rq(dst_cpu);
> > +
>
> [1] Because that is what we use anyway.
>
> > +	assert_spin_locked(&lowest_rq->lock);
> > +
> > +	deactivate_task(this_rq, next_task, 0);
> > +	set_task_cpu(next_task, dst_cpu);

And here is where i need the dst_cpu. Do you prefer that I pass in the
cpu as a pointer? or just simply use lowest_rq->cpu. I guess that would
work too.

> > +	activate_task(lowest_rq, next_task, 0);
> > +
> > +	resched_task(lowest_rq->curr);
> > +
> > +	spin_unlock(&lowest_rq->lock);
> > +
> > +	ret = 1;
> > +out:
> > +	put_task_struct(next_task);
> > +
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Pull RT tasks from other CPUs in the RT-overload
> >   * case. Interrupts are disabled, local rq is locked.
> > @@ -2202,19 +2323,28 @@ static inline void finish_task_switch(st
> >  	 * be dropped twice.
> >  	 *		Manfred Spraul <manfred@colorfullife.com>
> >  	 */
> > +	prev_state = prev->state;
> > +	_finish_arch_switch(prev);
> > +#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
> > +	rq->curr_prio = current->prio;
> > +#endif
> > +	finish_lock_switch(rq, prev);
> >  #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
> >  	/*
> >  	 * If we pushed an RT task off the runqueue,
> > -	 * then kick other CPUs, they might run it:
> > -	 */
> > -	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
> > -		schedstat_inc(rq, rto_schedule);
> > -		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
> > +	 * then kick other CPUs, they might run it.
> > +	 * Note we may release the rq lock, and since
> > +	 * the lock was owned by prev, we need to release it
> > +	 * first via finish_lock_switch and then reaquire it.
> > +	 */
> > +	if (unlikely(rt_task(current))) {
> > +		spin_lock(&rq->lock);
> > +		/* push_rt_task will return true if it moved an RT */
> > +		while (push_rt_task(rq))
> > +			;
> > +		spin_unlock(&rq->lock);
> >  	}
> >  #endif
> > -	prev_state = prev->state;
> > -	_finish_arch_switch(prev);
> > -	finish_lock_switch(rq, prev);
>
> finish_lock_switch() seems to do spin_unlock_irq() in the tree I'm
> looking at. which mean you just 'forgot' to re-enable IRQs.

In my tree (2.6.23-rt1) it is just a spin_unlock().

-- Steve
