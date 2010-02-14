Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab0BNKPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:15:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:39830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0BNKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:15:39 -0500
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
In-Reply-To: <1265403478.6089.41.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264720855.9660.22.camel@jschopp-laptop>
	 <1264721088.10385.1.camel@jschopp-laptop>
	 <1265403478.6089.41.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:12:20 +0100
Message-ID: <1266142340.5273.418.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 14:57 -0600, Joel Schopp wrote:
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
> @@ -620,3 +620,61 @@ void __cpu_die(unsigned int cpu)
>  		smp_ops->cpu_die(cpu);
>  }
>  #endif
> +
> +#ifdef CONFIG_SCHED_SMT
> +unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
> +{
> +	int sibling;
> +	int idle_count = 0;
> +	int thread;
> +
> +	/* Setup the default weight and smt_gain used by most cpus for SMT
> +	 * Power.  Doing this right away covers the default case and can be
> +	 * used by cpus that modify it dynamically.
> +	 */
> +	struct cpumask *sibling_map = sched_domain_span(sd);
> +	unsigned long weight = cpumask_weight(sibling_map);
> +	unsigned long smt_gain = sd->smt_gain;
> +
> +
> +	if (cpu_has_feature(CPU_FTR_ASYNC_SMT4) && weight == 4) {
> +		for_each_cpu(sibling, sibling_map) {
> +			if (idle_cpu(sibling))
> +				idle_count++;
> +		}
> +
> +		/* the following section attempts to tweak cpu power based
> +		 * on current idleness of the threads dynamically at runtime
> +		 */
> +		if (idle_count > 1) {
> +			thread = cpu_thread_in_core(cpu);
> +			if (thread < 2) {
> +				/* add 75 % to thread power */
> +				smt_gain += (smt_gain >> 1) + (smt_gain >> 2);
> +			} else {
> +				 /* subtract 75 % to thread power */
> +				smt_gain = smt_gain >> 2;
> +			}
> +		}
> +	}
> +
> +	/* default smt gain is 1178, weight is # of SMT threads */
> +	switch (weight) {
> +	case 1:
> +		/*divide by 1, do nothing*/
> +		break;
> +	case 2:
> +		smt_gain = smt_gain >> 1;
> +		break;
> +	case 4:
> +		smt_gain = smt_gain >> 2;
> +		break;
> +	default:
> +		smt_gain /= weight;
> +		break;
> +	}
> +
> +	return smt_gain;
> +
> +}
> +#endif

Suppose for a moment we have 2 threads (hot-unplugged thread 1 and 3, we
can construct an equivalent but more complex example for 4 threads), and
we have 4 tasks, 3 SCHED_OTHER of equal nice level and 1 SCHED_FIFO, the
SCHED_FIFO task will consume exactly 50% walltime of whatever cpu it
ends up on.

In that situation, provided that each cpu's cpu_power is of equal
measure, scale_rt_power() ensures that we run 2 SCHED_OTHER tasks on the
cpu that doesn't run the RT task, and 1 SCHED_OTHER task next to the RT
task, so that each task consumes 50%, which is all fair and proper.

However, if you do the above, thread 0 will have +75% = 1.75 and thread
2 will have -75% = 0.25, then if the RT task will land on thread 0,
we'll be having: 0.875 vs 0.25, or on thread 3, 1.75 vs 0.125. In either
case thread 0 will receive too many (if not all) SCHED_OTHER tasks.

That is, unless these threads 2 and 3 really are _that_ weak, at which
point one wonders why IBM bothered with the silicon ;-)

So tell me again, why is fiddling with the cpu_power a good placement
tool?


