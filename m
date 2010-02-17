Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0BQLnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:43:08 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:57539 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0BQLnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WCBsZhrxvoZ6FMtlbJLq0Pi4KNYJNOYQTUXCvmal7SxXzlYMEZtCtRWzQbzlshYzoM
         dplxK3syfL1YUSqxv8q3OHRHVTM/Bzc5/F6mAeN7ZSwEQJ74jfLPDSvBsBfxk5zs6dPi
         Y+ktbtLgyrtAWPOovTt/fMZ5bgEiqqest/EEo=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 08/10] x86-32: support atomic64_t on 386/486 UP/SMP
Date: Wed, 17 Feb 2010 12:42:40 +0100
Message-Id: <1266406962-17463-9-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes atomic64 use either the generic implementation or
the rewritten cmpxchg8b one just introduced by inserting a "call" to
either, using the alternatives system to dynamically switch the calls.

This allows to use atomic64_t on 386/486 which lack cmpxchg8b

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/atomic_32.h |   56 +++++++++++++++++-----
 arch/x86/lib/atomic64_32.c       |   94 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 50a6d4c..1ab431c 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -279,6 +279,12 @@ long long cx8_atomic64_dec_if_positive_cx8call(atomic64_t *v);
 int cx8_atomic64_inc_not_zero_cx8call(atomic64_t *v);
 int cx8_atomic64_add_unless(atomic64_t *v, long long a, long long u);
 
+#ifdef CONFIG_X86_CMPXCHG64
+#define ATOMIC64_ALTERNATIVE(f) "call cx8_atomic64_" #f
+#else
+#define ATOMIC64_ALTERNATIVE(f) ALTERNATIVE("call generic_atomic64_" #f, "call cx8_atomic64_" #f, X86_FEATURE_CX8)
+#endif
+
 /**
  * atomic64_cmpxchg - cmpxchg atomic64 variable
  * @p:      pointer to type atomic64_t
@@ -288,11 +294,25 @@ int cx8_atomic64_add_unless(atomic64_t *v, long long a, long long u);
  * Atomically sets @v to @n if it was equal to @o and returns
  * the old value.
  */
