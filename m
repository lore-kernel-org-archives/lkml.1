Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0BWGIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:08:32 -0500
Received: from ozlabs.org ([203.10.76.45]:51493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0BWGI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:08:29 -0500
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <24165.1266577276@neuling.org>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop> <1264721088.10385.1.camel@jschopp-laptop> <1265403478.6089.41.camel@jschopp-laptop> <1266142340.5273.418.camel@laptop> <25851.1266445258@neuling.org> <1266499023.26719.597.camel@laptop> <14639.1266559532@neuling.org> <1266573672.1806.70.camel@laptop> <24165.1266577276@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Fri, 19 Feb 2010 22:01:16 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Tue, 23 Feb 2010 17:08:27 +1100
Message-ID: <23662.1266905307@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <24165.1266577276@neuling.org> you wrote:
> In message <1266573672.1806.70.camel@laptop> you wrote:
> > On Fri, 2010-02-19 at 17:05 +1100, Michael Neuling wrote:
> > > >  include/linux/sched.h |    2 +-
> > > >  kernel/sched_fair.c   |   61 +++++++++++++++++++++++++++++++++++++++++
++
> ++--
> > > -
> > > >  2 files changed, 58 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > index 0eef87b..42fa5c6 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -849,7 +849,7 @@ enum cpu_idle_type {
> > > >  #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power sa
vings */
> > > >  #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg
> > >  resources */
> > > >  #define SD_SERIALIZE		0x0400	/* Only a single load balancing
>  instanc
> > > e */
> > > > -
> > > > +#define SD_ASYM_PACKING		0x0800
> > > 
> > > Would we eventually add this to SD_SIBLING_INIT in a arch specific hook,
> > > or is this ok to add it generically?
> > 
> > I'd think we'd want to keep that limited to architectures that actually
> > need it.
> 
> OK
> 
> > >  
> > > > +static int update_sd_pick_busiest(struct sched_domain *sd,
> > > > +	       			  struct sd_lb_stats *sds,
> > > > +				  struct sched_group *sg,
> > > > +			  	  struct sg_lb_stats *sgs)
> > > > +{
> > > > +	if (sgs->sum_nr_running > sgs->group_capacity)
> > > > +		return 1;
> > > > +
> > > > +	if (sgs->group_imb)
> > > > +		return 1;
> > > > +
> > > > +	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running) {
> > > > +		if (!sds->busiest)
> > > > +			return 1;
> > > > +
> > > > +		if (group_first_cpu(sds->busiest) < group_first_cpu(gro
up))
> > > 
> > > "group" => "sg" here? (I get a compile error otherwise)
> > 
> > Oh, quite ;-)
> > 
> > > > +static int check_asym_packing(struct sched_domain *sd,
> > > > +				    struct sd_lb_stats *sds, 
> > > > +				    int cpu, unsigned long *imbalance)
> > > > +{
> > > > +	int i, cpu, busiest_cpu;
> > > 
> > > Redefining cpu here.  Looks like the cpu parameter is not really needed?
> > 
> > Seems that way indeed, I went back and forth a few times on the actual
> > implementation of this function (which started out live as a copy of
> > check_power_save_busiest_group), its amazing there were only these two
> > compile glitches ;-)
> 
> :-)
> 
> Below are the cleanups + the arch specific bits.  It doesn't change your
> logic at all.  Obviously the PPC arch bits would need to be split into a
> separate patch.
> 
> Compiles and boots against linux-next.

I have some comments on the code inline but... 

So when I run this, I don't get processes pulled down to the lower
threads.  A simple test case of running 1 CPU intensive process at
SCHED_OTHER on a machine with 2 way SMT system (a POWER6 but enabling
SD_ASYM_PACKING).  The single processes doesn't move to lower threads as
I'd hope.

Also, are you sure you want to put this in generic code?  It seem to be
quite POWER7 specific functionality, so would be logically better in
arch/powerpc.  I guess some other arch *might* need it, but seems
unlikely.  

> Mikey
> ---
>  arch/powerpc/include/asm/cputable.h |    3 +
>  arch/powerpc/kernel/process.c       |    7 +++
>  include/linux/sched.h               |    4 +-
>  include/linux/topology.h            |    1 
>  kernel/sched_fair.c                 |   64 +++++++++++++++++++++++++++++++++
+--
>  5 files changed, 74 insertions(+), 5 deletions(-)
> 
> Index: linux-next/arch/powerpc/include/asm/cputable.h
> ===================================================================
> --- linux-next.orig/arch/powerpc/include/asm/cputable.h
> +++ linux-next/arch/powerpc/include/asm/cputable.h
> @@ -195,6 +195,7 @@ extern const char *powerpc_base_platform
>  #define CPU_FTR_SAO			LONG_ASM_CONST(0x0020000000000000)
>  #define CPU_FTR_CP_USE_DCBTZ		LONG_ASM_CONST(0x0040000000000000)
>  #define CPU_FTR_UNALIGNED_LD_STD	LONG_ASM_CONST(0x0080000000000000)
> +#define CPU_FTR_ASYM_SMT4		LONG_ASM_CONST(0x0100000000000000)
>  
>  #ifndef __ASSEMBLY__
>  
> @@ -409,7 +410,7 @@ extern const char *powerpc_base_platform
>  	    CPU_FTR_MMCRA | CPU_FTR_SMT | \
>  	    CPU_FTR_COHERENT_ICACHE | CPU_FTR_LOCKLESS_TLBIE | \
>  	    CPU_FTR_PURR | CPU_FTR_SPURR | CPU_FTR_REAL_LE | \
> -	    CPU_FTR_DSCR | CPU_FTR_SAO)
> +	    CPU_FTR_DSCR | CPU_FTR_SAO  | CPU_FTR_ASYM_SMT4)
>  #define CPU_FTRS_CELL	(CPU_FTR_USE_TB | CPU_FTR_LWSYNC | \
>  	    CPU_FTR_PPCAS_ARCH_V2 | CPU_FTR_CTRL | \
>  	    CPU_FTR_ALTIVEC_COMP | CPU_FTR_MMCRA | CPU_FTR_SMT | \
> Index: linux-next/arch/powerpc/kernel/process.c
> ===================================================================
> --- linux-next.orig/arch/powerpc/kernel/process.c
> +++ linux-next/arch/powerpc/kernel/process.c
> @@ -1265,3 +1265,10 @@ unsigned long randomize_et_dyn(unsigned 
>  
>  	return ret;
>  }
> +
> +int arch_sd_asym_packing(void)
> +{
> +	if (cpu_has_feature(CPU_FTR_ASYM_SMT4))
> +		return SD_ASYM_PACKING;
> +	return 0;
> +}
> Index: linux-next/include/linux/sched.h
> ===================================================================
> --- linux-next.orig/include/linux/sched.h
> +++ linux-next/include/linux/sched.h
> @@ -849,7 +849,7 @@ enum cpu_idle_type {
>  #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
>  #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg
 resources */
>  #define SD_SERIALIZE		0x0400	/* Only a single load balancing instanc
e */
> -
> +#define SD_ASYM_PACKING		0x0800  /* Asymetric SMT packing */
>  #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling d
omain */
>  
>  enum powersavings_balance_level {
> @@ -881,6 +881,8 @@ static inline int sd_balance_for_package
>  	return SD_PREFER_SIBLING;
>  }
>  
> +extern int arch_sd_asym_packing(void);
> +
>  /*
>   * Optimise SD flags for power savings:
>   * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
> Index: linux-next/include/linux/topology.h
> ===================================================================
> --- linux-next.orig/include/linux/topology.h
> +++ linux-next/include/linux/topology.h
> @@ -102,6 +102,7 @@ int arch_update_cpu_topology(void);
>  				| 1*SD_SHARE_PKG_RESOURCES		\
>  				| 0*SD_SERIALIZE			\
>  				| 0*SD_PREFER_SIBLING			\
> +				| arch_sd_asym_packing()		\
>  				,					\
>  	.last_balance		= jiffies,				\
>  	.balance_interval	= 1,					\
> Index: linux-next/kernel/sched_fair.c
> ===================================================================
> --- linux-next.orig/kernel/sched_fair.c
> +++ linux-next/kernel/sched_fair.c
> @@ -2086,6 +2086,7 @@ struct sd_lb_stats {
>  	struct sched_group *this;  /* Local group in this sd */
>  	unsigned long total_load;  /* Total load of all groups in sd */
>  	unsigned long total_pwr;   /*	Total power of all groups in sd */
> +	unsigned long total_nr_running;
>  	unsigned long avg_load;	   /* Average load across all groups in sd */
>  
>  	/** Statistics of this group */
> @@ -2493,6 +2494,28 @@ static inline void update_sg_lb_stats(st
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

If we are asymetric packing...


> +		if (!sds->busiest)
> +			return 1;

This just seems to be a null pointer check.

>From the tracing I've done, this is always true (always NULL) at this
point so we return here.

> +
> +		if (group_first_cpu(sds->busiest) < group_first_cpu(sg))
> +			return 1;

I'm a bit lost as to what this is for.  Any clues you could provide
would be appreciated. :-)

Is the first cpu in this domain's busiest group before the first cpu in
this group.  If, so pick this as the busiest?

Should this be the other way around if we want to pack the busiest to
the first cpu?  Mark it as the busiest if it's after (not before).  

Is group_first_cpu guaranteed to give us the first physical cpu (ie.
thread 0 in our case) or are these virtualised at this point?

I'm not seeing this hit anyway due to the null pointer check above.

> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * update_sd_lb_stats - Update sched_group's statistics for load balancing.
>   * @sd: sched_domain whose statistics are to be updated.
> @@ -2533,6 +2556,7 @@ static inline void update_sd_lb_stats(st
>  
>  		sds->total_load += sgs.group_load;
>  		sds->total_pwr += group->cpu_power;
> +		sds->total_nr_running += sgs.sum_nr_running;
>  
>  		/*
>  		 * In case the child domain prefers tasks go to siblings
> @@ -2547,9 +2571,8 @@ static inline void update_sd_lb_stats(st
>  			sds->this = group;
>  			sds->this_nr_running = sgs.sum_nr_running;
>  			sds->this_load_per_task = sgs.sum_weighted_load;
> -		} else if (sgs.avg_load > sds->max_load &&
> -			   (sgs.sum_nr_running > sgs.group_capacity ||
> -				sgs.group_imb)) {
> +		} else if (sgs.avg_load >= sds->max_load &&
> +			   update_sd_pick_busiest(sd, sds, group, &sgs)) {

This is pretty clear.  Moving stuff to the new function.

>  			sds->max_load = sgs.avg_load;
>  			sds->busiest = group;
>  			sds->busiest_nr_running = sgs.sum_nr_running;
> @@ -2562,6 +2585,38 @@ static inline void update_sd_lb_stats(st
>  	} while (group != sd->groups);
>  }
>  
> +int __weak sd_asym_packing_arch(void)
> +{
> +	return 0;
> +}
> +
> +static int check_asym_packing(struct sched_domain *sd,
> +				    struct sd_lb_stats *sds,
> +				    unsigned long *imbalance)
> +{
> +	int i, cpu, busiest_cpu;
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

This seems to be the core of the packing logic.

We make sure the busiest_cpu is not past total_nr_running.  If it is we
mark as imbalanced.  Correct?

It seems if a non zero thread/group had a pile of processes running on
it and a lower thread had much less, this wouldn't fire, but I'm
guessing normal load balancing would kick in that case to fix the
imbalance.

Any corrections to my ramblings appreciated :-)

Thanks again,
Mikey

> +
> +	*imbalance = sds->max_load;
> +	return 1;
> +}
> +
>  /**
>   * fix_small_imbalance - Calculate the minor imbalance that exists
>   *			amongst the groups of a sched_domain, during
> @@ -2761,6 +2816,9 @@ find_busiest_group(struct sched_domain *
>  	return sds.busiest;
>  
>  out_balanced:
> +	if (check_asym_packing(sd, &sds, imbalance))
> +		return sds.busiest;
> +
>  	/*
>  	 * There is no obvious imbalance. But check if we can do some balancing
>  	 * to save power.
