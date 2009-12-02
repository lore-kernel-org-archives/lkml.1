Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZLBODW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZLBODW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZLBODV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:03:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbZLBODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:03:21 -0500
Subject: Re: [patch]  f83f9ac causes tasks running at MAX_PRIO
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Williams <pwil3058@bigpond.net.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1259754383.4003.610.camel@laptop>
References: <1259501027.6268.9.camel@marge.simson.net>
	 <1259754383.4003.610.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 09:03:26 -0500
Message-Id: <1259762606.12870.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 12:46 +0100, Peter Zijlstra wrote:
> On Sun, 2009-11-29 at 14:23 +0100, Mike Galbraith wrote:
> 
> > sched: fix task priority bug.
> > 
> > f83f9ac removed a call to effective_prio() in wake_up_new_task(), which
> > leads to tasks running at MAX_PRIO.  That call set both the child's prio
> > and normal_prio fields to normal_prio(child).  Do the same fork time by
> > setting both to normal_prio(parent).
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Peter Williams <pwil3058@bigpond.net.au>
> > LKML-Reference: <new-submission>
> > 
> > ---
> >  kernel/sched.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -2609,7 +2609,7 @@ void sched_fork(struct task_struct *p, i
> >  	/*
> >  	 * Make sure we do not leak PI boosting priority to the child.
> >  	 */
> > -	p->prio = current->normal_prio;
> > +	p->prio = p->normal_prio = normal_prio(current);
> >  
> >  	if (!rt_prio(p->prio))
> >  		p->sched_class = &fair_sched_class;
> > 
> 
> Damn PI stuff makes my head hurt ;-)

I recommend Advil

> 
> So we've got:
> 
>  ->prio        - the actual effective priority    [ prio scale ]
>  ->normal_prio - the task's normal priority       [ prio scale ]
>  ->static_prio - SCHED_OTHER's nice value         [ prio scale ]
>  ->rt_priority - SCHED_FIFO/RR prio value  [ sched_param scale ]
> 
> [ with prio scale being:
> 
>   [0,    MAX_RT_PRIO-1]     [MAX_RT_PRIO, MAX_PRIO-1]
>    RT-100, RT-99..RT-1           NICE-20, NICE+19
> ]
> 
> So at sched_fork() we do the
> 
>  p->prio = p->normal_prio;
> 
> thing, to unboost.
> 
> If that results in MAX_PRIO, then our parent's ->normal_prio is stuffed.
> 
> Looking at the code I can see that happening because we've got:
> 
> init_idle() doing:
>   idle->prio = idle->normal_prio = MAX_PRIO;

But this is only called on the idle task, which should never fork.


> 
> Which will propagate... like reported.
> 
> Now, since the idle-threads usually run on &idle_sched_class, nobody
> will actually look at their ->prio, so having that out-of-range might
> make sense.
> 
> Just needs to get fixed up when we fork a normal thread, which would be
> in sched_fork(), now your call to normal_prio() fixes this by setting
> everything to ->static_prio for SCHED_OTHER tasks, however
> 
> migration_call()
>   CPU_DEAD:
>     rq->idle->static_prio = MAX_PRIO;
> 
> spoils that too, then again, at that point nothing will fork from that
> idle thread.

Well, that is when the CPU is dead, right?

> 
> Funny thing though, INIT_TASK() sets everything at MAX_PRIO-20.

Right, because the init task will fork. But once a task becomes idle, it
should never do anything (but service interrupts).

> 
> Ingo, any particular reason we set idle threads at MAX_PRIO? Can't we
> simply do something like below and be done with it?

There probably isn't any reason this can't be done, but I'm thinking we
may be papering over a bug instead of solving one.

-- Steve

> 
> ---
>  kernel/sched.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c0e4e9d..5ad5a66 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6963,7 +6963,6 @@ void __cpuinit init_idle(struct task_struct *idle,
> int cpu)
>  	__sched_fork(idle);
>  	idle->se.exec_start = sched_clock();
>  
> -	idle->prio = idle->normal_prio = MAX_PRIO;
>  	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
>  	__set_task_cpu(idle, cpu);
>  
> @@ -7667,7 +7666,6 @@ migration_call(struct notifier_block *nfb,
> unsigned long action, void *hcpu)
>  		spin_lock_irq(&rq->lock);
>  		update_rq_clock(rq);
>  		deactivate_task(rq, rq->idle, 0);
> -		rq->idle->static_prio = MAX_PRIO;
>  		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
>  		rq->idle->sched_class = &idle_sched_class;
>  		migrate_dead_tasks(cpu);
> 
> 