+
 static inline long long atomic64_cmpxchg(atomic64_t *v, long long o,  long long n)
 {
-	asm volatile(LOCK_PREFIX "cmpxchg8b %1"
-				: "+A" (o)
-				: "m" (v->counter), "b" ((unsigned)n), "c" ((unsigned)(n >> 32))
+	unsigned high = (unsigned)(n >> 32);
+	unsigned low = (unsigned)n;
+	asm volatile(
+#ifdef CONFIG_X86_CMPXCHG64
+			LOCK_PREFIX "cmpxchg8b (%%esi)"
+#else
+#if CONFIG_SMP
+			LOCK_PREFIX_ALTERNATIVE_PATCH "\n\t"
+			ALTERNATIVE("call generic_atomic64_cmpxchg_cx8call", "lock; cmpxchg8b (%%esi)\n\tnop", X86_FEATURE_CX8)
+#else
+			ALTERNATIVE("call generic_atomic64_cmpxchg_cx8call", "cmpxchg8b (%%esi)\n\t" ASM_NOP2, X86_FEATURE_CX8)
+#endif
+#endif
+				: "+A" (o), "+b" (low), "+c" (high)
+				: "S" (v)
+				: "memory"
 				);
 	return o;
 }
@@ -310,7 +330,7 @@ static inline long long atomic64_xchg(atomic64_t *v, long long n)
 	long long o;
 	unsigned high = (unsigned)(n >> 32);
 	unsigned low = (unsigned)n;
-	asm volatile("call cx8_atomic64_xchg_cx8call"
+	asm volatile(ATOMIC64_ALTERNATIVE(xchg_cx8call)
 				: "=A" (o), "+b" (low), "+c" (high)
 				: "S" (v)
 				: "memory"
@@ -329,7 +349,7 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 {
 	unsigned high = (unsigned)(i >> 32);
 	unsigned low = (unsigned)i;
-	asm volatile("call cx8_atomic64_set_cx8call"
+	asm volatile(ATOMIC64_ALTERNATIVE(set_cx8call)
 			: "+b" (low), "+c" (high)
 			: "S" (v)
 			: "eax", "edx", "memory"
@@ -345,7 +365,7 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 static inline long long atomic64_read(atomic64_t *v)
 {
 	long long r;
-	asm volatile("call cx8_atomic64_read_cx8call"
+	asm volatile(ATOMIC64_ALTERNATIVE(read_cx8call)
 				: "=A" (r), "+c" (v)
 				: : "memory"
 				);
@@ -361,7 +381,11 @@ static inline long long atomic64_read(atomic64_t *v)
  */
 static inline long long atomic64_add_return(long long a, atomic64_t *v)
 {
-	return cx8_atomic64_add_return(a, v);
+	asm volatile(ATOMIC64_ALTERNATIVE(add_return)
+				: "+A" (a), "+c" (v)
+				: : "memory"
+				);
+	return a;
 }
 
 /*
@@ -369,13 +393,17 @@ static inline long long atomic64_add_return(long long a, atomic64_t *v)
  */
 static inline long long atomic64_sub_return(long long a, atomic64_t *v)
 {
-	return cx8_atomic64_sub_return(a, v);
+	asm volatile(ATOMIC64_ALTERNATIVE(sub_return)
+				: "+A" (a), "+c" (v)
+				: : "memory"
+				);
+	return a;
 }
 
 static inline long long atomic64_inc_return(atomic64_t *v)
 {
 	long long a;
-	asm volatile("call cx8_atomic64_inc_return_cx8call"
+	asm volatile(ATOMIC64_ALTERNATIVE(inc_return_cx8call)
 				: "=A" (a)
 				: "S" (v)
 				: "memory", "ecx"
@@ -386,7 +414,7 @@ static inline long long atomic64_inc_return(atomic64_t *v)
 static inline long long atomic64_dec_return(atomic64_t *v)
 {
 	long long a;
-	asm volatile("call cx8_atomic64_dec_return_cx8call"
+	asm volatile(ATOMIC64_ALTERNATIVE(dec_return_cx8call)
 				: "=A" (a)
 				: "S" (v)
 				: "memory", "ecx"
@@ -402,7 +430,7 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 	asm volatile(
 			"pushl %4\n\t"
 			"pushl %3\n\t"
-			"call cx8_atomic64_add_unless\n\t"
+			ATOMIC64_ALTERNATIVE(add_unless) "\n\t"
 			"addl $8, %%esp\n\t"
 			: "+a" (r), "+d" (low), "+c" (high)
 			: "g" ((unsigned)u), "g" ((unsigned)(u >> 32))
@@ -413,7 +441,7 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 static inline long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long long r;
-	asm volatile("call cx8_atomic64_dec_if_positive_cx8call"
+	asm volatile(ATOMIC64_ALTERNATIVE(dec_if_positive_cx8call)
 				: "=A" (r)
 				: "S" (v)
 				: "ecx", "memory"
@@ -424,7 +452,7 @@ static inline long long atomic64_dec_if_positive(atomic64_t *v)
 static inline int atomic64_inc_not_zero(atomic64_t *v)
 {
 	int r;
-	asm volatile("call cx8_atomic64_inc_not_zero_cx8call"
+	asm volatile(ATOMIC64_ALTERNATIVE(inc_not_zero_cx8call)
 				: "=a" (r)
 				: "S" (v)
 				: "ecx", "edx", "memory"
@@ -441,5 +469,7 @@ static inline int atomic64_inc_not_zero(atomic64_t *v)
 #define atomic64_dec(v)		atomic64_dec_return(v)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 
+#undef ATOMIC64_ALTERNATIVE
+
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 18544b3..b7edbb3 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -27,3 +27,97 @@ EXPORT_SYMBOL(cx8_atomic64_inc_return_cx8call);
 EXPORT_SYMBOL(cx8_atomic64_dec_return_cx8call);
 EXPORT_SYMBOL(cx8_atomic64_dec_if_positive_cx8call);
 EXPORT_SYMBOL(cx8_atomic64_inc_not_zero_cx8call);
+
+
+#ifndef CONFIG_X86_CMPXCHG64
+
+/* inline these since we expose variants with a different calling convention */
+#define generic_atomic64_read static inline generic_atomic64_read
+#define generic_atomic64_set static inline generic_atomic64_set
+#define generic_atomic64_xchg static inline generic_atomic64_xchg
+#define generic_atomic64_cmpxchg static inline generic_atomic64_cmpxchg
+#define generic_atomic64_dec_if_positive static inline generic_atomic64_dec_if_positive
+#include <asm-generic/atomic64-impl.h>
+#undef generic_atomic64_read
+#undef generic_atomic64_set
+#undef generic_atomic64_xchg
+#undef generic_atomic64_cmpxchg
+#undef generic_atomic64_dec_if_positive
+
+union generic_atomic64_lock generic_atomic64_lock[ATOMIC64_NR_LOCKS] __cacheline_aligned_in_smp;
+pure_initcall(init_generic_atomic64_lock);
+
+EXPORT_SYMBOL(generic_atomic64_add);
+EXPORT_SYMBOL(generic_atomic64_add_return);
+EXPORT_SYMBOL(generic_atomic64_sub);
+EXPORT_SYMBOL(generic_atomic64_sub_return);
+EXPORT_SYMBOL(generic_atomic64_add_unless);
+
+long long generic_atomic64_read_cx8call(long long dummy, const atomic64_t *v)
+{
+	return generic_atomic64_read(v);
+}
+EXPORT_SYMBOL(generic_atomic64_read_cx8call);
+
+#endif /* CONFIG_X86_CMPXCHG64 */
+
+register unsigned low asm("ebx");
+register atomic64_t *v asm("esi");
+
+#ifndef CONFIG_X86_CMPXCHG64
+
+long long generic_atomic64_cmpxchg_cx8call(long long o, unsigned high)
+{
+	return generic_atomic64_cmpxchg(v, o, ((long long)high << 32) | low);
+}
+EXPORT_SYMBOL(generic_atomic64_cmpxchg_cx8call);
+
+long long generic_atomic64_xchg_cx8call(long long dummy, unsigned high)
+{
+	return generic_atomic64_xchg(v, ((long long)high << 32) | low);
+}
+EXPORT_SYMBOL(generic_atomic64_xchg_cx8call);
+
+void generic_atomic64_set_cx8call(long long dummy, unsigned high)
+{
+	return generic_atomic64_set(v, ((long long)high << 32) | low);
+}
+EXPORT_SYMBOL(generic_atomic64_set_cx8call);
+
+long long generic_atomic64_inc_return_cx8call(void)
+{
+	return generic_atomic64_add_return(1, v);
+}
+EXPORT_SYMBOL(generic_atomic64_inc_return_cx8call);
+
+long long generic_atomic64_dec_return_cx8call(void)
+{
+	return generic_atomic64_sub_return(1, v);
+}
+EXPORT_SYMBOL(generic_atomic64_dec_return_cx8call);
+
+void generic_atomic64_inc_cx8call(void)
+{
+	return generic_atomic64_add(1, v);
+}
+EXPORT_SYMBOL(generic_atomic64_inc_cx8call);
+
+void generic_atomic64_dec_cx8call(void)
+{
+	return generic_atomic64_sub(1, v);
+}
+EXPORT_SYMBOL(generic_atomic64_dec_cx8call);
+
+long long generic_atomic64_dec_if_positive_cx8call(void)
+{
+	return generic_atomic64_dec_if_positive(v);
+}
+EXPORT_SYMBOL(generic_atomic64_dec_if_positive_cx8call);
+
+int generic_atomic64_inc_not_zero_cx8call(void)
+{
+	return generic_atomic64_add_unless(v, 1LL, 0LL);
+}
+EXPORT_SYMBOL(generic_atomic64_inc_not_zero_cx8call);
+
+#endif /* CONFIG_X86_CMPXCHG64 */
-- 
1.6.6.1.476.g01ddb

