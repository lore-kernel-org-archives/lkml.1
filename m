Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYHZSOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYHZSOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYHZSNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:13:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60123 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbYHZSNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:13:47 -0400
Date: Tue, 26 Aug 2008 11:13:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] state machine based rcu
Message-ID: <20080826181331.GF6656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48AD8969.7060900@colorfullife.com> <20080822190250.GH6744@linux.vnet.ibm.com> <48AFC751.2020806@colorfullife.com> <20080824170949.GG6851@linux.vnet.ibm.com> <20080826160838.GA11279@linux.vnet.ibm.com> <48B43B2C.20003@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B43B2C.20003@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 07:19:40PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> The big long test is over, so if you can send me a patch against some
>> Linus tree, I will see about testing your code.  Assuming someone else
>> doesn't jump on the machines first, that is...  :-/
>>   
> Cool.
> Attached is the latest patch I have, it should be stable and perform about 
> as good as the current code.

Could you provide me a diff against some Linus tree?  Or at least give
me the commit you are based on in tip/core/rcu?  The testing
infrastructure I have does not yet know about git trees.  :-(

> The only known regressions are:
> - a lack of a force_quiescent_state() implementation. Shouldn't matter 
> since no_hz cpus are bypassed.
> - the irq entry of no_hz cpus takes a global spinlock. For some test 
> setups, this will probably kill the performance.
>
> Which test do you intend to run?

I intend to run:

	modprobe rcutorture stat_interval=100 test_no_idle_hz

in parallel with a script that loops offlining and onlining CPUs one
at a time.  (Offline CPU 0, online it, offline CPU 1, online it, etc.)

> An oprofile with an opannotate asm file would be nice. Preferably with 
> inlined spinlocks - that would immediately show the hot spots.
>
> Do you have an opannotate output from your patch?

That I do not.  I should look into that.

							Thanx, Paul

> --
>    Manfred

> xxx From 1445cbb7b30b4c918ad9efd2997b0dae76ba7ace Mon Sep 17 00:00:00 2001
> xxx From: Manfred Spraul <manfred@colorfullife.com>
> Date: Fri, 22 Aug 2008 14:51:54 +0200
> Subject: [PATCH] kernel/rcustate.c: state machine based rcu implementation.
> 
> I've decided to move the state machine based rcu code into
> a separate file, that's simpler to maintain.
> Very few updates are needed outside the new files.
> The code contains a few new ideas for the "classic" rcu code:
> 
> Right now, each cpu locally decides what it does, the only
> global thing is the bitmap that keeps track of grace periods.
> What this grace period means is defined by the cpu: it's possible
> that some cpus interpret a grace period as the sign for
> calling the rcu callbacks, other cpus interpret it as the
> sign that they should stop accepting further call_rcu()
> calls and start waiting for the next grace period.
> 
> The patch adds a global state, now all cpus do the same thing.
> The system is either collecting pointers for the next grace
> period, or it's waiting for a grace period to complete.
> This helps, because both calls are different:
> - for collecting pointers, any context is acceptable.
> - for the end of the grace period, the call must be from
>   outside critical sections.
> 
> Each cpu compares it's own state with the global state.
> If they do not match, then it must do something.
> 
> Additionally, the patch removes the cpu bitmask:
> Since all cpus must do something and the only thing that
> is tested for is an empty bitmask, the bitmask can be replaced
> with an integer that counts the outstanding cpus.
> (right now, the bitmasks are still there, but just for debugging).
> 
> If needed, a slow path could reconstruct the bitmap on the fly.
> {for_each_online_cpu(i) if (rcu_pending(i) {do_something()} }
> 
> The code in kernel/rcustate.c also has a unified list for the
> dead structures of call_rcu(), call_rcu_sched() and call_rcu_bh():
> There is no need to treat the outstanding callbacks differently,
> thus one list is sufficient.
> 
> The patch is work in progress:
> - The counters could be made hierarchical for better scalability.
> - The counters could be replaced by atomic_t
> - The bitmaps could be removed.
> - The patch doesn't contain the new debug features in rcu classic.
> - The patch doesn't contain a force_quiescent_state() implementation.
> - The Kconfig file is probably incorrect.
> 
> I'm interested in test feedback: with qemu & 8 cpus, fedora boots
> into runlevel 3, logging in works.
> 
> The patch is against tip/rcu.
> ---
>  include/linux/hardirq.h    |   27 +-
>  include/linux/rcuclassic.h |    2 -
>  include/linux/rcucpumask.h |  154 +++++++
>  include/linux/rcupdate.h   |   19 +-
>  include/linux/rcupreempt.h |   14 -
>  include/linux/rcustate.h   |  199 +++++++++
>  init/Kconfig               |   12 +-
>  kernel/Makefile            |    1 +
>  kernel/rcuclassic.c        |   20 +-
>  kernel/rcucpumask.c        |  119 ++++++
>  kernel/rcupreempt.c        |    6 +-
>  kernel/rcustate.c          |  961 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/softirq.c           |    2 +-
>  13 files changed, 1501 insertions(+), 35 deletions(-)
>  create mode 100644 include/linux/rcucpumask.h
>  create mode 100644 include/linux/rcustate.h
>  create mode 100644 kernel/rcucpumask.c
>  create mode 100644 kernel/rcustate.c
> 
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 181006c..4c064a3 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -118,13 +118,13 @@ static inline void account_system_vtime(struct task_struct *tsk)
>  }
>  #endif
> 
> -#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
> -extern void rcu_irq_enter(void);
> -extern void rcu_irq_exit(void);
> +#ifdef CONFIG_NO_HZ
> +extern void rcu_irq_enter(int in_nmi);
> +extern void rcu_irq_exit(int in_nmi);
>  #else
> -# define rcu_irq_enter() do { } while (0)
> -# define rcu_irq_exit() do { } while (0)
> -#endif /* CONFIG_PREEMPT_RCU */
> +# define rcu_irq_enter(in_nmi) do { } while (0)
> +# define rcu_irq_exit(in_nmi) do { } while (0)
> +#endif /* CONFIG_NO_HZ */
> 
>  /*
>   * It is safe to do non-atomic ops on ->hardirq_context,
> @@ -132,14 +132,17 @@ extern void rcu_irq_exit(void);
>   * always balanced, so the interrupted value of ->hardirq_context
>   * will always be restored.
>   */
> -#define __irq_enter()					\
> +#define ____irq_enter(in_nmi)				\
>  	do {						\
> -		rcu_irq_enter();			\
> +		rcu_irq_enter(in_nmi);			\
>  		account_system_vtime(current);		\
>  		add_preempt_count(HARDIRQ_OFFSET);	\
>  		trace_hardirq_enter();			\
>  	} while (0)
> 
> +#define __irq_enter()	____irq_enter(0)
> +#define __irq_exit()	____irq_exit(0)
> +
>  /*
>   * Enter irq context (on NO_HZ, update jiffies):
>   */
> @@ -148,12 +151,12 @@ extern void irq_enter(void);
>  /*
>   * Exit irq context without processing softirqs:
>   */
> -#define __irq_exit()					\
> +#define ____irq_exit(in_nmi)				\
>  	do {						\
>  		trace_hardirq_exit();			\
>  		account_system_vtime(current);		\
>  		sub_preempt_count(HARDIRQ_OFFSET);	\
> -		rcu_irq_exit();				\
> +		rcu_irq_exit(in_nmi);			\
>  	} while (0)
> 
>  /*
> @@ -161,7 +164,7 @@ extern void irq_enter(void);
>   */
>  extern void irq_exit(void);
> 
> -#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
> -#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
> +#define nmi_enter()		do { lockdep_off(); ____irq_enter(1); } while (0)
> +#define nmi_exit()		do { ____irq_exit(1); lockdep_on(); } while (0)
> 
>  #endif /* LINUX_HARDIRQ_H */
> diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> index 1658995..fc3047f 100644
> --- a/include/linux/rcuclassic.h
> +++ b/include/linux/rcuclassic.h
> @@ -162,8 +162,6 @@ extern struct lockdep_map rcu_lock_map;
> 
>  #define __synchronize_sched() synchronize_rcu()
> 
> -#define call_rcu_sched(head, func) call_rcu(head, func)
> -
>  extern void __rcu_init(void);
>  #define rcu_init_sched()	do { } while (0)
>  extern void rcu_check_callbacks(int cpu, int user);
> diff --git a/include/linux/rcucpumask.h b/include/linux/rcucpumask.h
> new file mode 100644
> index 0000000..0a650dd
> --- /dev/null
> +++ b/include/linux/rcucpumask.h
> @@ -0,0 +1,154 @@
> +/*
> + * cpu mask with integrated locking, intended for rcu
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
> + *
> + */
> +
> +#ifndef __LINUX_RCUCPUMASK_H
> +#define __LINUX_RCUCPUMASK_H
> +
> +#include <linux/spinlock.h>
> +#include <linux/cpumask.h>
> +
> +#define RCUCPUMASK_CPULIMIT	512
> +
> +#if (NR_CPUS > RCUCPUMASK_CPULIMIT)
> +
> +Bla Bla Bla
> +
> +#elif (NR_CPUS > 1)
> +
> +/*
> + * cpu bitmask:
> + * "normal" implementation, single spinlock.
> + */
> +
> +#define RCUCPUMASK_FLAT 1
> +
> +struct rcu_cpumask {
> +	spinlock_t lock;
> +
> +	/* number of cpus that are tracked by rcu */
> +	int cpus_total;
> +
> +	/* number of cpus that are still unresolved */
> +	int cpus_open;
> +
> +	int state ____cacheline_internodealigned_in_smp;
> +
> +	/* debug only: two bitmaps to double check the counters */
> +	cpumask_t mask_cpu_total ____cacheline_internodealigned_in_smp;
> +	cpumask_t mask_cpu_open;
> +} ____cacheline_internodealigned_in_smp;
> +
> +#define __RCU_CPUMASK_INIT(ptr) { .lock = __SPIN_LOCK_UNLOCKED(&(ptr)->lock) }
> +
> +/**
> + * rcu_cpumask_init(rcm, new_state) - initialize cpu mask with all live cpus.
> + * @rcm: rcu cpumask pointer.
> + * @new_state: new global state of the state machine
> + *
> + * This function sets the cpu bits for all cpus that might read pointers
> + * to rcu protected structures.
> + */
> +extern void rcu_cpumask_init(struct rcu_cpumask *rcm, int newstate, int setupcpus);
> +
> +/**
> + * rcu_cpumask_clear_and_test(rcm, cpu) - remove one cpu from cpumask
> + * @rcm: rcu cpumask pointer.
> + * @cpu: cpu to remove
> + *
> + * This function clears the bit for the given @cpu from the cpu mask.
> + * If no other bits are set, then the function returns 1, otherwise 0.
> + */
> +extern int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu);
> +
> +/**
> + * rcu_cpumask_addcpu(rcm, cpu) - list a cpu as important for rcu
> + * @rcm: rcu cpumask pointer.
> + * @cpu: cpu to remove
> + *
> + * This function adds the given cpu to the list of cpus that might access
> + * rcu related structures.
> + * The function return the current state, i.e. the state for which the cpu
> + * doesn't need to do anything.
> + */
> +extern int rcu_cpumask_addcpu(struct rcu_cpumask *rcm, int cpu);
> +
> +/**
> + * rcu_cpumask_removecpu(rcm, cpu) - remove a cpu from cpu list.
> + * @rcm: rcu cpumask pointer.
> + * @cpu: cpu to remove
> + *
> + * The function removes the given @cpu from the list of rcu related cpus.
> + * A cpu that is not listed must neither call call_rcu() nor access any
> + * rcu protected structures.
> + *
> + * The function returns the state for which the cpu is still listed,
> + * i.e. the cpu must do the work for that state.
> + */
> +extern int rcu_cpumask_removecpu(struct rcu_cpumask *rcm, int cpu);
> +
> +#else /* NR_CPUS == 1 */
> +
> +/*
> + * cpu bitmask: uniprocessor optimized.
> + * - there is just one cpu, it's always online.
> + * - clear_and_test always clears the only bit that could be set,
> + *   thus it always returns 1.
> + * Conclusion: No datastorage at all needed.
> + */
> +
> +struct rcu_cpumask {
> +	int state;
> +};
> +
> +#define __RCU_CPUMASK_INIT(ptr) { .state = 0 }
> +
> +static inline void rcu_cpumask_init(struct rcu_cpumask *rcm, int newstate, int setupcpus)
> +{
> +	rcm->state = newstate;
> +}
> +static inline int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu)
> +{
> +	return 1;
> +}
> +static inline int rcu_cpumask_addcpu(struct rcu_cpumask *rcm, int cpu)
> +{
> +	return rcm->state;
> +}
> +
> +static inline int rcu_cpumask_removecpu(struct rcu_cpumask *rcm, int cpu)
> +{
> +	return rcm->state;
> +}
> +
> +#endif /* NR_CPUS == 1 */
> +
> +/**
> + * rcu_cpumask_getstate(rcm) - retrieve the current state
> + * @rcm: rcu cpumask pointer.
> + *
> + * This function returns the current state from the cpu mask.
> + */
> +static inline int rcu_cpumask_getstate(struct rcu_cpumask *rcm)
> +{
> +	return rcm->state;
> +}
> +
> +#endif /* __LINUX_RCUCPUMASK_H */
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index e8b4039..b75035c 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -52,7 +52,9 @@ struct rcu_head {
>  	void (*func)(struct rcu_head *head);
>  };
> 
> -#ifdef CONFIG_CLASSIC_RCU
> +#ifdef CONFIG_STATE_RCU
> +#include <linux/rcustate.h>
> +#elif CONFIG_CLASSIC_RCU
>  #include <linux/rcuclassic.h>
>  #else /* #ifdef CONFIG_CLASSIC_RCU */
>  #include <linux/rcupreempt.h>
> @@ -243,6 +245,21 @@ extern void call_rcu(struct rcu_head *head,
>  extern void call_rcu_bh(struct rcu_head *head,
>  			void (*func)(struct rcu_head *head));
> 
> +/**
> + * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual update function to be invoked after the grace period
> + *
> + * The update function will be invoked some time after a full
> + * synchronize_sched()-style grace period elapses, in other words after
> + * all currently executing preempt-disabled sections of code (including
> + * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
> + * completed.
> + */
> +extern void call_rcu_sched(struct rcu_head *head,
> +			   void (*func)(struct rcu_head *head));
> +
> +
>  /* Exported common interfaces */
>  extern void synchronize_rcu(void);
>  extern void rcu_barrier(void);
> diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> index 3e05c09..bef8562 100644
> --- a/include/linux/rcupreempt.h
> +++ b/include/linux/rcupreempt.h
> @@ -65,20 +65,6 @@ static inline void rcu_qsctr_inc(int cpu)
>   */
>  #define call_rcu_bh	 	call_rcu
> 
> -/**
> - * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
> - * @head: structure to be used for queueing the RCU updates.
> - * @func: actual update function to be invoked after the grace period
> - *
> - * The update function will be invoked some time after a full
> - * synchronize_sched()-style grace period elapses, in other words after
> - * all currently executing preempt-disabled sections of code (including
> - * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
> - * completed.
> - */
> -extern void call_rcu_sched(struct rcu_head *head,
> -			   void (*func)(struct rcu_head *head));
> -
>  extern void __rcu_read_lock(void)	__acquires(RCU);
>  extern void __rcu_read_unlock(void)	__releases(RCU);
>  extern int rcu_pending(int cpu);
> diff --git a/include/linux/rcustate.h b/include/linux/rcustate.h
> new file mode 100644
> index 0000000..32557d1
> --- /dev/null
> +++ b/include/linux/rcustate.h
> @@ -0,0 +1,199 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion (classic version)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright IBM Corporation, 2001
> + *
> + * Author: Dipankar Sarma <dipankar@in.ibm.com>
> + *
> + * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
> + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> + * Papers:
> + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		Documentation/RCU
> + *
> + * Rewrite based on a global state machine
> + * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
> + */
> +
> +#ifndef __LINUX_RCUCLASSIC_H
> +#define __LINUX_RCUCLASSIC_H
> +
> +#include <linux/cache.h>
> +#include <linux/spinlock.h>
> +#include <linux/threads.h>
> +#include <linux/percpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/seqlock.h>
> +#include <linux/rcucpumask.h>
> +
> +/*
> + * global state machine:
> + * - each cpu regularly check the global state and compares it with it's own local state.
> + * - if both state do not match, then the cpus do the required work and afterwards
> + *   - update their local state
> + *   - clear their bit in the cpu bitmask.
> + * The state machine is protected by the protocol:
> + * The state can only change when all cpus have completed the current stage, thus
> + * random changes cannot happen.
> + * The only exception is the change from RCU_STATE_DESTROY to RCU_STATE_DESTROY_AND_COLLECT,
> + * but this change doesn't matter, because RCU_STATE_DESTROY is a subset of
> + * RCU_STATE_DESTROY_AND_COLLECT.
> + *
> + * The state is stored in the rcu_cpumask structure.
> + */
> +
> +/* RCU_STATE_DESTROY:
> + * call callbacks that were registered by call_rcu for the objects in rcu_cpu_state.old
> + */
> +#define RCU_STATE_DESTROY		1
> +/* RCU_STATE_DESTROY_AND_COLLECT:
> + * - call callbacks that were registered by call_rcu for the objects in rcu_cpu_state.old
> + * - move the objects from rcu_cpu_state.new to rcu_cpu_state.new
> + */
> +#define RCU_STATE_DESTROY_AND_COLLECT	2
> +/* RCU_STATE_GRACE
> + * - wait for a quiescent state
> + */
> +#define RCU_STATE_GRACE			3
> +
> +struct rcu_global_state {
> +	seqlock_t		lock;
> +	int			start_immediately;
> +	long			completed;
> +	struct rcu_cpumask	cpus;
> +} ____cacheline_internodealigned_in_smp;
> +
> +struct rcu_cpu_state {
> +	int state;
> +
> +	int mode;
> +	int count;
> +	/* new objects, directly from call_rcu().
> +	 * The list are length-based, not NULL-terminated.
> +	 */
> +	struct rcu_head *new;	/* new objects */
> +	struct rcu_head **newtail;
> +	long            newqlen; 	 /* # of queued callbacks */
> +
> +	unsigned long	timeout;
> +
> +	/* objects that are in rcu grace processing. The actual
> +	* state depends on rcu_cpumask_getstate(&rgs->cpus);
> +	 */
> +	struct rcu_head *old;
> +	struct rcu_head **oldtail;
> +	long            oldqlen;
> +
> +	/*
> +	 * quiescent state looking:
> +	 * When the cpu sees RCU_STATE_DESTROY_AND_COLLECT, it clears looking.
> +	 * When the cpu sees RCU_STATE_GRACE, it sets looking and clears
> +	 * quiet.
> +	 * If looking and quiet are both set, then there was a grace period,
> +	 * even if the state machine is called from non-idle context.
> +	 */
> +	int quiet;
> +	int looking;
> +};
> +
> +/* Note: only one structure for _bh and _normal. */
> +struct rcu_cpu_dead {
> +	/*
> +	 * objects that are scheduled for immediate call of
> +	 * ->func().
> +	 */
> +	struct rcu_head *dead;
> +	struct rcu_head **deadtail;
> +	long		deadqlen;
> +
> +	long		batchcount;
> +};
> +
> +DECLARE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_normal);
> +DECLARE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_bh);
> +DECLARE_PER_CPU(struct rcu_cpu_dead, rcu_cpudata_dead);
> +
> +extern long rcu_batches_completed(void);
> +extern long rcu_batches_completed_bh(void);
> +
> +extern int rcu_pending(int cpu);
> +extern int rcu_needs_cpu(int cpu);
> +
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +extern struct lockdep_map rcu_lock_map;
> +# define rcu_read_acquire()	\
> +			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
> +# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
> +#else
> +# define rcu_read_acquire()	do { } while (0)
> +# define rcu_read_release()	do { } while (0)
> +#endif
> +
> +#define __rcu_read_lock() \
> +	do { \
> +		preempt_disable(); \
> +		__acquire(RCU); \
> +		rcu_read_acquire(); \
> +	} while (0)
> +#define __rcu_read_unlock() \
> +	do { \
> +		rcu_read_release(); \
> +		__release(RCU); \
> +		preempt_enable(); \
> +	} while (0)
> +#define __rcu_read_lock_bh() \
> +	do { \
> +		local_bh_disable(); \
> +		__acquire(RCU_BH); \
> +		rcu_read_acquire(); \
> +	} while (0)
> +#define __rcu_read_unlock_bh() \
> +	do { \
> +		rcu_read_release(); \
> +		__release(RCU_BH); \
> +		local_bh_enable(); \
> +	} while (0)
> +
> +extern void __rcu_init(void);
> +#define rcu_init_sched()	do { } while (0)
> +
> +extern void __synchronize_sched(void);
> +extern void rcu_check_callbacks(int cpu, int user);
> +
> +#ifdef CONFIG_NO_HZ
> +extern void rcu_enter_nohz(void);
> +extern void rcu_exit_nohz(void);
> +#else /* CONFIG_NO_HZ */
> +#define rcu_enter_nohz()	do { } while (0)
> +#define rcu_exit_nohz()		do { } while (0)
> +#endif /* CONFIG_NO_HZ */
> +
> +static inline void rcu_qsctr_inc(int cpu)
> +{
> +	per_cpu(rcu_cpudata_normal, cpu).quiet = 1;
> +	per_cpu(rcu_cpudata_bh, cpu).quiet = 1;
> +}
> +
> +static inline void rcu_bh_qsctr_inc(int cpu)
> +{
> +	per_cpu(rcu_cpudata_bh, cpu).quiet = 1;
> +}
> +
> +#endif /* __LINUX_RCUCLASSIC_H */
> diff --git a/init/Kconfig b/init/Kconfig
> index b678803..faa7bba 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -914,10 +914,20 @@ source "block/Kconfig"
>  config PREEMPT_NOTIFIERS
>  	bool
> 
> +config STATE_RCU
> +	bool
> +	default y
> +	help
> +	  This option selects a state machine based RCU implementation.
> +	  It's a replacement for the "classic" rcu implementation that
> +	  aims simpler code and better scalability.
> +	  If unsure, say N. 
> +
>  config CLASSIC_RCU
> -	def_bool !PREEMPT_RCU
> +	def_bool !PREEMPT_RCU && !STATE_RCU
>  	help
>  	  This option selects the classic RCU implementation that is
>  	  designed for best read-side performance on non-realtime
>  	  systems.  Classic RCU is the default.  Note that the
>  	  PREEMPT_RCU symbol is used to select/deselect this option.
> +
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 4e1d7df..6bc9503 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>  obj-$(CONFIG_SECCOMP) += seccomp.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
>  obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
> +obj-$(CONFIG_STATE_RCU) += rcustate.o rcucpumask.o
>  obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
>  ifeq ($(CONFIG_PREEMPT_RCU),y)
>  obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index 01e761a..39fde99 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -215,6 +215,13 @@ void call_rcu_bh(struct rcu_head *head,
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_bh);
> 
> +void call_rcu_sched(struct rcu_head *head,
> +				void (*func)(struct rcu_head *rcu))
> +{
> +	call_rcu(head, func);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu_sched);
> +
>  /*
>   * Return the number of RCU batches processed thus far.  Useful
>   * for debug and statistics.
> @@ -710,7 +717,7 @@ void rcu_check_callbacks(int cpu, int user)
>  static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
>  						struct rcu_data *rdp)
>  {
> -	long flags;
> +	unsigned long flags;
> 
>  	spin_lock_irqsave(&rcp->lock, flags);
>  	memset(rdp, 0, sizeof(*rdp));
> @@ -757,6 +764,17 @@ static struct notifier_block __cpuinitdata rcu_nb = {
>  	.notifier_call	= rcu_cpu_notify,
>  };
> 
> +#ifdef CONFIG_NO_HZ
> +
> +void rcu_irq_enter(int in_nmi)
> +{
> +}
> +
> +void rcu_irq_exit(int in_nmi)
> +{
> +}
> +#endif
> +
>  /*
>   * Initializes rcu mechanism.  Assumed to be called early.
>   * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
> diff --git a/kernel/rcucpumask.c b/kernel/rcucpumask.c
> new file mode 100644
> index 0000000..85ceb1e
> --- /dev/null
> +++ b/kernel/rcucpumask.c
> @@ -0,0 +1,119 @@
> +/*
> + * Scalable cpu mask for rcu.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
> + *
> + */
> +#include <linux/rcucpumask.h>
> +#include <linux/bug.h>
> +
> +#ifdef RCUCPUMASK_FLAT
> +
> +void rcu_cpumask_init(struct rcu_cpumask *rcm, int newstate, int setupcpus)
> +{
> +	BUG_ON(!irqs_disabled());
> +
> +	spin_lock(&rcm->lock);
> +	rcm->state = newstate;
> +
> +	if (setupcpus) {
> +		rcm->cpus_open = rcm->cpus_total;
> +
> +		bitmap_copy(cpus_addr(rcm->mask_cpu_open), cpus_addr(rcm->mask_cpu_total), NR_CPUS);
> +	} else {
> +		rcm->cpus_open = 0;
> +		cpus_clear(rcm->mask_cpu_open);
> +	}
> +	spin_unlock(&rcm->lock);
> +}
> +
> +int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu)
> +{
> +	int ret;
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	spin_lock(&rcm->lock);
> +
> +	BUG_ON(!cpu_isset(cpu, rcm->mask_cpu_open));
> +	cpu_clear(cpu, rcm->mask_cpu_open);
> +
> +	rcm->cpus_open--;
> +if (rcm->cpus_open < 0) {
> +	printk(KERN_ERR" rcm %p cpu %d state %d.\n", rcm, cpu, rcm->state);
> +for(;;);
> +}
> +	ret = rcm->cpus_open;
> +	if (ret == 0) {
> +if (!cpus_empty(rcm->mask_cpu_open)) {
> +	printk(KERN_ERR" rcm %p cpu %d state %d.\n", rcm, cpu, rcm->state);
> +for(;;);
> +}
> +	}
> +	
> +	spin_unlock(&rcm->lock);
> +
> +	return !ret;
> +}
> +
> +int rcu_cpumask_addcpu(struct rcu_cpumask *rcm, int cpu)
> +{
> +	int ret;
> +	unsigned long flags;
> +
> +	/*
> +	 * This function is called both during early bootup (irqs disabled)
> +	 * and during "normal" CPU_UP notifiers (irqs enabled).
> +	 */
> +	spin_lock_irqsave(&rcm->lock, flags);
> +
> +	BUG_ON(cpu_isset(cpu, rcm->mask_cpu_total));
> +	cpu_set(cpu, rcm->mask_cpu_total);
> +
> +	rcm->cpus_total++;
> +	ret = rcm->state;
> +	
> +	spin_unlock_irqrestore(&rcm->lock, flags);
> +
> +	return ret;
> +}
> +
> +int rcu_cpumask_removecpu(struct rcu_cpumask *rcm, int cpu)
> +{
> +	int ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rcm->lock, flags);
> +
> +	BUG_ON(!cpu_isset(cpu, rcm->mask_cpu_total));
> +	cpu_clear(cpu, rcm->mask_cpu_total);
> +
> +	rcm->cpus_total--;
> +	ret = rcm->state;
> +	
> +	spin_unlock_irqrestore(&rcm->lock, flags);
> +
> +	return ret;
> +}
> +
> +#endif /* RCUCPUMASK_FLAT */
> +
> +#ifdef RCUCPUMASK_HIERARCHICAL
> +
> +bla
> +
> +#endif /* RCUCPUMASK_HIERARCHICAL */
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index ca4bbbe..ab18347 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -434,13 +434,13 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
>  static DEFINE_PER_CPU(int, rcu_update_flag);
> 
>  /**
> - * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
> + * __rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
>   *
>   * If the CPU was idle with dynamic ticks active, this updates the
>   * rcu_dyntick_sched.dynticks to let the RCU handling know that the
>   * CPU is active.
>   */
> -void rcu_irq_enter(void)
> +void __rcu_irq_enter(int in_nmi)
>  {
>  	int cpu = smp_processor_id();
>  	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> @@ -510,7 +510,7 @@ void rcu_irq_enter(void)
>   * rcu_dyntick_sched.dynticks to put let the RCU handling be
>   * aware that the CPU is going back to idle with no ticks.
>   */
> -void rcu_irq_exit(void)
> +void __rcu_irq_exit(int in_nmi)
>  {
>  	int cpu = smp_processor_id();
>  	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> diff --git a/kernel/rcustate.c b/kernel/rcustate.c
> new file mode 100644
> index 0000000..76ee1fe
> --- /dev/null
> +++ b/kernel/rcustate.c
> @@ -0,0 +1,961 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright IBM Corporation, 2001
> + *
> + * Authors: Dipankar Sarma <dipankar@in.ibm.com>
> + *	    Manfred Spraul <manfred@colorfullife.com>
> + *
> + * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
> + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> + * Papers:
> + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		Documentation/RCU
> + *
> + * Rewrite based on a global state machine
> + * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
> + *
> + */
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/spinlock.h>
> +#include <linux/smp.h>
> +#include <linux/rcupdate.h>
> +#include <linux/interrupt.h>
> +#include <linux/sched.h>
> +#include <asm/atomic.h>
> +#include <linux/bitops.h>
> +#include <linux/module.h>
> +#include <linux/completion.h>
> +#include <linux/moduleparam.h>
> +#include <linux/percpu.h>
> +#include <linux/notifier.h>
> +#include <linux/cpu.h>
> +#include <linux/mutex.h>
> +#include <linux/time.h>
> +
> +
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +static struct lock_class_key rcu_lock_key;
> +struct lockdep_map rcu_lock_map =
> +	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
> +EXPORT_SYMBOL_GPL(rcu_lock_map);
> +#endif
> +
> +/* Definition for rcupdate control block. */
> +static struct rcu_global_state rcu_global_state_normal = {
> +	.lock = __SEQLOCK_UNLOCKED(&rcu_global_state_normal.lock),
> +	.start_immediately = 0,
> +	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_normal.cpus)
> +};
> +
> +static struct rcu_global_state rcu_global_state_bh = {
> +	.lock = __SEQLOCK_UNLOCKED(&rcu_global_state_bh.lock),
> +	.start_immediately = 0,
> +	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_bh.cpus)
> +};
> +
> +DEFINE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_normal) = { 0L };
> +DEFINE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_bh) = { 0L };
> +DEFINE_PER_CPU(struct rcu_cpu_dead, rcu_cpudata_dead) = { 0L };
> +
> +#ifdef CONFIG_NO_HZ
> +/*
> + * NMI Handling:
> + * NMIs on nohz cpus must be handled seperately:
> + * nohz cpus that are outside interrupt are ignored for rcu
> + * grace period checking. For normal interrupt, the cpus
> + * are added back on the fly.
> + * This is impossible for NMIs, NMIs can't take spinlocks.
> + * Therefore a different approach is taken:
> + * On NMI entry, a counter is increased and on exit decreased
> + * again.
> + * call_rcu_sched() polls all cpus and checks that this count is 0.
> + *
> + * Since there is no spinlock(), memory barriers are needed.
> + */
> +static atomic_t rcu_nmi_counter = ATOMIC_INIT(0);
> +
> +DEFINE_PER_CPU(int , rcu_nmi_counter_percpu) = { 0L };
> +
> +#endif
> +
> +
> +/*
> + * rcu_cpumode:
> + * -1:
> + * "normal" rcu behavior: the scheduler and the timer interrupt
> + * check for grace periods, read side critical sections are permitted
> + * everywhere.
> + *
> + * 0:
> + * This cpu is sitting in the idle thread, with disabled hz timer.
> + *
> + * > 0:
> + * The cpu is in an interrupt that interrupted a nohz idle thread.
> + */
> +
> +#define RCU_CPUMODE_INVALID	-2
> +#define RCU_CPUMODE_DELAYED	-1
> +DEFINE_PER_CPU(int, rcu_cpumode) = { 0L };
> +
> +int qlowmark = 100;
> +
> +long rcu_batches_completed(void)
> +{
> +	return rcu_global_state_normal.completed;
> +}
> +
> +long rcu_batches_completed_bh(void)
> +{
> +	return rcu_global_state_normal.completed;
> +}
> +
> +/**
> + * rcu_state_startcycle - start the next rcu cycle
> + * @rgs: global rcu state
> + *
> + * The function starts the next rcu cycle, either immediately or
> + * by setting rgs->start_immediately.
> + */
> +static void rcu_state_startcycle(struct rcu_global_state *rgs)
> +{
> +	unsigned seq;
> +	int do_real_start;
> +
> +	BUG_ON(!irqs_disabled());
> +	do {
> +		seq = read_seqbegin(&rgs->lock);
> +		if (rgs->start_immediately == 0) {
> +			do_real_start = 1;
> +		} else {
> +			do_real_start = 0;
> +			BUG_ON(rcu_cpumask_getstate(&rgs->cpus) == RCU_STATE_DESTROY);
> +		}
> +	} while (read_seqretry(&rgs->lock, seq));
> +
> +	if (do_real_start) {
> +		write_seqlock(&rgs->lock);
> +		switch(rcu_cpumask_getstate(&rgs->cpus)) {
> +		case RCU_STATE_DESTROY_AND_COLLECT:
> +		case RCU_STATE_GRACE:
> +			rgs->start_immediately = 1;
> +			break;
> +		case RCU_STATE_DESTROY:
> +			rcu_cpumask_init(&rgs->cpus, RCU_STATE_DESTROY_AND_COLLECT, 1);
> +			BUG_ON(rgs->start_immediately);
> +			break;
> +		default:
> +			BUG();
> +		}
> +		write_sequnlock(&rgs->lock);
> +	}
> +}
> +
> +/*
> + * Delay that can occur for synchronize_rcu() callers
> + */
> +#define RCU_MAX_DELAY	(HZ/30+1)
> +
> +static void rcu_checkqlen(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int inc)
> +{
> +	BUG_ON(!irqs_disabled());
> +	if (unlikely(rcs->newqlen == 0)) {
> +		rcs->timeout = jiffies + RCU_MAX_DELAY;
> +	}
> +	if ((rcs->newqlen < qlowmark) && (rcs->newqlen+inc >= qlowmark))
> +		rcu_state_startcycle(rgs);
> +
> +	rcs->newqlen += inc;
> +
> +	/*
> +	 * This is not really a bug, it might happen when interrupt calls
> +	 * call_rcu() while the cpu is in nohz mode. see rcu_irq_exit
> +	 */
> +	WARN_ON( (rcs->newqlen >= qlowmark) && (rcu_cpumask_getstate(&rgs->cpus) == RCU_STATE_DESTROY));
> +}
> +
> +
> +static void __call_rcu(struct rcu_head *head, struct rcu_global_state *rgs,
> +		struct rcu_cpu_state *rcs)
> +{
> +	if (rcs->new == NULL) {
> +		rcs->new = head;
> +	} else {
> +		(*rcs->newtail) = head;
> +	}
> +	rcs->newtail = &head->next;
> +
> +	rcu_checkqlen(rgs, rcs, 1);
> +}
> +
> +void call_rcu_sched(struct rcu_head *head,
> +				void (*func)(struct rcu_head *rcu))
> +{
> +#if CONFIG_NO_HZ
> +	/*
> +	 * NMI interrupts are not included in rgs->cpus.
> +	 * Thus we must wait synchroneously until no NMI
> +	 * is running.
> +	 */
> +	/*
> +	 * make all rcu_assign statements visible to
> +	 * all cpus.
> +	 */
> +	smp_mb();
> +
> +	/* quick check: no nmi at all? */
> +	if (unlikely(atomic_read(&rcu_nmi_counter) > 0)) {
> +		int cpu;
> +
> +		/* slow check: check each cpu individually */
> +		for_each_online_cpu(cpu) {
> +
> +			/* loop while this cpu is in a nmi */
> +			while (per_cpu(rcu_nmi_counter_percpu, cpu) > 0) {
> +				cpu_relax();
> +			}
> +
> +			/* quick check: if noone is in an nmi, then we can exit
> +			 * immediately, without checking the remaining cpus.
> +			 */
> +			if (atomic_read(&rcu_nmi_counter) == 0)
> +				break;
> +
> +			cpu_relax();	
> +		}
> +	}
> +#endif
> +	call_rcu(head, func);
> +}
> +
> +EXPORT_SYMBOL_GPL(call_rcu_sched);
> +
> +/*
> + * Wait until all currently running preempt_disable() code segments
> + * (including hardware-irq-disable segments) complete.  Note that
> + * in -rt this does -not- necessarily result in all currently executing
> + * interrupt -handlers- having completed.
> + */
> +synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
> +EXPORT_SYMBOL_GPL(__synchronize_sched);
> +
> +
> +void call_rcu(struct rcu_head *head,
> +				void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long flags;
> +
> +	head->func = func;
> +	local_irq_save(flags);
> +	__call_rcu(head, &rcu_global_state_normal, &__get_cpu_var(rcu_cpudata_normal));
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu);
> +
> +void call_rcu_bh(struct rcu_head *head,
> +				void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long flags;
> +
> +	head->func = func;
> +	local_irq_save(flags);
> +	__call_rcu(head, &rcu_global_state_bh, &__get_cpu_var(rcu_cpudata_bh));
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu_bh);
> +
> +#define RCU_BATCH_MIN		100
> +#define	RCU_BATCH_INCFACTOR	2
> +#define RCU_BATCH_DECFACTOR	4
> +
> +static void rcu_move_and_raise(struct rcu_cpu_state *rcs, int do_raise)
> +{
> +	struct rcu_cpu_dead *rcd = &get_cpu_var(rcu_cpudata_dead);
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	/* update batch limit:
> +	 * - if there are still old entries when new entries are added:
> +	 *   double the batch count.
> +	 * - if there are no old entries: reduce it by 25%, but never below 100.
> +	 */
> +	if (rcd->deadqlen)
> +		rcd->batchcount = rcd->batchcount*RCU_BATCH_INCFACTOR;
> +	 else
> +		rcd->batchcount = rcd->batchcount-rcd->batchcount/RCU_BATCH_DECFACTOR;
> +	if (rcd->batchcount < RCU_BATCH_MIN)
> +		rcd->batchcount = RCU_BATCH_MIN;
> +
> +	if (rcs->old != NULL) {
> +		if (rcd->dead == NULL) {
> +			rcd->dead = rcs->old;
> +		} else {
> +			(*rcd->deadtail) = rcs->old;
> +		}
> +		rcd->deadtail = rcs->oldtail;
> +		rcd->deadqlen += rcs->oldqlen;
> +	}
> +
> +	rcs->old = NULL;
> +	rcs->oldtail = NULL;
> +	rcs->oldqlen = 0;
> +
> +	if (do_raise)
> +		raise_softirq(RCU_SOFTIRQ);
> +
> +	put_cpu_var(rcu_cpudata_dead);
> +}
> +
> +static void __rcu_state_machine(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs,
> +					int global_state, int is_quiet, int do_raise, int cpu)
> +{
> +	int inc_state;
> +	unsigned long flags;
> +
> +	/*
> +	 * Theoretically, this code should run under read_seqbegin().
> +	 * But: important chages (i.e. from COLLECT to GRACE,
> +	 * from GRACE to DESTROY) only happen when all cpus have completed
> +	 * their work. If rcu_cpumask_getstate(&rgs->cpus) != rcs->state, then we haven't completed
> +	 * our work yet. Thus such a change cannot happen.
> +	 * The only change that might happen is a change from RCU_STATE_DESTROY
> +	 * to RCU_STATE_DESTROY_AND_COLLECT. We'll notice that in the next
> +	 * round.
> +	 * no need for an mb() either - it simply doesn't matter.
> +	 * Actually: when rcu_state_startcycle() is called, then it's guaranteed
> +	 * that global_state and rcu_cpumask_getstate(&rgs->cpus) do not match...
> +	 */
> +	local_irq_save(flags);
> +	if (global_state == RCU_STATE_DESTROY && rcs->newqlen > 0 &&
> +		time_after(jiffies, rcs->timeout) && do_raise) {
> +		rcu_state_startcycle(rgs);
> +	}
> +
> +	inc_state = 0;
> +	if (global_state != rcs->state) {
> +		switch(global_state) {
> +		case RCU_STATE_DESTROY:
> +			rcs->state = RCU_STATE_DESTROY;
> +			rcu_move_and_raise(rcs, do_raise);
> +			break;
> +		case RCU_STATE_DESTROY_AND_COLLECT:
> +			rcs->state = RCU_STATE_DESTROY_AND_COLLECT;
> +			rcu_move_and_raise(rcs, do_raise);
> +			rcs->old = rcs->new;
> +			rcs->oldtail = rcs->newtail;
> +			rcs->oldqlen = rcs->newqlen;
> +			rcs->new = NULL;
> +			rcs->newtail = NULL;
> +			rcs->newqlen = 0;
> +			rcs->looking = 0;
> +			if (rcu_cpumask_clear_and_test(&rgs->cpus, cpu))
> +				inc_state = 1;
> +			break;
> +		case RCU_STATE_GRACE:
> +			if (is_quiet || (rcs->quiet && rcs->looking)) {
> +				rcs->state = RCU_STATE_GRACE;
> +				if (rcu_cpumask_clear_and_test(&rgs->cpus, cpu))
> +					inc_state = 1;
> +			}
> +			rcs->quiet = 0;
> +			rcs->looking = 1;
> +			break;
> +		default:
> +			BUG();
> +		}
> +	}
> +
> +	if (unlikely(inc_state)) {
> +		local_irq_save(flags);
> +		write_seqlock(&rgs->lock);
> +
> +		BUG_ON(rcu_cpumask_getstate(&rgs->cpus) != rcs->state);
> +		BUG_ON(global_state != rcu_cpumask_getstate(&rgs->cpus));
> +		/*
> +		 * advance the state machine:
> +		 * - from COLLECT to GRACE
> +		 * - from GRACE to DESTROY/COLLECT
> +		 */
> +		switch(rcu_cpumask_getstate(&rgs->cpus)) {
> +		case RCU_STATE_DESTROY_AND_COLLECT:
> +			rcu_cpumask_init(&rgs->cpus, RCU_STATE_GRACE, 1);
> +			break;
> +		case RCU_STATE_GRACE:
> +			rgs->completed++;
> +			if (rgs->start_immediately) {
> +				rcu_cpumask_init(&rgs->cpus, RCU_STATE_DESTROY_AND_COLLECT, 1);
> +			} else {
> +				rcu_cpumask_init(&rgs->cpus, RCU_STATE_DESTROY, 0);
> +			}
> +			rgs->start_immediately = 0;
> +			break;
> +		default:
> +			BUG();
> +		}
> +		write_sequnlock(&rgs->lock);
> +		local_irq_restore(flags);
> +	}
> +}
> +
> +static void rcu_state_machine(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int is_quiet, int cpu)
> +{
> +	int global_state = rcu_cpumask_getstate(&rgs->cpus);
> +
> +	/* gcc should not optimize away the local variable global_state... */
> +	barrier();
> +	__rcu_state_machine(rgs, rcs, global_state, is_quiet, 1, cpu);
> +}
> +
> +#if defined(CONFIG_HOTPLUG_CPU) || defined (CONFIG_NO_HZ)
> +
> +static void __rcu_remove_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int cpu)
> +{
> +	int global_state;
> +	unsigned seq;
> +
> +	BUG_ON(!irqs_disabled());
> +	/* task 1:
> +	 * Do the work that the cpu is still supposed to do.
> +	 * We rely on the lock inside the rcu_cpumask, that guarantees that
> +	 * we neither do too much nor too little.
> +	 * But do not raise the softirq, the caller is responsible handling
> +	 * the entries stil in the queues.
> +	 */
> +	global_state = rcu_cpumask_removecpu(&rgs->cpus, cpu);
> +
> +	/*
> +	 * ensure that we are not in the middle of updating
> +	 * rcu_cpumask_getstate(&rgs->cpus): otherwise __rcu_state_machine()
> +	 * would return with "nothing to do", although
> +	 * the cpu must do something.
> +	 */
> +	do {
> +		seq = read_seqbegin(&rgs->lock);
> +	} while (read_seqretry(&rgs->lock, seq));
> +
> +	__rcu_state_machine(rgs, rcs, global_state, 1, 0, cpu);
> +}
> +
> +#endif
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +/**
> + * rcu_bulk_add - bulk add new rcu objects.
> + * @rgs: global rcu state
> + * @rcs: cpu state
> + * @h: linked list of rcu objects.
> + *
> + * Must be called with enabled local interrupts
> + */
> +static void rcu_bulk_add(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, struct rcu_head *h, struct rcu_head **htail, int len)
> +{
> +
> +	BUG_ON(irqs_disabled());
> +
> +	if (len > 0) {
> +		local_irq_disable();
> +		if (rcs->new == NULL) {
> +			rcs->new = h;
> +		} else {
> +			(*rcs->newtail) = h;
> +		}
> +		rcs->newtail = htail;
> +
> +		rcu_checkqlen(rgs, rcs, len);
> +		local_irq_enable();
> +	}
> +}
> +
> +
> +static void __rcu_offline_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *this_rcs,
> +					struct rcu_cpu_state *other_rcs, int cpu)
> +{
> +	/*
> +	 * task 1: Do the work that the other cpu is still supposed to do.
> +	 */
> +	__rcu_remove_cpu(rgs, other_rcs, cpu);
> +	per_cpu(rcu_cpumode, cpu) = RCU_CPUMODE_INVALID;
> +
> +	/* task 2: move all entries from the new cpu into the lists of the current cpu.
> +	 * locking: The other cpu is dead, thus no locks are required.
> +	 *  Thus it's more or less a bulk call_rcu().
> +	 * For the sake of simplicity, all objects are treated as "new", even the objects
> +	 * that are already in old.
> +	 */
> +	rcu_bulk_add(rgs, this_rcs, other_rcs->new, other_rcs->newtail, other_rcs->newqlen);
> +	rcu_bulk_add(rgs, this_rcs, other_rcs->old, other_rcs->oldtail, other_rcs->oldqlen);
> +}
> +
> +static void rcu_offline_cpu(int cpu)
> +{
> +	struct rcu_cpu_state *this_rcs_normal = &get_cpu_var(rcu_cpudata_normal);
> +	struct rcu_cpu_state *this_rcs_bh = &get_cpu_var(rcu_cpudata_bh);
> +	struct rcu_cpu_dead *this_rcd, *other_rcd;
> +
> +	BUG_ON(irqs_disabled());
> +
> +	/* step 1: move new & old lists, clear cpu bitmask */
> +	__rcu_offline_cpu(&rcu_global_state_normal, this_rcs_normal,
> +					&per_cpu(rcu_cpudata_normal, cpu), cpu);
> +	__rcu_offline_cpu(&rcu_global_state_bh, this_rcs_bh,
> +					&per_cpu(rcu_cpudata_bh, cpu), cpu);
> +	put_cpu_var(rcu_cpudata_normal);
> +	put_cpu_var(rcu_cpudata_bh);
> +
> +	/* step 2: move dead list */
> +	this_rcd = &get_cpu_var(rcu_cpudata_dead);
> +	other_rcd = &per_cpu(rcu_cpudata_dead, cpu);
> +
> +	if (other_rcd->dead != NULL) {
> +		local_irq_disable();
> +		if (this_rcd->dead == NULL) {
> +			this_rcd->dead = other_rcd->dead;
> +		} else {
> +			(*this_rcd->deadtail) = other_rcd->dead;
> +		}
> +		this_rcd->deadtail = other_rcd->deadtail;
> +		this_rcd->deadqlen += other_rcd->deadqlen;
> +		local_irq_enable();
> +	}
> +
> +	put_cpu_var(rcu_cpudata_dead);
> +
> +	BUG_ON(rcu_needs_cpu(cpu));
> +}
> +
> +#else
> +
> +static void rcu_offline_cpu(int cpu)
> +{
> +}
> +
> +#endif
> +
> +static int __rcu_pending(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs)
> +{
> +	/*
> +	 * This cpu must do something for the state machine.
> +	 */
> +	if (rcu_cpumask_getstate(&rgs->cpus) != rcs->state)
> +		return 1;
> +	/*
> +	 * The state machine is stopped and the current
> +	 * cpu has outstanding rcu callbacks
> +	 */
> +	if (rcs->state == RCU_STATE_DESTROY && rcs->newqlen)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/**
> + * void rcu_pending(int cpu) - check for pending rcu related work.
> + * @cpu: cpu to check.
> + *
> + * Check to see if there is any immediate RCU-related work to be done
> + * by the current CPU, returning 1 if so.  This function is part of the
> + * RCU implementation; it is -not- an exported member of the RCU API.
> + *
> + * This function is inherently racy: If it returns 1, then there is something
> + * to do. If it return 0, then there was nothing to do. It's possible that
> + * by the time rcu_pending returns, there is now something to do.
> + *
> + */
> +int rcu_pending(int cpu)
> +{
> +	return __rcu_pending(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu)) ||
> +		__rcu_pending(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu));
> +}
> +
> +static int __rcu_needs_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs)
> +{
> +	if (rcs->new)
> +		return 1;
> +	if (rcs->old)
> +		return 1;
> +	return 0;
> +}
> +
> +/**
> + * void rcu_needs_cpu(cpu) - check for outstanding rcu work.
> + * @cpu: cpu to check.
> + *
> + * Check to see if any future RCU-related work will need to be done
> + * by @cpu, even if none need be done immediately, returning
> + * 1 if so.  This function is part of the RCU implementation; it is -not-
> + * an exported member of the RCU API.
> + *
> + * Locking only works properly if the function is called for the current
> + * cpu and with disabled local interupts. It's a prerequisite for
> + * rcu_nohz_enter() that rcu_needs_cpu() return 0. Local interupts must not
> + * be enabled in between, otherwise a softirq could call call_rcu().
> + *
> + * Note: rcu_needs_cpu() can be 0 (cpu not needed) even though rcu_pending()
> + * returns 1. This means that the outstanding work can be completed by either
> + * the CPU_DEAD callback or rcu_enter_nohz().
> + */
> +int rcu_needs_cpu(int cpu)
> +{
> +	int ret;
> +
> +	WARN_ON(!irqs_disabled());
> +
> +	ret  = __rcu_needs_cpu(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu)) ||
> +		__rcu_needs_cpu(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu)) ||
> +		(per_cpu(rcu_cpudata_dead, cpu).deadqlen > 0);
> +
> +	return ret;
> +}
> +
> +/**
> + * rcu_check_callback(cpu, user) - external entry point for grace checking
> + * @cpu: cpu id.
> + * @user: user space was interrupted.
> + *
> + * Top-level function driving RCU grace-period detection, normally
> + * invoked from the scheduler-clock interrupt.  This function simply
> + * increments counters that are read only from softirq by this same
> + * CPU, so there are no memory barriers required.
> + *
> + * This function can run with disabled local interrupts, thus all
> + * callees must use local_irq_save()
> + */
> +void rcu_check_callbacks(int cpu, int user)
> +{
> +	if (user ||
> +	    (idle_cpu(cpu) && !in_softirq() &&
> +				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> +
> +		/*
> +		 * Get here if this CPU took its interrupt from user
> +		 * mode or from the idle loop, and if this is not a
> +		 * nested interrupt.  In this case, the CPU is in
> +		 * a quiescent state, so count it.
> +		 *
> +		 */
> +		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 1, cpu);
> +		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 1, cpu);
> +
> +	} else if (!in_softirq()) {
> +
> +		/*
> +		 * Get here if this CPU did not take its interrupt from
> +		 * softirq, in other words, if it is not interrupting
> +		 * a rcu_bh read-side critical section.  This is an _bh
> +		 * critical section, so count it.
> +		 */
> +		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 0, cpu);
> +		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 1, cpu);
> +	} else {
> +		/*
> +		 * We are interrupting something. Nevertheless - check if we should collect
> +		 * rcu objects. This can be done from arbitrary context.
> +		 */
> +		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 0, cpu);
> +		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 0, cpu);
> +	}
> +}
> +
> +/*
> + * Invoke the completed RCU callbacks.
> + */
> +static void rcu_do_batch(struct rcu_cpu_dead *rcd)
> +{
> +	struct rcu_head *list;
> +	int i, count;
> +
> +	if (!rcd->deadqlen)
> +		return;
> +
> +	/* step 1: pull up to rcs->batchcount objects */
> +	BUG_ON(irqs_disabled());
> +	local_irq_disable();
> +
> +	if (rcd->deadqlen > rcd->batchcount) {
> +		struct rcu_head *walk;
> +
> +		list = rcd->dead;
> +		count = rcd->batchcount;
> +
> +		walk = rcd->dead;
> +		for (i=0;i<count;i++)
> +			walk = walk->next;
> +		rcd->dead = walk;
> +
> +	} else {
> +		list = rcd->dead;
> +		count = rcd->deadqlen;
> +
> +		rcd->dead = NULL;
> +		rcd->deadtail = NULL;
> +	}
> +	rcd->deadqlen -= count;
> +	BUG_ON(rcd->deadqlen < 0);
> +
> +	local_irq_enable();
> +
> +	/* step 2: call the rcu callbacks */
> +
> +	for (i=0;i<count;i++) {
> +		struct rcu_head *next;
> +
> +		next = list->next;
> +		prefetch(next);
> +		list->func(list);
> +		list = next;
> +	}
> +
> +	/* step 3: if still entries left, raise the softirq again */
> +	if (rcd->deadqlen)
> +		raise_softirq(RCU_SOFTIRQ);
> +}
> +
> +static void rcu_process_callbacks(struct softirq_action *unused)
> +{
> +	rcu_do_batch(&get_cpu_var(rcu_cpudata_dead));
> +	put_cpu_var(rcu_cpudata_dead);
> +}
> +
> +static void __rcu_add_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int cpu)
> +{
> +	rcs->state = rcu_cpumask_addcpu(&rgs->cpus, cpu);
> +}
> +
> +#ifdef CONFIG_NO_HZ
> +
> +void rcu_enter_nohz(void)
> +{
> +	int cpu = smp_processor_id();
> +	int *pmode;
> +
> +	/*
> +	 * call_rcu() between rcu_needs_cpu and rcu_enter_nohz() are
> +	 * not permitted.
> +	 * Thus both must be called with disabled local interrupts,
> +	 * without enabling the interrupts in between.
> +	 *
> +	 * Note: disabling interrupts only prevents call_rcu().
> +	 * it can obviously happen that another cpu forwards
> +	 * the state machine. That doesn't hurt: __rcu_remove_cpu()
> +	 * the the work that we need to do.
> +	 */
> +	BUG_ON(!irqs_disabled());
> +
> +	pmode = &get_cpu_var(rcu_cpumode);
> +	BUG_ON(*pmode != RCU_CPUMODE_DELAYED);
> +	*pmode = 0;
> +	put_cpu_var(rcu_cpumode);
> +
> +	__rcu_remove_cpu(&rcu_global_state_normal, &get_cpu_var(rcu_cpudata_normal), cpu);
> +	put_cpu_var(rcu_cpudata_normal);
> +	__rcu_remove_cpu(&rcu_global_state_bh, &get_cpu_var(rcu_cpudata_bh), cpu);
> +	put_cpu_var(rcu_cpudata_bh);
> +
> +	BUG_ON(rcu_needs_cpu(cpu));
> +}
> +
> +void rcu_exit_nohz(void)
> +{
> +	int cpu = smp_processor_id();
> +	int *pmode;
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	pmode = &get_cpu_var(rcu_cpumode);
> +	BUG_ON(*pmode != 0);
> +	*pmode = RCU_CPUMODE_DELAYED;
> +	put_cpu_var(rcu_cpumode);
> +
> +	__rcu_add_cpu(&rcu_global_state_normal, &get_cpu_var(rcu_cpudata_normal), cpu);
> +	put_cpu_var(rcu_cpudata_normal);
> +	__rcu_add_cpu(&rcu_global_state_bh, &get_cpu_var(rcu_cpudata_bh), cpu);
> +	put_cpu_var(rcu_cpudata_bh);
> +}
> +
> +void rcu_irq_enter(int in_nmi)
> +{
> +	int *pmode;
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	pmode = &get_cpu_var(rcu_cpumode);
> +	if (unlikely(*pmode != RCU_CPUMODE_DELAYED)) {
> +		if (in_nmi) {
> +			int *pcount;
> +
> +			pcount = &get_cpu_var(rcu_nmi_counter_percpu);
> +			(*pcount)++;
> +			put_cpu_var(rcu_nmi_counter_percpu);
> +			atomic_inc(&rcu_nmi_counter);
> +			/*
> +			 * Here an explicit mb() is required:
> +			 * All other memory ordering is enforced by the
> +			 * spinlock in rgs->cpus. For NMIs, this is not
> +			 * the case: The counters inc must be before
> +			 * any accesses to rcu protected memory,
> +			 * the counter dec after all accesses.
> +			 */
> +			smp_mb();
> +		} else {
> +			if (*pmode == 0) {
> +				int cpu = smp_processor_id();
> +
> +				__rcu_add_cpu(&rcu_global_state_normal,&get_cpu_var(rcu_cpudata_normal), cpu);
> +				put_cpu_var(rcu_cpudata_normal);
> +				__rcu_add_cpu(&rcu_global_state_bh,&get_cpu_var(rcu_cpudata_bh), cpu);
> +				put_cpu_var(rcu_cpudata_bh);
> +			}
> +			(*pmode)++;
> +		}
> +	}
> +	put_cpu_var(rcu_cpumode);
> +}
> +
> +void rcu_irq_exit(int in_nmi)
> +{
> +	int *pmode;
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	pmode = &get_cpu_var(rcu_cpumode);
> +	if (unlikely(*pmode != RCU_CPUMODE_DELAYED)) {
> +		if (in_nmi) {
> +			int *pcount;
> +			/* see comment in rcu_irq_enter() */
> +			smp_mb();
> +
> +			atomic_dec(&rcu_nmi_counter);
> +
> +			pcount = &get_cpu_var(rcu_nmi_counter_percpu);
> +			(*pcount)--;
> +			put_cpu_var(rcu_nmi_counter_percpu);
> +		} else {
> +			(*pmode)--;
> +
> +			if (*pmode == 0) {
> +				int cpu = smp_processor_id();
> +
> +				/*
> +				 * task 1: remove us from the list of cpus that might be inside critical
> +				 * sections and inform the global state machine that we are outside
> +				 * any read side critical sections.
> +				 */
> +				__rcu_remove_cpu(&rcu_global_state_normal,&per_cpu(rcu_cpudata_normal, cpu), cpu);
> +				__rcu_remove_cpu(&rcu_global_state_bh,&per_cpu(rcu_cpudata_bh, cpu), cpu);
> +
> +				if (rcu_needs_cpu(cpu)) {
> +					/*
> +					 * task 2: Someone did a call_rcu() in the interupt.
> +					 * Duh, we've lost. Force a reschedule, that leaves nohz mode.
> +					 *
> +					 * Note: This can race: our call_rcu() might have set
> +					 * start_immediately. But: that start might happen before
> +					 * we readd ourself to the global cpu mask. Then we would
> +					 * not take part in the global cycle - and we would not set
> +					 * start_immediately again, either, because our newqlen is
> +					 * already above qlowmark. The timeout would
> +					 * ensure forward progress, thus it's not that bad.
> +					 *
> +					 * FIXME: double check that this really works.
> +					 */
> +printk(KERN_ERR" irq exit %d - need resched .\n", cpu);
> +					set_need_resched();
> +				}
> +			}
> +		}
> +	}
> +}
> +
> +#endif /* CONFIG_NO_HZ */
> +
> +static void rcu_init_percpu_data(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int cpu)
> +{
> +	__rcu_add_cpu(rgs, rcs, cpu);
> +
> +	rcs->new = rcs->old = NULL;
> +	rcs->newqlen = rcs->oldqlen = 0;
> +}
> +
> +static void __cpuinit rcu_online_cpu(int cpu)
> +{
> +	rcu_init_percpu_data(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), cpu);
> +	rcu_init_percpu_data(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), cpu);
> +
> +	per_cpu(rcu_cpumode, cpu) = RCU_CPUMODE_DELAYED;
> +
> +	per_cpu(rcu_cpudata_dead, cpu).dead = NULL;
> +	per_cpu(rcu_cpudata_dead, cpu).deadqlen = 0;
> +	per_cpu(rcu_cpudata_dead, cpu).batchcount = RCU_BATCH_MIN;
> +
> +	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
> +}
> +
> +static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> +				unsigned long action, void *hcpu)
> +{
> +	long cpu = (long)hcpu;
> +
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +	case CPU_UP_PREPARE_FROZEN:
> +		rcu_online_cpu(cpu);
> +		break;
> +	case CPU_UP_CANCELED:
> +	case CPU_UP_CANCELED_FROZEN:
> +		/*
> +		 * During CPU_UP_PREPARE, the cpu is fully accounted for
> +		 * and added into the rcu_cpumask. Thus it must be properly
> +		 * removed if the CPU_UP failed.
> +		 * Therefore CPU_UP_CANCELED is equivalent to CPU_DEAD.
> +		 */
> +		/* fall-through */
> +	case CPU_DEAD:
> +	case CPU_DEAD_FROZEN:
> +		rcu_offline_cpu(cpu);
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block __cpuinitdata rcu_nb = {
> +	.notifier_call	= rcu_cpu_notify,
> +};
> +
> +/*
> + * Initializes rcu mechanism.  Assumed to be called early.
> + * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
> + * Note that rcu_qsctr and friends are implicitly
> + * initialized due to the choice of ``0'' for RCU_CTR_INVALID.
> + */
> +void __init __rcu_init(void)
> +{
> +	rcu_cpumask_init(&rcu_global_state_normal.cpus, RCU_STATE_DESTROY, 0);
> +	rcu_cpumask_init(&rcu_global_state_bh.cpus, RCU_STATE_DESTROY, 0);
> +	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
> +			(void *)(long)smp_processor_id());
> +	/* Register notifier for non-boot CPUs */
> +	register_cpu_notifier(&rcu_nb);
> +}
> +
> +module_param(qlowmark, int, 0);
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index c506f26..ba20a90 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -287,7 +287,7 @@ void irq_exit(void)
>  	/* Make sure that timer wheel updates are propagated */
>  	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
>  		tick_nohz_stop_sched_tick(0);
> -	rcu_irq_exit();
> +	rcu_irq_exit(0);
>  #endif
>  	preempt_enable_no_resched();
>  }
> -- 
> 1.5.5.1
> 

