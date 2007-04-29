Return-Path: <linux-kernel-owner+w=401wt.eu-S1161579AbXD2Xrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161579AbXD2Xrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161609AbXD2Xr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161575AbXD2XqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:17 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/26] x86_64: Use X86_EFLAGS_IF in x86-64/irqflags.h.
Message-Id: <20070429234616.2B840151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As per i386 patch: move X86_EFLAGS_IF et al out to a new header:
processor-flags.h, so we can include it from irqflags.h and use it in
raw_irqs_disabled_flags().

As a side-effect, we could now use these flags in .S files.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/irqflags.h        |    9 +++++----
 include/asm-x86_64/processor-flags.h |   26 ++++++++++++++++++++++++++
 include/asm-x86_64/processor.h       |   22 +---------------------
 3 files changed, 32 insertions(+), 25 deletions(-)

Index: linux/include/asm-x86_64/irqflags.h
===================================================================
--- linux.orig/include/asm-x86_64/irqflags.h
+++ linux/include/asm-x86_64/irqflags.h
@@ -9,6 +9,7 @@
  */
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
+#include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
 /*
@@ -53,19 +54,19 @@ static inline void raw_local_irq_disable
 {
 	unsigned long flags = __raw_local_save_flags();
 
-	raw_local_irq_restore((flags & ~(1 << 9)) | (1 << 18));
+	raw_local_irq_restore((flags & ~X86_EFLAGS_IF) | X86_EFLAGS_AC);
 }
 
 static inline void raw_local_irq_enable(void)
 {
 	unsigned long flags = __raw_local_save_flags();
 
-	raw_local_irq_restore((flags | (1 << 9)) & ~(1 << 18));
+	raw_local_irq_restore((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (1<<9)) || (flags & (1 << 18));
+	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
 }
 
 #else /* CONFIG_X86_VSMP */
@@ -82,7 +83,7 @@ static inline void raw_local_irq_enable(
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (1 << 9));
+	return !(flags & X86_EFLAGS_IF);
 }
 
 #endif
Index: linux/include/asm-x86_64/processor-flags.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/processor-flags.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_X86_64_PROCESSOR_FLAGS_H
+#define __ASM_X86_64_PROCESSOR_FLAGS_H
+/* Various flags defined: can be included from assembler. */
+
+/*
+ * EFLAGS bits
+ */
+#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
+#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
+#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
+#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
+#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
+#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
+#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
+#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
+#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
+#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
+#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
+#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
+#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
+#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
+#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
+#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
+#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
+
+#endif /* __ASM_X86_64_PROCESSOR_FLAGS_H */
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -20,6 +20,7 @@
 #include <asm/percpu.h>
 #include <linux/personality.h>
 #include <linux/cpumask.h>
+#include <asm/processor-flags.h>
 
 #define TF_MASK		0x00000100
 #define IF_MASK		0x00000200
@@ -103,27 +104,6 @@ extern unsigned int init_intel_cacheinfo
 extern unsigned short num_cache_leaves;
 
 /*
- * EFLAGS bits
- */
-#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
-#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
-#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
-#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
-#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
-#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
-#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
-#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
-#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
-#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
-#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
-#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
-#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
-#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
-#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
-#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
-#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
-
-/*
  * Intel CPU features in CR4
  */
 #define X86_CR4_VME		0x0001	/* enable vm86 extensions */
