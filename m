Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbYE1H1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbYE1H1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 03:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYE1H1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 03:27:41 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:35286 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYE1H1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 03:27:39 -0400
Date: Wed, 28 May 2008 00:26:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080528072618.GA6496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru> <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org> <20080527154001.GB14296@linux.vnet.ibm.com> <alpine.LFD.1.10.0805270908250.2958@woody.linux-foundation.org> <20080527170611.GD14296@linux.vnet.ibm.com> <20080528050150.GA19441@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528050150.GA19441@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:01:50PM -0700, Paul E. McKenney wrote:
> On Tue, May 27, 2008 at 10:06:11AM -0700, Paul E. McKenney wrote:
> > On Tue, May 27, 2008 at 09:11:33AM -0700, Linus Torvalds wrote:
> > > On Tue, 27 May 2008, Paul E. McKenney wrote:
> > > > 
> > > > But this will only help until preemptible spinlocks arrive, right?
> > > 
> > > I don't think we will ever have preemptible spinlocks.
> > > 
> > > If you preempt spinlocks, you have serious issues with contention and 
> > > priority inversion etc, and you basically need to turn them into sleeping 
> > > mutexes. So now you also need to do interrupts as sleepable threads etc 
> > > etc.
> > 
> > Indeed, all of these are required in that case.
> > 
> > > And it would break the existing non-preempt RCU usage anyway.
> > 
> > Yes, preemptable spinlocks cannot work without preemptable RCU.
> > 
> > > Yeah, maybe the RT people try to do that, but quite frankly, it is insane. 
> > > Spinlocks are *different* from sleeping locks, for a damn good reason.
> > 
> > Well, I guess I never claimed to be sane...
> > 
> > Anyway, will look at a preemptable RCU that waits for preempt-disable
> > sections of code.
> 
> And here is a just-now hacked up patch.  Untested, probably fails to compile.
> Just kicked off a light test run, will let you know how it goes.

