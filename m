Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZCQGSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZCQGSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZCQGSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:18:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50115 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZCQGR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:17:59 -0400
Date: Tue, 17 Mar 2009 15:16:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] posixtimers: Fix posix clock monotonicity
Message-Id: <20090317151632.a84528b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49BF3F73.5090007@jp.fujitsu.com>
References: <49BF3F73.5090007@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 15:13:07 +0900
Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> This patch rehires task_sched_runtime() and thread_group_sched_runtime()
> which were removed at the time of 2.6.28-rc1.
> 
> These functions protect the sampling of clock with rq lock.
> This rq lock is required not to update rq->clock during the sampling.
> i.e. You may get ((banked runtime before update)+(delta after update)).
> 
Does clock_gettime() go backward without lock ?

Thanks,
-Kame


> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: stable@kernel.org	[2.6.28.x]
> 
> ---
>  kernel/posix-cpu-timers.c |    7 +++--
>  kernel/sched.c            |   58 +++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 55 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 4e5288a..a65641a 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -294,7 +294,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>  		cpu->cpu = virt_ticks(p);
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = task_sched_runtime(p);
>  		break;
>  	}
>  	return 0;
> @@ -310,18 +310,19 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
>  {
>  	struct task_cputime cputime;
>  
> -	thread_group_cputime(p, &cputime);
>  	switch (CPUCLOCK_WHICH(which_clock)) {
>  	default:
>  		return -EINVAL;
>  	case CPUCLOCK_PROF:
> +		thread_group_cputime(p, &cputime);
>  		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
>  		break;
>  	case CPUCLOCK_VIRT:
> +		thread_group_cputime(p, &cputime);
>  		cpu->cpu = cputime.utime;
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = thread_group_sched_runtime(p);
>  		break;
>  	}
>  	return 0;
> diff --git a/kernel/sched.c b/kernel/sched.c
> index db66874..617d1b8 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4066,7 +4066,23 @@ EXPORT_PER_CPU_SYMBOL(kstat);
>  /*
>   * Return any ns on the sched_clock that have not yet been banked in
>   * @p in case that task is currently running.
> + *
> + * Called with task_rq_lock() held on @rq.
>   */
> +static u64 __task_delta_exec(struct task_struct *p, struct rq *rq)
> +{
> +	u64 ns = 0;
> +
> +	if (task_current(rq, p)) {
> +		update_rq_clock(rq);
> +		ns = rq->clock - p->se.exec_start;
> +		if ((s64)ns < 0)
> +			ns = 0;
> +	}
> +
> +	return ns;
> +}
> +
>  unsigned long long task_delta_exec(struct task_struct *p)
>  {
>  	unsigned long flags;
> @@ -4074,16 +4090,44 @@ unsigned long long task_delta_exec(struct task_struct *p)
>  	u64 ns = 0;
>  
>  	rq = task_rq_lock(p, &flags);
> +	ns = __task_delta_exec(p, rq);
> +	task_rq_unlock(rq, &flags);
>  
> -	if (task_current(rq, p)) {
> -		u64 delta_exec;
> +	return ns;
> +}
>  
> -		update_rq_clock(rq);
> -		delta_exec = rq->clock - p->se.exec_start;
> -		if ((s64)delta_exec > 0)
> -			ns = delta_exec;
> -	}
> +/*
> + * Return p->sum_exec_runtime plus any more ns on the sched_clock
> + * that have not yet been banked in case the task is currently running.
> + */
> +unsigned long long task_sched_runtime(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	struct rq *rq;
> +	u64 ns = 0;
> +
> +	rq = task_rq_lock(p, &flags);
> +	ns = p->se.sum_exec_runtime + __task_delta_exec(p, rq);
> +	task_rq_unlock(rq, &flags);
> +
> +	return ns;
> +}
>  
> +/*
> + * Return sum_exec_runtime for the thread group plus any more ns on the
> + * sched_clock that have not yet been banked in case the task is currently
> + * running.
> + */
> +unsigned long long thread_group_sched_runtime(struct task_struct *p)
> +{
> +	struct task_cputime totals;
> +	unsigned long flags;
> +	struct rq *rq;
> +	u64 ns;
> +
> +	rq = task_rq_lock(p, &flags);
> +	thread_group_cputime(p, &totals);
> +	ns = totals.sum_exec_runtime + __task_delta_exec(p, rq);
>  	task_rq_unlock(rq, &flags);
>  
>  	return ns;
> -- 
> 1.6.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

