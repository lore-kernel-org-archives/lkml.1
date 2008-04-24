Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYDXPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYDXPP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbYDXPOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55934 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759103AbYDXPOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:30 -0400
Message-Id: <20080424151402.327003259@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 23/37] Immediate Values - Powerpc Optimization NMI MCE support
Content-Disposition: inline; filename=immediate-values-powerpc-optimization-nmi-mce-support.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:14:02 +0000
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
 arch/powerpc/kernel/immediate.c |   70 ++++++++++++++++++++++++++++++++++++++++
 include/asm-powerpc/immediate.h |   18 ++++++++++
 3 files changed, 89 insertions(+)

Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2008-04-16 21:22:29.000000000 -0400
@@ -0,0 +1,70 @@
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
+	case 1:	if (*(uint8_t *)imv->imv == *(uint8_t *)imv->var)
+			return 0;
+		*(uint8_t *)imv->imv = *(uint8_t *)imv->var;
+		break;
+	case 2:	if (*(uint16_t *)imv->imv == *(uint16_t *)imv->var)
+			return 0;
+		*(uint16_t *)imv->imv = *(uint16_t *)imv->var;
+		break;
+	default:return -EINVAL;
+	}
+	flush_icache_range(imv->imv, imv->imv + imv->size);
+	return 0;
+}
Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/immediate.h	2008-04-16 12:25:42.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2008-04-16 20:49:48.000000000 -0400
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
--- linux-2.6-lttng.orig/arch/powerpc/kernel/Makefile	2008-04-16 12:23:07.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/Makefile	2008-04-16 12:25:44.000000000 -0400
@@ -45,6 +45,7 @@ obj-$(CONFIG_HIBERNATION)	+= swsusp.o su
 obj64-$(CONFIG_HIBERNATION)	+= swsusp_asm64.o
 obj-$(CONFIG_MODULES)		+= module_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_44x)		+= cpu_setup_44x.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
 
 ifeq ($(CONFIG_PPC_MERGE),y)
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
