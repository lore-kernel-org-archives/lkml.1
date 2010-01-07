Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012Ab0AGKlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0AGKlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 05:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992Ab0AGKkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 05:40:07 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52165 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab0AGKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 05:40:04 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] lockdep: Add file and line to initialize sequence of spin and rw lock
Date: Thu,  7 Jan 2010 19:39:51 +0900
Message-Id: <1262860795-5745-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

each of spinlock and rwlock has two way to be initialized.
1: the macros DEFINE_{SPIN,RW}LOCK for statically defined locks
2: the functions {spin_,rw}lock_init() for locks on dynamically allocated memory

This patch modifies these two initialize sequences
for adding __FILE__ and __LINE__ to lockdep_map.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/spinlock.h       |   12 ++++++++----
 include/linux/spinlock_types.h |   12 ++++++++++--
 lib/spinlock_debug.c           |   10 ++++++----
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index f0ca7a7..cf526d8 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -92,12 +92,14 @@ extern int __lockfunc generic__raw_read_trylock(raw_rwlock_t *lock);
 
 #ifdef CONFIG_DEBUG_SPINLOCK
   extern void __spin_lock_init(spinlock_t *lock, const char *name,
-			       struct lock_class_key *key);
+			       struct lock_class_key *key,
+			       const char *file, unsigned int line);
 # define spin_lock_init(lock)					\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	__spin_lock_init((lock), #lock, &__key);		\
+	__spin_lock_init((lock), #lock, &__key,			\
+			 __FILE__, __LINE__);			\
 } while (0)
 
 #else
@@ -107,12 +109,14 @@ do {								\
 
 #ifdef CONFIG_DEBUG_SPINLOCK
   extern void __rwlock_init(rwlock_t *lock, const char *name,
-			    struct lock_class_key *key);
+			    struct lock_class_key *key,
+			    const char *file, unsigned int line);
 # define rwlock_init(lock)					\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	__rwlock_init((lock), #lock, &__key);			\
+	__rwlock_init((lock), #lock, &__key,			\
+		      __FILE__, __LINE__);			\
 } while (0)
 #else
 # define rwlock_init(lock)					\
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 68d88f7..13c04a0 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -52,13 +52,21 @@ typedef struct {
 #define SPINLOCK_OWNER_INIT	((void *)-1L)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = {	\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+	}
 #else
 # define SPIN_DEP_MAP_INIT(lockname)
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define RW_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define RW_DEP_MAP_INIT(lockname)	.dep_map = {	\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+	}
 #else
 # define RW_DEP_MAP_INIT(lockname)
 #endif
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 9c4b025..fdab55d 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -14,14 +14,15 @@
 #include <linux/module.h>
 
 void __spin_lock_init(spinlock_t *lock, const char *name,
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
 	lock->raw_lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	lock->magic = SPINLOCK_MAGIC;
@@ -32,14 +33,15 @@ void __spin_lock_init(spinlock_t *lock, const char *name,
 EXPORT_SYMBOL(__spin_lock_init);
 
 void __rwlock_init(rwlock_t *lock, const char *name,
-		   struct lock_class_key *key)
+		   struct lock_class_key *key,
+		   const char *file, unsigned int line)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/*
 	 * Make sure we are not reinitializing a held lock:
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	__lockdep_init_map(&lock->dep_map, name, key, 0, file, line);
 #endif
 	lock->raw_lock = (raw_rwlock_t) __RAW_RW_LOCK_UNLOCKED;
 	lock->magic = RWLOCK_MAGIC;
-- 
1.6.5.2

