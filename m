Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYJCElm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYJCElm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYJCEla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:41:30 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:50998 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbYJCEl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:41:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAHg/5UhMQWq+/2dsb2JhbACBcbo0gWg
Date: Fri, 3 Oct 2008 00:41:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, laijs@cn.fujitsu.com,
       manfred@colorfullife.com, dipankar@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, josht@linux.vnet.ibm.com,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH tip/master] RCU-based detection of stalled CPUs for
	Classic RCU
Message-ID: <20081003044127.GB5331@Krystal>
References: <20081002003628.GA7877@linux.vnet.ibm.com> <20081002080726.GB17695@elte.hu> <20081002140507.GB6729@linux.vnet.ibm.com> <20081002151046.GB2473@Krystal> <20081002174318.GB7324@linux.vnet.ibm.com> <20081002185115.GA11047@Krystal> <20081002225537.GA6706@linux.vnet.ibm.com> <20081002230639.GA7522@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081002230639.GA7522@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:40:33 up 120 days,  9:20,  8 users,  load average: 0.06, 0.12,
	0.13
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Hello!
> 
> This patch adds stalled-CPU detection to Classic RCU.  This capability
> is enabled by a new config variable CONFIG_RCU_CPU_STALL_DETECTOR, which
> defaults disabled.  This is a debugging feature to detect infinite loops
> in kernel code, not something that non-kernel-hackers would be expected
> to care about.  This feature can detect looping CPUs in !PREEMPT builds
> and looping CPUs with preemption disabled in PREEMPT builds.  This is
> essentially a port of this functionality from the treercu patch, replacing
> the stall debug patch that is already in tip/core/rcu (commit 67182ae1c4).
> 
> The changes from the patch in tip/core/rcu include making the config
> variable name match that in treercu, changing from seconds to jiffies to
> avoid spurious warnings, and printing a boot message when this feature
> is enabled.
> 

Hi Paul,

Thanks for the previous explanations. Out of curiosity, what can this
patch do that the nmi watchdog can't do ?

