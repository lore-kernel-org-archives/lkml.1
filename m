Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZKFXqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZKFXqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZKFXqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:46:43 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:38582 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbZKFXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:46:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RUiZ8zAAOHaHpYq/ZgxfCZmHSJyF3rUvoHqIT1dPKz+d5Kg5EJOSyTovsA6kciCS+i
         UD4AcV3OuHp940sgCKBl8O9DsqX/jH47TMua+YI495Yn+/0I8uBbu5vAFZ3b80v9Doi8
         uVOLNeF7syDSyA/Hfkq/gcCtHGKB+yBvQrZI8=
Message-ID: <4AF4B614.3080708@gmail.com>
Date: Fri, 06 Nov 2009 19:49:40 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Intermittent early panic in try_to_wake_up
References: <4AE0EBBD.6090005@gmail.com>	 <1256289781.22979.11.camel@marge.simson.net>  <4AF36364.9090004@gmail.com> <1257485650.6233.17.camel@marge.simson.net>
In-Reply-To: <1257485650.6233.17.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Hi Kevin,
> 
> 
> I may have found the bad thing that could have happened to ksoftirqd.
> 
> If you feel like testing, try the below.  We were altering the task
> struct outside of locks, which is not interrupt etc safe.  It cures a
> problem I ran into, and will hopefully cure yours as well.
> 
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
> runqueue selection restored benchmarking sanity, as did this patchlet.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>

The patch below does not apply to mainline, unless I'm doing something wrong.
It's against -tip, I assume?  Is it just as applicable to mainline?

> 
> ---
>  kernel/sched.c |   32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6.32.git/kernel/sched.c
> ===================================================================
> --- linux-2.6.32.git.orig/kernel/sched.c
> +++ linux-2.6.32.git/kernel/sched.c
> @@ -1011,6 +1011,24 @@ static struct rq *this_rq_lock(void)
>  	return rq;
>  }
>  
> +/*
> + * cpu_rq_lock - lock the runqueue a given cpu and disable interrupts.
> + */
> +static struct rq *cpu_rq_lock(int cpu, unsigned long *flags)
> +	__acquires(rq->lock)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +
> +	spin_lock_irqsave(&rq->lock, *flags);
> +	return rq;
> +}
> +
> +static inline void cpu_rq_unlock(struct rq *rq, unsigned long *flags)
> +	__releases(rq->lock)
> +{
> +	spin_unlock_irqrestore(&rq->lock, *flags);
> +}
> +
>  #ifdef CONFIG_SCHED_HRTICK
>  /*
>   * Use HR-timers to deliver accurate preemption points.
> @@ -2342,16 +2360,17 @@ static int try_to_wake_up(struct task_st
>  	if (task_contributes_to_load(p))
>  		rq->nr_uninterruptible--;
>  	p->state = TASK_WAKING;
> +	preempt_disable();
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
> +	} else
> +		rq = task_rq_lock(p, &flags);
> +	preempt_enable_no_resched();
>  
>  	if (rq->idle_stamp) {
>  		u64 delta = rq->clock - rq->idle_stamp;
> @@ -2365,7 +2384,6 @@ static int try_to_wake_up(struct task_st
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

