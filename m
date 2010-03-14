Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab0CNKjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:39:01 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52877 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab0CNKiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:54 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 08/11] Adopt mutex to lock monitor
Date: Sun, 14 Mar 2010 19:38:45 +0900
Message-Id: <1268563128-6486-9-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current struct mutex holds struct lockdep_map,
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
 include/linux/mutex.h |   14 +++++++-------
 kernel/mutex-debug.c  |    2 +-
 kernel/mutex.c        |   14 +++++++-------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 878cab4..0673307 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -13,7 +13,7 @@
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 #include <linux/linkage.h>
-#include <linux/lockdep.h>
+#include <linux/lock_monitor.h>
 
 #include <asm/atomic.h>
 
@@ -57,8 +57,8 @@ struct mutex {
 	const char 		*name;
 	void			*magic;
 #endif
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
+#ifdef CONFIG_LOCK_MONITOR
+	struct lock_monitor     monitor;
 #endif
 };
 
@@ -88,10 +88,10 @@ do {							\
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __DEP_MAP_MUTEX_INITIALIZER(lockname) \
-		, .dep_map = { .name = #lockname }
+# define __LOCK_MONITOR_MUTEX_INITIALIZER(lockname) \
+	        , .monitor = { __LOCK_MONITOR_INIT(lockname) }
 #else
-# define __DEP_MAP_MUTEX_INITIALIZER(lockname)
+# define __LOCK_MONITOR_MUTEX_INITIALIZER(lockname)
 #endif
 
 #define __MUTEX_INITIALIZER(lockname) \
@@ -99,7 +99,7 @@ do {							\
 		, .wait_lock = __SPIN_LOCK_UNLOCKED(lockname.wait_lock) \
 		, .wait_list = LIST_HEAD_INIT(lockname.wait_list) \
 		__DEBUG_MUTEX_INITIALIZER(lockname) \
-		__DEP_MAP_MUTEX_INITIALIZER(lockname) }
+		__LOCK_MONITOR_MUTEX_INITIALIZER(lockname) }
 
 #define DEFINE_MUTEX(mutexname) \
 	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index ec815a9..9266f60 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -88,7 +88,7 @@ void debug_mutex_init(struct mutex *lock, const char *name,
 	 * Make sure we are not reinitializing a held lock:
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	lockdep_init_map(&lock->monitor.dep_map, name, key, 0);
 #endif
 	lock->magic = lock;
 }
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 632f04c..f9e91ce 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -147,7 +147,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	unsigned long flags;
 
 	preempt_disable();
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+	mutex_acquire(&lock->monitor, subclass, 0, ip);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 	/*
@@ -180,7 +180,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			break;
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
-			lock_acquired(&lock->dep_map, ip);
+			lockdep_acquired(&lock->dep_map, ip);
 			mutex_set_owner(lock);
 			preempt_enable();
 			return 0;
@@ -216,7 +216,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
 
-	lock_contended(&lock->dep_map, ip);
+	lockdep_contended(&lock->monitor.dep_map, ip);
 
 	for (;;) {
 		/*
@@ -238,7 +238,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (unlikely(signal_pending_state(state, task))) {
 			mutex_remove_waiter(lock, &waiter,
 					    task_thread_info(task));
-			mutex_release(&lock->dep_map, 1, ip);
+			mutex_release(&lock->monitor, 1, ip);
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
 			debug_mutex_free_waiter(&waiter);
@@ -256,7 +256,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	}
 
 done:
-	lock_acquired(&lock->dep_map, ip);
+	lockdep_acquired(&lock->monitor.dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
@@ -312,7 +312,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 	unsigned long flags;
 
 	spin_lock_mutex(&lock->wait_lock, flags);
-	mutex_release(&lock->dep_map, nested, _RET_IP_);
+	mutex_release(&lock->monitor, nested, _RET_IP_);
 	debug_mutex_unlock(lock);
 
 	/*
@@ -437,7 +437,7 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
 		mutex_set_owner(lock);
-		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		mutex_acquire(&lock->monitor, 0, 1, _RET_IP_);
 	}
 
 	/* Set it back to 0 if there are no waiters: */
-- 
1.6.5.2

