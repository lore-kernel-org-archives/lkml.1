Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYHSOEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYHSOEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYHSOEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:04:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51967 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYHSOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:03:58 -0400
Date: Tue, 19 Aug 2008 07:03:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       oleg@tv-sign.ru, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier
	cleanups
Message-ID: <20080819140339.GF7106@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080805162144.GA8297@linux.vnet.ibm.com> <489936E5.7020509@colorfullife.com> <20080807031806.GA6910@linux.vnet.ibm.com> <48A93D49.2000601@colorfullife.com> <20080818140404.GD6847@linux.vnet.ibm.com> <48AAA501.8010502@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAA501.8010502@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:48:33PM +0200, Manfred Spraul wrote:
> Hi Paul,
>
> You are beating me: I've just finished a my implementation, it's attached.
> It boots with qemu, rcu torture enabled, both single and 8-cpu.

I started about 2.5 weeks ago, so I probably had a head start.

> Two problems are open:
> - right now, I don't use rcu_qsctr_inc() at all.

Hmmm...  What do you do instead to detect context switches?  Or do you
currently rely completely on scheduling-clock interrupts from idle &c?

> - qlowmark is set to 0, any other value breaks synchronize_rcu().

In my implementation, qlowmark controls only the rate at which callbacks
that have already passed a grace period.  You seem to be using it to
delay start of a grace period until there is a reasonably large amount
of work to do.  My suggestion would be to add a time delay as well,
so that if (say) 2 jiffies have passed since the first callback was
registered via call_rcu(), start the grace-period processing regardless
of how few callbacks there are.

> And I must read your implementation....

Likewise!  I suggest that we each complete our implementations, then
look at what should be taken from each.  Seem reasonable?

							Thanx, Paul

> --
>    Manfred

