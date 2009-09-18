Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZIRUzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZIRUzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZIRUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:55:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:4656 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZIRUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:55:46 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
Date: Fri, 18 Sep 2009 23:55:42 +0300
Message-Id: <c9f73fa56a41bc1051cd347cc453081235e3d776.1253307263.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needed for proper prefetch abort handling on ARMv7.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/include/asm/glue.h    |   10 ++++++++--
 arch/arm/kernel/entry-armv.S   |   14 ++++----------
 arch/arm/kernel/entry-common.S |    8 ++++++--
 arch/arm/mm/fault.c            |    2 +-
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/glue.h b/arch/arm/include/asm/glue.h
index a0e39d5..5bfaf6f 100644
--- a/arch/arm/include/asm/glue.h
+++ b/arch/arm/include/asm/glue.h
@@ -130,7 +130,10 @@
 # ifdef CPU_PABORT_HANDLER
 #  define MULTI_PABORT 1
 # else
-#  define CPU_PABORT_HANDLER(reg, insn)	mrc p15, 0, reg, cr6, cr0, 2
+#  define CPU_PABORT_HANDLER(addr, ifsr, insn) \
+	mrc	p15, 0, addr, c6, c0, 2 ; \
+	mrc	p15, 0, ifsr, c5, c0, 1
+
 # endif
 #endif
 
@@ -138,7 +141,10 @@
 # ifdef CPU_PABORT_HANDLER
 #  define MULTI_PABORT 1
 # else
-#  define CPU_PABORT_HANDLER(reg, insn)	mov reg, insn
+#define __hash_5 #5
+#  define CPU_PABORT_HANDLER(addr, ifsr, insn) \
+	mov	addr, insn ; \
+	mov	ifsr, __hash_5
 # endif
 #endif
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 3d727a8..335ae58 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -303,22 +303,16 @@ __pabt_svc:
 	tst	r3, #PSR_I_BIT
 	biceq	r9, r9, #PSR_I_BIT
 
-	@
-	@ set args, then call main handler
-	@
-	@  r0 - address of faulting instruction
-	@  r1 - pointer to registers on stack
-	@
 #ifdef MULTI_PABORT
 	mov	r0, r2			@ pass address of aborted instruction.
 	ldr	r4, .LCprocfns
 	mov	lr, pc
 	ldr	pc, [r4, #PROCESSOR_PABT_FUNC]
 #else
-	CPU_PABORT_HANDLER(r0, r2)
+	CPU_PABORT_HANDLER(r0, r1, r2)
 #endif
 	msr	cpsr_c, r9			@ Maybe enable interrupts
-	mov	r1, sp				@ regs
+	mov	r2, sp				@ regs
 	bl	do_PrefetchAbort		@ call abort handler
 
 	@
@@ -697,10 +691,10 @@ __pabt_usr:
 	mov	lr, pc
 	ldr	pc, [r4, #PROCESSOR_PABT_FUNC]
 #else
-	CPU_PABORT_HANDLER(r0, r2)
+	CPU_PABORT_HANDLER(r0, r1, r2)
 #endif
 	enable_irq				@ Enable interrupts
-	mov	r1, sp				@ regs
+	mov	r2, sp				@ regs
 	bl	do_PrefetchAbort		@ call abort handler
  UNWIND(.fnend		)
 	/* fall through */
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 807cfeb..931ab9a 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -426,10 +426,14 @@ sys_mmap2:
 ENDPROC(sys_mmap2)
 
 ENTRY(pabort_ifar)
-		mrc	p15, 0, r0, cr6, cr0, 2
-ENTRY(pabort_noifar)
+		mrc	p15, 0, r0, c6, c0, 2		@ get IFAR
+		mrc	p15, 0, r1, c5, c0, 1		@ get IFSR
 		mov	pc, lr
 ENDPROC(pabort_ifar)
+ENTRY(pabort_noifar)
+		/* simulate IFSR with section translation fault status */
+		mov	r1, #5
+		mov	pc, lr
 ENDPROC(pabort_noifar)
 
 #ifdef CONFIG_OABI_COMPAT
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index cc8829d..5e27462 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -506,7 +506,7 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 }
 
 asmlinkage void __exception
-do_PrefetchAbort(unsigned long addr, struct pt_regs *regs)
+do_PrefetchAbort(unsigned long addr, int ifsr, struct pt_regs *regs)
 {
 	do_translation_fault(addr, 0, regs);
 }
-- 
1.6.4.4

