Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659Ab0AMDXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0AMDXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 22:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036Ab0AMDXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 22:23:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36057 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0AMDXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 22:23:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory barrier (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100113013757.GA29314@Krystal>
References: <20100113013757.GA29314@Krystal>
Message-Id: <20100113110455.B3D3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Jan 2010 12:23:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Interesting patch :)

I have few comments.

> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-12 10:25:47.000000000 -0500
> +++ linux-2.6-lttng/kernel/sched.c	2010-01-12 14:33:20.000000000 -0500
> @@ -10822,6 +10822,117 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
>  
> +#ifdef CONFIG_SMP
> +
> +/*
> + * Execute a memory barrier on all active threads from the current process
> + * on SMP systems. Do not rely on implicit barriers in IPI handler execution,
> + * because batched IPI lists are synchronized with spinlocks rather than full
> + * memory barriers. This is not the bulk of the overhead anyway, so let's stay
> + * on the safe side.
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
> +	struct mm_struct *mm;
> +	int cpu;
> +
> +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> +		spin_lock_irq(&cpu_rq(cpu)->lock);
> +		mm = cpu_curr(cpu)->mm;
> +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> +		if (current->mm == mm)
> +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> +	}
> +}
> +
> +#endif /* #ifdef CONFIG_SMP */
> +
> +/*
> + * sys_membarrier - issue memory barrier on current process running threads
> + * @expedited: (0) Lowest overhead. Few milliseconds latency.
> + *             (1) Few microseconds latency.

Why do we need both expedited and non-expedited mode? at least, this documentation
is bad. it suggest "you have to use non-expedited mode always!".


> + *
> + * Execute a memory barrier on all running threads of the current process.
> + * Upon completion, the caller thread is ensured that all process threads
> + * have passed through a state where memory accesses match program order.
> + * (non-running threads are de facto in such a state)
> + *
> + * mm_cpumask is used as an approximation. It is a superset of the cpumask to
> + * which we must send IPIs, mainly due to lazy TLB shootdown. Therefore,
> + * we check each runqueue to make sure our ->mm is indeed running on them. This
> + * reduces the risk of disturbing a RT task by sending unnecessary IPIs. There
> + * is still a slight chance to disturb an unrelated task, because we do not lock
> + * the runqueues while sending IPIs, but the real-time effect of this heavy
> + * locking would be worse than the comparatively small disruption of an IPI.
> + *
> + * RED PEN: before assinging a system call number for sys_membarrier() to an
> + * architecture, we must ensure that switch_mm issues full memory barriers (or a
> + * synchronizing instruction having the same effect) between:
> + * - user-space code execution and clear mm_cpumask.
> + * - set mm_cpumask and user-space code execution.
> + * In some case adding a comment to this effect will suffice, in others we will
> + * need to add smp_mb__before_clear_bit()/smp_mb__after_clear_bit() or simply
> + * smp_mb(). These barriers are required to ensure we do not _miss_ a CPU that
> + * need to receive an IPI, which would be a bug.
> + *
> + * On uniprocessor systems, this system call simply returns 0 without doing
> + * anything, so user-space knows it is implemented.
> + */
> +SYSCALL_DEFINE1(membarrier, int, expedited)
> +{
> +#ifdef CONFIG_SMP
> +	cpumask_var_t tmpmask;
> +	struct mm_struct *mm;
> +	int cpu;
> +
> +	if (unlikely(thread_group_empty(current) || (num_online_cpus() == 1)))
> +		return 0;
> +	if (!unlikely(expedited)) {

unlikely(!expedited)?


> +		synchronize_sched();
> +		return 0;
> +	}
> +	/*
> +	 * Memory barrier on the caller thread _before_ sending first
> +	 * IPI. Matches memory barriers around mm_cpumask modification in
> +	 * switch_mm().
> +	 */
> +	smp_mb();
> +	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> +		membarrier_retry();
> +		goto unlock;
> +	}

if CONFIG_CPUMASK_OFFSTACK=1, alloc_cpumask_var call kmalloc. FWIW,
kmalloc calling seems destory the worth of this patch.

#ifdef CONFIG_CPUMASK_OFFSTACK
	membarrier_retry();
	goto unlock;
#endif

is better? I'm not sure.


> +	cpumask_copy(tmpmask, mm_cpumask(current->mm));
> +	preempt_disable();
> +	cpumask_clear_cpu(smp_processor_id(), tmpmask);
> +	for_each_cpu(cpu, tmpmask) {
> +		spin_lock_irq(&cpu_rq(cpu)->lock);
> +		mm = cpu_curr(cpu)->mm;
> +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> +		if (current->mm != mm)
> +			cpumask_clear_cpu(cpu, tmpmask);
> +	}
> +	smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
> +	preempt_enable();
> +	free_cpumask_var(tmpmask);
> +unlock:
> +	/*
> +	 * Memory barrier on the caller thread _after_ we finished
> +	 * waiting for the last IPI. Matches memory barriers around mm_cpumask
> +	 * modification in switch_mm().
> +	 */
> +	smp_mb();
> +#endif /* #ifdef CONFIG_SMP */
> +	return 0;
> +}


