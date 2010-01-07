Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830Ab0AGWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0AGWqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808Ab0AGWqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:46:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:40812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab0AGWqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:46:17 -0500
Date: Thu, 7 Jan 2010 22:45:54 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1262883215-4034-3-git-send-email-brgerst@gmail.com>
References: <1262883215-4034-3-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Sync asm/atomic_32.h and asm/atomic_64.h
Message-ID: <tip-3ce59bb8352e1c53446bef1ead1c63956dfef64a@git.kernel.org>
Git-Commit-ID: 3ce59bb8352e1c53446bef1ead1c63956dfef64a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ce59bb8352e1c53446bef1ead1c63956dfef64a
Gitweb:     http://git.kernel.org/tip/3ce59bb8352e1c53446bef1ead1c63956dfef64a
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Thu, 7 Jan 2010 11:53:34 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jan 2010 11:47:55 -0800

x86: Sync asm/atomic_32.h and asm/atomic_64.h

Prepare for merging into asm/atomic.h.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1262883215-4034-3-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/atomic_32.h |   42 +++++++++++++++++---
 arch/x86/include/asm/atomic_64.h |   81 +++++++++++++++++++++++++-------------
 2 files changed, 89 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index e128ae9..036962e 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -4,6 +4,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/processor.h>
+#include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 
 /*
@@ -145,8 +146,8 @@ static inline int atomic_inc_and_test(atomic_t *v)
 
 /**
  * atomic_add_negative - add and test if negative
- * @v: pointer of type atomic_t
  * @i: integer value to add
+ * @v: pointer of type atomic_t
  *
  * Atomically adds @i to @v and returns true
  * if the result is negative, or false when
@@ -164,8 +165,8 @@ static inline int atomic_add_negative(int i, atomic_t *v)
 
 /**
  * atomic_add_return - add integer and return
- * @v: pointer of type atomic_t
  * @i: integer value to add
+ * @v: pointer of type atomic_t
  *
  * Atomically adds @i to @v and returns @i + @v
  */
@@ -206,6 +207,9 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	return atomic_add_return(-i, v);
 }
 
+#define atomic_inc_return(v)  (atomic_add_return(1, v))
+#define atomic_dec_return(v)  (atomic_sub_return(1, v))
+
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	return cmpxchg(&v->counter, old, new);
@@ -242,8 +246,33 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#define atomic_inc_return(v)  (atomic_add_return(1, v))
-#define atomic_dec_return(v)  (atomic_sub_return(1, v))
+/**
+ * atomic_inc_short - increment of a short integer
+ * @v: pointer to type int
+ *
+ * Atomically adds 1 to @v
+ * Returns the new value of @u
+ */
+static inline short int atomic_inc_short(short int *v)
+{
+	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
+	return *v;
+}
+
+#ifdef CONFIG_X86_64
+/**
+ * atomic_or_long - OR of two long integers
+ * @v1: pointer to type unsigned long
+ * @v2: pointer to type unsigned long
+ *
+ * Atomically ORs @v1 and @v2
+ * Returns the result of the OR
+ */
+static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
+{
+	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
+}
+#endif
 
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
@@ -251,8 +280,9 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
 
 #define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"				\
-		     : : "r" (mask), "m" (*(addr)) : "memory")
+	asm volatile(LOCK_PREFIX "orl %0,%1"			\
+		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
+		     : "memory")
 
 /* Atomic operations are already serializing on x86 */
 #define smp_mb__before_atomic_dec()	barrier()
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index 042c331..7740788 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -1,7 +1,9 @@
 #ifndef _ASM_X86_ATOMIC_64_H
 #define _ASM_X86_ATOMIC_64_H
 
+#include <linux/compiler.h>
 #include <linux/types.h>
