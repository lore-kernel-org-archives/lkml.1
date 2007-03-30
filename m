Return-Path: <linux-kernel-owner+w=401wt.eu-S1945920AbXC3DMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945920AbXC3DMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945926AbXC3DMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:12:52 -0400
Received: from ozlabs.org ([203.10.76.45]:39142 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945920AbXC3DMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:12:51 -0400
Subject: [PATCH] Use X86_EFLAGS_IF in x86-64/irqflags.h.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Gerd Hoffmann <kraxel@suse.de>, Alan <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070329121958.GA35584@muc.de>
References: <1175154408.12230.195.camel@localhost.localdomain>
	 <20070329103602.GB52274@muc.de>
	 <1175166417.12230.206.camel@localhost.localdomain>
	 <20070329121958.GA35584@muc.de>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 13:12:23 +1000
Message-Id: <1175224343.12230.368.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-29 at 14:19 +0200, Andi Kleen wrote:
> On Thu, Mar 29, 2007 at 09:06:57PM +1000, Rusty Russell wrote:

[SNIP: processor-flags.h patch for i386 ]

> Ok. Can you do it for x86-64 too?

OK, here it is.  Compiles, but -rc5-mm2 doesn't link for me on x86-64 at
the moment.

Something seems quite wrong with CONFIG_X86_VSMP.  AFAICT (1 << 18) is
the "alignment check" flag, not the "virtual interrupt" flag which I
expected.

Cheers,
Rusty.
==
As per i386 patch: move X86_EFLAGS_IF et al out to a new header:
processor-flags.h, so we can include it from irqflags.h and use it in
raw_irqs_disabled_flags().

As a side-effect, we could now use these flags in .S files.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 533294f1af63 include/asm-x86_64/irqflags.h
--- a/include/asm-x86_64/irqflags.h	Thu Mar 29 18:52:58 2007 +1000
+++ b/include/asm-x86_64/irqflags.h	Fri Mar 30 12:57:01 2007 +1000
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
diff -r 533294f1af63 include/asm-x86_64/processor-flags.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-x86_64/processor-flags.h	Fri Mar 30 12:48:11 2007 +1000
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
diff -r 533294f1af63 include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h	Thu Mar 29 18:52:58 2007 +1000
+++ b/include/asm-x86_64/processor.h	Fri Mar 30 12:44:11 2007 +1000
@@ -20,6 +20,7 @@
 #include <asm/percpu.h>
 #include <linux/personality.h>
 #include <linux/cpumask.h>
+#include <asm/processor-flags.h>
 
 #define TF_MASK		0x00000100
 #define IF_MASK		0x00000200
@@ -103,27 +104,6 @@ extern unsigned short num_cache_leaves;
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


