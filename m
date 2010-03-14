Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab0CNKkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:40:45 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52851 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab0CNKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:53 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 02/11] Adopt lockdep to lock monitor
Date: Sun, 14 Mar 2010 19:38:39 +0900
Message-Id: <1268563128-6486-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now lockdep is a hook of lock monitor.

lockdep still does stat and event tracing.
I'll remove these from it later. And these can be
individual hook of lock monitor.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/lockdep.h |  138 ++++++++--------------------------------------
 kernel/lockdep.c        |   51 +++++++++++++++---
 2 files changed, 67 insertions(+), 122 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 371161c..1faa4e1 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -261,18 +261,18 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
  * or they are too narrow (they suffer from a false class-split):
  */
 #define lockdep_set_class(lock, key) \
-		lockdep_init_map(&(lock)->dep_map, #key, key, 0)
+		lockdep_init_map(&(lock)->monitor.dep_map, #key, key, 0)
 #define lockdep_set_class_and_name(lock, key, name) \
-		lockdep_init_map(&(lock)->dep_map, name, key, 0)
+		lockdep_init_map(&(lock)->monitor.dep_map, name, key, 0)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
-		lockdep_init_map(&(lock)->dep_map, #key, key, sub)
+		lockdep_init_map(&(lock)->monitor.dep_map, #key, key, sub)
 #define lockdep_set_subclass(lock, sub)	\
-		lockdep_init_map(&(lock)->dep_map, #lock, \
-				 (lock)->dep_map.key, sub)
+		lockdep_init_map(&(lock)->monitor.dep_map, #lock, \
+				 (lock)->monitor.dep_map.key, sub)
 /*
  * Compare locking classes
  */
-#define lockdep_match_class(lock, key) lockdep_match_key(&(lock)->dep_map, key)
+#define lockdep_match_class(lock, key) lockdep_match_key(&(lock)->monitor.dep_map, key)
 
 static inline int lockdep_match_key(struct lockdep_map *lock,
 				    struct lock_class_key *key)
@@ -295,14 +295,14 @@ static inline int lockdep_match_key(struct lockdep_map *lock,
  *   1: simple checks (freeing, held-at-exit-time, etc.)
  *   2: full validation
  */
-extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
+extern void lockdep_acquire(struct lockdep_map *lock, unsigned int subclass,
 			 int trylock, int read, int check,
 			 struct lockdep_map *nest_lock, unsigned long ip);
 
-extern void lock_release(struct lockdep_map *lock, int nested,
+extern void lockdep_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
-#define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
+#define lockdep_is_held(lock)	lock_is_held(&(lock)->monitor.dep_map)
 
 extern int lock_is_held(struct lockdep_map *lock);
 
@@ -340,8 +340,8 @@ static inline void lockdep_on(void)
 {
 }
 
-# define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
-# define lock_release(l, n, i)			do { } while (0)
+# define lockdep_acquire(l, s, t, r, c, n, i)	do { } while (0)
+# define lockdep_release(l, n, i)		do { } while (0)
 # define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_set_current_reclaim_state(g)	do { } while (0)
@@ -380,45 +380,16 @@ struct lock_class_key { };
 
 #ifdef CONFIG_LOCK_STAT
 
-extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
-extern void lock_acquired(struct lockdep_map *lock, unsigned long ip);
-
-#define LOCK_CONTENDED(_lock, try, lock)			\
-do {								\
-	if (!try(_lock)) {					\
-		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
-		lock(_lock);					\
-	}							\
-	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
-} while (0)
+extern void lockdep_contended(struct lockdep_map *lock, unsigned long ip);
+extern void lockdep_acquired(struct lockdep_map *lock, unsigned long ip);
 
 #else /* CONFIG_LOCK_STAT */
 
-#define lock_contended(lockdep_map, ip) do {} while (0)
-#define lock_acquired(lockdep_map, ip) do {} while (0)
-
-#define LOCK_CONTENDED(_lock, try, lock) \
-	lock(_lock)
+#define lockdep_contended(lockdep_map, ip) do {} while (0)
+#define lockdep_acquired(lockdep_map, ip) do {} while (0)
 
 #endif /* CONFIG_LOCK_STAT */
 
-#ifdef CONFIG_LOCKDEP
-
-/*
- * On lockdep we dont want the hand-coded irq-enable of
- * _raw_*_lock_flags() code, because lockdep assumes
- * that interrupts are not re-enabled during lock-acquire:
- */
-#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
-	LOCK_CONTENDED((_lock), (try), (lock))
-
-#else /* CONFIG_LOCKDEP */
-
-#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
-	lockfl((_lock), (flags))
-
-#endif /* CONFIG_LOCKDEP */
-
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern void early_init_irq_lock_class(void);
 #else
@@ -450,74 +421,13 @@ static inline void print_irqtrace_events(struct task_struct *curr)
  */
 #define SINGLE_DEPTH_NESTING			1
 
-/*
- * Map the dependency ops to NOP or to real lockdep ops, depending
- * on the per lock-class debug mode:
- */
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-# else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
-# endif
-# define spin_release(l, n, i)			lock_release(l, n, i)
-#else
-# define spin_acquire(l, s, t, i)		do { } while (0)
-# define spin_release(l, n, i)			do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
-# else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
-# endif
-# define rwlock_release(l, n, i)		lock_release(l, n, i)
-#else
-# define rwlock_acquire(l, s, t, i)		do { } while (0)
-# define rwlock_acquire_read(l, s, t, i)	do { } while (0)
-# define rwlock_release(l, n, i)		do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-# else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-# endif
-# define mutex_release(l, n, i)			lock_release(l, n, i)
-#else
-# define mutex_acquire(l, s, t, i)		do { } while (0)
-# define mutex_release(l, n, i)			do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
-# else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
-# endif
-# define rwsem_release(l, n, i)			lock_release(l, n, i)
-#else
-# define rwsem_acquire(l, s, t, i)		do { } while (0)
-# define rwsem_acquire_read(l, s, t, i)		do { } while (0)
-# define rwsem_release(l, n, i)			do { } while (0)
-#endif
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)		lockdep_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
 # else
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)		lockdep_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
 # endif
-# define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
+# define lock_map_release(l)			lockdep_release(l, 1, _THIS_IP_)
 #else
 # define lock_map_acquire(l)			do { } while (0)
 # define lock_map_release(l)			do { } while (0)
@@ -526,15 +436,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #ifdef CONFIG_PROVE_LOCKING
 # define might_lock(lock) 						\
 do {									\
-	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
-	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+	typecheck(struct lockdep_map *, &(lock)->monitor.dep_map);	\
+	lockdep_acquire(&(lock)->monitor.dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lockdep_release(&(lock)->monitor.dep_map, 0, _THIS_IP_);		\
 } while (0)
 # define might_lock_read(lock) 						\
 do {									\
-	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
-	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+	typecheck(struct lockdep_map *, &(lock)->monitor.dep_map);	\
+	lockdep_acquire(&(lock)->monitor.dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lockdep_release(&(lock)->monitor.dep_map, 0, _THIS_IP_);	\
 } while (0)
 #else
 # define might_lock(lock) do { } while (0)
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index da7435d..f7600a5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -43,6 +43,7 @@
 #include <linux/ftrace.h>
 #include <linux/stringify.h>
 #include <linux/bitops.h>
+#include <linux/lock_monitor.h>
 
 #include <asm/sections.h>
 
@@ -3208,7 +3209,7 @@ EXPORT_SYMBOL_GPL(lock_set_class);
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
  */
-void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
+void lockdep_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check,
 			  struct lockdep_map *nest_lock, unsigned long ip)
 {
@@ -3228,9 +3229,9 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(lock_acquire);
+EXPORT_SYMBOL_GPL(lockdep_acquire);
 
-void lock_release(struct lockdep_map *lock, int nested,
+void lockdep_release(struct lockdep_map *lock, int nested,
 			  unsigned long ip)
 {
 	unsigned long flags;
@@ -3247,7 +3248,7 @@ void lock_release(struct lockdep_map *lock, int nested,
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(lock_release);
+EXPORT_SYMBOL_GPL(lockdep_release);
 
 int lock_is_held(struct lockdep_map *lock)
 {
@@ -3412,7 +3413,7 @@ found_it:
 	lock->ip = ip;
 }
 
-void lock_contended(struct lockdep_map *lock, unsigned long ip)
+void lockdep_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -3431,9 +3432,9 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(lock_contended);
+EXPORT_SYMBOL_GPL(lockdep_contended);
 
-void lock_acquired(struct lockdep_map *lock, unsigned long ip)
+void lockdep_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -3450,7 +3451,7 @@ void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(lock_acquired);
+EXPORT_SYMBOL_GPL(lockdep_acquired);
 #endif
 
 /*
@@ -3579,6 +3580,38 @@ out_restore:
 	raw_local_irq_restore(flags);
 }
 
+void lockdep_acquire_hook(struct lock_monitor *monitor, unsigned int subclass,
+			  int trylock, int read, int check,
+			  struct lock_monitor *nest_monitor, unsigned long ip)
+{
+	lockdep_acquire(&monitor->dep_map, subclass, trylock, read,
+			check, nest_monitor ? &nest_monitor->dep_map : NULL, ip);
+}
+
+void lockdep_acquired_hook(struct lock_monitor *monitor, unsigned long ip)
+{
+	lockdep_acquired(&monitor->dep_map, ip);
+}
+
+void lockdep_contended_hook(struct lock_monitor *monitor, unsigned long ip)
+{
+	lockdep_contended(&monitor->dep_map, ip);
+}
+
+void lockdep_release_hook(struct lock_monitor *monitor, int nested,
+			  unsigned long ip)
+{
+	lockdep_release(&monitor->dep_map, nested, ip);
+}
+
+static struct lock_monitor_hook lockdep_hook = {
+	.name = "lockdep",
+	.acquire = lockdep_acquire_hook,
+	.acquired = lockdep_acquired_hook,
+	.contended = lockdep_contended_hook,
+	.release = lockdep_release_hook,
+};
+
 void lockdep_init(void)
 {
 	int i;
@@ -3598,6 +3631,8 @@ void lockdep_init(void)
 	for (i = 0; i < CHAINHASH_SIZE; i++)
 		INIT_LIST_HEAD(chainhash_table + i);
 
+	lock_monitor_register(&lockdep_hook);
+
 	lockdep_initialized = 1;
 }
 
-- 
1.6.5.2

