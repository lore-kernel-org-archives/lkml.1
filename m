Return-Path: <linux-kernel-owner+w=401wt.eu-S1765206AbXGNUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765206AbXGNUoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbXGNUob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:44:31 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:48739 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761558AbXGNUob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:44:31 -0400
Date: Sat, 14 Jul 2007 16:39:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 2/5] Thread Migration Preemption - v2
Message-ID: <20070714203924.GU6975@Krystal>
References: <20070714175733.194012000@chello.nl> <20070714175839.641246000@chello.nl> <20070714171646.GB746@tv-sign.ru> <1184438694.5284.69.camel@lappy> <1184440051.5284.72.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1184440051.5284.72.camel@lappy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:36:40 up 7 days, 10:41,  2 users,  load average: 0.29, 0.22, 0.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> How about somethign like this?
> 

Interesting approach.. then the process in its migrate disable critical
section will wake us up when it ends, but we are still available for
other migrations.

I'll try to merge this with what I have.

> ---
> 
> Avoid busy looping on unmigratable tasks by pushing the migration requests
> onto a delayed_migration_queue, which we try on each wakeup.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -288,6 +288,7 @@ struct rq {
>  
>  	struct task_struct *migration_thread;
>  	struct list_head migration_queue;
> +	struct list_head delayed_migration_queue;
>  #endif
>  
>  #ifdef CONFIG_SCHEDSTATS
> @@ -5623,6 +5624,11 @@ static int migration_thread(void *data)
>  		head = &rq->migration_queue;
>  
>  		if (list_empty(head)) {
> +			/*
> +			 * we got a wakeup, give the delayed list another shot.
> +			 */
> +			if (current->state != TASK_INTERRUPTIBLE)
> +				list_splice(&rq->delayed_migration_queue, head);
>  			spin_unlock_irq(&rq->lock);
>  			schedule();
>  			set_current_state(TASK_INTERRUPTIBLE);
> @@ -5641,8 +5647,7 @@ static int migration_thread(void *data)
>  			 * wake us up.
>  			 */
>  			spin_lock_irq(&rq->lock);
> -			head = &rq->migration_queue;
> -			list_add(&req->list, head);
> +			list_add(&req->list, &rq->delayed_migration_queue);
>  			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
>  			spin_unlock_irq(&rq->lock);
>  			wake_up_process(req->task);
> @@ -7006,6 +7011,7 @@ void __init sched_init(void)
>  		rq->cpu = i;
>  		rq->migration_thread = NULL;
>  		INIT_LIST_HEAD(&rq->migration_queue);
> +		INIT_LIST_HEAD(&rq->delayed_migration_queue);
>  #endif
>  		atomic_set(&rq->nr_iowait, 0);
>  
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
