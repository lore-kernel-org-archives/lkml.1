Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYFXJ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYFXJ7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYFXJ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:58:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYFXJ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:58:50 -0400
Subject: Re: [PATCH 2/3] sched: only run newidle if previous task was CFS
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       dbahi@novell.com
In-Reply-To: <20080623230445.31515.41728.stgit@lsg.lsg.lab.novell.com>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
	 <20080623230445.31515.41728.stgit@lsg.lsg.lab.novell.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 11:58:37 +0200
Message-Id: <1214301517.4351.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 17:04 -0600, Gregory Haskins wrote:
> A system that tends to overschedule (such as PREEMPT_RT) will naturally
> tend to newidle balance often as well.  This may have quite a negative
> impact on performance.  This patch attempts to address the overzealous
> newidle balancing by only allowing it to occur if the previous task
> was SCHED_OTHER.
> 
> Some may argue that if the system is going idle, it should try to
> newidle balance to keep it doing useful work.  But the fact is that
> spending too much time in the load-balancing code demonstrably hurts
> performance as well.  Running oprofile on the system with various
> workloads has shown that we can sometimes spend a majority of our
> cpu-time running load_balance_newidle.  Additionally, disabling
> newidle balancing can make said workloads increase in performance by
> up to 200%.  Obviously disabling the feature outright is not sustainable,
> but hopefully we can make it smarter. 
> 
> This code assumes that if there arent any CFS tasks present on the queue,
> it was probably already balanced.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

NAK, this wrecks idle balance for any potential other classes.

idle_balance() is the generical hook - as can be seen from the class
iteration in move_tasks().

I can imagine paritioned EDF wanting to make use of these hooks to
balance the reservations.

> ---
> 
>  kernel/sched.c      |    4 +---
>  kernel/sched_fair.c |    9 +++++++++
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 490e6bc..3efbbc5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1310,6 +1310,7 @@ static unsigned long source_load(int cpu, int type);
>  static unsigned long target_load(int cpu, int type);
>  static unsigned long cpu_avg_load_per_task(int cpu);
>  static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
> +static void idle_balance(int this_cpu, struct rq *this_rq);
>  #endif /* CONFIG_SMP */
>  
>  #include "sched_stats.h"
> @@ -4170,9 +4171,6 @@ asmlinkage void __sched __schedule(void)
>  		prev->sched_class->pre_schedule(rq, prev);
>  #endif
>  
> -	if (unlikely(!rq->nr_running))
> -		idle_balance(cpu, rq);
> -
>  	prev->sched_class->put_prev_task(rq, prev);
>  	next = pick_next_task(rq, prev);
>  
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 0ade6f8..2e22529 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1426,6 +1426,14 @@ static void moved_group_fair(struct task_struct *p)
>  }
>  #endif
>  
> +#ifdef CONFIG_SMP
> +static void pre_schedule_fair(struct rq *rq, struct task_struct *prev)
> +{
> +	if (unlikely(!rq->nr_running))
> +		idle_balance(rq->cpu, rq);
> +}
> +#endif
> +
>  /*
>   * All the scheduling class methods:
>   */
> @@ -1446,6 +1454,7 @@ static const struct sched_class fair_sched_class = {
>  #ifdef CONFIG_SMP
>  	.load_balance		= load_balance_fair,
>  	.move_one_task		= move_one_task_fair,
> +	.pre_schedule		= pre_schedule_fair,
>  #endif
>  
>  	.set_curr_task          = set_curr_task_fair,
> 

