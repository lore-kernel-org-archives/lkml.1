Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0BVSuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:50:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:55799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0BVSup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:50:45 -0500
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266628424.4729.23.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
	 <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
	 <1266608875.1529.749.camel@laptop>
	 <1266609029.4729.1.camel@sbs-t61.sc.intel.com>
	 <1266609734.1529.772.camel@laptop>
	 <1266628424.4729.23.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 19:50:18 +0100
Message-ID: <1266864618.6122.472.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 17:13 -0800, Suresh Siddha wrote:

> Ok Peter. There is another place that is scaling load_per_task with
> cpu_power but later comparing with the difference of max and min of the
> actual cpu load. :(
> 
>         avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
>                 group->cpu_power;
> 
>         if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
>                 sgs->group_imb = 1;
> 
> Fixing this seems to have fixed the problem you mentioned. Can you
> please checkout the appended patch? If everything seems ok, then I will
> send the patch (against -tip tree) on monday morning with the detailed
> changelog.

Yes, this one does seem to generate the intended behaviour and does look
good (after cleaning up some of the now redundant comments).

Thanks!

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3a8fb30..213b445 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3423,6 +3423,7 @@ struct sd_lb_stats {
>  	unsigned long max_load;
>  	unsigned long busiest_load_per_task;
>  	unsigned long busiest_nr_running;
> +	unsigned long busiest_group_capacity;
>  
>  	int group_imb; /* Is there imbalance in this sd */
>  #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> @@ -3742,8 +3743,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>  	unsigned long load, max_cpu_load, min_cpu_load;
>  	int i;
>  	unsigned int balance_cpu = -1, first_idle_cpu = 0;
> -	unsigned long sum_avg_load_per_task;
> -	unsigned long avg_load_per_task;
> +	unsigned long avg_load_per_task = 0;
>  
>  	if (local_group) {
>  		balance_cpu = group_first_cpu(group);
> @@ -3752,7 +3752,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>  	}
>  
>  	/* Tally up the load of all CPUs in the group */
> -	sum_avg_load_per_task = avg_load_per_task = 0;
>  	max_cpu_load = 0;
>  	min_cpu_load = ~0UL;
>  
> @@ -3782,7 +3781,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>  		sgs->sum_nr_running += rq->nr_running;
>  		sgs->sum_weighted_load += weighted_cpuload(i);
>  
> -		sum_avg_load_per_task += cpu_avg_load_per_task(i);
>  	}
>  
>  	/*
> @@ -3801,6 +3799,9 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>  	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
>  
> 
> +	if (sgs->sum_nr_running)
> +		avg_load_per_task =
> +				sgs->sum_weighted_load / sgs->sum_nr_running;
>  	/*
>  	 * Consider the group unbalanced when the imbalance is larger
>  	 * than the average weight of two tasks.
> @@ -3810,9 +3811,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>  	 *      normalized nr_running number somewhere that negates
>  	 *      the hierarchy?
>  	 */
> -	avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
> -		group->cpu_power;
> -
>  	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
>  		sgs->group_imb = 1;
>  
> @@ -3880,6 +3878,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  			sds->max_load = sgs.avg_load;
>  			sds->busiest = group;
>  			sds->busiest_nr_running = sgs.sum_nr_running;
> +			sds->busiest_group_capacity = sgs.group_capacity;
>  			sds->busiest_load_per_task = sgs.sum_weighted_load;
>  			sds->group_imb = sgs.group_imb;
>  		}
> @@ -3902,6 +3901,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  {
>  	unsigned long tmp, pwr_now = 0, pwr_move = 0;
>  	unsigned int imbn = 2;
> +	unsigned long scaled_busy_load_per_task;
>  
>  	if (sds->this_nr_running) {
>  		sds->this_load_per_task /= sds->this_nr_running;
> @@ -3912,8 +3912,12 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  		sds->this_load_per_task =
>  			cpu_avg_load_per_task(this_cpu);
>  
> -	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
> -			sds->busiest_load_per_task * imbn) {
> +	scaled_busy_load_per_task = sds->busiest_load_per_task
> +						 * SCHED_LOAD_SCALE;
> +	scaled_busy_load_per_task /= sds->busiest->cpu_power;
> +
> +	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
> +			(scaled_busy_load_per_task * imbn)) {
>  		*imbalance = sds->busiest_load_per_task;
>  		return;
>  	}
> @@ -3964,7 +3968,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
>  		unsigned long *imbalance)
>  {
> -	unsigned long max_pull;
> +	unsigned long max_pull, load_above_capacity = ~0UL;
>  	/*
>  	 * In the presence of smp nice balancing, certain scenarios can have
>  	 * max load less than avg load(as we skip the groups at or below
> @@ -3975,9 +3979,30 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
>  		return fix_small_imbalance(sds, this_cpu, imbalance);
>  	}
>  
> -	/* Don't want to pull so many tasks that a group would go idle */
> -	max_pull = min(sds->max_load - sds->avg_load,
> -			sds->max_load - sds->busiest_load_per_task);
> +	if (!sds->group_imb) {
> +		/*
> + 	 	 * Don't want to pull so many tasks that a group would go idle.
> +	 	 */
> +		load_above_capacity = (sds->busiest_nr_running - 
> +						sds->busiest_group_capacity);
> +
> +		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_LOAD_SCALE);
> +	
> +		load_above_capacity /= sds->busiest->cpu_power;
> +	}
> +
> +	/*
> +	 * We're trying to get all the cpus to the average_load, so we don't
> +	 * want to push ourselves above the average load, nor do we wish to
> +	 * reduce the max loaded cpu below the average load, as either of these
> +	 * actions would just result in more rebalancing later, and ping-pong
> +	 * tasks around. Thus we look for the minimum possible imbalance.
> +	 * Negative imbalances (*we* are more loaded than anyone else) will
> +	 * be counted as no imbalance for these purposes -- we can't fix that
> +	 * by pulling tasks to us. Be careful of negative numbers as they'll
> +	 * appear as very large values with unsigned longs.
> +	 */
> +	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
>  
>  	/* How much load to actually move to equalise the imbalance */
>  	*imbalance = min(max_pull * sds->busiest->cpu_power,
> @@ -4069,19 +4094,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
>  		sds.busiest_load_per_task =
>  			min(sds.busiest_load_per_task, sds.avg_load);
>  
> -	/*
> -	 * We're trying to get all the cpus to the average_load, so we don't
> -	 * want to push ourselves above the average load, nor do we wish to
> -	 * reduce the max loaded cpu below the average load, as either of these
> -	 * actions would just result in more rebalancing later, and ping-pong
> -	 * tasks around. Thus we look for the minimum possible imbalance.
> -	 * Negative imbalances (*we* are more loaded than anyone else) will
> -	 * be counted as no imbalance for these purposes -- we can't fix that
> -	 * by pulling tasks to us. Be careful of negative numbers as they'll
> -	 * appear as very large values with unsigned longs.
> -	 */
> -	if (sds.max_load <= sds.busiest_load_per_task)
> -		goto out_balanced;
>  
>  	/* Looks like there is an imbalance. Compute it */
>  	calculate_imbalance(&sds, this_cpu, imbalance);
> 
>  
> 
> 


