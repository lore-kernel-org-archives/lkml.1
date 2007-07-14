Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbXGNTOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbXGNTOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760325AbXGNTO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:14:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40731 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265AbXGNTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:14:26 -0400
Subject: Re: [RFC] Thread Migration Preemption - v4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20070714184237.GI6975@Krystal>
References: <20070706060257.GA188@tv-sign.ru>
	 <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru>
	 <20070711044915.GA4025@Krystal> <20070711163648.GA232@tv-sign.ru>
	 <20070714184237.GI6975@Krystal>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 21:14:11 +0200
Message-Id: <1184440451.5284.75.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Would have been nice if you'd CC'ed me :-/

On Sat, 2007-07-14 at 14:42 -0400, Mathieu Desnoyers wrote:

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
> +		} else
> +			complete(&req->done);
>  	}
>  	__set_current_state(TASK_RUNNING);
>  	return 0;

I'm not really liking this, this way we hold up all other migration
requests.

