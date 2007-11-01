Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbXKAOEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbXKAOEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXKAOEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:04:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXKAOEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:04:13 -0400
Date: Thu, 1 Nov 2007 15:04:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 3/4] x86: spinlock.h merge prep
Message-ID: <20071101140412.GD26879@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101140146.GA26879@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Prepare for merging 32 and 64 bit spinlocks, by making them identical
(except for the OOSTORE thing). raw_read_lock and raw_write_lock get a
relaxed register constraint, and 64-bit has a few "=m" constraints changed
to "+m". I hope these things actually make the code better.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/include/asm-x86/spinlock_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/spinlock_32.h
+++ linux-2.6/include/asm-x86/spinlock_32.h
@@ -98,14 +98,15 @@ static inline int __raw_spin_trylock(raw
 	return ret;
 }
 
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+#if defined(CONFIG_X86_32) && \
+	(defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE))
 /*
  * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
  * (PPro errata 66, 92)
  */
-#define UNLOCK_LOCK_PREFIX LOCK_PREFIX
+# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
 #else
-#define UNLOCK_LOCK_PREFIX
+# define UNLOCK_LOCK_PREFIX
 #endif
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
@@ -135,49 +136,42 @@ static inline void __raw_spin_unlock_wai
  *
  * On x86, we implement read-write locks as a 32-bit counter
  * with the high bit (sign) being the "contended" bit.
- *
- * The inline assembly is non-obvious. Think about it.
- *
- * Changed to use the same technique as rw semaphores.  See
- * semaphore.h for details.  -ben
- *
- * the helpers are in arch/i386/kernel/semaphore.c
  */
 
 /**
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static inline int __raw_read_can_lock(raw_rwlock_t *x)
+static inline int __raw_read_can_lock(raw_rwlock_t *lock)
 {
-	return (int)(x)->lock > 0;
+	return (int)(lock)->lock > 0;
 }
 
 /**
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static inline int __raw_write_can_lock(raw_rwlock_t *x)
+static inline int __raw_write_can_lock(raw_rwlock_t *lock)
 {
-	return (x)->lock == RW_LOCK_BIAS;
+	return (lock)->lock == RW_LOCK_BIAS;
 }
 
 static inline void __raw_read_lock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " subl $1,(%0)\n\t"
+	asm volatile(LOCK_PREFIX "subl $1,(%0)\n\t"
 		     "jns 1f\n"
 		     "call __read_lock_failed\n\t"
 		     "1:\n"
-		     ::"a" (rw) : "memory");
+		     ::"r" (rw) : "memory");
 }
 
 static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " subl $" RW_LOCK_BIAS_STR ",(%0)\n\t"
+	asm volatile(LOCK_PREFIX "subl %1,(%0)\n\t"
 		     "jz 1f\n"
 		     "call __write_lock_failed\n\t"
 		     "1:\n"
-		     ::"a" (rw) : "memory");
+		     ::"r" (rw), "i" (RW_LOCK_BIAS) : "memory");
 }
 
 static inline int __raw_read_trylock(raw_rwlock_t *lock)
@@ -206,8 +200,8 @@ static inline void __raw_read_unlock(raw
 
 static inline void __raw_write_unlock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "addl $" RW_LOCK_BIAS_STR ", %0"
-				 : "+m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+			: "+m" (rw->lock) : "i" (RW_LOCK_BIAS) : "memory");
 }
 
 #define _raw_spin_relax(lock)	cpu_relax()
Index: linux-2.6/include/asm-x86/spinlock_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/spinlock_64.h
+++ linux-2.6/include/asm-x86/spinlock_64.h
@@ -5,6 +5,7 @@
 #include <asm/rwlock.h>
 #include <asm/page.h>
 #include <asm/processor.h>
+#include <linux/compiler.h>
 
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
@@ -126,11 +127,19 @@ static inline void __raw_spin_unlock_wai
  * with the high bit (sign) being the "contended" bit.
  */
 
+/**
+ * read_can_lock - would read_trylock() succeed?
+ * @lock: the rwlock in question.
+ */
 static inline int __raw_read_can_lock(raw_rwlock_t *lock)
 {
 	return (int)(lock)->lock > 0;
 }
 
+/**
+ * write_can_lock - would write_trylock() succeed?
+ * @lock: the rwlock in question.
+ */
 static inline int __raw_write_can_lock(raw_rwlock_t *lock)
 {
 	return (lock)->lock == RW_LOCK_BIAS;
@@ -140,18 +149,18 @@ static inline void __raw_read_lock(raw_r
 {
 	asm volatile(LOCK_PREFIX "subl $1,(%0)\n\t"
 		     "jns 1f\n"
-		     "call __read_lock_failed\n"
+		     "call __read_lock_failed\n\t"
 		     "1:\n"
-		     ::"D" (rw), "i" (RW_LOCK_BIAS) : "memory");
+		     ::"r" (rw) : "memory");
 }
 
 static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX "subl %1,(%0)\n\t"
 		     "jz 1f\n"
-		     "\tcall __write_lock_failed\n\t"
+		     "call __write_lock_failed\n\t"
 		     "1:\n"
-		     ::"D" (rw), "i" (RW_LOCK_BIAS) : "memory");
+		     ::"r" (rw), "i" (RW_LOCK_BIAS) : "memory");
 }
 
 static inline int __raw_read_trylock(raw_rwlock_t *lock)
@@ -175,13 +184,13 @@ static inline int __raw_write_trylock(ra
 
 static inline void __raw_read_unlock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " ; incl %0" :"=m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX "incl %0" :"+m" (rw->lock) : : "memory");
 }
 
 static inline void __raw_write_unlock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " ; addl $" RW_LOCK_BIAS_STR ",%0"
-				: "=m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+			: "+m" (rw->lock) : "i" (RW_LOCK_BIAS) : "memory");
 }
 
 #define _raw_spin_relax(lock)	cpu_relax()
