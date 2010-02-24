Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0BXJDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:03:15 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53326 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0BXJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:03:10 -0500
X-Quarantine-ID: <hXYKxvBDvP0h>
X-Amavis-Alert: BAD HEADER, Duplicate header field: "To"
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, paulus@samba.org,
       tglx@linutronix.de, gregkh@suse.de
Subject: [PATCH] Separate lock events with types
Date: Wed, 24 Feb 2010 18:02:46 +0900
Message-Id: <1267002166-7281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20100129221252.GA5052@nowhere>
References: <20100129221252.GA5052@nowhere>
To: Frederic Weisbecker <fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my long silence...

Thanks for Frederic's great work like trace_lock_class_init(),
overhead of perf lock was reduced a lot.
But still there is overhead which cannot be disregarded.

So I'd like to suggest that separating lock trace events into each types of lock.
e.g.
	trace_lock_acquire() -> spin_trace_lock_acquire(), rwlock_trace_lock_acquire()
I think that mutex and spinlock are completely different things.
And as I describe below, filtering at recording phase can reduce overhead of tracing.

CAUTION:
This patch is the proof of concept. The way this patch employes
is different from one I described above. This patch adds if statement
before trace_lock_*(). Implementation of separating events per types will be
a big one, so this is an only trial edition for performance improvements.

Below is the list of typical scores of each situations:

|    raw score of perf bench sched messaging:
|
| %  ./perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 0.573 [sec]



|    before (Frederic's perf/core):
|
| % sudo ./perf lock record ./perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 3.265 [sec]
| [ perf record: Woken up 0 times to write data ]
| [ perf record: Captured and wrote 143.952 MB perf.data (~6289344 samples) ]



|    after (tracing only spinlocks):
|
| % sudo ./perf lock record ./perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 1.580 [sec]   <-- x2 faster!!
| [ perf record: Woken up 0 times to write data ]
| [ perf record: Captured and wrote 100.274 MB perf.data (~4381037 samples) ]

How do you think, Peter and Frederic?

---
 fs/sysfs/dir.c                   |    4 +-
 include/linux/lockdep.h          |  103 ++++++++++++++++++++++++--------------
 include/linux/rcupdate.h         |    4 +-
 include/linux/rwlock_api_smp.h   |   16 +++---
 include/linux/spinlock_api_smp.h |    8 ++--
 include/trace/events/lock.h      |    4 +-
 kernel/lockdep.c                 |   26 ++++++----
 kernel/mutex.c                   |    4 +-
 kernel/rwsem.c                   |    8 ++--
 kernel/spinlock.c                |    6 +-
 10 files changed, 108 insertions(+), 75 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 699f371..8782409 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -204,13 +204,13 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
 
 	if (v != SD_DEACTIVATED_BIAS) {
-		lock_contended(&sd->dep_map, _RET_IP_);
+		lock_contended(&sd->dep_map, _RET_IP_, LOCK_TYPE_OTHER);
 		wait_for_completion(&wait);
 	}
 
 	sd->s_sibling = NULL;
 
-	lock_acquired(&sd->dep_map, _RET_IP_);
+	lock_acquired(&sd->dep_map, _RET_IP_, LOCK_TYPE_OTHER);
 	rwsem_release(&sd->dep_map, 1, _RET_IP_);
 }
 
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 0b662fc..b93976a 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -19,6 +19,14 @@ struct lockdep_map;
 #include <linux/debug_locks.h>
 #include <linux/stacktrace.h>
 
