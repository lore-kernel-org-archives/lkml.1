Return-Path: <linux-kernel-owner+w=401wt.eu-S965641AbXCVDwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbXCVDwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 23:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965647AbXCVDwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 23:52:49 -0400
Received: from ozlabs.org ([203.10.76.45]:60847 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXCVDws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 23:52:48 -0400
Subject: [PATCH] Use X86_EFLAGS_IF in irqflags.h, lguest.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1174533874.2713.105.camel@localhost.localdomain>
References: <1174533374.2713.104.camel@localhost.localdomain>
	 <1174533874.2713.105.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 14:52:29 +1100
Message-Id: <1174535550.2713.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 14:24 +1100, Rusty Russell wrote:
> Belay this: there's a X86_EFLAGS_IF in asm/processor.h which we should
> use.  Will send patch.

How's this.  There may be other users, but they're not easy to grep for.

==
Move X86_EFLAGS_IF et al out to a new header: processor-flags.h, so we
can include it from irqflags.h and use it in raw_irqs_disabled_flags().

As a side-effect, we could now use these flags in .S files.

Lguest also modified to use the flags.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r bd0a803d9948 include/asm-i386/processor-flags.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-i386/processor-flags.h	Thu Mar 22 14:31:41 2007 +1100
@@ -0,0 +1,26 @@
+#ifndef __ASM_I386_PROCESSOR_FLAGS_H
+#define __ASM_I386_PROCESSOR_FLAGS_H
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
+#endif	/* __ASM_I386_PROCESSOR_FLAGS_H */
diff -r bd0a803d9948 include/asm-i386/irqflags.h
--- a/include/asm-i386/irqflags.h	Thu Mar 22 14:13:31 2007 +1100
+++ b/include/asm-i386/irqflags.h	Thu Mar 22 14:47:21 2007 +1100
@@ -9,6 +9,7 @@
  */
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
+#include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
 static inline unsigned long native_save_fl(void)
@@ -119,7 +120,7 @@ static inline unsigned long __raw_local_
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (1 << 9));
+	return !(flags & X86_EFLAGS_IF);
 }
 
 static inline int raw_irqs_disabled(void)
diff -r bd0a803d9948 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h	Thu Mar 22 14:13:31 2007 +1100
+++ b/include/asm-i386/processor.h	Thu Mar 22 14:31:58 2007 +1100
@@ -21,6 +21,7 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <asm/processor-flags.h>
 
 /* flag for disabling the tsc */
 extern int tsc_disable;
@@ -125,27 +126,6 @@ extern void detect_ht(struct cpuinfo_x86
 #else
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
-
-/*
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
 
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)
diff -r bd0a803d9948 arch/i386/lguest/interrupts_and_traps.c
--- a/arch/i386/lguest/interrupts_and_traps.c	Thu Mar 22 14:13:31 2007 +1100
+++ b/arch/i386/lguest/interrupts_and_traps.c	Thu Mar 22 14:46:15 2007 +1100
@@ -42,7 +42,7 @@ static void reflect_trap(struct lguest *
 	   (it's always 0, since irqs are enabled when guest is running). */
 	eflags = regs->eflags;
 	get_user(irq_enable, &lg->lguest_data->irq_enabled);
-	eflags |= (irq_enable & 512);
+	eflags |= (irq_enable & X86_EFLAGS_IF);
 
 	push_guest_stack(lg, &gstack, eflags);
 	push_guest_stack(lg, &gstack, regs->cs);
@@ -86,7 +86,7 @@ void maybe_do_interrupt(struct lguest *l
 	/* If they're halted, we re-enable interrupts. */
 	if (lg->halted) {
 		/* Re-enable interrupts. */
-		put_user(512, &lg->lguest_data->irq_enabled);
+		put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled);
 		lg->halted = 0;
 	} else {
 		/* Maybe they have interrupts disabled? */
diff -r bd0a803d9948 arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c	Thu Mar 22 14:13:31 2007 +1100
+++ b/arch/i386/lguest/lguest.c	Thu Mar 22 14:26:41 2007 +1100
@@ -107,9 +107,8 @@ static void fastcall irq_disable(void)
 
 static void fastcall irq_enable(void)
 {
-	/* Linux i386 code expects bit 9 set. */
 	/* FIXME: Check if interrupt pending... */
-	lguest_data.irq_enabled = 512;
+	lguest_data.irq_enabled = X86_EFLAGS_IF;
 }
 
 static void fastcall lguest_load_gdt(const struct Xgt_desc_struct *desc)
@@ -394,7 +393,7 @@ static fastcall void lguest_write_idt_en
 	extern const char start_##name[], end_##name[];		\
 	asm("start_" #name ": " code "; end_" #name ":")
 DEF_LGUEST(cli, "movl $0," LGUEST_IRQ);
-DEF_LGUEST(sti, "movl $512," LGUEST_IRQ);
+DEF_LGUEST(sti, "movl $"__stringify(X86_EFLAGS_IF)"," LGUEST_IRQ);
 DEF_LGUEST(popf, "movl %eax," LGUEST_IRQ);
 DEF_LGUEST(pushf, "movl " LGUEST_IRQ ",%eax");
 DEF_LGUEST(pushf_cli, "movl " LGUEST_IRQ ",%eax; movl $0," LGUEST_IRQ);


