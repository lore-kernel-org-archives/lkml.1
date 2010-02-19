Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0BSGFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:05:36 -0500
Received: from ozlabs.org ([203.10.76.45]:58352 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0BSGFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:05:34 -0500
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <1266499023.26719.597.camel@laptop>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop> <1264721088.10385.1.camel@jschopp-laptop> <1265403478.6089.41.camel@jschopp-laptop> <1266142340.5273.418.camel@laptop> <25851.1266445258@neuling.org> <1266499023.26719.597.camel@laptop>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Thu, 18 Feb 2010 14:17:03 +0100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 19 Feb 2010 17:05:32 +1100
Message-ID: <14639.1266559532@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-02-18 at 09:20 +1100, Michael Neuling wrote:
> > > Suppose for a moment we have 2 threads (hot-unplugged thread 1 and 3, we
> > > can construct an equivalent but more complex example for 4 threads), and
> > > we have 4 tasks, 3 SCHED_OTHER of equal nice level and 1 SCHED_FIFO, the
> > > SCHED_FIFO task will consume exactly 50% walltime of whatever cpu it
> > > ends up on.
> > > 
> > > In that situation, provided that each cpu's cpu_power is of equal
> > > measure, scale_rt_power() ensures that we run 2 SCHED_OTHER tasks on the
> > > cpu that doesn't run the RT task, and 1 SCHED_OTHER task next to the RT
> > > task, so that each task consumes 50%, which is all fair and proper.
> > > 
> > > However, if you do the above, thread 0 will have +75% = 1.75 and thread
> > > 2 will have -75% = 0.25, then if the RT task will land on thread 0,
> > > we'll be having: 0.875 vs 0.25, or on thread 3, 1.75 vs 0.125. In either
> > > case thread 0 will receive too many (if not all) SCHED_OTHER tasks.
> > > 
> > > That is, unless these threads 2 and 3 really are _that_ weak, at which
> > > point one wonders why IBM bothered with the silicon ;-)
> > 
> > Peter,
> > 
> > 2 & 3 aren't weaker than 0 & 1 but.... 
> > 
> > The core has dynamic SMT mode switching which is controlled by the
> > hypervisor (IBM's PHYP).  There are 3 SMT modes:
> > 	SMT1 uses thread  0
> > 	SMT2 uses threads 0 & 1
> > 	SMT4 uses threads 0, 1, 2 & 3
> > When in any particular SMT mode, all threads have the same performance
> > as each other (ie. at any moment in time, all threads perform the same).  
> > 
> > The SMT mode switching works such that when linux has threads 2 & 3 idle
> > and 0 & 1 active, it will cede (H_CEDE hypercall) threads 2 and 3 in the
> > idle loop and the hypervisor will automatically switch to SMT2 for that
> > core (independent of other cores).  The opposite is not true, so if
> > threads 0 & 1 are idle and 2 & 3 are active, we will stay in SMT4 mode.
> > 
> > Similarly if thread 0 is active and threads 1, 2 & 3 are idle, we'll go
> > into SMT1 mode.  
> > 
> > If we can get the core into a lower SMT mode (SMT1 is best), the threads
> > will perform better (since they share less core resources).  Hence when
> > we have idle threads, we want them to be the higher ones.
> 
> Just out of curiosity, is this a hardware constraint or a hypervisor
> constraint?
> 
> > So to answer your question, threads 2 and 3 aren't weaker than the other
> > threads when in SMT4 mode.  It's that if we idle threads 2 & 3, threads
> > 0 & 1 will speed up since we'll move to SMT2 mode.
> >
> > I'm pretty vague on linux scheduler details, so I'm a bit at sea as to
> > how to solve this.  Can you suggest any mechanisms we currently have in
> > the kernel to reflect these properties, or do you think we need to
> > develop something new?  If so, any pointers as to where we should look?
> 
> Well there currently isn't one, and I've been telling people to create a
> new SD_flag to reflect this and influence the f_b_g() behaviour.
> 
> Something like the below perhaps, totally untested and without comments
> so that you'll have to reverse engineer and validate my thinking.
> 
> There's one fundamental assumption, and one weakness in the
> implementation.

Thanks for the help.

I'm still trying to get up to speed with how this works but while trying
to cleanup and compile your patch, I had some simple questions below...

> 
> ---
> 
>  include/linux/sched.h |    2 +-
>  kernel/sched_fair.c   |   61 +++++++++++++++++++++++++++++++++++++++++++++--
-
>  2 files changed, 58 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0eef87b..42fa5c6 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -849,7 +849,7 @@ enum cpu_idle_type {
>  #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
>  #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg
 resources */
>  #define SD_SERIALIZE		0x0400	/* Only a single load balancing instanc
e */
> -
> +#define SD_ASYM_PACKING		0x0800

Would we eventually add this to SD_SIBLING_INIT in a arch specific hook,
or is this ok to add it generically?

>  #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling d
omain */
>  
>  enum powersavings_balance_level {
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index ff7692c..7e42bfe 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2086,6 +2086,7 @@ struct sd_lb_stats {
>  	struct sched_group *this;  /* Local group in this sd */
>  	unsigned long total_load;  /* Total load of all groups in sd */
>  	unsigned long total_pwr;   /*	Total power of all groups in sd */
> +	unsigned long total_nr_running;
>  	unsigned long avg_load;	   /* Average load across all groups in sd */
>  
>  	/** Statistics of this group */
> @@ -2414,10 +2415,10 @@ static inline void update_sg_lb_stats(struct sched_do
main *sd,
>  			int *balance, struct sg_lb_stats *sgs)
>  {
>  	unsigned long load, max_cpu_load, min_cpu_load;
> -	int i;
>  	unsigned int balance_cpu = -1, first_idle_cpu = 0;
>  	unsigned long sum_avg_load_per_task;
>  	unsigned long avg_load_per_task;
> +	int i;
>  
>  	if (local_group)
>  		balance_cpu = group_first_cpu(group);
> @@ -2493,6 +2494,28 @@ static inline void update_sg_lb_stats(struct sched_dom
ain *sd,
>  		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
>  }
>  
> +static int update_sd_pick_busiest(struct sched_domain *sd,
> +	       			  struct sd_lb_stats *sds,
> +				  struct sched_group *sg,
> +			  	  struct sg_lb_stats *sgs)
> +{
> +	if (sgs->sum_nr_running > sgs->group_capacity)
> +		return 1;
> +
> +	if (sgs->group_imb)
> +		return 1;
> +
> +	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running) {
> +		if (!sds->busiest)
> +			return 1;
> +
> +		if (group_first_cpu(sds->busiest) < group_first_cpu(group))

"group" => "sg" here? (I get a compile error otherwise)

> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * update_sd_lb_stats - Update sched_group's statistics for load balancing.
>   * @sd: sched_domain whose statistics are to be updated.
> @@ -2533,6 +2556,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  
>  		sds->total_load += sgs.group_load;
>  		sds->total_pwr += group->cpu_power;
> +		sds->total_nr_running += sgs.sum_nr_running;
>  
>  		/*
>  		 * In case the child domain prefers tasks go to siblings
> @@ -2547,9 +2571,8 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  			sds->this = group;
>  			sds->this_nr_running = sgs.sum_nr_running;
>  			sds->this_load_per_task = sgs.sum_weighted_load;
> -		} else if (sgs.avg_load > sds->max_load &&
> -			   (sgs.sum_nr_running > sgs.group_capacity ||
> -				sgs.group_imb)) {
> +		} else if (sgs.avg_load >= sds->max_load &&
> +			   update_sd_pick_busiest(sd, sds, group, &sgs)) {
>  			sds->max_load = sgs.avg_load;
>  			sds->busiest = group;
>  			sds->busiest_nr_running = sgs.sum_nr_running;
> @@ -2562,6 +2585,33 @@ static inline void update_sd_lb_stats(struct sched_dom
ain *sd, int this_cpu,
>  	} while (group != sd->groups);
>  }
>  
> +static int check_asym_packing(struct sched_domain *sd,
> +				    struct sd_lb_stats *sds, 
> +				    int cpu, unsigned long *imbalance)
> +{
> +	int i, cpu, busiest_cpu;

Redefining cpu here.  Looks like the cpu parameter is not really needed?

> +
> +	if (!(sd->flags & SD_ASYM_PACKING))
> +		return 0;
> +
> +	if (!sds->busiest)
> +		return 0;
> +
> +	i = 0;
> +	busiest_cpu = group_first_cpu(sds->busiest);
> +	for_each_cpu(cpu, sched_domain_span(sd)) {
> +		i++;
> +		if (cpu == busiest_cpu)
> +			break;
> +	}
> +
> +	if (sds->total_nr_running > i)
> +		return 0;
> +
> +	*imbalance = sds->max_load;
> +	return 1;
> +}
> +
>  /**
>   * fix_small_imbalance - Calculate the minor imbalance that exists
>   *			amongst the groups of a sched_domain, during
> @@ -2761,6 +2811,9 @@ find_busiest_group(struct sched_domain *sd, int this_cp
u,
>  	return sds.busiest;
>  
>  out_balanced:
> +	if (check_asym_packing(sd, &sds, this_cpu, imbalance))
> +		return sds.busiest;
> +
>  	/*
>  	 * There is no obvious imbalance. But check if we can do some balancing
>  	 * to save power.
> 
> 
