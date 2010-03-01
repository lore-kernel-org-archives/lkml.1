Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0CATEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:04:14 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39409 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab0CATEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:04:11 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/2] rcu: suppress RCU lockdep warnings during early boot
Date: Mon,  1 Mar 2010 11:03:53 -0800
Message-Id: <1267470234-27150-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100301190329.GA26892@linux.vnet.ibm.com>
References: <20100301190329.GA26892@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU is used during very early boot, before RCU and lockdep have been
initialized.  So make the underlying primitives (rcu_read_lock_held(),
rcu_read_lock_bh_held(), rcu_read_lock_sched_held(), and
rcu_dereference_check()) check for early boot via the rcu_scheduler_active
flag.  This will suppress false positives.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c843736..af51d5f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -104,12 +104,14 @@ extern struct lockdep_map rcu_sched_lock_map;
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
+	if (!rcu_scheduler_active || !debug_locks)
+		return 1;
+	return lock_is_held(&rcu_lock_map);
 }
 
 /**
@@ -119,12 +121,14 @@ static inline int rcu_read_lock_held(void)
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
+	if (!rcu_scheduler_active || !debug_locks)
+		return 1;
+	return lock_is_held(&rcu_bh_lock_map);
 }
 
 /**
@@ -135,14 +139,18 @@ static inline int rcu_read_lock_bh_held(void)
  * this assumes we are in an RCU-sched read-side critical section unless it
  * can prove otherwise.  Note that disabling of preemption (including
  * disabling irqs) counts as an RCU-sched read-side critical section.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
 
+	if (!rcu_scheduler_active || !debug_locks)
+		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0 || !rcu_scheduler_active;
+	return lockdep_opinion || preempt_count() != 0;
 }
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -166,7 +174,7 @@ static inline int rcu_read_lock_bh_held(void)
 
 static inline int rcu_read_lock_sched_held(void)
 {
-	return preempt_count() != 0 || !rcu_scheduler_active;
+	return !rcu_scheduler_active || preempt_count() != 0;
 }
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -184,7 +192,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_locks && !(c)) \
+		if (rcu_scheduler_active && debug_locks && !(c)) \
 			lockdep_rcu_dereference(__FILE__, __LINE__); \
 		rcu_dereference_raw(p); \
 	})
-- 
1.6.6

