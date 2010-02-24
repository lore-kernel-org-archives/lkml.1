Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0BXJyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:54:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:58043 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0BXJyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WT7gfT8/WYpEHcLHvzgB3eKGcmknPN8KexmSlJgiqbnsI8ofXKN/iPAVUBXRqzHG2m
         N8o933xPYDUOdrGPNoNZ5zbM/piGUVmZ7LeQPaSm0jc9qNM+dI+e1mb27vy+7WeeHbe7
         BG42LvfoAWyTWmr1xj8Ffn6P6o+vs2rW1N/QU=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 4/4] x86-32: rewrite 32-bit atomic64 functions in assembly (v3)
Date: Wed, 24 Feb 2010 10:54:25 +0100
Message-Id: <1267005265-27958-5-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267005265-27958-1-git-send-email-luca@luca-barbieri.com>
References: <1267005265-27958-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v3 (due to rebasing to tip/x86/asm):
- Patches atomic64_32.h instead of atomic_32.h
- Uses the CALL alternative mechanism from commit
  1b1d9258181bae199dc940f4bd0298126b9a73d9

Changes in v2:
- Merged 386 and cx8 support in the same patch
- 386 support now done in assembly, C code no longer used at all
- cmpxchg64 is used for atomic64_cmpxchg
- stop using macros, use one-line inline functions instead
- miscellanous changes and improvements

This patch replaces atomic64_32.c with two assembly implementations,
one for 386/486 machines using pushf/cli/popf and one for 586+ machines
using cmpxchg8b.

The cmpxchg8b implementation provides the following advantages over the
current one:

1. Implements atomic64_add_unless, atomic64_dec_if_positive and
   atomic64_inc_not_zero

2. Uses the ZF flag changed by cmpxchg8b instead of doing a comparison

3. Uses custom register calling conventions that reduce or eliminate
   register moves to suit cmpxchg8b

4. Reads the initial value instead of using cmpxchg8b to do that.
   Currently we use lock xaddl and movl, which seems the fastest.

5. Does not use the lock prefix for atomic64_set
   64-bit writes are already atomic, so we don't need that.
   We still need it for atomic64_read to avoid restoring a value
   changed in the meantime.

6. Allocates registers as well or better than gcc

The 386 implementation provides support for 386 and 486 machines.
386/486 SMP is not supported (we dropped it), but such support can be
added easily if desired.

A pure assembly implementation is required due to the custom calling
conventions, and desire to use %ebp in atomic64_add_return (we need
7 registers...), as well as the ability to use pushf/popf in the 386
code without an intermediate pop/push.

