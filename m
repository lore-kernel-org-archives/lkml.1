Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbXGNUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbXGNUXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762972AbXGNUXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:23:37 -0400
Received: from mail.screens.ru ([213.234.233.54]:47008 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762510AbXGNUXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:23:36 -0400
Date: Sun, 15 Jul 2007 00:23:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] Thread Migration Preemption - v4
Message-ID: <20070714202356.GA137@tv-sign.ru>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru> <20070711044915.GA4025@Krystal> <20070711163648.GA232@tv-sign.ru> <20070714184237.GI6975@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714184237.GI6975@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Mathieu Desnoyers wrote:
>
> @@ -4891,10 +4948,42 @@ static int migration_thread(void *data)
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
> +			if (req->task->se.on_rq
> +					|| !task_migrate_count(req->task)) {
> +				/*
> +				 * The process is on the runqueue, it could
> +				 * exit its critical section at any moment,
> +				 * don't race with it and retry actively.
> +				 * Also, if the thread is not on the runqueue
> +				 * and has a zero migration count
> +				 * (__migrate_task failed because cpus allowed
> +				 * changed), just retry.
> +				 */
> +				spin_unlock_irq(&rq->lock);
> +				continue;

Again, this can deadlock. migration_thread() is SCHED_FIFO, and it shares the
same CPU with req->task. We are doing a busy-wait loop, req->task may have no
chance to finish its critical section.

> +			}
> +			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			spin_unlock_irq(&rq->lock);
> +			/*
> +			 * Wait for the process currently in its critical
> +			 * section.
> +			 */
> +			wake_up_process(req->task);
> +			schedule();

As Peter pointed out, we hold up all other migration requests.

And worse, this can hang forever (until another req comes). do_check_migrate()
can wake_up() the wrong rq.

set_current_state(TASK_INTERRUPTIBLE) is bogus, we can miss a wakeup from
(say) sched_migrate_task().

Oleg.

