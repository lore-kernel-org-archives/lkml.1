Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXJCRhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXJCRhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbXJCRg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:36:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43743 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXJCRg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:36:58 -0400
Date: Wed, 3 Oct 2007 10:37:05 -0700
From: Mike Kravetz <kravetz@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: -rt scheduling: wakeup bug?
Message-ID: <20071003173705.GB4817@monkey.ibm.com>
References: <20071001221519.GA20671@monkey.ibm.com> <20071002050632.GB28345@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002050632.GB28345@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 07:06:32AM +0200, Ingo Molnar wrote:
> Index: linux-rt-rebase.q/kernel/sched.c
> ===================================================================
> --- linux-rt-rebase.q.orig/kernel/sched.c
> +++ linux-rt-rebase.q/kernel/sched.c
> @@ -1819,6 +1819,13 @@ out_set_cpu:
>  		cpu = task_cpu(p);
>  	}
> 
> +out_activate:
> +#endif /* CONFIG_SMP */
> +
> +	activate_task(rq, p, 1);
> +
> +	trace_start_sched_wakeup(p, rq);
> +
>  	/*
>  	 * If a newly woken up RT task cannot preempt the
>  	 * current (RT) task (on a target runqueue) then try
> @@ -1849,28 +1856,21 @@ out_set_cpu:
>  			smp_send_reschedule_allbutself_cpumask(p->cpus_allowed);
> 
>  		schedstat_inc(this_rq, rto_wakeup);
> -	}
> -
> -out_activate:
> -#endif /* CONFIG_SMP */
> -
> -	activate_task(rq, p, 1);
> -
> -	trace_start_sched_wakeup(p, rq);
> -
> -	/*
> -	 * Sync wakeups (i.e. those types of wakeups where the waker
> -	 * has indicated that it will leave the CPU in short order)
> -	 * don't trigger a preemption, if the woken up task will run on
> -	 * this cpu. (in this case the 'I will reschedule' promise of
> -	 * the waker guarantees that the freshly woken up task is going
> -	 * to be considered on this CPU.)
> -	 */
> -	if (!sync || cpu != this_cpu)
> -		check_preempt_curr(rq, p);
> -	else {
> -		if (TASK_PREEMPTS_CURR(p, rq))
> -			set_tsk_need_resched_delayed(rq->curr);
> +	} else {
> +		/*
> +		 * Sync wakeups (i.e. those types of wakeups where the waker
> +		 * has indicated that it will leave the CPU in short order)
> +		 * don't trigger a preemption, if the woken up task will run on
> +		 * this cpu. (in this case the 'I will reschedule' promise of
> +		 * the waker guarantees that the freshly woken up task is going
> +		 * to be considered on this CPU.)
> +		 */
> +		if (!sync || cpu != this_cpu)
> +			check_preempt_curr(rq, p);
> +		else {
> +			if (TASK_PREEMPTS_CURR(p, rq))
> +				set_tsk_need_resched_delayed(rq->curr);
> +		}
>  	}
>  	if (rq->curr && p && rq && _need_resched())
>  		trace_special_pid(p->pid, PRIO(p), PRIO(rq->curr));

Not an issue with the patch, just that last bit of code pulled in for
context.  I don't think it is a bug, but the checking of 'rq' after
checking 'rq->curr' just doesn't look right (or necessary).  Could it
just be an artifact from earlier versions of the code?

-- 
Mike
