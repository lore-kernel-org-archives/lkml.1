Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab0BYKOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:14:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:40976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045Ab0BYKOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:14:36 -0500
Date: Thu, 25 Feb 2010 10:14:01 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, mathieu.desnoyers@efficios.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-17-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-17-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Stop overflowing signed integers
Message-ID: <tip-20133cfce7d0bbdcc0c398301030c091f5675c88@git.kernel.org>
Git-Commit-ID: 20133cfce7d0bbdcc0c398301030c091f5675c88
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:14:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20133cfce7d0bbdcc0c398301030c091f5675c88
Gitweb:     http://git.kernel.org/tip/20133cfce7d0bbdcc0c398301030c091f5675c88
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:05:01 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:57 +0100

rcu: Stop overflowing signed integers

The C standard does not specify the result of an operation that
overflows a signed integer, so such operations need to be
avoided.  This patch changes the type of several fields from
"long" to "unsigned long" and adjusts operations as needed.
ULONG_CMP_GE() and ULONG_CMP_LT() macros are introduced to do
the modular comparisons that are appropriate given that overflow
is an expected event.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-17-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c       |   11 +++++------
 kernel/rcutree.h       |   33 ++++++++++++++++++---------------
 kernel/rcutree_trace.c |   14 +++++++-------
 3 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 29d88c0..dd0d31d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -500,7 +500,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	trigger_all_cpu_backtrace();
 
 	spin_lock_irqsave(&rnp->lock, flags);
-	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
+	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
 		rsp->jiffies_stall =
 			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
 	spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1216,8 +1216,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
 		return;	/* Someone else is already on the job. */
 	}
-	if (relaxed &&
-	    (long)(rsp->jiffies_force_qs - jiffies) >= 0)
+	if (relaxed && ULONG_CMP_GE(rsp->jiffies_force_qs, jiffies))
 		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);  /* irqs already disabled */
@@ -1295,7 +1294,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
 	 */
-	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
+	if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
 		force_quiescent_state(rsp, 1);
 
 	/*
@@ -1392,7 +1391,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 			force_quiescent_state(rsp, 0);
 		rdp->n_force_qs_snap = rsp->n_force_qs;
 		rdp->qlen_last_fqs_check = rdp->qlen;
-	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
+	} else if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
 }
@@ -1525,7 +1524,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Has an RCU GP gone long enough to send resched IPIs &c? */
 	if (rcu_gp_in_progress(rsp) &&
-	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)) {
+	    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies)) {
 		rdp->n_rp_need_fqs++;
 		return 1;
 	}
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index d9d032a..7495fed 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -92,10 +92,10 @@ struct rcu_dynticks {
 struct rcu_node {
 	spinlock_t lock;	/* Root rcu_node's lock protects some */
 				/*  rcu_state fields as well as following. */
-	long	gpnum;		/* Current grace period for this node. */
+	unsigned long gpnum;	/* Current grace period for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
-	long	completed;	/* Last grace period completed for this node. */
+	unsigned long completed; /* Last GP completed for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
 	unsigned long qsmask;	/* CPUs or groups that need to switch in */
@@ -161,11 +161,11 @@ struct rcu_node {
 /* Per-CPU data for read-copy update. */
 struct rcu_data {
 	/* 1) quiescent-state and grace-period handling : */
-	long		completed;	/* Track rsp->completed gp number */
+	unsigned long	completed;	/* Track rsp->completed gp number */
 					/*  in order to detect GP end. */
-	long		gpnum;		/* Highest gp number that this CPU */
+	unsigned long	gpnum;		/* Highest gp number that this CPU */
 					/*  is aware of having started. */
-	long		passed_quiesc_completed;
+	unsigned long	passed_quiesc_completed;
 					/* Value of completed at time of qs. */
 	bool		passed_quiesc;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
@@ -221,14 +221,14 @@ struct rcu_data {
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
 	/* 5) __rcu_pending() statistics. */
-	long n_rcu_pending;		/* rcu_pending() calls since boot. */
-	long n_rp_qs_pending;
-	long n_rp_cb_ready;
-	long n_rp_cpu_needs_gp;
-	long n_rp_gp_completed;
-	long n_rp_gp_started;
-	long n_rp_need_fqs;
-	long n_rp_need_nothing;
+	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
+	unsigned long n_rp_qs_pending;
+	unsigned long n_rp_cb_ready;
+	unsigned long n_rp_cpu_needs_gp;
+	unsigned long n_rp_gp_completed;
+	unsigned long n_rp_gp_started;
+	unsigned long n_rp_need_fqs;
+	unsigned long n_rp_need_nothing;
 
 	int cpu;
 };
@@ -255,6 +255,9 @@ struct rcu_data {
 
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
+#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
+#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
+
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
  * represented in "heap" form in a dense array.  The root (first level)
@@ -283,8 +286,8 @@ struct rcu_state {
 						/*  period because */
 						/*  force_quiescent_state() */
 						/*  was running. */
-	long	gpnum;				/* Current gp number. */
-	long	completed;			/* # of last completed gp. */
+	unsigned long gpnum;			/* Current gp number. */
+	unsigned long completed;		/* # of last completed gp. */
 
 	/* End of fields guarded by root rcu_node's lock. */
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9d2c884..d45db2e 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -50,7 +50,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d pqc=%ld qp=%d",
+	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pqc=%lu qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->completed, rdp->gpnum,
@@ -105,7 +105,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%d,%s,%ld,%ld,%d,%ld,%d",
+	seq_printf(m, "%d,%s,%lu,%lu,%d,%lu,%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
 		   rdp->completed, rdp->gpnum,
@@ -155,13 +155,13 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
-	long gpnum;
+	unsigned long gpnum;
 	int level = 0;
 	int phase;
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
-	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
+	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
 		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
@@ -215,12 +215,12 @@ static const struct file_operations rcuhier_fops = {
 static int show_rcugp(struct seq_file *m, void *unused)
 {
 #ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%ld\n",
+	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%lu\n",
 		   rcu_preempt_state.completed, rcu_preempt_state.gpnum);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%ld\n",
+	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%lu\n",
 		   rcu_sched_state.completed, rcu_sched_state.gpnum);
-	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%ld\n",
+	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%lu\n",
 		   rcu_bh_state.completed, rcu_bh_state.gpnum);
 	return 0;
 }
