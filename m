Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZJJGiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZJJGiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZJJGiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:38:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:58154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZJJGiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:38:24 -0400
Subject: Re: sched: race between deactivate and switch sched_info
 accounting?
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0910091849070.22548@kitami.corp.google.com>
References: <alpine.DEB.2.00.0910091849070.22548@kitami.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Oct 2009 08:37:40 +0200
Message-Id: <1255156660.7866.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 19:40 -0700, Paul Turner wrote:

This looks very funny, I would expect that whoever does activate() on
that task to do the sched_info*() muck?

The below patch looks very asymmetric in that regard.

> It's possible for our previously de-activated task to be re-activated by a 
> remote cpu during lock balancing.  We have to account for this manually 
> since prev == next, yet the task just went through dequeue accounting.
> 
>  Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  kernel/sched.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ee61f45..6445d9d 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5381,7 +5381,7 @@ asmlinkage void __sched schedule(void)
>  	struct task_struct *prev, *next;
>  	unsigned long *switch_count;
>  	struct rq *rq;
> -	int cpu;
> +	int cpu, deactivated_prev = 0;
>  
>  need_resched:
>  	preempt_disable();
> @@ -5406,8 +5406,10 @@ need_resched_nonpreemptible:
>  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>  		if (unlikely(signal_pending_state(prev->state, prev)))
>  			prev->state = TASK_RUNNING;
> -		else
> +		else {
>  			deactivate_task(rq, prev, 1);
> +			deactivated_prev = 1;
> +		}
>  		switch_count = &prev->nvcsw;
>  	}
>  
> @@ -5434,8 +5436,15 @@ need_resched_nonpreemptible:
>  		 */
>  		cpu = smp_processor_id();
>  		rq = cpu_rq(cpu);
> -	} else
> +	} else {
> +		/*
> +		 * account for our previous task being re-activated by a
> +		 * remote cpu.
> +		 */
> +		if (unlikely(deactivated_prev))
> +			sched_info_switch(prev, prev);
>  		spin_unlock_irq(&rq->lock);
> +	}
>  
>  	post_schedule(rq);
>  
