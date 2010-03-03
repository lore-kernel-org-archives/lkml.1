Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0CCPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:47:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48898 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0CCPrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:47:12 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] rcu: suppress RCU lockdep warnings during early boot
Date: Wed,  3 Mar 2010 07:46:57 -0800
Message-Id: <1267631219-8713-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100303154638.GA8576@linux.vnet.ibm.com>
References: <20100303154638.GA8576@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU is used during very early boot, before RCU and lockdep have been
initialized.  So make the underlying primitives (rcu_read_lock_held(),
rcu_read_lock_bh_held(), rcu_read_lock_sched_held(), and
rcu_dereference_check()) check for early boot via the rcu_scheduler_active
flag.  This will suppress false positives.

Also introduce a debug_lockdep_rcu_enabled() static inline helper
function, which tags the CONTINUE_PROVE_RCU case as likely(), as suggested
by Ingo Molnar.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   35 ++++++++++++++++++++++++++---------
 lib/locking-selftest.c   |    5 +++++
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c843736..fb80ce3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -97,6 +97,11 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
+static inline int debug_lockdep_rcu_enabled(void)
+{
+	return likely(rcu_scheduler_active && debug_locks);
+}
+
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
  *
@@ -104,12 +109,14 @@ extern struct lockdep_map rcu_sched_lock_map;
  * an RCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
  * this assumes we are in an RCU read-side critical section unless it can
  * prove otherwise.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_held(void)
 {
-	if (debug_locks)
-		return lock_is_held(&rcu_lock_map);
-	return 1;
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return lock_is_held(&rcu_lock_map);
 }
 
 /**
@@ -119,12 +126,14 @@ static inline int rcu_read_lock_held(void)
  * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
  * this assumes we are in an RCU-bh read-side critical section unless it can
  * prove otherwise.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_bh_held(void)
 {
-	if (debug_locks)
-		return lock_is_held(&rcu_bh_lock_map);
-	return 1;
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return lock_is_held(&rcu_bh_lock_map);
 }
 
 /**
@@ -135,14 +144,18 @@ static inline int rcu_read_lock_bh_held(void)
  * this assumes we are in an RCU-sched read-side critical section unless it
  * can prove otherwise.  Note that disabling of preemption (including
  * disabling irqs) counts as an RCU-sched read-side critical section.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
 
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0 || !rcu_scheduler_active;
+	return lockdep_opinion || preempt_count() != 0;
 }
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -154,6 +167,10 @@ static inline int rcu_read_lock_sched_held(void)
 # define rcu_read_acquire_sched()	do { } while (0)
 # define rcu_read_release_sched()	do { } while (0)
 
+static inline void debug_lockdep_rcu_update(void)
+{
+}
+
 static inline int rcu_read_lock_held(void)
 {
 	return 1;
@@ -166,7 +183,7 @@ static inline int rcu_read_lock_bh_held(void)
 
 static inline int rcu_read_lock_sched_held(void)
 {
-	return preempt_count() != 0 || !rcu_scheduler_active;
+	return !rcu_scheduler_active || preempt_count() != 0;
 }
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -184,7 +201,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_locks && !(c)) \
+		if (debug_lockdep_rcu_enabled() && !(c)) \
 			lockdep_rcu_dereference(__FILE__, __LINE__); \
 		rcu_dereference_raw(p); \
 	})
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 619313e..5c549b8 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
 #include <linux/irqflags.h>
+#include <linux/rcupdate.h>
 
 /*
  * Change this to 1 if you want to see the failure printouts:
@@ -1192,6 +1193,7 @@ void locking_selftest(void)
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;
+		debug_lockdep_rcu_update();
 		printk("BUG: %3d unexpected failures (out of %3d) - debugging disabled! |\n",
 			unexpected_testcase_failures, testcase_total);
 		printk("-----------------------------------------------------------------\n");
@@ -1201,18 +1203,21 @@ void locking_selftest(void)
 			expected_testcase_failures, testcase_total);
 		printk("----------------------------------------------------\n");
 		debug_locks = 1;
+		debug_lockdep_rcu_update();
 	} else if (expected_testcase_failures && !testcase_successes) {
 		printk("--------------------------------------------------------\n");
 		printk("All %3d testcases failed, as expected. |\n",
 			expected_testcase_failures);
 		printk("----------------------------------------\n");
 		debug_locks = 1;
+		debug_lockdep_rcu_update();
 	} else {
 		printk("-------------------------------------------------------\n");
 		printk("Good, all %3d testcases passed! |\n",
 			testcase_successes);
 		printk("---------------------------------\n");
 		debug_locks = 1;
+		debug_lockdep_rcu_update();
 	}
 	debug_locks_silent = 0;
 }
-- 
1.6.6

