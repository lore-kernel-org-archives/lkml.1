Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbZIBLW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbZIBLW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZIBLWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:22:55 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57825 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZIBLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:22:54 -0400
Date: Wed, 2 Sep 2009 16:52:50 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 4/8] sched: add smt_gain
Message-ID: <20090902112250.GD3817@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090901083431.748830771@chello.nl> <20090901083826.073345955@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901083826.073345955@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 10:34:35AM +0200, Peter Zijlstra wrote:
> The idea is that multi-threading a core yields more work capacity than
> a single thread, provide a way to express a static gain for threads.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/sched.h    |    1 +
>  include/linux/topology.h |    1 +
>  kernel/sched.c           |    8 +++++++-
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -930,6 +930,7 @@ struct sched_domain {
>  	unsigned int newidle_idx;
>  	unsigned int wake_idx;
>  	unsigned int forkexec_idx;
> +	unsigned int smt_gain;
>  	int flags;			/* See SD_* */
>  	enum sched_domain_level level;
> 
> Index: linux-2.6/include/linux/topology.h
> ===================================================================
> --- linux-2.6.orig/include/linux/topology.h
> +++ linux-2.6/include/linux/topology.h
> @@ -99,6 +99,7 @@ int arch_update_cpu_topology(void);
>  				| SD_SHARE_CPUPOWER,	\
>  	.last_balance		= jiffies,		\
>  	.balance_interval	= 1,			\
> +	.smt_gain		= 1178,	/* 15% */	\

/* 15% of SCHED_LOAD_SCALE */ , I suppose.

>  }
>  #endif
>  #endif /* CONFIG_SCHED_SMT */
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -8490,9 +8490,15 @@ static void init_sched_groups_power(int 
>  		weight = cpumask_weight(sched_domain_span(sd));
>  		/*
>  		 * SMT siblings share the power of a single core.
> +		 * Usually multiple threads get a better yield out of
> +		 * that one core than a single thread would have,
> +		 * reflect that in sd->smt_gain.
>  		 */
> -		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1)
> +		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
> +			power *= sd->smt_gain;
>  			power /= weight;
> +			power >>= SCHED_LOAD_SHIFT;
> +		}
>  		sg_inc_cpu_power(sd->groups, power);
>  		return;
>  	}
> 
> -- 

-- 
Thanks and Regards
gautham
