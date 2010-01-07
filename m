Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934Ab0AGWqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0AGWqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866Ab0AGWqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:46:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:40815 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0AGWqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:46:18 -0500
Date: Thu, 7 Jan 2010 22:46:10 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1262883215-4034-4-git-send-email-brgerst@gmail.com>
References: <1262883215-4034-4-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Merge asm/atomic_{32,64}.h
Message-ID: <tip-5abbbbf0b0cd4abf5898136d0c345dc99b859c8c@git.kernel.org>
Git-Commit-ID: 5abbbbf0b0cd4abf5898136d0c345dc99b859c8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5abbbbf0b0cd4abf5898136d0c345dc99b859c8c
Gitweb:     http://git.kernel.org/tip/5abbbbf0b0cd4abf5898136d0c345dc99b859c8c
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Thu, 7 Jan 2010 11:53:35 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jan 2010 11:48:38 -0800

x86: Merge asm/atomic_{32,64}.h

Merge the now identical code from asm/atomic_32.h and asm/atomic_64.h
into asm/atomic.h.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1262883215-4034-4-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/atomic.h    |  299 +++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/atomic_32.h |  295 -------------------------------------
 arch/x86/include/asm/atomic_64.h |  295 -------------------------------------
 3 files changed, 297 insertions(+), 592 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 4e1b887..8baaa71 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -1,5 +1,300 @@
+#ifndef _ASM_X86_ATOMIC_H
+#define _ASM_X86_ATOMIC_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/processor.h>
+#include <asm/alternative.h>
+#include <asm/cmpxchg.h>
+
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc..
+ */
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.
+ */
+static inline int atomic_read(const atomic_t *v)
+{
+	return v->counter;
+}
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+}
+
+/**
+ * atomic_add - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic_add(int i, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_sub - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "subl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic_sub_and_test(int i, atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
+	return c;
+}
+
+/**
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic_inc(atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "incl %0"
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_dec - decrement atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic_dec(atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "decl %0"
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_dec_and_test - decrement and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic_dec_and_test(atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "decl %0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic_inc_and_test - increment and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic_inc_and_test(atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "incl %0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic_add_negative - add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
+	return c;
+}
+
+/**
+ * atomic_add_return - add integer and return
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	int __i;
+#ifdef CONFIG_M386
+	unsigned long flags;
+	if (unlikely(boot_cpu_data.x86 <= 3))
+		goto no_xadd;
+#endif
+	/* Modern 486+ processor */
+	__i = i;
+	asm volatile(LOCK_PREFIX "xaddl %0, %1"
+		     : "+r" (i), "+m" (v->counter)
+		     : : "memory");
+	return i + __i;
+
+#ifdef CONFIG_M386
+no_xadd: /* Legacy 386 processor */
+	local_irq_save(flags);
+	__i = atomic_read(v);
+	atomic_set(v, i + __i);
+	local_irq_restore(flags);
+	return i + __i;
+#endif
+}
+
+/**
+ * atomic_sub_return - subtract integer and return
+ * @v: pointer of type atomic_t
+ * @i: integer value to subtract
+ *
+ * Atomically subtracts @i from @v and returns @v - @i
+ */
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	return atomic_add_return(-i, v);
+}
+
+#define atomic_inc_return(v)  (atomic_add_return(1, v))
+#define atomic_dec_return(v)  (atomic_sub_return(1, v))
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline int atomic_xchg(atomic_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
+
+/**
+ * atomic_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
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
+
+/* These are x86-specific, used by some header files */
+#define atomic_clear_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "andl %0,%1"			\
+		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
+
+#define atomic_set_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "orl %0,%1"			\
+		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
+		     : "memory")
+
+/* Atomic operations are already serializing on x86 */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 #ifdef CONFIG_X86_32
-# include "atomic_32.h"
+# include "atomic64_32.h"
 #else
-# include "atomic_64.h"
+# include "atomic64_64.h"
 #endif
