Return-Path: <linux-kernel-owner+w=401wt.eu-S1751009AbZGXAQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbZGXAQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZGXAQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:16:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51265 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZGXAQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:16:05 -0400
Date: Thu, 23 Jul 2009 17:16:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH RFC -tip 1/4] Move private definitions from
	include/linux/rcutree.h to kernel/rcutree.h
Message-ID: <20090724001603.GA18282@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090724001429.GA17374@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724001429.GA17374@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some information hiding that makes it easier to merge preemptability
into rcutree without descending into #include hell.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcutree.h |  211 ------------------------------------------
 kernel/rcutree.c        |    2 
 kernel/rcutree.h        |  238 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree_trace.c  |    1 
 4 files changed, 241 insertions(+), 211 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index d4dfd24..e37d5e2 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,217 +30,6 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-#include <linux/cache.h>
-#include <linux/spinlock.h>
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <linux/seqlock.h>
-
-/*
- * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
- * In theory, it should be possible to add more levels straightforwardly.
- * In practice, this has not been tested, so there is probably some
- * bug somewhere.
- */
-#define MAX_RCU_LVLS 3
-#define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
-#define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
-#define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
-
-#if NR_CPUS <= RCU_FANOUT
-#  define NUM_RCU_LVLS	      1
-#  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (NR_CPUS)
-#  define NUM_RCU_LVL_2	      0
-#  define NUM_RCU_LVL_3	      0
-#elif NR_CPUS <= RCU_FANOUT_SQ
-#  define NUM_RCU_LVLS	      2
-#  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
-#  define NUM_RCU_LVL_2	      (NR_CPUS)
-#  define NUM_RCU_LVL_3	      0
-#elif NR_CPUS <= RCU_FANOUT_CUBE
-#  define NUM_RCU_LVLS	      3
-#  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
-#  define NUM_RCU_LVL_3	      NR_CPUS
-#else
-# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
-#endif /* #if (NR_CPUS) <= RCU_FANOUT */
-
-#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
-#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
-
-/*
- * Dynticks per-CPU state.
- */
-struct rcu_dynticks {
-	int dynticks_nesting;	/* Track nesting level, sort of. */
-	int dynticks;		/* Even value for dynticks-idle, else odd. */
-	int dynticks_nmi;	/* Even value for either dynticks-idle or */
-				/*  not in nmi handler, else odd.  So this */
-				/*  remains even for nmi from irq handler. */
-};
-
-/*
- * Definition for node within the RCU grace-period-detection hierarchy.
- */
-struct rcu_node {
-	spinlock_t lock;
-	unsigned long qsmask;	/* CPUs or groups that need to switch in */
-				/*  order for current grace period to proceed.*/
-	unsigned long qsmaskinit;
-				/* Per-GP initialization for qsmask. */
-	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
-	int	grplo;		/* lowest-numbered CPU or group here. */
-	int	grphi;		/* highest-numbered CPU or group here. */
-	u8	grpnum;		/* CPU/group number for next level up. */
-	u8	level;		/* root is at level 0. */
-	struct rcu_node *parent;
-} ____cacheline_internodealigned_in_smp;
-
-/* Index values for nxttail array in struct rcu_data. */
-#define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
-#define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
-#define RCU_NEXT_READY_TAIL	2	/* Also RCU_NEXT head. */
-#define RCU_NEXT_TAIL		3
-#define RCU_NEXT_SIZE		4
-
-/* Per-CPU data for read-copy update. */
-struct rcu_data {
-	/* 1) quiescent-state and grace-period handling : */
-	long		completed;	/* Track rsp->completed gp number */
-					/*  in order to detect GP end. */
-	long		gpnum;		/* Highest gp number that this CPU */
-					/*  is aware of having started. */
-	long		passed_quiesc_completed;
-					/* Value of completed at time of qs. */
-	bool		passed_quiesc;	/* User-mode/idle loop etc. */
-	bool		qs_pending;	/* Core waits for quiesc state. */
-	bool		beenonline;	/* CPU online at least once. */
-	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
-	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
-
-	/* 2) batch handling */
-	/*
-	 * If nxtlist is not NULL, it is partitioned as follows.
-	 * Any of the partitions might be empty, in which case the
-	 * pointer to that partition will be equal to the pointer for
-	 * the following partition.  When the list is empty, all of
-	 * the nxttail elements point to nxtlist, which is NULL.
-	 *
-	 * [*nxttail[RCU_NEXT_READY_TAIL], NULL = *nxttail[RCU_NEXT_TAIL]):
-	 *	Entries that might have arrived after current GP ended
-	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
-	 *	Entries known to have arrived before current GP ended
-	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
-	 *	Entries that batch # <= ->completed - 1: waiting for current GP
-	 * [nxtlist, *nxttail[RCU_DONE_TAIL]):
-	 *	Entries that batch # <= ->completed
-	 *	The grace period for these entries has completed, and
-	 *	the other grace-period-completed entries may be moved
-	 *	here temporarily in rcu_process_callbacks().
-	 */
-	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail[RCU_NEXT_SIZE];
-	long		qlen; 	 	/* # of queued callbacks */
-	long		blimit;		/* Upper limit on a processed batch */
-
-#ifdef CONFIG_NO_HZ
-	/* 3) dynticks interface. */
-	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
-	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
-#endif /* #ifdef CONFIG_NO_HZ */
-
-	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
-#ifdef CONFIG_NO_HZ
-	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
-#endif /* #ifdef CONFIG_NO_HZ */
-	unsigned long offline_fqs;	/* Kicked due to being offline. */
-	unsigned long resched_ipi;	/* Sent a resched IPI. */
-
-	/* 5) __rcu_pending() statistics. */
-	long n_rcu_pending;		/* rcu_pending() calls since boot. */
-	long n_rp_qs_pending;
-	long n_rp_cb_ready;
-	long n_rp_cpu_needs_gp;
-	long n_rp_gp_completed;
-	long n_rp_gp_started;
-	long n_rp_need_fqs;
-	long n_rp_need_nothing;
-
-	int cpu;
-};
-
-/* Values for signaled field in struct rcu_state. */
-#define RCU_GP_INIT		0	/* Grace period being initialized. */
-#define RCU_SAVE_DYNTICK	1	/* Need to scan dyntick state. */
-#define RCU_FORCE_QS		2	/* Need to force quiescent state. */
-#ifdef CONFIG_NO_HZ
-#define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
-#else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_FORCE_QS
-#endif /* #else #ifdef CONFIG_NO_HZ */
-
-#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_STALL_RAT_DELAY		2	  /* Allow other CPUs time */
-						  /*  to take at least one */
-						  /*  scheduling clock irq */
-						  /*  before ratting on them. */
-
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-/*
- * RCU global state, including node hierarchy.  This hierarchy is
- * represented in "heap" form in a dense array.  The root (first level)
- * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
- * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
- * and the third level in ->node[m+1] and following (->node[m+1] referenced
- * by ->level[2]).  The number of levels is determined by the number of
- * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
- * consisting of a single rcu_node.
- */
-struct rcu_state {
-	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
-	struct rcu_node *level[NUM_RCU_LVLS];	/* Hierarchy levels. */
-	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
-	u8 levelspread[NUM_RCU_LVLS];		/* kids/node in each level. */
-	struct rcu_data *rda[NR_CPUS];		/* array of rdp pointers. */
-
-	/* The following fields are guarded by the root rcu_node's lock. */
-
-	u8	signaled ____cacheline_internodealigned_in_smp;
-						/* Force QS state. */
-	long	gpnum;				/* Current gp number. */
-	long	completed;			/* # of last completed gp. */
-	spinlock_t onofflock;			/* exclude on/offline and */
-						/*  starting new GP. */
-	spinlock_t fqslock;			/* Only one task forcing */
-						/*  quiescent states. */
-	unsigned long jiffies_force_qs;		/* Time at which to invoke */
-						/*  force_quiescent_state(). */
-	unsigned long n_force_qs;		/* Number of calls to */
-						/*  force_quiescent_state(). */
-	unsigned long n_force_qs_lh;		/* ~Number of calls leaving */
-						/*  due to lock unavailable. */
-	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
-						/*  due to no GP active. */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	unsigned long gp_start;			/* Time at which GP started, */
-						/*  but in jiffies. */
-	unsigned long jiffies_stall;		/* Time at which to check */
-						/*  for CPU stalls. */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-#ifdef CONFIG_NO_HZ
-	long dynticks_completed;		/* Value of completed @ snap. */
-#endif /* #ifdef CONFIG_NO_HZ */
-};
-
 extern void rcu_qsctr_inc(int cpu);
 extern void rcu_bh_qsctr_inc(int cpu);
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e8e9e93..e4b5d01 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,6 +46,8 @@
 #include <linux/mutex.h>
 #include <linux/time.h>
 
