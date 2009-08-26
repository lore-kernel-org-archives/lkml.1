Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZHZSxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZHZSxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZHZSxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:53:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34439 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZHZSxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:53:00 -0400
Message-ID: <4A958480.3070207@us.ibm.com>
Date: Wed, 26 Aug 2009 11:52:48 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -rt] sched: fully ignore RT tasks for CFS load-balancing
References: <1251297875.18584.5.camel@twins>
In-Reply-To: <1251297875.18584.5.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Since -rt runs IRQs and SoftIRQs as RT tasks and load-balancing is done
> from softirq context, there is always at least one RT task (and very
> likely multiple) running when we balance.
> 
> The current (and totally broken) interaction between RT tasks and CFS
> load-balancing makes it so that we'll try to evacuate a significant
> amount of tasks due to RT tasks being runnable.
> 
> Solve this in another broken way by not accounting RT tasks at all.
> 
> This will likely break another class of cases, but until we can properly
> fix this, we might as well do this.

Peter,

Do we know why this became a problem lately?  I don't recall seeing load 
balancing issues like this way back around 2.6.21 or 22 when CFS was 
released.  Is the cpu_load stuff fairly recent?

--
Darren

> 
> Chucked-on-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_rt.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index adcbc68..385d31f 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -926,8 +926,6 @@ static void enqueue_task_rt(struct rq *rq, struct
> task_struct *p, int wakeup)
> 
>  	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
>  		enqueue_pushable_task(rq, p);
> -
> -	inc_cpu_load(rq, p->se.load.weight);
>  }
> 
>  static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int
> sleep)
> @@ -942,8 +940,6 @@ static void dequeue_task_rt(struct rq *rq, struct
> task_struct *p, int sleep)
>  	dequeue_rt_entity(rt_se);
> 
>  	dequeue_pushable_task(rq, p);
> -
> -	dec_cpu_load(rq, p->se.load.weight);
>  }
> 
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
