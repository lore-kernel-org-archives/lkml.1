Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbZIOHSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbZIOHSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZIOHSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:18:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:49522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166AbZIOHSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:18:42 -0400
Date: Tue, 15 Sep 2009 07:18:10 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12528585111916-git-send-email->
References: <12528585111916-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix synchronize_rcu() for TREE_PREEMPT_RCU
Message-ID: <tip-366b04ca60c70479e2959fe8485b87ff380fdbbf@git.kernel.org>
Git-Commit-ID: 366b04ca60c70479e2959fe8485b87ff380fdbbf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 07:18:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  366b04ca60c70479e2959fe8485b87ff380fdbbf
Gitweb:     http://git.kernel.org/tip/366b04ca60c70479e2959fe8485b87ff380fdbbf
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 13 Sep 2009 09:15:11 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 08:43:59 +0200

rcu: Fix synchronize_rcu() for TREE_PREEMPT_RCU

The redirection of synchronize_sched() to synchronize_rcu() was
appropriate for TREE_RCU, but not for TREE_PREEMPT_RCU.

Fix this by creating an underlying synchronize_sched().  TREE_RCU
then redirects synchronize_rcu() to synchronize_sched(), while
TREE_PREEMPT_RCU has its own version of synchronize_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <12528585111916-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcupdate.h |   23 +++++------------------
 include/linux/rcutree.h  |    4 ++--
 kernel/rcupdate.c        |   44 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 95e0615..39dce83 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,8 +52,13 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
+#ifdef CONFIG_TREE_PREEMPT_RCU
 extern void synchronize_rcu(void);
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#define synchronize_rcu synchronize_sched
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 extern void synchronize_rcu_bh(void);
+extern void synchronize_sched(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
@@ -262,24 +267,6 @@ struct rcu_synchronize {
 extern void wakeme_after_rcu(struct rcu_head  *head);
 
 /**
- * synchronize_sched - block until all CPUs have exited any non-preemptive
- * kernel code sequences.
- *
- * This means that all preempt_disable code sequences, including NMI and
- * hardware-interrupt handlers, in progress on entry will have completed
- * before this primitive returns.  However, this does not guarantee that
- * softirq handlers will have completed, since in some kernels, these
- * handlers can run in process context, and can block.
- *
- * This primitive provides the guarantees made by the (now removed)
- * synchronize_kernel() API.  In contrast, synchronize_rcu() only
- * guarantees that rcu_read_lock() sections will have completed.
- * In "classic RCU", these two guarantees happen to be one and
- * the same, but can differ in realtime RCU implementations.
- */
-#define synchronize_sched() __synchronize_sched()
-
-/**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
  * @func: actual update function to be invoked after the grace period
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a893077..00d08c0 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -53,6 +53,8 @@ static inline void __rcu_read_unlock(void)
 	preempt_enable();
 }
 
+#define __synchronize_sched() synchronize_rcu()
+
 static inline void exit_rcu(void)
 {
 }
@@ -68,8 +70,6 @@ static inline void __rcu_read_unlock_bh(void)
 	local_bh_enable();
 }
 
-#define __synchronize_sched() synchronize_rcu()
-
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index bd5d5c8..28d2f24 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -74,6 +74,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -87,7 +89,7 @@ void synchronize_rcu(void)
 {
 	struct rcu_synchronize rcu;
 
-	if (rcu_blocking_is_gp())
+	if (!rcu_scheduler_active)
 		return;
 
 	init_completion(&rcu.completion);
@@ -98,6 +100,46 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+/**
+ * synchronize_sched - wait until an rcu-sched grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu-sched
+ * grace period has elapsed, in other words after all currently executing
+ * rcu-sched read-side critical sections have completed.   These read-side
+ * critical sections are delimited by rcu_read_lock_sched() and
+ * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
+ * local_irq_disable(), and so on may be used in place of
+ * rcu_read_lock_sched().
+ *
+ * This means that all preempt_disable code sequences, including NMI and
+ * hardware-interrupt handlers, in progress on entry will have completed
+ * before this primitive returns.  However, this does not guarantee that
+ * softirq handlers will have completed, since in some kernels, these
+ * handlers can run in process context, and can block.
+ *
+ * This primitive provides the guarantees made by the (now removed)
+ * synchronize_kernel() API.  In contrast, synchronize_rcu() only
+ * guarantees that rcu_read_lock() sections will have completed.
+ * In "classic RCU", these two guarantees happen to be one and
+ * the same, but can differ in realtime RCU implementations.
+ */
+void synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
 /**
  * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
  *
