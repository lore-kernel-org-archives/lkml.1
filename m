Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZHXO63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZHXO63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZHXO63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:58:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:42804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZHXO62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:58:28 -0400
Subject: Re: [PATCH 9/15] sched: Check sched_mn_power_savings when setting
 flags for CPU and MN domains
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>
In-Reply-To: <20090820134013.GX29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134013.GX29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 16:57:42 +0200
Message-Id: <1251125862.7538.270.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:40 +0200, Andreas Herrmann wrote:
> Use new function sd_balance_for_mn_power() and adapt
> sd_balance_for_package_power() and sd_power_saving_flags() for correct
> setting of flags SD_POWERSAVINGS_BALANCE and SD_BALANCE_NEWIDLE in CPU
> and MN domains.
> 
> Furthermore add flag SD_SHARE_PKG_RESOURCES to MN domain.
> Rational: a multi-node processor most likely shares package resources
> (on Magny-Cours the package constitues a "voltage domain").

IIRC SD_SHARE_PKG_RESOURCES plays games with the cpu_pwer of a
sched_domain, which breaks in all kinds of curious ways, this adds more
breakage afaict.

ego?

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
> +}
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
