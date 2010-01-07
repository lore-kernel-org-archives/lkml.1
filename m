Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230Ab0AGKkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab0AGKkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 05:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989Ab0AGKkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 05:40:08 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52183 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0AGKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 05:40:04 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] lockdep: Add file and line to initialize sequence of mutex
Date: Thu,  7 Jan 2010 19:39:54 +0900
Message-Id: <1262860795-5745-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like other ones of this patch series, this patch adds
__FILE__ and __LINE__ to lockdep_map of mutex.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/mutex-debug.h |    2 +-
 include/linux/mutex.h       |   12 +++++++++---
 kernel/mutex-debug.c        |    5 +++--
 kernel/mutex-debug.h        |    3 ++-
 kernel/mutex.c              |    5 +++--
 kernel/mutex.h              |    2 +-
 6 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/linux/mutex-debug.h b/include/linux/mutex-debug.h
index 731d77d..f86bf4e 100644
--- a/include/linux/mutex-debug.h
+++ b/include/linux/mutex-debug.h
@@ -15,7 +15,7 @@
 do {									\
 	static struct lock_class_key __key;				\
 									\
-	__mutex_init((mutex), #mutex, &__key);				\
+	__mutex_init((mutex), #mutex, &__key, __FILE__, __LINE__);	\
 } while (0)
 
 extern void mutex_destroy(struct mutex *lock);
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 878cab4..ce9082a 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -82,14 +82,19 @@ struct mutex_waiter {
 do {							\
 	static struct lock_class_key __key;		\
 							\
-	__mutex_init((mutex), #mutex, &__key);		\
+	__mutex_init((mutex), #mutex, &__key,		\
+		     __FILE__, __LINE__);		\
 } while (0)
 # define mutex_destroy(mutex)				do { } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname) \
-		, .dep_map = { .name = #lockname }
+		, .dep_map = {		       \
+			.file = __FILE__,      \
+			.line = __LINE__,      \
+			.name = #lockname,     \
+		}
 #else
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)
 #endif
@@ -105,7 +110,8 @@ do {							\
 	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
 
 extern void __mutex_init(struct mutex *lock, const char *name,
-			 struct lock_class_key *key);
+			 struct lock_class_key *key,
+			 const char *file, unsigned int line);
 
 /**
  * mutex_is_locked - is the mutex locked
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index ec815a9..4a1321b 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -81,14 +81,15 @@ void debug_mutex_unlock(struct mutex *lock)
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
-		      struct lock_class_key *key)
+		      struct lock_class_key *key,
+		      const char *file, unsigned int line)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/*
 	 * Make sure we are not reinitializing a held lock:
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	__lockdep_init_map(&lock->dep_map, name, key, 0, file, line);
 #endif
 	lock->magic = lock;
 }
diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
index 6b2d735..802a2d7 100644
--- a/kernel/mutex-debug.h
+++ b/kernel/mutex-debug.h
@@ -25,7 +25,8 @@ extern void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 				struct thread_info *ti);
 extern void debug_mutex_unlock(struct mutex *lock);
 extern void debug_mutex_init(struct mutex *lock, const char *name,
-			     struct lock_class_key *key);
+			     struct lock_class_key *key,
+			     const char *file, unsigned int line);
 
 static inline void mutex_set_owner(struct mutex *lock)
 {
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 947b3ad..7c49bab 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -46,14 +46,15 @@
  * It is not allowed to initialize an already locked mutex.
  */
 void
-__mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
+__mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key,
+	     const char *file, unsigned int line)
 {
 	atomic_set(&lock->count, 1);
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 
-	debug_mutex_init(lock, name, key);
+	debug_mutex_init(lock, name, key, file, line);
 }
 
 EXPORT_SYMBOL(__mutex_init);
diff --git a/kernel/mutex.h b/kernel/mutex.h
index 67578ca..81914e6 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -40,7 +40,7 @@ static inline void mutex_clear_owner(struct mutex *lock)
 #define debug_mutex_free_waiter(waiter)			do { } while (0)
 #define debug_mutex_add_waiter(lock, waiter, ti)	do { } while (0)
 #define debug_mutex_unlock(lock)			do { } while (0)
-#define debug_mutex_init(lock, name, key)		do { } while (0)
+#define debug_mutex_init(lock, name, key, file, line)	do { } while (0)
 
 static inline void
 debug_mutex_lock_common(struct mutex *lock, struct mutex_waiter *waiter)
-- 
1.6.5.2

