Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZBITRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZBITRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZBITRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:17:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbZBITRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:17:41 -0500
Date: Mon, 9 Feb 2009 20:14:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090209191405.GA4561@redhat.com>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu> <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop> <498AA0F1.2030003@cn.fujitsu.com> <498B9675.3000202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B9675.3000202@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Lai Jiangshan wrote:
>
> 1) lockdep will complain when recursion run_workqueue()
> 2) The recursive implement of run_workqueue() makes flush_workqueue()
>    and it's doc are inconsistent. It may hide deadlock and other bugs.
> 3) recursion run_workqueue() will poison cwq->current_work,
>    but flush_work() and __cancel_work_timer() ...etc. need
>    reliable cwq->current_work.

I think this change is good. If we still have users which call flush
from work->func() they should be fixed, imho.

And while I knew this recursive flush is bad, I didn't realize how
bad it is until Lai spelled this. Thanks.

Acked-by: Oleg Nesterov <oleg@redhat.com>

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

