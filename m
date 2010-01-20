Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322Ab0ATUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0ATUtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413Ab0ATUtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:49:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0ATUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:49:17 -0500
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <1264017847.5717.132.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 21:48:37 +0100
Message-ID: <1264020517.4283.1117.camel@laptop>
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

So this is an actual performance improvement, not only power savings?

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
> +
> +	return smt_gain;
> +
> +}

This looks to suffer significant whitespace damage.

The design goal for smt_power was to be able to actually measure the
processing gains from smt and feed that into the scheduler, not really
placement tricks like this.

Now I also heard AMD might want to have something similar to this,
something to do with powerlines and die layout.

I'm not sure playing games with cpu_power is the best or if simply
moving tasks to lower numbered cpus using an SD_flag is the best
solution for these kinds of things.

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

And you just wrecked x86 ;-)

It has an smt_power implementation that tries to measure smt gains using
aperf/mperf, trouble is that this represents the actual performance not
the capacity. This has the problem that when idle it represents 0
capacity and will not attract work.

Coming up with something that actually works there is on the todo list,
I was thinking perhaps temporal maximums from !idle.

So if you want to go with this, you'll need to stub out
arch/x86/kernel/cpu/sched.c



