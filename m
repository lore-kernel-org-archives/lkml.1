Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYIWOBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYIWOBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYIWNx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:53:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42312 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYIWNx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:53:27 -0400
Date: Tue, 23 Sep 2008 17:59:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Mayhar <fmayhar@google.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5 re-resubmit] Fix itimer/many thread hang.
Message-ID: <20080923135917.GA285@tv-sign.ru>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu> <1221502142.19012.35.camel@bobble.smo.corp.google.com> <20080916084143.GC17287@elte.hu> <1221678187.13420.17.camel@bobble.smo.corp.google.com> <20080918102353.GD20967@elte.hu> <1222114936.21579.20.camel@bobble.smo.corp.google.com> <20080923114033.GB14840@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923114033.GB14840@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Ingo Molnar wrote:
>
> below is the delta patch i've applied to tip/timers/posixtimers - might 
> be easier to review for those who've seen v1 and who'd like to check the 
> changes.
> ...
>
> +unsigned long long task_delta_exec(struct task_struct *p)
>  {
> +	struct rq *rq;
> +	unsigned long flags;
> +	u64 ns = 0;
> +
> +	rq = task_rq_lock(p, &flags);
>  	if (task_current(rq, p)) {
>  		u64 delta_exec;
>  
>  		update_rq_clock(rq);
>  		delta_exec = rq->clock - p->se.exec_start;
>  		if ((s64)delta_exec > 0)
> -			return delta_exec;
> +			ns = delta_exec;
>  	}
> -	return 0;
> -}
> -
> -/*
> - * Return p->sum_exec_runtime plus any more ns on the sched_clock
> - * that have not yet been banked in case the task is currently running.
> - */
> -unsigned long long task_sched_runtime(struct task_struct *p)
> -{
> -	unsigned long flags;
> -	u64 ns;
> -	struct rq *rq;
> -
> -	rq = task_rq_lock(p, &flags);
> -	ns = p->se.sum_exec_runtime + task_delta_exec(p, rq);
> -	task_rq_unlock(rq, &flags);
> -
> -	return ns;
> -}
> -
> -/*
> - * Return sum_exec_runtime for the thread group plus any more ns on the
> - * sched_clock that have not yet been banked in case the task is currently
> - * running.
> - */
> -unsigned long long thread_group_sched_runtime(struct task_struct *p)
> -{
> -	unsigned long flags;
> -	u64 ns;
> -	struct rq *rq;
> -	struct task_cputime totals;
> -
> -	rq = task_rq_lock(p, &flags);
> -	thread_group_cputime(p, &totals);
> -	ns = totals.sum_exec_runtime + task_delta_exec(p, rq);
> -	task_rq_unlock(rq, &flags);
>
>  	return ns;

Looks like task_delta_exec() forgets to unlock rq.

> +static inline void thread_group_cputime_account_exec_runtime(
> +	struct thread_group_cputime *tgtimes,
> +	unsigned long long ns)
> +{
> +	if (tgtimes->totals) {
> +		struct task_cputime *times;
> +
> +		times = per_cpu_ptr(tgtimes->totals, get_cpu());
> +		times->sum_exec_runtime += ns;
> +		put_cpu_no_resched();
> +	}
> +}
> +
> +#else /* CONFIG_SMP */
> +
> +static inline void thread_group_cputime_account_user(
> +	struct thread_group_cputime *tgtimes,
> +	cputime_t cputime)
> +{
> +	tgtimes->totals->utime = cputime_add(tgtimes->totals->utime, cputime);
> +}

Confused. Unless I misread the patch, tgtimes->totals can be NULL
on UP too?

Do we really need the special version for !CONFIG_SMP ? per_cpu_ptr()
just returns the pointer. Yes, get_cpu() disables preemption, but
perhaps this is tolerable?


(of course, this can't explain the crash)

Oleg.

