Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZAAAOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZAAAOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZAAANr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:13:47 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:8044 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZAAANq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:13:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JrwizfokaRcv8pNG4hLf5Nt6pxO+j/ER05ZdAyFprRRZrpxHcnwdfFL2owPdAKpiJp
         CLO/ZVkzRP9Cd4fUvjeK328rO9F2rBiVMYmzA6RqqodJjjYXtHqt6h7VECgZH7SeYcgX
         16JAdi6aMumDHh5I8qRYLygGQvGGFitln54CY=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 2/4] x86-64: Unify x86_*_percpu() functions.
Date: Wed, 31 Dec 2008 19:13:41 -0500
Message-Id: <1230768823-31037-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
References: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge the 32-bit and 64-bit versions of these functions.  Unlike 32-bit,
the segment base is the current cpu's PDA instead of the offset from the
original per-cpu area.  This is because GCC hardcodes the stackprotector
canary at %gs:40.  Since the assembler is incapable of relocating against
multiple symbols, the code ends up looking like:

	movq $per_cpu__var, reg
	subq $per_cpu__pda, reg
	movq %gs:(reg), reg

This is still atomic since the offset is a constant (just calculated at
runtime) and not dependant on the cpu number.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/percpu.h |   92 +++++++++++++++++-----------------------
 1 files changed, 39 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 6f866fd..f704243 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -1,54 +1,9 @@
 #ifndef _ASM_X86_PERCPU_H
 #define _ASM_X86_PERCPU_H
 
-#ifdef CONFIG_X86_64
-#include <linux/compiler.h>
-
-/* Same as asm-generic/percpu.h, except that we store the per cpu offset
-   in the PDA. Longer term the PDA and every per cpu variable
-   should be just put into a single section and referenced directly
-   from %gs */
-
-#ifdef CONFIG_SMP
-#include <asm/pda.h>
-
-#define __my_cpu_offset read_pda(data_offset)
-
-#endif
-#include <asm-generic/percpu.h>
-
-DECLARE_PER_CPU(struct x8664_pda, pda);
-
-/*
- * These are supposed to be implemented as a single instruction which
- * operates on the per-cpu data base segment.  x86-64 doesn't have
- * that yet, so this is a fairly inefficient workaround for the
- * meantime.  The single instruction is atomic with respect to
- * preemption and interrupts, so we need to explicitly disable
- * interrupts here to achieve the same effect.  However, because it
- * can be used from within interrupt-disable/enable, we can't actually
- * disable interrupts; disabling preemption is enough.
- */
-#define x86_read_percpu(var)						\
-	({								\
-		typeof(per_cpu_var(var)) __tmp;				\
-		preempt_disable();					\
-		__tmp = __get_cpu_var(var);				\
-		preempt_enable();					\
-		__tmp;							\
-	})
-
-#define x86_write_percpu(var, val)					\
-	do {								\
-		preempt_disable();					\
-		__get_cpu_var(var) = (val);				\
-		preempt_enable();					\
-	} while(0)
-
-#else /* CONFIG_X86_64 */
-
 #ifdef __ASSEMBLY__
 
+#ifdef CONFIG_X86_32
 /*
  * PER_CPU finds an address of a per-cpu variable.
  *
@@ -72,6 +27,8 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 #define PER_CPU_VAR(var)	per_cpu__##var
 #endif	/* SMP */
 
+#endif	/* X86_32 */
+
 #else /* ...!ASSEMBLY */
 
 /*
@@ -88,19 +45,37 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
  */
 #ifdef CONFIG_SMP
 
+#ifdef CONFIG_X86_32
+
 #define __my_cpu_offset x86_read_percpu(this_cpu_off)
 
 /* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
+#define __percpu_seg_off(x) (x)
+
+#else
+
+#define __my_cpu_offset read_pda(data_offset)
+
+#define __percpu_seg "%%gs:"
+#define __percpu_seg_off(x) RELOC_HIDE((x), -(unsigned long)&per_cpu__pda)
+
+#endif
 
 #else  /* !SMP */
 
 #define __percpu_seg ""
+#define __percpu_seg_off(x) (x)
 
 #endif	/* SMP */
 
 #include <asm-generic/percpu.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/pda.h>
+DECLARE_PER_CPU(struct x8664_pda, pda);
+#endif
+
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
@@ -111,6 +86,7 @@ extern void __bad_percpu_size(void);
 #define percpu_to_op(op, var, val)			\
 do {							\
 	typedef typeof(var) T__;			\
+	typeof(var) *var__ = __percpu_seg_off(&var);	\
 	if (0) {					\
 		T__ tmp__;				\
 		tmp__ = (val);				\
@@ -118,17 +94,22 @@ do {							\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b %1,"__percpu_seg"%0"		\
-		    : "+m" (var)			\
+		    : "+m" (*var__)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 2:						\
 		asm(op "w %1,"__percpu_seg"%0"		\
-		    : "+m" (var)			\
+		    : "+m" (*var__)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 4:						\
 		asm(op "l %1,"__percpu_seg"%0"		\
-		    : "+m" (var)			\
+		    : "+m" (*var__)			\
+		    : "ri" ((T__)val));			\
+		break;					\
+	case 8:						\
+		asm(op "q %1,"__percpu_seg"%0"		\
+		    : "+m" (*var__)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	default: __bad_percpu_size();			\
@@ -138,21 +119,27 @@ do {							\
 #define percpu_from_op(op, var)				\
 ({							\
 	typeof(var) ret__;				\
+	typeof(var) *var__ = __percpu_seg_off(&var);	\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_seg"%1,%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : "m" (*var__));			\
 		break;					\
 	case 2:						\
 		asm(op "w "__percpu_seg"%1,%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : "m" (*var__));			\
 		break;					\
 	case 4:						\
 		asm(op "l "__percpu_seg"%1,%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : "m" (*var__));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_seg"%1,%0"		\
+		    : "=r" (ret__)			\
+		    : "m" (*var__));			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
@@ -165,7 +152,6 @@ do {							\
 #define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
 #define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 
 #ifdef CONFIG_SMP
 
-- 
1.6.1.rc1

