Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367Ab0ATVEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0ATVEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945Ab0ATVEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:04:08 -0500
Received: from ozlabs.org ([203.10.76.45]:43733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab0ATVEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:04:07 -0500
From: Michael Neuling <mikey@neuling.org>
To: Joel Schopp <jschopp@austin.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <1264017847.5717.132.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop>
Comments: In-reply-to Joel Schopp <jschopp@austin.ibm.com>
   message dated "Wed, 20 Jan 2010 14:04:07 -0600."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 21 Jan 2010 10:04:03 +1300
Message-ID: <26556.1264021443@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
> there is performance benefit to idling the higher numbered threads in
> the core.  
> 
> This patch implements arch_scale_smt_power to dynamically update smt
> thread power in these idle cases in order to prefer threads 0,1 over
> threads 2,3 within a core.
> 
> Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
> ---
> Index: linux-2.6.git/arch/powerpc/kernel/smp.c
> ===================================================================
> --- linux-2.6.git.orig/arch/powerpc/kernel/smp.c
> +++ linux-2.6.git/arch/powerpc/kernel/smp.c
> @@ -617,3 +617,44 @@ void __cpu_die(unsigned int cpu)
>  		smp_ops->cpu_die(cpu);
>  }
>  #endif
> +
> +static inline int thread_in_smt4core(int x)
> +{
> +  return x % 4;
> +}
> +unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
> +{
> +  int cpu2;
> +  int idle_count = 0;
> +
> +  struct cpumask *cpu_map = sched_domain_span(sd);
> +
> +	unsigned long weight = cpumask_weight(cpu_map);
> +	unsigned long smt_gain = sd->smt_gain;
> +
> +	if (cpu_has_feature(CPU_FTRS_POWER7) && weight == 4) {

I think we should avoid using cpu_has_feature like this.  It's better to
create a new feature and add it to POWER7 in the cputable, then check
for that here.

The way that it is now, I think any CPU that has superset of the POWER7
features, will be true here.  This is not what we want.

> +		for_each_cpu(cpu2, cpu_map) {
> +			if (idle_cpu(cpu2))
> +				idle_count++;
> +		}
> +
> +		/* the following section attempts to tweak cpu power based
> +		 * on current idleness of the threads dynamically at runtime
> +		 */
> +		if (idle_count == 2 || idle_count == 3 || idle_count == 4) {
> +			if (thread_in_smt4core(cpu) == 0 ||
> +			    thread_in_smt4core(cpu) == 1) {
> +				/* add 75 % to thread power */
> +				smt_gain += (smt_gain >> 1) + (smt_gain >> 2);
> +			} else {
> +				 /* subtract 75 % to thread power */
> +				smt_gain = smt_gain >> 2;
> +			}
> +		}
> +	}
> +	/* default smt gain is 1178, weight is # of SMT threads */
> +	smt_gain /= weight;

This results in a PPC div, when most of the time it's going to be a
power of two divide.  You've optimised the divides a few lines above
this, but not this one.  Some consistency would be good.

Mikey

> +
> +	return smt_gain;
> +
> +}
> Index: linux-2.6.git/kernel/sched_features.h
> ===================================================================
> --- linux-2.6.git.orig/kernel/sched_features.h
> +++ linux-2.6.git/kernel/sched_features.h
> @@ -107,7 +107,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, 1)
>  /*
>   * Use arch dependent cpu power functions
>   */
> -SCHED_FEAT(ARCH_POWER, 0)
> +SCHED_FEAT(ARCH_POWER, 1)
>  
>  SCHED_FEAT(HRTICK, 0)
>  SCHED_FEAT(DOUBLE_TICK, 0)
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
