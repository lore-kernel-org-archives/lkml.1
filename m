Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651AbZIBLSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbZIBLSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZIBLSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:18:12 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:45639 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZIBLSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:18:11 -0400
Date: Wed, 2 Sep 2009 16:47:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 3/8] sched: update the cpu_power sum during
	load-balance
Message-ID: <20090902111759.GB3817@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090901083431.748830771@chello.nl> <20090901083825.985050292@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901083825.985050292@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 10:34:34AM +0200, Peter Zijlstra wrote:
> In order to prepare for a more dynamic cpu_power, update the group sum
> while walking the sched domains during load-balance.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -3699,6 +3699,28 @@ static inline int check_power_save_busie
>  }
>  #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
> 
> +static void update_sched_power(struct sched_domain *sd)
> +{
> +	struct sched_domain *child = sd->child;
> +	struct sched_group *group, *sdg = sd->groups;
> +	unsigned long power = sdg->__cpu_power;
> +
> +	if (!child) {
> +		/* compute cpu power for this cpu */
> +		return;
> +	}
> +
> +	sdg->__cpu_power = 0;
> +
> +	group = child->groups;
> +	do {
> +		sdg->__cpu_power += group->__cpu_power;
> +		group = group->next;
> +	} while (group != child->groups);
> +
> +	if (power != sdg->__cpu_power)
> +		sdg->reciprocal_cpu_power = reciprocal_value(sdg->__cpu_power);
> +}
> 
>  /**
>   * update_sg_lb_stats - Update sched_group's statistics for load balancing.
> @@ -3712,7 +3734,8 @@ static inline int check_power_save_busie
>   * @balance: Should we balance.
>   * @sgs: variable to hold the statistics for this group.
>   */
> -static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
> +static inline void update_sg_lb_stats(struct sched_domain *sd,
> +			struct sched_group *group, int this_cpu,
>  			enum cpu_idle_type idle, int load_idx, int *sd_idle,
>  			int local_group, const struct cpumask *cpus,
>  			int *balance, struct sg_lb_stats *sgs)
> @@ -3723,8 +3746,11 @@ static inline void update_sg_lb_stats(st
>  	unsigned long sum_avg_load_per_task;
>  	unsigned long avg_load_per_task;
> 
> -	if (local_group)
> +	if (local_group) {
>  		balance_cpu = group_first_cpu(group);
> +		if (balance_cpu == this_cpu)
> +			update_sched_power(sd);
> +	}

I guess the intention of this check is to ensure that the cpu_power for
the group of sd is updated only by a specific member of the group and
that would ideally be the first member of the group.

Thus, this check has more to do with this_cpu being the
group_first_cpu() than this_cpu being the balance_cpu. Correct ?

> 
>  	/* Tally up the load of all CPUs in the group */
>  	sum_avg_load_per_task = avg_load_per_task = 0;
> @@ -3828,7 +3854,7 @@ static inline void update_sd_lb_stats(st
>  		local_group = cpumask_test_cpu(this_cpu,
>  					       sched_group_cpus(group));
>  		memset(&sgs, 0, sizeof(sgs));
> -		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
> +		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
>  				local_group, cpus, balance, &sgs);
> 
>  		if (local_group && balance && !(*balance))
> @@ -3863,7 +3889,6 @@ static inline void update_sd_lb_stats(st
>  		update_sd_power_savings_stats(group, sds, local_group, &sgs);
>  		group = group->next;
>  	} while (group != sd->groups);
> -
>  }
> 
>  /**
> 
> -- 

-- 
Thanks and Regards
gautham
