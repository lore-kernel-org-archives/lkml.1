Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXLQA4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXLQA4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934341AbXLQAzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:55:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:13168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934342AbXLQAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:55:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OWDORedRKJlMMexxXl4XdMpv1uQrpYf2xHxhkV/oFFqDwJsYaIYNkW30ZeKj2nK1AW9xN8fgnpeiBsi4qamYRVinzIfEG0ujw7TZeB0SN93maRbRobBUZVQ3WdqA33kc4f9lP6s2Y3+lo7ZKNfdS4rQ3FhPtH1n6AXnF0hTYFJg=
Subject: [PATCH 4/4] x86: Unify local_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 16:55:16 -0800
Message-Id: <1197852916.3749.100.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/local.h    |  148 ++++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/local_32.h |  150 --------------------------------------------
 include/asm-x86/local_64.h |  134 ---------------------------------------
 3 files changed, 144 insertions(+), 288 deletions(-)

diff --git a/include/asm-x86/local.h b/include/asm-x86/local.h
index 194565b..f5677e2 100644
--- a/include/asm-x86/local.h
+++ b/include/asm-x86/local.h
@@ -17,11 +17,151 @@ typedef struct
 #define local_read(l)	atomic_long_read(&(l)->a)
 #define local_set(l,i)	atomic_long_set(&(l)->a, (i))
 
-#ifdef CONFIG_X86_32
-# include "local_32.h"
-#else
-# include "local_64.h"
+static inline void local_inc(local_t *l)
+{
+	__asm__ __volatile__(
+		_ASM_INC "%0"
+		:"+m" (l->a.counter));
+}
+
+static inline void local_dec(local_t *l)
+{
+	__asm__ __volatile__(
+		_ASM_DEC "%0"
+		:"+m" (l->a.counter));
+}
+
+static inline void local_add(long i, local_t *l)
+{
+	__asm__ __volatile__(
+		_ASM_ADD "%1,%0"
+		:"+m" (l->a.counter)
+		:"ir" (i));
+}
+
+static inline void local_sub(long i, local_t *l)
+{
+	__asm__ __volatile__(
+		_ASM_SUB "%1,%0"
+		:"+m" (l->a.counter)
+		:"ir" (i));
+}
+
+/**
+ * local_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @l: pointer to type local_t
+ *
+ * Atomically subtracts @i from @l and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int local_sub_and_test(long i, local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		_ASM_SUB "%2,%0; sete %1"
+		:"+m" (l->a.counter), "=qm" (c)
+		:"ir" (i) : "memory");
+	return c;
+}
+
+/**
+ * local_dec_and_test - decrement and test
+ * @l: pointer to type local_t
+ *
+ * Atomically decrements @l by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int local_dec_and_test(local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		_ASM_DEC "%0; sete %1"
+		:"+m" (l->a.counter), "=qm" (c)
+		: : "memory");
+	return c != 0;
+}
+
+/**
+ * local_inc_and_test - increment and test
+ * @l: pointer to type local_t
+ *
+ * Atomically increments @l by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int local_inc_and_test(local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		_ASM_INC "%0; sete %1"
+		:"+m" (l->a.counter), "=qm" (c)
+		: : "memory");
+	return c != 0;
+}
+
+/**
+ * local_add_negative - add and test if negative
+ * @i: integer value to add
+ * @l: pointer to type local_t
+ *
+ * Atomically adds @i to @l and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int local_add_negative(long i, local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		_ASM_ADD "%2,%0; sets %1"
+		:"+m" (l->a.counter), "=qm" (c)
+		:"ir" (i) : "memory");
+	return c;
+}
+
+/**
+ * local_add_return - add and return
+ * @i: integer value to add
+ * @l: pointer to type local_t
+ *
+ * Atomically adds @i to @l and returns @i + @l
+ */
+static inline long local_add_return(long i, local_t *l)
+{
+	long __i;
+#ifdef CONFIG_M386
+	unsigned long flags;
+	if(unlikely(boot_cpu_data.x86 <= 3))
+		goto no_xadd;
+#endif
+	/* Modern 486+ processor */
+	__i = i;
+	__asm__ __volatile__(
+		_ASM_XADD "%0, %1;"
+		:"+r" (i), "+m" (l->a.counter)
+		: : "memory");
+	return i + __i;
+
+#ifdef CONFIG_M386
+no_xadd: /* Legacy 386 processor */
+	local_irq_save(flags);
+	__i = local_read(l);
+	local_set(l, i + __i);
+	local_irq_restore(flags);
+	return i + __i;
 #endif
+}
+
+static inline long local_sub_return(long i, local_t *l)
+{
+	return local_add_return(-i,l);
+}
 
 #define local_inc_return(l)  (local_add_return(1,l))
 #define local_dec_return(l)  (local_sub_return(1,l))
