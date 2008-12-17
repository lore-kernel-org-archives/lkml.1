Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752120AbYLQTtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbYLQTtZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYLQTtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:49:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35348 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYLQTtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:49:12 -0500
Date: Wed, 17 Dec 2008 11:49:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
        manfred@colorfullife.com, dipankar@in.ibm.com,
        josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
        dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
        rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
        andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH -tip] v10 scalable classic RCU implementation
Message-ID: <20081217194907.GJ6674@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081202222157.GA14911@linux.vnet.ibm.com> <20081217003744.GA26660@linux.vnet.ibm.com> <20081216180313.23bcd252.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216180313.23bcd252.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 06:03:13PM -0800, Andrew Morton wrote:
> On Tue, 16 Dec 2008 16:37:44 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello!
> > 
> > This patch fixes a long-standing performance bug in classic RCU that
> > results in massive internal-to-RCU lock contention on systems with
> > more than a few hundred CPUs.  Although this patch creates a separate
> > flavor of RCU for ease of review and patch maintenance, it is intended
> > to replace classic RCU.
> > 
> > This patch still handles stress better than does mainline, so I am still
> > calling it ready for inclusion.  This patch is against the -tip tree.
> > Nevertheless, experience on an actual 1000+ CPU machine would still be
> > most welcome.
> > 
> > Most of the changes noted below were found while creating an rcutiny
> > (which should permit ejecting the current rcuclassic) and while doing
> > detailed line-by-line documentation.
> > 
> > Updates from v9 (http://lkml.org/lkml/2008/12/2/334):
> > 
> > o	Fixes from remainder of line-by-line code walkthrough,
> > 	including comment spelling, initialization, undesirable
> > 	narrowing due to type conversion, removing redundant memory
> > 	barriers, removing redundant local-variable initialization,
> > 	and removing redundant local variables.
> > 
> > 	I do not believe that any of these fixes address the CPU-hotplug
> > 	issues that Andi Kleen was seeing, but please do give it a whirl
> > 	in case the machine is smarter than I am.
> > 
> > 	A writeup from the walkthrough may be found at the following
> > 	URL, in case you are suffering from terminal insomnia or
> > 	masochism:
> > 
> > 	http://www.kernel.org/pub/linux/kernel/people/paulmck/tmp/rcutree-walkthrough.2008.12.16a.pdf
> > 
> > o	Made rcutree tracing use seq_file, as suggested some time
> > 	ago by Lai Jiangshan.
> > 
> > o	Added a .csv variant of the rcudata debugfs trace file, to allow
> > 	people having thousands of CPUs to drop the data into
> > 	a spreadsheet.	Tested with oocalc and gnumeric.  Updated
> > 	documentation to suit.
> > 
> > Updates from v8 (http://lkml.org/lkml/2008/11/15/139):
> > Updates from v7 (http://lkml.org/lkml/2008/10/10/291):
> > Updates from v6 (http://lkml.org/lkml/2008/9/23/448):
> > Updates from v5 (http://lkml.org/lkml/2008/9/15/92, bad subject line):
> > Updates from v4 for those missing v5 given its bad subject line:
> 
> It strikes me that this code is at the level of maturity where it
> should have been in linux-next months ago.

I believe that it is ready for prime time.

> > To build, start with 2.6.28-rc3, and apply:
> > 
> > 	http://www.rdrop.com/users/paulmck/patches/linux-2.6-tip.2008.11.29a.patch
> > 	http://www.rdrop.com/users/paulmck/patches/2.6.28-rc3-tip-treeRCU-7.patch
> > 
> > The former gets you to commit #29cbda77a67cf263d636feea65d3bbc9c7de2e24
> > in /tip/core/rcu in the -tip tree, and the latter is the following patch.
> > 
> > Thoughts?
> 
> Merge it?

Works for me!  ;-)

> > +choice
> > +	prompt "RCU Implementation"
> > +	default CLASSIC_RCU
> 
> But toggle that.

Fair enough.

> > +config CLASSIC_RCU
> > +	bool "Classic RCU"
> > +	help
> > +	  This option selects the classic RCU implementation that is
> > +	  designed for best read-side performance on non-realtime
> > +	  systems.
> > +	  
> > +	  Select this option if you are unsure.
> > +
> > +config TREE_RCU
> > +	bool "Tree-based hierarchical RCU"
> > +	help
> > +	  This option selects the RCU implementation that is
> > +	  designed for very large SMP system with hundreds or
> > +	  thousands of CPUs.
> > +
> 
> If it blows up, we can trivially disable it in config, yes?

Yep, just select CLASSIC_RCU.

> > Documentation/RCU/00-INDEX             |    2 
> > Documentation/RCU/trace.txt            |  413 ++++++++
> > arch/powerpc/platforms/pseries/rtasd.c |    4 
> > include/linux/hardirq.h                |   14 
> > include/linux/rcupdate.h               |   10 
> > include/linux/rcutree.h                |  329 +++++++
> > init/Kconfig                           |   18 
> > kernel/Kconfig.preempt                 |   62 +
> > kernel/Makefile                        |    6 
> > kernel/rcupreempt.c                    |   10 
> > kernel/rcupreempt_trace.c              |   10 
> > kernel/rcutree.c                       | 1535 +++++++++++++++++++++++++++++++++
> > kernel/rcutree_trace.c                 |  271 +++++
> > kernel/softirq.c                       |    5 
> > lib/Kconfig.debug                      |   13 
> > 15 files changed, 2671 insertions(+), 31 deletions(-)
> 
> What's the plan for removal of the classic RCU code?  (asap, please. 
> No more slabs!)

I was thinking in terms of the following patch (untested).  Given that
Classic RCU has some issues with CPU hotplug and dynticks, sooner would
be better than later.  I am OK with immediately applying the following
on top of v10, but if people want to hold off for a bit, I am also OK
leaving Classic RCU in for a release or two.

							Thanx, Paul

Remove Classic RCU and make the default RCU implementation be TREE_RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 b/include/linux/rcupdate.h |    4 
 b/kernel/Kconfig.preempt   |   14 
 b/kernel/Makefile          |    1 
 include/linux/rcuclassic.h |  184 ----------
 kernel/rcuclassic.c        |  786 ---------------------------------------------
 5 files changed, 4 insertions(+), 985 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
deleted file mode 100644
index 301dda8..0000000
--- a/include/linux/rcuclassic.h
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- * Read-Copy Update mechanism for mutual exclusion (classic version)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright IBM Corporation, 2001
- *
- * Author: Dipankar Sarma <dipankar@in.ibm.com>
- *
- * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
- * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
- * Papers:
- * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
- * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
- *
- * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU
- *
- */
-
-#ifndef __LINUX_RCUCLASSIC_H
-#define __LINUX_RCUCLASSIC_H
-
-#include <linux/cache.h>
-#include <linux/spinlock.h>
-#include <linux/threads.h>
-#include <linux/percpu.h>
-#include <linux/cpumask.h>
-#include <linux/seqlock.h>
-
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK	(10 * HZ) /* for rcp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK	(30 * HZ) /* for rcp->jiffies_stall */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-/* Global control variables for rcupdate callback mechanism. */
-struct rcu_ctrlblk {
-	long	cur;		/* Current batch number.                      */
-	long	completed;	/* Number of the last completed batch         */
-	long	pending;	/* Number of the last pending batch           */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	unsigned long gp_start;	/* Time at which GP started in jiffies. */
-	unsigned long jiffies_stall;
-				/* Time at which to check for CPU stalls. */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-	int	signaled;
-
-	spinlock_t	lock	____cacheline_internodealigned_in_smp;
-	cpumask_t	cpumask; /* CPUs that need to switch in order    */
-				 /* for current batch to proceed.        */
-} ____cacheline_internodealigned_in_smp;
-
-/* Is batch a before batch b ? */
-static inline int rcu_batch_before(long a, long b)
-{
-	return (a - b) < 0;
-}
-
-/* Is batch a after batch b ? */
-static inline int rcu_batch_after(long a, long b)
-{
-	return (a - b) > 0;
-}
-
-/* Per-CPU data for Read-Copy UPdate. */
-struct rcu_data {
-	/* 1) quiescent state handling : */
-	long		quiescbatch;     /* Batch # for grace period */
-	int		passed_quiesc;	 /* User-mode/idle loop etc. */
-	int		qs_pending;	 /* core waits for quiesc state */
-
-	/* 2) batch handling */
-	/*
-	 * if nxtlist is not NULL, then:
-	 * batch:
-	 *	The batch # for the last entry of nxtlist
-	 * [*nxttail[1], NULL = *nxttail[2]):
-	 *	Entries that batch # <= batch
-	 * [*nxttail[0], *nxttail[1]):
-	 *	Entries that batch # <= batch - 1
-	 * [nxtlist, *nxttail[0]):
-	 *	Entries that batch # <= batch - 2
-	 *	The grace period for these entries has completed, and
-	 *	the other grace-period-completed entries may be moved
-	 *	here temporarily in rcu_process_callbacks().
-	 */
-	long  	       	batch;
-	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail[3];
-	long            qlen; 	 	 /* # of queued callbacks */
-	struct rcu_head *donelist;
-	struct rcu_head **donetail;
-	long		blimit;		 /* Upper limit on a processed batch */
-	int cpu;
-	struct rcu_head barrier;
-};
-
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
-DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
-
-/*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
- * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
- */
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-}
-static inline void rcu_bh_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
-}
-
-extern int rcu_pending(int cpu);
-extern int rcu_needs_cpu(int cpu);
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
-#else
-# define rcu_read_acquire()	do { } while (0)
-# define rcu_read_release()	do { } while (0)
-#endif
-
-#define __rcu_read_lock() \
-	do { \
-		preempt_disable(); \
-		__acquire(RCU); \
-		rcu_read_acquire(); \
-	} while (0)
-#define __rcu_read_unlock() \
-	do { \
-		rcu_read_release(); \
-		__release(RCU); \
-		preempt_enable(); \
-	} while (0)
-#define __rcu_read_lock_bh() \
-	do { \
-		local_bh_disable(); \
-		__acquire(RCU_BH); \
-		rcu_read_acquire(); \
-	} while (0)
-#define __rcu_read_unlock_bh() \
-	do { \
-		rcu_read_release(); \
-		__release(RCU_BH); \
-		local_bh_enable(); \
-	} while (0)
-
-#define __synchronize_sched() synchronize_rcu()
-
-#define call_rcu_sched(head, func) call_rcu(head, func)
-
-extern void __rcu_init(void);
-#define rcu_init_sched()	do { } while (0)
-extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
-
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);
-
-#define rcu_enter_nohz()	do { } while (0)
-#define rcu_exit_nohz()		do { } while (0)
-
-#endif /* __LINUX_RCUCLASSIC_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index bfd289a..b91ef7f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,9 +52,7 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
-#if defined(CONFIG_CLASSIC_RCU)
-#include <linux/rcuclassic.h>
-#elif defined(CONFIG_TREE_RCU)
+#if defined(CONFIG_TREE_RCU)
 #include <linux/rcutree.h>
 #elif defined(CONFIG_PREEMPT_RCU)
 #include <linux/rcupreempt.h>
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 463f297..9608115 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -54,23 +54,15 @@ endchoice
 
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
-
-config CLASSIC_RCU
-	bool "Classic RCU"
-	help
-	  This option selects the classic RCU implementation that is
-	  designed for best read-side performance on non-realtime
-	  systems.
-	  
-	  Select this option if you are unsure.
+	default TREE_RCU
 
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP system with hundreds or
-	  thousands of CPUs.
+	  thousands of CPUs.  It also scales down nicely to
+	  smaller systems.
 
 config PREEMPT_RCU
 	bool "Preemptible RCU"