And it passes light testing on a 4-CPU x86 box.

							Thanx, Paul

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  include/linux/rcupreempt.h |   15 ++++++++-
>  kernel/Kconfig.preempt     |   15 +++++++++
>  kernel/rcupreempt.c        |   71 ++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 99 insertions(+), 2 deletions(-)
> 
> diff -urpNa -X dontdiff linux-2.6.26-rc3/include/linux/rcupreempt.h linux-2.6.26-rc3-rcu-gcwnp/include/linux/rcupreempt.h
> --- linux-2.6.26-rc3/include/linux/rcupreempt.h	2008-05-23 02:26:06.000000000 -0700
> +++ linux-2.6.26-rc3-rcu-gcwnp/include/linux/rcupreempt.h	2008-05-27 21:27:35.000000000 -0700
> @@ -40,7 +40,20 @@
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
>  
> -#define rcu_qsctr_inc(cpu)
> +struct rcu_dyntick_sched {
> +	int qs;
> +	int rcu_qs_snap;
> +};
> +
> +DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
> +
> +static inline void rcu_qsctr_inc(int cpu)
> +{
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	rdssp->qs++;
> +}
> +
>  #define rcu_bh_qsctr_inc(cpu)
>  #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
>  
> diff -urpNa -X dontdiff linux-2.6.26-rc3/kernel/Kconfig.preempt linux-2.6.26-rc3-rcu-gcwnp/kernel/Kconfig.preempt
> --- linux-2.6.26-rc3/kernel/Kconfig.preempt	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.26-rc3-rcu-gcwnp/kernel/Kconfig.preempt	2008-05-27 21:27:39.000000000 -0700
> @@ -77,3 +77,18 @@ config RCU_TRACE
>  
>  	  Say Y here if you want to enable RCU tracing
>  	  Say N if you are unsure.
> +
> +config PREEMPT_RCU_WAIT_PREEMPT_DISABLE
> +	bool "Cause preemptible RCU to wait for preempt_disable code"
> +	depends on PREEMPT_RCU
> +	default y
> +	help
> +	  This option causes preemptible RCU's grace periods to wait
> +	  on preempt_disable() code sections (such as spinlock critical
> +	  sections in CONFIG_PREEMPT kernels) as well as for RCU
> +	  read-side critical sections.  This preserves this semantic
> +	  from Classic RCU.  Longer term, explicit RCU read-side critical
> +	  sections need to be added.
> +
> +	  Say N here if you want strict RCU semantics.
> +	  Say Y if you are unsure.
> diff -urpNa -X dontdiff linux-2.6.26-rc3/kernel/rcupreempt.c linux-2.6.26-rc3-rcu-gcwnp/kernel/rcupreempt.c
> --- linux-2.6.26-rc3/kernel/rcupreempt.c	2008-05-23 02:26:07.000000000 -0700
> +++ linux-2.6.26-rc3-rcu-gcwnp/kernel/rcupreempt.c	2008-05-27 21:46:51.000000000 -0700
> @@ -123,6 +123,12 @@ enum rcu_try_flip_states {
>  	rcu_try_flip_waitzero_state,
>  
>  	/*
> +	 * Wait here for all CPUs to pass through a quiescent state, but
> +	 * only if CONFIG_PREEMPT_RCU_WAIT_PREEMPT_DISABLE.
> +	 */
> +	rcu_try_flip_waitqs_state,
> +
> +	/*
>  	 * Wait here for each of the other CPUs to execute a memory barrier.
>  	 * This is necessary to ensure that these other CPUs really have
>  	 * completed executing their RCU read-side critical sections, despite
> @@ -131,6 +137,14 @@ enum rcu_try_flip_states {
>  	rcu_try_flip_waitmb_state,
>  };
>  
> +/* Plumb the grace-period state machine based on Kconfig parameters. */
> +
> +#ifdef CONFIG_PREEMPT_RCU_WAIT_PREEMPT_DISABLE
> +#define rcu_try_flip_waitzero_next_state rcu_try_flip_waitqs_state
> +#else  /* #ifdef CONFIG_PREEMPT_RCU_WAIT_PREEMPT_DISABLE */
> +#define rcu_try_flip_waitzero_next_state rcu_try_flip_waitmb_state
> +#endif /* #else  #ifdef CONFIG_PREEMPT_RCU_WAIT_PREEMPT_DISABLE */
> +
>  struct rcu_ctrlblk {
>  	spinlock_t	fliplock;	/* Protect state-machine transitions. */
>  	long		completed;	/* Number of last completed batch. */
> @@ -413,6 +427,8 @@ static void __rcu_advance_callbacks(stru
>  	}
>  }
>  
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched);
> +
>  #ifdef CONFIG_NO_HZ
>  
>  DEFINE_PER_CPU(long, dynticks_progress_counter) = 1;
> @@ -619,6 +635,25 @@ rcu_try_flip_waitmb_needed(int cpu)
>  
>  #endif /* CONFIG_NO_HZ */
>  
> +#ifdef CONFIG_PREEMPT_RCU_WAIT_PREEMPT_DISABLE
> +
> +void rcu_try_flip_take_qs_snapshot(void)
> +{
> +	struct rcu_dyntick_sched *rdssp;
> +	int cpu;
> +
> +	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
> +		rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +		rdssp->rcu_qs_snap = rdssp->qs;
> +	}
> +}
> +
> +#else /* #ifdef CONFIG_PREEMPT_RCU_WAIT_PREEMPT_DISABLE */
> +
> +#define rcu_try_flip_take_qs_snapshot()
> +
> +#endif /* #else #ifdef CONFIG_PREEMPT_RCU_WAIT_PREEMPT_DISABLE */
> +
>  /*
>   * Get here when RCU is idle.  Decide whether we need to
>   * move out of idle state, and return non-zero if so.
> @@ -662,6 +697,13 @@ rcu_try_flip_idle(void)
>  		dyntick_save_progress_counter(cpu);
>  	}
>  
> +	/*
> +	 * And take quiescent-state snapshot if we are also to wait
> +	 * on preempt_disable() code sequences.
> +	 */
> +
> +	rcu_try_flip_take_qs_snapshot();
> +
>  	return 1;
>  }
>  
> @@ -731,6 +773,26 @@ rcu_try_flip_waitzero(void)
>  	return 1;
>  }
>  
> +static int
> +rcu_try_flip_waitqs(void)
> +{
> +	int cpu;
> +	struct rcu_dyntick_sched *rdssp;
> +
> +	/* RCU_TRACE_ME(rcupreempt_trace_try_flip_q1); */
> +	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
> +		rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +		if (rcu_try_flip_waitack_needed(cpu) &&
> +		    (rdssp->qs == rdssp->rcu_qs_snap)) {
> +			/* RCU_TRACE_ME(rcupreempt_trace_try_flip_qe1); */
> +			return 0;
> +		}
> +	}
> +
> +	/* RCU_TRACE_ME(rcupreempt_trace_try_flip_q2); */
> +	return 1;
> +}
> +
>  /*
>   * Wait for all CPUs to do their end-of-grace-period memory barrier.
>   * Return 0 once all CPUs have done so.
> @@ -775,7 +837,9 @@ static void rcu_try_flip(void)
>  
>  	/*
>  	 * Take the next transition(s) through the RCU grace-period
> -	 * flip-counter state machine.
> +	 * flip-counter state machine.  The _next_state transition
> +	 * is defined by the "plumbing" definitions following the
> +	 * rcu_try_flip_states enum.
>  	 */
>  
>  	switch (rcu_ctrlblk.rcu_try_flip_state) {
> @@ -792,6 +856,11 @@ static void rcu_try_flip(void)
>  	case rcu_try_flip_waitzero_state:
>  		if (rcu_try_flip_waitzero())
>  			rcu_ctrlblk.rcu_try_flip_state =
> +				rcu_try_flip_waitzero_next_state;
> +		break;
> +	case rcu_try_flip_waitqs_state:
> +		if (rcu_try_flip_waitqs())
> +			rcu_ctrlblk.rcu_try_flip_state =
>  				rcu_try_flip_waitmb_state;
>  		break;
>  	case rcu_try_flip_waitmb_state:
