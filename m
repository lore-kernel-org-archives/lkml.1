Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0BSNDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:03:32 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34459 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab0BSNDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:03:31 -0500
Date: Fri, 19 Feb 2010 18:33:18 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
Message-ID: <20100219130318.GA20884@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
 <1266057388.557.59599.camel@twins>
 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2010-02-18 18:16:47]:

> On Sat, 2010-02-13 at 02:36 -0800, Peter Zijlstra wrote:
> > On Fri, 2010-02-12 at 17:31 -0800, Suresh Siddha wrote:
> > > 
> > > We have one more problem that Yanmin and Ling Ma reported. On a dual
> > > socket quad-core platforms (for example platforms based on NHM-EP), we
> > > are seeing scenarios where one socket is completely busy (with all the 4
> > > cores running with 4 tasks) and another socket is completely idle.
> > > 
> > > This causes performance issues as those 4 tasks share the memory
> > > controller, last-level cache bandwidth etc. Also we won't be taking
> > > advantage of turbo-mode as much as we like. We will have all these
> > > benefits if we move two of those tasks to the other socket. Now both the
> > > sockets can potentially go to turbo etc and improve performance.
> > > 
> > > In short, your recent change (shown below) broke this behavior. In the
> > > kernel summit you mentioned you made this change with out affecting the
> > > behavior of SMT/MC. And my testing immediately after kernel-summit also
> > > didn't show the problem (perhaps my test didn't hit this specific
> > > change). But apparently we are having performance issues with this patch
> > > (Ling Ma's bisect pointed to this patch). I will look more detailed into
> > > this after the long weekend (to see if we can catch this scenario in
> > > fix_small_imbalance() etc). But wanted to give you a quick heads up.
> > > Thanks.
> > 
> > Right, so the behaviour we want should be provided by SD_PREFER_SIBLING,
> > it provides the capacity==1 thing the cpu_power games used to provide.
> > 
> > Not saying it's not broken, but that's where the we should be looking to
> > fix it.
> 
> Peter, Some portions of code in fix_small_imbalance() and
> calculate_imbalance() are comparing max_load and busiest_load_per_task.
> Some of these comparisons are ok but some of them are broken. Broken
> comparisons are assuming that the cpu_power is SCHED_LOAD_SCALE. Also
> there is one check which still assumes that the world is balanced when
> max_load <= busiest_load_per_task. This is wrong with the recent changes
> (as cpu power no longer reflects the group capacity that is needed to
> implement SCHED_MC/SCHED_SMT).
> 
> The appended patch works for me and fixes the SCHED_MC performance
> behavior. I am sending this patch out for a quick review and I will do
> bit more testing tomorrow and If you don't follow what I am doing in
> this patch and why, then stay tuned for a patch with complete changelog
> that I will send tomorrow. Good night. Thanks.

Hi Suresh,

Thanks for sharing the patch.

> ---
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3a8fb30..2f4cac0 100644
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
> @@ -3880,6 +3881,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  			sds->max_load = sgs.avg_load;
>  			sds->busiest = group;
>  			sds->busiest_nr_running = sgs.sum_nr_running;
> +			sds->busiest_group_capacity = sgs.group_capacity;
>  			sds->busiest_load_per_task = sgs.sum_weighted_load;
>  			sds->group_imb = sgs.group_imb;
>  		}
> @@ -3902,6 +3904,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  {
>  	unsigned long tmp, pwr_now = 0, pwr_move = 0;
>  	unsigned int imbn = 2;
> +	unsigned long scaled_busy_load_per_task;
> 
>  	if (sds->this_nr_running) {
>  		sds->this_load_per_task /= sds->this_nr_running;
> @@ -3912,8 +3915,12 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
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
> +			scaled_busy_load_per_task * imbn) {
>  		*imbalance = sds->busiest_load_per_task;
>  		return;

This change looks good.

>  	}
> @@ -3964,7 +3971,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
>  		unsigned long *imbalance)
>  {
> -	unsigned long max_pull;
> +	unsigned long max_pull, load_above_capacity = ~0UL;
>  	/*
>  	 * In the presence of smp nice balancing, certain scenarios can have
>  	 * max load less than avg load(as we skip the groups at or below
> @@ -3975,9 +3982,30 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
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

This seems tricky.  max_load - avg_load will be less than
load_above_capacity most of the time.  How does this expression
increase the max_pull from previous expression?

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

Does this increase or decrease the value of max_pull from previous
expression?
 
>  	/* How much load to actually move to equalise the imbalance */
>  	*imbalance = min(max_pull * sds->busiest->cpu_power,
> @@ -4069,19 +4097,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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

This is right.  This condition was treating most cases as balanced and
exit right here. However if this check is removed, we will have to
execute more code to detect/ascertain balanced case.

--Vaidy
