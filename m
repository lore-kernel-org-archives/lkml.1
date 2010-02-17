Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0BQLnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:43:02 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:29272 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab0BQLm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=p/VZ49hqOj1WMcTP2t3Qwp6t+tzQcMK/HcrEJrghk/dxBiTDegzxRvuyGvSurrfoc6
         B9iVSjOLVP044WP0rq4MKd+kHPJgbnjqrWOfZQNMwL6HQlhFUKE+exC0nZN4pgcq4l3y
         G3McAz/CVoeqAv55MumaZixVUo2pJT63ul2cU=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 06/10] x86-32: rewrite 32-bit atomic64 functions in assembly
Date: Wed, 17 Feb 2010 12:42:38 +0100
Message-Id: <1266406962-17463-7-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces atomic64_32.c with an assembly implementation.

It provides the following advantages:

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

A pure assembly implementation is required due to the custom calling
conventions, and desire to use %ebp in atomic64_add_return (we need
7 registers...).

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/atomic_32.h |  244 +++++++++++++++++++++-----------------
 arch/x86/lib/Makefile            |    2 +-
 arch/x86/lib/atomic64_32.c       |  243 ++++----------------------------------
 arch/x86/lib/atomic64_asm_32.S   |  231 ++++++++++++++++++++++++++++++++++++
 4 files changed, 390 insertions(+), 330 deletions(-)
 create mode 100644 arch/x86/lib/atomic64_asm_32.S

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index dc5a667..50a6d4c 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -268,56 +268,89 @@ typedef struct {
 
 #define ATOMIC64_INIT(val)	{ (val) }
 
-extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
+long long cx8_atomic64_read_cx8call(long long, const atomic64_t *v);
+long long cx8_atomic64_set_cx8call(long long, const atomic64_t *v);
+long long cx8_atomic64_xchg_cx8call(long long, unsigned high);
+long long cx8_atomic64_add_return(long long a, atomic64_t *v);
+long long cx8_atomic64_sub_return(long long a, atomic64_t *v);
+long long cx8_atomic64_inc_return_cx8call(long long a, atomic64_t *v);
+long long cx8_atomic64_dec_return_cx8call(long long a, atomic64_t *v);
+long long cx8_atomic64_dec_if_positive_cx8call(atomic64_t *v);
+int cx8_atomic64_inc_not_zero_cx8call(atomic64_t *v);
+int cx8_atomic64_add_unless(atomic64_t *v, long long a, long long u);
+
+/**
+ * atomic64_cmpxchg - cmpxchg atomic64 variable
+ * @p:      pointer to type atomic64_t
+ * @o:  expected value
+ * @n:  new value
+ *
+ * Atomically sets @v to @n if it was equal to @o and returns
+ * the old value.
+ */
+static inline long long atomic64_cmpxchg(atomic64_t *v, long long o,  long long n)
+{
+	asm volatile(LOCK_PREFIX "cmpxchg8b %1"
+				: "+A" (o)
+				: "m" (v->counter), "b" ((unsigned)n), "c" ((unsigned)(n >> 32))
+				);
+	return o;
+}
 
 /**
  * atomic64_xchg - xchg atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
+ * @v:      pointer to type atomic64_t
+ * @n:  value to assign
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
+	asm volatile("call cx8_atomic64_xchg_cx8call"
+				: "=A" (o), "+b" (low), "+c" (high)
+				: "S" (v)
+				: "memory"
+				);
+	return o;
+}
 
 /**
  * atomic64_set - set atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
+ * @v:      pointer to type atomic64_t
+ * @n:  value to assign
  *
- * Atomically sets the value of @ptr to @new_val.
+ * Atomically sets the value of @v to @n.
  */
-extern void atomic64_set(atomic64_t *ptr, u64 new_val);
+static inline void atomic64_set(atomic64_t *v, long long i)
+{
+	unsigned high = (unsigned)(i >> 32);
+	unsigned low = (unsigned)i;
+	asm volatile("call cx8_atomic64_set_cx8call"
+			: "+b" (low), "+c" (high)
+			: "S" (v)
+			: "eax", "edx", "memory"
+			);
+}
 
 /**
  * atomic64_read - read atomic64 variable
- * @ptr:      pointer to type atomic64_t
+ * @v:      pointer to type atomic64_t
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
+	asm volatile("call cx8_atomic64_read_cx8call"
+				: "=A" (r), "+c" (v)
+				: : "memory"
+				);
+	return r;
+ }
 
 /**
  * atomic64_add_return - add and return
@@ -326,90 +359,87 @@ extern u64 atomic64_read(atomic64_t *ptr);
  *
  * Atomically adds @delta to @ptr and returns @delta + *@ptr
  */
-extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
+static inline long long atomic64_add_return(long long a, atomic64_t *v)
+{
+	return cx8_atomic64_add_return(a, v);
+}
 
 /*
  * Other variants with different arithmetic operators:
  */
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
+static inline long long atomic64_sub_return(long long a, atomic64_t *v)
+{
+	return cx8_atomic64_sub_return(a, v);
+}
 
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
+static inline long long atomic64_inc_return(atomic64_t *v)
+{
+	long long a;
+	asm volatile("call cx8_atomic64_inc_return_cx8call"
+				: "=A" (a)
+				: "S" (v)
+				: "memory", "ecx"
+				);
+	return a;
+}
 
-/**
- * atomic64_inc - increment atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1.
- */
-extern void atomic64_inc(atomic64_t *ptr);
+static inline long long atomic64_dec_return(atomic64_t *v)
+{
+	long long a;
+	asm volatile("call cx8_atomic64_dec_return_cx8call"
+				: "=A" (a)
+				: "S" (v)
+				: "memory", "ecx"
+				);
+	return a;
+}
 
-/**
- * atomic64_dec - decrement atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1.
- */
-extern void atomic64_dec(atomic64_t *ptr);
+static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
+{
+	int r = (int)v;
+	unsigned low = (unsigned)a;
+	unsigned high = (unsigned)(a >> 2);
+	asm volatile(
+			"pushl %4\n\t"
+			"pushl %3\n\t"
+			"call cx8_atomic64_add_unless\n\t"
+			"addl $8, %%esp\n\t"
+			: "+a" (r), "+d" (low), "+c" (high)
+			: "g" ((unsigned)u), "g" ((unsigned)(u >> 32))
+			: "memory");
+	return r;
+}
 
-/**
- * atomic64_dec_and_test - decrement and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-extern int atomic64_dec_and_test(atomic64_t *ptr);
+static inline long long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long long r;
+	asm volatile("call cx8_atomic64_dec_if_positive_cx8call"
+				: "=A" (r)
+				: "S" (v)
+				: "ecx", "memory"
+				);
+	return r;
+}
 
-/**
- * atomic64_inc_and_test - increment and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-extern int atomic64_inc_and_test(atomic64_t *ptr);
+static inline int atomic64_inc_not_zero(atomic64_t *v)
+{
+	int r;
+	asm volatile("call cx8_atomic64_inc_not_zero_cx8call"
+				: "=a" (r)
+				: "S" (v)
+				: "ecx", "edx", "memory"
+				);
+	return r;
+}
 
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
+#define atomic64_add(i, v)		atomic64_add_return(i, v)
+#define atomic64_sub(i, v)		atomic64_sub_return(i, v)
+#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
+#define atomic64_inc(v)		atomic64_inc_return(v)
+#define atomic64_inc_and_test(v) 	(atomic64_inc_return(v) == 0)
+#define atomic64_sub_and_test(a, v)	(atomic64_sub_return((a), (v)) == 0)
+#define atomic64_dec(v)		atomic64_dec_return(v)
+#define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..b42fdeb 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -25,7 +25,7 @@ lib-$(CONFIG_KPROBES) += insn.o inat.o
 obj-y += msr.o msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
-        obj-y += atomic64_32.o
+        obj-y += atomic64_32.o atomic64_asm_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += semaphore_32.o string_32.o
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 824fa0b..18544b3 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -1,3 +1,14 @@
+/*
+ * atomic64_t for x86-32
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -6,225 +17,13 @@
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
+EXPORT_SYMBOL(cx8_atomic64_read_cx8call);
+EXPORT_SYMBOL(cx8_atomic64_set_cx8call);
+EXPORT_SYMBOL(cx8_atomic64_xchg_cx8call);
+EXPORT_SYMBOL(cx8_atomic64_add_return);
+EXPORT_SYMBOL(cx8_atomic64_sub_return);
+EXPORT_SYMBOL(cx8_atomic64_add_unless);
+EXPORT_SYMBOL(cx8_atomic64_inc_return_cx8call);
+EXPORT_SYMBOL(cx8_atomic64_dec_return_cx8call);
+EXPORT_SYMBOL(cx8_atomic64_dec_if_positive_cx8call);
+EXPORT_SYMBOL(cx8_atomic64_inc_not_zero_cx8call);
diff --git a/arch/x86/lib/atomic64_asm_32.S b/arch/x86/lib/atomic64_asm_32.S
new file mode 100644
index 0000000..3e98118
--- /dev/null
+++ b/arch/x86/lib/atomic64_asm_32.S
@@ -0,0 +1,231 @@
+/*
+ * atomic64_t for x86-32
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
+.macro read64_for_write reg
+	xorl %eax, %eax
+	LOCK_PREFIX
+	xaddl %eax, (\reg)
+	movl 4(\reg), %edx
+.endm
+
+ENTRY(cx8_atomic64_read_cx8call)
+	CFI_STARTPROC
+
+	movl %ebx, %eax
+	movl %ecx, %edx
+
+/* we need LOCK_PREFIX since otherwise cmpxchg8b always does the write */
+	LOCK_PREFIX
+	cmpxchg8b (%ecx)
+
+	ret
+	CFI_ENDPROC
+ENDPROC(cx8_atomic64_read_cx8call)
+
+ENTRY(cx8_atomic64_set_cx8call)
+	CFI_STARTPROC
+
+	read64_for_write %esi
+
+1:
+/* we don't need LOCK_PREFIX since aligned 64-bit writes are atomic on 586 and newer */
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(cx8_atomic64_set_cx8call)
+
+ENTRY(cx8_atomic64_xchg_cx8call)
+	CFI_STARTPROC
+
+	read64_for_write %esi
+
+1:
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(cx8_atomic64_xchg_cx8call)
+
+.macro addsub_return func ins insc
+ENTRY(cx8_atomic64_\func\()_return)
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
+	read64_for_write %ebp
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
+ENDPROC(cx8_atomic64_\func\()_return)
+.endm
+
+addsub_return add add adc
+addsub_return sub sub sbb
+
+.macro incdec_return func ins insc
+ENTRY(cx8_atomic64_\func\()_return_cx8call)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64_for_write %esi
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
+ENDPROC(cx8_atomic64_\func\()_return_cx8call)
+.endm
+
+incdec_return inc add adc
+incdec_return dec sub sbb
+
+ENTRY(cx8_atomic64_dec_if_positive_cx8call)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64_for_write %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+/* dec doesn't set the carry flag */
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
+ENDPROC(cx8_atomic64_dec_if_positive_cx8call)
+
+ENTRY(cx8_atomic64_add_unless)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+	SAVE esi
+	SAVE edi
+
+	movl %eax, %ebp
+	movl %edx, %esi
+	movl %ecx, %edi
+
+	read64_for_write %ebp
+1:
+	cmpl %eax, 0x14(%esp)
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
+	RESTORE edi
+	RESTORE esi
+	RESTORE ebx
+	RESTORE ebp
+	ret
+4:
+	cmpl %edx, 0x18(%esp)
+	jne 2b
+	movl $1, %eax
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(cx8_atomic64_add_unless)
+
+ENTRY(cx8_atomic64_inc_not_zero_cx8call)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64_for_write %esi
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
+ENDPROC(cx8_atomic64_inc_not_zero_cx8call)
-- 
1.6.6.1.476.g01ddb

