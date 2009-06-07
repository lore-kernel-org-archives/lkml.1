Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZFGNC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZFGNC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbZFGMz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:55:57 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43332 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbZFGMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:55:52 -0400
X-Sasl-enc: Sdk7FKFrIG9ZQOPDAmxSI/pwyBnkbLb4NY8w66fUL/+T 1244378564
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2, tip] i386: Fix/simplify espfix, move it into assembly
Date: Sun,  7 Jun 2009 14:42:36 +0200
Message-Id: <1244378557-5455-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm>
References: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The espfix code triggers if we have a protected mode userspace 
application with a 16-bit stack. On returning to userspace, the CPU 
doesn't restore the high word of the stack pointer. This is an 
"official" bug, and the work-around used in the kernel is to temporarily 
switch to a 32-bit stack segment/pointer pair where the high word of the 
pointer is equal to the high word of the userspace stackpointer, just 
before doing the iret.

The current implementation uses THREAD_SIZE to determine the cut-off, 
but there is no good reason not to use natural 1<<16... However, 
implementing this by simply substituting THREAD_SIZE with 1<<16 in 
patch_espfix_desc crashed the test application. patch_espfix_desc tries 
to do what is described above, but gets it subtly wrong if the userspace 
stack pointer is just below a multiple of THREAD_SIZE: an overflow 
occurs to bit 13... With a bit of luck, when the kernelspace 
stackpointer is just below a 64kb-boundary, the overflow then ripples 
trough to bit 16 and the userspace stack pointer will then be changed by 
65536. Changing the cut-off to bit 16 just made the problem occur
reliably.

This patch moves all espfix code into entry_32.S. Selecting a 16-bit 
cut-off simplifies the code enormously. The game with changing the limit 
dynamically is removed too. It complicates matters and I see no value in 
it. Changing only the top 16-bit word of ESP is one instruction and it 
also implies that only two bytes of the ESPFIX GDT entry need to be 
changed and this can be implemented in just a handful simple to 
understand instructions. As a side effect, the operation to compute the 
original ESP from the ESPFIX ESP and the GDT entry simplifies a bit too, 
and the remaining three instructions have been expanded inline in 
entry_32.S.

Follow-up cleanup:
 - GET_DESC_BASE macro removed
 - #include <asm/desc.h> removed from head_32.S and entry_32.S
 - arch/x86/include/asm/desc.h de-ASSEMBLY-ized
 - patch_espfix_desc() removed from arch/x86/kernel/traps.c 

impact: can now run with ESP=xxxxfffc on 16-bit stack segment

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

---
 arch/x86/include/asm/desc.h  |   26 ---------------------
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/entry_32.S   |   50 ++++++++++++++++++++++++++++-------------
 arch/x86/kernel/head_32.S    |    1 -
 arch/x86/kernel/traps.c      |   21 -----------------
 5 files changed, 35 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index c45f415..c993e9e 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_DESC_H
 #define _ASM_X86_DESC_H
 
-#ifndef __ASSEMBLY__
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
@@ -380,29 +379,4 @@ static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
 }
 
-#else
-/*
- * GET_DESC_BASE reads the descriptor base of the specified segment.
- *
- * Args:
- *    idx - descriptor index
- *    gdt - GDT pointer
- *    base - 32bit register to which the base will be written
- *    lo_w - lo word of the "base" register
- *    lo_b - lo byte of the "base" register
- *    hi_b - hi byte of the low word of the "base" register
- *
- * Example:
- *    GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
- *    Will read the base address of GDT_ENTRY_ESPFIX_SS and put it into %eax.
- */
-#define GET_DESC_BASE(idx, gdt, base, lo_w, lo_b, hi_b) \
-	movb idx * 8 + 4(gdt), lo_b;			\
-	movb idx * 8 + 7(gdt), hi_b;			\
-	shll $16, base;					\
-	movw idx * 8 + 2(gdt), lo_w;
-
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* _ASM_X86_DESC_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3ffdcfa..9b95c2f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -108,7 +108,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	/* data */
 	[GDT_ENTRY_APMBIOS_BASE+2]	= { { { 0x0000ffff, 0x00409200 } } },
 