+
+#include <asm-generic/atomic-long.h>
+#endif /* _ASM_X86_ATOMIC_H */
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
deleted file mode 100644
index 036962e..0000000
--- a/arch/x86/include/asm/atomic_32.h
+++ /dev/null
@@ -1,295 +0,0 @@
-#ifndef _ASM_X86_ATOMIC_32_H
-#define _ASM_X86_ATOMIC_32_H
-
-#include <linux/compiler.h>
-#include <linux/types.h>
-#include <asm/processor.h>
-#include <asm/alternative.h>
-#include <asm/cmpxchg.h>
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-
-/**
- * atomic_read - read atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically reads the value of @v.
- */
-static inline int atomic_read(const atomic_t *v)
-{
-	return v->counter;
-}
-
-/**
- * atomic_set - set atomic variable
- * @v: pointer of type atomic_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.
- */
-static inline void atomic_set(atomic_t *v, int i)
-{
-	v->counter = i;
-}
-
-/**
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "addl %1,%0"
-		     : "+m" (v->counter)
-		     : "ir" (i));
-}
-
-/**
- * atomic_sub - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "subl %1,%0"
-		     : "+m" (v->counter)
-		     : "ir" (i));
-}
-
-/**
- * atomic_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_sub_and_test(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
- * atomic_inc - increment atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1.
- */
-static inline void atomic_inc(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "incl %0"
-		     : "+m" (v->counter));
-}
-
-/**
- * atomic_dec - decrement atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1.
- */
-static inline void atomic_dec(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "decl %0"
-		     : "+m" (v->counter));
-}
-
-/**
- * atomic_dec_and_test - decrement and test
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int atomic_dec_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_inc_and_test - increment and test
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_inc_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_add_negative - add and test if negative
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
- * atomic_add_return - add integer and return
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns @i + @v
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int __i;
-#ifdef CONFIG_M386
-	unsigned long flags;
-	if (unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
-	__i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	local_irq_save(flags);
-	__i = atomic_read(v);
-	atomic_set(v, i + __i);
-	local_irq_restore(flags);
-	return i + __i;
-#endif
-}
-
-/**
- * atomic_sub_return - subtract integer and return
- * @v: pointer of type atomic_t
- * @i: integer value to subtract
- *
- * Atomically subtracts @i from @v and returns @v - @i
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	return atomic_add_return(-i, v);
-}
-
-#define atomic_inc_return(v)  (atomic_add_return(1, v))
-#define atomic_dec_return(v)  (atomic_sub_return(1, v))
-
-static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
-{
-	return cmpxchg(&v->counter, old, new);
-}
-
-static inline int atomic_xchg(atomic_t *v, int new)
-{
-	return xchg(&v->counter, new);
-}
-
-/**
- * atomic_add_unless - add unless the number is already a given value
- * @v: pointer of type atomic_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
- */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
-{
-	int c, old;
-	c = atomic_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-/**
- * atomic_inc_short - increment of a short integer
- * @v: pointer to type int
- *
- * Atomically adds 1 to @v
- * Returns the new value of @u
- */
-static inline short int atomic_inc_short(short int *v)
-{
-	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
-	return *v;
-}
-
-#ifdef CONFIG_X86_64
-/**
- * atomic_or_long - OR of two long integers
- * @v1: pointer to type unsigned long
- * @v2: pointer to type unsigned long
- *
- * Atomically ORs @v1 and @v2
- * Returns the result of the OR
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
-}
-#endif
-
-/* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
-
-#define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"			\
-		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
-		     : "memory")
-
-/* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#include <asm/atomic64_32.h>
-#include <asm-generic/atomic-long.h>
-#endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
deleted file mode 100644
index 7740788..0000000
--- a/arch/x86/include/asm/atomic_64.h
+++ /dev/null
@@ -1,295 +0,0 @@
-#ifndef _ASM_X86_ATOMIC_64_H
-#define _ASM_X86_ATOMIC_64_H
-
-#include <linux/compiler.h>
-#include <linux/types.h>
-#include <asm/processor.h>
-#include <asm/alternative.h>
-#include <asm/cmpxchg.h>
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-
-/**
- * atomic_read - read atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically reads the value of @v.
- */
-static inline int atomic_read(const atomic_t *v)
-{
-	return v->counter;
-}
-
-/**
- * atomic_set - set atomic variable
- * @v: pointer of type atomic_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.
- */
-static inline void atomic_set(atomic_t *v, int i)
-{
-	v->counter = i;
-}
-
-/**
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "addl %1,%0"
-		     : "+m" (v->counter)
-		     : "ir" (i));
-}
-
-/**
- * atomic_sub - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "subl %1,%0"
-		     : "+m" (v->counter)
-		     : "ir" (i));
-}
-
-/**
- * atomic_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_sub_and_test(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
- * atomic_inc - increment atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1.
- */
-static inline void atomic_inc(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "incl %0"
-		     : "+m" (v->counter));
-}
-
-/**
- * atomic_dec - decrement atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1.
- */
-static inline void atomic_dec(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "decl %0"
-		     : "+m" (v->counter));
-}
-
-/**
- * atomic_dec_and_test - decrement and test
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int atomic_dec_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_inc_and_test - increment and test
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_inc_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_add_negative - add and test if negative
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
- * atomic_add_return - add integer and return
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns @i + @v
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int __i;
-#ifdef CONFIG_M386
-	unsigned long flags;
-	if (unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
-	__i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	local_irq_save(flags);
-	__i = atomic_read(v);
-	atomic_set(v, i + __i);
-	local_irq_restore(flags);
-	return i + __i;
-#endif
-}
-
-/**
- * atomic_sub_return - subtract integer and return
- * @v: pointer of type atomic_t
- * @i: integer value to subtract
- *
- * Atomically subtracts @i from @v and returns @v - @i
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	return atomic_add_return(-i, v);
-}
-
-#define atomic_inc_return(v)  (atomic_add_return(1, v))
-#define atomic_dec_return(v)  (atomic_sub_return(1, v))
-
-static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
-{
-	return cmpxchg(&v->counter, old, new);
-}
-
-static inline int atomic_xchg(atomic_t *v, int new)
-{
-	return xchg(&v->counter, new);
-}
-
-/**
- * atomic_add_unless - add unless the number is already a given value
- * @v: pointer of type atomic_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
- */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
-{
-	int c, old;
-	c = atomic_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-/**
- * atomic_inc_short - increment of a short integer
- * @v: pointer to type int
- *
- * Atomically adds 1 to @v
- * Returns the new value of @u
- */
-static inline short int atomic_inc_short(short int *v)
-{
-	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
-	return *v;
-}
-
-#ifdef CONFIG_X86_64
-/**
- * atomic_or_long - OR of two long integers
- * @v1: pointer to type unsigned long
- * @v2: pointer to type unsigned long
- *
- * Atomically ORs @v1 and @v2
- * Returns the result of the OR
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
-}
-#endif
-
-/* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
-
-#define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"			\
-		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
-		     : "memory")
-
-/* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#include <asm/atomic64_64.h>
-#include <asm-generic/atomic-long.h>
-#endif /* _ASM_X86_ATOMIC_64_H */