+#include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 
@@ -45,12 +47,12 @@ static inline void atomic_set(atomic_t *v, int i)
 static inline void atomic_add(int i, atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "addl %1,%0"
-		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
+		     : "+m" (v->counter)
+		     : "ir" (i));
 }
 
 /**
- * atomic_sub - subtract the atomic variable
+ * atomic_sub - subtract integer from atomic variable
  * @i: integer value to subtract
  * @v: pointer of type atomic_t
  *
@@ -59,8 +61,8 @@ static inline void atomic_add(int i, atomic_t *v)
 static inline void atomic_sub(int i, atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "subl %1,%0"
-		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
+		     : "+m" (v->counter)
+		     : "ir" (i));
 }
 
 /**
@@ -77,8 +79,8 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
 	unsigned char c;
 
 	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
 	return c;
 }
 
@@ -91,8 +93,7 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
 static inline void atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
+		     : "+m" (v->counter));
 }
 
 /**
@@ -104,8 +105,7 @@ static inline void atomic_inc(atomic_t *v)
 static inline void atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
+		     : "+m" (v->counter));
 }
 
 /**
@@ -121,8 +121,8 @@ static inline int atomic_dec_and_test(atomic_t *v)
 	unsigned char c;
 
 	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
 	return c != 0;
 }
 
@@ -139,8 +139,8 @@ static inline int atomic_inc_and_test(atomic_t *v)
 	unsigned char c;
 
 	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
 	return c != 0;
 }
 
@@ -158,13 +158,13 @@ static inline int atomic_add_negative(int i, atomic_t *v)
 	unsigned char c;
 
 	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
 	return c;
 }
 
 /**
- * atomic_add_return - add and return
+ * atomic_add_return - add integer and return
  * @i: integer value to add
  * @v: pointer of type atomic_t
  *
@@ -172,13 +172,36 @@ static inline int atomic_add_negative(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
-	int __i = i;
+	int __i;
+#ifdef CONFIG_M386
+	unsigned long flags;
+	if (unlikely(boot_cpu_data.x86 <= 3))
+		goto no_xadd;
+#endif
+	/* Modern 486+ processor */
+	__i = i;
 	asm volatile(LOCK_PREFIX "xaddl %0, %1"
 		     : "+r" (i), "+m" (v->counter)
 		     : : "memory");
 	return i + __i;
+
+#ifdef CONFIG_M386
+no_xadd: /* Legacy 386 processor */
+	local_irq_save(flags);
+	__i = atomic_read(v);
+	atomic_set(v, i + __i);
+	local_irq_restore(flags);
+	return i + __i;
+#endif
 }
 
+/**
+ * atomic_sub_return - subtract integer and return
+ * @v: pointer of type atomic_t
+ * @i: integer value to subtract
+ *
+ * Atomically subtracts @i from @v and returns @v - @i
+ */
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
 	return atomic_add_return(-i, v);
@@ -187,23 +210,23 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 #define atomic_inc_return(v)  (atomic_add_return(1, v))
 #define atomic_dec_return(v)  (atomic_sub_return(1, v))
 
-static inline long atomic_cmpxchg(atomic_t *v, int old, int new)
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	return cmpxchg(&v->counter, old, new);
 }
 
-static inline long atomic_xchg(atomic_t *v, int new)
+static inline int atomic_xchg(atomic_t *v, int new)
 {
 	return xchg(&v->counter, new);
 }
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
- * Atomically adds @a to @v, so long as it was not @u.
+ * Atomically adds @a to @v, so long as @v was not already @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
 static inline int atomic_add_unless(atomic_t *v, int a, int u)
@@ -236,6 +259,7 @@ static inline short int atomic_inc_short(short int *v)
 	return *v;
 }
 
+#ifdef CONFIG_X86_64
 /**
  * atomic_or_long - OR of two long integers
  * @v1: pointer to type unsigned long
@@ -248,15 +272,16 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 {
 	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
 }
+#endif
 
 /* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)					\
-	asm volatile(LOCK_PREFIX "andl %0,%1"				\
+#define atomic_clear_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "andl %0,%1"			\
 		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
 
-#define atomic_set_mask(mask, addr)					\
-	asm volatile(LOCK_PREFIX "orl %0,%1"				\
-		     : : "r" ((unsigned)(mask)), "m" (*(addr))		\
+#define atomic_set_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "orl %0,%1"			\
+		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
 		     : "memory")
 
 /* Atomic operations are already serializing on x86 */
