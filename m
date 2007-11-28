Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXK1VSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXK1VSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbXK1VPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38910 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755018AbXK1VP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:28 -0500
Message-Id: <20071128211528.333696455@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:36 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com
Subject: [patch 10/10] x86: Unify percpu.h
Content-Disposition: inline; filename=unification
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Form a single percpu.h from percpu_32.h and percpu_64.h. Both are now pretty
small so this is simply adding them together.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/percpu.h    |  145 ++++++++++++++++++++++++++++++++++++++++++--
 include/asm-x86/percpu_32.h |  119 ------------------------------------
 include/asm-x86/percpu_64.h |   20 ------
 3 files changed, 141 insertions(+), 143 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu.h	2007-11-28 12:51:19.008463047 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/percpu.h	2007-11-28 12:52:07.439963275 -0800
@@ -1,5 +1,142 @@
-#ifdef CONFIG_X86_32
-# include "percpu_32.h"
-#else
-# include "percpu_64.h"
+#ifndef _ASM_X86_PERCPU_H_
+#define _ASM_X86_PERCPU_H_
+
+#ifdef CONFIG_X86_64
+#include <linux/compiler.h>
+
+/* Same as asm-generic/percpu.h, except that we store the per cpu offset
+   in the PDA. Longer term the PDA and every per cpu variable
+   should be just put into a single section and referenced directly
+   from %gs */
+
+#ifdef CONFIG_SMP
+#include <asm/pda.h>
+
+#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
+#define __my_cpu_offset read_pda(data_offset)
+
+#define per_cpu_offset(x) (__per_cpu_offset(x))
+
 #endif
