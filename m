Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbZKXRHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbZKXRHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933624AbZKXRHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:07:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:40124 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933592AbZKXRH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:07:29 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19itv95eORiRqjcYfnCtg8ud1H6PZIvmGnd01QsdW
	Rzpff/4rzhvQIM
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259070683.4531.1476.camel@laptop>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259070683.4531.1476.camel@laptop>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 18:07:29 +0100
Message-Id: <1259082449.15249.90.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 14:51 +0100, Peter Zijlstra wrote:

> > @@ -2566,7 +2565,7 @@ void sched_fork(struct task_struct *p, i
> >  	 * Revert to default priority/policy on fork if requested.
> >  	 */
> >  	if (unlikely(p->sched_reset_on_fork)) {
> > -		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR) {
> > +		if (task_has_rt_policy(p)) {
> >  			p->policy = SCHED_NORMAL;
> >  			p->normal_prio = p->static_prio;
> >  		}
> 
> While a nice change, it shouldn't have been mixed in I think.

Right, I'll remove it.

> > @@ -2589,16 +2588,10 @@ void sched_fork(struct task_struct *p, i
> >  	 */
> >  	p->prio = current->normal_prio;
> >  
> > -	if (!rt_prio(p->prio))
> > +	if (!task_has_rt_policy(p))
> >  		p->sched_class = &fair_sched_class;
> 
> And I suspect this one is actually buggy, see how rt_mutex_setprio()
> only changes ->prio and ->sched_class, but leaves ->policy to the
> original value?

In PI boosted or reset case, policy will be non-rt, but it's gone.

(hm. ? note to self: have another look at PI, and ask printk what
happens if a boosted rt task with sched_reset_on_fork set comes by)

> > @@ -2625,21 +2618,40 @@ void sched_fork(struct task_struct *p, i
> >   */
> >  void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
> >  {
> > +	int cpu = get_cpu();
> >  	unsigned long flags;
> > -	struct rq *rq;
> > +	struct task_struct *parent = current;
> > +	struct rq *rq, *orig_rq;
> >  
> > -	rq = task_rq_lock(p, &flags);
> > +	smp_wmb();
> > +	rq = orig_rq = task_rq_lock(parent, &flags);
> >  	BUG_ON(p->state != TASK_RUNNING);
> > -	update_rq_clock(rq);
> > +	update_rq_clock(orig_rq);
> >  
> > -	if (!p->sched_class->task_new || !current->se.on_rq) {
> > +	if (p->sched_class->task_new)
> > +		p->sched_class->task_new(orig_rq, p, 1);
> > +#ifdef CONFIG_SMP
> > +	p->state = TASK_WAKING;
> > +	__task_rq_unlock(orig_rq);
> > +	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
> > +	rq = cpu_rq(cpu);
> > +	if (rq != orig_rq) {
> > +		update_rq_clock(rq);
> > +		set_task_cpu(p, cpu);
> > +	}
> > +	__task_rq_lock(p);
> 
> [ should've been: rq == __task_rq_lock(p), because as we didn't hold the
> rq->lock the task could have actually been migrated again after
> set_task_cpu() ]

Oops, yes.

> > +	WARN_ON(p->state != TASK_WAKING);
> > +	p->state = TASK_RUNNING;
> > +#endif
> > +
> > +	if (!p->sched_class->task_new || !parent->se.on_rq) {
> >  		activate_task(rq, p, 0);
> >  	} else {
> >  		/*
> >  		 * Let the scheduling class do new task startup
> >  		 * management (if any):
> >  		 */
> > -		p->sched_class->task_new(rq, p);
> > +		p->sched_class->task_new(rq, p, 0);
> >  		inc_nr_running(rq);
> >  	}
> >  	trace_sched_wakeup_new(rq, p, 1);
> > @@ -2649,6 +2661,7 @@ void wake_up_new_task(struct task_struct
> >  		p->sched_class->task_wake_up(rq, p);
> >  #endif
> >  	task_rq_unlock(rq, &flags);
> > +	put_cpu();
> >  }
> 
> OK, so the general idea seems to be to call task_new(.prep=1) to update
> and copy vruntime from the parent to the child _before_ we muck about
> and move the child over to another cpu.

Right.  We need the parent's vruntime updated so the child cannot end up
left of it no matter where either party lives at wakeup time.  The child
has a copy of the parent's not yet updated vruntime.

> Then we muck about and move the thing to another cpu.
> 
> Then we call it again with .prep=0 to actually enqueue the thing.
> 
> So, the whole point of ->task_new() was to be able to poke at ->vruntime
> before the regular enqueue, I think we folded the enqueue in in order to
> avoid two class calls. But if you're going to do two calls, we might as
> well use ->task_new() and ->enqueue_task() aka activate_task().
> 
> This leaves the problem that task_new() behaviour depends on knowing the
> target cpu, could we solve that by relying on the fact that we're
> executing on the original cpu, something like:
> 
> void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
> {
> 	unsigned long flags;
> 	struct rq *rq, *orig_rq;
> 	int cpu = get_cpu();
> 
> 	rq = task_rq_lock(p, &flags);

Locking the child, but it's the parent, and parent's runqueue we must
modify.  We can't do that unlocked.

> 	BUG_ON(p->state != TASK_RUNNING);
> 	update_rq_clock(rq);
> 
> #ifdef CONFIG_SMP
> 	p->state = TASK_WAKING;
> 	__task_rq_unlock(rq);
> 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
> 	rq = cpu_rq(cpu);
> 	if (rq != orig_rq) {
> 		update_rq_clock(rq);
> 		set_task_cpu(p, cpu);
> 	}
> 	rq = __task_rq_lock(p);
> 	WARN_ON(p->state != TASK_WAKING);
> 	p->state = TASK_RUNNING;
> #endif
> 
> 	if (p->sched_class->task_new) {
> 		/* can detect migration through: task_cpu(p) != smp_processor_id() */

What if the parent was migrated before we got here?

> > @@ -1229,6 +1226,9 @@ static struct task_struct *copy_process(
> >  	/* Need tasklist lock for parent etc handling! */
> >  	write_lock_irq(&tasklist_lock);
> >  
> > +	/* Perform scheduler related setup. Assign this task to a CPU. */
> > +	sched_fork(p, clone_flags);
> > +
> 
> You just invalidated that comment ;-)

It's a dirty job, but _somebody_'s gotta do it ;-)  Will fix.

	-Mike