> /*
>  * Read-Copy Update mechanism for mutual exclusion
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, write to the Free Software
>  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>  *
>  * Copyright IBM Corporation, 2001
>  *
>  * Authors: Dipankar Sarma <dipankar@in.ibm.com>
>  *	    Manfred Spraul <manfred@colorfullife.com>
>  *
>  * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
>  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
>  * Papers:
>  * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
>  * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
>  *
>  * For detailed explanation of Read-Copy Update mechanism see -
>  * 		Documentation/RCU
>  *
>  * Rewrite based on a global state machine
>  * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
>  *
>  */
> #include <linux/types.h>
> #include <linux/kernel.h>
> #include <linux/init.h>
> #include <linux/spinlock.h>
> #include <linux/smp.h>
> #include <linux/rcupdate.h>
> #include <linux/interrupt.h>
> #include <linux/sched.h>
> #include <asm/atomic.h>
> #include <linux/bitops.h>
> #include <linux/module.h>
> #include <linux/completion.h>
> #include <linux/moduleparam.h>
> #include <linux/percpu.h>
> #include <linux/notifier.h>
> #include <linux/cpu.h>
> #include <linux/mutex.h>
> #include <linux/time.h>
> #include <linux/proc_fs.h>
> 
> #ifdef CONFIG_DEBUG_LOCK_ALLOC
> static struct lock_class_key rcu_lock_key;
> struct lockdep_map rcu_lock_map =
> 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
> EXPORT_SYMBOL_GPL(rcu_lock_map);
> #endif
> 
> /* Definition for rcupdate control block. */
> static struct rcu_global_state rcu_global_state_normal = {
> 	.lock = __SEQLOCK_UNLOCKED(&rcu_global_state_normal.lock),
> 	.state = RCU_STATE_DESTROY,
> 	.start_immediately = 0,
> 	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_normal.cpus)
> };
> 
> static struct rcu_global_state rcu_global_state_bh = {
> 	.lock = __SEQLOCK_UNLOCKED(&rcu_global_state_bh.lock),
> 	.state = RCU_STATE_DESTROY,
> 	.start_immediately = 0,
> 	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_bh.cpus)
> };
> 
> DEFINE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_normal) = { 0L };
> DEFINE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_bh) = { 0L };
> DEFINE_PER_CPU(struct rcu_cpu_dead, rcu_cpudata_dead) = { 0L };
> 
> 
> /* FIXME: setting qlowmark to non-zero causes a hang.
>  * probably someone waits for a rcu completion - but
>  * the real rcu cycle is never started because qlowmark is not
>  * reached. (e.g. synchronize_rcu()).
>  * idea: replace with a timer based delay.
>  */
> int qlowmark = 0;
> 
> void rcu_cpumask_init(struct rcu_cpumask *rcm)
> {
> 	BUG_ON(!irqs_disabled());
> 	spin_lock(&rcm->lock);
> 	/*
> 	 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
> 	 * Barrier  Otherwise it can cause tickless idle CPUs to be
> 	 * included in rcp->cpumask, which will extend graceperiods
> 	 * unnecessarily.
> 	 */
> 	smp_mb();
> 	cpus_andnot(rcm->cpus, cpu_online_map, nohz_cpu_mask);
> 
> 	spin_unlock(&rcm->lock);
> }
> 
> int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu)
> {
> 	int ret = 0;
> 
> 	BUG_ON(!irqs_disabled());
> 	spin_lock(&rcm->lock);
> 	cpu_clear(cpu, rcm->cpus);
> 	if (cpus_empty(rcm->cpus))
> 		ret = 1;
> 	spin_unlock(&rcm->lock);
> 
> 	return ret;
> }
> 
> long rcu_batches_completed(void)
> {
> 	return rcu_global_state_normal.completed;
> }
> 
> long rcu_batches_completed_bh(void)
> {
> 	return rcu_global_state_normal.completed;
> }
> 
> /**
>  * rcu_state_startcycle - start the next rcu cycle
>  * @rgs: global rcu state
>  *
>  * The function starts the next rcu cycle, either immediately or
>  * by setting rgs->start_immediately.
>  */ 
> static void rcu_state_startcycle(struct rcu_global_state *rgs)
> {
> 	unsigned seq;
> 	int do_real_start;
> 
> 	BUG_ON(!irqs_disabled());
> 	do {
> 		seq = read_seqbegin(&rgs->lock);
> 		if (rgs->start_immediately == 0) {
> 			do_real_start = 1;
> 		} else {
> 			do_real_start = 0;
> 			BUG_ON(rgs->state == RCU_STATE_DESTROY);
> 		}
> 	} while (read_seqretry(&rgs->lock, seq));
> 
> 	if (do_real_start) {
> 		write_seqlock(&rgs->lock);
> 		switch(rgs->state) {
> 		case RCU_STATE_DESTROY_AND_COLLECT:
> 		case RCU_STATE_GRACE:
> 			rgs->start_immediately = 1;
> 			break;
> 		case RCU_STATE_DESTROY:
> 			rgs->state = RCU_STATE_DESTROY_AND_COLLECT;
> 			BUG_ON(rgs->start_immediately);
> 			rcu_cpumask_init(&rgs->cpus);
> 			break;
> 		default:
> 			BUG();
> 		}
> 		write_sequnlock(&rgs->lock);
> 	}
> }
> 
> static void rcu_checkqlen(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int inc)
> {
> 	BUG_ON(!irqs_disabled());
> 	rcs->newqlen += inc; 
> 	if (unlikely(rcs->newqlen > qlowmark)) {
> 
> 		/* FIXME: actually, this code only needs to run once,
> 		 *  i.e. when qlen == qlowmark. But: qlowmark can be changed at runtime.
> 		 * and: doesn't work anyway, see comment near qlowmark
> 		 */
> 		rcu_state_startcycle(rgs);
> 	}
> }
> 
> 
> static void __call_rcu(struct rcu_head *head, struct rcu_global_state *rgs,
> 		struct rcu_cpu_state *rcs)
> {
> 	if (rcs->new == NULL)
> 		rcs->newtail = &head->next;
> 	head->next = rcs->new;
> 	rcs->new = head;
> 
> 	rcu_checkqlen(rgs, rcs, 1);
> }
> 
> /**
>  * call_rcu - Queue an RCU callback for invocation after a grace period.
>  * @head: structure to be used for queueing the RCU updates.
>  * @func: actual update function to be invoked after the grace period
>  *
>  * The update function will be invoked some time after a full grace
>  * period elapses, in other words after all currently executing RCU
>  * read-side critical sections have completed.  RCU read-side critical
>  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
>  * and may be nested.
>  */
> void call_rcu(struct rcu_head *head,
> 				void (*func)(struct rcu_head *rcu))
> {
> 	unsigned long flags;
> 
> 	head->func = func;
> 	local_irq_save(flags);
> 	__call_rcu(head, &rcu_global_state_normal, &__get_cpu_var(rcu_cpudata_normal));
> 	local_irq_restore(flags);
> }
> EXPORT_SYMBOL_GPL(call_rcu);
> 
> /**
>  * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
>  * @head: structure to be used for queueing the RCU updates.
>  * @func: actual update function to be invoked after the grace period
>  *
>  * The update function will be invoked some time after a full grace
>  * period elapses, in other words after all currently executing RCU
>  * read-side critical sections have completed. call_rcu_bh() assumes
>  * that the read-side critical sections end on completion of a softirq
>  * handler. This means that read-side critical sections in process
>  * context must not be interrupted by softirqs. This interface is to be
>  * used when most of the read-side critical sections are in softirq context.
>  * RCU read-side critical sections are delimited by rcu_read_lock() and
>  * rcu_read_unlock(), * if in interrupt context or rcu_read_lock_bh()
>  * and rcu_read_unlock_bh(), if in process context. These may be nested.
>  */
> void call_rcu_bh(struct rcu_head *head,
> 				void (*func)(struct rcu_head *rcu))
> {
> 	unsigned long flags;
> 
> 	head->func = func;
> 	local_irq_save(flags);
> 	__call_rcu(head, &rcu_global_state_bh, &__get_cpu_var(rcu_cpudata_bh));
> 	local_irq_restore(flags);
> }
> EXPORT_SYMBOL_GPL(call_rcu_bh);
> 
> #ifdef CONFIG_HOTPLUG_CPU
> 
> /**
>  * rcu_bulk_add - bulk add new rcu objects.
>  * @rgs: global rcu state
>  * @rcs: cpu state
>  * @h: linked list of rcu objects.
>  *
>  * Must be called with enabled local interrupts
>  */
> static void rcu_bulk_add(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, struct rcu_head *h, struct rcu_head **htail, int len)
> {
> 
> 	BUG_ON(irqs_disabled());
> 
> 	if (len > 0) {
> 		local_irq_disable();
> 		if (rcs->new) {
> 			(*htail) = rcs->new;
> 			rcs->new = h;
> 		} else {
> 			rcs->new = h;
> 			rcs->newtail = htail;
> 		}
> 		rcu_checkqlen(rgs, rcs, len);
> 		local_irq_enable();
> 	}
> }
> 
> #define RCU_BATCH_MIN		100
> #define	RCU_BATCH_INCFACTOR	2
> #define RCU_BATCH_DECFACTOR	4
> 
> static void rcu_move_and_raise(struct rcu_cpu_state *rcs)
> {
> 	struct rcu_cpu_dead *rcd = &per_cpu(rcu_cpudata_dead, smp_processor_id());
> 
> 	BUG_ON(!irqs_disabled());
> 
> 	/* update batch limit:
> 	 * - if there are still old entries when new entries are added:
> 	 *   double the batch count.
> 	 * - if there are no old entries: reduce it by 25%, but never below 100.
> 	 */
> 	if (rcd->deadqlen)
> 		rcd->batchcount = rcd->batchcount*RCU_BATCH_INCFACTOR;
> 	 else
> 		rcd->batchcount = rcd->batchcount-rcd->batchcount/RCU_BATCH_DECFACTOR;
> 	if (rcd->batchcount < RCU_BATCH_MIN)
> 		rcd->batchcount = RCU_BATCH_MIN;
> 
> 	if (rcs->oldqlen) {
> 		(*rcs->oldtail) = rcd->dead;
> 		rcd->dead = rcs->old;
> 		rcd->deadqlen += rcs->oldqlen;
> 		rcs->old = NULL;
> 		rcs->oldtail = NULL;
> 		rcs->oldqlen = 0;
> 	} 
> 	BUG_ON(rcs->old);
> 	BUG_ON(rcs->oldtail);
> 	BUG_ON(rcs->oldqlen);
> 	raise_softirq(RCU_SOFTIRQ);
> }
> 
> static void rcu_state_machine(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int is_quiet)
> {
> 	int inc_state;
> 	unsigned seq;
> 	unsigned long flags;
> 
> 	inc_state = 0;
> 	do {
> 		seq = read_seqbegin(&rgs->lock);
> 		local_irq_save(flags);
> 		if (rgs->state != rcs->state) {
> 			inc_state = 0;
> 			switch(rgs->state) {
> 			case RCU_STATE_DESTROY:
> 				rcs->state = rgs->state;
> 				rcu_move_and_raise(rcs);
> 				break;
> 			case RCU_STATE_DESTROY_AND_COLLECT:
> 				rcs->state = rgs->state;
> 				rcu_move_and_raise(rcs);
> 				rcs->old = rcs->new;
> 				rcs->oldtail = rcs->newtail;
> 				rcs->oldqlen = rcs->newqlen;
> 				rcs->new = NULL;
> 				rcs->newtail = NULL;
> 				rcs->newqlen = 0;
> 				if (rcu_cpumask_clear_and_test(&rgs->cpus, smp_processor_id()))
> 					inc_state = 1;
> 				break;
> 			case RCU_STATE_GRACE: 
> 				if (is_quiet) {
> 					rcs->state = rgs->state;
> 					if (rcu_cpumask_clear_and_test(&rgs->cpus, smp_processor_id()))
> 						inc_state = 1;
> 				}
> 				break;
> 			default:
> 				BUG();
> 			}
> 		}
> 		local_irq_restore(flags);
> 	} while (read_seqretry(&rgs->lock, seq));
> 
> 	
> 	if (unlikely(inc_state)) {
> 		local_irq_save(flags);
> 		write_seqlock(&rgs->lock);
> 		/*
> 		 * double check for races: If e.g. a new cpu starts up it
> 		 * will call the state machine although it's not listed in the
> 		 * cpumasks. Then multiple cpu could could see the cleared bitmask
> 		 * and try to advance the state. In this case, only the first
> 		 * cpu does something, the remaining incs are ignored.
> 		 */
> 		if (rgs->state == rcs->state) {
> 			/*
> 			 * advance the state machine:
> 			 * - from COLLECT to GRACE
> 			 * - from GRACE to DESTROY/COLLECT
> 			 */
> 			switch(rgs->state) {
> 			case RCU_STATE_DESTROY_AND_COLLECT:
> 				rgs->state = RCU_STATE_GRACE;
> 				rcu_cpumask_init(&rgs->cpus);
> 				break;
> 			case RCU_STATE_GRACE:
> 				rgs->completed++;
> 				if (rgs->start_immediately) {
> 					rgs->state = RCU_STATE_DESTROY_AND_COLLECT;
> 					rcu_cpumask_init(&rgs->cpus);
> 				} else {
> 					rgs->state = RCU_STATE_DESTROY;
> 				}
> 				rgs->start_immediately = 0;
> 				break;
> 			default:
> 				BUG();
> 			}
> 		}
> 		write_sequnlock(&rgs->lock);
> 		local_irq_restore(flags);
> 	}
> }
> 
> static void __rcu_offline_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *this_rcs,
> 					struct rcu_cpu_state *other_rcs, int cpu)
> {
> 	/* task 1: move all entries from the new cpu into the lists of the current cpu.
> 	 * locking: The other cpu is dead, thus no locks are required.
> 	 *  Thus it's more or less a bulk call_rcu().
> 	 * For the sake of simplicity, all objects are treated as "new", even the objects
> 	 * that are already in old.
> 	 */
> 	rcu_bulk_add(rgs, this_rcs, other_rcs->new, other_rcs->newtail, other_rcs->newqlen);
> 	rcu_bulk_add(rgs, this_rcs, other_rcs->old, other_rcs->oldtail, other_rcs->oldqlen);
> 
> 
> 	/* task 2: handle the cpu bitmask of the other cpu
> 	 * We know that the other cpu is dead, thus it's guaranteed not to be holding
> 	 * any pointers to rcu protected objects.
> 	 */
> 
> 	rcu_state_machine(rgs, other_rcs, 1);
> }
> 
> static void rcu_offline_cpu(int cpu)
> {
> 	struct rcu_cpu_state *this_rcs_normal = &get_cpu_var(rcu_cpudata_normal);
> 	struct rcu_cpu_state *this_rcs_bh = &get_cpu_var(rcu_cpudata_bh);
> 
> 	BUG_ON(irqs_disabled());
> 
> 	__rcu_offline_cpu(&rcu_global_state_normal, this_rcs_normal,
> 					&per_cpu(rcu_cpudata_normal, cpu), cpu);
> 	__rcu_offline_cpu(&rcu_global_state_bh, this_rcs_bh,
> 					&per_cpu(rcu_cpudata_bh, cpu), cpu);
> 	put_cpu_var(rcu_cpudata_normal);
> 	put_cpu_var(rcu_cpudata_bh);
> 
> 	BUG_ON(rcu_needs_cpu(cpu));
> }
> 
> #else
> 
> static void rcu_offline_cpu(int cpu)
> {
> }
> 
> #endif
> 
> static int __rcu_pending(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs)
> {
> 	/* quick and dirty check for pending */
> 	if (rgs->state != rcs->state)
> 		return 1;
> 	return 0;
> }
> 
> /*
>  * Check to see if there is any immediate RCU-related work to be done
>  * by the current CPU, returning 1 if so.  This function is part of the
>  * RCU implementation; it is -not- an exported member of the RCU API.
>  */
> int rcu_pending(int cpu)
> {
> 	return __rcu_pending(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu)) ||
> 		__rcu_pending(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu));
> }
> 
> /*
>  * Check to see if any future RCU-related work will need to be done
>  * by the current CPU, even if none need be done immediately, returning
>  * 1 if so.  This function is part of the RCU implementation; it is -not-
>  * an exported member of the RCU API.
>  */
> int rcu_needs_cpu(int cpu)
> {
> 	struct rcu_cpu_state *rcs_normal = &per_cpu(rcu_cpudata_normal, cpu);
> 	struct rcu_cpu_state *rcs_bh = &per_cpu(rcu_cpudata_bh, cpu);
> 
> 	return !!rcs_normal->new || !!rcs_normal->old ||
> 		!!rcs_bh->new || !!rcs_bh->old ||
> 		rcu_pending(cpu);
> }
> 
> /**
>  * rcu_check_callback(cpu, user) - external entry point for grace checking
>  * @cpu: cpu id.
>  * @user: user space was interrupted.
>  *
>  * Top-level function driving RCU grace-period detection, normally
>  * invoked from the scheduler-clock interrupt.  This function simply
>  * increments counters that are read only from softirq by this same
>  * CPU, so there are no memory barriers required.
>  *
>  * This function can run with disabled local interrupts, thus all
>  * callees must use local_irq_save()
>  */
> void rcu_check_callbacks(int cpu, int user)
> {
> 	if (user ||
> 	    (idle_cpu(cpu) && !in_softirq() &&
> 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> 
> 		/*
> 		 * Get here if this CPU took its interrupt from user
> 		 * mode or from the idle loop, and if this is not a
> 		 * nested interrupt.  In this case, the CPU is in
> 		 * a quiescent state, so count it.
> 		 *
> 		 */
> 		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 1);
> 		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 1);
> 
> 	} else if (!in_softirq()) {
> 
> 		/*
> 		 * Get here if this CPU did not take its interrupt from
> 		 * softirq, in other words, if it is not interrupting
> 		 * a rcu_bh read-side critical section.  This is an _bh
> 		 * critical section, so count it.
> 		 */
> 		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 0);
> 		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 1);
> 	} else {
> 		/*
> 		 * We are interrupting something. Nevertheless - check if we should collect
> 		 * rcu objects. This can be done from arbitrary context.
> 		 */
> 		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 0);
> 		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 0);
> 	}
> }
> 
> void rcu_restart_cpu(int cpu)
> {
> 	BUG_ON(per_cpu(rcu_cpudata_normal, cpu).new != NULL);
> 	BUG_ON(per_cpu(rcu_cpudata_normal, cpu).old != NULL);
> 	per_cpu(rcu_cpudata_normal, cpu).state = RCU_STATE_DESTROY;
> 
> 	BUG_ON(per_cpu(rcu_cpudata_bh, cpu).new != NULL);
> 	BUG_ON(per_cpu(rcu_cpudata_bh, cpu).old != NULL);
> 	per_cpu(rcu_cpudata_bh, cpu).state = RCU_STATE_DESTROY;
> }
> 
> /*
>  * Invoke the completed RCU callbacks.
>  */
> static void rcu_do_batch(struct rcu_cpu_dead *rcd)
> {
> 	struct rcu_head *list;
> 	int i, count;
> 
> 	if (!rcd->deadqlen)
> 		return;
> 
> 	/* step 1: pull up to rcs->batchcount objects */
> 	BUG_ON(irqs_disabled());
> 	local_irq_disable();
> 
> 	if (rcd->deadqlen > rcd->batchcount) {
> 		struct rcu_head *walk;
> 
> 		list = rcd->dead;
> 		count = rcd->batchcount;
> 		
> 		walk = rcd->dead;
> 		for (i=0;i<count;i++)
> 			walk = walk->next;		
> 		rcd->dead = walk;
> 
> 	} else {
> 		list = rcd->dead;
> 		count = rcd->deadqlen;
> 
> 		rcd->dead = NULL;
> 	}
> 	rcd->deadqlen -= count;
> 	BUG_ON(rcd->deadqlen < 0);
> 
> 	local_irq_enable();
> 
> 	/* step 2: call the rcu callbacks */
> 
> 	for (i=0;i<count;i++) {
> 		struct rcu_head *next;
> 
> 		next = list->next;
> 		prefetch(next);
> 		list->func(list);
> 		list = next;
> 	}
> 
> 	/* step 3: if still entries left, raise the softirq again */
> 	if (rcd->deadqlen)
> 		raise_softirq(RCU_SOFTIRQ);
> }
> 
> static void rcu_process_callbacks(struct softirq_action *unused)
> {
> 	rcu_do_batch(&per_cpu(rcu_cpudata_dead, smp_processor_id()));
> }
> 
> static void rcu_init_percpu_data(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs)
> {
> 	rcs->new = rcs->old = NULL;
> 	rcs->newqlen = rcs->oldqlen = 0;
> 	rcs->state = RCU_STATE_DESTROY;
> }
> 
> static void __cpuinit rcu_online_cpu(int cpu)
> {
> 	rcu_init_percpu_data(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu));
> 	rcu_init_percpu_data(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu));
> 
> 	per_cpu(rcu_cpudata_dead, cpu).dead = NULL;
> 	per_cpu(rcu_cpudata_dead, cpu).deadqlen = 0;
> 	per_cpu(rcu_cpudata_dead, cpu).batchcount = RCU_BATCH_MIN;
> 
> 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
> }
> 
> static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> 				unsigned long action, void *hcpu)
> {
> 	long cpu = (long)hcpu;
> 
> 	switch (action) {
> 	case CPU_UP_PREPARE:
> 	case CPU_UP_PREPARE_FROZEN:
> 		rcu_online_cpu(cpu);
> 		break;
> 	case CPU_DEAD:
> 	case CPU_DEAD_FROZEN:
> 		rcu_offline_cpu(cpu);
> 		break;
> 	default:
> 		break;
> 	}
> 	return NOTIFY_OK;
> }
> 
> static struct notifier_block __cpuinitdata rcu_nb = {
> 	.notifier_call	= rcu_cpu_notify,
> };
> 
> /*
>  * Initializes rcu mechanism.  Assumed to be called early.
>  * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
>  * Note that rcu_qsctr and friends are implicitly
>  * initialized due to the choice of ``0'' for RCU_CTR_INVALID.
>  */
> void __init __rcu_init(void)
> {
> 	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
> 			(void *)(long)smp_processor_id());
> 	/* Register notifier for non-boot CPUs */
> 	register_cpu_notifier(&rcu_nb);
> }
> 
> module_param(qlowmark, int, 0);
> 
> 

