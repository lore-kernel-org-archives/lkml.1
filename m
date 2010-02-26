Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935732Ab0BZJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:30:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:39899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935704Ab0BZJaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:30:21 -0500
Date: Fri, 26 Feb 2010 09:29:39 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267135607-7056-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267135607-7056-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Make rcu_read_lock_sched_held() take boot time into account
Message-ID: <tip-d9f1bb6ad7fc53c406706f47858dd5ff030b14a3@git.kernel.org>
Git-Commit-ID: d9f1bb6ad7fc53c406706f47858dd5ff030b14a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:29:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9f1bb6ad7fc53c406706f47858dd5ff030b14a3
Gitweb:     http://git.kernel.org/tip/d9f1bb6ad7fc53c406706f47858dd5ff030b14a3
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 25 Feb 2010 14:06:47 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 08:20:46 +0100

rcu: Make rcu_read_lock_sched_held() take boot time into account

Before the scheduler starts, all tasks are non-preemptible by
definition. So, during that time, rcu_read_lock_sched_held()
needs to always return "true".  This patch makes that be so.

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
LKML-Reference: <1267135607-7056-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |    4 +++-
 include/linux/rcutiny.h  |    4 ----
 include/linux/rcutree.h  |    1 -
 kernel/rcupdate.c        |   18 ++++++++++++++++++
 kernel/rcutree.c         |   19 -------------------
 5 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1a4de31..fcea332 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -62,6 +62,8 @@ extern int sched_expedited_torture_stats(char *page);
 
 /* Internal to kernel */
 extern void rcu_init(void);
+extern int rcu_scheduler_active;
+extern void rcu_scheduler_starting(void);
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
@@ -140,7 +142,7 @@ static inline int rcu_read_lock_sched_held(void)
 
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0;
+	return lockdep_opinion || preempt_count() != 0 || !rcu_scheduler_active;
 }
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 2b70d4e..a519587 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -105,10 +105,6 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
-static inline void rcu_scheduler_starting(void)
-{
-}
-
 static inline void exit_rcu(void)
 {
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 704a010..42cc3a0 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,7 +35,6 @@ struct notifier_block;
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
-extern void rcu_scheduler_starting(void);
 extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 033cb55..7bfa004 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,6 +44,7 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/kernel_stat.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -62,6 +63,23 @@ struct lockdep_map rcu_sched_lock_map =
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 #endif
 
+int rcu_scheduler_active __read_mostly;
+
+/*
+ * This function is invoked towards the end of the scheduler's initialization
+ * process.  Before this is called, the idle task might contain
+ * RCU read-side critical sections (during which time, this idle
+ * task is booting the system).  After this function is called, the
+ * idle tasks are prohibited from containing RCU read-side critical
+ * sections.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 525d398..335bfe4 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,7 +46,6 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
-#include <linux/kernel_stat.h>
 
 #include "rcutree.h"
 
@@ -81,9 +80,6 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
-static int rcu_scheduler_active __read_mostly;
-
-
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
@@ -1565,21 +1561,6 @@ static int rcu_needs_cpu_quick_check(int cpu)
 	       rcu_preempt_needs_cpu(cpu);
 }
 
-/*
- * This function is invoked towards the end of the scheduler's initialization
- * process.  Before this is called, the idle task might contain
- * RCU read-side critical sections (during which time, this idle
- * task is booting the system).  After this function is called, the
- * idle tasks are prohibited from containing RCU read-side critical
- * sections.
- */
-void rcu_scheduler_starting(void)
-{
-	WARN_ON(num_online_cpus() != 1);
-	WARN_ON(nr_context_switches() > 0);
-	rcu_scheduler_active = 1;
-}
-
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
