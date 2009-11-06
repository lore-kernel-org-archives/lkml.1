Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZKFCbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZKFCbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 21:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbZKFCbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 21:31:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759204AbZKFCbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 21:31:19 -0500
Message-ID: <4AF38A72.9000900@cn.fujitsu.com>
Date: Fri, 06 Nov 2009 10:31:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: [patch] Re: There is something with scheduler (was Re: [patch]
 Re: [regression bisect -next] BUG: using smp_processor_id() in preemptible
 [00000000] code: rmmod)
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>	 <1256805552.7158.22.camel@marge.simson.net>	 <20091029091411.GE22963@elte.hu>	 <1256807967.7158.58.camel@marge.simson.net>	 <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu>	 <1257190811.19608.2.camel@marge.simson.net>	 <4AF2AC30.4000003@cn.fujitsu.com>	 <1257430388.6437.31.camel@marge.simson.net>	 <1257431437.7016.3.camel@marge.simson.net> <1257462632.6560.8.camel@marge.simson.net>
In-Reply-To: <1257462632.6560.8.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> A bit of late night cut/paste fixed it right up, so tomorrow, I can redo
> benchmarks etc etc.
> 
> Lai, mind giving this a try?  I believe this will fix your problem as
> well as mine.

My problem: a bound task is run on a different cpu. You haven't describe
how does it happen, how do you think this patch will fix my problem?

> 
> sched: fix runqueue locking buglet.
> 
> Calling set_task_cpu() with the runqueue unlocked is unsafe.  Add cpu_rq_lock()
> locking primitive, and lock the runqueue.  Also, update rq->clock before calling
> set_task_cpu(), as it could be stale.
> 
> Running netperf UDP_STREAM with two pinned tasks with tip 1b9508f applied emitted
> the thoroughly unbelievable result that ratelimiting newidle could produce twice
> the throughput of the virgin kernel.  Reverting to locking the runqueue prior to
> runqueue selection restored benchmarking sanity, as finally did this patchlet.
> 

[...]

> ---
>  kernel/sched.c |   38 +++++++++++++++++++++++++++++++-------
>  1 file changed, 31 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6.32.git/kernel/sched.c
> ===================================================================
> --- linux-2.6.32.git.orig/kernel/sched.c
> +++ linux-2.6.32.git/kernel/sched.c
> @@ -1011,6 +1011,32 @@ static struct rq *this_rq_lock(void)
>  	return rq;
>  }
>  
> +/*
> + * cpu_rq_lock - lock the runqueue a given task resides on and disable
> + * interrupts. Note the ordering: we can safely lookup the cpu_rq without
> + * explicitly disabling preemption.
> + */
> +static struct rq *cpu_rq_lock(int cpu, unsigned long *flags)
> +	__acquires(rq->lock)
> +{
> +	struct rq *rq;
> +
> +	for (;;) {
> +		local_irq_save(*flags);
> +		rq = cpu_rq(cpu);
> +		spin_lock(&rq->lock);
> +		if (likely(rq == cpu_rq(cpu)))
> +			return rq;
> +		spin_unlock_irqrestore(&rq->lock, *flags);
> +	}
> +}
> +
> +static inline void cpu_rq_unlock(struct rq *rq, unsigned long *flags)
> +	__releases(rq->lock)
> +{
> +	spin_unlock_irqrestore(&rq->lock, *flags);
> +}
> +

The above code is totally garbage, cpu_rq(cpu) is constant.

>  #ifdef CONFIG_SCHED_HRTICK
>  /*
>   * Use HR-timers to deliver accurate preemption points.
> @@ -2345,13 +2371,12 @@ static int try_to_wake_up(struct task_st
>  	task_rq_unlock(rq, &flags);
>  
>  	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> -	if (cpu != orig_cpu)
> -		set_task_cpu(p, cpu);
> -
> -	rq = task_rq_lock(p, &flags);
> -
> -	if (rq != orig_rq)
> +	if (cpu != orig_cpu) {
> +		rq = cpu_rq_lock(cpu, &flags);
>  		update_rq_clock(rq);
> +		set_task_cpu(p, cpu);

Process p's runqueue may not have been locked.


> +	} else
> +		rq = task_rq_lock(p, &flags);
>  
>  	if (rq->idle_stamp) {
>  		u64 delta = rq->clock - rq->idle_stamp;
> @@ -2365,7 +2390,6 @@ static int try_to_wake_up(struct task_st
>  	}
>  
>  	WARN_ON(p->state != TASK_WAKING);
> -	cpu = task_cpu(p);
>  
>  #ifdef CONFIG_SCHEDSTATS
>  	schedstat_inc(rq, ttwu_count);
> 
> 
> 
> 



