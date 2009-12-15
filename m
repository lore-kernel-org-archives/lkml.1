Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbZLOXMG (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbZLOXLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:11:31 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53805 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762238AbZLOXCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 18/18] rcu: add primitives to check for RCU read-side critical sections
Date: Tue, 15 Dec 2009 15:02:41 -0800
Message-Id: <12609181613745-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

Create rcu_read_lock_held(), rcu_read_lock_bh_held(),
rcu_read_lock_sched_held(), and srcu_read_lock_held() primitives that
return non-zero if there might be the corresponding type of RCU read-side
critical section in effect at the time that they are invoked.  If there is
doubt, they report being in the critical section.  They give exact
answers if CONFIG_PROVE_LOCKING.

Also create rcu_dereference_check(), which takes a second boolean argument
into which one puts rcu_read_lock_held() or similar.  For example:

	rcu_dereference_check(gp, rcu_read_lock_held() ||
				  lockdep_is_held(my_lock));

There will likely need to be a lockdep_might_be_held() to handle the
case where debug_locks==0.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   85 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rcutiny.h  |    4 --
 include/linux/rcutree.h  |    1 -
 include/linux/srcu.h     |   24 +++++++++++++
 kernel/rcutorture.c      |   12 +++++-
 kernel/rcutree_plugin.h  |   22 ------------
 lib/debug_locks.c        |    1 +
 7 files changed, 120 insertions(+), 29 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 723c564..84b891d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -95,6 +95,70 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
+/**
+ * rcu_read_lock_held - might we be in RCU read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
+ * an RCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an RCU read-side critical section unless it can
+ * prove otherwise.
+ */
+static inline int rcu_read_lock_held(void)
+{
+	if (debug_locks)
+		return lock_is_held(&rcu_lock_map);
+	return 1;
+}
+
+/**
+ * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
+ * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an RCU-bh read-side critical section unless it can
+ * prove otherwise.
+ */
+static inline int rcu_read_lock_bh_held(void)
+{
+	if (debug_locks)
+		return lock_is_held(&rcu_bh_lock_map);
+	return 1;
+}
+
+/**
+ * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in an
+ * RCU-sched read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an RCU-sched read-side critical section unless it
+ * can prove otherwise.  Note that disabling of preemption (including
+ * disabling irqs) counts as an RCU-sched read-side critical section.
+ */
+static inline int rcu_read_lock_sched_held(void)
+{
+	int lockdep_opinion = 0;
+
+	if (debug_locks)
+		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
+	return lockdep_opinion || preempt_count() != 0;
+}
+
+/**
+ * rcu_dereference_check - rcu_dereference with debug checking
+ *
+ * Do an rcu_dereference(), but check that the context is correct.
+ * For example, rcu_dereference_check(gp, rcu_read_lock_held()) to
+ * ensure that the rcu_dereference_check() executes within an RCU
+ * read-side critical section.  It is also possible to check for
+ * locks being held, for example, by using lockdep_is_held().
+ */
+#define rcu_dereference_check(p, c) \
+	({ \
+		if (debug_locks) \
+			WARN_ON_ONCE(!c); \
+		rcu_dereference(p); \
+	})
+
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 # define rcu_read_acquire()		do { } while (0)
@@ -104,6 +168,27 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_acquire_sched()	do { } while (0)
 # define rcu_read_release_sched()	do { } while (0)
 
+static inline int rcu_read_lock_held(void)
+{
+	return 1;
+}
+
+static inline int rcu_read_lock_bh_held(void)
+{
+	return 1;
+}
+
+static inline int rcu_read_lock_sched_held(void)
+{
+	return preempt_count() != 0;
+}
+
+#define rcu_dereference_check(p, c) \
+	({ \
+		(void)(c); \
+		rcu_dereference(p); \
+	})
+
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index c32b16d..b524590 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -29,10 +29,6 @@
 
 void rcu_sched_qs(int cpu);
 void rcu_bh_qs(int cpu);
-static inline int rcu_read_lock_held(void)
-{
-	return 0;
-}
 
 #define __rcu_read_lock()	preempt_disable()
 #define __rcu_read_unlock()	preempt_enable()
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 8cd4ac1..564a025 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -37,7 +37,6 @@ extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_scheduler_starting(void);
 extern int rcu_expedited_torture_stats(char *page);
-extern int rcu_read_lock_held(void);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 5a07b90..9404d35 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -52,14 +52,38 @@ void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+
 extern struct lockdep_map srcu_lock_map;
 # define srcu_read_acquire() \
 		lock_acquire(&srcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
 # define srcu_read_release() \
 		lock_release(&srcu_lock_map, 1, _THIS_IP_)
+
+/**
+ * srcu_read_lock_held - might we be in SRCU read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
+ * an SRCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an SRCU read-side critical section unless it can
+ * prove otherwise.
+ */
+static inline int srcu_read_lock_held(void)
+{
+	if (debug_locks)
+		return lock_is_held(&srcu_lock_map);
+	return 1;
+}
+
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 # define srcu_read_acquire()	do { } while (0)
 # define srcu_read_release()	do { } while (0)
+
+static inline int srcu_read_lock_held(void)
+{
+	return 1;
+}
+
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index b4096d3..dc986f0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -796,7 +796,11 @@ static void rcu_torture_timer(unsigned long unused)
 
 	idx = cur_ops->readlock();
 	completed = cur_ops->completed();
-	p = rcu_dereference(rcu_torture_current);
+	p = rcu_dereference_check(rcu_torture_current,
+				  rcu_read_lock_held() ||
+				  rcu_read_lock_bh_held() ||
+				  rcu_read_lock_sched_held() ||
+				  srcu_read_lock_held());
 	if (p == NULL) {
 		/* Leave because rcu_torture_writer is not yet underway */
 		cur_ops->readunlock(idx);
@@ -853,7 +857,11 @@ rcu_torture_reader(void *arg)
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
-		p = rcu_dereference(rcu_torture_current);
+		p = rcu_dereference_check(rcu_torture_current,
+					  rcu_read_lock_held() ||
+					  rcu_read_lock_bh_held() ||
+					  rcu_read_lock_sched_held() ||
+					  srcu_read_lock_held());
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f6258ae..e77cdf3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -310,18 +310,6 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-/*
- * Return 1 if the current task is provably within an RCU read-side
- * critical section.  The bit about checking a running task to see if
- * it is blocked is a bit strange, but keep in mind that sleep and
- * wakeup are not atomic operations.
- */
-int rcu_read_lock_held(void)
-{
-	return ACCESS_ONCE(current->rcu_read_lock_nesting) != 0 ||
-	       (current->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED);
-}
-
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
@@ -773,16 +761,6 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
-/*
- * Return 1 if the current task is provably within an RCU read-side
- * critical section.  But without preemptible RCU, we never can be
- * sure, so always return 0.
- */
-int rcu_read_lock_held(void)
-{
-	return 0;
-}
-
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index bc3b117..5bf0020 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -23,6 +23,7 @@
  * shut up after that.
  */
 int debug_locks = 1;
+EXPORT_SYMBOL_GPL(debug_locks);
 
 /*
  * The locking-testsuite uses <debug_locks_silent> to get a
-- 
1.5.2.5

