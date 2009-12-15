Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZLOXNt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934141AbZLOXNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:13:17 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44981 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762330AbZLOXCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:47 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 16/18] rcu: make lockdep aware of SRCU read-side critical sections.
Date: Tue, 15 Dec 2009 15:02:39 -0800
Message-Id: <1260918161657-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

This patch adds lockdep classes and code to make lockdep aware of
SRCU read-side critical sections.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h |   44 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/srcu.c        |   26 +++++++++++++-------------
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4765d97..5a07b90 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -45,10 +45,50 @@ struct srcu_struct {
 
 int init_srcu_struct(struct srcu_struct *sp);
 void cleanup_srcu_struct(struct srcu_struct *sp);
-int srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
-void srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
+int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
+void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern struct lockdep_map srcu_lock_map;
+# define srcu_read_acquire() \
+		lock_acquire(&srcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define srcu_read_release() \
+		lock_release(&srcu_lock_map, 1, _THIS_IP_)
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+# define srcu_read_acquire()	do { } while (0)
+# define srcu_read_release()	do { } while (0)
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+/**
+ * srcu_read_lock - register a new reader for an SRCU-protected structure.
+ * @sp: srcu_struct in which to register the new reader.
+ *
+ * Enter an SRCU read-side critical section.  Note that SRCU read-side
+ * critical sections may be nested.
+ */
+static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
+{
+	int retval = __srcu_read_lock(sp);
+
+	srcu_read_acquire();
+	return retval;
+}
+
+/**
+ * srcu_read_unlock - unregister a old reader from an SRCU-protected structure.
+ * @sp: srcu_struct in which to unregister the old reader.
+ * @idx: return value from corresponding srcu_read_lock().
+ *
+ * Exit an SRCU read-side critical section.
+ */
+static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
+	__releases(sp)
+{
+	srcu_read_release();
+	__srcu_read_unlock(sp, idx);
+}
+
 #endif
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 818d7d9..4575f63 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,6 +34,13 @@
 #include <linux/smp.h>
 #include <linux/srcu.h>
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key srcu_lock_key;
+struct lockdep_map srcu_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("srcu_read_lock", &srcu_lock_key);
+EXPORT_SYMBOL_GPL(srcu_lock_map);
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /**
  * init_srcu_struct - initialize a sleep-RCU structure
  * @sp: structure to initialize.
@@ -100,15 +107,12 @@ void cleanup_srcu_struct(struct srcu_struct *sp)
 }
 EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
 
-/**
- * srcu_read_lock - register a new reader for an SRCU-protected structure.
- * @sp: srcu_struct in which to register the new reader.
- *
+/*
  * Counts the new reader in the appropriate per-CPU element of the
  * srcu_struct.  Must be called from process context.
  * Returns an index that must be passed to the matching srcu_read_unlock().
  */
-int srcu_read_lock(struct srcu_struct *sp)
+int __srcu_read_lock(struct srcu_struct *sp)
 {
 	int idx;
 
@@ -120,26 +124,22 @@ int srcu_read_lock(struct srcu_struct *sp)
 	preempt_enable();
 	return idx;
 }
-EXPORT_SYMBOL_GPL(srcu_read_lock);
+EXPORT_SYMBOL_GPL(__srcu_read_lock);
 
-/**
- * srcu_read_unlock - unregister a old reader from an SRCU-protected structure.
- * @sp: srcu_struct in which to unregister the old reader.
- * @idx: return value from corresponding srcu_read_lock().
- *
+/*
  * Removes the count for the old reader from the appropriate per-CPU
  * element of the srcu_struct.  Note that this may well be a different
  * CPU than that which was incremented by the corresponding srcu_read_lock().
  * Must be called from process context.
  */
-void srcu_read_unlock(struct srcu_struct *sp, int idx)
+void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
 	preempt_disable();
 	srcu_barrier();  /* ensure compiler won't misorder critical section. */
 	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(srcu_read_unlock);
+EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
-- 
1.5.2.5

