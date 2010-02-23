Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0BWBFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:05:25 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47419 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0BWBFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/21] rcu: introduce lockdep-based checking to RCU read-side primitives
Date: Mon, 22 Feb 2010 17:04:45 -0800
Message-Id: <1266887105-1528-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspection is proving insufficient to catch all RCU misuses, which is
understandable given that rcu_dereference() might be protected by any
of four different flavors of RCU (RCU, RCU-bh, RCU-sched, and SRCU), and
might also/instead be protected by any of a number of locking primitives.
It is therefore time to enlist the aid of lockdep.

This set of patches is inspired by earlier work by Peter Zijlstra and
Thomas Gleixner, and takes the following approach:

o	Set up separate lockdep classes for RCU, RCU-bh, and RCU-sched.

o	Set up separate lockdep classes for each instance of SRCU.

o	Create primitives that check for being in an RCU read-side
	critical section.  These return exact answers if lockdep is
	fully enabled, but if unsure, report being in an RCU read-side
	critical section.  (We want to avoid false positives!)
	The primitives are:

	For RCU: rcu_read_lock_held(void)

	For RCU-bh: rcu_read_lock_bh_held(void)

	For RCU-sched: rcu_read_lock_sched_held(void)

	For SRCU: srcu_read_lock_held(struct srcu_struct *sp)

o	Add rcu_dereference_check(), which takes a second argument
	in which one places a boolean expression based on the above
	primitives and/or lockdep_is_held().

o	A new kernel configuration parameter, CONFIG_PROVE_RCU, enables
	rcu_dereference_check().  This depends on CONFIG_PROVE_LOCKING,
	and should be quite helpful during the transition period while
	CONFIG_PROVE_RCU-unaware patches are in flight.

The existing rcu_dereference() primitive does no checking, but upcoming
patches will change that.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  126 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/srcu.h     |   87 +++++++++++++++++++++++++++++++-
 kernel/rcupdate.c        |   10 ++++
 kernel/rcutorture.c      |   12 ++++-
 kernel/srcu.c            |   50 ++++++++++++------
 lib/Kconfig.debug        |   12 ++++
 lib/debug_locks.c        |    1 +
 7 files changed, 267 insertions(+), 31 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 24440f4..e3d37ef 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -78,14 +78,120 @@ extern void rcu_init(void);
 } while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+
 extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_acquire() \
+		lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
-#else
-# define rcu_read_acquire()	do { } while (0)
-# define rcu_read_release()	do { } while (0)
-#endif
+
+extern struct lockdep_map rcu_bh_lock_map;
+# define rcu_read_acquire_bh() \
+		lock_acquire(&rcu_bh_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release_bh()	lock_release(&rcu_bh_lock_map, 1, _THIS_IP_)
+
+extern struct lockdep_map rcu_sched_lock_map;
+# define rcu_read_acquire_sched() \
+		lock_acquire(&rcu_sched_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release_sched() \
+		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
+
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
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+# define rcu_read_acquire()		do { } while (0)
+# define rcu_read_release()		do { } while (0)
+# define rcu_read_acquire_bh()		do { } while (0)
+# define rcu_read_release_bh()		do { } while (0)
+# define rcu_read_acquire_sched()	do { } while (0)
+# define rcu_read_release_sched()	do { } while (0)
+
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
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+#ifdef CONFIG_PROVE_RCU
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
+			WARN_ON_ONCE(!(c)); \
+		rcu_dereference(p); \
+	})
+
+#else /* #ifdef CONFIG_PROVE_RCU */
+
+#define rcu_dereference_check(p, c)	rcu_dereference(p)
+
+#endif /* #else #ifdef CONFIG_PROVE_RCU */
 
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
@@ -160,7 +266,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	__rcu_read_lock_bh();
 	__acquire(RCU_BH);
