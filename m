Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYIEPa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYIEPa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYIEPaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:30:15 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56268 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbYIEPaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:30:08 -0400
Date: Fri, 5 Sep 2008 08:29:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       penberg@cs.helsinki.fi, andi@firstfloor.org
Subject: [PATCH, RFC] v4 scalable classic RCU implementation
Message-ID: <20080905152930.GA8124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830004935.GA28548@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Still experimental, not for inclusion.  But ready for serious experimental
use, in particular, experience on an actual >1000-CPU machine would be
most welcome.

Updates from v3:

o	The hierarchical-RCU implementation has been moved to its own
	"rcutree" set of files.  This allows configuring three different
	implementations of RCU (CLASSIC_RCU, PREEMPT_RCU, and the new
	TREE_RCU).  More importantly, it enables easy application of
	this patch to a wide variety of Linux versions.

	I hope that this implementation can completely replace Classic
	RCU, but in the meantime, this split makes for easier testing
	and review.

o	The stalled-CPU detection is now implemented and working,
	enabled by the CONFIG_RCU_CPU_STALL config parameter.  Complaints
	are kprint()ed 3 seconds into the stall, and every 30 seconds
	thereafter.  It also now attempts to force quiescent states.

o	The algorithm uses pre-fabricated masks rather than shifting
	on each access.

o	Review comments have been applied (thank you all!!!).
	For but one example, call_rcu() and call_rcu_bh() are now
	one-liners.

o	The rcu_pending() and rcu_needs_cpu() primitives are now
	much more aggressive about permitting CPUs to enter dynticks
	idle mode.  Only CPUs that have RCU callbacks are kept out
	of dynticks idle mode.

Attached is an updated patch to Classic RCU that applies a
hierarchy, greatly reducing the contention on the top-level lock
for large machines.  This passes 10-hour concurrent rcutorture and
online-offline testing on 128-CPU ppc64.  It is OK for experimental
work assuming only modestly brave experimenters (and perhaps even
cowardly experiementers), but not yet ready for inclusion.  See also
Manfred Spraul's recent patches (or his earlier work from 2004 at
http://marc.info/?l=linux-kernel&m=108546384711797&w=2).  We will
converge onto a common patch in the fullness of time, but are currently
exploring different regions of the design space.  That said, I have
already gratefully stolen a number of Manfred's ideas.

This patch provides CONFIG_RCU_FANOUT, which controls the bushiness
of the RCU hierarchy.  Defaults to 32 on 32-bit machines and 64 on
64-bit machines.  If CONFIG_NR_CPUS is less than CONFIG_RCU_FANOUT,
there is no hierarchy.  By default, the RCU initialization code will
adjust CONFIG_RCU_FANOUT to balance the hierarchy, so strongly NUMA
architectures may choose to set CONFIG_RCU_FANOUT_EXACT to disable
this balancing, allowing the hierarchy to be exactly aligned to the
underlying hardware.  Up to two levels of hierarchy are permitted
(in addition to the root node), allowing up to 16,384 CPUs on 32-bit
systems and up to 262,144 CPUs on 64-bit systems.  I just know that I
am going to regret saying this, but this seems more than sufficient
for the foreseeable future.  (Some architectures might wish to set
CONFIG_RCU_FANOUT=4, which would limit such architectures to 64 CPUs.
If this becomes a real problem, additional levels can be added, but I
doubt that it will make a significant difference on real hardware.)

In the common case, a given CPU will manipulate its private rcu_data
structure and the rcu_node structure that it shares with its immediate
neighbors.  This can reduce both lock and memory contention by multiple
orders of magnitude, which should eliminate the need for the strange
manipulations that are reported to be required when running Linux on
very large systems.

Some shortcomings:

o	Entering and leaving dynticks idle mode is a quiescent state,
	but the current patch doesn't take advantage of this (noted
	by Manfred).  It appears that it should be possible to make
	nmi_enter() and nmi_exit() provide an in_nmi(), which would make
	it possible for rcu_irq_enter() and rcu_irq_exit() to figure
	out whether it is safe to tell RCU about the quiescent state --
	and also greatly simplify the code.  However, a first attempt
	to hack this into existence failed, so will be taking a more
	measured approach.

o	There are a few places where grace periods are unnecessarily
	delayed.

o	There are probably hangs, rcutorture failures, &c.  In particular,
	the case where an interrupt from dynticks idle invokes call_rcu()
	requires a bit more thought.  And it requires NMIs to be sorted
	as noted above.

o	There are a few architectures that will sometimes execute irq
	handlers on CPUs that are already marked offline.  This is the
	subject of separate patches.  (Yes, you do have to have a very
	unlikely code construct hitting an unlikely sequence of events
	for anything bad to happen, but still needs to be fixed.)

o	Structure field layout is likely highly suboptimal.  On the other
	hand, given that the read-side primitives do not touch any of
	this data, this issue is not as pressing as it might otherwise be.

o	There is not yet a human-readable design document.  Will be fixed.

To build, start with 2.6.27-rc3, and apply:

	http://www.rdrop.com/users/paulmck/patches/2.6.27-rc3-treeRCU-2.patch

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 
 include/linux/hardirq.h  |    4 
 include/linux/rcupdate.h |    6 
 include/linux/rcutree.h  |  334 ++++++++++
 init/Kconfig             |   15 
 kernel/Kconfig.preempt   |   70 ++
 kernel/Makefile          |    6 
 kernel/rcutree.c         | 1474 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree_trace.c   |  231 +++++++
 lib/Kconfig.debug        |   13 
 9 files changed, 2135 insertions(+), 18 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 181006c..a776bf0 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,13 +118,13 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
+#if defined(CONFIG_NO_HZ)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 #else
 # define rcu_irq_enter() do { } while (0)
 # define rcu_irq_exit() do { } while (0)
-#endif /* CONFIG_PREEMPT_RCU */
+#endif /* #if defined(CONFIG_NO_HZ) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e8b4039..cffec3e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -54,8 +54,12 @@ struct rcu_head {
 
 #ifdef CONFIG_CLASSIC_RCU
 #include <linux/rcuclassic.h>
-#else /* #ifdef CONFIG_CLASSIC_RCU */
+#elif CONFIG_TREE_RCU
+#include <linux/rcutree.h>
+#elif CONFIG_PREEMPT_RCU
 #include <linux/rcupreempt.h>
