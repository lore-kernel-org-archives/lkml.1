Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZHZKBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZHZKBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZHZKBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:01:53 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:58965 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbZHZKBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:01:53 -0400
Date: Wed, 26 Aug 2009 15:31:18 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 9/15] sched: Check sched_mn_power_savings when setting
	flags for CPU and MN domains
Message-ID: <20090826100118.GB22064@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090820131243.GO29327@alberich.amd.com> <20090820134013.GX29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820134013.GX29327@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 03:40:13PM +0200, Andreas Herrmann wrote:
> 
> Use new function sd_balance_for_mn_power() and adapt
> sd_balance_for_package_power() and sd_power_saving_flags() for correct
> setting of flags SD_POWERSAVINGS_BALANCE and SD_BALANCE_NEWIDLE in CPU
> and MN domains.
> 
> Furthermore add flag SD_SHARE_PKG_RESOURCES to MN domain.
> Rational: a multi-node processor most likely shares package resources
> (on Magny-Cours the package constitues a "voltage domain").
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/include/asm/topology.h |    3 ++-
>  include/linux/sched.h           |   14 ++++++++++++--
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index 6d7d133..4a520b8 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -198,7 +198,8 @@ static inline void setup_node_to_cpumask_map(void) { }
>  				| SD_BALANCE_EXEC	\
>  				| SD_WAKE_AFFINE	\
>  				| SD_WAKE_BALANCE	\
> -				| sd_balance_for_package_power()\
> +				| SD_SHARE_PKG_RESOURCES\
> +				| sd_balance_for_mn_power()\
>  				| sd_power_saving_flags(),\
>  	.last_balance		= jiffies,		\
>  	.balance_interval	= 1,			\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5755643..c53bdd8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -844,9 +844,18 @@ static inline int sd_balance_for_mc_power(void)
>  	return 0;
>  }
> 
> +static inline int sd_balance_for_mn_power(void)
> +{
> +	if (sched_mc_power_savings || sched_smt_power_savings)
> +		return SD_POWERSAVINGS_BALANCE;
> +
> +	return 0;

This again implies that if SD_POWERSAVINGS_BALANCE is set at any level,
it must also be set at it's parent.

With this constraint, there can only be 4 combinations.
0) SD_POWERSAVINGS_BALANCE not set.
1) SD_POWERSAVINGS_BALANCE set at SD_LV_CPU.
2) SD_POWERSAVINGS_BALANCE set at SD_LV_MN and SD_LV_CPU
3) SD_POWERSAVINGS_BALANCE set at SD_LV_MC, SD_LV_MN and SD_LV_CPU.

If we could independently decide the aggressiveness of consolidation
(i.e, 1 or 2), We can do away with these multiple sysfs variables have
have a single tunable.

Does this make sense ?

> +
>  static inline int sd_balance_for_package_power(void)
>  {
> -	if (sched_mc_power_savings | sched_smt_power_savings)
> +	if (sched_mn_power_savings || sched_mc_power_savings ||
> +	    sched_smt_power_savings)
>  		return SD_POWERSAVINGS_BALANCE;
> 
>  	return 0;
> @@ -860,7 +869,8 @@ static inline int sd_balance_for_package_power(void)
> 
>  static inline int sd_power_saving_flags(void)
>  {
> -	if (sched_mc_power_savings | sched_smt_power_savings)
> +	if (sched_mn_power_savings || sched_mc_power_savings ||
> +	    sched_smt_power_savings)
>  		return SD_BALANCE_NEWIDLE;
> 
>  	return 0;
> -- 
> 1.6.0.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks and Regards
gautham
