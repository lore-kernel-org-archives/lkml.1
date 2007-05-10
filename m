Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXEJCxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXEJCxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXEJCw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:52:56 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35958 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbXEJCwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:52:55 -0400
Message-Id: <20070510020916.196492766@polymtl.ca>
References: <20070510015555.973107048@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:55:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 04/10] Linux Kernel Markers - PowerPC optimized version
Content-Disposition: inline; filename=linux-kernel-markers-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 02:52:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile |    1 
 arch/powerpc/kernel/marker.c |   25 ++++++++++++
 include/asm-powerpc/marker.h |   85 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

Index: linux-2.6-lttng/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/Makefile	2007-05-09 18:14:51.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/Makefile	2007-05-09 18:16:00.000000000 -0400
@@ -96,3 +96,4 @@
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
Index: linux-2.6-lttng/arch/powerpc/kernel/marker.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/kernel/marker.c	2007-05-09 18:16:00.000000000 -0400
@@ -0,0 +1,25 @@
+/* marker.c
+ *
+ * Powerpc optimized marker enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/string.h>
+#include <asm/cacheflush.h>
+
+int marker_optimized_set_enable(void *address, char enable)
+{
+	char newi[MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET
+			+ sizeof(MARK_OPTIMIZED_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	MARK_OPTIMIZED_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
Index: linux-2.6-lttng/include/asm-powerpc/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/marker.h	2007-05-09 18:16:00.000000000 -0400
@@ -0,0 +1,85 @@
+#ifndef _ASM_POWERPC_MARKER_H
+#define _ASM_POWERPC_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. PowerPC architecture
+ * optimisations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm-compat.h>
+
+#ifdef CONFIG_MARKERS
+
+#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
+
+/* Optimized version of the markers */
+#define trace_mark_optimized(flags, name, format, args...) \
+	do { \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= format; \
+		static const char __mstrtab_args_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #args; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		__mstrtab_args_##name, \
+		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
+		char condition; \
+		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
+					PPC_LONG "%1, 0f;\n\t" \
+					".previous;\n\t" \
+					".align 4\n\t" \
+					"0:\n\t" \
+					"li %0,0;\n\t" \
+				: "=r" (condition) \
+				: "i" (&__mark_data_##name)); \
+		__mark_check_format(format, ## args); \
+		if (unlikely(condition)) { \
+			preempt_disable(); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
+
+/* Marker macro selecting the generic or optimized version of marker, depending
+ * on the flags specified. */
+#define _trace_mark(flags, format, args...) \
+do { \
+	if ((flags) & MF_OPTIMIZED) \
+		trace_mark_optimized(flags, format, ## args); \
+	else \
+		trace_mark_generic(flags, format, ## args); \
+} while (0)
+
+/* Marker with default behavior */
+#define trace_mark(format, args...) _trace_mark(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
+
+/* Offset of the immediate value from the start of the addi instruction (result
+ * of the li mnemonic), in bytes. */
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 2
+#define MARK_OPTIMIZED_ENABLE_TYPE short
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
+
+extern int marker_optimized_set_enable(void *address, char enable);
+
+#endif
+#endif //_ASM_POWERPC_MARKER_H

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
