Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbXIUOka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbXIUOka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbXIUOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:40:23 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:58980 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbXIUOkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:40:19 -0400
Date: Fri, 21 Sep 2007 10:40:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070921144003.GC15697@goodmis.org>
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910183412.GC3819@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:
>  
>  #endif /* __KERNEL__ */
>  #endif /* __LINUX_RCUCLASSIC_H */
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h
> --- linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h	2007-07-19 14:02:36.000000000 -0700
> +++ linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h	2007-08-22 15:21:06.000000000 -0700
> @@ -52,7 +52,11 @@ struct rcu_head {
>  	void (*func)(struct rcu_head *head);
>  };
>  
> +#ifdef CONFIG_CLASSIC_RCU
>  #include <linux/rcuclassic.h>
> +#else /* #ifdef CONFIG_CLASSIC_RCU */
> +#include <linux/rcupreempt.h>
> +#endif /* #else #ifdef CONFIG_CLASSIC_RCU */

A bit extreme on the comments here.


>  
>  #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
>  #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> @@ -218,10 +222,13 @@ extern void FASTCALL(call_rcu_bh(struct 
>  /* Exported common interfaces */
>  extern void synchronize_rcu(void);
>  extern void rcu_barrier(void);
> +extern long rcu_batches_completed(void);
> +extern long rcu_batches_completed_bh(void);
>  
>  /* Internal to kernel */
>  extern void rcu_init(void);
>  extern void rcu_check_callbacks(int cpu, int user);
> +extern int rcu_needs_cpu(int cpu);
>  
>  #endif /* __KERNEL__ */
>  #endif /* __LINUX_RCUPDATE_H */
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/include/linux/rcupreempt.h linux-2.6.22-c-preemptrcu/include/linux/rcupreempt.h
> --- linux-2.6.22-b-fixbarriers/include/linux/rcupreempt.h	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22-c-preemptrcu/include/linux/rcupreempt.h	2007-08-22 15:21:06.000000000 -0700
> @@ -0,0 +1,78 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion (RT implementation)
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
> + * Copyright (C) IBM Corporation, 2006
> + *
> + * Author:  Paul McKenney <paulmck@us.ibm.com>
> + *
> + * Based on the original work by Paul McKenney <paul.mckenney@us.ibm.com>
> + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> + * Papers:
> + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		Documentation/RCU
> + *
> + */
> +
> +#ifndef __LINUX_RCUPREEMPT_H
> +#define __LINUX_RCUPREEMPT_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/cache.h>
> +#include <linux/spinlock.h>
> +#include <linux/threads.h>
> +#include <linux/percpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/seqlock.h>
> +
> +#define rcu_qsctr_inc(cpu)
> +#define rcu_bh_qsctr_inc(cpu)
> +#define call_rcu_bh(head, rcu) call_rcu(head, rcu)
> +
> +extern void __rcu_read_lock(void);
> +extern void __rcu_read_unlock(void);
> +extern int rcu_pending(int cpu);
> +extern int rcu_needs_cpu(int cpu);
> +
> +#define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
> +#define __rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
> +
> +#define __rcu_read_lock_nesting()	(current->rcu_read_lock_nesting)
> +
> +extern void __synchronize_sched(void);
> +
> +extern void __rcu_init(void);
> +extern void rcu_check_callbacks(int cpu, int user);
> +extern void rcu_restart_cpu(int cpu);
> +
> +#ifdef CONFIG_RCU_TRACE
> +struct rcupreempt_trace;
> +extern int *rcupreempt_flipctr(int cpu);
> +extern long rcupreempt_data_completed(void);
> +extern int rcupreempt_flip_flag(int cpu);
> +extern int rcupreempt_mb_flag(int cpu);
> +extern char *rcupreempt_try_flip_state_name(void);
> +extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
> +#endif
> +
> +struct softirq_action;
> +
> +#endif /* __KERNEL__ */
> +#endif /* __LINUX_RCUPREEMPT_H */
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/include/linux/rcupreempt_trace.h linux-2.6.22-c-preemptrcu/include/linux/rcupreempt_trace.h
> --- linux-2.6.22-b-fixbarriers/include/linux/rcupreempt_trace.h	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22-c-preemptrcu/include/linux/rcupreempt_trace.h	2007-08-22 15:21:06.000000000 -0700
> @@ -0,0 +1,100 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion (RT implementation)
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
> + * Copyright (C) IBM Corporation, 2006
> + *
> + * Author:  Paul McKenney <paulmck@us.ibm.com>
> + *
> + * Based on the original work by Paul McKenney <paul.mckenney@us.ibm.com>
> + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> + * Papers:
> + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		http://lse.sourceforge.net/locking/rcupdate.html
> + *
> + */
> +
> +#ifndef __LINUX_RCUPREEMPT_TRACE_H
> +#define __LINUX_RCUPREEMPT_TRACE_H
> +
> +#ifdef __KERNEL__
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +
> +#include <asm/atomic.h>
> +
> +/*
> + * PREEMPT_RCU data structures.
> + */
> +
> +struct rcupreempt_trace {
> +	long		next_length;
> +	long		next_add;
> +	long		wait_length;
> +	long		wait_add;
> +	long		done_length;
> +	long		done_add;
> +	long		done_remove;
> +	atomic_t	done_invoked;
> +	long		rcu_check_callbacks;
> +	atomic_t	rcu_try_flip_1;
> +	atomic_t	rcu_try_flip_e1;
> +	long		rcu_try_flip_i1;
> +	long		rcu_try_flip_ie1;
> +	long		rcu_try_flip_g1;
> +	long		rcu_try_flip_a1;
> +	long		rcu_try_flip_ae1;
> +	long		rcu_try_flip_a2;
> +	long		rcu_try_flip_z1;
> +	long		rcu_try_flip_ze1;
> +	long		rcu_try_flip_z2;
> +	long		rcu_try_flip_m1;
> +	long		rcu_try_flip_me1;
> +	long		rcu_try_flip_m2;
> +};
> +
> +#ifdef CONFIG_RCU_TRACE
> +#define RCU_TRACE(fn, arg) 	fn(arg);
> +#else
> +#define RCU_TRACE(fn, arg)
> +#endif
> +
> +extern void rcupreempt_trace_move2done(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_move2wait(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_e1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_i1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_ie1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_g1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_a1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_ae1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_a2(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_z1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_ze1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_z2(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_m1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_me1(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_try_flip_m2(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_check_callbacks(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_done_remove(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_invoke(struct rcupreempt_trace *trace);
> +extern void rcupreempt_trace_next_add(struct rcupreempt_trace *trace);
> +
> +#endif /* __KERNEL__ */
> +#endif /* __LINUX_RCUPREEMPT_TRACE_H */
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/include/linux/sched.h linux-2.6.22-c-preemptrcu/include/linux/sched.h
> --- linux-2.6.22-b-fixbarriers/include/linux/sched.h	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-c-preemptrcu/include/linux/sched.h	2007-08-22 15:21:06.000000000 -0700
> @@ -850,6 +850,11 @@ struct task_struct {
>  	cpumask_t cpus_allowed;
>  	unsigned int time_slice, first_time_slice;
>  
> +#ifdef CONFIG_PREEMPT_RCU
> +	int rcu_read_lock_nesting;
> +	int rcu_flipctr_idx;
> +#endif /* #ifdef CONFIG_PREEMPT_RCU */
> +
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	struct sched_info sched_info;
>  #endif
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/kernel/fork.c linux-2.6.22-c-preemptrcu/kernel/fork.c
> --- linux-2.6.22-b-fixbarriers/kernel/fork.c	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-c-preemptrcu/kernel/fork.c	2007-08-22 15:21:06.000000000 -0700
> @@ -1032,6 +1032,10 @@ static struct task_struct *copy_process(
>  
>  	INIT_LIST_HEAD(&p->children);
>  	INIT_LIST_HEAD(&p->sibling);
> +#ifdef CONFIG_PREEMPT_RCU
> +	p->rcu_read_lock_nesting = 0;
> +	p->rcu_flipctr_idx = 0;
> +#endif /* #ifdef CONFIG_PREEMPT_RCU */
>  	p->vfork_done = NULL;
>  	spin_lock_init(&p->alloc_lock);
>  
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/kernel/Kconfig.preempt linux-2.6.22-c-preemptrcu/kernel/Kconfig.preempt
> --- linux-2.6.22-b-fixbarriers/kernel/Kconfig.preempt	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-c-preemptrcu/kernel/Kconfig.preempt	2007-08-22 15:21:06.000000000 -0700
> @@ -63,3 +63,41 @@ config PREEMPT_BKL
>  	  Say Y here if you are building a kernel for a desktop system.
>  	  Say N if you are unsure.
>  
> +choice
> +	prompt "RCU implementation type:"
> +	default CLASSIC_RCU
> +
> +config CLASSIC_RCU
> +	bool "Classic RCU"
> +	help
> +	  This option selects the classic RCU implementation that is
> +	  designed for best read-side performance on non-realtime
> +	  systems.
> +
> +	  Say Y if you are unsure.
> +
> +config PREEMPT_RCU
> +	bool "Preemptible RCU"
> +	depends on PREEMPT
> +	help
> +	  This option reduces the latency of the kernel by making certain
> +	  RCU sections preemptible. Normally RCU code is non-preemptible, if
> +	  this option is selected then read-only RCU sections become
> +	  preemptible. This helps latency, but may expose bugs due to
> +	  now-naive assumptions about each RCU read-side critical section
> +	  remaining on a given CPU through its execution.
> +
> +	  Say N if you are unsure.
> +
> +endchoice
> +
> +config RCU_TRACE
> +	bool "Enable tracing for RCU - currently stats in debugfs"
> +	select DEBUG_FS
> +	default y
> +	help
> +	  This option provides tracing in RCU which presents stats
> +	  in debugfs for debugging RCU implementation.
> +
> +	  Say Y here if you want to enable RCU tracing
> +	  Say N if you are unsure.
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/kernel/Makefile linux-2.6.22-c-preemptrcu/kernel/Makefile
> --- linux-2.6.22-b-fixbarriers/kernel/Makefile	2007-07-19 12:16:03.000000000 -0700
> +++ linux-2.6.22-c-preemptrcu/kernel/Makefile	2007-08-22 15:21:06.000000000 -0700
> @@ -6,7 +6,7 @@ obj-y     = sched.o fork.o exec_domain.o
>  	    exit.o itimer.o time.o softirq.o resource.o \
>  	    sysctl.o capability.o ptrace.o timer.o user.o \
>  	    signal.o sys.o kmod.o workqueue.o pid.o \
> -	    rcupdate.o rcuclassic.o extable.o params.o posix-timers.o \
> +	    rcupdate.o extable.o params.o posix-timers.o \
>  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>  	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o
>  
> @@ -46,6 +46,11 @@ obj-$(CONFIG_DETECT_SOFTLOCKUP) += softl
>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>  obj-$(CONFIG_SECCOMP) += seccomp.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
> +obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
> +obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
> +ifeq ($(CONFIG_PREEMPT_RCU),y)
> +obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
> +endif
>  obj-$(CONFIG_RELAY) += relay.o
>  obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
>  obj-$(CONFIG_UTS_NS) += utsname.o
> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/kernel/rcupreempt.c linux-2.6.22-c-preemptrcu/kernel/rcupreempt.c
> --- linux-2.6.22-b-fixbarriers/kernel/rcupreempt.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22-c-preemptrcu/kernel/rcupreempt.c	2007-08-22 15:35:19.000000000 -0700
> @@ -0,0 +1,767 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion, realtime implementation
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
> + * Copyright IBM Corporation, 2006
> + *
> + * Authors: Paul E. McKenney <paulmck@us.ibm.com>
> + *		With thanks to Esben Nielsen, Bill Huey, and Ingo Molnar
> + *		for pushing me away from locks and towards counters, and
> + *		to Suparna Bhattacharya for pushing me completely away
> + *		from atomic instructions on the read side.
> + *
> + * Papers:  http://www.rdrop.com/users/paulmck/RCU
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		Documentation/RCU/ *.txt
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
> +#include <linux/rcupdate.h>
> +#include <linux/cpu.h>
> +#include <linux/random.h>
> +#include <linux/delay.h>
> +#include <linux/byteorder/swabb.h>
> +#include <linux/cpumask.h>
> +#include <linux/rcupreempt_trace.h>
> +
> +/*
> + * PREEMPT_RCU data structures.
> + */
> +
> +#define GP_STAGES 4

I take it that GP stand for "grace period". Might want to state that
here. /* Grace period stages */  When I was looking at this code at 1am,
I kept asking myself "what's this GP?" (General Protection??). But
that's what happens when looking at code like this after midnight ;-)

> +struct rcu_data {
> +	spinlock_t	lock;		/* Protect rcu_data fields. */
> +	long		completed;	/* Number of last completed batch. */
> +	int		waitlistcount;
> +	struct tasklet_struct rcu_tasklet;
> +	struct rcu_head *nextlist;
> +	struct rcu_head **nexttail;
> +	struct rcu_head *waitlist[GP_STAGES];
> +	struct rcu_head **waittail[GP_STAGES];
> +	struct rcu_head *donelist;
> +	struct rcu_head **donetail;
> +#ifdef CONFIG_RCU_TRACE
> +	struct rcupreempt_trace trace;
> +#endif /* #ifdef CONFIG_RCU_TRACE */
> +};
> +struct rcu_ctrlblk {
> +	spinlock_t	fliplock;	/* Protect state-machine transitions. */
> +	long		completed;	/* Number of last completed batch. */
> +};
> +static DEFINE_PER_CPU(struct rcu_data, rcu_data);
> +static struct rcu_ctrlblk rcu_ctrlblk = {
> +	.fliplock = SPIN_LOCK_UNLOCKED,
> +	.completed = 0,
> +};
> +static DEFINE_PER_CPU(int [2], rcu_flipctr) = { 0, 0 };
> +
> +/*
> + * States for rcu_try_flip() and friends.

Can you have a pointer somewhere that explains these states. And not a
"it's in this paper or directory". Either have a short discription here,
or specify where exactly to find the information (perhaps a
Documentation/RCU/preemptible_states.txt?).

Trying to understand these states has caused me the most agony in
reviewing these patches.

> + */
> +
> +enum rcu_try_flip_states {
> +	rcu_try_flip_idle_state,	/* "I" */
> +	rcu_try_flip_waitack_state, 	/* "A" */
> +	rcu_try_flip_waitzero_state,	/* "Z" */
> +	rcu_try_flip_waitmb_state	/* "M" */
> +};
> +static enum rcu_try_flip_states rcu_try_flip_state = rcu_try_flip_idle_state;
> +#ifdef CONFIG_RCU_TRACE
> +static char *rcu_try_flip_state_names[] =
> +	{ "idle", "waitack", "waitzero", "waitmb" };
> +#endif /* #ifdef CONFIG_RCU_TRACE */
> +
> +/*
> + * Enum and per-CPU flag to determine when each CPU has seen
> + * the most recent counter flip.
> + */
> +
> +enum rcu_flip_flag_values {
> +	rcu_flip_seen,		/* Steady/initial state, last flip seen. */
> +				/* Only GP detector can update. */
> +	rcu_flipped		/* Flip just completed, need confirmation. */
> +				/* Only corresponding CPU can update. */
> +};
> +static DEFINE_PER_CPU(enum rcu_flip_flag_values, rcu_flip_flag) = rcu_flip_seen;
> +
> +/*
> + * Enum and per-CPU flag to determine when each CPU has executed the
> + * needed memory barrier to fence in memory references from its last RCU
> + * read-side critical section in the just-completed grace period.
> + */
> +
> +enum rcu_mb_flag_values {
> +	rcu_mb_done,		/* Steady/initial state, no mb()s required. */
> +				/* Only GP detector can update. */
> +	rcu_mb_needed		/* Flip just completed, need an mb(). */
> +				/* Only corresponding CPU can update. */
> +};
> +static DEFINE_PER_CPU(enum rcu_mb_flag_values, rcu_mb_flag) = rcu_mb_done;
> +
> +/*
> + * Macro that prevents the compiler from reordering accesses, but does
> + * absolutely -nothing- to prevent CPUs from reordering.  This is used
> + * only to mediate communication between mainline code and hardware
> + * interrupt and NMI handlers.
> + */
> +#define ORDERED_WRT_IRQ(x) (*(volatile typeof(x) *)&(x))
> +
> +/*
> + * RCU_DATA_ME: find the current CPU's rcu_data structure.
> + * RCU_DATA_CPU: find the specified CPU's rcu_data structure.
> + */
> +#define RCU_DATA_ME()		(&__get_cpu_var(rcu_data))
> +#define RCU_DATA_CPU(cpu)	(&per_cpu(rcu_data, cpu))
> +
> +/*
> + * Helper macro for tracing when the appropriate rcu_data is not
> + * cached in a local variable, but where the CPU number is so cached.
> + */
> +#define RCU_TRACE_CPU(f, cpu) RCU_TRACE(f, &(RCU_DATA_CPU(cpu)->trace));
> +
> +/*
> + * Helper macro for tracing when the appropriate rcu_data is not
> + * cached in a local variable.
> + */
> +#define RCU_TRACE_ME(f) RCU_TRACE(f, &(RCU_DATA_ME()->trace));
> +
> +/*
> + * Helper macro for tracing when the appropriate rcu_data is pointed
> + * to by a local variable.
> + */
> +#define RCU_TRACE_RDP(f, rdp) RCU_TRACE(f, &((rdp)->trace));
> +
> +/*
> + * Return the number of RCU batches processed thus far.  Useful
> + * for debug and statistics.
> + */
> +long rcu_batches_completed(void)
> +{
> +	return rcu_ctrlblk.completed;
> +}
> +EXPORT_SYMBOL_GPL(rcu_batches_completed);
> +
> +/*
> + * Return the number of RCU batches processed thus far.  Useful for debug
> + * and statistics.  The _bh variant is identical to straight RCU.
> + */

If they are identical, then why the separation?

> +long rcu_batches_completed_bh(void)
> +{
> +	return rcu_ctrlblk.completed;
> +}
> +EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
> +
> +void __rcu_read_lock(void)
> +{
> +	int idx;
> +	struct task_struct *me = current;

Nitpick, but other places in the kernel usually use "t" or "p" as a
variable to assign current to.  It's just that "me" thows me off a
little while reviewing this.  But this is just a nitpick, so do as you
will.

> +	int nesting;
> +
> +	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
> +	if (nesting != 0) {
> +
> +		/* An earlier rcu_read_lock() covers us, just count it. */
> +
> +		me->rcu_read_lock_nesting = nesting + 1;
> +
> +	} else {
> +		unsigned long oldirq;

Nitpick, "flags" is usually used for saving irq state.

> +
> +		/*
> +		 * Disable local interrupts to prevent the grace-period
> +		 * detection state machine from seeing us half-done.
> +		 * NMIs can still occur, of course, and might themselves
> +		 * contain rcu_read_lock().
> +		 */
> +
> +		local_irq_save(oldirq);

Isn't the GP detection done via a tasklet/softirq. So wouldn't a
local_bh_disable be sufficient here? You already cover NMIs, which would
also handle normal interrupts.

> +
> +		/*
> +		 * Outermost nesting of rcu_read_lock(), so increment
> +		 * the current counter for the current CPU.  Use volatile
> +		 * casts to prevent the compiler from reordering.
> +		 */
> +
> +		idx = ORDERED_WRT_IRQ(rcu_ctrlblk.completed) & 0x1;
> +		smp_read_barrier_depends();  /* @@@@ might be unneeded */
> +		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])++;
> +
> +		/*
> +		 * Now that the per-CPU counter has been incremented, we
> +		 * are protected from races with rcu_read_lock() invoked
> +		 * from NMI handlers on this CPU.  We can therefore safely
> +		 * increment the nesting counter, relieving further NMIs
> +		 * of the need to increment the per-CPU counter.
> +		 */
> +
> +		ORDERED_WRT_IRQ(me->rcu_read_lock_nesting) = nesting + 1;
> +
> +		/*
> +		 * Now that we have preventing any NMIs from storing
> +		 * to the ->rcu_flipctr_idx, we can safely use it to
> +		 * remember which counter to decrement in the matching
> +		 * rcu_read_unlock().
> +		 */
> +
> +		ORDERED_WRT_IRQ(me->rcu_flipctr_idx) = idx;
> +		local_irq_restore(oldirq);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(__rcu_read_lock);
> +
> +void __rcu_read_unlock(void)
> +{
> +	int idx;
> +	struct task_struct *me = current;
> +	int nesting;
> +
> +	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
> +	if (nesting > 1) {
> +
> +		/*
> +		 * We are still protected by the enclosing rcu_read_lock(),
> +		 * so simply decrement the counter.
> +		 */
> +
> +		me->rcu_read_lock_nesting = nesting - 1;
> +
> +	} else {
> +		unsigned long oldirq;
> +
> +		/*
> +		 * Disable local interrupts to prevent the grace-period
> +		 * detection state machine from seeing us half-done.
> +		 * NMIs can still occur, of course, and might themselves
> +		 * contain rcu_read_lock() and rcu_read_unlock().
> +		 */
> +
> +		local_irq_save(oldirq);
> +
> +		/*
> +		 * Outermost nesting of rcu_read_unlock(), so we must
> +		 * decrement the current counter for the current CPU.
> +		 * This must be done carefully, because NMIs can
> +		 * occur at any point in this code, and any rcu_read_lock()
> +		 * and rcu_read_unlock() pairs in the NMI handlers
> +		 * must interact non-destructively with this code.
> +		 * Lots of volatile casts, and -very- careful ordering.
> +		 *
> +		 * Changes to this code, including this one, must be
> +		 * inspected, validated, and tested extremely carefully!!!
> +		 */
> +
> +		/*
> +		 * First, pick up the index.  Enforce ordering for
> +		 * DEC Alpha.
> +		 */
> +
> +		idx = ORDERED_WRT_IRQ(me->rcu_flipctr_idx);
> +		smp_read_barrier_depends();  /* @@@ Needed??? */
> +
> +		/*
> +		 * Now that we have fetched the counter index, it is
> +		 * safe to decrement the per-task RCU nesting counter.
> +		 * After this, any interrupts or NMIs will increment and
> +		 * decrement the per-CPU counters.
> +		 */
> +		ORDERED_WRT_IRQ(me->rcu_read_lock_nesting) = nesting - 1;
> +
> +		/*
> +		 * It is now safe to decrement this task's nesting count.
> +		 * NMIs that occur after this statement will route their
> +		 * rcu_read_lock() calls through this "else" clause, and
> +		 * will thus start incrementing the per-CPU coutner on

s/coutner/counter/

> +		 * their own.  They will also clobber ->rcu_flipctr_idx,
> +		 * but that is OK, since we have already fetched it.
> +		 */
> +
> +		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])--;
> +		local_irq_restore(oldirq);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(__rcu_read_unlock);
> +
> +/*
> + * If a global counter flip has occurred since the last time that we
> + * advanced callbacks, advance them.  Hardware interrupts must be
> + * disabled when calling this function.
> + */
> +static void __rcu_advance_callbacks(struct rcu_data *rdp)
> +{
> +	int cpu;
> +	int i;
> +	int wlc = 0;
> +
> +	if (rdp->completed != rcu_ctrlblk.completed) {
> +		if (rdp->waitlist[GP_STAGES - 1] != NULL) {
> +			*rdp->donetail = rdp->waitlist[GP_STAGES - 1];
> +			rdp->donetail = rdp->waittail[GP_STAGES - 1];
> +			RCU_TRACE_RDP(rcupreempt_trace_move2done, rdp);
> +		}
> +		for (i = GP_STAGES - 2; i >= 0; i--) {
> +			if (rdp->waitlist[i] != NULL) {
> +				rdp->waitlist[i + 1] = rdp->waitlist[i];
> +				rdp->waittail[i + 1] = rdp->waittail[i];
> +				wlc++;
> +			} else {
> +				rdp->waitlist[i + 1] = NULL;
> +				rdp->waittail[i + 1] =
> +					&rdp->waitlist[i + 1];
> +			}
> +		}
> +		if (rdp->nextlist != NULL) {
> +			rdp->waitlist[0] = rdp->nextlist;
> +			rdp->waittail[0] = rdp->nexttail;
> +			wlc++;
> +			rdp->nextlist = NULL;
> +			rdp->nexttail = &rdp->nextlist;
> +			RCU_TRACE_RDP(rcupreempt_trace_move2wait, rdp);
> +		} else {
> +			rdp->waitlist[0] = NULL;
> +			rdp->waittail[0] = &rdp->waitlist[0];
> +		}
> +		rdp->waitlistcount = wlc;
> +		rdp->completed = rcu_ctrlblk.completed;
> +	}
> +
> +	/*
> +	 * Check to see if this CPU needs to report that it has seen
> +	 * the most recent counter flip, thereby declaring that all
> +	 * subsequent rcu_read_lock() invocations will respect this flip.
> +	 */
> +
> +	cpu = raw_smp_processor_id();
> +	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
> +		smp_mb();  /* Subsequent counter accesses must see new value */
> +		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
> +		smp_mb();  /* Subsequent RCU read-side critical sections */
> +			   /*  seen -after- acknowledgement. */
> +	}
> +}
> +
> +/*
> + * Get here when RCU is idle.  Decide whether we need to
> + * move out of idle state, and return non-zero if so.
> + * "Straightforward" approach for the moment, might later
> + * use callback-list lengths, grace-period duration, or
> + * some such to determine when to exit idle state.
> + * Might also need a pre-idle test that does not acquire
> + * the lock, but let's get the simple case working first...
> + */
> +
> +static int
> +rcu_try_flip_idle(void)
> +{
> +	int cpu;
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_i1);
> +	if (!rcu_pending(smp_processor_id())) {
> +		RCU_TRACE_ME(rcupreempt_trace_try_flip_ie1);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Do the flip.
> +	 */
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_g1);
> +	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
> +
> +	/*
> +	 * Need a memory barrier so that other CPUs see the new
> +	 * counter value before they see the subsequent change of all
> +	 * the rcu_flip_flag instances to rcu_flipped.
> +	 */
> +
> +	smp_mb();	/* see above block comment. */
> +
> +	/* Now ask each CPU for acknowledgement of the flip. */
> +
> +	for_each_possible_cpu(cpu)
> +		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
> +
> +	return 1;
> +}
> +
> +/*
> + * Wait for CPUs to acknowledge the flip.
> + */
> +
> +static int
> +rcu_try_flip_waitack(void)
> +{
> +	int cpu;
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
> +	for_each_possible_cpu(cpu)
> +		if (per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
> +			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
> +			return 0;
> +		}
> +
> +	/*
> +	 * Make sure our checks above don't bleed into subsequent
> +	 * waiting for the sum of the counters to reach zero.
> +	 */
> +
> +	smp_mb();	/* see above block comment. */
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_a2);
> +	return 1;
> +}
> +
> +/*
> + * Wait for collective ``last'' counter to reach zero,
> + * then tell all CPUs to do an end-of-grace-period memory barrier.
> + */
> +
> +static int
> +rcu_try_flip_waitzero(void)
> +{
> +	int cpu;
> +	int lastidx = !(rcu_ctrlblk.completed & 0x1);
> +	int sum = 0;
> +
> +	/* Check to see if the sum of the "last" counters is zero. */
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(rcu_flipctr, cpu)[lastidx];
> +	if (sum != 0) {
> +		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
> +		return 0;
> +	}
> +
> +	smp_mb();  /* Don't call for memory barriers before we see zero. */
> +
> +	/* Call for a memory barrier from each CPU. */
> +
> +	for_each_possible_cpu(cpu)
> +		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_z2);
> +	return 1;
> +}
> +
> +/*
> + * Wait for all CPUs to do their end-of-grace-period memory barrier.
> + * Return 0 once all CPUs have done so.
> + */
> +
> +static int
> +rcu_try_flip_waitmb(void)
> +{
> +	int cpu;
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
> +	for_each_possible_cpu(cpu)
> +		if (per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
> +			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
> +			return 0;
> +		}
> +
> +	smp_mb(); /* Ensure that the above checks precede any following flip. */
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_m2);
> +	return 1;
> +}
> +
> +/*
> + * Attempt a single flip of the counters.  Remember, a single flip does
> + * -not- constitute a grace period.  Instead, the interval between
> + * at least three consecutive flips is a grace period.
> + *
> + * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation

Oh, come now! It's not "nuts" to use this ;-)

> + * on a large SMP, they might want to use a hierarchical organization of
> + * the per-CPU-counter pairs.
> + */
> +static void rcu_try_flip(void)
> +{
> +	unsigned long oldirq;
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_1);
> +	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, oldirq))) {
> +		RCU_TRACE_ME(rcupreempt_trace_try_flip_e1);
> +		return;
> +	}
> +
> +	/*
> +	 * Take the next transition(s) through the RCU grace-period
> +	 * flip-counter state machine.
> +	 */
> +
> +	switch (rcu_try_flip_state) {
> +	case rcu_try_flip_idle_state:
> +		if (rcu_try_flip_idle())
> +			rcu_try_flip_state = rcu_try_flip_waitack_state;

Just trying to understand all this. Here at flip_idle, only a CPU with
no pending RCU calls will flip it. Then all the cpus flags will be set
to rcu_flipped, and the ctrl.completed counter is incremented.

When a CPU calls process_callbacks, it would then move all it's
callbacks to the next list (next -> wait[GP...] -> done), and set it's
unique completed counter to completed. So no more moving up the lists
will be done. It also will set it's state flag to rcu_flip_seen. Even if
the cpu doesn't have any RCU callbacks, the state would be in
rcu_try_flip_waitack_state so we go to the next switch case for a
rcu_try_flip call.

Also the filp counter has been flipped so that all new rcu_read_locks
will increment the cpus "other" index. We just need to wait for the
index of the previous counters to reach zero.

> +		break;
> +	case rcu_try_flip_waitack_state:
> +		if (rcu_try_flip_waitack())

Now, we just wait to see if all the cpus have called process_callbacks
and now have the flag rcu_flip_seen set. So all the cpus have pushed
their callbacks up to the next queue.

> +			rcu_try_flip_state = rcu_try_flip_waitzero_state;
> +		break;
> +	case rcu_try_flip_waitzero_state:
> +		if (rcu_try_flip_waitzero())

Now this is where we wait for the sum of all the CPUs counters to reach
zero. The reason for the sum is that the task may have been preempted
and migrated to another CPU and decremented that counter. So the one CPU
counter would be 1 and the other would be -1. But the sum is still zero.
Is there a chance that overflow of a counter (although probably very
very unlikely) would cause any problems?

Also, all the CPUs have their "check_mb" set.

> +			rcu_try_flip_state = rcu_try_flip_waitmb_state;
> +		break;
> +	case rcu_try_flip_waitmb_state:
> +		if (rcu_try_flip_waitmb())

I have to admit that this seems a bit of an overkill, but I guess you
know what you are doing.  After going through three states, we still
need to do a memory barrier on each CPU?

> +			rcu_try_flip_state = rcu_try_flip_idle_state;

Finally we are back to the original state and we start the process all
over.

Is this analysis correct?

> +	}
> +	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
> +}
> +
> +/*
> + * Check to see if this CPU needs to do a memory barrier in order to
> + * ensure that any prior RCU read-side critical sections have committed
> + * their counter manipulations and critical-section memory references
> + * before declaring the grace period to be completed.
> + */
> +static void rcu_check_mb(int cpu)
> +{
> +	if (per_cpu(rcu_mb_flag, cpu) == rcu_mb_needed) {
> +		smp_mb();  /* Ensure RCU read-side accesses are visible. */
> +		per_cpu(rcu_mb_flag, cpu) = rcu_mb_done;
> +	}
> +}
> +
> +void rcu_check_callbacks(int cpu, int user)
> +{
> +	unsigned long oldirq;
> +	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
> +
> +	rcu_check_mb(cpu);
> +	if (rcu_ctrlblk.completed == rdp->completed)
> +		rcu_try_flip();
> +	spin_lock_irqsave(&rdp->lock, oldirq);
> +	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
> +	__rcu_advance_callbacks(rdp);
> +	if (rdp->donelist == NULL) {
> +		spin_unlock_irqrestore(&rdp->lock, oldirq);
> +	} else {
> +		spin_unlock_irqrestore(&rdp->lock, oldirq);
> +		raise_softirq(RCU_SOFTIRQ);
> +	}
> +}
> +
> +/*
> + * Needed by dynticks, to make sure all RCU processing has finished
> + * when we go idle:

Didn't we have a discussion that this is no longer true? Or was it taken
out of Dynamic ticks before. I don't see any users of it.

> + */
> +void rcu_advance_callbacks(int cpu, int user)
> +{
> +	unsigned long oldirq;
> +	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
> +
> +	if (rcu_ctrlblk.completed == rdp->completed) {
> +		rcu_try_flip();
> +		if (rcu_ctrlblk.completed == rdp->completed)
> +			return;
> +	}
> +	spin_lock_irqsave(&rdp->lock, oldirq);
> +	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
> +	__rcu_advance_callbacks(rdp);
> +	spin_unlock_irqrestore(&rdp->lock, oldirq);
> +}

OK, that's all I have on this patch (will take a bit of a break before
reviewing your other patches).  But I will say that RCU has grown quite
a bit, and is looking very good.

Basically, what I'm saying is "Great work, Paul!".  This is looking
good. Seems that we just need a little bit better explanation for those
that are not up at the IQ level of you.  I can write something up after
this all gets finalized. Sort of a rcu-design.txt, that really tries to
explain it to the simpleton's like me ;-)

-- Steve