+enum {
+	LOCK_TYPE_OTHER = 0,
+	LOCK_TYPE_SPIN,
+	LOCK_TYPE_RWLOCK,
+	LOCK_TYPE_RWSEM,
+	LOCK_TYPE_MUTEX,
+};
+
 /*
  * We'd rather not expose kernel/lockdep_states.h this wide, but we do need
  * the total number of states... :-(
@@ -294,10 +302,11 @@ static inline int lockdep_match_key(struct lockdep_map *lock,
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			 int trylock, int read, int check,
-			 struct lockdep_map *nest_lock, unsigned long ip);
+			 struct lockdep_map *nest_lock, unsigned long ip,
+			 int type);
 
 extern void lock_release(struct lockdep_map *lock, int nested,
-			 unsigned long ip);
+			 unsigned long ip, int type);
 
 #define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
 
@@ -337,7 +346,7 @@ static inline void lockdep_on(void)
 {
 }
 
-# define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
+# define lock_acquire(l, s, t, r, c, n, i, ty)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
 # define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
@@ -377,16 +386,16 @@ struct lock_class_key { };
 
 #ifdef CONFIG_LOCK_STAT
 
-extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
-extern void lock_acquired(struct lockdep_map *lock, unsigned long ip);
+extern void lock_contended(struct lockdep_map *lock, unsigned long ip, int type);
+extern void lock_acquired(struct lockdep_map *lock, unsigned long ip, int type);
 
-#define LOCK_CONTENDED(_lock, try, lock)			\
+#define LOCK_CONTENDED(_lock, try, lock, type)			\
 do {								\
 	if (!try(_lock)) {					\
-		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
+		lock_contended(&(_lock)->dep_map, _RET_IP_, type);	\
 		lock(_lock);					\
 	}							\
-	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
+	lock_acquired(&(_lock)->dep_map, _RET_IP_, type);	\
 } while (0)
 
 #else /* CONFIG_LOCK_STAT */
@@ -394,7 +403,7 @@ do {								\
 #define lock_contended(lockdep_map, ip) do {} while (0)
 #define lock_acquired(lockdep_map, ip) do {} while (0)
 
-#define LOCK_CONTENDED(_lock, try, lock) \
+#define LOCK_CONTENDED(_lock, try, lock, type)	\
 	lock(_lock)
 
 #endif /* CONFIG_LOCK_STAT */
@@ -406,13 +415,13 @@ do {								\
  * _raw_*_lock_flags() code, because lockdep assumes
  * that interrupts are not re-enabled during lock-acquire:
  */
-#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
-	LOCK_CONTENDED((_lock), (try), (lock))
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags, type)	\
+	LOCK_CONTENDED((_lock), (try), (lock), type)
 
 #else /* CONFIG_LOCKDEP */
 
-#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
-	lockfl((_lock), (flags))
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags, type)	\
+	lockfl((_lock), (flags), type)
 
 #endif /* CONFIG_LOCKDEP */
 
@@ -454,13 +463,17 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
+#  define spin_acquire(l, s, t, i)			\
+	lock_acquire(l, s, t, 0, 2, NULL, i, LOCK_TYPE_SPIN)
+#  define spin_acquire_nest(l, s, t, n, i)		\
+	lock_acquire(l, s, t, 0, 2, n, i, LOCK_TYPE_SPIN)
 # else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define spin_acquire(l, s, t, i)			\
+	lock_acquire(l, s, t, 0, 1, NULL, i, LOCK_TYPE_SPIN)
+#  define spin_acquire_nest(l, s, t, n, i)		\
+	lock_acquire(l, s, t, 0, 1, NULL, i, LOCK_TYPE_SPIN)
 # endif
-# define spin_release(l, n, i)			lock_release(l, n, i)
+# define spin_release(l, n, i)			lock_release(l, n, i, LOCK_TYPE_SPIN)
 #else
 # define spin_acquire(l, s, t, i)		do { } while (0)
 # define spin_release(l, n, i)			do { } while (0)
@@ -468,13 +481,17 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
+#  define rwlock_acquire(l, s, t, i)			\
+	lock_acquire(l, s, t, 0, 2, NULL, i, LOCK_TYPE_RWLOCK)
+#  define rwlock_acquire_read(l, s, t, i)		\
+	lock_acquire(l, s, t, 2, 2, NULL, i, LOCK_TYPE_RWLOCK)
 # else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
