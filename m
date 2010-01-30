Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140Ab0A3Lnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0A3Lnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882Ab0A3Lno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:43:44 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52244 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab0A3Lnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:43:42 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 05/11] lockdep: Add file and line to initialize sequence of rwlock
Date: Sat, 30 Jan 2010 20:43:27 +0900
Message-Id: <1264851813-8413-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rwlock has two way to be initialized.
1: the macros DEFINE_{SPIN,RW}LOCK for statically defined locks
2: the functions {spin_,rw}lock_init() for locks on dynamically allocated memory

This patch modifies these two initialize sequences
for adding __FILE__ and __LINE__ to lockdep_map.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/rwlock.h       |    6 ++++--
 include/linux/rwlock_types.h |    6 +++++-
 lib/spinlock_debug.c         |    6 ++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 71e0b00..cdef180 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -16,12 +16,14 @@
 
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
diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index bd31808..e5e70c4 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -25,7 +25,11 @@ typedef struct {
 #define RWLOCK_MAGIC		0xdeaf1eed
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define RW_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define RW_DEP_MAP_INIT(lockname)	.dep_map = {	\
+		.name = #lockname,			\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+	}
 #else
 # define RW_DEP_MAP_INIT(lockname)
 #endif
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 81fa789..1cdae8b 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -34,14 +34,16 @@ void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 EXPORT_SYMBOL(__raw_spin_lock_init);
 
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
+	__lockdep_init_map(&lock->dep_map, name, key, 0,
+			   file, line);
 #endif
 	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
 	lock->magic = RWLOCK_MAGIC;
-- 
1.6.5.2