The parameter names are changed to match the convention in atomic_64.h

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/atomic64_32.h |  278 +++++++++++++++++++++++++++---------
 arch/x86/lib/Makefile              |    3 +-
 arch/x86/lib/atomic64_32.c         |  273 +++++++----------------------------
 arch/x86/lib/atomic64_386_32.S     |  175 ++++++++++++++++++++++
 arch/x86/lib/atomic64_cx8_32.S     |  225 +++++++++++++++++++++++++++++
 5 files changed, 664 insertions(+), 290 deletions(-)
 create mode 100644 arch/x86/lib/atomic64_386_32.S
 create mode 100644 arch/x86/lib/atomic64_cx8_32.S

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 03027bf..2a934aa 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -14,109 +14,193 @@ typedef struct {
 
 #define ATOMIC64_INIT(val)	{ (val) }
 
-extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
+#ifdef CONFIG_X86_CMPXCHG64
+#define ATOMIC64_ALTERNATIVE_(f, g) "call atomic64_" #g "_cx8"
+#else
+#define ATOMIC64_ALTERNATIVE_(f, g) ALTERNATIVE("call atomic64_" #f "_386", "call atomic64_" #g "_cx8", X86_FEATURE_CX8)
+#endif
+
+#define ATOMIC64_ALTERNATIVE(f) ATOMIC64_ALTERNATIVE_(f, f)
+
+/**
+ * atomic64_cmpxchg - cmpxchg atomic64 variable
+ * @p: pointer to type atomic64_t
+ * @o: expected value
+ * @n: new value
+ *
+ * Atomically sets @v to @n if it was equal to @o and returns
+ * the old value.
+ */
+
+static inline long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
+{
+	return cmpxchg64(&v->counter, o, n);
+}
 
 /**
  * atomic64_xchg - xchg atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
+ * @v: pointer to type atomic64_t
+ * @n: value to assign
  *
- * Atomically xchgs the value of @ptr to @new_val and returns
+ * Atomically xchgs the value of @v to @n and returns
  * the old value.
  */
-extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
+static inline long long atomic64_xchg(atomic64_t *v, long long n)
+{
+	long long o;
+	unsigned high = (unsigned)(n >> 32);
+	unsigned low = (unsigned)n;
+	asm volatile(ATOMIC64_ALTERNATIVE(xchg)
+		     : "=A" (o), "+b" (low), "+c" (high)
+		     : "S" (v)
+		     : "memory"
+		     );
+	return o;
+}
 
 /**
  * atomic64_set - set atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
+ * @v: pointer to type atomic64_t
+ * @n: value to assign
  *
- * Atomically sets the value of @ptr to @new_val.
+ * Atomically sets the value of @v to @n.
  */
-extern void atomic64_set(atomic64_t *ptr, u64 new_val);
+static inline void atomic64_set(atomic64_t *v, long long i)
+{
+	unsigned high = (unsigned)(i >> 32);
+	unsigned low = (unsigned)i;
+	asm volatile(ATOMIC64_ALTERNATIVE(set)
+		     : "+b" (low), "+c" (high)
+		     : "S" (v)
+		     : "eax", "edx", "memory"
+		     );
+}
 
 /**
  * atomic64_read - read atomic64 variable
- * @ptr:      pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically reads the value of @ptr and returns it.
+ * Atomically reads the value of @v and returns it.
  */
-static inline u64 atomic64_read(atomic64_t *ptr)
+static inline long long atomic64_read(atomic64_t *v)
 {
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
+	long long r;
+	asm volatile(ATOMIC64_ALTERNATIVE(read)
+		     : "=A" (r), "+c" (v)
+		     : : "memory"
+		     );
+	return r;
+ }
 
 /**
  * atomic64_add_return - add and return
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
  *
- * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ * Atomically adds @i to @v and returns @i + *@v
  */
-extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
+static inline long long atomic64_add_return(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE(add_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
 
 /*
  * Other variants with different arithmetic operators:
  */
-extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
-extern u64 atomic64_inc_return(atomic64_t *ptr);
-extern u64 atomic64_dec_return(atomic64_t *ptr);
+static inline long long atomic64_sub_return(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE(sub_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
+
+static inline long long atomic64_inc_return(atomic64_t *v)
+{
+	long long a;
+	asm volatile(ATOMIC64_ALTERNATIVE(inc_return)
+		     : "=A" (a)
+		     : "S" (v)
+		     : "memory", "ecx"
+		     );
+	return a;
+}
+
+static inline long long atomic64_dec_return(atomic64_t *v)
+{
+	long long a;
+	asm volatile(ATOMIC64_ALTERNATIVE(dec_return)
+		     : "=A" (a)
+		     : "S" (v)
+		     : "memory", "ecx"
+		     );
+	return a;
+}
 
 /**
  * atomic64_add - add integer to atomic64 variable
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
  *
- * Atomically adds @delta to @ptr.
+ * Atomically adds @i to @v.
  */
-extern void atomic64_add(u64 delta, atomic64_t *ptr);
+static inline long long atomic64_add(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(add, add_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
 
 /**
  * atomic64_sub - subtract the atomic64 variable
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
  *
- * Atomically subtracts @delta from @ptr.
+ * Atomically subtracts @i from @v.
  */
-extern void atomic64_sub(u64 delta, atomic64_t *ptr);
+static inline long long atomic64_sub(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(sub, sub_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
 
 /**
  * atomic64_sub_and_test - subtract value from variable and test result
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr and returns
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
+  *
+ * Atomically subtracts @i from @v and returns
  * true if the result is zero, or false for all
  * other cases.
  */
-extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
+static inline int atomic64_sub_and_test(long long i, atomic64_t *v)
+{
+	return atomic64_sub_return(i, v) == 0;
+}
 
 /**
  * atomic64_inc - increment atomic64 variable
- * @ptr: pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically increments @ptr by 1.
+ * Atomically increments @v by 1.
  */
-extern void atomic64_inc(atomic64_t *ptr);
+static inline void atomic64_inc(atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(inc, inc_return)
+		     : : "S" (v)
+		     : "memory", "eax", "ecx", "edx"
+		     );
+}
 
 /**
  * atomic64_dec - decrement atomic64 variable
@@ -124,37 +208,97 @@ extern void atomic64_inc(atomic64_t *ptr);
  *
  * Atomically decrements @ptr by 1.
  */
-extern void atomic64_dec(atomic64_t *ptr);
+static inline void atomic64_dec(atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(dec, dec_return)
+		     : : "S" (v)
+		     : "memory", "eax", "ecx", "edx"
+		     );
+}
 
 /**
  * atomic64_dec_and_test - decrement and test
- * @ptr: pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically decrements @ptr by 1 and
+ * Atomically decrements @v by 1 and
  * returns true if the result is 0, or false for all other
  * cases.
  */
-extern int atomic64_dec_and_test(atomic64_t *ptr);
+static inline int atomic64_dec_and_test(atomic64_t *v)
+{
+	return atomic64_dec_return(v) == 0;
+}
 
 /**
  * atomic64_inc_and_test - increment and test
- * @ptr: pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically increments @ptr by 1
+ * Atomically increments @v by 1
  * and returns true if the result is zero, or false for all
  * other cases.
  */
-extern int atomic64_inc_and_test(atomic64_t *ptr);
+static inline int atomic64_inc_and_test(atomic64_t *v)
+{
+	return atomic64_inc_return(v) == 0;
+}
 
 /**
  * atomic64_add_negative - add and test if negative
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
  *
- * Atomically adds @delta to @ptr and returns true
+ * Atomically adds @i to @v and returns true
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
+static inline int atomic64_add_negative(long long i, atomic64_t *v)
+{
+	return atomic64_add_return(i, v) < 0;
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
+static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
+{
+	unsigned low = (unsigned)u;
+	unsigned high = (unsigned)(u >> 32);
+	asm volatile(ATOMIC64_ALTERNATIVE(add_unless) "\n\t"
+		     : "+A" (a), "+c" (v), "+S" (low), "+D" (high)
+		     : : "memory");
+	return (int)a;
+}
+
+
+static inline int atomic64_inc_not_zero(atomic64_t *v)
+{
+	int r;
+	asm volatile(ATOMIC64_ALTERNATIVE(inc_not_zero)
+		     : "=a" (r)
+		     : "S" (v)
+		     : "ecx", "edx", "memory"
+		     );
+	return r;
+}
+
+static inline long long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long long r;
+	asm volatile(ATOMIC64_ALTERNATIVE(dec_if_positive)
+		     : "=A" (r)
+		     : "S" (v)
+		     : "ecx", "memory"
+		     );
+	return r;
+}
+
+#undef ATOMIC64_ALTERNATIVE
+#undef ATOMIC64_ALTERNATIVE_
 
 #endif /* _ASM_X86_ATOMIC64_32_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..05d686b 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -26,11 +26,12 @@ obj-y += msr.o msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
+        lib-y += atomic64_cx8_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += semaphore_32.o string_32.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
-        lib-y += cmpxchg8b_emu.o
+        lib-y += cmpxchg8b_emu.o atomic64_386_32.o
 endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 824fa0b..540179e 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -6,225 +6,54 @@
 #include <asm/cmpxchg.h>
 #include <asm/atomic.h>
 
-static noinline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
-{
-	u32 low = new;
-	u32 high = new >> 32;
-
-	asm volatile(
-		LOCK_PREFIX "cmpxchg8b %1\n"
-		     : "+A" (old), "+m" (*ptr)
-		     :  "b" (low),  "c" (high)
-		     );
-	return old;
-}
-
-u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val)
-{
-	return cmpxchg8b(&ptr->counter, old_val, new_val);
-}
-EXPORT_SYMBOL(atomic64_cmpxchg);
-
-/**
- * atomic64_xchg - xchg atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically xchgs the value of @ptr to @new_val and returns
- * the old value.
- */
-u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
-{
-	/*
-	 * Try first with a (possibly incorrect) assumption about
-	 * what we have there. We'll do two loops most likely,
-	 * but we'll get an ownership MESI transaction straight away
-	 * instead of a read transaction followed by a
-	 * flush-for-ownership transaction:
-	 */
-	u64 old_val, real_val = 0;
-
-	do {
-		old_val = real_val;
-
-		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
-
-	} while (real_val != old_val);
-
-	return old_val;
-}
-EXPORT_SYMBOL(atomic64_xchg);
-
-/**
- * atomic64_set - set atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically sets the value of @ptr to @new_val.
- */
-void atomic64_set(atomic64_t *ptr, u64 new_val)
-{
-	atomic64_xchg(ptr, new_val);
-}
-EXPORT_SYMBOL(atomic64_set);
-
-/**
-EXPORT_SYMBOL(atomic64_read);
- * atomic64_add_return - add and return
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr and returns @delta + *@ptr
- */
-noinline u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
-{
-	/*
-	 * Try first with a (possibly incorrect) assumption about
-	 * what we have there. We'll do two loops most likely,
-	 * but we'll get an ownership MESI transaction straight away
-	 * instead of a read transaction followed by a
-	 * flush-for-ownership transaction:
-	 */
-	u64 old_val, new_val, real_val = 0;
-
-	do {
-		old_val = real_val;
-		new_val = old_val + delta;
-
-		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
-
-	} while (real_val != old_val);
-
-	return new_val;
-}
-EXPORT_SYMBOL(atomic64_add_return);
-
-u64 atomic64_sub_return(u64 delta, atomic64_t *ptr)
-{
-	return atomic64_add_return(-delta, ptr);
-}
-EXPORT_SYMBOL(atomic64_sub_return);
-
-u64 atomic64_inc_return(atomic64_t *ptr)
-{
-	return atomic64_add_return(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_inc_return);
-
-u64 atomic64_dec_return(atomic64_t *ptr)
-{
-	return atomic64_sub_return(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_dec_return);
-
-/**
- * atomic64_add - add integer to atomic64 variable
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr.
- */
-void atomic64_add(u64 delta, atomic64_t *ptr)
-{
-	atomic64_add_return(delta, ptr);
-}
-EXPORT_SYMBOL(atomic64_add);
-
-/**
- * atomic64_sub - subtract the atomic64 variable
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr.
- */
-void atomic64_sub(u64 delta, atomic64_t *ptr)
-{
-	atomic64_add(-delta, ptr);
-}
-EXPORT_SYMBOL(atomic64_sub);
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
-int atomic64_sub_and_test(u64 delta, atomic64_t *ptr)
-{
-	u64 new_val = atomic64_sub_return(delta, ptr);
-
-	return new_val == 0;
-}
-EXPORT_SYMBOL(atomic64_sub_and_test);
-
-/**
- * atomic64_inc - increment atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1.
- */
-void atomic64_inc(atomic64_t *ptr)
-{
-	atomic64_add(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_inc);
-
-/**
- * atomic64_dec - decrement atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1.
- */
-void atomic64_dec(atomic64_t *ptr)
-{
-	atomic64_sub(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_dec);
-
-/**
- * atomic64_dec_and_test - decrement and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-int atomic64_dec_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_dec_and_test);
-
-/**
- * atomic64_inc_and_test - increment and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-int atomic64_inc_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(-1, ptr);
-}
-EXPORT_SYMBOL(atomic64_inc_and_test);
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
-int atomic64_add_negative(u64 delta, atomic64_t *ptr)
-{
-	s64 new_val = atomic64_add_return(delta, ptr);
-
-	return new_val < 0;
-}
-EXPORT_SYMBOL(atomic64_add_negative);
+long long atomic64_read_cx8(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_read_cx8);
+long long atomic64_set_cx8(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_set_cx8);
+long long atomic64_xchg_cx8(long long, unsigned high);
+EXPORT_SYMBOL(atomic64_xchg_cx8);
+long long atomic64_add_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_add_return_cx8);
+long long atomic64_sub_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_sub_return_cx8);
+long long atomic64_inc_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_return_cx8);
+long long atomic64_dec_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_return_cx8);
+long long atomic64_dec_if_positive_cx8(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_if_positive_cx8);
+int atomic64_inc_not_zero_cx8(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_not_zero_cx8);
+int atomic64_add_unless_cx8(atomic64_t *v, long long a, long long u);
+EXPORT_SYMBOL(atomic64_add_unless_cx8);
+
+#ifndef CONFIG_X86_CMPXCHG64
+long long atomic64_read_386(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_read_386);
+long long atomic64_set_386(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_set_386);
+long long atomic64_xchg_386(long long, unsigned high);
+EXPORT_SYMBOL(atomic64_xchg_386);
+long long atomic64_add_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_add_return_386);
+long long atomic64_sub_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_sub_return_386);
+long long atomic64_inc_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_return_386);
+long long atomic64_dec_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_return_386);
+long long atomic64_add_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_add_386);
+long long atomic64_sub_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_sub_386);
+long long atomic64_inc_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_386);
+long long atomic64_dec_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_386);
+long long atomic64_dec_if_positive_386(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_if_positive_386);
+int atomic64_inc_not_zero_386(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_not_zero_386);
+int atomic64_add_unless_386(atomic64_t *v, long long a, long long u);
+EXPORT_SYMBOL(atomic64_add_unless_386);
+#endif
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
new file mode 100644
index 0000000..5db07fe
--- /dev/null
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -0,0 +1,175 @@
+/*
+ * atomic64_t for 386/486
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+/* if you want SMP support, implement these with real spinlocks */
+.macro LOCK reg
+	pushfl
+	CFI_ADJUST_CFA_OFFSET 4
+	cli
+.endm
+
+.macro UNLOCK reg
+	popfl
+	CFI_ADJUST_CFA_OFFSET -4
+.endm
+
+.macro BEGIN func reg
+$v = \reg
+
+ENTRY(atomic64_\func\()_386)
+	CFI_STARTPROC
+	LOCK $v
+
+.macro RETURN
+	UNLOCK $v
+	ret
+.endm
+
+.macro END_
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_386)
+.purgem RETURN
+.purgem END_
+.purgem END
+.endm
+
+.macro END
+RETURN
+END_
+.endm
+.endm
+
+BEGIN read %ecx
+	movl  ($v), %eax
+	movl 4($v), %edx
+END
+
+BEGIN set %esi
+	movl %ebx,  ($v)
+	movl %ecx, 4($v)
+END
+
+BEGIN xchg %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	movl %ebx,  ($v)
+	movl %ecx, 4($v)
+END
+
+BEGIN add %ecx
+	addl %eax,  ($v)
+	adcl %edx, 4($v)
+END
+
+BEGIN add_return %ecx
+	addl  ($v), %eax
+	adcl 4($v), %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN sub %ecx
+	subl %eax,  ($v)
+	sbbl %edx, 4($v)
+END
+
+BEGIN sub_return %ecx
+	negl %edx
+	negl %eax
+	sbbl $0, %edx
+	addl  ($v), %eax
+	adcl 4($v), %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN inc %esi
+	addl $1,  ($v)
+	adcl $0, 4($v)
+END
+
+BEGIN inc_return %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	addl $1, %eax
+	adcl $0, %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN dec %esi
+	subl $1,  ($v)
+	sbbl $0, 4($v)
+END
+
+BEGIN dec_return %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	subl $1, %eax
+	sbbl $0, %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN add_unless %ecx
+	addl %eax, %esi
+	adcl %edx, %edi
+	addl  ($v), %eax
+	adcl 4($v), %edx
+	cmpl %eax, %esi
+	je 3f
+1:
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+	xorl %eax, %eax
+2:
+RETURN
+3:
+	cmpl %edx, %edi
+	jne 1b
+	movl $1, %eax
+	jmp 2b
+END_
+
+BEGIN inc_not_zero %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	testl %eax, %eax
+	je 3f
+1:
+	addl $1, %eax
+	adcl $0, %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+	xorl %eax, %eax
+2:
+RETURN
+3:
+	testl %edx, %edx
+	jne 1b
+	movl $1, %eax
+	jmp 2b
+END_
+
+BEGIN dec_if_positive %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	subl $1, %eax
+	sbbl $0, %edx
+	js 1f
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+1:
+END
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
new file mode 100644
index 0000000..e49c4eb
--- /dev/null
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -0,0 +1,225 @@
+/*
+ * atomic64_t for 586+
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+.macro SAVE reg
+	pushl %\reg
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET \reg, 0
+.endm
+
+.macro RESTORE reg
+	popl %\reg
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE \reg
+.endm
+
+.macro read64 reg
+	movl %ebx, %eax
+	movl %ecx, %edx
+/* we need LOCK_PREFIX since otherwise cmpxchg8b always does the write */
+	LOCK_PREFIX
+	cmpxchg8b (\reg)
+.endm
+
+ENTRY(atomic64_read_cx8)
+	CFI_STARTPROC
+
+	read64 %ecx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_read_cx8)
+
+ENTRY(atomic64_set_cx8)
+	CFI_STARTPROC
+
+1:
+/* we don't need LOCK_PREFIX since aligned 64-bit writes
+ * are atomic on 586 and newer */
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_set_cx8)
+
+ENTRY(atomic64_xchg_cx8)
+	CFI_STARTPROC
+
+	movl %ebx, %eax
+	movl %ecx, %edx
+1:
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_xchg_cx8)
+
+.macro addsub_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+	SAVE esi
+	SAVE edi
+
+	movl %eax, %esi
+	movl %edx, %edi
+	movl %ecx, %ebp
+
+	read64 %ebp
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l %esi, %ebx
+	\insc\()l %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE edi
+	RESTORE esi
+	RESTORE ebx
+	RESTORE ebp
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+addsub_return add add adc
+addsub_return sub sub sbb
+
+.macro incdec_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l $1, %ebx
+	\insc\()l $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+incdec_return inc add adc
+incdec_return dec sub sbb
+
+ENTRY(atomic64_dec_if_positive_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	subl $1, %ebx
+	sbb $0, %ecx
+	js 2f
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+2:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_dec_if_positive_cx8)
+
+ENTRY(atomic64_add_unless_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+/* these just push these two parameters on the stack */
+	SAVE edi
+	SAVE esi
+
+	movl %ecx, %ebp
+	movl %eax, %esi
+	movl %edx, %edi
+
+	read64 %ebp
+1:
+	cmpl %eax, 0(%esp)
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl %esi, %ebx
+	adcl %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+	xorl %eax, %eax
+3:
+	addl $8, %esp
+	CFI_ADJUST_CFA_OFFSET -8
+	RESTORE ebx
+	RESTORE ebp
+	ret
+4:
+	cmpl %edx, 4(%esp)
+	jne 2b
+	movl $1, %eax
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_add_unless_cx8)
+
+ENTRY(atomic64_inc_not_zero_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	testl %eax, %eax
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl $1, %ebx
+	adcl $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	xorl %eax, %eax
+3:
+	RESTORE ebx
+	ret
+4:
+	testl %edx, %edx
+	jne 2b
+	movl $1, %eax
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_inc_not_zero_cx8)
-- 
1.6.6.1.476.g01ddb