+#  define rwlock_acquire(l, s, t, i)			\
+	lock_acquire(l, s, t, 0, 1, NULL, i, LOCK_TYPE_RWLOCK)
+#  define rwlock_acquire_read(l, s, t, i)		\
+	lock_acquire(l, s, t, 2, 1, NULL, i, LOCK_TYPE_RWLOCK)
 # endif
-# define rwlock_release(l, n, i)		lock_release(l, n, i)
+# define rwlock_release(l, n, i)		lock_release(l, n, i, LOCK_TYPE_RWLOCK)
 #else
 # define rwlock_acquire(l, s, t, i)		do { } while (0)
 # define rwlock_acquire_read(l, s, t, i)	do { } while (0)
@@ -483,11 +500,13 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define mutex_acquire(l, s, t, i)			\
+	lock_acquire(l, s, t, 0, 2, NULL, i, LOCK_TYPE_MUTEX)
 # else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define mutex_acquire(l, s, t, i)			\
+	lock_acquire(l, s, t, 0, 1, NULL, i, LOCK_TYPE_MUTEX)
 # endif
-# define mutex_release(l, n, i)			lock_release(l, n, i)
+# define mutex_release(l, n, i)			lock_release(l, n, i, LOCK_TYPE_MUTEX)
 #else
 # define mutex_acquire(l, s, t, i)		do { } while (0)
 # define mutex_release(l, n, i)			do { } while (0)
@@ -495,13 +514,17 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
+#  define rwsem_acquire(l, s, t, i)		\
+	lock_acquire(l, s, t, 0, 2, NULL, i, LOCK_TYPE_RWSEM)
+#  define rwsem_acquire_read(l, s, t, i)	\
+	lock_acquire(l, s, t, 1, 2, NULL, i, LOCK_TYPE_RWSEM)
 # else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
+#  define rwsem_acquire(l, s, t, i)		\
+	lock_acquire(l, s, t, 0, 1, NULL, i, LOCK_TYPE_RWSEM)
+#  define rwsem_acquire_read(l, s, t, i)	\
+	lock_acquire(l, s, t, 1, 1, NULL, i, LOCK_TYPE_RWSEM)
 # endif
-# define rwsem_release(l, n, i)			lock_release(l, n, i)
+# define rwsem_release(l, n, i)			lock_release(l, n, i, LOCK_TYPE_RWSEM)
 #else
 # define rwsem_acquire(l, s, t, i)		do { } while (0)
 # define rwsem_acquire_read(l, s, t, i)		do { } while (0)
@@ -510,11 +533,13 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)					\
+	lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_, LOCK_TYPE_OTHER)
 # else
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)					\
+	lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_, LOCK_TYPE_OTHER)
 # endif
-# define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
+# define lock_map_release(l)			lock_release(l, 1, _THIS_IP_, LOCK_TYPE_OTHER)
 #else
 # define lock_map_acquire(l)			do { } while (0)
 # define lock_map_release(l)			do { } while (0)
@@ -524,14 +549,16 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define might_lock(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
-	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2,			\
+		     NULL, _THIS_IP_, LOCK_TYPE_OTHER);			\
+	lock_release(&(lock)->dep_map, 0, _THIS_IP_, LOCK_TYPE_OTHER);	\
 } while (0)
 # define might_lock_read(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
-	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2,			\
+		     NULL, _THIS_IP_, LOCK_TYPE_OTHER);			\
+	lock_release(&(lock)->dep_map, 0, _THIS_IP_, LOCK_TYPE_OTHER);	\
 } while (0)
 #else
 # define might_lock(lock) do { } while (0)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 24440f4..91a092f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -80,8 +80,8 @@ extern void rcu_init(void);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+	lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_, LOCK_TYPE_OTHER)
+# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_, LOCK_TYPE_OTHER)
 #else
 # define rcu_read_acquire()	do { } while (0)
 # define rcu_read_release()	do { } while (0)
diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 9c9f049..63b1da7 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -147,7 +147,7 @@ static inline void __raw_read_lock(rwlock_t *lock)
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
+	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock, LOCK_TYPE_RWLOCK);
 }
 
 static inline unsigned long __raw_read_lock_irqsave(rwlock_t *lock)
@@ -158,7 +158,7 @@ static inline unsigned long __raw_read_lock_irqsave(rwlock_t *lock)
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED_FLAGS(lock, do_raw_read_trylock, do_raw_read_lock,
-			     do_raw_read_lock_flags, &flags);
+			     do_raw_read_lock_flags, &flags, LOCK_TYPE_RWLOCK);
 	return flags;
 }
 
@@ -167,7 +167,7 @@ static inline void __raw_read_lock_irq(rwlock_t *lock)
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
+	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock, LOCK_TYPE_RWLOCK);
 }
 
 static inline void __raw_read_lock_bh(rwlock_t *lock)
@@ -175,7 +175,7 @@ static inline void __raw_read_lock_bh(rwlock_t *lock)
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
+	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock, LOCK_TYPE_RWLOCK);
 }
 
 static inline unsigned long __raw_write_lock_irqsave(rwlock_t *lock)
@@ -186,7 +186,7 @@ static inline unsigned long __raw_write_lock_irqsave(rwlock_t *lock)
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED_FLAGS(lock, do_raw_write_trylock, do_raw_write_lock,
-			     do_raw_write_lock_flags, &flags);
+			     do_raw_write_lock_flags, &flags, LOCK_TYPE_RWLOCK);
 	return flags;
 }
 
@@ -195,7 +195,7 @@ static inline void __raw_write_lock_irq(rwlock_t *lock)
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock, LOCK_TYPE_RWLOCK);
 }
 
 static inline void __raw_write_lock_bh(rwlock_t *lock)
@@ -203,14 +203,14 @@ static inline void __raw_write_lock_bh(rwlock_t *lock)
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock, LOCK_TYPE_RWLOCK);
 }
 
 static inline void __raw_write_lock(rwlock_t *lock)
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock, LOCK_TYPE_RWLOCK);
 }
 
 #endif /* CONFIG_PREEMPT */
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index e253ccd..0cf97ec 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -114,7 +114,7 @@ static inline unsigned long __raw_spin_lock_irqsave(raw_spinlock_t *lock)
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_LOCKDEP
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock, LOCK_TYPE_SPIN);
 #else
 	do_raw_spin_lock_flags(lock, &flags);
 #endif
@@ -126,7 +126,7 @@ static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock, LOCK_TYPE_SPIN);
 }
 
 static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
@@ -134,14 +134,14 @@ static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 	local_bh_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock, LOCK_TYPE_SPIN);
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock, LOCK_TYPE_SPIN);
 }
 
 #endif /* CONFIG_PREEMPT */
diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index ced4ceb..353dbd6 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -43,8 +43,8 @@ TRACE_EVENT_INJECT(lock_class_init,
 TRACE_EVENT(lock_acquire,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
-		int trylock, int read, int check,
-		struct lockdep_map *next_lock, unsigned long ip),
+		 int trylock, int read, int check,
+		 struct lockdep_map *next_lock, unsigned long ip),
 
 	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 4d9eef8..d4ee446 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3211,11 +3211,14 @@ EXPORT_SYMBOL_GPL(lock_set_class);
  */
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check,
-			  struct lockdep_map *nest_lock, unsigned long ip)
+			  struct lockdep_map *nest_lock, unsigned long ip,
+			  int type)
 {
 	unsigned long flags;
 
-	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
+	if (type == LOCK_TYPE_SPIN)
+		trace_lock_acquire(lock, subclass, trylock,
+				   read, check, nest_lock, ip);
 
 	if (unlikely(current->lockdep_recursion))
 		return;
@@ -3232,11 +3235,12 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 EXPORT_SYMBOL_GPL(lock_acquire);
 
 void lock_release(struct lockdep_map *lock, int nested,
-			  unsigned long ip)
+		  unsigned long ip, int type)
 {
 	unsigned long flags;
 
-	trace_lock_release(lock, nested, ip);
+	if (type == LOCK_TYPE_SPIN)
+		trace_lock_release(lock, nested, ip);
 
 	if (unlikely(current->lockdep_recursion))
 		return;
@@ -3357,7 +3361,7 @@ found_it:
 }
 
 static void
