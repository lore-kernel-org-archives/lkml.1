Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYKDI3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYKDI3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYKDI2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:28:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbYKDI2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:28:54 -0500
Message-ID: <4910070C.8010807@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 16:25:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this fix will increase about several hundred bytes to the kernel text
for rcuclassic.

but it will increase readability for rcupdate codes. and make
code tools happy(ctags, kernel-doc ...).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5f89b62..1d20922 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -166,8 +166,6 @@ extern struct lockdep_map rcu_lock_map;
 		local_bh_enable(); \
 	} while (0)
 
-#define __synchronize_sched() synchronize_rcu()
-
 #define call_rcu_sched(head, func) call_rcu(head, func)
 
 extern void __rcu_init(void);
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 86f1f5e..d2b5232 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -189,45 +189,6 @@ struct rcu_head {
 		(p) = (v); \
 	})
 
-/* Infrastructure to implement the synchronize_() primitives. */
-
-struct rcu_synchronize {
-	struct rcu_head head;
-	struct completion completion;
-};
-
-extern void wakeme_after_rcu(struct rcu_head  *head);
-
-#define synchronize_rcu_xxx(name, func) \
-void name(void) \
-{ \
-	struct rcu_synchronize rcu; \
-	\
-	init_completion(&rcu.completion); \
-	/* Will wake me after RCU finished. */ \
-	func(&rcu.head, wakeme_after_rcu); \
-	/* Wait for it. */ \
-	wait_for_completion(&rcu.completion); \
-}
-
-/**
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
 /**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -265,6 +226,7 @@ extern void call_rcu_bh(struct rcu_head *head,
 
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
+extern void synchronize_sched(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 3e05c09..448cd23 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -87,8 +87,6 @@ extern int rcu_needs_cpu(int cpu);
 #define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
 #define __rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
 
-extern void __synchronize_sched(void);
-
 extern void __rcu_init(void);
 extern void rcu_init_sched(void);
 extern void rcu_check_callbacks(int cpu, int user);
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index ad63af8..bd7d6b2 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -56,11 +56,16 @@ static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
 
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
+
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
  */
-void wakeme_after_rcu(struct rcu_head  *head)
+static void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
 
@@ -77,10 +82,46 @@ void wakeme_after_rcu(struct rcu_head  *head)
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
-void synchronize_rcu(void);	/* Makes kernel-doc tools happy */
-synchronize_rcu_xxx(synchronize_rcu, call_rcu)
+void synchronize_rcu(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+/**
+ * synchronize_sched - block until all CPUs have exited any non-preemptive
+ * kernel code sequences.
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
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 59236e8..2068ad9 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1161,15 +1161,6 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
- * Wait until all currently running preempt_disable() code segments
- * (including hardware-irq-disable segments) complete.  Note that
- * in -rt this does -not- necessarily result in all currently executing
- * interrupt -handlers- having completed.
- */
-synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
-EXPORT_SYMBOL_GPL(__synchronize_sched);
-
-/*
  * kthread function that manages call_rcu_sched grace periods.
  */
 static int rcu_sched_grace_period(void *arg)


