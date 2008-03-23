Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYCWIbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYCWIbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759513AbYCWIJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:48 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2287 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758995AbYCWIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:46 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 106/148] include/asm-x86/rwsem.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:21 -0700
Message-Id: <1206259443-13210-107-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/rwsem.h |  169 ++++++++++++++++++++++++-----------------------
 1 files changed, 86 insertions(+), 83 deletions(-)

diff --git a/include/asm-x86/rwsem.h b/include/asm-x86/rwsem.h
index 520a379..750f2a3 100644
--- a/include/asm-x86/rwsem.h
+++ b/include/asm-x86/rwsem.h
@@ -56,14 +56,16 @@ extern asmregparm struct rw_semaphore *
 /*
  * the semaphore definition
  */
-struct rw_semaphore {
-	signed long		count;
+
 #define RWSEM_UNLOCKED_VALUE		0x00000000
 #define RWSEM_ACTIVE_BIAS		0x00000001
 #define RWSEM_ACTIVE_MASK		0x0000ffff
 #define RWSEM_WAITING_BIAS		(-0x00010000)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+
+struct rw_semaphore {
+	signed long		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -78,11 +80,13 @@ struct rw_semaphore {
 #endif
 
 
-#define __RWSEM_INITIALIZER(name) \
-{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
+#define __RWSEM_INITIALIZER(name)				\
+{								\
+	RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
+	LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) \
+}
 
-#define DECLARE_RWSEM(name) \
+#define DECLARE_RWSEM(name)					\
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
 
 extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
@@ -100,16 +104,16 @@ do {								\
  */
 static inline void __down_read(struct rw_semaphore *sem)
 {
-	__asm__ __volatile__(
-		"# beginning down_read\n\t"
-LOCK_PREFIX	"  incl      (%%eax)\n\t" /* adds 0x00000001, returns the old value */
-		"  jns        1f\n"
-		"  call call_rwsem_down_read_failed\n"
-		"1:\n\t"
-		"# ending down_read\n\t"
-		: "+m" (sem->count)
-		: "a" (sem)
-		: "memory", "cc");
+	asm volatile("# beginning down_read\n\t"
+		     LOCK_PREFIX "  incl      (%%eax)\n\t"
+		     /* adds 0x00000001, returns the old value */
+		     "  jns        1f\n"
+		     "  call call_rwsem_down_read_failed\n"
+		     "1:\n\t"
+		     "# ending down_read\n\t"
+		     : "+m" (sem->count)
+		     : "a" (sem)
+		     : "memory", "cc");
 }
 
 /*
@@ -118,21 +122,20 @@ LOCK_PREFIX	"  incl      (%%eax)\n\t" /* adds 0x00000001, returns the old value
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	__s32 result, tmp;
-	__asm__ __volatile__(
-		"# beginning __down_read_trylock\n\t"
-		"  movl      %0,%1\n\t"
-		"1:\n\t"
-		"  movl	     %1,%2\n\t"
-		"  addl      %3,%2\n\t"
-		"  jle	     2f\n\t"
-LOCK_PREFIX	"  cmpxchgl  %2,%0\n\t"
-		"  jnz	     1b\n\t"
-		"2:\n\t"
-		"# ending __down_read_trylock\n\t"
-		: "+m" (sem->count), "=&a" (result), "=&r" (tmp)
-		: "i" (RWSEM_ACTIVE_READ_BIAS)
-		: "memory", "cc");
-	return result>=0 ? 1 : 0;
+	asm volatile("# beginning __down_read_trylock\n\t"
+		     "  movl      %0,%1\n\t"
+		     "1:\n\t"
+		     "  movl	     %1,%2\n\t"
+		     "  addl      %3,%2\n\t"
+		     "  jle	     2f\n\t"
+		     LOCK_PREFIX "  cmpxchgl  %2,%0\n\t"
+		     "  jnz	     1b\n\t"
+		     "2:\n\t"
+		     "# ending __down_read_trylock\n\t"
+		     : "+m" (sem->count), "=&a" (result), "=&r" (tmp)
+		     : "i" (RWSEM_ACTIVE_READ_BIAS)
+		     : "memory", "cc");
+	return result >= 0 ? 1 : 0;
 }
 
 /*
@@ -143,17 +146,18 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 	int tmp;
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
-	__asm__ __volatile__(
-		"# beginning down_write\n\t"
-LOCK_PREFIX	"  xadd      %%edx,(%%eax)\n\t" /* subtract 0x0000ffff, returns the old value */
-		"  testl     %%edx,%%edx\n\t" /* was the count 0 before? */
-		"  jz        1f\n"
-		"  call call_rwsem_down_write_failed\n"
-		"1:\n"
-		"# ending down_write"
-		: "+m" (sem->count), "=d" (tmp)
-		: "a" (sem), "1" (tmp)
-		: "memory", "cc");
+	asm volatile("# beginning down_write\n\t"
+		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     /* subtract 0x0000ffff, returns the old value */
+		     "  testl     %%edx,%%edx\n\t"
+		     /* was the count 0 before? */
+		     "  jz        1f\n"
+		     "  call call_rwsem_down_write_failed\n"
+		     "1:\n"
+		     "# ending down_write"
+		     : "+m" (sem->count), "=d" (tmp)
+		     : "a" (sem), "1" (tmp)
+		     : "memory", "cc");
 }
 
 static inline void __down_write(struct rw_semaphore *sem)
@@ -167,7 +171,7 @@ static inline void __down_write(struct rw_semaphore *sem)
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
 	signed long ret = cmpxchg(&sem->count,
-				  RWSEM_UNLOCKED_VALUE, 
+				  RWSEM_UNLOCKED_VALUE,
 				  RWSEM_ACTIVE_WRITE_BIAS);
 	if (ret == RWSEM_UNLOCKED_VALUE)
 		return 1;
@@ -180,16 +184,16 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
 static inline void __up_read(struct rw_semaphore *sem)
 {
 	__s32 tmp = -RWSEM_ACTIVE_READ_BIAS;
-	__asm__ __volatile__(
-		"# beginning __up_read\n\t"
-LOCK_PREFIX	"  xadd      %%edx,(%%eax)\n\t" /* subtracts 1, returns the old value */
-		"  jns        1f\n\t"
-		"  call call_rwsem_wake\n"
-		"1:\n"
-		"# ending __up_read\n"
-		: "+m" (sem->count), "=d" (tmp)
-		: "a" (sem), "1" (tmp)
-		: "memory", "cc");
+	asm volatile("# beginning __up_read\n\t"
+		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     /* subtracts 1, returns the old value */
+		     "  jns        1f\n\t"
+		     "  call call_rwsem_wake\n"
+		     "1:\n"
+		     "# ending __up_read\n"
+		     : "+m" (sem->count), "=d" (tmp)
+		     : "a" (sem), "1" (tmp)
+		     : "memory", "cc");
 }
 
 /*
@@ -197,17 +201,18 @@ LOCK_PREFIX	"  xadd      %%edx,(%%eax)\n\t" /* subtracts 1, returns the old valu
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	__asm__ __volatile__(
-		"# beginning __up_write\n\t"
-		"  movl      %2,%%edx\n\t"
-LOCK_PREFIX	"  xaddl     %%edx,(%%eax)\n\t" /* tries to transition 0xffff0001 -> 0x00000000 */
-		"  jz       1f\n"
-		"  call call_rwsem_wake\n"
-		"1:\n\t"
-		"# ending __up_write\n"
-		: "+m" (sem->count)
-		: "a" (sem), "i" (-RWSEM_ACTIVE_WRITE_BIAS)
-		: "memory", "cc", "edx");
+	asm volatile("# beginning __up_write\n\t"
+		     "  movl      %2,%%edx\n\t"
+		     LOCK_PREFIX "  xaddl     %%edx,(%%eax)\n\t"
+		     /* tries to transition
+			0xffff0001 -> 0x00000000 */
+		     "  jz       1f\n"
+		     "  call call_rwsem_wake\n"
+		     "1:\n\t"
+		     "# ending __up_write\n"
+		     : "+m" (sem->count)
+		     : "a" (sem), "i" (-RWSEM_ACTIVE_WRITE_BIAS)
+		     : "memory", "cc", "edx");
 }
 
 /*
@@ -215,16 +220,16 @@ LOCK_PREFIX	"  xaddl     %%edx,(%%eax)\n\t" /* tries to transition 0xffff0001 ->
  */
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
-	__asm__ __volatile__(
-		"# beginning __downgrade_write\n\t"
-LOCK_PREFIX	"  addl      %2,(%%eax)\n\t" /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
-		"  jns       1f\n\t"
-		"  call call_rwsem_downgrade_wake\n"
-		"1:\n\t"
-		"# ending __downgrade_write\n"
-		: "+m" (sem->count)
-		: "a" (sem), "i" (-RWSEM_WAITING_BIAS)
-		: "memory", "cc");
+	asm volatile("# beginning __downgrade_write\n\t"
+		     LOCK_PREFIX "  addl      %2,(%%eax)\n\t"
+		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
+		     "  jns       1f\n\t"
+		     "  call call_rwsem_downgrade_wake\n"
+		     "1:\n\t"
+		     "# ending __downgrade_write\n"
+		     : "+m" (sem->count)
+		     : "a" (sem), "i" (-RWSEM_WAITING_BIAS)
+		     : "memory", "cc");
 }
 
 /*
@@ -232,10 +237,9 @@ LOCK_PREFIX	"  addl      %2,(%%eax)\n\t" /* transitions 0xZZZZ0001 -> 0xYYYY0001
  */
 static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
 {
-	__asm__ __volatile__(
-LOCK_PREFIX	"addl %1,%0"
-		: "+m" (sem->count)
-		: "ir" (delta));
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+		     : "+m" (sem->count)
+		     : "ir" (delta));
 }
 
 /*
@@ -245,12 +249,11 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 {
 	int tmp = delta;
 
-	__asm__ __volatile__(
-LOCK_PREFIX	"xadd %0,%1"
-		: "+r" (tmp), "+m" (sem->count)
-		: : "memory");
+	asm volatile(LOCK_PREFIX "xadd %0,%1"
+		     : "+r" (tmp), "+m" (sem->count)
+		     : : "memory");
 
-	return tmp+delta;
+	return tmp + delta;
 }
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
-- 
1.5.4.rc2

