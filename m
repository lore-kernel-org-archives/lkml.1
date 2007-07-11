Return-Path: <linux-kernel-owner+w=401wt.eu-S1765379AbXGKQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765379AbXGKQfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXGKQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:35:24 -0400
Received: from mail.screens.ru ([213.234.233.54]:36805 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXGKQfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:35:23 -0400
Date: Wed, 11 Jul 2007 20:36:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] Thread Migration Preemption - v2
Message-ID: <20070711163648.GA232@tv-sign.ru>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru> <20070711044915.GA4025@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711044915.GA4025@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11, Mathieu Desnoyers wrote:
> 
> This patch adds the ability to protect critical sections from migration to
> another CPU without disabling preemption.
> 
> This will be useful to minimize the amount of preemption disabling for the -rt
> patch. It will help leveraging improvements brought by the local_t types in
> asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> variables protected by migrate_disable must be either atomic or protected from
> concurrent updates done by other threads.
> 
> Typical use:
> 
> migrate_disable();
> local_inc(&__get_cpu_var(&my_local_t_var));
> migrate_enable();
> 
> Which will increment the variable atomically wrt the local CPU.

Well, I am not a maintainer, but I personally think this patch is too complex.

Mathieu, please use "diff -p", it is very difficult to read it. I am not sure
I understand this patch correctly, I don't have a -git tree.

>  static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>  {
> @@ -4829,13 +4888,19 @@
>  
>  	double_rq_lock(rq_src, rq_dest);
>  	/* Already moved. */
> -	if (task_cpu(p) != src_cpu)
> +	if (task_cpu(p) != src_cpu) {
> +		ret = 1;
>  		goto out;
> +	}

This is a strange change. Why we return success when migration failed ?
OK, I guess this is a special hack for the modified migration_thread()...

>  	/* Affinity changed (again). */
>  	if (!cpu_isset(dest_cpu, p->cpus_allowed))
>  		goto out;
>  
>  	on_rq = p->se.on_rq;
> +#ifdef CONFIG_PREEMPT
> +	if (!on_rq && task_thread_info(p)->migrate_count)
> +		goto out;
> +#endif

This means that move_task_off_dead_cpu() will spin until the task will be scheduled
on the dead CPU. Given that we hold tasklist_lock and irqs are disabled, this may
never happen.

(This patch adds a lot of #ifdef's, I think it could be simplified if you add
 get_migrate_count() which is defined as 0 when !CONFIG_PREEMPT).

> @@ -4891,10 +4957,22 @@
>  		list_del_init(head->next);
>  
>  		spin_unlock(&rq->lock);
> -		__migrate_task(req->task, cpu, req->dest_cpu);
> +		migrated = __migrate_task(req->task, cpu, req->dest_cpu);
>  		local_irq_enable();
> -
> -		complete(&req->done);
> +		if (!migrated) {
> +			/*
> +			 * If the process has not been migrated, let it run
> +			 * until it reaches a migration_check() so it can
> +			 * wake us up.
> +			 */
> +			spin_lock_irq(&rq->lock);
> +			head = &rq->migration_queue;
> +			list_add(&req->list, head);
> +			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
> +			spin_unlock_irq(&rq->lock);
> +			wake_up_process(req->task);
> +		} else
> +			complete(&req->done);

I guess this is migration_thread(). The wake_up_process(req->task) looks strange,
why? It can't help if the task waits for the event/mutex.

And this is racy. What if check_migrate() is in progress, and the task has already
checked TIF_NEED_MIGRATE?

Hm. We re-add "req" to rq->migration_queue. This means that migration_thread() will
do a busy-wait loop. Not good and deadlockable, migration/X is SCHED_FIFO.
And what if __migrate_task() failed because ->cpus_allowed was changed in between?

Oleg.