+#else
+#error "Unknown RCU implementation specified to kernel configuration"
 #endif /* #else #ifdef CONFIG_CLASSIC_RCU */
 
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
new file mode 100644
index 0000000..4213009
--- /dev/null
+++ b/include/linux/rcutree.h
@@ -0,0 +1,334 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Author: Dipankar Sarma <dipankar@in.ibm.com>
+ *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical algorithm
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 	Documentation/RCU
+ */
+
+#ifndef __LINUX_RCUTREE_H
+#define __LINUX_RCUTREE_H
+
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
+#include <linux/percpu.h>
+#include <linux/cpumask.h>
+#include <linux/seqlock.h>
+
+/*
+ * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
+ * In theory, it should be possible to add more levels straightforwardly.
+ * In practice, this has not been tested, so there is probably some
+ * bug somewhere.
+ */
+#define MAX_RCU_LVLS 3
+#define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
+#define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
+#define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
+
+#if (NR_CPUS) <= RCU_FANOUT
+#  define NUM_RCU_LVLS	      1
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (NR_CPUS)
+#  define NUM_RCU_LVL_2	      0
+#  define NUM_RCU_LVL_3	      0
+#elif (NR_CPUS) <= RCU_FANOUT_SQ
+#  define NUM_RCU_LVLS	      2
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
+#  define NUM_RCU_LVL_2	      (NR_CPUS)
+#  define NUM_RCU_LVL_3	      0
+#elif (NR_CPUS) <= RCU_FANOUT_CUBE
+#  define NUM_RCU_LVLS	      3
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
+#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
+#  define NUM_RCU_LVL_3	      NR_CPUS
+#else
+# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
+#endif /* #if (NR_CPUS) <= RCU_FANOUT */
+
+#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
+#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
+
+/*
+ * Definition for node within the RCU grace-period-detection hierarchy.
+ */
+struct rcu_node {
+	spinlock_t lock;
+	unsigned long qsmask;	/* CPUs or groups that need to switch in */
+				/*  order for current grace period to proceed.*/
+	unsigned long qsmaskinit;
+				/* Per-GP initialization for qsmask. */
+	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
+	int	grplo;		/* lowest-numbered CPU or group here. */
+	int	grphi;		/* highest-numbered CPU or group here. */
+	u8	grpnum;		/* CPU/group number for next level up. */
+	u8	level;		/* root is at level 0. */
+	struct rcu_node *parent;
+} ____cacheline_internodealigned_in_smp;
+
+/* Index values for nxttail array in struct rcu_data. */
+#define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
+#define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
+#define RCU_NEXT_READY_TAIL	2	/* Also RCU_NEXT head. */
+#define RCU_NEXT_TAIL		3
+#define RCU_NEXT_SIZE		4
+
+/* Per-CPU data for read-copy update. */
+struct rcu_data {
+	/* 1) quiescent-state and grace-period handling : */
+	long		completed;	/* Track rsp->completed gp number */
+					/*  in order to detect GP end. */
+	long		gpnum;		/* Highest gp number that this CPU */
+					/*  is aware of having started. */
+	bool		passed_quiesc;	/* User-mode/idle loop etc. */
+	long		passed_quiesc_completed;
+					/* Value of completed at time of qs. */
+	bool		qs_pending;	/* Core waits for quiesc state. */
+	bool		beenonline;	/* CPU online at least once. */
+	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
+	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
+
+	/* 2) batch handling */
+	/*
+	 * If nxtlist is not NULL, it is partitioned as follows.
+	 * Any of the partitions might be empty, in which case the
+	 * pointer to that partition will be equal to the pointer for
+	 * the following partition.  When the list is empty, all of
+	 * the nxttail elements point to nxtlist, which is NULL.
+	 *
+	 * [*nxttail[RCU_NEXT_READY_TAIL], NULL = *nxttail[RCU_NEXT_TAIL]):
+	 *	Entries that might have arrived after current GP ended
+	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
+	 *	Entries known to have arrived before current GP ended
+	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
+	 *	Entries that batch # <= ->completed - 1: waiting for current GP
+	 * [nxtlist, *nxttail[RCU_DONE_TAIL]):
+	 *	Entries that batch # <= ->completed
+	 *	The grace period for these entries has completed, and
+	 *	the other grace-period-completed entries may be moved
+	 *	here temporarily in rcu_process_callbacks().
+	 */
+	struct rcu_head *nxtlist;
+	struct rcu_head **nxttail[RCU_NEXT_SIZE];
+	long		qlen; 	 	/* # of queued callbacks */
+	long		blimit;		/* Upper limit on a processed batch */
+
+	/* 3) rcu-barrier functions */
+	struct rcu_head barrier;
+
+#ifdef CONFIG_NO_HZ
+	/* 4) dynticks interface (see http://lwn.net/Articles/279077/) */
+	int dynticks_nesting;		/* Track nesting level, sort of. */
+	int dynticks;			/* Even for dynticks-idle mode. */
+	int dynticks_snap;		/* Per-GP tracking for dynticks. */
+#endif /* #ifdef CONFIG_NO_HZ */
+
+	/* 5) reasons this CPU needed to be kicked by force_quiescent_state */
+#ifdef CONFIG_NO_HZ
+	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
+#endif /* #ifdef CONFIG_NO_HZ */
+	unsigned long offline_fqs;	/* Kicked due to being offline. */
+	unsigned long resched_ipi;	/* Sent a resched IPI. */
+
+	int cpu;
+};
+
+/* Values for signaled field in struc rcu_data. */
+#define RCU_SAVE_DYNTICK	0	/* Need to scan dyntick state. */
+#define RCU_FORCE_QS		1	/* Need to force quiescent state. */
+#ifdef CONFIG_NO_HZ
+#define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
+#else /* #ifdef CONFIG_NO_HZ */
+#define RCU_SIGNAL_INIT		RCU_FORCE_QS
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#ifdef CONFIG_RCU_CPU_STALL
+#define RCU_SECONDS_TILL_STALL_CHECK	 3	/* for rsp->seconds_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK	30	/* for rsp->seconds_stall */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL */
+
+/*
+ * RCU global state, including node hierarchy.  This hierarchy is
+ * represented in "heap" form in a dense array.  The root (first level)
+ * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
+ * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
+ * and the third level in ->node[m+1] and following (->node[m+1] referenced
+ * by ->level[2]).  The number of levels is determined by the number of
+ * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
+ * consisting of a single rcu_node.
+ */
+struct rcu_state {
+	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
+	struct rcu_node *level[NUM_RCU_LVLS];	/* Hierarchy levels. */
+	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
+	u8 levelspread[NUM_RCU_LVLS];		/* kids/node in each level. */
+	struct rcu_data *rda[NR_CPUS];		/* array of rdp pointers. */
+
+	/* The following fields are guarded by the root rcu_node's lock. */
+
+	u8	signaled ____cacheline_internodealigned_in_smp;
+						/* sent GP-kick IPIs? */
+	long	gpnum;				/* Current gp number. */
+	long	completed;			/* # of last completed gp. */
+	spinlock_t onofflock;			/* exclude on/offline and */
+						/*  starting new GP. */
+	spinlock_t fqslock;			/* Only one task forcing */
+						/*  quiescent states. */
+	unsigned long jiffies_force_qs;		/* Time at which to invoke */
+						/*  force_quiescent_state(). */
+	unsigned long n_force_qs;		/* Number of calls to */
+						/*  force_quiescent_state(). */
+	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
+						/*  due to no GP active. */
+#ifdef CONFIG_RCU_CPU_STALL
+	unsigned long gp_start;			/* Time at which GP started, */
+						/*  but in jiffies. */
+	unsigned long seconds_stall;		/* Time at which to check */
+						/*  for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL */
+#ifdef CONFIG_NO_HZ
+	long dynticks_completed;		/* Value of completed @ snap. */
+#endif /* #ifdef CONFIG_NO_HZ */
+};
+
+extern struct rcu_state rcu_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_data);
+
+extern struct rcu_state rcu_bh_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+static inline void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+static inline void rcu_bh_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
+extern int rcu_pending(int cpu);
+extern int rcu_needs_cpu(int cpu);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern struct lockdep_map rcu_lock_map;
+# define rcu_read_acquire()	\
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
+# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+#else
+# define rcu_read_acquire()	do { } while (0)
+# define rcu_read_release()	do { } while (0)
+#endif
+
+#define __rcu_read_lock() \
+	do { \
+		preempt_disable(); \
+		__acquire(RCU); \
+		rcu_read_acquire(); \
+	} while (0)
+#define __rcu_read_unlock() \
+	do { \
+		rcu_read_release(); \
+		__release(RCU); \
+		preempt_enable(); \
+	} while (0)
+#define __rcu_read_lock_bh() \
+	do { \
+		local_bh_disable(); \
+		__acquire(RCU_BH); \
+		rcu_read_acquire(); \
+	} while (0)
+#define __rcu_read_unlock_bh() \
+	do { \
+		rcu_read_release(); \
+		__release(RCU_BH); \
+		local_bh_enable(); \
+	} while (0)
+
+#define __synchronize_sched() synchronize_rcu()
+
+#define call_rcu_sched(head, func) call_rcu(head, func)
+
+extern void __rcu_init(void);
+#define rcu_init_sched()	do { } while (0)
+extern void rcu_check_callbacks(int cpu, int user);
+extern void rcu_restart_cpu(int cpu);
+
+extern long rcu_batches_completed(void);
+extern long rcu_batches_completed_bh(void);
+
+#ifdef CONFIG_NO_HZ
+
+/*
+ * Enter nohz mode, in other words, -leave- the mode in which RCU
+ * read-side critical sections can occur.  (Though RCU read-side
+ * critical sections can occur in irq handlers in nohz mode, a possibility
+ * handled by rcu_irq_enter() and rcu_irq_exit()).
+ *
+ * @@@ note quiescent state???
+ */
+static inline void rcu_enter_nohz(void)
+{
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	__get_cpu_var(rcu_data).dynticks++;
+	WARN_ON_RATELIMIT(__get_cpu_var(rcu_data).dynticks & 0x1, &rs);
+	__get_cpu_var(rcu_bh_data).dynticks++;
+	WARN_ON_RATELIMIT(__get_cpu_var(rcu_bh_data).dynticks & 0x1, &rs);
+}
+
+/*
+ * Exit nohz mode.
+ */
+static inline void rcu_exit_nohz(void)
+{
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
+	__get_cpu_var(rcu_data).dynticks++;
+	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_data).dynticks & 0x1), &rs);
+	__get_cpu_var(rcu_bh_data).dynticks++;
+	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_bh_data).dynticks & 0x1), &rs);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+}
+
+#else /* CONFIG_NO_HZ */
+#define rcu_enter_nohz()	do { } while (0)
+#define rcu_exit_nohz()		do { } while (0)
+#endif /* CONFIG_NO_HZ */
+
+#endif /* __LINUX_RCUTREE_H */
diff --git a/init/Kconfig b/init/Kconfig
index b678803..82ee8f7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -914,10 +914,11 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
-config CLASSIC_RCU
-	def_bool !PREEMPT_RCU
-	help
-	  This option selects the classic RCU implementation that is
-	  designed for best read-side performance on non-realtime
-	  systems.  Classic RCU is the default.  Note that the
-	  PREEMPT_RCU symbol is used to select/deselect this option.
+config RCU_TRACE
+	def_bool TREE_RCU_TRACE || PREEMPT_RCU_TRACE
+	select DEBUG_FS
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.  Note that
+	  either RCU_TREE_TRACE or RCU_PREEMPT_TRACE is used to
+	  select/deselect this option.
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 9fdba03..86f7fb6 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -52,10 +52,29 @@ config PREEMPT
 
 endchoice
 