> /*
>  * Read-Copy Update mechanism for mutual exclusion (classic version)
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, write to the Free Software
>  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>  *
>  * Copyright IBM Corporation, 2001
>  *
>  * Author: Dipankar Sarma <dipankar@in.ibm.com>
>  *
>  * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
>  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
>  * Papers:
>  * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
>  * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
>  *
>  * For detailed explanation of Read-Copy Update mechanism see -
>  * 		Documentation/RCU
>  *
>  * Rewrite based on a global state machine
>  * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
>  */
> 
> #ifndef __LINUX_RCUCLASSIC_H
> #define __LINUX_RCUCLASSIC_H
> 
> #include <linux/cache.h>
> #include <linux/spinlock.h>
> #include <linux/threads.h>
> #include <linux/percpu.h>
> #include <linux/cpumask.h>
> #include <linux/seqlock.h>
> #include <linux/cpumask.h>
> 
> /*
>  * cpu bitmask:
>  * default implementation, flat without hierarchy, not optimized for UP.
>  */
> 
> struct rcu_cpumask {
> 	spinlock_t lock;
> 	cpumask_t cpus;
> } ____cacheline_internodealigned_in_smp;
> 
> #define __RCU_CPUMASK_INIT(ptr) { .lock = __SPIN_LOCK_UNLOCKED(&(ptr)->lock) }
> 
> /*
>  * global state machine:
>  * - each cpu regularly check the global state and compares it with it's own local state.
>  * - if both state do not match, then the cpus do the required work and afterwards
>  *   - update their local state
>  *   - clear their bit in the cpu bitmask.
>  * The state machine is sequence lock protected. It's only read with disabled local interupts.
>  * Since all cpus must do something to complete a state change, the current state cannot
>  * jump forward by more than one state.
>  */
> 
> /* RCU_STATE_DESTROY:
>  * call callbacks that were registered by call_rcu for the objects in rcu_cpu_state.old
>  */
> #define RCU_STATE_DESTROY		1
> /* RCU_STATE_DESTROY_AND_COLLECT:
>  * - call callbacks that were registered by call_rcu for the objects in rcu_cpu_state.old
>  * - move the objects from rcu_cpu_state.new to rcu_cpu_state.new
>  */
> #define RCU_STATE_DESTROY_AND_COLLECT	2
> /* RCU_STATE_GRACE
>  * - wait for a quiescent state
>  */
> #define RCU_STATE_GRACE			3
> 
> struct rcu_global_state {
> 	seqlock_t		lock;
> 	int			state;
> 	int			start_immediately;
> 	long			completed;
> 	struct rcu_cpumask	cpus;
> } ____cacheline_internodealigned_in_smp;
> 
> struct rcu_cpu_state {
> 
> 	int state;
> 
> 	/* new objects, directly from call_rcu().
> 	 * objects are added LIFO, better for cache hits.
> 	 * the list are length-based, not NULL-terminated.
> 	 */
> 	struct rcu_head *new;	/* new objects */
> 	struct rcu_head **newtail;
> 	long            newqlen; 	 /* # of queued callbacks */
> 
> 	/* objects that are in rcu grace processing. The actual
> 	 * state depends on rgs->state.
> 	 */
> 	struct rcu_head *old;		
> 	struct rcu_head **oldtail;
> 	long            oldqlen;
> };
> 
> struct rcu_cpu_dead {
> 	/* objects that are scheduled for immediate call of
> 	 * ->func().
> 	 * objects are added FIFO, necessary for forward progress.
> 	 * only one structure for _bh and _normal.
> 	 */
> 	struct rcu_head *dead;
> 	long		deadqlen;
> 
> 	long		batchcount;
> };
> 
> DECLARE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_normal);
> DECLARE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_bh);
> DECLARE_PER_CPU(struct rcu_cpu_dead, rcu_cpudata_dead);
> 
> extern long rcu_batches_completed(void);
> extern long rcu_batches_completed_bh(void);
> 
> extern int rcu_pending(int cpu);
> extern int rcu_needs_cpu(int cpu);
> 
> #ifdef CONFIG_DEBUG_LOCK_ALLOC
> extern struct lockdep_map rcu_lock_map;
> # define rcu_read_acquire()	\
> 			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
> # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
> #else
> # define rcu_read_acquire()	do { } while (0)
> # define rcu_read_release()	do { } while (0)
> #endif
> 
> #define __rcu_read_lock() \
> 	do { \
> 		preempt_disable(); \
> 		__acquire(RCU); \
> 		rcu_read_acquire(); \
> 	} while (0)
> #define __rcu_read_unlock() \
> 	do { \
> 		rcu_read_release(); \
> 		__release(RCU); \
> 		preempt_enable(); \
> 	} while (0)
> #define __rcu_read_lock_bh() \
> 	do { \
> 		local_bh_disable(); \
> 		__acquire(RCU_BH); \
> 		rcu_read_acquire(); \
> 	} while (0)
> #define __rcu_read_unlock_bh() \
> 	do { \
> 		rcu_read_release(); \
> 		__release(RCU_BH); \
> 		local_bh_enable(); \
> 	} while (0)
> 
> #define __synchronize_sched() synchronize_rcu()
> 
> #define call_rcu_sched(head, func) call_rcu(head, func)
> 
> extern void __rcu_init(void);
> #define rcu_init_sched()	do { } while (0)
> extern void rcu_check_callbacks(int cpu, int user);
> extern void rcu_restart_cpu(int cpu);
> 
> 
> #define rcu_enter_nohz()	do { } while (0)
> #define rcu_exit_nohz()		do { } while (0)
> 
> #define rcu_qsctr_inc(cpu)	do { } while (0)
> #define rcu_bh_qsctr_inc(cpu)	do { } while (0)
> 
> #endif /* __LINUX_RCUCLASSIC_H */