diff --git a/include/asm-x86/local_32.h b/include/asm-x86/local_32.h
deleted file mode 100644
index 33fa3ee..0000000
--- a/include/asm-x86/local_32.h
+++ /dev/null
@@ -1,150 +0,0 @@
-#ifndef _ARCH_I386_LOCAL_H
-#define _ARCH_I386_LOCAL_H
-
-static inline void local_inc(local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_INC "%0"
-		:"+m" (l->a.counter));
-}
-
-static inline void local_dec(local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_DEC "%0"
-		:"+m" (l->a.counter));
-}
-
-static inline void local_add(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_ADD "%1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
-}
-
-static inline void local_sub(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_SUB "%1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
-}
-
-/**
- * local_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @l: pointer of type local_t
- *
- * Atomically subtracts @i from @l and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int local_sub_and_test(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_SUB "%2,%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
-	return c;
-}
-
-/**
- * local_dec_and_test - decrement and test
- * @l: pointer of type local_t
- *
- * Atomically decrements @l by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int local_dec_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_DEC "%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
-	return c != 0;
-}
-
-/**
- * local_inc_and_test - increment and test
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int local_inc_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_INC "%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
-	return c != 0;
-}
-
-/**
- * local_add_negative - add and test if negative
- * @l: pointer of type local_t
- * @i: integer value to add
- *
- * Atomically adds @i to @l and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int local_add_negative(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_ADD "%2,%0; sets %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
-	return c;
-}
-
-/**
- * local_add_return - add and return
- * @l: pointer of type local_t
- * @i: integer value to add
- *
- * Atomically adds @i to @l and returns @i + @l
- */
-static inline long local_add_return(long i, local_t *l)
-{
-	long __i;
-#ifdef CONFIG_M386
-	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
-	__i = i;
-	__asm__ __volatile__(
-		_ASM_XADD "%0, %1;"
-		:"+r" (i), "+m" (l->a.counter)
-		: : "memory");
-	return i + __i;
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	local_irq_save(flags);
-	__i = local_read(l);
-	local_set(l, i + __i);
-	local_irq_restore(flags);
-	return i + __i;
-#endif
-}
-
-static inline long local_sub_return(long i, local_t *l)
-{
-	return local_add_return(-i,l);
-}
-
-#endif /* _ARCH_I386_LOCAL_H */
diff --git a/include/asm-x86/local_64.h b/include/asm-x86/local_64.h
deleted file mode 100644
index 91983e2..0000000
--- a/include/asm-x86/local_64.h
+++ /dev/null
@@ -1,134 +0,0 @@
-#ifndef _ARCH_X8664_LOCAL_H
-#define _ARCH_X8664_LOCAL_H
-
-static inline void local_inc(local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_INC "%0"
-		:"+m" (l->a.counter));
-}
-
-static inline void local_dec(local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_DEC "%0"
-		:"+m" (l->a.counter));
-}
-
-static inline void local_add(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_ADD "%1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
-}
-
-static inline void local_sub(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		_ASM_SUB "%1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
-}
-
-/**
- * local_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @l: pointer to type local_t
- *
- * Atomically subtracts @i from @l and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int local_sub_and_test(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_SUB "%2,%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
-	return c;
-}
-
-/**
- * local_dec_and_test - decrement and test
- * @l: pointer to type local_t
- *
- * Atomically decrements @l by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int local_dec_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_DEC "%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
-	return c != 0;
-}
-
-/**
- * local_inc_and_test - increment and test
- * @l: pointer to type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int local_inc_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_INC "%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
-	return c != 0;
-}
-
-/**
- * local_add_negative - add and test if negative
- * @i: integer value to add
- * @l: pointer to type local_t
- *
- * Atomically adds @i to @l and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int local_add_negative(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		_ASM_ADD "%2,%0; sets %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
-	return c;
-}
-
-/**
- * local_add_return - add and return
- * @i: integer value to add
- * @l: pointer to type local_t
- *
- * Atomically adds @i to @l and returns @i + @l
- */
-static inline long local_add_return(long i, local_t *l)
-{
-	long __i = i;
-	__asm__ __volatile__(
-		_ASM_XADD "%0, %1;"
-		:"+r" (i), "+m" (l->a.counter)
-		: : "memory");
-	return i + __i;
-}
-
-static inline long local_sub_return(long i, local_t *l)
-{
-	return local_add_return(-i,l);
-}
-
-#endif /* _ARCH_X8664_LOCAL_H */
-- 
1.5.4.rc0.1083.gf568

