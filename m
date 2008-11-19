Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYKSQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYKSQss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYKSQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:48:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYKSQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:48:39 -0500
Subject: Re: [patch] sched: fix inconsistency when redistribute per-cpu
	tg->cfs_rq  shares.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b040c32a0811182241r3cf5e7c7l25d3627c2265ead2@mail.gmail.com>
References: <b040c32a0811182241r3cf5e7c7l25d3627c2265ead2@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 17:47:45 +0100
Message-Id: <1227113269.29743.43.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 22:41 -0800, Ken Chen wrote:
> In the update_shares() path leading to tg_shares_up(), the calculation of
> per-cpu cfs_rq shares is rather erratic even under moderate task wake up
> rate.  The problem is that the per-cpu tg->cfs_rq load weight used in the
> sd_rq_weight aggregation and actual redistribution of the cfs_rq->shares
> are collected at different time.  Under moderate system load, we've seen
> quite a bit of variation on the cfs_rq->shares and ultimately wildly
> affects sched_entity's load weight.

Another thing we could possibly do is put a low-pass filter on the
per-cpu load values so that we smooth out the fluctuations, hmm?

> This patch caches the result of initial per-cpu load weight when doing the
> sum calculation, and then pass it down to update_group_shares_cpu() for
> redistributing per-cpu cfs_rq shares.  This allows consistent total cfs_rq
> shares across all CPUs. It also simplifies the rounding and zero load
> weight check.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

This does indeed look much better, the cleanup factor alone makes it a
worthwhile patch, he fact that is improves behaviour makes it even
better :-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks Ken!

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9b1e793..1ff78b6 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1473,27 +1473,13 @@ static void
>  update_group_shares_cpu(struct task_group *tg, int cpu,
>  			unsigned long sd_shares, unsigned long sd_rq_weight)
>  {
> -	int boost = 0;
>  	unsigned long shares;
>  	unsigned long rq_weight;
> 
>  	if (!tg->se[cpu])
>  		return;
> 
> -	rq_weight = tg->cfs_rq[cpu]->load.weight;
> -
> -	/*
> -	 * If there are currently no tasks on the cpu pretend there is one of
> -	 * average load so that when a new task gets to run here it will not
> -	 * get delayed by group starvation.
> -	 */
> -	if (!rq_weight) {
> -		boost = 1;
> -		rq_weight = NICE_0_LOAD;
> -	}
> -
> -	if (unlikely(rq_weight > sd_rq_weight))
> -		rq_weight = sd_rq_weight;
> +	rq_weight = tg->cfs_rq[cpu]->rq_weight;
> 
>  	/*
>  	 *           \Sum shares * rq_weight
> @@ -1501,7 +1487,7 @@ update_group_shares_cpu
>  	 *               \Sum rq_weight
>  	 *
>  	 */
> -	shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
> +	shares = (sd_shares * rq_weight) / sd_rq_weight;
>  	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
> 
>  	if (abs(shares - tg->se[cpu]->load.weight) >
> @@ -1510,11 +1496,7 @@ update_group_shares_cpu
>  		unsigned long flags;
> 
>  		spin_lock_irqsave(&rq->lock, flags);
> -		/*
> -		 * record the actual number of shares, not the boosted amount.
> -		 */
> -		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
> -		tg->cfs_rq[cpu]->rq_weight = rq_weight;
> +		tg->cfs_rq[cpu]->shares = shares;
> 
>  		__set_se_shares(tg->se[cpu], shares);
>  		spin_unlock_irqrestore(&rq->lock, flags);
> @@ -1528,13 +1510,23 @@ update_group_shares_cpu
>   */
>  static int tg_shares_up(struct task_group *tg, void *data)
>  {
> -	unsigned long rq_weight = 0;
> +	unsigned long weight, rq_weight = 0;
>  	unsigned long shares = 0;
>  	struct sched_domain *sd = data;
>  	int i;
> 
>  	for_each_cpu_mask(i, sd->span) {
> -		rq_weight += tg->cfs_rq[i]->load.weight;
> +		/*
> +		 * If there are currently no tasks on the cpu pretend there
> +		 * is one of average load so that when a new task gets to
> +		 * run here it will not get delayed by group starvation.
> +		 */
> +		weight = tg->cfs_rq[i]->load.weight;
> +		if (!weight)
> +			weight = NICE_0_LOAD;
> +
> +		tg->cfs_rq[i]->rq_weight = weight;
> +		rq_weight += weight;
>  		shares += tg->cfs_rq[i]->shares;
>  	}
> 
> @@ -1544,9 +1536,6 @@ static int tg_shares_up
>  	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
>  		shares = tg->shares;
> 
> -	if (!rq_weight)
> -		rq_weight = cpus_weight(sd->span) * NICE_0_LOAD;
> -
>  	for_each_cpu_mask(i, sd->span)
>  		update_group_shares_cpu(tg, i, shares, rq_weight);

