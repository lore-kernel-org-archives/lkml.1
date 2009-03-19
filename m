Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbZCSRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbZCSRWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZCSRWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:22:41 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:38207 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZCSRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:22:39 -0400
Date: Thu, 19 Mar 2009 22:53:52 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 3 5/6] sched: Arbitrate the nomination of
	preferred_wakeup_cpu
Message-ID: <20090319172352.GP2990@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com> <20090318092243.24787.92087.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090318092243.24787.92087.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gautham R Shenoy <ego@in.ibm.com> [2009-03-18 14:52:43]:

> Currently for sched_mc/smt_power_savings = 2, we consolidate tasks
> by having a preferred_wakeup_cpu which will be used for all the
> further wake ups.
> 
> This preferred_wakeup_cpu is currently nominated by find_busiest_group()
> while loadbalancing for sched_domains which has SD_POWERSAVINGS_BALANCE flag
> set.
> 
> However, on systems which are multi-threaded and multi-core, we can
> have multiple sched_domains in the same hierarchy with
> SD_POWERSAVINGS_BALANCE flag set.
> 
> Currently we don't have any arbitration mechanism as to while load balancing
> for which sched_domain in the hierarchy should find_busiest_group(sd)
> nominate the preferred_wakeup_cpu. Hence can overwrite valid nominations
> made previously thereby causing the preferred_wakup_cpu to ping-pong
> thereby preventing us from effectively consolidating tasks.
> 
> Fix this by means of an arbitration algorithm, where in we nominate the
> preferred_wakeup_cpu sched_domain in find_busiest_group() for a particular
> sched_domain if the sched_domain:
> - is the topmost power aware sched_domain.
> 	OR
> - contains the previously nominated preferred wake up cpu in it's span.
> 
> This will help to further fine tune the wake-up biasing logic by
> identifying a partially busy core within a CPU package instead of
> potentially waking up a completely idle core.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
> 
>  kernel/sched.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 16d7655..651550c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -522,6 +522,14 @@ struct root_domain {
>  	 * This is triggered at POWERSAVINGS_BALANCE_WAKEUP(2).
>  	 */
>  	unsigned int preferred_wakeup_cpu;
> +
> +	/*
> +	 * top_powersavings_sd_lvl records the level of the highest
> +	 * sched_domain that has the SD_POWERSAVINGS_BALANCE flag set.
> +	 *
> +	 * Used to arbitrate nomination of the preferred_wakeup_cpu.
> +	 */
> +	enum sched_domain_level top_powersavings_sd_lvl;
>  #endif
>  };
> 
> @@ -3416,9 +3424,27 @@ out_balanced:
>  		goto ret;
> 
>  	if (this == group_leader && group_leader != group_min) {
> +		struct root_domain *my_rd = cpu_rq(this_cpu)->rd;
>  		*imbalance = min_load_per_task;
> -		if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
> -			cpu_rq(this_cpu)->rd->preferred_wakeup_cpu =
> +		/*
> +		 * To avoid overwriting of preferred_wakeup_cpu nominations
> +		 * while calling find_busiest_group() at various sched_domain
> +		 * levels, we define an arbitration mechanism wherein
> +		 * find_busiest_group() nominates a preferred_wakeup_cpu at
> +		 * the sched_domain sd if:
> +		 *
> +		 * - sd is the highest sched_domain in the hierarchy having the
> +		 *   SD_POWERSAVINGS_BALANCE flag set.
> +		 *
> +		 *   OR
> +		 *
> +		 * - sd contains the previously nominated preferred_wakeup_cpu
> +		 *   in it's span.
> +		 */
> +		if (sd->level == my_rd->top_powersavings_sd_lvl ||
> +			cpu_isset(my_rd->preferred_wakeup_cpu,
> +					*sched_domain_span(sd))) {
> +			my_rd->preferred_wakeup_cpu =
>  				cpumask_first(sched_group_cpus(group_leader));
>  		}
>  		return group_min;
> @@ -7541,6 +7567,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
>  	struct root_domain *rd;
>  	cpumask_var_t nodemask, this_sibling_map, this_core_map, send_covered,
>  		tmpmask;
> +	struct sched_domain *sd;
> +
>  #ifdef CONFIG_NUMA
>  	cpumask_var_t domainspan, covered, notcovered;
>  	struct sched_group **sched_group_nodes = NULL;
> @@ -7816,6 +7844,19 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
> 
>  	err = 0;
> 
> +	rd->preferred_wakeup_cpu = UINT_MAX;
> +	rd->top_powersavings_sd_lvl = SD_LV_NONE;
> +
> +	if (active_power_savings_level < POWERSAVINGS_BALANCE_WAKEUP)
> +		goto free_tmpmask;
> +
> +	/* Record the level of the highest power-aware sched_domain */
> +	for_each_domain(first_cpu(*cpu_map), sd) {
> +		if (!(sd->flags & SD_POWERSAVINGS_BALANCE))
> +			continue;
> +		rd->top_powersavings_sd_lvl = sd->level;
> +	}
> +
>  free_tmpmask:
>  	free_cpumask_var(tmpmask);
>  free_send_covered:
> 

Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
