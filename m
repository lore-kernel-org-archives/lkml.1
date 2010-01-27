Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319Ab0A0Az0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0A0Az0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890Ab0A0AzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:55:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:54413 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0A0AzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:55:24 -0500
Subject: Re: [PATCHv2 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1264548495.12239.56.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 11:52:57 +1100
Message-ID: <1264553577.3601.144.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 17:28 -0600, Joel Schopp wrote:
> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
> there is performance benefit to idling the higher numbered threads in
> the core.  
> 
> This patch implements arch_scale_smt_power to dynamically update smt
> thread power in these idle cases in order to prefer threads 0,1 over
> threads 2,3 within a core.
> 
> v2 - Same functionality as v1, better coding style.

Better. Some more comments...

> Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
> ---
> Version 2 addresses style and optimization, same basic functionality
> Index: linux-2.6.git/arch/powerpc/kernel/smp.c
> ===================================================================
> --- linux-2.6.git.orig/arch/powerpc/kernel/smp.c
> +++ linux-2.6.git/arch/powerpc/kernel/smp.c
> @@ -620,3 +620,55 @@ void __cpu_die(unsigned int cpu)
>  		smp_ops->cpu_die(cpu);
>  }
>  #endif
> +
> +unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
> +{
> +	int sibling;
> +	int idle_count = 0;
> +	int thread;
> +
> +	struct cpumask *sibling_map = sched_domain_span(sd);

What about an early exit if !cpu_has_feature(CPU_FTR_SMT) ? That would
de-facto compile it out for 32-bit CPU platforms that don't support SMT
at all and avoid some overhead on POWER3,4,970...

> +	unsigned long weight = cpumask_weight(sibling_map);
> +	unsigned long smt_gain = sd->smt_gain;
> +
> +	if (cpu_has_feature(CPU_FTR_ASYNC_SMT4) && weight == 4) {

So that will only handle the case where all 4 threads are online right ?
There is no provision for the case where the user play tricks like
offlining thread, in which case it will stop trying to "push down"
processes right ? Not a big deal per-se I suppose, just something to be
aware of.

Also, can you add a comment as to why this is done in the code itself ?
above the if (cpu_has_feature(...)) statement.
 
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
> +}

Appart from that, it looks allright to me.

Cheers,
Ben.


