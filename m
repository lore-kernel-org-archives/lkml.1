Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986Ab0AZF47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0AZF47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 00:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845Ab0AZF47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 00:56:59 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:64853 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0AZF46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 00:56:58 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, mingo@elte.hu,
       paulus@samba.org, fweisbec@gmail.com, tglx@linutronix.de,
       gregkh@suse.de
Subject: [PATCH] Add type of locks to lock trace events
Date: Tue, 26 Jan 2010 14:56:44 +0900
Message-Id: <1264485404-6410-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263799219.4283.0.camel@laptop>
References: <1263799219.4283.0.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# Sorry, I wrote wrong Cc address. Previous mail was rejected by mailer-daemon.
# This is second time sending, if you already received this, please discard it...

There's no need to add any member to lockdep_map
for adding information of type of locks to lock trace events.

Example of perf trace:
|       init-0     [001]   335.078670: lock_acquired: 0xffff8800059d6bd8 &rq->lock kernel/lockdep.c:2973 (0 ns)
|       rb_consumer-424   [001]   335.078673: lock_acquire: 0xffff8800059d6bd8 1 &rq->lock kernel/lockdep.c:2973
|                                                                            # ^ &rq->lock is spin lock!
|       rb_consumer-424   [001]   335.078677: lock_acquire: 0xffff8800bba5e8e8 1 buffer->reader_lock_key kernel/trace/ring_
|       rb_consumer-424   [001]   335.078679: lock_acquired: 0xffff8800bba5e8e8 buffer->reader_lock_key kernel/trace/ring_b
|       rb_consumer-424   [001]   335.078684: lock_acquire: 0xffff8800059d12e8 1 &q->lock kernel/smp.c:83

Of course, as you told, type of lock dealing with is clear for human.
But it is not clear for programs like perf lock.

What I want to do is limiting types of lock focus on.
e.g. perf lock prof --type spin,rwlock

How do you think, Peter?
(This is test edition, don't apply it!)

---
 include/linux/lockdep.h     |   67 ++++++++++++++++++++++++++++++-------------
 include/linux/rcupdate.h    |    2 +-
 include/trace/events/lock.h |   12 +++++--
 kernel/lockdep.c            |    6 ++-
 4 files changed, 60 insertions(+), 27 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index a631afa..e267823 100644
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
@@ -306,7 +314,8 @@ static inline int lockdep_match_key(struct lockdep_map *lock,
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			 int trylock, int read, int check,
-			 struct lockdep_map *nest_lock, unsigned long ip);
+			 struct lockdep_map *nest_lock, unsigned long ip,
+			 int type);
 
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
@@ -345,7 +354,7 @@ static inline void lockdep_on(void)
 {
 }
 
-# define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
+# define lock_acquire(l, s, t, r, c, n, i, ty)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
 # define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
@@ -462,11 +471,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
 # define spin_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -476,11 +489,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
 # define rwlock_release(l, n, i)		lock_release(l, n, i)
 #else
@@ -491,9 +508,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -503,11 +522,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -518,9 +541,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
 #else
@@ -532,13 +557,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define might_lock(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2,			\
+		     NULL, _THIS_IP_, LOCK_TYPE_OTHER);			\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 # define might_lock_read(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2,			\
+		     NULL, _THIS_IP_, LOCK_TYPE_OTHER);			\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 #else
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 24440f4..9c5d1b9 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -80,7 +80,7 @@ extern void rcu_init(void);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+	lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_, LOCK_TYPE_OTHER)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
 #else
 # define rcu_read_acquire()	do { } while (0)
diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 3eef226..89107de 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -12,10 +12,11 @@
 TRACE_EVENT(lock_acquire,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
-		int trylock, int read, int check,
-		struct lockdep_map *next_lock, unsigned long ip),
+		 int trylock, int read, int check,
+		 struct lockdep_map *next_lock, unsigned long ip,
+		 int type),
 
-	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
+	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip, type),
 
 	TP_STRUCT__entry(
 		__field(unsigned int, flags)
@@ -23,6 +24,7 @@ TRACE_EVENT(lock_acquire,
 		__field(void *, lockdep_addr)
 		__string(file, lock->file)
 		__field(unsigned int, line)
+		__field(int, type)
 	),
 
 	TP_fast_assign(
@@ -31,9 +33,11 @@ TRACE_EVENT(lock_acquire,
 		__entry->lockdep_addr = lock;
 		__assign_str(file, lock->file);
 		__entry->line = lock->line;
+		__entry->type = type;
 	),
 
-	TP_printk("%p %s%s%s %s:%u", __entry->lockdep_addr,
+	TP_printk("%p %d %s%s%s %s:%u", __entry->lockdep_addr,
+		  __entry->type,
 		  (__entry->flags & 1) ? "try " : "",
 		  (__entry->flags & 2) ? "read " : "",
 		  __get_str(name), __get_str(file), __entry->line)
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f0f6dfd..12e5d73 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3211,11 +3211,13 @@ EXPORT_SYMBOL_GPL(lock_set_class);
  */
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check,
-			  struct lockdep_map *nest_lock, unsigned long ip)
+			  struct lockdep_map *nest_lock, unsigned long ip,
+			  int type)
 {
 	unsigned long flags;
 
-	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
+	trace_lock_acquire(lock, subclass, trylock,
+			   read, check, nest_lock, ip, type);
 
 	if (unlikely(current->lockdep_recursion))
 		return;
-- 
1.6.5.2

