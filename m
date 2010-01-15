Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0AOT6P (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065Ab0AOT6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:58:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0AOT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:58:14 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=mVfuvzjXvF3-R1Y06xAA:9 a=OOE5cEcSTeESNLf9bCEA:7 a=7iR8x94pgTU9rzUwcx4M1RCp5FkA:4 a=jeBq3FmKZ4MA:10 a=0wKMtcZ-cr3VrKYz:21 a=GqrSoLpc0GRkvcS_:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v6)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicholas Miell <nmiell@comcast.net>, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com
In-Reply-To: <20100115182914.GA10596@Krystal>
References: <20100115182914.GA10596@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 15 Jan 2010 14:58:09 -0500
Message-ID: <1263585489.28171.3990.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 13:29 -0500, Mathieu Desnoyers wrote:

> +SYSCALL_DEFINE1(membarrier, unsigned int, flags)
> +{
> +#ifdef CONFIG_SMP
> +	cpumask_var_t tmpmask;
> +	struct mm_struct *mm;
> +	int cpu;
> +
> +	/*
> +	 * Expect _only_ one of expedited or delayed flags.
> +	 * Don't care about optional mask for now.
> +	 */
> +	switch(flags & MEMBARRIER_MANDATORY_MASK) {
> +	case MEMBARRIER_EXPEDITED:
> +	case MEMBARRIER_DELAYED:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	if (unlikely(flags & MEMBARRIER_QUERY
> +		     || thread_group_empty(current)
> +		     || (num_online_cpus() == 1)))

I really hate the overuse of unlikely in the kernel. Unless it is 99.9%
false, it should not be used. My branch analyzer shows lots of areas in
the kernel that need this fixed.

For the check of MEMBARRIER_QUERY and thread_group_empty(), sure that
could be 99.9% true. But for num_online_cpus() == 1, I can see that
always being true. How may boxes do you have that are uniprocessor that
run without CONFIG_SMP=y?  Every distro I know enables this, only
embedded boards seem not to. So you just made the 100% true condition
unlikely on those boards. Grant it, this may not be such a big deal, but
I like to shed light on the overuse of unlikely. I don't think this
unlikely is worth it.


> +		return 0;
> +	if (flags & MEMBARRIER_DELAYED) {
> +		synchronize_sched();
> +		return 0;
> +	}
> +	/*
> +	 * Memory barrier on the caller thread _before_ sending first
> +	 * IPI. Matches memory barriers around mm_cpumask modification in
> +	 * switch_mm().
> +	 */
> +	smp_mb();
> +	if (!alloc_cpumask_var(&tmpmask, GFP_NOWAIT)) {
> +		membarrier_retry();
> +		goto unlock;

This unlock label is misleading, I had to go and see what it unlocked,
it which it did not unlock anything. Change it to "out".

> +	}
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

rename to "out:"

> +	/*
> +	 * Memory barrier on the caller thread _after_ we finished
> +	 * waiting for the last IPI. Matches memory barriers around mm_cpumask
> +	 * modification in switch_mm().
> +	 */
> +	smp_mb();
> +#endif /* #ifdef CONFIG_SMP */
> +	return 0;
> +}
> +
>  #ifndef CONFIG_SMP
>  
>  int rcu_expedited_torture_stats(char *page)
> Index: linux-2.6-lttng/arch/x86/include/asm/mmu_context.h
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/include/asm/mmu_context.h	2010-01-12 10:59:31.000000000 -0500
> +++ linux-2.6-lttng/arch/x86/include/asm/mmu_context.h	2010-01-12 11:59:49.000000000 -0500
> @@ -36,6 +36,11 @@ static inline void switch_mm(struct mm_s
>  	unsigned cpu = smp_processor_id();
>  
>  	if (likely(prev != next)) {
> +		/*
> +		 * smp_mb() between user-space thread execution and
> +		 * mm_cpumask clear is required by sys_membarrier().

Of course on x86, this just turns into a barrier();, perhaps the comment
could state, that the use of smp_mb__before_clear_bit() is more of an
example for other archs since x86 only requires a barrier().

> +		 */
> +		smp_mb__before_clear_bit();
>  		/* stop flush ipis for the previous mm */
>  		cpumask_clear_cpu(cpu, mm_cpumask(prev));
>  #ifdef CONFIG_SMP
> @@ -43,7 +48,11 @@ static inline void switch_mm(struct mm_s
>  		percpu_write(cpu_tlbstate.active_mm, next);
>  #endif
>  		cpumask_set_cpu(cpu, mm_cpumask(next));
> -
> +		/*
> +		 * smp_mb() between mm_cpumask set and user-space thread
> +		 * execution is required by sys_membarrier(). Implied by
> +		 * load_cr3.
> +		 */
>  		/* Re-load page tables */
>  		load_cr3(next->pgd);
>  
> @@ -59,9 +68,14 @@ static inline void switch_mm(struct mm_s
>  		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
>  
>  		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
> -			/* We were in lazy tlb mode and leave_mm disabled
> +			/*
> +			 * We were in lazy tlb mode and leave_mm disabled
>  			 * tlb flush IPI delivery. We must reload CR3
>  			 * to make sure to use no freed page tables.
> +			 *
> +			 * smp_mb() between mm_cpumask set and user-space
> +			 * thread execution is required by sys_membarrier().
> +			 * Implied by load_cr3.
>  			 */
>  			load_cr3(next->pgd);
>  			load_LDT_nolock(&next->context);
> Index: linux-2.6-lttng/include/linux/membarrier.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/linux/membarrier.h	2010-01-13 20:34:24.000000000 -0500
> @@ -0,0 +1,25 @@
> +#ifndef _LINUX_MEMBARRIER_H
> +#define _LINUX_MEMBARRIER_H
> +
> +/* First argument to membarrier syscall */
> +
> +/*
> + * Mandatory flags to the membarrier system call that the kernel must
> + * understand are in the low 16 bits.
> + */
> +#define MEMBARRIER_MANDATORY_MASK	0x0000FFFF	/* Mandatory flags */
> +
> +/*
> + * Optional hints that the kernel can ignore are in the high 16 bits.
> + */
> +#define MEMBARRIER_OPTIONAL_MASK	0xFFFF0000	/* Optional hints */
> +
> +/* Expedited: adds some overhead, fast execution (few microseconds) */
> +#define MEMBARRIER_EXPEDITED		(1 << 0)
> +/* Delayed: Low overhead, but slow execution (few milliseconds) */
> +#define MEMBARRIER_DELAYED		(1 << 1)
> +
> +/* Query flag support, without performing synchronization */
> +#define MEMBARRIER_QUERY		(1 << 16)
> +
> +#endif
> Index: linux-2.6-lttng/include/linux/Kbuild
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/Kbuild	2010-01-13 18:40:58.000000000 -0500
> +++ linux-2.6-lttng/include/linux/Kbuild	2010-01-13 18:41:24.000000000 -0500
> @@ -110,6 +110,7 @@ header-y += magic.h
>  header-y += major.h
>  header-y += map_to_7segment.h
>  header-y += matroxfb.h
> +header-y += membarrier.h
>  header-y += meye.h
>  header-y += minix_fs.h
>  header-y += mmtimer.h
> 

The rest:

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


