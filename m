Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725Ab0ATVga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0ATVga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197Ab0ATVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:36:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:43639 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab0ATVg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:36:28 -0500
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1264017847.5717.132.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 08:33:33 +1100
Message-ID: <1264023213.724.561.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 14:04 -0600, Joel Schopp wrote:
> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
> there is performance benefit to idling the higher numbered threads in
> the core.  
> 
> This patch implements arch_scale_smt_power to dynamically update smt
> thread power in these idle cases in order to prefer threads 0,1 over
> threads 2,3 within a core.
> 
> Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>

So I'll leave Peter deal with the scheduler aspects and will focus on
details :-)

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

Needs a whitespace here though I don't really like the above. Any reason
why you can't use the existing cpu_thread_in_core() ?

> +unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
> +{
> +  int cpu2;
> +  int idle_count = 0;
> +
> +  struct cpumask *cpu_map = sched_domain_span(sd);
> +
> +	unsigned long weight = cpumask_weight(cpu_map);
> +	unsigned long smt_gain = sd->smt_gain;

More whitespace damage above.

> +	if (cpu_has_feature(CPU_FTRS_POWER7) && weight == 4) {
> +		for_each_cpu(cpu2, cpu_map) {
> +			if (idle_cpu(cpu2))
> +				idle_count++;
> +		}

I'm not 100% sure about the use of the CPU feature above. First I wonder
if the right approach is to instead do something like

	if (!cpu_has_feature(...) !! weigth < 4)
		return default_scale_smt_power(sd, cpu);

Though we may be better off using a ppc_md. hook here to avoid
calculating the weight etc... on processors that don't need any
of that.

I also dislike your naming. I would suggest you change cpu_map to
sibling_map() and cpu2 to sibling (or just c). One thing I wonder is how
sure we are that sched_domain_span() is always going to give us the
threads btw ? If we introduce another sched domain level for NUMA
purposes can't we get confused ?

Also, how hot is this code path ?

> +		/* the following section attempts to tweak cpu power based
> +		 * on current idleness of the threads dynamically at runtime
> +		 */
> +		if (idle_count == 2 || idle_count == 3 || idle_count == 4) {

		if (idle_count > 1) ? :-)

> +			if (thread_in_smt4core(cpu) == 0 ||
> +			    thread_in_smt4core(cpu) == 1) {

			int thread = cpu_thread_in_core(cpu);
			if (thread < 2)
				...

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
> +
> +	return smt_gain;

Cheers,
Ben.

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