diff --git a/kernel/Makefile b/kernel/Makefile
index b96ef0b..7bcdb88 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -75,7 +75,6 @@ obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
-obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
deleted file mode 100644
index e503a00..0000000
--- a/kernel/rcuclassic.c
+++ /dev/null
@@ -1,786 +0,0 @@
-/*
- * Read-Copy Update mechanism for mutual exclusion
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright IBM Corporation, 2001
- *
- * Authors: Dipankar Sarma <dipankar@in.ibm.com>
- *	    Manfred Spraul <manfred@colorfullife.com>
- *
- * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
- * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
- * Papers:
- * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
- * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
- *
- * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU
- *
- */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/rcupdate.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <asm/atomic.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/completion.h>
-#include <linux/moduleparam.h>
-#include <linux/percpu.h>
-#include <linux/notifier.h>
-#include <linux/cpu.h>
-#include <linux/mutex.h>
-#include <linux/time.h>
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-static struct lock_class_key rcu_lock_key;
-struct lockdep_map rcu_lock_map =
-	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
-EXPORT_SYMBOL_GPL(rcu_lock_map);
-#endif
-
-
-/* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_ctrlblk = {
-	.cur = -300,
-	.completed = -300,
-	.pending = -300,
-	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
-};
-static struct rcu_ctrlblk rcu_bh_ctrlblk = {
-	.cur = -300,
-	.completed = -300,
-	.pending = -300,
-	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
-};
-
-DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
-
-static int blimit = 10;
-static int qhimark = 10000;
-static int qlowmark = 100;
-
-#ifdef CONFIG_SMP
-static void force_quiescent_state(struct rcu_data *rdp,
-			struct rcu_ctrlblk *rcp)
-{
-	int cpu;
-	cpumask_t cpumask;
-	unsigned long flags;
-
-	set_need_resched();
-	spin_lock_irqsave(&rcp->lock, flags);
-	if (unlikely(!rcp->signaled)) {
-		rcp->signaled = 1;
-		/*
-		 * Don't send IPI to itself. With irqs disabled,
-		 * rdp->cpu is the current cpu.
-		 *
-		 * cpu_online_map is updated by the _cpu_down()
-		 * using __stop_machine(). Since we're in irqs disabled
-		 * section, __stop_machine() is not exectuting, hence
-		 * the cpu_online_map is stable.
-		 *
-		 * However,  a cpu might have been offlined _just_ before
-		 * we disabled irqs while entering here.
-		 * And rcu subsystem might not yet have handled the CPU_DEAD
-		 * notification, leading to the offlined cpu's bit
-		 * being set in the rcp->cpumask.
-		 *
-		 * Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
-		 * sending smp_reschedule() to an offlined CPU.
-		 */
-		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
-		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask_nr(cpu, cpumask)
-			smp_send_reschedule(cpu);
-	}
-	spin_unlock_irqrestore(&rcp->lock, flags);
-}
-#else
-static inline void force_quiescent_state(struct rcu_data *rdp,
-			struct rcu_ctrlblk *rcp)
-{
-	set_need_resched();
-}
-#endif
-
-static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
-		struct rcu_data *rdp)
-{
-	long batch;
-
-	head->next = NULL;
-	smp_mb(); /* Read of rcu->cur must happen after any change by caller. */
-
-	/*
-	 * Determine the batch number of this callback.
-	 *
-	 * Using ACCESS_ONCE to avoid the following error when gcc eliminates
-	 * local variable "batch" and emits codes like this:
-	 *	1) rdp->batch = rcp->cur + 1 # gets old value
-	 *	......
-	 *	2)rcu_batch_after(rcp->cur + 1, rdp->batch) # gets new value
-	 * then [*nxttail[0], *nxttail[1]) may contain callbacks
-	 * that batch# = rdp->batch, see the comment of struct rcu_data.
-	 */
-	batch = ACCESS_ONCE(rcp->cur) + 1;
-
-	if (rdp->nxtlist && rcu_batch_after(batch, rdp->batch)) {
-		/* process callbacks */
-		rdp->nxttail[0] = rdp->nxttail[1];
-		rdp->nxttail[1] = rdp->nxttail[2];
-		if (rcu_batch_after(batch - 1, rdp->batch))
-			rdp->nxttail[0] = rdp->nxttail[2];
-	}
-
-	rdp->batch = batch;
-	*rdp->nxttail[2] = head;
-	rdp->nxttail[2] = &head->next;
-
-	if (unlikely(++rdp->qlen > qhimark)) {
-		rdp->blimit = INT_MAX;
-		force_quiescent_state(rdp, &rcu_ctrlblk);
-	}
-}
-
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
-static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
-{
-	rcp->gp_start = jiffies;
-	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
-}
-
-static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	int cpu;
-	long delta;
-	unsigned long flags;
-
-	/* Only let one CPU complain about others per time interval. */
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	delta = jiffies - rcp->jiffies_stall;
-	if (delta < 2 || rcp->cur != rcp->completed) {
-		spin_unlock_irqrestore(&rcp->lock, flags);
-		return;
-	}
-	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-
-	/* OK, time to rat on our buddy... */
-
-	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
-	for_each_possible_cpu(cpu) {
-		if (cpu_isset(cpu, rcp->cpumask))
-			printk(" %d", cpu);
-	}
-	printk(" (detected by %d, t=%ld jiffies)\n",
-	       smp_processor_id(), (long)(jiffies - rcp->gp_start));
-}
-
-static void print_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	unsigned long flags;
-
-	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
-			smp_processor_id(), jiffies,
-			jiffies - rcp->gp_start);
-	dump_stack();
-	spin_lock_irqsave(&rcp->lock, flags);
-	if ((long)(jiffies - rcp->jiffies_stall) >= 0)
-		rcp->jiffies_stall =
-			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-	set_need_resched();  /* kick ourselves to get things going. */
-}
-
-static void check_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	long delta;
-
-	delta = jiffies - rcp->jiffies_stall;
-	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
-
-		/* We haven't checked in, so go dump stack. */
-		print_cpu_stall(rcp);
-
-	} else if (rcp->cur != rcp->completed && delta >= 2) {
-
-		/* They had two seconds to dump stack, so complain. */
-		print_other_cpu_stall(rcp);
-	}
-}
-
-#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
-{
-}
-
-static inline void check_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-/**
- * call_rcu - Queue an RCU callback for invocation after a grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
- *
- * The update function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
- */
-void call_rcu(struct rcu_head *head,
-				void (*func)(struct rcu_head *rcu))
-{
-	unsigned long flags;
-
-	head->func = func;
-	local_irq_save(flags);
-	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(call_rcu);
-
-/**
- * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
- *
- * The update function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed. call_rcu_bh() assumes
- * that the read-side critical sections end on completion of a softirq
- * handler. This means that read-side critical sections in process
- * context must not be interrupted by softirqs. This interface is to be
- * used when most of the read-side critical sections are in softirq context.
- * RCU read-side critical sections are delimited by rcu_read_lock() and
- * rcu_read_unlock(), * if in interrupt context or rcu_read_lock_bh()
- * and rcu_read_unlock_bh(), if in process context. These may be nested.
- */
-void call_rcu_bh(struct rcu_head *head,
-				void (*func)(struct rcu_head *rcu))
-{
-	unsigned long flags;
-
-	head->func = func;
-	local_irq_save(flags);
-	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(call_rcu_bh);
-
-/*
- * Return the number of RCU batches processed thus far.  Useful
- * for debug and statistics.
- */
-long rcu_batches_completed(void)
-{
-	return rcu_ctrlblk.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
-
-/*
- * Return the number of RCU batches processed thus far.  Useful
- * for debug and statistics.
- */
-long rcu_batches_completed_bh(void)
-{
-	return rcu_bh_ctrlblk.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
-
-/* Raises the softirq for processing rcu_callbacks. */
-static inline void raise_rcu_softirq(void)
-{
-	raise_softirq(RCU_SOFTIRQ);
-}
-
-/*
- * Invoke the completed RCU callbacks. They are expected to be in
- * a per-cpu list.
- */
-static void rcu_do_batch(struct rcu_data *rdp)
-{
-	unsigned long flags;
-	struct rcu_head *next, *list;
-	int count = 0;
-
-	list = rdp->donelist;
-	while (list) {
-		next = list->next;
-		prefetch(next);
-		list->func(list);
-		list = next;
-		if (++count >= rdp->blimit)
-			break;
-	}
-	rdp->donelist = list;
-
-	local_irq_save(flags);
-	rdp->qlen -= count;
-	local_irq_restore(flags);
-	if (rdp->blimit == INT_MAX && rdp->qlen <= qlowmark)
-		rdp->blimit = blimit;
-
-	if (!rdp->donelist)
-		rdp->donetail = &rdp->donelist;
-	else
-		raise_rcu_softirq();
-}
-
-/*
- * Grace period handling:
- * The grace period handling consists out of two steps:
- * - A new grace period is started.
- *   This is done by rcu_start_batch. The start is not broadcasted to
- *   all cpus, they must pick this up by comparing rcp->cur with
- *   rdp->quiescbatch. All cpus are recorded  in the
- *   rcu_ctrlblk.cpumask bitmap.
- * - All cpus must go through a quiescent state.
- *   Since the start of the grace period is not broadcasted, at least two
- *   calls to rcu_check_quiescent_state are required:
- *   The first call just notices that a new grace period is running. The
- *   following calls check if there was a quiescent state since the beginning
- *   of the grace period. If so, it updates rcu_ctrlblk.cpumask. If
- *   the bitmap is empty, then the grace period is completed.
- *   rcu_check_quiescent_state calls rcu_start_batch(0) to start the next grace
- *   period (if necessary).
- */
-
-/*
- * Register a new batch of callbacks, and start it up if there is currently no
- * active batch and the batch to be registered has not already occurred.
- * Caller must hold rcu_ctrlblk.lock.
- */
-static void rcu_start_batch(struct rcu_ctrlblk *rcp)
-{
-	if (rcp->cur != rcp->pending &&
-			rcp->completed == rcp->cur) {
-		rcp->cur++;
-		record_gp_stall_check_time(rcp);
-
-		/*
-		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
-		 * Barrier  Otherwise it can cause tickless idle CPUs to be
-		 * included in rcp->cpumask, which will extend graceperiods
-		 * unnecessarily.
-		 */
-		smp_mb();
-		cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
-
-		rcp->signaled = 0;
-	}
-}
-
-/*
- * cpu went through a quiescent state since the beginning of the grace period.
- * Clear it from the cpu mask and complete the grace period if it was the last
- * cpu. Start another grace period if someone has further entries pending
- */
-static void cpu_quiet(int cpu, struct rcu_ctrlblk *rcp)
-{
-	cpu_clear(cpu, rcp->cpumask);
-	if (cpus_empty(rcp->cpumask)) {
-		/* batch completed ! */
-		rcp->completed = rcp->cur;
-		rcu_start_batch(rcp);
-	}
-}
-
-/*
- * Check if the cpu has gone through a quiescent state (say context
- * switch). If so and if it already hasn't done so in this RCU
- * quiescent cycle, then indicate that it has done so.
- */
-static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
-					struct rcu_data *rdp)
-{
-	unsigned long flags;
-
-	if (rdp->quiescbatch != rcp->cur) {
-		/* start new grace period: */
-		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
-		rdp->quiescbatch = rcp->cur;
-		return;
-	}
-
-	/* Grace period already completed for this cpu?
-	 * qs_pending is checked instead of the actual bitmap to avoid
-	 * cacheline trashing.
-	 */
-	if (!rdp->qs_pending)
-		return;
-
-	/*
-	 * Was there a quiescent state since the beginning of the grace
-	 * period? If no, then exit and wait for the next call.
-	 */
-	if (!rdp->passed_quiesc)
-		return;
-	rdp->qs_pending = 0;
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	/*
-	 * rdp->quiescbatch/rcp->cur and the cpu bitmap can come out of sync
-	 * during cpu startup. Ignore the quiescent state.
-	 */
-	if (likely(rdp->quiescbatch == rcp->cur))
-		cpu_quiet(rdp->cpu, rcp);
-
-	spin_unlock_irqrestore(&rcp->lock, flags);
-}
-
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-/* warning! helper for rcu_offline_cpu. do not use elsewhere without reviewing
- * locking requirements, the list it's pulling from has to belong to a cpu
- * which is dead and hence not processing interrupts.
- */
-static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
-				struct rcu_head **tail, long batch)
-{
-	unsigned long flags;
-
-	if (list) {
-		local_irq_save(flags);
-		this_rdp->batch = batch;
-		*this_rdp->nxttail[2] = list;
-		this_rdp->nxttail[2] = tail;
-		local_irq_restore(flags);
-	}
-}
-
-static void __rcu_offline_cpu(struct rcu_data *this_rdp,
-				struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-
-	/*
-	 * if the cpu going offline owns the grace period
-	 * we can block indefinitely waiting for it, so flush
-	 * it here
-	 */
-	spin_lock_irqsave(&rcp->lock, flags);
-	if (rcp->cur != rcp->completed)
-		cpu_quiet(rdp->cpu, rcp);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
-	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
-	spin_unlock(&rcp->lock);
-
-	this_rdp->qlen += rdp->qlen;
-	local_irq_restore(flags);
-}
-
-static void rcu_offline_cpu(int cpu)
-{
-	struct rcu_data *this_rdp = &get_cpu_var(rcu_data);
-	struct rcu_data *this_bh_rdp = &get_cpu_var(rcu_bh_data);
-
-	__rcu_offline_cpu(this_rdp, &rcu_ctrlblk,
-					&per_cpu(rcu_data, cpu));
-	__rcu_offline_cpu(this_bh_rdp, &rcu_bh_ctrlblk,
-					&per_cpu(rcu_bh_data, cpu));
-	put_cpu_var(rcu_data);
-	put_cpu_var(rcu_bh_data);
-}
-
-#else
-
-static void rcu_offline_cpu(int cpu)
-{
-}
-
-#endif
-
-/*
- * This does the RCU processing work from softirq context.
- */
-static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
-					struct rcu_data *rdp)
-{
-	unsigned long flags;
-	long completed_snap;
-
-	if (rdp->nxtlist) {
-		local_irq_save(flags);
-		completed_snap = ACCESS_ONCE(rcp->completed);
-
-		/*
-		 * move the other grace-period-completed entries to
-		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
-		 */
-		if (!rcu_batch_before(completed_snap, rdp->batch))
-			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
-		else if (!rcu_batch_before(completed_snap, rdp->batch - 1))
-			rdp->nxttail[0] = rdp->nxttail[1];
-
-		/*
-		 * the grace period for entries in
-		 * [rdp->nxtlist, *rdp->nxttail[0]) has completed and
-		 * move these entries to donelist
-		 */
-		if (rdp->nxttail[0] != &rdp->nxtlist) {
-			*rdp->donetail = rdp->nxtlist;
-			rdp->donetail = rdp->nxttail[0];
-			rdp->nxtlist = *rdp->nxttail[0];
-			*rdp->donetail = NULL;
-
-			if (rdp->nxttail[1] == rdp->nxttail[0])
-				rdp->nxttail[1] = &rdp->nxtlist;
-			if (rdp->nxttail[2] == rdp->nxttail[0])
-				rdp->nxttail[2] = &rdp->nxtlist;
-			rdp->nxttail[0] = &rdp->nxtlist;
-		}
-
-		local_irq_restore(flags);
-
-		if (rcu_batch_after(rdp->batch, rcp->pending)) {
-			unsigned long flags2;
-
-			/* and start it/schedule start if it's a new batch */
-			spin_lock_irqsave(&rcp->lock, flags2);
-			if (rcu_batch_after(rdp->batch, rcp->pending)) {
-				rcp->pending = rdp->batch;
-				rcu_start_batch(rcp);
-			}
-			spin_unlock_irqrestore(&rcp->lock, flags2);
-		}
-	}
-
-	rcu_check_quiescent_state(rcp, rdp);
-	if (rdp->donelist)
-		rcu_do_batch(rdp);
-}
-
-static void rcu_process_callbacks(struct softirq_action *unused)
-{
-	/*
-	 * Memory references from any prior RCU read-side critical sections
-	 * executed by the interrupted code must be see before any RCU
-	 * grace-period manupulations below.
-	 */
-
-	smp_mb(); /* See above block comment. */
-
-	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
-	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
-
-	/*
-	 * Memory references from any later RCU read-side critical sections
-	 * executed by the interrupted code must be see after any RCU
-	 * grace-period manupulations above.
-	 */
-
-	smp_mb(); /* See above block comment. */
-}
-
-static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-	/* Check for CPU stalls, if enabled. */
-	check_cpu_stall(rcp);
-
-	if (rdp->nxtlist) {
-		long completed_snap = ACCESS_ONCE(rcp->completed);
-
-		/*
-		 * This cpu has pending rcu entries and the grace period
-		 * for them has completed.
-		 */
-		if (!rcu_batch_before(completed_snap, rdp->batch))
-			return 1;
-		if (!rcu_batch_before(completed_snap, rdp->batch - 1) &&
-				rdp->nxttail[0] != rdp->nxttail[1])
-			return 1;
-		if (rdp->nxttail[0] != &rdp->nxtlist)
-			return 1;
-
-		/*
-		 * This cpu has pending rcu entries and the new batch
-		 * for then hasn't been started nor scheduled start
-		 */
-		if (rcu_batch_after(rdp->batch, rcp->pending))
-			return 1;
-	}
-
-	/* This cpu has finished callbacks to invoke */
-	if (rdp->donelist)
-		return 1;
-
-	/* The rcu core waits for a quiescent state from the cpu */
-	if (rdp->quiescbatch != rcp->cur || rdp->qs_pending)
-		return 1;
-
-	/* nothing to do */
-	return 0;
-}
-
-/*
- * Check to see if there is any immediate RCU-related work to be done
- * by the current CPU, returning 1 if so.  This function is part of the
- * RCU implementation; it is -not- an exported member of the RCU API.
- */
-int rcu_pending(int cpu)
-{
-	return __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
-		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu));
-}
-
-/*
- * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  This function is part of the RCU implementation; it is -not-
- * an exported member of the RCU API.
- */
-int rcu_needs_cpu(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
-
-	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
-}
-
-/*
- * Top-level function driving RCU grace-period detection, normally
- * invoked from the scheduler-clock interrupt.  This function simply
- * increments counters that are read only from softirq by this same
- * CPU, so there are no memory barriers required.
- */
-void rcu_check_callbacks(int cpu, int user)
-{
-	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
-
-		/*
-		 * Get here if this CPU took its interrupt from user
-		 * mode or from the idle loop, and if this is not a
-		 * nested interrupt.  In this case, the CPU is in
-		 * a quiescent state, so count it.
-		 *
-		 * Also do a memory barrier.  This is needed to handle
-		 * the case where writes from a preempt-disable section
-		 * of code get reordered into schedule() by this CPU's
-		 * write buffer.  The memory barrier makes sure that
-		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
-		 * by other CPUs to happen after any such write.
-		 */
-
-		smp_mb();  /* See above block comment. */
-		rcu_qsctr_inc(cpu);
-		rcu_bh_qsctr_inc(cpu);
-
-	} else if (!in_softirq()) {
-
-		/*
-		 * Get here if this CPU did not take its interrupt from
-		 * softirq, in other words, if it is not interrupting
-		 * a rcu_bh read-side critical section.  This is an _bh
-		 * critical section, so count it.  The memory barrier
-		 * is needed for the same reason as is the above one.
-		 */
-
-		smp_mb();  /* See above block comment. */
-		rcu_bh_qsctr_inc(cpu);
-	}
-	raise_rcu_softirq();
-}
-
-static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
-						struct rcu_data *rdp)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	memset(rdp, 0, sizeof(*rdp));
-	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
-	rdp->donetail = &rdp->donelist;
-	rdp->quiescbatch = rcp->completed;
-	rdp->qs_pending = 0;
-	rdp->cpu = cpu;
-	rdp->blimit = blimit;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-}
-
-static void __cpuinit rcu_online_cpu(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
-
-	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
-	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
-}
-
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		rcu_online_cpu(cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		rcu_offline_cpu(cpu);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata rcu_nb = {
-	.notifier_call	= rcu_cpu_notify,
-};
-
-/*
- * Initializes rcu mechanism.  Assumed to be called early.
- * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
- * Note that rcu_qsctr and friends are implicitly
- * initialized due to the choice of ``0'' for RCU_CTR_INVALID.
- */
-void __init __rcu_init(void)
-{
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
-			(void *)(long)smp_processor_id());
-	/* Register notifier for non-boot CPUs */
-	register_cpu_notifier(&rcu_nb);
-}
-
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
