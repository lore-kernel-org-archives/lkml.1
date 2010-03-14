Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0CNKka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:40:30 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52866 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977Ab0CNKix (ORCPT
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
Subject: [PATCH RFC 04/11] Adopt rwlock to lock monitor
Date: Sun, 14 Mar 2010 19:38:41 +0900
Message-Id: <1268563128-6486-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current rwlock_t holds struct lockdep_map,
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
 include/linux/rwlock_api_smp.h |   36 ++++++++++++++++++------------------
 include/linux/rwlock_types.h   |   12 ++++++------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 9c9f049..d8458d9 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -118,7 +118,7 @@ static inline int __raw_read_trylock(rwlock_t *lock)
 {
 	preempt_disable();
 	if (do_raw_read_trylock(lock)) {
-		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
+		rwlock_acquire_read(&lock->monitor, 0, 1, _RET_IP_);
 		return 1;
 	}
 	preempt_enable();
@@ -129,7 +129,7 @@ static inline int __raw_write_trylock(rwlock_t *lock)
 {
 	preempt_disable();
 	if (do_raw_write_trylock(lock)) {
-		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		rwlock_acquire(&lock->monitor, 0, 1, _RET_IP_);
 		return 1;
 	}
 	preempt_enable();
@@ -146,7 +146,7 @@ static inline int __raw_write_trylock(rwlock_t *lock)
 static inline void __raw_read_lock(rwlock_t *lock)
 {
 	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire_read(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
@@ -156,7 +156,7 @@ static inline unsigned long __raw_read_lock_irqsave(rwlock_t *lock)
 
 	local_irq_save(flags);
 	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire_read(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED_FLAGS(lock, do_raw_read_trylock, do_raw_read_lock,
 			     do_raw_read_lock_flags, &flags);
 	return flags;
@@ -166,7 +166,7 @@ static inline void __raw_read_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire_read(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
@@ -174,7 +174,7 @@ static inline void __raw_read_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire_read(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
@@ -184,7 +184,7 @@ static inline unsigned long __raw_write_lock_irqsave(rwlock_t *lock)
 
 	local_irq_save(flags);
 	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED_FLAGS(lock, do_raw_write_trylock, do_raw_write_lock,
 			     do_raw_write_lock_flags, &flags);
 	return flags;
@@ -194,7 +194,7 @@ static inline void __raw_write_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
@@ -202,14 +202,14 @@ static inline void __raw_write_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
 static inline void __raw_write_lock(rwlock_t *lock)
 {
 	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	rwlock_acquire(&lock->monitor, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
@@ -217,14 +217,14 @@ static inline void __raw_write_lock(rwlock_t *lock)
 
 static inline void __raw_write_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
 	preempt_enable();
 }
 
 static inline void __raw_read_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
 	preempt_enable();
 }
@@ -232,7 +232,7 @@ static inline void __raw_read_unlock(rwlock_t *lock)
 static inline void
 __raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
@@ -240,7 +240,7 @@ __raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 
 static inline void __raw_read_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
@@ -248,7 +248,7 @@ static inline void __raw_read_unlock_irq(rwlock_t *lock)
 
 static inline void __raw_read_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
@@ -257,7 +257,7 @@ static inline void __raw_read_unlock_bh(rwlock_t *lock)
 static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
 					     unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
@@ -265,7 +265,7 @@ static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
 
 static inline void __raw_write_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
@@ -273,7 +273,7 @@ static inline void __raw_write_unlock_irq(rwlock_t *lock)
 
 static inline void __raw_write_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	rwlock_release(&lock->monitor, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index bd31808..b4dd24a 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -17,17 +17,17 @@ typedef struct {
 	unsigned int magic, owner_cpu;
 	void *owner;
 #endif
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
+#ifdef CONFIG_LOCK_MONITOR
+	struct lock_monitor monitor;
 #endif
 } rwlock_t;
 
 #define RWLOCK_MAGIC		0xdeaf1eed
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define RW_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define RW_LOCK_MONITOR_INIT(lockname)	.monitor = { __LOCK_MONITOR_INIT(lockname) }
 #else
-# define RW_DEP_MAP_INIT(lockname)
+# define RW_LOCK_MONITOR_INIT(lockname)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -36,11 +36,11 @@ typedef struct {
 				.magic = RWLOCK_MAGIC,			\
 				.owner = SPINLOCK_OWNER_INIT,		\
 				.owner_cpu = -1,			\
-				RW_DEP_MAP_INIT(lockname) }
+				RW_LOCK_MONITOR_INIT(lockname) }
 #else
 #define __RW_LOCK_UNLOCKED(lockname) \
 	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED,	\
-				RW_DEP_MAP_INIT(lockname) }
+				RW_LOCK_MONITOR_INIT(lockname) }
 #endif
 
 /*
-- 
1.6.5.2

