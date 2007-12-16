Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbXLPMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbXLPMEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbXLPMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:03:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:62600 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765013AbXLPMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nEczfkl3U1CMw5ubRB43YLQeTKcgIcGfm7roCtrNeHr4yaGq5ExR6RkObAnl88s1A8Xcjj8HVgEExsbHxVBOiNq3uWAeJPMEW4Db7VTsQ9uJvQEt/2wA/8v8twdo0QMTwWHoqEc1+FlDddcydoL7l1r79JXK/0HeCsj8UNqYTg8=
Subject: [PATCH 3/4] x86: Unify local_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 04:04:00 -0800
Message-Id: <1197806640.3749.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce macros to deal with X86_32 using longs and X86_64
using quads.  Small comment fixes to make files match.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/local.h    |   17 +++++++++++++++++
 include/asm-x86/local_32.h |   28 ++++++++++++++--------------
 include/asm-x86/local_64.h |   18 +++++++++---------
 3 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/include/asm-x86/local.h b/include/asm-x86/local.h
index 1e6b5af..8839c36 100644
--- a/include/asm-x86/local.h
+++ b/include/asm-x86/local.h
@@ -14,6 +14,23 @@ typedef struct
 
 #define local_read(l)	atomic_long_read(&(l)->a)
 #define local_set(l,i)	atomic_long_set(&(l)->a, (i))
+/*
+ * X86_32 uses longs
+ * X86_64 uses quads
+ */
+#ifdef CONFIG_X86_32
+# define ASM_INC incl
+# define ASM_DEC decl
+# define ASM_ADD addl
+# define ASM_SUB subl
+# define ASM_XADD xaddl
+#else
+# define ASM_INC incq
+# define ASM_DEC decq
+# define ASM_ADD addq
+# define ASM_SUB subq
+# define ASM_XADD xaddq
+#endif
 
 #ifdef CONFIG_X86_32
 # include "local_32.h"
diff --git a/include/asm-x86/local_32.h b/include/asm-x86/local_32.h
index f3bc4d9..ff6d1d2 100644
--- a/include/asm-x86/local_32.h
+++ b/include/asm-x86/local_32.h
@@ -4,21 +4,21 @@
 static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
-		"incl %0"
+		"ASM_INC %0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
 	__asm__ __volatile__(
-		"decl %0"
+		"ASM_DEC %0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"addl %1,%0"
+		"ASM_ADD %1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -26,7 +26,7 @@ static inline void local_add(long i, local_t *l)
 static inline void local_sub(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"subl %1,%0"
+		"ASM_SUB %1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -34,7 +34,7 @@ static inline void local_sub(long i, local_t *l)
 /**
  * local_sub_and_test - subtract value from variable and test result
  * @i: integer value to subtract
- * @l: pointer of type local_t
+ * @l: pointer to type local_t
  *
  * Atomically subtracts @i from @l and returns
  * true if the result is zero, or false for all
@@ -45,7 +45,7 @@ static inline int local_sub_and_test(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"subl %2,%0; sete %1"
+		"ASM_SUB %2,%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -53,7 +53,7 @@ static inline int local_sub_and_test(long i, local_t *l)
 
 /**
  * local_dec_and_test - decrement and test
- * @l: pointer of type local_t
+ * @l: pointer to type local_t
  *
  * Atomically decrements @l by 1 and
  * returns true if the result is 0, or false for all other
@@ -64,7 +64,7 @@ static inline int local_dec_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"decl %0; sete %1"
+		"ASM_DEC %0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -72,7 +72,7 @@ static inline int local_dec_and_test(local_t *l)
 
 /**
  * local_inc_and_test - increment and test
- * @l: pointer of type local_t
+ * @l: pointer to type local_t
  *
  * Atomically increments @l by 1
  * and returns true if the result is zero, or false for all
@@ -83,7 +83,7 @@ static inline int local_inc_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"incl %0; sete %1"
+		"ASM_INC %0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -91,8 +91,8 @@ static inline int local_inc_and_test(local_t *l)
 
 /**
  * local_add_negative - add and test if negative
- * @l: pointer of type local_t
  * @i: integer value to add
+ * @l: pointer to type local_t
  *
  * Atomically adds @i to @l and returns true
  * if the result is negative, or false when
@@ -103,7 +103,7 @@ static inline int local_add_negative(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"addl %2,%0; sets %1"
+		"ASM_ADD %2,%0; sets %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -111,8 +111,8 @@ static inline int local_add_negative(long i, local_t *l)
 
 /**
  * local_add_return - add and return
- * @l: pointer of type local_t
  * @i: integer value to add
+ * @l: pointer to type local_t
  *
  * Atomically adds @i to @l and returns @i + @l
  */
@@ -127,7 +127,7 @@ static inline long local_add_return(long i, local_t *l)
 	/* Modern 486+ processor */
 	__i = i;
 	__asm__ __volatile__(
-		"xaddl %0, %1;"
+		"ASM_XADD %0, %1;"
 		:"+r" (i), "+m" (l->a.counter)
 		: : "memory");
 	return i + __i;
diff --git a/include/asm-x86/local_64.h b/include/asm-x86/local_64.h
index 7808f53..0e92bc6 100644
--- a/include/asm-x86/local_64.h
+++ b/include/asm-x86/local_64.h
@@ -4,21 +4,21 @@
 static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
-		"incq %0"
+		"ASM_INC %0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
 	__asm__ __volatile__(
-		"decq %0"
+		"ASM_DEC %0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"addq %1,%0"
+		"ASM_ADD %1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -26,7 +26,7 @@ static inline void local_add(long i, local_t *l)
 static inline void local_sub(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"subq %1,%0"
+		"ASM_SUB %1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -45,7 +45,7 @@ static inline int local_sub_and_test(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"subq %2,%0; sete %1"
+		"ASM_SUB %2,%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -64,7 +64,7 @@ static inline int local_dec_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"decq %0; sete %1"
+		"ASM_DEC %0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -83,7 +83,7 @@ static inline int local_inc_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"incq %0; sete %1"
+		"ASM_INC %0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -103,7 +103,7 @@ static inline int local_add_negative(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"addq %2,%0; sets %1"
+		"ASM_ADD %2,%0; sets %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -120,7 +120,7 @@ static inline long local_add_return(long i, local_t *l)
 {
 	long __i = i;
 	__asm__ __volatile__(
-		"xaddq %0, %1;"
+		"ASM_XADD %0, %1;"
 		:"+r" (i), "+m" (l->a.counter)
 		: : "memory");
 	return i + __i;
-- 
1.5.4.rc0.1083.gf568


