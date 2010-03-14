Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab0CNKki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:40:38 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52863 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab0CNKix (ORCPT
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
Subject: [PATCH RFC 05/11] Adopt arch dependent rwsem to lock monitor
Date: Sun, 14 Mar 2010 19:38:42 +0900
Message-Id: <1268563128-6486-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current struct rw_semaphore holds struct lockdep_map,
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
 include/linux/rwsem-spinlock.h |   12 ++++++------
 include/linux/rwsem.h          |    2 ++
 kernel/rwsem.c                 |   16 ++++++++--------
 lib/rwsem-spinlock.c           |    2 +-
 lib/rwsem.c                    |    2 +-
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index bdfcc25..e99c42b 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -32,20 +32,20 @@ struct rw_semaphore {
 	__s32			activity;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
+#ifdef CONFIG_LOCK_MONITOR
+	struct lock_monitor     monitor;
 #endif
 };
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+#ifdef CONFIG_LOCK_MONITOR
+# define __RWSEM_LOCK_MONITOR_INIT(lockname) , .monitor = { __LOCK_MONITOR_INIT(lockname) }
 #else
-# define __RWSEM_DEP_MAP_INIT(lockname)
+# define __RWSEM_LOCK_MONITOR_INIT(lockname)
 #endif
 
 #define __RWSEM_INITIALIZER(name) \
 { 0, __SPIN_LOCK_UNLOCKED(name.wait_lock), LIST_HEAD_INIT((name).wait_list) \
-  __RWSEM_DEP_MAP_INIT(name) }
+  __RWSEM_LOCK_MONITOR_INIT(name) }
 
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index efd348f..5440a95 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -16,6 +16,8 @@
 
 struct rw_semaphore;
 
+#include <linux/lock_monitor.h>
+
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
 #include <linux/rwsem-spinlock.h> /* use a generic implementation */
 #else
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index cae050b..c2fd9e6 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -19,7 +19,7 @@
 void __sched down_read(struct rw_semaphore *sem)
 {
 	might_sleep();
-	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+	rwsem_acquire_read(&sem->monitor, 0, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
@@ -34,7 +34,7 @@ int down_read_trylock(struct rw_semaphore *sem)
 	int ret = __down_read_trylock(sem);
 
 	if (ret == 1)
-		rwsem_acquire_read(&sem->dep_map, 0, 1, _RET_IP_);
+		rwsem_acquire_read(&sem->monitor, 0, 1, _RET_IP_);
 	return ret;
 }
 
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(down_read_trylock);
 void __sched down_write(struct rw_semaphore *sem)
 {
 	might_sleep();
-	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
+	rwsem_acquire(&sem->monitor, 0, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
@@ -61,7 +61,7 @@ int down_write_trylock(struct rw_semaphore *sem)
 	int ret = __down_write_trylock(sem);
 
 	if (ret == 1)
-		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
+		rwsem_acquire(&sem->monitor, 0, 1, _RET_IP_);
 	return ret;
 }
 
@@ -72,7 +72,7 @@ EXPORT_SYMBOL(down_write_trylock);
  */
 void up_read(struct rw_semaphore *sem)
 {
-	rwsem_release(&sem->dep_map, 1, _RET_IP_);
+	rwsem_release(&sem->monitor, 1, _RET_IP_);
 
 	__up_read(sem);
 }
@@ -84,7 +84,7 @@ EXPORT_SYMBOL(up_read);
  */
 void up_write(struct rw_semaphore *sem)
 {
-	rwsem_release(&sem->dep_map, 1, _RET_IP_);
+	rwsem_release(&sem->monitor, 1, _RET_IP_);
 
 	__up_write(sem);
 }
@@ -110,7 +110,7 @@ EXPORT_SYMBOL(downgrade_write);
 void down_read_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();
-	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
+	rwsem_acquire_read(&sem->monitor, subclass, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(down_read_non_owner);
 void down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();
-	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
+	rwsem_acquire(&sem->monitor, subclass, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index ccf95bf..3bd0ed0 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -41,7 +41,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	 * Make sure we are not reinitializing a held semaphore:
 	 */
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
+	lockdep_init_map(&sem->monitor.dep_map, name, key, 0);
 #endif
 	sem->activity = 0;
 	spin_lock_init(&sem->wait_lock);
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 3e3365e..fab3db0 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -19,7 +19,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	 * Make sure we are not reinitializing a held semaphore:
 	 */
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
+	lockdep_init_map(&sem->monitor.dep_map, name, key, 0);
 #endif
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	spin_lock_init(&sem->wait_lock);
-- 
1.6.5.2