-	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x00000000, 0x00c09200 } } },
+	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_PERCPU]		= { { { 0x0000ffff, 0x00cf9200 } } },
 	GDT_STACK_CANARY_INIT
 #endif
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index d7d1c7d..96f9942 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -48,7 +48,6 @@
 #include <asm/segment.h>
 #include <asm/smp.h>
 #include <asm/page_types.h>
-#include <asm/desc.h>
 #include <asm/percpu.h>
 #include <asm/dwarf2.h>
 #include <asm/processor-flags.h>
@@ -588,24 +587,34 @@ ldt_ss:
 	jne restore_nocheck
 #endif
 
-	/* If returning to userspace with 16bit stack,
-	 * try to fix the higher word of ESP, as the CPU
-	 * won't restore it.
-	 * This is an "official" bug of all the x86-compatible
-	 * CPUs, which we can try to work around to make
-	 * dosemu and wine happy. */
-	movl PT_OLDESP(%esp), %eax
-	movl %esp, %edx
-	call patch_espfix_desc
+/*
+ * Setup and switch to ESPFIX stack
+ *
+ * We're returning to userspace with a 16 bit stack. The CPU will not
+ * restore the high word of ESP for us on executing iret... This is an
+ * "official" bug of all the x86-compatible CPUs, which we can work
+ * around to make dosemu and wine happy. We do this by preloading the
+ * high word of ESP with the high word of the userspace ESP while
+ * compensating for the offset by changing to the ESPFIX segment with
+ * a base address that matches for the difference.
+ */
+	mov %esp, %edx			/* load kernel esp */
+	mov PT_OLDESP(%esp), %eax	/* load userspace esp */
+	mov %dx, %ax			/* eax: new kernel esp */
+	sub %eax, %edx			/* offset (low word is 0) */
+	PER_CPU(gdt_page, %ebx)
+	shr $16, %edx
+	mov %dl, GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx) /* bits 16..23 */
+	mov %dh, GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx) /* bits 24..31 */
 	pushl $__ESPFIX_SS
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl %eax
+	push %eax			/* new kernel esp */
 	CFI_ADJUST_CFA_OFFSET 4
 	/* Disable interrupts, but do not irqtrace this section: we
 	 * will soon execute iret and the tracer was already set to
 	 * the irqstate after the iret */
 	DISABLE_INTERRUPTS(CLBR_EAX)
-	lss (%esp), %esp
+	lss (%esp), %esp		/* switch to espfix segment */
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
 	CFI_ENDPROC
@@ -718,15 +727,24 @@ PTREGSCALL(vm86)
 PTREGSCALL(vm86old)
 
 .macro FIXUP_ESPFIX_STACK
-	/* since we are on a wrong stack, we cant make it a C code :( */
+/*
+ * Switch back for ESPFIX stack to the normal zerobased stack
+ *
+ * We can't call C functions using the ESPFIX stack. This code reads
+ * the high word of the segment base from the GDT and swiches to the
+ * normal stack and adjusts ESP with the matching offset.
+ */
+	/* fixup the stack */
 	PER_CPU(gdt_page, %ebx)
-	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
-	addl %esp, %eax
+	mov GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx), %al /* bits 16..23 */
+	mov GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx), %ah /* bits 24..31 */
+	shl $16, %eax
+	addl %esp, %eax			/* the adjusted stack pointer */
 	pushl $__KERNEL_DS
 	CFI_ADJUST_CFA_OFFSET 4
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
-	lss (%esp), %esp
+	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
 .endm
 .macro UNWIND_ESPFIX_STACK
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index dc5ed4b..8663afb 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -13,7 +13,6 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/pgtable_types.h>
-#include <asm/desc.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c8a7f87..4bd1f6f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -763,27 +763,6 @@ do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
-{
-	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
-	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
-	unsigned long new_kesp = kesp - base;
-	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
-	__u64 desc = *(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS];
-
-	/* Set up base for espfix segment */
-	desc &= 0x00f0ff0000000000ULL;
-	desc |=	((((__u64)base) << 16) & 0x000000ffffff0000ULL) |
-		((((__u64)base) << 32) & 0xff00000000000000ULL) |
-		((((__u64)lim_pages) << 32) & 0x000f000000000000ULL) |
-		(lim_pages & 0xffff);
-	*(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS] = desc;
-
-	return new_kesp;
-}
-#endif
-
 asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 }
-- 
1.6.0.4

