Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbYLYIZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbYLYIZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 03:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYLYIZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 03:25:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51792 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYLYIZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 03:25:06 -0500
Date: Thu, 25 Dec 2008 09:24:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-cpu-timers:
	clock_gettime(CLOCK_THREAD_CPUTIME_ID) goes backward
Message-ID: <20081225082456.GA28479@elte.hu>
References: <4951F7E6.2080805@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4951F7E6.2080805@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4064,6 +4064,33 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
>  EXPORT_PER_CPU_SYMBOL(kstat);
>  
>  /*
> + * Return total of runtime which already banked and which not yet
> + * @p in case that task is currently running.
> + */
> +unsigned long long task_total_exec(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	struct rq *rq;
> +	u64 ns = 0;
> +
> +	rq = task_rq_lock(p, &flags);
> +
> +	if (task_current(rq, p)) {
> +		u64 delta_exec;
> +
> +		update_rq_clock(rq);
> +		delta_exec = rq->clock - p->se.exec_start;
> +		if ((s64)delta_exec > 0)
> +			ns = delta_exec;
> +	}
> +	ns += p->se.sum_exec_runtime;
> +
> +	task_rq_unlock(rq, &flags);
> +
> +	return ns;
> +}
> +

ok - the issue is real, but there's a few implementational details. Did 
you know about task_delta_exec()? This new function duplicates that 
function's behavior - and task_delta_exec() is already used by posix 
task/cpu timers.

I find your new task_total_exec() interface better (it's easier to use), 
could you have a look at eliminating task_delta_exec() users and migrating 
them over to task_total_exec()?

Maybe even change the name of sum_exec_runtime over to __sum_exec_runtime, 
to make sure nobody uses the 'raw' value - which is always stale up to one 
tick's worth of execution. Accessing that raw value would only make sense 
after the task has finished executing. (i.e. at cutime/cstime collection 
time)

	Ingo