+#include <asm-generic/percpu.h>
+
+DECLARE_PER_CPU(struct x8664_pda, pda);
+
+#else /* CONFIG_X86_64 */
+
+#ifdef __ASSEMBLY__
+
+/*
+ * PER_CPU finds an address of a per-cpu variable.
+ *
+ * Args:
+ *    var - variable name
+ *    reg - 32bit register
+ *
+ * The resulting address is stored in the "reg" argument.
+ *
+ * Example:
+ *    PER_CPU(cpu_gdt_descr, %ebx)
+ */
+#ifdef CONFIG_SMP
+#define PER_CPU(var, reg)				\
+	movl %fs:per_cpu__##this_cpu_off, reg;		\
+	lea per_cpu__##var(reg), reg
+#define PER_CPU_VAR(var)	%fs:per_cpu__##var
+#else /* ! SMP */
+#define PER_CPU(var, reg)			\
+	movl $per_cpu__##var, reg
+#define PER_CPU_VAR(var)	per_cpu__##var
+#endif	/* SMP */
+
+#else /* ...!ASSEMBLY */
+
+/*
+ * PER_CPU finds an address of a per-cpu variable.
+ *
+ * Args:
+ *    var - variable name
+ *    cpu - 32bit register containing the current CPU number
+ *
+ * The resulting address is stored in the "cpu" argument.
+ *
+ * Example:
+ *    PER_CPU(cpu_gdt_descr, %ebx)
+ */
+#ifdef CONFIG_SMP
+
+#define __my_cpu_offset x86_read_percpu(this_cpu_off)
+
+/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
+#define __percpu_seg "%%fs:"
+
+#else  /* !SMP */
+
+#define __percpu_seg ""
+
+#endif	/* SMP */
+
+#include <asm-generic/percpu.h>
+
+/* We can use this directly for local CPU (faster). */
+DECLARE_PER_CPU(unsigned long, this_cpu_off);
+
+/* For arch-specific code, we can use direct single-insn ops (they
+ * don't give an lvalue though). */
+extern void __bad_percpu_size(void);
+
+#define percpu_to_op(op,var,val)				\
+	do {							\
+		typedef typeof(var) T__;			\
+		if (0) { T__ tmp__; tmp__ = (val); }		\
+		switch (sizeof(var)) {				\
+		case 1:						\
+			asm(op "b %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		case 2:						\
+			asm(op "w %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		case 4:						\
+			asm(op "l %1,"__percpu_seg"%0"		\
+			    : "+m" (var)			\
+			    :"ri" ((T__)val));			\
+			break;					\
+		default: __bad_percpu_size();			\
+		}						\
+	} while (0)
+
+#define percpu_from_op(op,var)					\
+	({							\
+		typeof(var) ret__;				\
+		switch (sizeof(var)) {				\
+		case 1:						\
+			asm(op "b "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		case 2:						\
+			asm(op "w "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		case 4:						\
+			asm(op "l "__percpu_seg"%1,%0"		\
+			    : "=r" (ret__)			\
+			    : "m" (var));			\
+			break;					\
+		default: __bad_percpu_size();			\
+		}						\
+		ret__; })
+
+#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
+#define x86_write_percpu(var,val) percpu_to_op("mov", per_cpu__##var, val)
+#define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
+#define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
+#define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
+#endif /* !__ASSEMBLY__ */
+#endif /* !CONFIG_X86_64 */
+#endif /* _ASM_X86_PERCPU_H_ */
Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu_32.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu_32.h	2007-11-28 12:51:48.084703616 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,119 +0,0 @@
-#ifndef __ARCH_I386_PERCPU__
-#define __ARCH_I386_PERCPU__
-
-#ifdef __ASSEMBLY__
-
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    reg - 32bit register
- *
- * The resulting address is stored in the "reg" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
-#ifdef CONFIG_SMP
-#define PER_CPU(var, reg)				\
-	movl %fs:per_cpu__##this_cpu_off, reg;		\
-	lea per_cpu__##var(reg), reg
-#define PER_CPU_VAR(var)	%fs:per_cpu__##var
-#else /* ! SMP */
-#define PER_CPU(var, reg)			\
-	movl $per_cpu__##var, reg
-#define PER_CPU_VAR(var)	per_cpu__##var
-#endif	/* SMP */
-
-#else /* ...!ASSEMBLY */
-
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    cpu - 32bit register containing the current CPU number
- *
- * The resulting address is stored in the "cpu" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
-#ifdef CONFIG_SMP
-
-#define __my_cpu_offset x86_read_percpu(this_cpu_off)
-
-/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
-#define __percpu_seg "%%fs:"
-
-#else  /* !SMP */
-
-#define __percpu_seg ""
-
-#endif	/* SMP */
-
-#include <asm-generic/percpu.h>
-
-/* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
-
-/* For arch-specific code, we can use direct single-insn ops (they
- * don't give an lvalue though). */
-extern void __bad_percpu_size(void);
-
-#define percpu_to_op(op,var,val)				\
-	do {							\
-		typedef typeof(var) T__;			\
-		if (0) { T__ tmp__; tmp__ = (val); }		\
-		switch (sizeof(var)) {				\
-		case 1:						\
-			asm(op "b %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		case 2:						\
-			asm(op "w %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		case 4:						\
-			asm(op "l %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		default: __bad_percpu_size();			\
-		}						\
-	} while (0)
-
-#define percpu_from_op(op,var)					\
-	({							\
-		typeof(var) ret__;				\
-		switch (sizeof(var)) {				\
-		case 1:						\
-			asm(op "b "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		case 2:						\
-			asm(op "w "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		case 4:						\
-			asm(op "l "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		default: __bad_percpu_size();			\
-		}						\
-		ret__; })
-
-#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var,val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
-#endif /* !__ASSEMBLY__ */
-
-#endif /* __ARCH_I386_PERCPU__ */
Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu_64.h	2007-11-28 12:51:50.496213423 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,20 +0,0 @@
-#ifndef _ASM_X8664_PERCPU_H_
-#define _ASM_X8664_PERCPU_H_
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
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
-#endif
-#include <asm-generic/percpu.h>
-#endif /* _ASM_X8664_PERCPU_H_ */

-- 
