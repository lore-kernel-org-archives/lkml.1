Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbZG1Ete@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbZG1Ete (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbZG1Etd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:49:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55769 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZG1Etd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:49:33 -0400
Date: Tue, 28 Jul 2009 09:44:25 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ken Chen <kenchen@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: CFS group scheduler fairness broken starting from 2.6.29-rc1
Message-ID: <20090728041425.GA3276@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090723075735.GA18878@in.ibm.com> <1248696557.6987.1615.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248696557.6987.1615.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 02:09:17PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-07-23 at 13:27 +0530, Bharata B Rao wrote:
> > Hi,
> > 
> > Group scheduler fainess is broken since 2.6.29-rc1. git bisect led me
> > to this commit:
> > 
> > commit ec4e0e2fe018992d980910db901637c814575914
> > Author: Ken Chen <kenchen@google.com>
> > Date:   Tue Nov 18 22:41:57 2008 -0800
> > 
> >     sched: fix inconsistency when redistribute per-cpu tg->cfs_rq shares
> >     
> >     Impact: make load-balancing more consistent
> >     
> >     In the update_shares() path leading to tg_shares_up(), the calculation of
> >     per-cpu cfs_rq shares is rather erratic even under moderate task wake up
> >     rate.  The problem is that the per-cpu tg->cfs_rq load weight used in the
> >     sd_rq_weight aggregation and actual redistribution of the cfs_rq->shares
> >     are collected at different time.  Under moderate system load, we've seen
> >     quite a bit of variation on the cfs_rq->shares and ultimately wildly
> >     affects sched_entity's load weight.
> >     
> >     This patch caches the result of initial per-cpu load weight when doing the
> >     sum calculation, and then pass it down to update_group_shares_cpu() for
> >     redistributing per-cpu cfs_rq shares.  This allows consistent total cfs_rq
> >     shares across all CPUs. It also simplifies the rounding and zero load
> >     weight check.
> >     
> >     Signed-off-by: Ken Chen <kenchen@google.com>
> >     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Right, I think I spotted the bug.
> 
> Before this patch we would assign a non-0 share to empty cpu groups in
> order to avoid starvation cases. But we could not account that non-0
> share into the shares sum of the sd on the next run.
> 
> With this patch however we do. Which will create a skew which will only
> be corrected on the top level domain when we reach there.
> 
> -               tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
> 
> Is the logic that went missing.
> 
> /me goes frob a patch together.
> 
> How does the below work?

Restores the fairness values to that of 2.6.28. IOW, works fine.

Regards,
Bharata.

> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -1523,13 +1523,18 @@ static void
>  update_group_shares_cpu(struct task_group *tg, int cpu,
>  			unsigned long sd_shares, unsigned long sd_rq_weight)
>  {
> -	unsigned long shares;
>  	unsigned long rq_weight;
> +	unsigned long shares;
> +	int boost = 0;
> 
>  	if (!tg->se[cpu])
>  		return;
> 
>  	rq_weight = tg->cfs_rq[cpu]->rq_weight;
> +	if (!rq_weight) {
> +		boost = 1;
> +		rq_weight = NICE_0_LOAD;
> +	}
> 
>  	/*
>  	 *           \Sum shares * rq_weight
> @@ -1546,8 +1551,7 @@ update_group_shares_cpu(struct task_grou
>  		unsigned long flags;
> 
>  		spin_lock_irqsave(&rq->lock, flags);
> -		tg->cfs_rq[cpu]->shares = shares;
> -
> +		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
>  		__set_se_shares(tg->se[cpu], shares);
>  		spin_unlock_irqrestore(&rq->lock, flags);
>  	}
> @@ -1560,7 +1564,7 @@ update_group_shares_cpu(struct task_grou
>   */
>  static int tg_shares_up(struct task_group *tg, void *data)
>  {
> -	unsigned long weight, rq_weight = 0;
> +	unsigned long weight, rq_weight = 0, eff_weight = 0;
>  	unsigned long shares = 0;
>  	struct sched_domain *sd = data;
>  	int i;
> @@ -1572,11 +1576,13 @@ static int tg_shares_up(struct task_grou
>  		 * run here it will not get delayed by group starvation.
>  		 */
>  		weight = tg->cfs_rq[i]->load.weight;
> +		tg->cfs_rq[i]->rq_weight = weight;
> +		rq_weight += weight;
> +
>  		if (!weight)
>  			weight = NICE_0_LOAD;
> 
> -		tg->cfs_rq[i]->rq_weight = weight;
> -		rq_weight += weight;
> +		eff_weight += weight;
>  		shares += tg->cfs_rq[i]->shares;
>  	}
> 
> @@ -1586,8 +1592,14 @@ static int tg_shares_up(struct task_grou
>  	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
>  		shares = tg->shares;
> 
> -	for_each_cpu(i, sched_domain_span(sd))
> -		update_group_shares_cpu(tg, i, shares, rq_weight);
> +	for_each_cpu(i, sched_domain_span(sd)) {
> +		unsigned long sd_rq_weight = rq_weight;
> +
> +		if (!tg->cfs_rq[i]->rq_weight)
> +			sd_rq_weight = eff_weight;
> +
> +		update_group_shares_cpu(tg, i, shares, sd_rq_weight);
> +	}
> 
>  	return 0;
>  }
> 
