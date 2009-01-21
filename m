Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbZAULNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbZAULNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZAULNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:13:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbZAULNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:13:07 -0500
Subject: Re: [PATCH] workqueue: not allow recursion run_workqueue
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4976EE11.7010007@cn.fujitsu.com>
References: <4976EE11.7010007@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 12:12:53 +0100
Message-Id: <1232536373.4847.115.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 17:42 +0800, Lai Jiangshan wrote:
> 1) lockdep will complain when recursion run_workqueue
> 2) works is not run orderly when recursion run_workqueue
> 
> 3) BUG!
>    We use recursion run_workqueue to hidden deadlock when
>    keventd trying to flush its own queue.
> 
>    It's bug. When flush_workqueue()(nested in a work callback)returns,
>    the workqueue is not really flushed, the sequence statement of
>    this work callback will do some thing bad.
> 
>    So we should not allow workqueue trying to flush its own queue.

The patch looks good, but I'm utterly failing to comprehend this
changelog. What exactly can go wrong (other than the obvious too deep
nest and the fact that lockdep will complain)?

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 2f44583..1129cde 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -48,8 +48,6 @@ struct cpu_workqueue_struct {
>  
>  	struct workqueue_struct *wq;
>  	struct task_struct *thread;
> -
> -	int run_depth;		/* Detect run_workqueue() recursion depth */
>  } ____cacheline_aligned;
>  
>  /*
> @@ -262,13 +260,6 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
>  static void run_workqueue(struct cpu_workqueue_struct *cwq)
>  {
>  	spin_lock_irq(&cwq->lock);
> -	cwq->run_depth++;
> -	if (cwq->run_depth > 3) {
> -		/* morton gets to eat his hat */
> -		printk("%s: recursion depth exceeded: %d\n",
> -			__func__, cwq->run_depth);
> -		dump_stack();
> -	}
>  	while (!list_empty(&cwq->worklist)) {
>  		struct work_struct *work = list_entry(cwq->worklist.next,
>  						struct work_struct, entry);
> @@ -311,7 +302,6 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
>  		spin_lock_irq(&cwq->lock);
>  		cwq->current_work = NULL;
>  	}
> -	cwq->run_depth--;
>  	spin_unlock_irq(&cwq->lock);
>  }
>  
> @@ -368,29 +358,20 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
>  
>  static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
>  {
> -	int active;
> +	int active = 0;
> +	struct wq_barrier barr;
>  
> -	if (cwq->thread == current) {
> -		/*
> -		 * Probably keventd trying to flush its own queue. So simply run
> -		 * it by hand rather than deadlocking.
> -		 */
> -		run_workqueue(cwq);
> -		active = 1;
> -	} else {
> -		struct wq_barrier barr;
> +	WARN_ON(cwq->thread == current);
>  
> -		active = 0;
> -		spin_lock_irq(&cwq->lock);
> -		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> -			insert_wq_barrier(cwq, &barr, &cwq->worklist);
> -			active = 1;
> -		}
> -		spin_unlock_irq(&cwq->lock);
> -
> -		if (active)
> -			wait_for_completion(&barr.done);
> +	spin_lock_irq(&cwq->lock);
> +	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> +		insert_wq_barrier(cwq, &barr, &cwq->worklist);
> +		active = 1;
>  	}
> +	spin_unlock_irq(&cwq->lock);
> +
> +	if (active)
> +		wait_for_completion(&barr.done);
>  
>  	return active;
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