Mathieu

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  include/linux/rcuclassic.h |   12 ++-
>  kernel/rcuclassic.c        |  166 +++++++++++++++++++++++----------------------
>  lib/Kconfig.debug          |    2 
>  3 files changed, 96 insertions(+), 84 deletions(-)
> 
> diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> index 29bf528..2d72d20 100644
> --- a/include/linux/rcuclassic.h
> +++ b/include/linux/rcuclassic.h
> @@ -40,15 +40,21 @@
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
>  
> +#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> +#define RCU_SECONDS_TILL_STALL_CHECK	3 * HZ	/* for rcp->jiffies_stall */
> +#define RCU_SECONDS_TILL_STALL_RECHECK	30 * HZ	/* for rcp->jiffies_stall */
> +#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
>  
>  /* Global control variables for rcupdate callback mechanism. */
>  struct rcu_ctrlblk {
>  	long	cur;		/* Current batch number.                      */
>  	long	completed;	/* Number of the last completed batch         */
>  	long	pending;	/* Number of the last pending batch           */
> -#ifdef CONFIG_DEBUG_RCU_STALL
> -	unsigned long gp_check;	/* Time grace period should end, in seconds.  */
> -#endif /* #ifdef CONFIG_DEBUG_RCU_STALL */
> +#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> +	unsigned long gp_start;	/* Time at which GP started in jiffies. */
> +	unsigned long jiffies_stall;
> +				/* Time at which to check for CPU stalls. */
> +#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
>  
>  	int	signaled;
>  
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index ed15128..eae2fb6 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -164,6 +164,87 @@ static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
>  	}
>  }
>  
> +#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> +
> +static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
> +{
> +	rcp->gp_start = jiffies;
> +	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
> +}
> +
> +static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
> +{
> +	int cpu;
> +	long delta;
> +	unsigned long flags;
> +
> +	/* Only let one CPU complain about others per time interval. */
> +
> +	spin_lock_irqsave(&rcp->lock, flags);
> +	delta = jiffies - rcp->jiffies_stall;
> +	if (delta < 2 || rcp->cur != rcp->completed) {
> +		spin_unlock_irqrestore(&rcp->lock, flags);
> +		return;
> +	}
> +	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
> +	spin_unlock_irqrestore(&rcp->lock, flags);
> +
> +	/* OK, time to rat on our buddy... */
> +
> +	printk(KERN_ERR "RCU detected CPU stalls:");
> +	for_each_possible_cpu(cpu) {
> +		if (cpu_isset(cpu, rcp->cpumask))
> +			printk(" %d", cpu);
> +	}
> +	printk(" (detected by %d, t=%ld jiffies)\n",
> +	       smp_processor_id(), (long)(jiffies - rcp->gp_start));
> +}
> +
> +static void print_cpu_stall(struct rcu_ctrlblk *rcp)
> +{
> +	unsigned long flags;
> +
> +	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
> +			smp_processor_id(), jiffies,
> +			jiffies - rcp->gp_start);
> +	dump_stack();
> +	spin_lock_irqsave(&rcp->lock, flags);
> +	if ((long)(jiffies - rcp->jiffies_stall) >= 0)
> +		rcp->jiffies_stall =
> +			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
> +	spin_unlock_irqrestore(&rcp->lock, flags);
> +	set_need_resched();  /* kick ourselves to get things going. */
> +}
> +
> +static void check_cpu_stall(struct rcu_ctrlblk *rcp)
> +{
> +	long delta;
> +
> +	delta = jiffies - rcp->jiffies_stall;
> +	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
> +		
> +		/* We haven't checked in, so go dump stack. */
> +		print_cpu_stall(rcp);
> +
> +	} else if (rcp->cur != rcp->completed && delta >= 2) {
> +
> +		/* They had two seconds to dump stack, so complain. */
> +		print_other_cpu_stall(rcp);
> +	}
> +}
> +
> +#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> +
> +static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
> +{
> +}
> +
> +static void check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
> +{
> +}
> +
> +#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> +
>  /**
>   * call_rcu - Queue an RCU callback for invocation after a grace period.
>   * @head: structure to be used for queueing the RCU updates.
> @@ -293,84 +374,6 @@ static void rcu_do_batch(struct rcu_data *rdp)
>   *   period (if necessary).
>   */
>  
> -#ifdef CONFIG_DEBUG_RCU_STALL
> -
> -static inline void record_gp_check_time(struct rcu_ctrlblk *rcp)
> -{
> -	rcp->gp_check = get_seconds() + 3;
> -}
> -
> -static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
> -{
> -	int cpu;
> -	long delta;
> -	unsigned long flags;
> -
> -	/* Only let one CPU complain about others per time interval. */
> -
> -	spin_lock_irqsave(&rcp->lock, flags);
> -	delta = get_seconds() - rcp->gp_check;
> -	if (delta < 2L || cpus_empty(rcp->cpumask)) {
> -		spin_unlock(&rcp->lock);
> -		return;
> -	}
> -	rcp->gp_check = get_seconds() + 30;
> -	spin_unlock_irqrestore(&rcp->lock, flags);
> -
> -	/* OK, time to rat on our buddy... */
> -
> -	printk(KERN_ERR "RCU detected CPU stalls:");
> -	for_each_cpu_mask(cpu, rcp->cpumask)
> -		printk(" %d", cpu);
> -	printk(" (detected by %d, t=%lu/%lu)\n",
> -	       smp_processor_id(), get_seconds(), rcp->gp_check);
> -}
> -
> -static void print_cpu_stall(struct rcu_ctrlblk *rcp)
> -{
> -	unsigned long flags;
> -
> -	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu)\n",
> -			smp_processor_id(), get_seconds(), rcp->gp_check);
> -	dump_stack();
> -	spin_lock_irqsave(&rcp->lock, flags);
> -	if ((long)(get_seconds() - rcp->gp_check) >= 0L)
> -		rcp->gp_check = get_seconds() + 30;
> -	spin_unlock_irqrestore(&rcp->lock, flags);
> -}
> -
> -static void check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
> -{
> -	long delta;
> -
> -	delta = get_seconds() - rcp->gp_check;
> -	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0L) {
> -
> -		/* We haven't checked in, so go dump stack. */
> -
> -		print_cpu_stall(rcp);
> -
> -	} else {
> -		if (!cpus_empty(rcp->cpumask) && delta >= 2L) {
> -			/* They had two seconds to dump stack, so complain. */
> -			print_other_cpu_stall(rcp);
> -		}
> -	}
> -}
> -
> -#else /* #ifdef CONFIG_DEBUG_RCU_STALL */
> -
> -static inline void record_gp_check_time(struct rcu_ctrlblk *rcp)
> -{
> -}
> -
> -static inline void
> -check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
> -{
> -}
> -
> -#endif /* #else #ifdef CONFIG_DEBUG_RCU_STALL */
> -
>  /*
>   * Register a new batch of callbacks, and start it up if there is currently no
>   * active batch and the batch to be registered has not already occurred.
> @@ -381,7 +384,7 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
>  	if (rcp->cur != rcp->pending &&
>  			rcp->completed == rcp->cur) {
>  		rcp->cur++;
> -		record_gp_check_time(rcp);
> +		record_gp_stall_check_time(rcp);
>  
>  		/*
>  		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
> @@ -603,7 +606,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>  static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
>  {
>  	/* Check for CPU stalls, if enabled. */
> -	check_cpu_stall(rcp, rdp);
> +	check_cpu_stall(rcp);
>  
>  	if (rdp->nxtlist) {
>  		long completed_snap = ACCESS_ONCE(rcp->completed);
> @@ -769,6 +772,9 @@ static struct notifier_block __cpuinitdata rcu_nb = {
>   */
>  void __init __rcu_init(void)
>  {
> +#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> +	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
> +#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
>  	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
>  			(void *)(long)smp_processor_id());
>  	/* Register notifier for non-boot CPUs */
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 4e921a8..e0e0582 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -616,7 +616,7 @@ config RCU_TORTURE_TEST_RUNNABLE
>  	  Say N here if you want the RCU torture tests to start only
>  	  after being manually enabled via /proc.
>  
> -config RCU_CPU_STALL
> +config RCU_CPU_STALL_DETECTOR
>  	bool "Check for stalled CPUs delaying RCU grace periods"
>  	depends on CLASSIC_RCU
>  	default n

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
