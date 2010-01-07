Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385Ab0AGQx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0AGQx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172Ab0AGQxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:53:53 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49949 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0AGQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N4Y0EIm/ZqYrEzg8QIROZvplUMn8nnWPu16x23m1Nh6+HjWIQn5ywMPqCN9OGX94hS
         KHmKaenylgAp+LkDqIkMWYqW+cCjJvbRS6DYPsB/53Sx31C4WQJeyPYP2g0N7PplRwe7
         mouXkNDNAIhXBNq1aJINPhPLqNDmYp4GqXHc0=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: Split atomic64_t functions into seperate headers
Date: Thu,  7 Jan 2010 11:53:33 -0500
Message-Id: <1262883215-4034-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1262883215-4034-1-git-send-email-brgerst@gmail.com>
References: <1262883215-4034-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/atomic64_32.h |  160 +++++++++++++++++++++++++
 arch/x86/include/asm/atomic64_64.h |  224 ++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/atomic_32.h   |  152 +------------------------
 arch/x86/include/asm/atomic_64.h   |  217 +----------------------------------
 4 files changed, 386 insertions(+), 367 deletions(-)
 create mode 100644 arch/x86/include/asm/atomic64_32.h
 create mode 100644 arch/x86/include/asm/atomic64_64.h

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
new file mode 100644
index 0000000..03027bf
--- /dev/null
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -0,0 +1,160 @@
+#ifndef _ASM_X86_ATOMIC64_32_H
+#define _ASM_X86_ATOMIC64_32_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/processor.h>
+//#include <asm/cmpxchg.h>
+
+/* An 64bit atomic type */
+
+typedef struct {
+	u64 __aligned(8) counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(val)	{ (val) }
+
+extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
+
+/**
+ * atomic64_xchg - xchg atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically xchgs the value of @ptr to @new_val and returns
+ * the old value.
+ */
+extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+extern void atomic64_set(atomic64_t *ptr, u64 new_val);
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ *
+ * Atomically reads the value of @ptr and returns it.
+ */
+static inline u64 atomic64_read(atomic64_t *ptr)
+{
+	u64 res;
+
+	/*
+	 * Note, we inline this atomic64_t primitive because
+	 * it only clobbers EAX/EDX and leaves the others
+	 * untouched. We also (somewhat subtly) rely on the
+	 * fact that cmpxchg8b returns the current 64-bit value
+	 * of the memory location we are touching:
+	 */
+	asm volatile(
+		"mov %%ebx, %%eax\n\t"
+		"mov %%ecx, %%edx\n\t"
+		LOCK_PREFIX "cmpxchg8b %1\n"
+			: "=&A" (res)
+			: "m" (*ptr)
+		);
+
+	return res;
+}
+
+extern u64 atomic64_read(atomic64_t *ptr);
+
+/**
+ * atomic64_add_return - add and return
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ */
+extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
+
+/*
+ * Other variants with different arithmetic operators:
+ */
+extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
+extern u64 atomic64_inc_return(atomic64_t *ptr);
+extern u64 atomic64_dec_return(atomic64_t *ptr);
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr.
+ */
+extern void atomic64_add(u64 delta, atomic64_t *ptr);
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr.
+ */
+extern void atomic64_sub(u64 delta, atomic64_t *ptr);
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1.
+ */
+extern void atomic64_inc(atomic64_t *ptr);
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1.
+ */
+extern void atomic64_dec(atomic64_t *ptr);
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+extern int atomic64_dec_and_test(atomic64_t *ptr);
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+extern int atomic64_inc_and_test(atomic64_t *ptr);
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
+
+#endif /* _ASM_X86_ATOMIC64_32_H */
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
new file mode 100644
index 0000000..51c5b40
--- /dev/null
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -0,0 +1,224 @@
+#ifndef _ASM_X86_ATOMIC64_64_H
+#define _ASM_X86_ATOMIC64_64_H
+
+#include <linux/types.h>
+#include <asm/alternative.h>
+#include <asm/cmpxchg.h>
+
+/* The 64-bit atomic type */
+
+#define ATOMIC64_INIT(i)	{ (i) }
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically reads the value of @v.
+ * Doesn't imply a read memory barrier.
+ */
+static inline long atomic64_read(const atomic64_t *v)
+{
+	return v->counter;
+}
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @v: pointer to type atomic64_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static inline void atomic64_set(atomic64_t *v, long i)
+{
+	v->counter = i;
+}
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic64_add(long i, atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "addq %1,%0"
+		     : "=m" (v->counter)
+		     : "er" (i), "m" (v->counter));
+}
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline void atomic64_sub(long i, atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "subq %1,%0"
+		     : "=m" (v->counter)
+		     : "er" (i), "m" (v->counter));
+}
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic64_sub_and_test(long i, atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "er" (i), "m" (v->counter) : "memory");
+	return c;
+}
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic64_inc(atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "incq %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic64_dec(atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "decq %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically decrements @v by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic64_dec_and_test(atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "decq %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic64_inc_and_test(atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "incq %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically adds @i to @v and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int atomic64_add_negative(long i, atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "er" (i), "m" (v->counter) : "memory");
+	return c;
+}
+
+/**
+ * atomic64_add_return - add and return
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline long atomic64_add_return(long i, atomic64_t *v)
+{
+	long __i = i;
+	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
+		     : "+r" (i), "+m" (v->counter)
+		     : : "memory");
+	return i + __i;
+}
+
+static inline long atomic64_sub_return(long i, atomic64_t *v)
+{
+	return atomic64_add_return(-i, v);
+}
+
+#define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
+#define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
+
+static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline long atomic64_xchg(atomic64_t *v, long new)
+{
+	return xchg(&v->counter, new);
+}
+
+/**
+ * atomic64_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic64_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
+#endif /* _ASM_X86_ATOMIC64_64_H */
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index dc5a667..e128ae9 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -260,156 +260,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-/* An 64bit atomic type */
-
-typedef struct {
-	u64 __aligned(8) counter;
-} atomic64_t;
-
-#define ATOMIC64_INIT(val)	{ (val) }
-
-extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
-
-/**
- * atomic64_xchg - xchg atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically xchgs the value of @ptr to @new_val and returns
- * the old value.
- */
-extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
-
-/**
- * atomic64_set - set atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically sets the value of @ptr to @new_val.
- */
-extern void atomic64_set(atomic64_t *ptr, u64 new_val);
-
-/**
- * atomic64_read - read atomic64 variable
- * @ptr:      pointer to type atomic64_t
- *
- * Atomically reads the value of @ptr and returns it.
- */
-static inline u64 atomic64_read(atomic64_t *ptr)
-{
-	u64 res;
-
-	/*
-	 * Note, we inline this atomic64_t primitive because
-	 * it only clobbers EAX/EDX and leaves the others
-	 * untouched. We also (somewhat subtly) rely on the
-	 * fact that cmpxchg8b returns the current 64-bit value
-	 * of the memory location we are touching:
-	 */
-	asm volatile(
-		"mov %%ebx, %%eax\n\t"
-		"mov %%ecx, %%edx\n\t"
-		LOCK_PREFIX "cmpxchg8b %1\n"
-			: "=&A" (res)
-			: "m" (*ptr)
-		);
-
-	return res;
-}
-
-extern u64 atomic64_read(atomic64_t *ptr);
-
-/**
- * atomic64_add_return - add and return
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr and returns @delta + *@ptr
- */
-extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
-
-/*
- * Other variants with different arithmetic operators:
- */
-extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
-extern u64 atomic64_inc_return(atomic64_t *ptr);
-extern u64 atomic64_dec_return(atomic64_t *ptr);
-
-/**
- * atomic64_add - add integer to atomic64 variable
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr.
- */
-extern void atomic64_add(u64 delta, atomic64_t *ptr);
-
-/**
- * atomic64_sub - subtract the atomic64 variable
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr.
- */
-extern void atomic64_sub(u64 delta, atomic64_t *ptr);
-
-/**
- * atomic64_sub_and_test - subtract value from variable and test result
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
-
-/**
- * atomic64_inc - increment atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1.
- */
-extern void atomic64_inc(atomic64_t *ptr);
-
-/**
- * atomic64_dec - decrement atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1.
- */
-extern void atomic64_dec(atomic64_t *ptr);
-
-/**
- * atomic64_dec_and_test - decrement and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-extern int atomic64_dec_and_test(atomic64_t *ptr);
-
-/**
- * atomic64_inc_and_test - increment and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-extern int atomic64_inc_and_test(atomic64_t *ptr);
-
-/**
- * atomic64_add_negative - add and test if negative
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
-
+#include <asm/atomic64_32.h>
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index d605dc2..042c331 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -187,196 +187,6 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 #define atomic_inc_return(v)  (atomic_add_return(1, v))
 #define atomic_dec_return(v)  (atomic_sub_return(1, v))
 
-/* The 64-bit atomic type */
-
-#define ATOMIC64_INIT(i)	{ (i) }
-
-/**
- * atomic64_read - read atomic64 variable
- * @v: pointer of type atomic64_t
- *
- * Atomically reads the value of @v.
- * Doesn't imply a read memory barrier.
- */
-static inline long atomic64_read(const atomic64_t *v)
-{
-	return v->counter;
-}
-
-/**
- * atomic64_set - set atomic64 variable
- * @v: pointer to type atomic64_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.
- */
-static inline void atomic64_set(atomic64_t *v, long i)
-{
-	v->counter = i;
-}
-
-/**
- * atomic64_add - add integer to atomic64 variable
- * @i: integer value to add
- * @v: pointer to type atomic64_t
- *
- * Atomically adds @i to @v.
- */
-static inline void atomic64_add(long i, atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "addq %1,%0"
-		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
-}
-
-/**
- * atomic64_sub - subtract the atomic64 variable
- * @i: integer value to subtract
- * @v: pointer to type atomic64_t
- *
- * Atomically subtracts @i from @v.
- */
-static inline void atomic64_sub(long i, atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "subq %1,%0"
-		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
-}
-
-/**
- * atomic64_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @v: pointer to type atomic64_t
- *
- * Atomically subtracts @i from @v and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic64_sub_and_test(long i, atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
-}
-
-/**
- * atomic64_inc - increment atomic64 variable
- * @v: pointer to type atomic64_t
- *
- * Atomically increments @v by 1.
- */
-static inline void atomic64_inc(atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "incq %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
-}
-
-/**
- * atomic64_dec - decrement atomic64 variable
- * @v: pointer to type atomic64_t
- *
- * Atomically decrements @v by 1.
- */
-static inline void atomic64_dec(atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "decq %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
-}
-
-/**
- * atomic64_dec_and_test - decrement and test
- * @v: pointer to type atomic64_t
- *
- * Atomically decrements @v by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int atomic64_dec_and_test(atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
-}
-
-/**
- * atomic64_inc_and_test - increment and test
- * @v: pointer to type atomic64_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic64_inc_and_test(atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
-}
-
-/**
- * atomic64_add_negative - add and test if negative
- * @i: integer value to add
- * @v: pointer to type atomic64_t
- *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int atomic64_add_negative(long i, atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
-}
-
-/**
- * atomic64_add_return - add and return
- * @i: integer value to add
- * @v: pointer to type atomic64_t
- *
- * Atomically adds @i to @v and returns @i + @v
- */
-static inline long atomic64_add_return(long i, atomic64_t *v)
-{
-	long __i = i;
-	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
-}
-
-static inline long atomic64_sub_return(long i, atomic64_t *v)
-{
-	return atomic64_add_return(-i, v);
-}
-
-#define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
-#define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
-
-static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
-{
-	return cmpxchg(&v->counter, old, new);
-}
-
-static inline long atomic64_xchg(atomic64_t *v, long new)
-{
-	return xchg(&v->counter, new);
-}
-
 static inline long atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	return cmpxchg(&v->counter, old, new);
@@ -414,30 +224,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
- * atomic64_add_unless - add unless the number is a given value
- * @v: pointer of type atomic64_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
- */
-static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
-{
-	long c, old;
-	c = atomic64_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic64_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-/**
  * atomic_inc_short - increment of a short integer
  * @v: pointer to type int
  *
@@ -463,8 +249,6 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
 }
 
-#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
-
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)					\
 	asm volatile(LOCK_PREFIX "andl %0,%1"				\
@@ -481,5 +265,6 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
+#include <asm/atomic64_64.h>
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_64_H */
-- 
1.6.5.2

