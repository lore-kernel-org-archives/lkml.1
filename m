Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911Ab0AIKsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0AIKsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 05:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980Ab0AIKsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 05:48:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:48080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0AIKse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 05:48:34 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com, Josh Triplett <josh@joshtriplett.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100108235649.GA18477@Krystal>
References: <20100108235649.GA18477@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Jan 2010 11:47:43 +0100
Message-ID: <1263034063.557.6495.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 18:56 -0500, Mathieu Desnoyers wrote:

> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 23:23:34.000000000 -0500
> +++ linux-2.6-lttng/kernel/sched.c	2010-01-08 18:17:44.000000000 -0500
> @@ -119,6 +119,11 @@
>   */
>  #define RUNTIME_INF	((u64)~0ULL)
>  
> +/*
> + * IPI vs cpumask broadcast threshold. Threshold of 1 IPI.
> + */
> +#define ADAPT_IPI_THRESHOLD	1
> +
>  static inline int rt_policy(int policy)
>  {
>  	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
> @@ -10822,6 +10827,124 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
>  
> +/*
> + * Execute a memory barrier on all CPUs on SMP systems.
> + * Do not rely on implicit barriers in smp_call_function(), just in case they
> + * are ever relaxed in the future.
> + */
> +static void membarrier_ipi(void *unused)
> +{
> +	smp_mb();
> +}
> +
> +/*
> + * Handle out-of-mem by sending per-cpu IPIs instead.
> + */
> +static void membarrier_retry(void)
> +{
> +	int cpu;
> +
> +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> +		if (cpu_curr(cpu)->mm == current->mm)
> +			smp_call_function_single(cpu, membarrier_ipi,
> +						 NULL, 1);
> +	}
> +}


> +SYSCALL_DEFINE0(membarrier)
> +{
> +#ifdef CONFIG_SMP
> +	int cpu, i, cpu_ipi[ADAPT_IPI_THRESHOLD], nr_cpus = 0;
> +	cpumask_var_t tmpmask;
> +	int this_cpu;
> +
> +	if (likely(!thread_group_empty(current))) {
> +		rcu_read_lock();	/* protect cpu_curr(cpu)-> access */
> +		/*
> +		 * We don't need to include ourself in IPI, as we already
> +		 * surround our execution with memory barriers. We also
> +		 * don't have to disable preemption here, because if we
> +		 * migrate out of "this_cpu", then there is an implied memory
> +		 * barrier for the thread now running on "this_cpu".
> +		 */
> +		this_cpu = raw_smp_processor_id();

How is this not a bug?

> +		/*
> +		 * Memory barrier on the caller thread _before_ the first
> +		 * cpu_curr(cpu)->mm read and also before sending first IPI.
> +		 */
> +		smp_mb();
> +		/* Get CPU IDs up to threshold */
> +		for_each_cpu(cpu, mm_cpumask(current->mm)) {
> +			if (unlikely(cpu == this_cpu))
> +				continue;
> +			if (cpu_curr(cpu)->mm == current->mm) {
> +				if (nr_cpus == ADAPT_IPI_THRESHOLD) {
> +					nr_cpus++;
> +					break;
> +				}
> +				cpu_ipi[nr_cpus++] = cpu;
> +			}
> +		}
> +		if (likely(nr_cpus <= ADAPT_IPI_THRESHOLD)) {
> +			for (i = 0; i < nr_cpus; i++) {
> +				smp_call_function_single(cpu_ipi[i],
> +							 membarrier_ipi,
> +							 NULL, 1);
> +			}
> +		} else {
> +			if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> +				membarrier_retry();
> +				goto unlock;
> +			}
> +			for (i = 0; i < ADAPT_IPI_THRESHOLD; i++)
> +				cpumask_set_cpu(cpu_ipi[i], tmpmask);
> +			/* Continue previous for_each_cpu() */
> +			do {
> +				if (cpu_curr(cpu)->mm == current->mm)
> +					cpumask_set_cpu(cpu, tmpmask);
> +				cpu = cpumask_next(cpu,
> +						   mm_cpumask(current->mm));
> +				if (unlikely(cpu == this_cpu))
> +					continue;
> +			} while (cpu < nr_cpu_ids);
> +			preempt_disable();	/* explicitly required */

This seems to indicate the same.

> +			smp_call_function_many(tmpmask, membarrier_ipi, NULL,
> +					       1);
> +			preempt_enable();
> +			free_cpumask_var(tmpmask);
> +		}
> +unlock:
> +		/*
> +		 * Memory barrier on the caller thread _after_ we finished
> +		 * waiting for the last IPI and also after reading the last
> +		 * cpu_curr(cpu)->mm.
> +		 */
> +		smp_mb();
> +		rcu_read_unlock();
> +	}
> +#endif	/* #ifdef CONFIG_SMP */
> +	return 0;
> +}
> +
>  #ifndef CONFIG_SMP
>  
>  int rcu_expedited_torture_stats(char *page)