+choice
+	prompt "RCU Implementation"
+	default CLASSIC_RCU
+
+config CLASSIC_RCU
+	bool "Classic RCU"
+	help
+	  This option selects the classic RCU implementation that is
+	  designed for best read-side performance on non-realtime
+	  systems.
+	  
+	  Select this option if you are unsure.
+
+config TREE_RCU
+	bool "Tree-based Hierarchical RCU"
+	help
+	  This option selects the RCU implementation that is
+	  designed for very large SMP system with hundreds or
+	  thousands of CPUs.
+
 config PREEMPT_RCU
 	bool "Preemptible RCU"
 	depends on PREEMPT
-	default n
 	help
 	  This option reduces the latency of the kernel by making certain
 	  RCU sections preemptible. Normally RCU code is non-preemptible, if
@@ -64,16 +83,57 @@ config PREEMPT_RCU
 	  now-naive assumptions about each RCU read-side critical section
 	  remaining on a given CPU through its execution.
 
+endchoice
+
+config TREE_RCU_TRACE
+	bool "Enable tracing for tree-based hierarchical RCU"
+	depends on TREE_RCU
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.
+
+	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
 
-config RCU_TRACE
-	bool "Enable tracing for RCU - currently stats in debugfs"
+config PREEMPT_RCU_TRACE
+	bool "Enable tracing for preemptable RCU"
 	depends on PREEMPT_RCU
