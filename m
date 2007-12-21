Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbXLUB7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbXLUB7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXLUB6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:58:14 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35506 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759831AbXLUB6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:58:10 -0500
Message-Id: <20071221015729.821534864@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:55:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 22/24] Immediate Values - Powerpc Optimization NMI MCE support
Content-Disposition: inline; filename=immediate-values-powerpc-optimization-nmi-mce-support.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an atomic update for immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@infradead.org>
CC: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/Makefile    |    1 
 arch/powerpc/kernel/immediate.c |   73 ++++++++++++++++++++++++++++++++++++++++
 include/asm-powerpc/immediate.h |   18 +++++++++
 3 files changed, 92 insertions(+)

Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2007-12-20 20:52:27.000000000 -0500
@@ -0,0 +1,73 @@
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
+ * arch_imv_update - update one immediate value
+ * @imv: pointer of type const struct __imv to update
+ * @early: early boot (1), normal (0)
+ *
+ * Update one immediate value. Must be called with imv_mutex held.
+ */
+int arch_imv_update(const struct __imv *imv, int early)
+{
+#ifdef CONFIG_KPROBES
+	kprobe_opcode_t *insn;
+	/*
+	 * Fail if a kprobe has been set on this instruction.
+	 * (TODO: we could eventually do better and modify all the (possibly
+	 * nested) kprobes for this site if kprobes had an API for this.
+	 */
+	switch (imv->size) {
+	case 1:	/* The uint8_t points to the 3rd byte of the
+		 * instruction */
+		insn = (void *)(imv->imv - 1 - LI_OPCODE_LEN);
+		break;
+	case 2:	insn = (void *)(imv->imv - LI_OPCODE_LEN);
+		break;
+	default:
+	return -EINVAL;
+	}
+
+	if (unlikely(!early && *insn == BREAKPOINT_INSTRUCTION)) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %lu\n",
+				    (void *)imv->imv,
+				    (void *)imv->var, imv->size);
+		return -EBUSY;
+	}
+#endif
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (imv->size) {
+	case 1:	if (*(uint8_t *)imv->imv
+				== *(uint8_t *)imv->var)
+			return 0;
+		break;
+	case 2:	if (*(uint16_t *)imv->imv
+				== *(uint16_t *)imv->var)
+			return 0;
+		break;
+	default:return -EINVAL;
+	}
+	memcpy((void *)imv->imv, (void *)imv->var,
+			imv->size);
+	flush_icache_range(imv->imv,
+		imv->imv + imv->size);
+	return 0;
+}
Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/immediate.h	2007-12-20 20:52:20.000000000 -0500
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-12-20 20:52:27.000000000 -0500
@@ -12,6 +12,16 @@
 
 #include <asm/asm-compat.h>
 
+struct __imv {
+	unsigned long var;	/* Identifier variable of the immediate value */
+	unsigned long imv;	/*
+				 * Pointer to the memory location that holds
+				 * the immediate value within the load immediate
+				 * instruction.
+				 */
+	unsigned char size;	/* Type size. */
+} __attribute__ ((packed));
+
 /**
  * imv_read - read immediate variable
  * @name: immediate value name
@@ -19,6 +29,11 @@
  * Reads the value of @name.
  * Optimized version of the immediate.
  * Do not use in __init and __exit functions. Use _imv_read() instead.
+ * Makes sure the 2 bytes update will be atomic by aligning the immediate
+ * value. Use a normal memory read for the 4 bytes immediate because there is no
+ * way to atomically update it without using a seqlock read side, which would
+ * cost more in term of total i-cache and d-cache space than a simple memory
+ * read.
  */
 #define imv_read(name)							\
 	({								\
@@ -40,6 +55,7 @@
 					PPC_LONG "%c1, ((1f)-2)\n\t"	\
 					".byte 2\n\t"			\
 					".previous\n\t"			\
+					".align 2\n\t"			\
 					"li %0,0\n\t"			\
 					"1:\n\t"			\
 				: "=r" (value)				\
@@ -52,4 +68,6 @@
 		value;							\
 	})
 
+extern int arch_imv_update(const struct __imv *imv, int early);
+
 #endif /* _ASM_POWERPC_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/Makefile	2007-12-20 20:52:20.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/Makefile	2007-12-20 20:52:27.000000000 -0500
@@ -91,3 +91,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
