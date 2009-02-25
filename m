Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbZBYIVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbZBYIVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZBYIVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:21:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:58496 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZBYIVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:21:33 -0500
Subject: Re: [PATCH] sched: fix unfairness when upgrade weight
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <49A4F401.30503@cn.fujitsu.com>
References: <49A4F401.30503@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 09:20:53 +0100
Message-Id: <1235550053.4645.3035.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 15:32 +0800, Miao Xie wrote:

> This patch fixes this bug by tuning the vruntime of weight-upgraded
> sched entities, just like waking up a task. the new vruntime will be
>     cfs_rq->min_vruntime + sched_vslice();

I really don't like that.

Better would be to scale with min_vruntime, which would at least
approximate the lag somewhat.

Best is to compute the actual lag, but that might just not be worth the
extra overhead.

http://programming.kicks-ass.net/kernel-patches/sched-avg_vruntime/


> ---
>  kernel/sched.c      |   16 +++++++++-------
>  kernel/sched_fair.c |    9 +++++++++
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 410eec4..26e6d33 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5096,12 +5096,8 @@ void set_user_nice(struct task_struct *p, long nice)
>  
>  	if (on_rq) {
>  		enqueue_task(rq, p, 0);
> -		/*
> -		 * If the task increased its priority or is running and
> -		 * lowered its priority, then reschedule its CPU:
> -		 */
> -		if (delta < 0 || (delta > 0 && task_running(rq, p)))
> -			resched_task(rq->curr);
> +		p->sched_class->prio_changed(rq, p, old_prio,
> +						task_running(rq, p));
>  	}
>  out_unlock:
>  	task_rq_unlock(rq, &flags);
> @@ -8929,16 +8925,22 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares)
>  {
>  	struct cfs_rq *cfs_rq = se->cfs_rq;
>  	int on_rq;
> +	unsigned long old_weight;
>  
>  	on_rq = se->on_rq;
>  	if (on_rq)
>  		dequeue_entity(cfs_rq, se, 0);
>  
> +	old_weight = se->load.weight;
>  	se->load.weight = shares;
>  	se->load.inv_weight = 0;
>  
> -	if (on_rq)
> +	if (on_rq) {
> +		if (se->load.weight > old_weight)
> +			se->vruntime = cfs_rq->min_vruntime
> +						+ sched_vslice(cfs_rq, se);
>  		enqueue_entity(cfs_rq, se, 0);
> +	}
>  }
>  
>  static void set_se_shares(struct sched_entity *se, unsigned long shares)
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 0566f2a..34d4d11 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1690,6 +1690,15 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
>  static void prio_changed_fair(struct rq *rq, struct task_struct *p,
>  			      int oldprio, int running)
>  {
> +	struct cfs_rq *cfs_rq = task_cfs_rq(p);
> +	struct sched_entity *se = &p->se;
> +	int on_rq = se->on_rq;
> +
> +	if (p->prio < oldprio && on_rq) {
> +		dequeue_entity(cfs_rq, se, 0);
> +		se->vruntime = cfs_rq->min_vruntime + sched_vslice(cfs_rq, se);
> +		enqueue_entity(cfs_rq, se, 0);
> +	}

we very likely just enqueued the thing, and now we dequeue/enqueue
again.. not very nice.

>  	/*
>  	 * Reschedule if we are currently running on this runqueue and
>  	 * our priority decreased, or if we are not currently running on