+#include "rcutree.h"
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5e872bb..7cc830a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -1,3 +1,239 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ * Internal non-public definitions.
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
+ * Author: Ingo Molnar <mingo@elte.hu>
+ *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
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
+#if NR_CPUS <= RCU_FANOUT
+#  define NUM_RCU_LVLS	      1
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (NR_CPUS)
+#  define NUM_RCU_LVL_2	      0
+#  define NUM_RCU_LVL_3	      0
+#elif NR_CPUS <= RCU_FANOUT_SQ
+#  define NUM_RCU_LVLS	      2
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
+#  define NUM_RCU_LVL_2	      (NR_CPUS)
+#  define NUM_RCU_LVL_3	      0
+#elif NR_CPUS <= RCU_FANOUT_CUBE
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
+ * Dynticks per-CPU state.
+ */
+struct rcu_dynticks {
+	int dynticks_nesting;	/* Track nesting level, sort of. */
+	int dynticks;		/* Even value for dynticks-idle, else odd. */
+	int dynticks_nmi;	/* Even value for either dynticks-idle or */
+				/*  not in nmi handler, else odd.  So this */
+				/*  remains even for nmi from irq handler. */
+};
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
+	long		passed_quiesc_completed;
+					/* Value of completed at time of qs. */
+	bool		passed_quiesc;	/* User-mode/idle loop etc. */
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
+#ifdef CONFIG_NO_HZ
+	/* 3) dynticks interface. */
+	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
+	int dynticks_snap;		/* Per-GP tracking for dynticks. */
+	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
+#endif /* #ifdef CONFIG_NO_HZ */
+
+	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
+#ifdef CONFIG_NO_HZ
+	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
+#endif /* #ifdef CONFIG_NO_HZ */
+	unsigned long offline_fqs;	/* Kicked due to being offline. */
+	unsigned long resched_ipi;	/* Sent a resched IPI. */
+
+	/* 5) __rcu_pending() statistics. */
+	long n_rcu_pending;		/* rcu_pending() calls since boot. */
+	long n_rp_qs_pending;
+	long n_rp_cb_ready;
+	long n_rp_cpu_needs_gp;
+	long n_rp_gp_completed;
+	long n_rp_gp_started;
+	long n_rp_need_fqs;
+	long n_rp_need_nothing;
+
+	int cpu;
+};
+
+/* Values for signaled field in struct rcu_state. */
+#define RCU_GP_INIT		0	/* Grace period being initialized. */
+#define RCU_SAVE_DYNTICK	1	/* Need to scan dyntick state. */
+#define RCU_FORCE_QS		2	/* Need to force quiescent state. */
+#ifdef CONFIG_NO_HZ
+#define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
+#else /* #ifdef CONFIG_NO_HZ */
+#define RCU_SIGNAL_INIT		RCU_FORCE_QS
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ)  /* for rsp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ)  /* for rsp->jiffies_stall */
+#define RCU_STALL_RAT_DELAY		2	  /* Allow other CPUs time */
+						  /*  to take at least one */
+						  /*  scheduling clock irq */
+						  /*  before ratting on them. */
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
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
+						/* Force QS state. */
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
+	unsigned long n_force_qs_lh;		/* ~Number of calls leaving */
+						/*  due to lock unavailable. */
+	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
+						/*  due to no GP active. */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	unsigned long gp_start;			/* Time at which GP started, */
+						/*  but in jiffies. */
+	unsigned long jiffies_stall;		/* Time at which to check */
+						/*  for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+#ifdef CONFIG_NO_HZ
+	long dynticks_completed;		/* Value of completed @ snap. */
+#endif /* #ifdef CONFIG_NO_HZ */
+};
+
+#ifdef RCU_TREE_NONCORE
 
 /*
  * RCU implementation internal declarations:
@@ -8,3 +244,5 @@ DECLARE_PER_CPU(struct rcu_data, rcu_data);
 extern struct rcu_state rcu_bh_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+#endif /* #ifdef RCU_TREE_NONCORE */
+
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index fe1dcdb..0cb52b8 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -43,6 +43,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
+#define RCU_TREE_NONCORE
 #include "rcutree.h"
 
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
