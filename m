Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759619AbYLQIib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYLQIib (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759698AbYLQIiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:38:08 -0500
Received: from viefep17-int.chello.at ([62.179.121.37]:41949 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755417AbYLQIiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:38:07 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] sched: fix uneven per-cpu task_group share distribution
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b040c32a0812152337r4c708d59q7d71ebbcda8fe05a@mail.gmail.com>
References: <b040c32a0812152337r4c708d59q7d71ebbcda8fe05a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 09:38:01 +0100
Message-Id: <1229503081.9487.51.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 23:37 -0800, Ken Chen wrote:
> While testing CFS scheduler on linux-2.6-tip tree
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> 
> We found that task which is pinned to a CPU could be starved relative to its
> allocated fair share.
> 
> The per-cpu sched_enetity load share calculation in tg_shares_up /
> update_group_shares_cpu distributes total task_group's share among all CPUs
> for a given SD domain, this would dilute task_group's per-cpu share because
> it distributes share to CPU that even has no load.  The trapped share is now
> un-consumable and it leads to fair share starvation on the runnable CPU.
> Peter was right that it is still required for the low level function to make
> distinction between a boosted share that don't have any load and actual tg
> share that should be distributed among CPUs in which the tg is running.
> 
> Patch to add that boost and we think the scheduler should only boost one
> times of tg shares over all empty CPU that don't have any load for the
> specific task_group in order to bound maximum temporary boost that a given
> task_group can have.

Yeah I was worried about you removing that boost, but since you seemed
to be doing serious testing on the thing.. A well, this sounds good.

> Signed-off-by: Ken Chen <kenchen@google.com>

OK, patch looks good too, thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1d673a9..7198a26 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1465,24 +1465,34 @@ static void __set_se_shares(
>   * Calculate and set the cpu's group shares.
>   */
>  static void
> -update_group_shares_cpu(struct task_group *tg, int cpu,
> +update_group_shares_cpu(struct task_group *tg, int cpu, int empty,
>  			unsigned long sd_shares, unsigned long sd_rq_weight)
>  {
> -	unsigned long shares;
> +	unsigned long shares, raw_shares;
>  	unsigned long rq_weight;
> 
>  	if (!tg->se[cpu])
>  		return;
> 
>  	rq_weight = tg->cfs_rq[cpu]->rq_weight;
> -
> -	/*
> -	 *           \Sum shares * rq_weight
> -	 * shares =  -----------------------
> -	 *               \Sum rq_weight
> -	 *
> -	 */
> -	shares = (sd_shares * rq_weight) / sd_rq_weight;
> +	if (rq_weight) {
> +		/*
> +		 *           \Sum shares * rq_weight
> +		 * shares =  -----------------------
> +		 *               \Sum rq_weight
> +		 *
> +		 */
> +		raw_shares = (sd_shares * rq_weight) / sd_rq_weight;
> +		shares = raw_shares;
> +	} else {
> +		/*
> +		 * If there are currently no tasks on the cpu pretend there
> +		 * is one of average load so that when a new task gets to
> +		 * run here it will not get delayed by group starvation.
> +		 */
> +		raw_shares = 0;
> +		shares = sd_shares / empty;
> +	}
>  	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
> 
>  	if (abs(shares - tg->se[cpu]->load.weight) >
> @@ -1491,7 +1501,7 @@ update_group_shares_cpu(
>  		unsigned long flags;
> 
>  		spin_lock_irqsave(&rq->lock, flags);
> -		tg->cfs_rq[cpu]->shares = shares;
> +		tg->cfs_rq[cpu]->shares = raw_shares;
> 
>  		__set_se_shares(tg->se[cpu], shares);
>  		spin_unlock_irqrestore(&rq->lock, flags);
> @@ -1508,17 +1518,12 @@ static int tg_shares_up(
>  	unsigned long weight, rq_weight = 0;
>  	unsigned long shares = 0;
>  	struct sched_domain *sd = data;
> -	int i;
> +	int i, empty = 0;
> 
>  	for_each_cpu(i, sched_domain_span(sd)) {
> -		/*
> -		 * If there are currently no tasks on the cpu pretend there
> -		 * is one of average load so that when a new task gets to
> -		 * run here it will not get delayed by group starvation.
> -		 */
>  		weight = tg->cfs_rq[i]->load.weight;
>  		if (!weight)
> -			weight = NICE_0_LOAD;
> +			empty++;
> 
>  		tg->cfs_rq[i]->rq_weight = weight;
>  		rq_weight += weight;
> @@ -1532,7 +1537,7 @@ static int tg_shares_up(
>  		shares = tg->shares;
> 
>  	for_each_cpu(i, sched_domain_span(sd))
> -		update_group_shares_cpu(tg, i, shares, rq_weight);
> +		update_group_shares_cpu(tg, i, empty, shares, rq_weight);
> 
>  	return 0;
>  }

