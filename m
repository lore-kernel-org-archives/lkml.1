Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXH0Stj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXH0Stj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXH0Stc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:49:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41811 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbXH0Stb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:49:31 -0400
Date: Mon, 27 Aug 2007 22:49:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cliff Wickman <cpw@sgi.com>
Cc: akpm@linux-foundation.org, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V4: hotplug cpu: migrate a task within its cpuset
Message-ID: <20070827184939.GA104@tv-sign.ru>
References: <20070827183338.GA3752@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827183338.GA3752@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Cliff Wickman wrote:
> 
> With this patch, migrate the task to:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any online cpu within the task's cpuset
>  3) to any cpu which is both online and among that task's cpus_allowed

I think the patch is correct.

Actually, it looks like "bugfix: fix cpu-hotplug with cpusets interaction" to me.
Not only we migrate to the "right" CPU (accoridng to 2), we also try to preserve
the correct ->cpus_allowed to stay within our ->cpuset.

(if only I really understood what cpuset is :)

Oleg.

>  include/linux/cpuset.h |    5 +++++
>  kernel/cpuset.c        |   15 ++++++++++++++-
>  kernel/sched.c         |   13 ++++++++++++-
>  3 files changed, 31 insertions(+), 2 deletions(-)
> 
> Index: linus.070821/kernel/sched.c
> ===================================================================
> --- linus.070821.orig/kernel/sched.c
> +++ linus.070821/kernel/sched.c
> @@ -61,6 +61,7 @@
>  #include <linux/delayacct.h>
>  #include <linux/reciprocal_div.h>
>  #include <linux/unistd.h>
> +#include <linux/cpuset.h>
>  
>  #include <asm/tlb.h>
>  
> @@ -5093,8 +5094,16 @@ restart:
>  
>  	/* No more Mr. Nice Guy. */
>  	if (dest_cpu == NR_CPUS) {
> +		cpumask_t cpus_allowed = cpuset_cpus_allowed_locked();
> +		/*
> +		 * Try to stay on the same cpuset, where the current cpuset
> +		 * may be a subset of all cpus.
> +		 * The cpuset_cpus_allowed_locked() variant of
> +		 * cpuset_cpus_allowed() will not block
> +		 * It must be called within calls to cpuset_lock/cpuset_unlock.
> +		 */
>  		rq = task_rq_lock(p, &flags);
> -		cpus_setall(p->cpus_allowed);
> +		p->cpus_allowed = cpus_allowed;
>  		dest_cpu = any_online_cpu(p->cpus_allowed);
>  		task_rq_unlock(rq, &flags);
>  
> @@ -5412,6 +5421,7 @@ migration_call(struct notifier_block *nf
>  
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> +		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
>  		migrate_live_tasks(cpu);
>  		rq = cpu_rq(cpu);
>  		kthread_stop(rq->migration_thread);
> @@ -5425,6 +5435,7 @@ migration_call(struct notifier_block *nf
>  		rq->idle->sched_class = &idle_sched_class;
>  		migrate_dead_tasks(cpu);
>  		spin_unlock_irq(&rq->lock);
> +		cpuset_unlock();
>  		migrate_nr_uninterruptible(rq);
>  		BUG_ON(rq->nr_running != 0);
>  
> Index: linus.070821/include/linux/cpuset.h
> ===================================================================
> --- linus.070821.orig/include/linux/cpuset.h
> +++ linus.070821/include/linux/cpuset.h
> @@ -22,6 +22,7 @@ extern void cpuset_init_smp(void);
>  extern void cpuset_fork(struct task_struct *p);
>  extern void cpuset_exit(struct task_struct *p);
>  extern cpumask_t cpuset_cpus_allowed(struct task_struct *p);
> +extern cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>  #define cpuset_current_mems_allowed (current->mems_allowed)
>  void cpuset_init_current_mems_allowed(void);
> @@ -87,6 +88,10 @@ static inline cpumask_t cpuset_cpus_allo
>  {
>  	return cpu_possible_map;
>  }
> +static inline cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p)
> +{
> +	return cpu_possible_map;
> +}
>  
>  static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
>  {
> Index: linus.070821/kernel/cpuset.c
> ===================================================================
> --- linus.070821.orig/kernel/cpuset.c
> +++ linus.070821/kernel/cpuset.c
> @@ -2325,10 +2325,23 @@ cpumask_t cpuset_cpus_allowed(struct tas
>  	cpumask_t mask;
>  
>  	mutex_lock(&callback_mutex);
> +	mask = cpuset_cpus_allowed_locked(tsk);
> +	mutex_unlock(&callback_mutex);
> +
> +	return mask;
> +}
> +
> +/**
> + * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
> + * Must be  called with callback_mutex held.
> + **/
> +cpumask_t cpuset_cpus_allowed_locked(struct task_struct *tsk)
> +{
> +	cpumask_t mask;
> +
>  	task_lock(tsk);
>  	guarantee_online_cpus(tsk->cpuset, &mask);
>  	task_unlock(tsk);
> -	mutex_unlock(&callback_mutex);
>  
>  	return mask;
>  }

