Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbYGYLkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbYGYLkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYGYLjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:39:43 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:6017 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYGYLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:39:42 -0400
X-SourceIP: 62.163.52.83
Subject: Re: [patch, rfc: 1/2] sched, hotplug: safe use of
	rq->migration_thread and find_busiest_queue()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1216937517.5368.11.camel@earth>
References: <1216937517.5368.11.camel@earth>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 13:39:46 +0200
Message-Id: <1216985986.7257.375.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 00:11 +0200, Dmitry Adamushko wrote:
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: sched, hotplug: safe use of rq->migration_thread
> and find_busiest_queue()
> 
> ---
> 
>     sched, hotplug: safe use of rq->migration_thread and find_busiest_queue()
>     
>     (1) make usre rq->migration_thread is valid when we access it in set_cpus_allowed_ptr()
>     after releasing the rq-lock;
>     
>     (2) in load_balance() and load_balance_idle()
>     
>     ensure that we don't get 'busiest' which can disappear as a result of cpu_down()
>     while we are manipulating it. For this goal, we choose 'busiest' only amongst
>     'cpu_active_map' cpus.
>     
>     load_balance() and load_balance_idle() get called with preemption being disabled
>     so synchronize_sched() in cpu_down() should get us synced.
>     
>     IOW, as soon as synchronize_sched() has been done in cpu_down(cpu), the run-queue for
>     can't be manipulated/accessed by the load-balancer.
>     
>     Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6acf749..b4ccc8b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3409,7 +3409,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  	struct rq *busiest;
>  	unsigned long flags;
>  
> -	cpus_setall(*cpus);
> +	/*
> +	 * Ensure that we don't get 'busiest' which can disappear
> +	 * as a result of cpu_down() while we are manipulating it.
> +	 *
> +	 * load_balance() gets called with preemption being disabled
> +	 * so synchronize_sched() in cpu_down() should get us synced.
> +	 */
> +	*cpus = cpu_active_map;

This is going to be painful on -rt... there it can be preempted. I guess
we can put get_online_cpus() around it or something..

>  	/*
>  	 * When power savings policy is enabled for the parent domain, idle
> @@ -3571,7 +3578,14 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
>  	int sd_idle = 0;
>  	int all_pinned = 0;
>  
> -	cpus_setall(*cpus);
> +	/*
> +	 * Ensure that we don't get 'busiest' which can disappear
> +	 * as a result of cpu_down() while we are manipulating it.
> +	 *
> +	 * load_balance_newidle() gets called with preemption being disabled
> +	 * so synchronize_sched() in cpu_down() should get us synced.
> +	 */
> +	*cpus = cpu_active_map;
>  
>  	/*
>  	 * When power savings policy is enabled for the parent domain, idle
> @@ -5764,9 +5778,14 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
>  		goto out;
>  
>  	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
> -		/* Need help from migration thread: drop lock and wait. */
> +		/* Need to wait for migration thread (might exit: take ref). */
> +		struct task_struct *mt = rq->migration_thread;
> +
> +		get_task_struct(mt);
>  		task_rq_unlock(rq, &flags);
> -		wake_up_process(rq->migration_thread);
> +		wake_up_process(mt);
> +		put_task_struct(mt);
> +
>  		wait_for_completion(&req.done);
>  		tlb_migrate_finish(p->mm);
>  		return 0;
> 
> 

