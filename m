Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZCSQVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZCSQVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZCSQVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:21:45 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56638 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZCSQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:21:44 -0400
Date: Thu, 19 Mar 2009 21:52:49 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 3 1/6] sched: code cleanup - sd_power_saving_flags(),
	sd_balance_for_*_power()
Message-ID: <20090319162249.GJ2990@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com> <20090318092222.24787.48744.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090318092222.24787.48744.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gautham R Shenoy <ego@in.ibm.com> [2009-03-18 14:52:22]:

> This is a code cleanup patch which combines the functions of
> sd_balance_for_mc/package_power() and sd_power_saving_flags() into a single
> function.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

> ---
> 
>  include/linux/sched.h    |   65 +++++++++++++++++++++++-----------------------
>  include/linux/topology.h |    6 +---
>  2 files changed, 35 insertions(+), 36 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 011db2f..37fecf7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -794,34 +794,45 @@ enum powersavings_balance_level {
> 
>  extern int sched_mc_power_savings, sched_smt_power_savings;
> 
> -static inline int sd_balance_for_mc_power(void)
> -{
> -	if (sched_smt_power_savings)
> -		return SD_POWERSAVINGS_BALANCE;
> -
> -	return 0;
> -}
> -
> -static inline int sd_balance_for_package_power(void)
> -{
> -	if (sched_mc_power_savings | sched_smt_power_savings)
> -		return SD_POWERSAVINGS_BALANCE;
> +enum sched_domain_level {
> +	SD_LV_NONE = 0,
> +	SD_LV_SIBLING,	/* Represents the THREADS domain */
                        /* Sched domain of sibling THREADS in a CORE */
> +	SD_LV_MC,	/* Represents the CORES domain */
                        /* Sched domain of sibling CORES in a PACKAGE */
> +	SD_LV_CPU,	/* Represents the PACKAGE domain */
                        /* Sched domain of PACKAGES in a NODE */
> +	SD_LV_NODE,	/* Represents the NODES domain */
                        /* Sched domain of NUMA NODEs in the system */

Just making the description/comments more elaborate.
                        
> +	SD_LV_ALLNODES,
> +	SD_LV_MAX
> +};
> 
> -	return 0;
> -}
> 
> -/*
> - * Optimise SD flags for power savings:
> - * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
> - * Keep default SD flags if sched_{smt,mc}_power_saving=0
> +/**
> + * sd_power_savings_flags: Returns the flags specific to power-aware-load
> + * balancing for a given sched_domain level
> + *
> + * @level: The sched_domain level for which the the power-aware-load balancing
> + * flags need to be set.
> + *
> + * This function helps in setting the flags for power-aware load balancing for
> + * a given sched_domain.
> + *	- SD_POWERSAVINGS_BALANCE tells the load-balancer that power-aware
> + *	load balancing is applicable at this domain.
> + *
> + *	- SD_BALANCE_NEWIDLE helps aggressive task consolidation and
> + *	power-savings.
> + *
> + * For more information on power aware scheduling, see the comment before
> + * find_busiest_group() in kernel/sched.c
>   */
> 
> -static inline int sd_power_saving_flags(void)
> +static inline int sd_power_saving_flags(enum sched_domain_level level)
>  {
> -	if (sched_mc_power_savings | sched_smt_power_savings)
> -		return SD_BALANCE_NEWIDLE;
> +	if (level == SD_LV_MC && !sched_smt_power_savings)
> +		return 0;
> +	if (level == SD_LV_CPU &&
> +		!(sched_mc_power_savings || sched_smt_power_savings))
> +		return 0;
> 
> -	return 0;
> +	return SD_POWERSAVINGS_BALANCE | SD_BALANCE_NEWIDLE;
>  }
> 
>  struct sched_group {
> @@ -847,16 +858,6 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
>  	return to_cpumask(sg->cpumask);
>  }
> 
> -enum sched_domain_level {
> -	SD_LV_NONE = 0,
> -	SD_LV_SIBLING,
> -	SD_LV_MC,
> -	SD_LV_CPU,
> -	SD_LV_NODE,
> -	SD_LV_ALLNODES,
> -	SD_LV_MAX
> -};
> -
>  struct sched_domain_attr {
>  	int relax_domain_level;
>  };
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index e632d29..8097dce 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -125,8 +125,7 @@ int arch_update_cpu_topology(void);
>  				| SD_WAKE_AFFINE	\
>  				| SD_WAKE_BALANCE	\
>  				| SD_SHARE_PKG_RESOURCES\
> -				| sd_balance_for_mc_power()\
> -				| sd_power_saving_flags(),\
> +				| sd_power_saving_flags(SD_LV_MC),\
>  	.last_balance		= jiffies,		\
>  	.balance_interval	= 1,			\
>  }
> @@ -151,8 +150,7 @@ int arch_update_cpu_topology(void);
>  				| SD_BALANCE_FORK	\
>  				| SD_WAKE_AFFINE	\
>  				| SD_WAKE_BALANCE	\
> -				| sd_balance_for_package_power()\
> -				| sd_power_saving_flags(),\
> +				| sd_power_saving_flags(SD_LV_CPU),\
>  	.last_balance		= jiffies,		\
>  	.balance_interval	= 1,			\
>  }

--Vaidy