-	select DEBUG_FS
-	default y
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
 
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
+
+config RCU_FANOUT
+	int "Tree-based Hierarchical RCU fanout value"
+	range 2 64 if 64BIT
+	range 2 32 if !64BIT
+	depends on TREE_RCU
+	default 64 if 64BIT
+	default 32 if !64BIT
+	help
+	  This option controls the fanout of hierarchical implementations
+	  of RCU, allowing RCU to work efficiently on machines with
+	  large numbers of CPUs.  This value must be at least the cube
+	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
+	  systems and up to 262,144 for 64-bit systems.
+
+	  Select a specific number if testing RCU itself.
+	  Take the default if unsure.
+
+config RCU_FANOUT_EXACT
+	bool "Disable tree-based hierarchical RCU auto-balancing"
+	depends on TREE_RCU
+	default n
+	help
+	  This option forces use of the exact RCU_FANOUT value specified,
+	  regardless of imbalances in the hierarchy.  This is useful for
+	  testing RCU itself, and might one day be useful on systems with
+	  strong NUMA behavior.
+
+	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
+
+	  Say n if unsure.
+
+	
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..101e880 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -74,10 +74,10 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
+obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
-ifeq ($(CONFIG_PREEMPT_RCU),y)
-obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
-endif
+obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
+obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
new file mode 100644
index 0000000..eb10394
--- /dev/null
+++ b/kernel/rcutree.c
@@ -0,0 +1,1474 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Authors: Dipankar Sarma <dipankar@in.ibm.com>
+ *	    Manfred Spraul <manfred@colorfullife.com>
+ *	    Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical version
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 	Documentation/RCU
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/time.h>
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key rcu_lock_key;
+struct lockdep_map rcu_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
+EXPORT_SYMBOL_GPL(rcu_lock_map);
+#endif
+
+/* Data structures. */
+
+#define RCU_STATE_INITIALIZER(name) { \
+	.level = { &name.node[0] }, \
+	.levelcnt = { \
+		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
+		NUM_RCU_LVL_1, \
+		NUM_RCU_LVL_2, \
+		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
+	}, \
+	.signaled = RCU_SIGNAL_INIT, \
+	.gpnum = -300, \
+	.completed = -300, \
+	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
+	.n_force_qs = 0, \
+	.n_force_qs_ngp = 0, \
+}
+
+struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
+
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
+
+static int blimit = 10;		/* Maximum callbacks per softirq. */
+static int qhimark = 10000;	/* If this many pending, ignore blimit. */
+static int qlowmark = 100;	/* Once only this many pending, use blimit. */
+
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+
+/*
+ * Return the number of RCU batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Return the number of RCU BH batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed_bh(void)
+{
+	return rcu_bh_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
+
+/*
+ * Does the CPU have callbacks ready to be invoked?
+ */
+static int
+cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
+{
+	return &rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL];
+}
+
+/*
+ * Does the current CPU require a yet-as-unscheduled grace period?
+ */
+static int
+cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	/* ACCESS_ONCE() because we are accessing outside of lock. */
+	return *rdp->nxttail[RCU_DONE_TAIL] &&
+	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
+}
+
+/*
+ * Return the root node of the specified rcu_state structure.
+ */
+static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
+{
+	return &rsp->node[0];
+}
+
+/*
+ * If the specified CPU is offline, tell the caller that it is in
+ * a quiescent state.  Otherwise, whack it with a reschedule IPI.
+ * Grace periods can end up waiting on an offline CPU when that
+ * CPU is in the process of coming online -- it will be added to the
+ * rcu_node bitmasks before it actually makes it online.  Because this
+ * race is quite rare, we check for it after detecting that the grace
+ * period has been delayed rather than checking each and every CPU
+ * each and every time we start a new grace period.
+ */
+static int rcu_implicit_offline_qs(struct rcu_data *rdp)
+{
+	/*
+	 * If the CPU is offline, it is in a quiescent state.  We can
+	 * trust its state not to change because interrupts are disabled.
+	 */
+	if (cpu_is_offline(rdp->cpu)) {
+		rdp->offline_fqs++;
+		return 1;
+	}
+
+	/* The CPU is online, so send it a reschedule IPI. */
+	if (rdp->cpu != smp_processor_id())
+		smp_send_reschedule(rdp->cpu);
+	else
+		set_need_resched();
+	rdp->resched_ipi++;
+	return 0;
+}
+
+#ifdef CONFIG_NO_HZ
+
+/*
+ * Helper function for rcu_irq_enter().
+ */
+void __rcu_irq_enter(struct rcu_data *rdp)
+{
+	if (rdp->dynticks_nesting)
+		rdp->dynticks_nesting++;
+
+	/*
+	 * Only update if we are coming from a stopped ticks mode
+	 * (rdp->dynticks is even).
+	 */
+	if (!in_interrupt() &&
+	    (rdp->dynticks & 0x1) == 0) {
+		/*
+		 * The following might seem like we could have a race
+		 * with NMI/SMIs. But this really isn't a problem.
+		 * Here we do a read/modify/write, and the race happens
+		 * when an NMI/SMI comes in after the read and before
+		 * the write. But NMI/SMIs will increment this counter
+		 * twice before returning, so the zero bit will not
+		 * be corrupted by the NMI/SMI which is the most important
+		 * part.
+		 *
+		 * The only thing is that we would bring back the counter
+		 * to a postion that it was in during the NMI/SMI.
+		 * But the zero bit would be set, so the rest of the
+		 * counter would again be ignored.
+		 *
+		 * On return from the IRQ, the counter may have the zero
+		 * bit be 0 and the counter the same as the return from
+		 * the NMI/SMI. If the state machine was so unlucky to
+		 * see that, it still doesn't matter, since all
+		 * RCU read-side critical sections on this CPU would
+		 * have already completed.
+		 */
+		rdp->dynticks++;
+		/*
+		 * The following memory barrier ensures that any RCU
+		 * read-side critical sections in the irq handler are
+		 * seen by other CPUs to follow the above increment to
+		 * rdp->dynticks. This is required in order for other CPUs
+		 * to correctly determine when it is safe to advance the
+		 * RCU grace-period state machine.
+		 */
+		smp_mb(); /* see above block comment. */
+		/*
+		 * Since we can't determine the dynamic tick mode from
+		 * the rdp->dynticks after this routine, we use a second
+		 * flag to acknowledge that we came from an idle state
+		 * with ticks stopped.
+		 */
+		rdp->dynticks_nesting++;
+		/*
+		 * If we take an NMI/SMI now, they will also increment
+		 * the dynticks_nesting counter, and will not update the
+		 * rdp->dynticks on exit. That is for this IRQ to do.
+		 */
+	}
+}
+
+/**
+ * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
+ *
+ * If the CPU was idle with dynamic ticks active, this updates the
+ * rdp->dynticks to let the RCU handling know that the CPU is active.
+ */
+void rcu_irq_enter(void)
+{
+	__rcu_irq_enter(&__get_cpu_var(rcu_data));
+	__rcu_irq_enter(&__get_cpu_var(rcu_bh_data));
+}
+
+/*
+ * Helper function for rcu_irq_exit().
+ */
+static void __rcu_irq_exit(struct rcu_data *rdp)
+{
+	/*
+	 * rdp->dynticks_nesting is set if we interrupted the CPU
+	 * when it was idle with ticks stopped.
+	 * Once this occurs, we keep track of interrupt nesting
+	 * because a NMI/SMI could also come in, and we still
+	 * only want the IRQ that started the increment of the
+	 * rdp->dynticks to be the one that modifies it on exit.
+	 */
+	if (rdp->dynticks_nesting) {
+		if (--rdp->dynticks_nesting)
+			return;
+
+		/* This must match the interrupt nesting */
+		WARN_ON(in_interrupt());
+
+		/*
+		 * If an NMI/SMI happens now we are still
+		 * protected by the rdp->dynticks being odd.
+		 */
+
+		/*
+		 * The following memory barrier ensures that any
+		 * rcu_read_unlock() primitives in the irq handler
+		 * are seen by other CPUs to preceed the following
+		 * increment to rdp->dynticks. This is required in
+		 * order for other CPUs to determine when it is safe
+		 * to advance the RCU grace-period state machine.
+		 */
+		smp_mb(); /* see above block comment. */
+		rdp->dynticks++;
+		WARN_ON(rdp->dynticks & 0x1);
+	}
+}
+
+/**
+ * rcu_irq_exit - Called from exiting Hard irq context.
+ *
+ * If the CPU was idle with dynamic ticks active, update the rdp->dynticks
+ * to put let the RCU handling be aware that the CPU is going back to idle
+ * with no ticks.
+ */
+void rcu_irq_exit(void)
+{
+	__rcu_irq_exit(&__get_cpu_var(rcu_data));
+	__rcu_irq_exit(&__get_cpu_var(rcu_bh_data));
+}
+
+/*
+ * Record the specified "completed" value, which is later used to validate
+ * dynticks counter manipulations.  Specify "rsp->complete - 1" to
+ * unconditionally invalidate any future dynticks manipulations (which is
+ * useful at the beginning of a grace period).
+ */
+static void dyntick_record_completed(struct rcu_state *rsp, int comp)
+{
+	rsp->dynticks_completed = comp;
+}
+
+/*
+ * Recall the previously recorded value of the completion for dynticks.
+ */
+static long dyntick_recall_completed(struct rcu_state *rsp)
+{
+	return rsp->dynticks_completed;
+}
+
+/*
+ * Snapshot the specified CPU's dynticks counter so that we can later
+ * credit them with an implicit quiescent state.  Return 1 if this CPU
+ * is already in a quiescent state courtesy of dynticks idle mode.
+ */
+static int dyntick_save_progress_counter(struct rcu_data *rdp)
+{
+	int ret;
+	int snap;
+
+	snap = rdp->dynticks;
+	smp_mb();	/* Order sampling of snap with end of grace period. */
+	rdp->dynticks_snap = snap;
+	ret = (snap & 0x1) == 0;
+	if (ret)
+		rdp->dynticks_fqs++;
+	return ret;
+}
+
+/*
+ * Return true if the specified CPU has passed through a quiescent
+ * state by virtue of being in or having passed through an dynticks
+ * idle state since the last call to dyntick_save_progress_counter()
+ * for this same CPU.
+ */
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+{
+	long curr;
+	long snap;
+
+	curr = rdp->dynticks;
+	snap = rdp->dynticks_snap;
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+
+	/*
+	 * If the CPU passed through or entered a dynticks idle phase with
+	 * no active irq handlers, then we can safely pretend that the CPU
+	 * already acknowledged the request to pass through a quiescent
+	 * state.  Either way, that CPU cannot possibly be in an RCU
+	 * read-side critical section that started before the beginning
+	 * of the current RCU grace period.
+	 */
+	if ((curr - snap) >= 2 || (curr & 0x1) == 0) {
+		rdp->dynticks_fqs++;
+		return 1;
+	}
+
+	/* Go check for the CPU being offline. */
+	return rcu_implicit_offline_qs(rdp);
+}
+
+#else /* #ifdef CONFIG_NO_HZ */
+
+static void dyntick_record_completed(struct rcu_state *rsp, int comp) { }
+
+/*
+ * If there are no dynticks, then the only way that a CPU can passively
+ * be in a quiescent state is to be offline.  Unlike dynticks idle, which
+ * is a point in time during the prior (already finished) grace period,
+ * an offline CPU is always in a quiescent state, and thus can be
+ * unconditionally applied.  So just return the current value of completed.
+ */
+static long dyntick_recall_completed(struct rcu_state *rsp)
+{
+	return rsp->completed;
+}
+
+static int dyntick_save_progress_counter(struct rcu_data *rdp) { return 0; }
+
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+{
+	return rcu_implicit_offline_qs(rdp);
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#ifdef CONFIG_RCU_CPU_STALL
+
+static void record_gp_stall_check_time(struct rcu_state *rsp)
+{
+	rsp->gp_start = jiffies;
+	rsp->seconds_stall = get_seconds() + RCU_SECONDS_TILL_STALL_CHECK;
+}
+
+static void print_other_cpu_stall(struct rcu_state *rsp)
+{
+	int cpu;
+	long delta;
+	unsigned long flags;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+
+	/* Only let one CPU complain about others per time interval. */
+
+	spin_lock_irqsave(&rnp->lock, flags);
+	delta = get_seconds() - rsp->seconds_stall;
+	if (delta < 2L || rsp->gpnum != rsp->completed) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	rsp->seconds_stall = get_seconds() + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+
+	/* OK, time to rat on our buddy... */
+
+	printk(KERN_ERR "RCU detected CPU stalls:");
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		if (rnp_cur->qsmask == 0)
+			continue;
+		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
+			if (rnp_cur->qsmask & (1UL << cpu))
+				printk(" %d", rnp_cur->grplo + cpu);
+	}
+	printk(" (detected by %d, t=%ld jiffies)\n",
+	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
+	force_quiescent_state(rsp, 0);  /* Kick them all. */
+}
+
+static void print_cpu_stall(struct rcu_state *rsp)
+{
+	unsigned long flags;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu)\n",
+			smp_processor_id(), get_seconds(),
+			jiffies - rsp->gp_start);
+	dump_stack();
+	spin_lock_irqsave(&rnp->lock, flags);
+	if ((long)(get_seconds() - rsp->seconds_stall) >= 0L)
+		rsp->seconds_stall =
+			get_seconds() + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+	set_need_resched();  /* kick ourselves to get things going. */
+}
+
+static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	long delta;
+	struct rcu_node *rnp;
+
+	delta = get_seconds() - rsp->seconds_stall;
+	rnp = rdp->mynode;
+	if ((rnp->qsmask & rdp->grpmask) && delta >= 0L) {
+
+		/* We haven't checked in, so go dump stack. */
+		print_cpu_stall(rsp);
+
+	} else if (rsp->gpnum != rsp->completed && delta >= 2L) {
+
+		/* They had two seconds to dump stack, so complain. */
+		print_other_cpu_stall(rsp);
+	}
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL */
+static void record_gp_stall_check_time(struct rcu_state *rsp) { }
+static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp) { }
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL */
+
+/*
+ * Update CPU-local rcu_data state to record the newly noticed grace period.
+ * This is used both when we started the grace period and when we notice
+ * that someone else started the grace period.
+ */
+static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	rdp->qs_pending = 1;
+	rdp->passed_quiesc = 0;
+	rdp->gpnum = rsp->gpnum;
+}
+
+/*
+ * Did someone else start a new RCU grace period start since we last
+ * checked?  Update local state appropriately if so.  Must be called
+ * on the CPU corresponding to rdp.
+ */
+static int
+check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	local_irq_save(flags);
+	if (rdp->gpnum != rsp->gpnum) {
+		note_new_gpnum(rsp, rdp);
+		ret = 1;
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Start a new RCU grace period if warranted, re-initializing the hierarchy
+ * in preparation for detecting the next grace period.  The caller must hold
+ * the root node's ->lock, which is released before return.  Hard irqs must
+ * be disabled.
+ */
+static void
+rcu_start_gp(struct rcu_state *rsp, unsigned long iflg)
+	__releases(rsp->rda[smp_processor_id()]->lock)
+{
+	unsigned long flags = iflg;
+	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_cur;
+	struct rcu_node *rnp_end;
+
+	if (!cpu_needs_another_gp(rsp, rdp)) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	/* Advance to a new grace period and initialize state. */
+	rsp->gpnum++;
+	rsp->signaled = RCU_SIGNAL_INIT;
+	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
+	record_gp_stall_check_time(rsp);
+	dyntick_record_completed(rsp, rsp->completed - 1);
+	note_new_gpnum(rsp, rdp);
+
+	/*
+	 * Because we are first, we know that all our callbacks will
+	 * be covered by this upcoming grace period, even the ones
+	 * that were registered arbitrarily recently.
+	 */
+	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+	/* Special-case the common single-level case. */
+	if (NUM_RCU_NODES == 1) {
+		rnp->qsmask = rnp->qsmaskinit;
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&rnp->lock, flags);
+
+
+	/* Exclude any concurrent CPU-hotplug operations. */
+	spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/*
+	 * Set the quiescent-state-needed bits in all the non-leaf RCU
+	 * nodes for all currently online CPUs.  This operation relies
+	 * on the layout of the hierarchy within the rsp->node[] array.
+	 * Note that other CPUs will access only the leaves of the
+	 * hierarchy, which still indicate that no grace period is in
+	 * progress.  In addition, we have excluded CPU-hotplug operations.
+	 *
+	 * We therefore do not need to hold any locks.  Any required
+	 * memory barriers will be supplied by the locks guarding the
+	 * leaf rcu_nodes in the hierarchy.
+	 */
+
+	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
+	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+
+	/*
+	 * Now set up the leaf nodes.  Here we must be careful.  First,
+	 * we need to hold the lock in order to exclude other CPUs, which
+	 * might be contending for the leaf nodes' locks.  Second, as
+	 * soon as we initialize a given leaf node, its CPUs might run
+	 * up the rest of the hierarchy.  We must therefore acquire locks
+	 * for each node that we touch during this stage.  (But we still
+	 * are excluding CPU-hotplug operations.)
+	 *
+	 * Note that the grace period cannot complete until we finish
+	 * the initialization process, as there will be at least one
+	 * qsmask bit set in the root node until that time, namely the
+	 * one corresponding to this CPU.
+	 */
+	rnp_end = &rsp->node[NUM_RCU_NODES];
+	rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
+	}
+
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
+}
+
+/*
+ * Advance this CPU's callbacks, but only if the current grace period
+ * has ended.  This may be called only from the CPU to whom the rdp
+ * belongs.
+ */
+static void
+rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	long completed_snap;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	completed_snap = ACCESS_ONCE(rsp->completed);  /* outside of lock. */
+
+	/* Did another grace period end? */
+	if (rdp->completed != completed_snap) {
+
+		/* Advance callbacks.  No harm if list empty. */
+		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
+		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		/* Remember that we saw this grace-period completion. */
+		rdp->completed = completed_snap;
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Similar to cpu_quiet(), for which it is a helper function.  Allows
+ * a group of CPUs to be quieted at one go, though all the CPUs in the
+ * group must be represented by the same leaf rcu_node structure.
+ * That structure's lock must be held upon entry, and it is released
+ * before return.
+ */
+static void
+cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
+	      unsigned long flags)
+	__releases(rnp->lock)
+{
+	/* Walk up the rcu_node hierarchy. */
+	for (;;) {
+		if (!(rnp->qsmask & mask)) {
+
+			/* Our bit has already been cleared, so done. */
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		rnp->qsmask &= ~mask;
+		if (rnp->qsmask != 0) {
+
+			/* Other bits still set at this level, so done. */
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		mask = rnp->grpmask;
+		if (rnp->parent == NULL) {
+
+			/* No more levels.  Exit loop holding root lock. */
+
+			break;
+		}
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		rnp = rnp->parent;
+		spin_lock_irqsave(&rnp->lock, flags);
+	}
+
+	/*
+	 * Get here if we are the last CPU to pass through a quiescent
+	 * state for this grace period.  Clean up and let rcu_start_gp()
+	 * start up the next grace period if one is needed.  Note that
+	 * we still hold rnp->lock, as required by rcu_start_gp(), which
+	 * will release it.
+	 */
+	rsp->completed = rsp->gpnum;
+	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
+	rcu_start_gp(rsp, flags);  /* releases rnp->lock. */
+}
+
+/*
+ * Record a quiescent state for the specified CPU, which must either be
+ * the current CPU or an offline CPU.  When invoking this on one's own
+ * behalf, lastcomp is used to make sure we are still in the grace period
+ * of interest.  We don't want to end the current grace period based on
+ * quiescent states detected in an earlier grace period!  On the other hand,
+ * it the CPU being quieted is offline, we can safely pass in lastcomp==NULL,
+ * since an offline CPU is in a quiescent state with respect to any grace
+ * period, unlike pesky online CPUs, which can go non-quiescent with
+ * absolutely no warning.
+ */
+static void
+cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long *lastcomp)
+{
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp;
+
+	rnp = rdp->mynode;
+	spin_lock_irqsave(&rnp->lock, flags);
+	if (lastcomp != NULL &&
+	    *lastcomp != ACCESS_ONCE(rsp->completed)) {
+
+		/*
+		 * Someone beat us to it for this grace period, so leave.
+		 * The race with GP start is resolved by the fact that we
+		 * hold the leaf rcu_node lock, so that the per-CPU bits
+		 * cannot yet be initialized -- so we would simply find our
+		 * CPU's bit already cleared in cpu_quiet_msk() if this race
+		 * occurred.
+		 */
+		rdp->passed_quiesc = 0;	/* try again later! */
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	mask = rdp->grpmask;
+	if ((rnp->qsmask & mask) == 0L) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+	} else {
+		rdp->qs_pending = 0;
+
+		/*
+		 * This GP can't end until cpu checks in, so all of our
+		 * callbacks can be processed during the next GP.
+		 */
+		rdp = rsp->rda[smp_processor_id()];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		cpu_quiet_msk(mask, rsp, rnp, flags); /* releases rnp->lock */
+	}
+}
+
+/*
+ * Check to see if there is a new grace period of which this CPU
+ * is not yet aware, and if so, set up local rcu_data state for it.
+ * Otherwise, see if this CPU has just passed through its first
+ * quiescent state for this grace period, and record that fact if so.
+ */
+static void
+rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	/* If there is now a new grace period, record and return. */
+	if (check_for_new_grace_period(rsp, rdp))
+		return;
+
+	/*
+	 * Does this CPU still need to do its part for current grace period?
+	 * If no, return and let the other CPUs do their part as well.
+	 */
+	if (!rdp->qs_pending)
+		return;
+
+	/*
+	 * Was there a quiescent state since the beginning of the grace
+	 * period? If no, then exit and wait for the next call.
+	 */
+	if (!rdp->passed_quiesc)
+		return;
+
+	/* Tell RCU we are done (but cpu_quiet() will be the judge of that). */
+	cpu_quiet(rdp->cpu, rsp, rdp, &rdp->passed_quiesc_completed);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
+ * and move all callbacks from the outgoing CPU to the current one.
+ */
+static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
+{
+	int i;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp_me;
+	struct rcu_node *rnp;
+
+	/* Exclude any attempts to start a new grace period. */
+	spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
+	rnp = rdp->mynode;
+	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	do {
+		spin_lock(&rnp->lock);		/* irqs already disabled. */
+		rnp->qsmaskinit &= ~mask;
+		if (rnp->qsmaskinit != 0) {
+			spin_unlock(&rnp->lock); /* irqs already disabled. */
+			break;
+		}
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock);	/* irqs already disabled. */
+						/* @@@ move up to simplify. */
+		rnp = rnp->parent;
+	} while (rnp != NULL);
+
+	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
+
+	/* Being offline is a quiescent state, so go record it. */
+	cpu_quiet(cpu, rsp, rdp, NULL);
+
+	/*
+	 * Move callbacks from the outgoing CPU to the running CPU.
+	 * Note that the outgoing CPU is now quiscent, so it is now
+	 * (uncharacteristically) safe to access it rcu_data structure.
+	 * Note also that we must carefully retain the order of the
+	 * outgoing CPU's callbacks in order for rcu_barrier() to work
+	 * correctly.  Finally, note that we start all the callbacks
+	 * afresh, even those that have passed through a grace period
+	 * and are therefore ready to invoke.  The theory is that hotplug
+	 * events are rare, and that if they are frequent enough to
+	 * indefinitely delay callbacks, you have far worse things to
+	 * be worrying about.
+	 */
+	rdp_me = rsp->rda[smp_processor_id()];
+	if (rdp->nxtlist != NULL) {
+		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+		rdp->nxtlist = NULL;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			rdp->nxttail[i] = &rdp->nxtlist;
+		rdp_me->qlen += rdp->qlen;
+		rdp->qlen = 0;
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Remove the specified CPU from the RCU hierarchy and move any pending
+ * callbacks that it might have to the current CPU.  This code assumes
+ * that at least one CPU in the system will remain running at all times.
+ * Any attempt to offline -all- CPUs is likely to strand RCU callbacks.
+ */
+static void rcu_offline_cpu(int cpu)
+{
+	__rcu_offline_cpu(cpu, &rcu_state);
+	__rcu_offline_cpu(cpu, &rcu_bh_state);
+}
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static void
+rcu_offline_cpu(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
+/*
+ * Invoke any RCU callbacks that have made it to the end of their grace
+ * period.  Thottle as specified by rdp->blimit.
+ */
+static void rcu_do_batch(struct rcu_data *rdp)
+{
+	unsigned long flags;
+	struct rcu_head *next, *list, **tail;
+	int count;
+
+	/* If no callbacks are ready, just return.*/
+	if (!cpu_has_callbacks_ready_to_invoke(rdp))
+		return;
+
+	/*
+	 * Extract the list of ready callbacks, disabling to prevent
+	 * races with call_rcu() from interrupt handlers.
+	 */
+	local_irq_save(flags);
+	list = rdp->nxtlist;
+	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
+	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
+	tail = rdp->nxttail[RCU_DONE_TAIL];
+	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
+		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
+			rdp->nxttail[count] = &rdp->nxtlist;
+	local_irq_restore(flags);
+
+	/* Invoke callbacks. */
+	count = 0;
+	while (list) {
+		next = list->next;
+		prefetch(next);
+		list->func(list);
+		list = next;
+		if (++count >= rdp->blimit)
+			break;
+	}
+
+	/* Update count, and requeue any remaining callbacks. */
+	local_irq_save(flags);
+	rdp->qlen -= count;
+	if (list != NULL) {
+		*tail = rdp->nxtlist;
+		rdp->nxtlist = list;
+		for (count = 0; count < RCU_NEXT_SIZE; count++)
+			if (&rdp->nxtlist == rdp->nxttail[count])
+				rdp->nxttail[count] = tail;
+			else
+				break;
+	}
+	local_irq_restore(flags);
+
+	/* Reinstate batch limit if we have worked down the excess. */
+	if (rdp->blimit == INT_MAX && rdp->qlen <= qlowmark)
+		rdp->blimit = blimit;
+
+	/* Re-raise the RCU softirq if there are callbacks remaining. */
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Check to see if this CPU is in a non-context-switch quiescent state
+ * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
+ * Also schedule the RCU softirq handler.
+ *
+ * This function must be called with hardirqs disabled.  It is normally
+ * invoked from the scheduling-clock interrupt.  If rcu_pending returns
+ * false, there is no point in invoking rcu_check_callbacks().
+ */
+void rcu_check_callbacks(int cpu, int user)
+{
+	if (user ||
+	    (idle_cpu(cpu) && !in_softirq() &&
+				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+
+		/*
+		 * Get here if this CPU took its interrupt from user
+		 * mode or from the idle loop, and if this is not a
+		 * nested interrupt.  In this case, the CPU is in
+		 * a quiescent state, so count it.
+		 *
+		 * Also do a memory barrier.  This is needed to handle
+		 * the case where writes from a preempt-disable section
+		 * of code get reordered into schedule() by this CPU's
+		 * write buffer.  The memory barrier makes sure that
+		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
+		 * by other CPUs to happen after any such write.
+		 */
+
+		smp_mb();  /* See above block comment. */
+		rcu_qsctr_inc(cpu);
+		rcu_bh_qsctr_inc(cpu);
+
+	} else if (!in_softirq()) {
+
+		/*
+		 * Get here if this CPU did not take its interrupt from
+		 * softirq, in other words, if it is not interrupting
+		 * a rcu_bh read-side critical section.  This is an _bh
+		 * critical section, so count it.  The memory barrier
+		 * is needed for the same reason as is the above one.
+		 */
+
+		smp_mb();  /* See above block comment. */
+		rcu_bh_qsctr_inc(cpu);
+	}
+	raise_softirq(RCU_SOFTIRQ);
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * Scan the leaf rcu_node structures, processing dyntick state for any that
+ * have not yet encountered a quiescent state, using the function specified.
+ * Returns 1 if the current grace period ends while scanning (possibly
+ * because we made it end).
+ */
+static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
+			       int (*f)(struct rcu_data *))
+{
+	unsigned long bit;
+	int cpu;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		mask = 0;
+		spin_lock_irqsave(&rnp_cur->lock, flags);
+		if (rsp->completed != lastcomp) {
+			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			return 1;
+		}
+		if (rnp_cur->qsmask == 0) {
+			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			continue;
+		}
+		cpu = rnp_cur->grplo;
+		bit = 1;
+		mask = 0;
+		for (; cpu <= rnp_cur->grphi; cpu++, bit <<= 1) {
+			if ((rnp_cur->qsmask & bit) != 0L && f(rsp->rda[cpu]))
+				mask |= bit;
+		}
+		if (mask != 0 && rsp->completed == lastcomp) {
+
+			/* cpu_quiet_msk() releases rnp_cur->lock. */
+			cpu_quiet_msk(mask, rsp, rnp_cur, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&rnp_cur->lock, flags);
+	}
+	return 0;
+}
+
+/*
+ * Force quiescent states on reluctant CPUs, and also detect which
+ * CPUs are in dyntick-idle mode.
+ */
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+{
+	unsigned long flags;
+	long lastcomp;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	u8 signaled;
+
+	if (!spin_trylock_irqsave(&rsp->fqslock, flags))
+		return;	/* Someone else is already on the job. */
+	if (relaxed && (long)(rsp->jiffies_force_qs - jiffies) >= 0)
+		goto unlock_ret; /* no emergency and done recently. */
+	rsp->n_force_qs++;
+	spin_lock(&rnp->lock);
+	lastcomp = rsp->completed;
+	signaled = rsp->signaled;
+	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
+	if (rsp->completed == rsp->gpnum) {
+		rsp->n_force_qs_ngp++;
+		spin_unlock(&rnp->lock);
+		goto unlock_ret;  /* no GP in progress, time updated. */
+	}
+	spin_unlock(&rnp->lock);
+	switch (signaled) {
+	case RCU_SAVE_DYNTICK:
+
+		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
+			break; /* So gcc recognizes the dead code. */
+
+		/* Record dyntick-idle state. */
+		if (rcu_process_dyntick(rsp, lastcomp,
+					dyntick_save_progress_counter))
+			goto unlock_ret;
+
+		/* Update state, record completion counter. */
+		spin_lock(&rnp->lock);
+		if (lastcomp == rsp->completed) {
+			rsp->signaled = RCU_FORCE_QS;
+			dyntick_record_completed(rsp, lastcomp);
+		}
+		spin_unlock(&rnp->lock);
+		break;
+
+	case RCU_FORCE_QS:
+
+		/* Check dyntick-idle state, send IPI to laggarts. */
+		if (rcu_process_dyntick(rsp, dyntick_recall_completed(rsp),
+					rcu_implicit_dynticks_qs))
+			goto unlock_ret;
+
+		/* Leave state in case more forcing is required. */
+
+		break;
+	}
+unlock_ret:
+	spin_unlock_irqrestore(&rsp->fqslock, flags);
+}
+
+#else /* #ifdef CONFIG_SMP */
+
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+{
+	set_need_resched();
+}
+
+#endif /* #else #ifdef CONFIG_SMP */
+
+/*
+ * This does the RCU processing work from softirq context for the
+ * specified rcu_state and rcu_data structures.  This may be called
+ * only from the CPU to whom the rdp belongs.
+ */
+static void
+__rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+
+	/*
+	 * If an RCU GP has gone long enough, go check for dyntick
+	 * idle CPUs and, if needed, send resched IPIs.
+	 */
+	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
+	    	force_quiescent_state(rsp, 1);
+
+	/*
+	 * Advance callbacks in response to end of earlier grace
+	 * period that some other CPU ended.
+	 */
+	rcu_process_gp_end(rsp, rdp);
+
+	/* Update RCU state based on any recent quiescent states. */
+	rcu_check_quiescent_state(rsp, rdp);
+
+	/* Does this CPU require a not-yet-started grace period? */
+	if (cpu_needs_another_gp(rsp, rdp)) {
+		spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
+		rcu_start_gp(rsp, flags);  /* releases above lock */
+	}
+
+	/* If there are callbacks ready, invoke them. */
+	rcu_do_batch(rdp);
+}
+
+/*
+ * Do softirq processing for the current CPU.
+ */
+static void rcu_process_callbacks(struct softirq_action *unused)
+{
+	/*
+	 * Memory references from any prior RCU read-side critical sections
+	 * executed by the interrupted code must be seen before any RCU
+	 * grace-period manupulations below.
+	 */
+	smp_mb(); /* See above block comment. */
+
+	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
+	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+
+	/*
+	 * Memory references from any later RCU read-side critical sections
+	 * executed by the interrupted code must be seen after any RCU
+	 * grace-period manupulations above.
+	 */
+	smp_mb(); /* See above block comment. */
+}
+
+static void
+__call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
+	   struct rcu_state *rsp)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	head->func = func;
+	head->next = NULL;
+
+	smp_mb(); /* Ensure RCU update seen before callback registry. */
+
+	/*
+	 * Opportunistically note grace-period endings and beginnings.
+	 * Note that we might see a beginning right after we see an
+	 * end, but never vice versa, since this CPU has to pass through
+	 * a quiescent state betweentimes.
+	 */
+	local_irq_save(flags);
+	rdp = rsp->rda[smp_processor_id()];
+	rcu_process_gp_end(rsp, rdp);
+	check_for_new_grace_period(rsp, rdp);
+
+	*rdp->nxttail[RCU_NEXT_TAIL] = head;
+	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
+
+	if (unlikely(++rdp->qlen > qhimark)) {
+		rdp->blimit = INT_MAX;
+		force_quiescent_state(rsp, 0);
+	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
+		force_quiescent_state(rsp, 1);
+	local_irq_restore(flags);
+}
+
+/*
+ * Queue an RCU callback for invocation after a grace period.
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Queue an RCU for invocation after a quicker grace period.
+ */
+void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_bh_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+/*
+ * Check to see if there is any immediate RCU-related work to be done
+ * by the current CPU, for the specified type of RCU, returning 1 if so.
+ * The checks are in order of increasing expense: checks that can be
+ * carried out against CPU-local state are performed first.  However,
+ * we must check for CPU stalls first, else we might not get a chance.
+ */
+static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	/* Check for CPU stalls, if enabled. */
+	check_cpu_stall(rsp, rdp);
+
+	/* Is the RCU core waiting for a quiescent state from this CPU? */
+	if (rdp->qs_pending)
+		return 1;
+
+	/* Does this CPU have callbacks ready to invoke? */
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		return 1;
+
+	/* Has RCU gone idle with this CPU needing another grace period? */
+	if (cpu_needs_another_gp(rsp, rdp))
+		return 1;
+
+	/* Has another RCU grace period completed?  */
+	if (ACCESS_ONCE(rsp->completed) != rdp->completed) /* outside of lock */
+		return 1;
+
+	/* Has a new RCU grace period started? */
+	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) /* outside of lock */
+		return 1;
+
+	/* Has an RCU GP gone long enough to send resched IPIs &c? */
+	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
+		return 1;
+
+	/* nothing to do */
+	return 0;
+}
+
+/*
+ * Check to see if there is any immediate RCU-related work to be done
+ * by the current CPU, returning 1 if so.  This function is part of the
+ * RCU implementation; it is -not- an exported member of the RCU API.
+ */
+int rcu_pending(int cpu)
+{
+	return __rcu_pending(&rcu_state, &per_cpu(rcu_data, cpu)) ||
+	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
+}
+
+/*
+ * Check to see if any future RCU-related work will need to be done
+ * by the current CPU, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	/* RCU callbacks either ready or pending? */
+	return per_cpu(rcu_data, cpu).nxtlist ||
+	       per_cpu(rcu_bh_data, cpu).nxtlist;
+}
+
+/*
+ * Initialize a CPU's per-CPU RCU data.  We take this "scorched earth"
+ * approach so that we don't have to worry about how long the CPU has
+ * been gone, or whether it ever was online previously.  We do trust the
+ * ->mynode field, as it is constant for a given struct rcu_data and
+ * initialized during early boot.
+ *
+ * Note that only one online or offline event can be happening at a given
+ * time.  Note also that we can accept some slop in the rsp->completed
+ * access due to the fact that this CPU cannot possibly have any RCU
+ * callbacks in flight yet.
+ */
+static void
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	int i;
+	unsigned long mask;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/* Set up local state, ensuring consistent view of global state. */
+	spin_lock_irqsave(&rnp->lock, flags);
+	rdp->completed = rsp->completed;
+	rdp->gpnum = rsp->completed;
+	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
+	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
+	rdp->beenonline = 1;	 /* We have now been online. */
+	rdp->passed_quiesc_completed = rsp->completed - 1;
+	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen = 0;
+	rdp->blimit = blimit;
+#ifdef CONFIG_NO_HZ
+	rdp->dynticks |= 1; /* want consecutive numbers even for hotplug. */
+	rdp->dynticks_nesting = 0;
+#endif /* #ifdef CONFIG_NO_HZ */
+	rdp->cpu = cpu;
+	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+
+	/*
+	 * A new grace period might start here.  If so, we won't be part
+	 * of it, but that is OK, as we are currently in a quiescent state.
+	 */
+
+	/* Exclude any attempts to start a new GP on large systems. */
+	spin_lock(&rsp->onofflock);		/* irqs already disabled. */
+
+	/* Add CPU to rcu_node bitmasks. */
+	rnp = rdp->mynode;
+	mask = rdp->grpmask;
+	do {
+		/* Exclude any attempts to start a new GP on small systems. */
+		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		rnp->qsmaskinit |= mask;
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock); /* irqs already disabled. */
+		rnp = rnp->parent;
+	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
+
+	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
+
+	/*
+	 * A new grace period might start here.  If so, we will be part of
+	 * it, and its gpnum will be greater than ours, so we will
+	 * participate.  It is also possible for the gpnum to have been
+	 * incremented before this function was called, and the bitmasks
+	 * to not be filled out until now, in which case we will also
+	 * participate due to our gpnum being behind.
+	 */
+
+	/* Since it is coming online, the CPU is in a quiescent state. */
+	cpu_quiet(cpu, rsp, rdp, NULL);
+	local_irq_restore(flags);
+}
+
+static void __cpuinit rcu_online_cpu(int cpu)
+{
+	rcu_init_percpu_data(cpu, &rcu_state);
+	rcu_init_percpu_data(cpu, &rcu_bh_state);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
+
+/*
+ * Handle CPU online/offline notifcation events.
+ */
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+				unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		rcu_online_cpu(cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		rcu_offline_cpu(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+/*
+ * Compute the per-level fanout, either using the exact fanout specified
+ * or balancing the tree, depending on CONFIG_RCU_FANOUT_EXACT.
+ */
+#ifdef CONFIG_RCU_FANOUT_EXACT
+static void __init rcu_init_levelspread(struct rcu_state *rsp)
+{
+	int i;
+
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
+		levelspread[i] = CONFIG_RCU_FANOUT;
+	}
+	
+}
+#else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
+static void __init rcu_init_levelspread(struct rcu_state *rsp)
+{
+	int ccur;
+	int cprv;
+	int i;
+
+	cprv = NR_CPUS;
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
+		ccur = rsp->levelcnt[i];
+		rsp->levelspread[i] = (cprv + ccur - 1) / ccur;
+		cprv = ccur;
+	}
+	
+}
+#endif /* #else #ifdef CONFIG_RCU_FANOUT_EXACT */
+
+/*
+ * Helper function for rcu_init() that initializes one rcu_state structure.
+ */
+static void __init rcu_init_one(struct rcu_state *rsp)
+{
+	int cpustride = 1;
+	int i;
+	int j;
+	struct rcu_node *rnp;
+
+	/* Initialize the level-tracking arrays. */
+
+	for (i = 1; i < NUM_RCU_LVLS; i++) {
+		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
+	}
+	rcu_init_levelspread(rsp);
+
+	/* Initialize the elements themselves, starting from the leaves. */
+
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
+		cpustride *= rsp->levelspread[i];
+		rnp = rsp->level[i];
+		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
+			spin_lock_init(&rnp->lock);
+			rnp->qsmask = 0;
+			rnp->qsmaskinit = 0;
+			rnp->grplo = j * cpustride;
+			rnp->grphi = (j + 1) * cpustride - 1;
+			if (rnp->grphi >= NR_CPUS)
+				rnp->grphi = NR_CPUS - 1;
+			if (i == 0) {
+				rnp->grpnum = 0;
+				rnp->grpmask = 0;
+				rnp->parent = NULL;
+			} else {
+				rnp->grpnum = j % rsp->levelspread[i - 1];
+				rnp->grpmask = 1UL << rnp->grpnum;
+				rnp->parent = rsp->level[i - 1] + 
+					      j / rsp->levelspread[i - 1];
+			}
+			rnp->level = i;
+		}
+	}
+}
+
+/*
+ * Helper macro for __rcu_init().  To be used nowhere else!
+ * Assigns leaf node pointers into each CPU's rcu_data structure.
+ */
+#define RCU_DATA_PTR_INIT(rsp, rcu_data) \
+do { \
+	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
+	j = 0; \
+	for_each_possible_cpu(i) { \
+		if (i > rnp[j].grphi) \
+			j++; \
+		per_cpu(rcu_data, i).mynode = &rnp[j]; \
+		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
+	} \
+} while (0)
+
+static struct notifier_block __cpuinitdata rcu_nb = {
+	.notifier_call	= rcu_cpu_notify,
+};
+
+void __init __rcu_init(void)
+{
+	int i;			/* All used by RCU_DATA_PTR_INIT(). */
+	int j;
+	struct rcu_node *rnp;
+
+	printk(KERN_WARNING "Experimental hierarchical RCU implementation.\n");
+#ifdef CONFIG_DEBUG_RCU_STALL
+	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
+#endif /* #ifdef CONFIG_DEBUG_RCU_STALL */
+	rcu_init_one(&rcu_state);
+	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
+	rcu_init_one(&rcu_bh_state);
+	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
+
+	for_each_online_cpu(i)
+		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
+	/* Register notifier for non-boot CPUs */
+	register_cpu_notifier(&rcu_nb);
+	printk(KERN_WARNING "Experimental hierarchical RCU init done.\n");
+}
+
+module_param(blimit, int, 0);
+module_param(qhimark, int, 0);
+module_param(qlowmark, int, 0);
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
new file mode 100644
index 0000000..05de009
--- /dev/null
+++ b/kernel/rcutree_trace.c
@@ -0,0 +1,231 @@
+/*
+ * Read-Copy Update tracing for classic implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Papers:  http://www.rdrop.com/users/paulmck/RCU
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ *
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+
+static DEFINE_MUTEX(rcuclassic_trace_mutex);
+static char *rcuclassic_trace_buf;
+#define RCUPREEMPT_TRACE_BUF_SIZE (512*NR_CPUS)
+
+static int print_one_rcu_data(struct rcu_data *rdp, char *buf, char *ebuf)
+{
+	int cnt = 0;
+
+	if (!rdp->beenonline)
+		return 0;
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		"%3d%cc=%ld g=%ld pq=%d pqc=%ld qp=%d",
+		rdp->cpu,
+		cpu_is_offline(rdp->cpu) ? '!' : ' ',
+		rdp->completed, rdp->gpnum,
+		rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		rdp->qs_pending);
+#ifdef CONFIG_NO_HZ
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		" dt=%d df=%lu", rdp->dynticks, rdp->dynticks_fqs);
+#endif /* #ifdef CONFIG_NO_HZ */
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		" of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		" ql=%ld b=%ld\n", rdp->qlen, rdp->blimit);
+	return cnt;
+}
+
+#define PRINT_RCU_DATA(name, buf, ebuf) \
+	do { \
+		int _p_r_d_i; \
+		\
+		for_each_possible_cpu(_p_r_d_i) \
+			(buf) += print_one_rcu_data(&per_cpu(name, _p_r_d_i), \
+						    buf, ebuf); \
+	} while (0)
+
+static ssize_t rcudata_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	ssize_t bcount;
+	char *buf = rcuclassic_trace_buf;
+	char *ebuf = &rcuclassic_trace_buf[RCUPREEMPT_TRACE_BUF_SIZE];
+
+	mutex_lock(&rcuclassic_trace_mutex);
+	buf += snprintf(buf, ebuf - buf, "rcu:\n");
+	PRINT_RCU_DATA(rcu_data, buf, ebuf);
+	buf += snprintf(buf, ebuf - buf, "rcu_bh:\n");
+	PRINT_RCU_DATA(rcu_bh_data, buf, ebuf);
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
+	mutex_unlock(&rcuclassic_trace_mutex);
+	return bcount;
+}
+
+static int print_one_rcu_state(struct rcu_state *rsp, char *buf, char *ebuf)
+{
+	int cnt = 0;
+	int level = 0;
+	struct rcu_node *rnp;
+
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+			"c=%ld g=%ld s=%d jfq=%ld nfqs=%lu/nfqsng=%lu(%lu)\n",
+			rsp->completed, rsp->gpnum, rsp->signaled,
+			(long)(rsp->jiffies_force_qs - jiffies),
+			rsp->n_force_qs, rsp->n_force_qs_ngp,
+			rsp->n_force_qs - rsp->n_force_qs_ngp);
+	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
+		if (rnp->level != level) {
+			cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "\n");
+			level = rnp->level;
+		}
+		cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+				"%lx/%lx %d:%d ^%d    ",
+				rnp->qsmask, rnp->qsmaskinit,
+				rnp->grplo, rnp->grphi, rnp->grpnum);
+	}
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "\n");
+	return cnt;
+}
+
+static ssize_t rcuhier_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	ssize_t bcount;
+	char *buf = rcuclassic_trace_buf;
+	char *ebuf = &rcuclassic_trace_buf[RCUPREEMPT_TRACE_BUF_SIZE];
+
+	mutex_lock(&rcuclassic_trace_mutex);
+	buf += snprintf(buf, ebuf - buf, "rcu:\n");
+	buf += print_one_rcu_state(&rcu_state, buf, ebuf);
+	buf += snprintf(buf, ebuf - buf, "rcu_bh:\n");
+	buf += print_one_rcu_state(&rcu_bh_state, buf, ebuf);
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
+	mutex_unlock(&rcuclassic_trace_mutex);
+	return bcount;
+}
+
+static ssize_t rcugp_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	ssize_t bcount;
+	char *buf = rcuclassic_trace_buf;
+	char *ebuf = &rcuclassic_trace_buf[RCUPREEMPT_TRACE_BUF_SIZE];
+
+	mutex_lock(&rcuclassic_trace_mutex);
+	buf += snprintf(buf, ebuf - buf, "rcu: completed=%ld  gpnum=%ld\n",
+			rcu_state.completed, rcu_state.gpnum);
+	buf += snprintf(buf, ebuf - buf, "rcu_bh: completed=%ld  gpnum=%ld\n",
+			rcu_bh_state.completed, rcu_bh_state.gpnum);
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
+	mutex_unlock(&rcuclassic_trace_mutex);
+	return bcount;
+}
+
+static struct file_operations rcudata_fops = {
+	.owner = THIS_MODULE,
+	.read = rcudata_read,
+};
+
+static struct file_operations rcuhier_fops = {
+	.owner = THIS_MODULE,
+	.read = rcuhier_read,
+};
+
+static struct file_operations rcugp_fops = {
+	.owner = THIS_MODULE,
+	.read = rcugp_read,
+};
+
+static struct dentry *rcudir, *datadir, *hierdir, *gpdir;
+static int rcuclassic_debugfs_init(void)
+{
+	rcudir = debugfs_create_dir("rcu", NULL);
+	if (!rcudir)
+		goto out;
+	datadir = debugfs_create_file("rcudata", 0444, rcudir,
+						NULL, &rcudata_fops);
+	if (!datadir)
+		goto free_out;
+
+	gpdir = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
+	if (!gpdir)
+		goto free_out;
+
+	hierdir = debugfs_create_file("rcuhier", 0444, rcudir,
+						NULL, &rcuhier_fops);
+	if (!hierdir)
+		goto free_out;
+	return 0;
+free_out:
+	if (datadir)
+		debugfs_remove(datadir);
+	if (gpdir)
+		debugfs_remove(gpdir);
+	debugfs_remove(rcudir);
+out:
+	return 1;
+}
+
+static int __init rcuclassic_trace_init(void)
+{
+	int ret;
+
+	rcuclassic_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
+	if (!rcuclassic_trace_buf)
+		return 1;
+	ret = rcuclassic_debugfs_init();
+	if (ret)
+		kfree(rcuclassic_trace_buf);
+	return ret;
+}
+
+static void __exit rcuclassic_trace_cleanup(void)
+{
+	debugfs_remove(datadir);
+	debugfs_remove(gpdir);
+	debugfs_remove(hierdir);
+	debugfs_remove(rcudir);
+	kfree(rcuclassic_trace_buf);
+}
+
+
+module_init(rcuclassic_trace_init);
+module_exit(rcuclassic_trace_cleanup);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 800ac84..03df272 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -597,6 +597,19 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
+config RCU_CPU_STALL
+	bool "Check for stalled CPUs delaying RCU grace periods"
+	depends on CLASSIC_RCU || TREE_RCU
+	default n
+	help
+	  This option causes RCU to printk information on which
+	  CPUs are delaying the current grace period, but only when
+	  the grace period extends for excessive time periods.
+
+	  Say Y if you want RCU to perform such checks.
+
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
