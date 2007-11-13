Return-Path: <linux-kernel-owner+w=401wt.eu-S1763442AbXKMTCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763442AbXKMTCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762514AbXKMTBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:01:25 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38449 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762350AbXKMTBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:01:24 -0500
Message-Id: <20071113190041.062037504@polymtl.ca>
References: <20071113185800.436425570@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:58:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 6/8] Immediate Values - Powerpc Optimization
Content-Disposition: inline; filename=immediate-values-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:00:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC optimization of the immediate values which uses a li instruction,
patched with an immediate value.

Changelog:
- Put immediate_set and _immediate_set in the architecture independent header.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/powerpc/Kconfig            |    3 +
 arch/powerpc/kernel/Makefile    |    1 
 arch/powerpc/kernel/immediate.c |  103 ++++++++++++++++++++++++++++++++++++++++
 include/asm-powerpc/immediate.h |   71 +++++++++++++++++++++++++++
 4 files changed, 178 insertions(+)

Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-11-13 13:53:28.000000000 -0500
@@ -0,0 +1,71 @@
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
+struct __immediate {
+	long var;		/* Identifier variable of the immediate value */
+	long immediate;		/*
+				 * Pointer to the memory location that holds
+				 * the immediate value within the load immediate
+				 * instruction.
+				 */
+	long size;		/* Type size. */
+} __attribute__ ((aligned(sizeof(long))));
+
+/**
+ * immediate_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _immediate_read() instead.
+ * Makes sure the 2 bytes update will be atomic by aligning the immediate
+ * value. Use a normal memory read for the 4 bytes immediate because there is no
+ * way to atomically update it without using a seqlock read side, which would
+ * cost more in term of total i-cache and d-cache space than a simple memory
+ * read.
+ */
+#define immediate_read(name)						\
+	({								\
+		__typeof__(name##__immediate) value;			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+					PPC_LONG "%c1, ((0f)+3), 1\n\t" \
+					".previous\n\t"			\
+					"0:\n\t"			\
+					"li %0,0\n\t"			\
+				: "=r" (value)				\
+				: "i" (&name##__immediate));		\
+			break;						\
+		case 2:							\
+			asm(".section __immediate,\"a\",@progbits\n\t"	\
+					PPC_LONG "%c1, ((0f)+2), 2\n\t" \
+					".previous\n\t"			\
+					".align 2\n\t"			\
+					"0:\n\t"			\
+					"li %0,0\n\t"			\
+				: "=r" (value)				\
+				: "i" (&name##__immediate));		\
+			break;						\
+		default:						\
+			value = name##__immediate;			\
+			break;						\
+		};							\
+		value;							\
+	})
+
+extern int arch_immediate_update(const struct __immediate *immediate);
+extern void arch_immediate_update_early(const struct __immediate *immediate);
+
+#endif /* _ASM_POWERPC_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/Makefile	2007-11-13 13:49:11.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/Makefile	2007-11-13 13:53:28.000000000 -0500
@@ -91,3 +91,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2007-11-13 13:53:28.000000000 -0500
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
+	case 1:	/* The uint8_t points to the 3rd byte of the
+		 * instruction */
+		insn = (void *)(immediate->immediate - 1 - LI_OPCODE_LEN);
+		break;
+	case 2:	insn = (void *)(immediate->immediate - LI_OPCODE_LEN);
+		break;
+	default:
+	return -EINVAL;
+	}
+
+	if (unlikely(*insn == BREAKPOINT_INSTRUCTION)) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %lu\n",
+				    (void *)immediate->immediate,
+				    (void *)immediate->var, immediate->size);
+		return -EBUSY;
+	}
+#endif
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+	case 1:	if (*(uint8_t *)immediate->immediate
+				== *(uint8_t *)immediate->var)
+			return 0;
+		break;
+	case 2:	if (*(uint16_t *)immediate->immediate
+				== *(uint16_t *)immediate->var)
+			return 0;
+		break;
+	default:return -EINVAL;
+	}
+	memcpy((void *)immediate->immediate, (void *)immediate->var,
+			immediate->size);
+	flush_icache_range((unsigned long)immediate->immediate,
+		(unsigned long)immediate->immediate + immediate->size);
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
+void arch_immediate_update_early(const struct __immediate *immediate)
+{
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (immediate->size) {
+	case 1:	if (*(uint8_t *)immediate->immediate
+				== *(uint8_t *)immediate->var)
+			return;
+		break;
+	case 2:	if (*(uint16_t *)immediate->immediate
+				== *(uint16_t *)immediate->var)
+			return;
+		break;
+	default:return;
+	}
+	memcpy((void *)immediate->immediate, (void *)immediate->var,
+			immediate->size);
+	flush_icache_range((unsigned long)immediate->immediate,
+		(unsigned long)immediate->immediate + immediate->size);
+}
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-11-13 13:53:36.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-11-13 13:53:58.000000000 -0500
@@ -169,6 +169,9 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_IMMEDIATE
+	def_bool y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
