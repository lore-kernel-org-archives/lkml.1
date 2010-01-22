Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204Ab0AVNj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0AVNj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090Ab0AVNjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:39:25 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62787 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0AVNjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:39:21 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/12] lockdep:  Add file and line to initialize sequence of rwsem
Date: Fri, 22 Jan 2010 22:39:07 +0900
Message-Id: <1264167553-6510-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like other ones of this patch series, this patch adds
__FILE__ and __LINE__ to lockdep_map of rw_semaphore.
This patch only affects to architecture independent rwsem.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/rwsem-spinlock.h |   11 ++++++++---
 lib/rwsem-spinlock.c           |    5 +++--
 lib/rwsem.c                    |    5 +++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index bdfcc25..53f68e6 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -38,7 +38,11 @@ struct rw_semaphore {
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = {	\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+	}
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
@@ -51,13 +55,14 @@ struct rw_semaphore {
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
 
 extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
+			 struct lock_class_key *key,
+			 const char *file, unsigned int line);
 
 #define init_rwsem(sem)						\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	__init_rwsem((sem), #sem, &__key);			\
+	__init_rwsem((sem), #sem, &__key, __FILE__, __LINE__);	\
 } while (0)
 
 extern void __down_read(struct rw_semaphore *sem);
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index ccf95bf..4aceeb4 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -34,14 +34,15 @@ EXPORT_SYMBOL(rwsem_is_locked);
  * initialise the semaphore
  */
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
-		  struct lock_class_key *key)
+		  struct lock_class_key *key,
+		  const char *file, unsigned int line)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/*
 	 * Make sure we are not reinitializing a held semaphore:
 	 */
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
+	__lockdep_init_map(&sem->dep_map, name, key, 0, file, line);
 #endif
 	sem->activity = 0;
 	spin_lock_init(&sem->wait_lock);
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 3e3365e..3f8d5cd 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -12,14 +12,15 @@
  * Initialize an rwsem:
  */
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
-		  struct lock_class_key *key)
+		  struct lock_class_key *key,
+		  const char *file, unsigned int line)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/*
 	 * Make sure we are not reinitializing a held semaphore:
 	 */
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
+	__lockdep_init_map(&sem->dep_map, name, key, 0, file, line);
 #endif
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	spin_lock_init(&sem->wait_lock);
-- 
1.6.5.2

