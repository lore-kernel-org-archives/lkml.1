Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZLBMtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZLBMtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZLBMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:49:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:37695 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750737AbZLBMtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:49:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+hmZdwUDShrWBXGMXMW9zXS4QcHEsu347fmZvyMh
	NBicaUfmwRd/iv
Subject: Re: [patch]  f83f9ac causes tasks running at MAX_PRIO
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Williams <pwil3058@bigpond.net.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1259754383.4003.610.camel@laptop>
References: <1259501027.6268.9.camel@marge.simson.net>
	 <1259754383.4003.610.camel@laptop>
Content-Type: text/plain
Date: Wed, 02 Dec 2009 13:49:10 +0100
Message-Id: <1259758150.6167.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 12:46 +0100, Peter Zijlstra wrote:

> init_idle() doing:
>   idle->prio = idle->normal_prio = MAX_PRIO;
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
> spoils that too..

Darn.

> Ingo, any particular reason we set idle threads at MAX_PRIO? Can't we
> simply do something like below and be done with it?

Hysterical reasons?  That might have been a doorstop conversion kit for
O(1), but boots fine with CFS, and prio 40 tasks are history.

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

