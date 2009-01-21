Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbZAUNCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbZAUNCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZAUNCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:02:25 -0500
Received: from gw2.cosmosbay.com ([86.64.20.130]:48514 "EHLO gw2.cosmosbay.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZAUNCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:02:25 -0500
Message-ID: <49771C9A.1030902@cosmosbay.com>
Date: Wed, 21 Jan 2009 14:01:14 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
References: <4976EE0B.5090200@cn.fujitsu.com>
In-Reply-To: <4976EE0B.5090200@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw2.cosmosbay.com [127.0.0.1]); Wed, 21 Jan 2009 14:01:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan a écrit :
> allocating memory for every cpu for single workqueue is waste.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 2f44583..ecd693d 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -99,7 +99,7 @@ static
>  struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
>  {
>  	if (unlikely(is_wq_single_threaded(wq)))
> -		cpu = singlethread_cpu;
> +		return wq->cpu_wq;
>  	return per_cpu_ptr(wq->cpu_wq, cpu);
>  }
>  
> @@ -417,7 +417,7 @@ void flush_workqueue(struct workqueue_struct *wq)
>  	lock_map_acquire(&wq->lockdep_map);
>  	lock_map_release(&wq->lockdep_map);
>  	for_each_cpu_mask_nr(cpu, *cpu_map)
> -		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
> +		flush_cpu_workqueue(wq_per_cpu(wq, cpu));
>  }
>  EXPORT_SYMBOL_GPL(flush_workqueue);
>  
> @@ -548,7 +548,7 @@ static void wait_on_work(struct work_struct *work)
>  	cpu_map = wq_cpu_map(wq);
>  
>  	for_each_cpu_mask_nr(cpu, *cpu_map)
> -		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
> +		wait_on_cpu_work(wq_per_cpu(wq, cpu), work);
>  }
>  
>  static int __cancel_work_timer(struct work_struct *work,
> @@ -752,17 +752,13 @@ int current_is_keventd(void)
>  
>  }
>  
> -static struct cpu_workqueue_struct *
> -init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
> +static void init_cpu_workqueue(struct workqueue_struct *wq,
> +		struct cpu_workqueue_struct *cwq)
>  {
> -	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> -
>  	cwq->wq = wq;
>  	spin_lock_init(&cwq->lock);
>  	INIT_LIST_HEAD(&cwq->worklist);
>  	init_waitqueue_head(&cwq->more_work);
> -
> -	return cwq;
>  }
>  
>  static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
> @@ -816,7 +812,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
>  	if (!wq)
>  		return NULL;
>  
> -	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
> +	if (singlethread)
> +		wq->cpu_wq = kmalloc(sizeof(*cwq), GFP_KERNEL);

kzalloc() here, since alloc_percpu() does the zeroing for you.

Or else run_depth is not initialized for example.

> +	else
> +		wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
>  	if (!wq->cpu_wq) {
>  		kfree(wq);
>  		return NULL;


