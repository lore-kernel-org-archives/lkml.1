Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbXFOVLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbXFOVLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXFOVK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:10:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:36035 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXFOVK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:10:57 -0400
Message-Id: <20070615202926.527054899@polymtl.ca>
References: <20070615202310.178466032@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 15 Jun 2007 16:23:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 5/8] Immediate Value - PowerPC Optimization
Content-Disposition: inline; filename=immediate-values-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 15 Jun 2007 21:11:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC optimization of the immediate values which uses a li instruction,
patched with an immediate value 0 or 1 to set the immediate value.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/powerpc/kernel/Makefile    |    1 
 arch/powerpc/kernel/immediate.c |   34 +++++++++++++++++++
 include/asm-powerpc/immediate.h |   69 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 103 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/immediate.h	2007-06-15 16:13:55.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-06-15 16:14:04.000000000 -0400
@@ -1 +1,68 @@
-#include <asm-generic/immediate.h>
+#ifndef _ASM_POWERPC_IMMEDIATE_H
+#define _ASM_POWERPC_IMMEDIATE_H
+
+/*
+ * Immediate values. PowerPC architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm-compat.h>
+
+#define IF_DEFAULT (IF_OPTIMIZED | IF_LOCKDEP)
+
+/* Optimized version of the immediate */
+#define immediate_optimized(flags, var)					\
+	({								\
+		char condition;						\
+		asm (	".section __immediate, \"a\", @progbits;\n\t"	\
+					PPC_LONG "%1, 0f, %2;\n\t"	\
+					".previous;\n\t"		\
+					".align 4\n\t"			\
+					"0:\n\t"			\
+					"li %0,%3;\n\t"			\
+				: "=r" (condition)			\
+				: "i" (&var),				\
+				  "i" (flags),				\
+				  "i" (0));				\
+		(condition);						\
+	})
+
+/*
+ * immediate macro selecting the generic or optimized version of immediate,
+ * depending on the flags specified. It is a macro because we need to pass the
+ * name to immediate_optimized() and immediate_generic() so they can declare a
+ * static variable with it.
+ */
+#define _immediate(flags, var)						\
+({									\
+	((flags) & IF_OPTIMIZED) ?					\
+		immediate_optimized(flags, var) :			\
+		immediate_generic(flags, var);				\
+})
+
+/* immediate with default behavior */
+#define immediate(var)	 _immediate(IF_DEFAULT, var)
+
+/*
+ * Architecture dependant immediate information, used internally for immediate
+ * activation.
+ */
+
+/*
+ * Offset of the immediate value from the start of the addi instruction (result
+ * of the li mnemonic), in bytes.
+ */
+#define IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 2
+#define IMMEDIATE_OPTIMIZED_ENABLE_TYPE unsigned short
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define IMMEDIATE_OPTIMIZED_ENABLE(a)					\
+	(*(IMMEDIATE_OPTIMIZED_ENABLE_TYPE*)				\
+		((char*)(a)+IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET))
+
+extern int immediate_optimized_set_enable(void *address, char enable);
+
+#endif /* _ASM_POWERPC_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/Makefile	2007-06-15 16:13:51.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/Makefile	2007-06-15 16:14:04.000000000 -0400
@@ -96,3 +96,4 @@
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2007-06-15 16:14:04.000000000 -0400
@@ -0,0 +1,34 @@
+/*
+ * Powerpc optimized immediate values enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/string.h>
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+
+/*
+ * The address is aligned on 4 bytes boundary: the 4 bytes instruction we are
+ * changing fits within one page.
+ */
+int immediate_optimized_set_enable(void *address, char enable)
+{
+	char newi[IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET
+			+ sizeof(IMMEDIATE_OPTIMIZED_ENABLE_TYPE);
+
+#if defined(CONFIG_DEBUG_PAGEALLOC)
+	/* Make sure this page is writable */
+	change_page_attr(virt_to_page(address), 1, PAGE_KERNEL_EXEC);
+	global_flush_tlb();
+#endif
+	memcpy(newi, address, size);
+	IMMEDIATE_OPTIMIZED_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(immediate_optimized_set_enable);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