-	rcu_read_acquire();
+	rcu_read_acquire_bh();
 }
 
 /*
@@ -170,7 +276,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_read_release();
+	rcu_read_release_bh();
 	__release(RCU_BH);
 	__rcu_read_unlock_bh();
 }
@@ -188,7 +294,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire();
+	rcu_read_acquire_sched();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -205,7 +311,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_read_release();
+	rcu_read_release_sched();
 	__release(RCU_SCHED);
 	preempt_enable();
 }
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4765d97..adbe167 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -35,6 +35,9 @@ struct srcu_struct {
 	int completed;
 	struct srcu_struct_array *per_cpu_ref;
 	struct mutex mutex;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 };
 
 #ifndef CONFIG_PREEMPT
@@ -43,12 +46,92 @@ struct srcu_struct {
 #define srcu_barrier()
 #endif /* #else #ifndef CONFIG_PREEMPT */
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+int __init_srcu_struct(struct srcu_struct *sp, const char *name,
+		       struct lock_class_key *key);
+
+#define init_srcu_struct(sp) \
+({ \
+	static struct lock_class_key __srcu_key; \
+	\
+	__init_srcu_struct((sp), #sp, &__srcu_key); \
+})
+
+# define srcu_read_acquire(sp) \
+		lock_acquire(&(sp)->dep_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define srcu_read_release(sp) \
+		lock_release(&(sp)->dep_map, 1, _THIS_IP_)
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 int init_srcu_struct(struct srcu_struct *sp);
+
+# define srcu_read_acquire(sp)  do { } while (0)
+# define srcu_read_release(sp)  do { } while (0)
+
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 void cleanup_srcu_struct(struct srcu_struct *sp);
-int srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
-void srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
+int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
+void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+/**
+ * srcu_read_lock_held - might we be in SRCU read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
+ * an SRCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an SRCU read-side critical section unless it can
+ * prove otherwise.
+ */
+static inline int srcu_read_lock_held(struct srcu_struct *sp)
+{
+	if (debug_locks)
+		return lock_is_held(&sp->dep_map);
+	return 1;
+}
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+static inline int srcu_read_lock_held(struct srcu_struct *sp)
+{
+	return 1;
+}
+
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
+	srcu_read_acquire(sp);
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
+	srcu_read_release(sp);
+	__srcu_read_unlock(sp, idx);
+}
+
 #endif
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 9b7fd47..033cb55 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -50,6 +50,16 @@ static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
 EXPORT_SYMBOL_GPL(rcu_lock_map);
+
+static struct lock_class_key rcu_bh_lock_key;
+struct lockdep_map rcu_bh_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_bh", &rcu_bh_lock_key);
+EXPORT_SYMBOL_GPL(rcu_bh_lock_map);
+
+static struct lock_class_key rcu_sched_lock_key;
+struct lockdep_map rcu_sched_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
+EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 #endif
 
 /*
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index adda92b..5f43f30 100644
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
+				  srcu_read_lock_held(&srcu_ctl));
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
+					  srcu_read_lock_held(&srcu_ctl));
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 31b275b..bde4295 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,6 +34,30 @@
 #include <linux/smp.h>
 #include <linux/srcu.h>
 
+static int init_srcu_struct_fields(struct srcu_struct *sp)
+{
+	sp->completed = 0;
+	mutex_init(&sp->mutex);
+	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
+	return sp->per_cpu_ref ? 0 : -ENOMEM;
+}
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+int __init_srcu_struct(struct srcu_struct *sp, const char *name,
+		       struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/* Don't re-initialize a lock while it is held. */
+	debug_check_no_locks_freed((void *)sp, sizeof(*sp));
+	lockdep_init_map(&sp->dep_map, name, key, 0);
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+	return init_srcu_struct_fields(sp);
+}
+EXPORT_SYMBOL_GPL(__init_srcu_struct);
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /**
  * init_srcu_struct - initialize a sleep-RCU structure
  * @sp: structure to initialize.
@@ -44,13 +68,12 @@
  */
 int init_srcu_struct(struct srcu_struct *sp)
 {
-	sp->completed = 0;
-	mutex_init(&sp->mutex);
-	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
-	return (sp->per_cpu_ref ? 0 : -ENOMEM);
+	return init_srcu_struct_fields(sp);
 }
 EXPORT_SYMBOL_GPL(init_srcu_struct);
 
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /*
  * srcu_readers_active_idx -- returns approximate number of readers
  *	active on the specified rank of per-CPU counters.
@@ -100,15 +123,12 @@ void cleanup_srcu_struct(struct srcu_struct *sp)
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
 
@@ -120,26 +140,22 @@ int srcu_read_lock(struct srcu_struct *sp)
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
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6bf97d1..6af20a8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -499,6 +499,18 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
+config PROVE_RCU
+	bool "RCU debugging: prove RCU correctness"
+	depends on PROVE_LOCKING
+	default n
+	help
+	 This feature enables lockdep extensions that check for correct
+	 use of RCU APIs.  This is currently under development.  Say Y
+	 if you want to debug RCU usage or help work on the PROVE_RCU
+	 feature.
+
+	 Say N if you are unsure.
+
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
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
1.6.6

