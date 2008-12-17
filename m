Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759905AbYLQIFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbYLQIFh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYLQIF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:05:27 -0500
Received: from viefep18-int.chello.at ([62.179.121.38]:33036 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751745AbYLQIF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:05:26 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] schedstat: consolidate per-task cpu runtime stats
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b040c32a0812162341v1fe5f419xfa379c880ca4c8da@mail.gmail.com>
References: <b040c32a0812162341v1fe5f419xfa379c880ca4c8da@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 09:05:19 +0100
Message-Id: <1229501119.9487.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 23:41 -0800, Ken Chen wrote:
> When we turn on CONFIG_SCHEDSTATS, per-task cpu runtime is accumulated
> twice. Once in task->se.sum_exec_runtime and once in sched_info.cpu_time.
> These two stats are exactly the same.
> 
> Given that task->se.sum_exec_runtime is always accumulated by the core
> scheduler, sched_info can reuse that data instead of duplicate the accounting.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

Looks good, thanks!

> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index d467760..4d745ba 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -347,7 +347,7 @@
>  static int proc_pid_schedstat(struct task_struct *task, char *buffer)
>  {
>  	return sprintf(buffer, "%llu %llu %lu\n",
> -			task->sched_info.cpu_time,
> +			task->se.sum_exec_runtime,
>  			task->sched_info.run_delay,
>  			task->sched_info.pcount);
>  }
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 55e30d1..a0fa340 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -672,8 +672,7 @@ struct reclaim_state;
>  struct sched_info {
>  	/* cumulative counters */
>  	unsigned long pcount;	      /* # of times run on this cpu */
> -	unsigned long long cpu_time,  /* time spent on the cpu */
> -			   run_delay; /* time spent waiting on a runqueue */
> +	unsigned long long run_delay; /* time spent waiting on a runqueue */
> 
>  	/* timestamps */
>  	unsigned long long last_arrival,/* when we last ran on a cpu */
> diff --git a/kernel/delayacct.c b/kernel/delayacct.c
> index b3179da..abb6e17 100644
> --- a/kernel/delayacct.c
> +++ b/kernel/delayacct.c
> @@ -127,7 +127,7 @@ int __delayacct_add_tsk
>  	 */
>  	t1 = tsk->sched_info.pcount;
>  	t2 = tsk->sched_info.run_delay;
> -	t3 = tsk->sched_info.cpu_time;
> +	t3 = tsk->se.sum_exec_runtime;
> 
>  	d->cpu_count += t1;
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 4d1920d..1ed1809 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -586,6 +586,8 @@ struct rq {
>  #ifdef CONFIG_SCHEDSTATS
>  	/* latency stats */
>  	struct sched_info rq_sched_info;
> +	unsigned long long rq_cpu_time;
> +	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
> 
>  	/* sys_sched_yield() stats */
>  	unsigned int yld_exp_empty;
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index 4272594..b07eee8 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -31,7 +31,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
>  		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
>  		    rq->ttwu_count, rq->ttwu_local,
> -		    rq->rq_sched_info.cpu_time,
> +		    rq->rq_cpu_time,
>  		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
> 
>  		seq_printf(seq, "\n");
> @@ -123,7 +123,7 @@ static inline void
>  rq_sched_info_depart(struct rq *rq, unsigned long long delta)
>  {
>  	if (rq)
> -		rq->rq_sched_info.cpu_time += delta;
> +		rq->rq_cpu_time += delta;
>  }
> 
>  static inline void
> @@ -238,7 +238,6 @@ static inline void sched_info_depart
>  	unsigned long long delta = task_rq(t)->clock -
>  					t->sched_info.last_arrival;
> 
> -	t->sched_info.cpu_time += delta;
>  	rq_sched_info_depart(task_rq(t), delta);
> 
>  	if (t->state == TASK_RUNNING)

