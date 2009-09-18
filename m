Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZIRKsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZIRKsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 06:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZIRKsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 06:48:08 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44908 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbZIRKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 06:48:07 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
Date: Fri, 18 Sep 2009 16:48:03 +0300
Message-Id: <f00f1348d91d2403ea0f1c5f05b3ac713664fe7b.1253281256.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needed for proper prefetch abort handling on ARMv7.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/include/asm/glue.h  |    4 ++--
 arch/arm/kernel/entry-armv.S |   14 ++++----------
 arch/arm/mm/Makefile         |    2 ++
 arch/arm/mm/fault.c          |    2 +-
 arch/arm/mm/pabort-ifar.S    |   18 ++++++++++++++++++
 arch/arm/mm/pabort-noifar.S  |   18 ++++++++++++++++++
 6 files changed, 45 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/mm/pabort-ifar.S
 create mode 100644 arch/arm/mm/pabort-noifar.S

diff --git a/arch/arm/include/asm/glue.h b/arch/arm/include/asm/glue.h
index a0e39d5..bc6595c 100644
--- a/arch/arm/include/asm/glue.h
+++ b/arch/arm/include/asm/glue.h
@@ -130,7 +130,7 @@
 # ifdef CPU_PABORT_HANDLER
 #  define MULTI_PABORT 1
 # else
-#  define CPU_PABORT_HANDLER(reg, insn)	mrc p15, 0, reg, cr6, cr0, 2
+#  define CPU_PABORT_HANDLER ifar_pabort
 # endif
 #endif
 
@@ -138,7 +138,7 @@
 # ifdef CPU_PABORT_HANDLER
 #  define MULTI_PABORT 1
 # else
-#  define CPU_PABORT_HANDLER(reg, insn)	mov reg, insn
+#  define CPU_PABORT_HANDLER noifar_pabort
 # endif
 #endif
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 85040cf..dbb4ce7 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -291,22 +291,16 @@ __pabt_svc:
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
+	bl	CPU_PABORT_HANDLER
 #endif
 	msr	cpsr_c, r9			@ Maybe enable interrupts
-	mov	r1, sp				@ regs
+	mov	r2, sp				@ regs
 	bl	do_PrefetchAbort		@ call abort handler
 
 	@
@@ -666,10 +660,10 @@ __pabt_usr:
 	mov	lr, pc
 	ldr	pc, [r4, #PROCESSOR_PABT_FUNC]
 #else
-	CPU_PABORT_HANDLER(r0, r2)
+	bl	CPU_PABORT_HANDLER
 #endif
 	enable_irq				@ Enable interrupts
-	mov	r1, sp				@ regs
+	mov	r2, sp				@ regs
 	bl	do_PrefetchAbort		@ call abort handler
 	/* fall through */
 /*
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 480f78a..30f1708 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -78,3 +78,5 @@ obj-$(CONFIG_CACHE_FEROCEON_L2)	+= cache-feroceon-l2.o
 obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
 obj-$(CONFIG_CACHE_XSC3L2)	+= cache-xsc3l2.o
 
+obj-$(CONFIG_CPU_PABRT_NOIFAR)	+= pabort-noifar.o
+obj-$(CONFIG_CPU_PABRT_IFAR)	+= pabort-ifar.o
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 22c9530..c7bbb32 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -480,7 +480,7 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 }
 
 asmlinkage void __exception
-do_PrefetchAbort(unsigned long addr, struct pt_regs *regs)
+do_PrefetchAbort(unsigned long addr, int ifsr, struct pt_regs *regs)
 {
 	do_translation_fault(addr, 0, regs);
 }
diff --git a/arch/arm/mm/pabort-ifar.S b/arch/arm/mm/pabort-ifar.S
new file mode 100644
index 0000000..46838ea
--- /dev/null
+++ b/arch/arm/mm/pabort-ifar.S
@@ -0,0 +1,18 @@
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Function: ifar_pabort
+ *
+ * Returns : r0 = address of abort
+ *	   : r1 = IFSR
+ *
+ * Purpose : obtain information about current prefetch abort.
+ */
+	.align	5
+ENTRY(ifar_pabort)
+	mrc	p15, 0, r0, c6, c0, 2		@ get IFAR
+	mrc	p15, 0, r1, c5, c0, 1		@ get IFSR
+
+	mov	pc, lr
+ENDPROC(ifar_pabort)
diff --git a/arch/arm/mm/pabort-noifar.S b/arch/arm/mm/pabort-noifar.S
new file mode 100644
index 0000000..46b0daf
--- /dev/null
+++ b/arch/arm/mm/pabort-noifar.S
@@ -0,0 +1,18 @@
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Function: noifar_pabort
+
+ * Returns : r0 = address of abort
+ *	   : r1 = 5, simulate IFSR with section translation fault status
+ *
+ * Purpose : obtain information about current prefetch abort.
+ */
+	.align	5
+ENTRY(noifar_pabort)
+	mov	r0, insn
+	mov	r1, #5		@ translation fault
+
+	mov	pc, lr
+ENDPROC(noifar_pabort)
-- 
1.6.4.4

