Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab0CNKkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:40:51 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52841 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab0CNKix (ORCPT
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
Subject: [PATCH RFC 03/11] Adopt spinlock to lock monitor
Date: Sun, 14 Mar 2010 19:38:40 +0900
Message-Id: <1268563128-6486-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current spinlock_t holds struct lockdep_map,
but it is a special thing of lockdep subsystem.

So I replaced it with struct lock_monitor.
Now it contains lockdep_map, and adding new members is easy.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/spinlock.h         |    4 ++--
 include/linux/spinlock_api_smp.h |   22 +++++++++++-----------
 include/linux/spinlock_types.h   |   16 ++++++++--------
 kernel/spinlock.c                |    8 ++++----
 lib/spinlock_debug.c             |    4 ++--
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 8608821..98a6314 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -171,8 +171,8 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock)
 
 # define raw_spin_lock_nest_lock(lock, nest_lock)			\
 	 do {								\
-		 typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
-		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
+		 typecheck(struct lock_monitor *, &(nest_lock)->monitor);\
+		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->monitor);	\
 	 } while (0)
 #else
 # define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index e253ccd..3290593 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -23,7 +23,7 @@ void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)		__acquires(lock);
 void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
 								__acquires(lock);
 void __lockfunc
-_raw_spin_lock_nest_lock(raw_spinlock_t *lock, struct lockdep_map *map)
+_raw_spin_lock_nest_lock(raw_spinlock_t *lock, struct lock_monitor *monitor)
 								__acquires(lock);
 void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)		__acquires(lock);
 void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
@@ -87,7 +87,7 @@ static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	preempt_disable();
 	if (do_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		spin_acquire(&lock->monitor, 0, 1, _RET_IP_);
 		return 1;
 	}
 	preempt_enable();
@@ -107,7 +107,7 @@ static inline unsigned long __raw_spin_lock_irqsave(raw_spinlock_t *lock)
 
 	local_irq_save(flags);
 	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	spin_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	/*
 	 * On lockdep we dont want the hand-coded irq-enable of
 	 * do_raw_spin_lock_flags() code, because lockdep assumes
@@ -125,7 +125,7 @@ static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	spin_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
@@ -133,14 +133,14 @@ static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	spin_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	spin_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
@@ -148,7 +148,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
+	spin_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
 	preempt_enable();
 }
@@ -156,7 +156,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 					    unsigned long flags)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
+	spin_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
@@ -164,7 +164,7 @@ static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 
 static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
+	spin_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
@@ -172,7 +172,7 @@ static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
 
 static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
+	spin_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
@@ -183,7 +183,7 @@ static inline int __raw_spin_trylock_bh(raw_spinlock_t *lock)
 	local_bh_disable();
 	preempt_disable();
 	if (do_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		spin_acquire(&lock->monitor, 0, 1, _RET_IP_);
 		return 1;
 	}
 	preempt_enable_no_resched();
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 851b778..cb113f5 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -15,7 +15,7 @@
 # include <linux/spinlock_types_up.h>
 #endif
 
-#include <linux/lockdep.h>
+#include <linux/lock_monitor.h>
 
 typedef struct raw_spinlock {
 	arch_spinlock_t raw_lock;
@@ -26,8 +26,8 @@ typedef struct raw_spinlock {
 	unsigned int magic, owner_cpu;
 	void *owner;
 #endif
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
+#ifdef CONFIG_LOCK_MONITOR
+	struct lock_monitor monitor;
 #endif
 } raw_spinlock_t;
 
@@ -36,9 +36,9 @@ typedef struct raw_spinlock {
 #define SPINLOCK_OWNER_INIT	((void *)-1L)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define SPIN_LOCK_MONITOR_INIT(lockname)	.monitor = { __LOCK_MONITOR_INIT(lockname) }
 #else
-# define SPIN_DEP_MAP_INIT(lockname)
+# define SPIN_LOCK_MONITOR_INIT(lockname)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -54,7 +54,7 @@ typedef struct raw_spinlock {
 	{					\
 	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
 	SPIN_DEBUG_INIT(lockname)		\
-	SPIN_DEP_MAP_INIT(lockname) }
+	SPIN_LOCK_MONITOR_INIT(lockname) }
 
 #define __RAW_SPIN_LOCK_UNLOCKED(lockname)	\
 	(raw_spinlock_t) __RAW_SPIN_LOCK_INITIALIZER(lockname)
@@ -66,10 +66,10 @@ typedef struct spinlock {
 		struct raw_spinlock rlock;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define LOCK_PADSIZE (offsetof(struct raw_spinlock, dep_map))
+# define LOCK_PADSIZE (offsetof(struct raw_spinlock, monitor))
 		struct {
 			u8 __padding[LOCK_PADSIZE];
-			struct lockdep_map dep_map;
+			struct lock_monitor monitor;
 		};
 #endif
 	};
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index be6517f..f2150d5 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -344,7 +344,7 @@ EXPORT_SYMBOL(_raw_write_unlock_bh);
 void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
 {
 	preempt_disable();
-	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	spin_acquire(&lock->monitor, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 EXPORT_SYMBOL(_raw_spin_lock_nested);
@@ -356,7 +356,7 @@ unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
 
 	local_irq_save(flags);
 	preempt_disable();
-	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	spin_acquire(&lock->monitor, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED_FLAGS(lock, do_raw_spin_trylock, do_raw_spin_lock,
 				do_raw_spin_lock_flags, &flags);
 	return flags;
@@ -364,10 +364,10 @@ unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
 EXPORT_SYMBOL(_raw_spin_lock_irqsave_nested);
 
 void __lockfunc _raw_spin_lock_nest_lock(raw_spinlock_t *lock,
-				     struct lockdep_map *nest_lock)
+				     struct lock_monitor *nest_monitor)
 {
 	preempt_disable();
-	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
+	spin_acquire_nest(&lock->monitor, 0, 0, nest_monitor, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 EXPORT_SYMBOL(_raw_spin_lock_nest_lock);
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 4755b98..b4b3bbe 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -21,7 +21,7 @@ void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 	 * Make sure we are not reinitializing a held lock:
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	lockdep_init_map(&lock->monitor.dep_map, name, key, 0);
 #endif
 	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	lock->magic = SPINLOCK_MAGIC;
@@ -39,7 +39,7 @@ void __rwlock_init(rwlock_t *lock, const char *name,
 	 * Make sure we are not reinitializing a held lock:
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	lockdep_init_map(&lock->monitor.dep_map, name, key, 0);
 #endif
 	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
 	lock->magic = RWLOCK_MAGIC;
-- 
1.6.5.2

