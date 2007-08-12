Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbXHLPMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbXHLPMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936234AbXHLPIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:08:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47595 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936222AbXHLPIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:08:46 -0400
Message-Id: <20070812150816.032383827@polymtl.ca>
References: <20070812150702.769065566@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:07:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 6/8] Immediate Values - Powerpc Optimization
Content-Disposition: inline; filename=immediate-values-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:08:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC optimization of the immediate values which uses a li instruction,
patched with an immediate value.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/powerpc/kernel/Makefile    |    1 
 arch/powerpc/kernel/immediate.c |  103 ++++++++++++++++++++++++++++++++
 include/asm-powerpc/immediate.h |  127 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+)

Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-08-07 13:33:13.000000000 -0400
@@ -0,0 +1,127 @@
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
+struct module;
+
+struct __immediate {
+	long var;		/* Identifier variable of the immediate value */
+	long immediate;		/*
+				 * Pointer to the memory location that holds
+				 * the immediate value within the load immediate
+				 * instruction.
+				 */
+	long size;		/* Type size. */
+};
+
+/**
+ * immediate_read - read immediate variable
+ * @var: pointer of type immediate_*_t
+ *
+ * Reads the value of @var.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _immediate_read() instead.
+ * Makes sure the 2 bytes update will be atomic by aligning the immediate
+ * value. Use a normal memory read for the 4 bytes immediate because there is no
+ * way to atomically update it without using a seqlock read side, which would
+ * cost more in term of total i-cache and d-cache space than a simple memory
+ * read.
+ */
+#define immediate_read(var)						\
+	({								\
+		__typeof__((var)->value) value;				\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm (	".section __immediate, \"a\", @progbits;\n\t" \
+					PPC_LONG "%1, ((0f)+3), 1;\n\t"	\
+					".previous;\n\t"		\
+					"0:\n\t"			\
+					"li %0,%2;\n\t"			\
+				: "=r" (value)				\
+				: "i" (&(var)->value),			\
+				  "i" (0));				\
+			break;						\
+		case 2:							\
+			asm (	".section __immediate, \"a\", @progbits;\n\t" \
+					PPC_LONG "%1, ((0f)+2), 2;\n\t"	\
+					".previous;\n\t"		\
+					".align 2\n\t"			\
+					"0:\n\t"			\
+					"li %0,%2;\n\t"			\
+				: "=r" (value)				\
+				: "i" (&(var)->value),			\
+				  "i" (0));				\
+			break;						\
+		default:						\
+			value = (var)->value;				\
+			break;						\
+		};							\
+		value;							\
+	})
+
+/**
+ * immediate_set - set immediate variable (with locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var, taking the module_mutex if required by
+ * the architecture.
+ */
+#define immediate_set(var, i) \
+	(var)->value = (i); \
+	immediate_update(1);
+
+/**
+ * _immediate_set - set immediate variable (without locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Must be called with module_mutex held.
+ */
+#define _immediate_set(var, i) \
+	(var)->value = (i); \
+	immediate_update(0);
+
+/**
+ * immediate_set_early - set immediate variable at early boot
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Should be used for early boot updates.
+ */
+#define immediate_set_early(var, i) \
+	(var)->value = (i); \
+	immediate_update_early();
+
+/**
+ * immediate_if - if () statement depending on an immediate value
+ * @var: pointer of type immediate_*_t
+ *
+ * Use as an if () statement depending on an immediate value.
+ * Do not use in __init and __exit functions. Use _immediate_if() instead.
+ * Branch depending on an immediate value. Could eventually be optimized further
+ * by improving gcc to give the ability to patch a jump instruction instead of
+ * the value it depends on.
+ */
+#define immediate_if(var)	if (unlikely(immediate_read(var)))
+
+/*
+ * Internal update functions.
+ */
+extern void immediate_update(int lock);
+extern void module_immediate_setup(struct module *mod);
+extern void immediate_update_early(void);
+extern int arch_immediate_update(const struct __immediate *immediate);
+extern void arch_immediate_update_early(const struct __immediate *immediate);
+
+#endif /* _ASM_POWERPC_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/Makefile	2007-08-07 13:32:35.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/Makefile	2007-08-07 13:32:53.000000000 -0400
@@ -103,3 +103,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2007-08-07 13:33:20.000000000 -0400
@@ -0,0 +1,103 @@
+/*
+ * Powerpc optimized immediate values enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/string.h>
+#include <linux/kprobes.h>
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+
+#define LI_OPCODE_LEN	2
+
+/**
+ * arch_immediate_update - update one immediate value
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value. Must be called with immediate_mutex held.
+ */
+int arch_immediate_update(const struct __immediate *immediate)
+{
+#ifdef CONFIG_KPROBES
+	kprobe_opcode_t *insn;
+	/*
+	 * Fail if a kprobe has been set on this instruction.
+	 * (TODO: we could eventually do better and modify all the (possibly
+	 * nested) kprobes for this site if kprobes had an API for this.
+	 */
+	switch (immediate->size) {
+		case 1:	/* The uint8_t points to the 3rd byte of the
+			 * instruction */
+			insn = (void*)(immediate->immediate - 1 - LI_OPCODE_LEN);
+			break;
+		case 2:	insn = (void*)(immediate->immediate - LI_OPCODE_LEN);
+			break;
+		default:
+		return -EINVAL;
+	}
+
+	if (unlikely(*insn == BREAKPOINT_INSTRUCTION)) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %lu\n",
+				    (void*)immediate->immediate,
+				    (void*)immediate->var, immediate->size);
+		return -EBUSY;
+	}
+#endif
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+		case 1:	if (*(uint8_t*)immediate->immediate
+					== *(uint8_t*)immediate->var)
+				return 0;
+			break;
+		case 2:	if (*(uint16_t*)immediate->immediate
+					== *(uint16_t*)immediate->var)
+				return 0;
+			break;
+		default:return -EINVAL;
+	}
+	memcpy((void*)immediate->immediate, (void*)immediate->var,
+			immediate->size);
+	flush_icache_range((unsigned long)immediate->immediate,
+				immediate->size);
+	return 0;
+}
+
+/**
+ * arch_immediate_update_early - update one immediate value at boot time
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value at boot time.
+ * We can use flush_icache_range, since the cpu identification has been done in
+ * the early_init stage.
+ */
+void __init arch_immediate_update_early(const struct __immediate *immediate)
+{
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+		case 1:	if (*(uint8_t*)immediate->immediate
+					== *(uint8_t*)immediate->var)
+				return;
+			break;
+		case 2:	if (*(uint16_t*)immediate->immediate
+					== *(uint16_t*)immediate->var)
+				return;
+			break;
+		default:return;
+	}
+	memcpy((void*)immediate->immediate, (void*)immediate->var,
+			immediate->size);
+	flush_icache_range((unsigned long)immediate->immediate,
+				immediate->size);
+}

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