-__lock_acquired(struct lockdep_map *lock, unsigned long ip)
+__lock_acquired(struct lockdep_map *lock, unsigned long ip, int type)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
@@ -3396,7 +3400,8 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
-	trace_lock_acquired(lock, ip, waittime);
+	if (type == LOCK_TYPE_SPIN)
+		trace_lock_acquired(lock, ip, waittime);
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
@@ -3413,11 +3418,12 @@ found_it:
 	lock->ip = ip;
 }
 
-void lock_contended(struct lockdep_map *lock, unsigned long ip)
+void lock_contended(struct lockdep_map *lock, unsigned long ip, int type)
 {
 	unsigned long flags;
 
-	trace_lock_contended(lock, ip);
+	if (type == LOCK_TYPE_SPIN)
+		trace_lock_contended(lock, ip);
 
 	if (unlikely(!lock_stat))
 		return;
@@ -3434,7 +3440,7 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(lock_contended);
 
-void lock_acquired(struct lockdep_map *lock, unsigned long ip)
+void lock_acquired(struct lockdep_map *lock, unsigned long ip, int type)
 {
 	unsigned long flags;
 
@@ -3447,7 +3453,7 @@ void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
-	__lock_acquired(lock, ip);
+	__lock_acquired(lock, ip, type);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 632f04c..b95826f 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -216,7 +216,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
 
-	lock_contended(&lock->dep_map, ip);
+	lock_contended(&lock->dep_map, ip, LOCK_TYPE_MUTEX);
 
 	for (;;) {
 		/*
@@ -256,7 +256,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	}
 
 done:
-	lock_acquired(&lock->dep_map, ip);
+	lock_acquired(&lock->dep_map, ip, LOCK_TYPE_MUTEX);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index cae050b..d02869e 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -21,7 +21,7 @@ void __sched down_read(struct rw_semaphore *sem)
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
 
-	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read, LOCK_TYPE_RWSEM);
 }
 
 EXPORT_SYMBOL(down_read);
@@ -48,7 +48,7 @@ void __sched down_write(struct rw_semaphore *sem)
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 
-	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write, LOCK_TYPE_RWSEM);
 }
 
 EXPORT_SYMBOL(down_write);
@@ -112,7 +112,7 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read, LOCK_TYPE_RWSEM);
 }
 
 EXPORT_SYMBOL(down_read_nested);
@@ -131,7 +131,7 @@ void down_write_nested(struct rw_semaphore *sem, int subclass)
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write, LOCK_TYPE_RWSEM);
 }
 
 EXPORT_SYMBOL(down_write_nested);
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index be6517f..81067c2 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -345,7 +345,7 @@ void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock, LOCK_TYPE_SPIN);
 }
 EXPORT_SYMBOL(_raw_spin_lock_nested);
 
@@ -358,7 +358,7 @@ unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED_FLAGS(lock, do_raw_spin_trylock, do_raw_spin_lock,
-				do_raw_spin_lock_flags, &flags);
+			     do_raw_spin_lock_flags, &flags, LOCK_TYPE_SPIN);
 	return flags;
 }
 EXPORT_SYMBOL(_raw_spin_lock_irqsave_nested);
@@ -368,7 +368,7 @@ void __lockfunc _raw_spin_lock_nest_lock(raw_spinlock_t *lock,
 {
 	preempt_disable();
 	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock, LOCK_TYPE_SPIN);
 }
 EXPORT_SYMBOL(_raw_spin_lock_nest_lock);
 
-- 
1.6.5.2

