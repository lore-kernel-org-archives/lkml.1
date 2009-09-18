Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZIRL2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZIRL2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZIRL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:28:55 -0400
Received: from smtp.nokia.com ([192.100.122.230]:21568 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbZIRL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:28:54 -0400
Date: Fri, 18 Sep 2009 14:28:36 +0300 (EEST)
From: Aaro Koskinen <aakoskin@nokia.com>
X-X-Sender: aakoskin@ak-desktop
To: "ext Kirill A. Shutemov" <kirill@shutemov.name>
cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
In-Reply-To: <f00f1348d91d2403ea0f1c5f05b3ac713664fe7b.1253281256.git.kirill@shutemov.name>
Message-ID: <alpine.DEB.1.00.0909181422370.11448@ak-desktop>
References: <f00f1348d91d2403ea0f1c5f05b3ac713664fe7b.1253281256.git.kirill@shutemov.name>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 18 Sep 2009 11:28:42.0935 (UTC) FILETIME=[2D71BC70:01CA3853]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, ext Kirill A. Shutemov wrote:

> It needed for proper prefetch abort handling on ARMv7.

Here's what I had in mind:

---
  arch/arm/include/asm/glue.h    |   24 ++++++++++++++++++------
  arch/arm/kernel/entry-armv.S   |   10 ++++++----
  arch/arm/kernel/entry-common.S |    1 +
  arch/arm/mm/Kconfig            |    9 ++++++---
  arch/arm/mm/Makefile           |    2 ++
  arch/arm/mm/fault.c            |   20 ++++++++++++++++++--
  arch/arm/mm/pabort-noifsr.S    |   16 ++++++++++++++++
  arch/arm/mm/proc-arm940.S      |    2 +-
  arch/arm/mm/proc-arm946.S      |    2 +-
  arch/arm/mm/proc-arm9tdmi.S    |    2 +-
  10 files changed, 70 insertions(+), 18 deletions(-)
  create mode 100644 arch/arm/mm/pabort-noifsr.S

diff --git a/arch/arm/include/asm/glue.h b/arch/arm/include/asm/glue.h
index a0e39d5..1427fef 100644
--- a/arch/arm/include/asm/glue.h
+++ b/arch/arm/include/asm/glue.h
@@ -123,26 +123,38 @@
   * Prefetch abort handler.  If the CPU has an IFAR use that, otherwise
   * use the address of the aborted instruction
   */
-#undef CPU_PABORT_HANDLER
+#undef CPU_PABORT_HANDLER_IFAR
+#undef CPU_PABORT_HANDLER_IFSR
  #undef MULTI_PABORT

  #ifdef CONFIG_CPU_PABRT_IFAR
-# ifdef CPU_PABORT_HANDLER
+# ifdef CPU_PABORT_HANDLER_IFAR
  #  define MULTI_PABORT 1
  # else
-#  define CPU_PABORT_HANDLER(reg, insn)	mrc p15, 0, reg, cr6, cr0, 2
+#  define CPU_PABORT_HANDLER_IFAR(reg, insn)	mrc p15, 0, reg, cr6, cr0, 2
+#  define CPU_PABORT_HANDLER_IFSR(reg)		mrc p15, 0, reg, cr5, cr0, 1
  # endif
  #endif

  #ifdef CONFIG_CPU_PABRT_NOIFAR
-# ifdef CPU_PABORT_HANDLER
+# ifdef CPU_PABORT_HANDLER_IFAR
  #  define MULTI_PABORT 1
  # else
-#  define CPU_PABORT_HANDLER(reg, insn)	mov reg, insn
+#  define CPU_PABORT_HANDLER_IFAR(reg, insn)	mov reg, insn
+#  define CPU_PABORT_HANDLER_IFSR(reg)		mrc p15, 0, reg, cr5, cr0, 1
  # endif
  #endif

-#ifndef CPU_PABORT_HANDLER
+#ifdef CONFIG_CPU_PABRT_NOIFSR
+# ifdef CPU_PABORT_HANDLER_IFAR
+#  define MULTI_PABORT 1
+# else
+#  define CPU_PABORT_HANDLER_IFAR(reg, insn)	mov reg, insn
+#  define CPU_PABORT_HANDLER_IFSR(reg)		mov reg, #0
+# endif
+#endif
+
+#if !defined(CPU_PABORT_HANDLER_IFAR) || !defined(CPU_PABORT_HANDLER_IFSR)
  #error Unknown prefetch abort handler type
  #endif

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 3d727a8..e252d32 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -315,10 +315,11 @@ __pabt_svc:
  	mov	lr, pc
  	ldr	pc, [r4, #PROCESSOR_PABT_FUNC]
  #else
-	CPU_PABORT_HANDLER(r0, r2)
+	CPU_PABORT_HANDLER_IFAR(r0, r2)
+	CPU_PABORT_HANDLER_IFSR(r1)
  #endif
  	msr	cpsr_c, r9			@ Maybe enable interrupts
-	mov	r1, sp				@ regs
+	mov	r2, sp				@ regs
  	bl	do_PrefetchAbort		@ call abort handler

  	@
@@ -697,10 +698,11 @@ __pabt_usr:
  	mov	lr, pc
  	ldr	pc, [r4, #PROCESSOR_PABT_FUNC]
  #else
-	CPU_PABORT_HANDLER(r0, r2)
+	CPU_PABORT_HANDLER_IFAR(r0, r2)
+	CPU_PABORT_HANDLER_IFSR(r1)
  #endif
  	enable_irq				@ Enable interrupts
-	mov	r1, sp				@ regs
+	mov	r2, sp				@ regs
  	bl	do_PrefetchAbort		@ call abort handler
   UNWIND(.fnend		)
  	/* fall through */
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 807cfeb..254465d 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -428,6 +428,7 @@ ENDPROC(sys_mmap2)
  ENTRY(pabort_ifar)
  		mrc	p15, 0, r0, cr6, cr0, 2
  ENTRY(pabort_noifar)
+		mrc     p15, 0, r1, cr5, cr0, 1           @ fsr
  		mov	pc, lr
  ENDPROC(pabort_ifar)
  ENDPROC(pabort_noifar)
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 5fe595a..d0ee034 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -100,7 +100,7 @@ config CPU_ARM9TDMI
  	depends on !MMU
  	select CPU_32v4T
  	select CPU_ABRT_NOMMU
-	select CPU_PABRT_NOIFAR
+	select CPU_PABRT_NOIFSR
  	select CPU_CACHE_V4
  	help
  	  A 32-bit RISC microprocessor based on the ARM9 processor core
@@ -210,7 +210,7 @@ config CPU_ARM940T
  	depends on !MMU
  	select CPU_32v4T
  	select CPU_ABRT_NOMMU
-	select CPU_PABRT_NOIFAR
+	select CPU_PABRT_NOIFSR
  	select CPU_CACHE_VIVT
  	select CPU_CP15_MPU
  	help
@@ -228,7 +228,7 @@ config CPU_ARM946E
  	depends on !MMU
  	select CPU_32v5
  	select CPU_ABRT_NOMMU
-	select CPU_PABRT_NOIFAR
+	select CPU_PABRT_NOIFSR
  	select CPU_CACHE_VIVT
  	select CPU_CP15_MPU
  	help
@@ -488,6 +488,9 @@ config CPU_PABRT_IFAR
  config CPU_PABRT_NOIFAR
  	bool

+config CPU_PABRT_NOIFSR
+	bool
+
  # The cache model
  config CPU_CACHE_V3
  	bool
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 63e3f6d..5c1062d 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -27,6 +27,8 @@ obj-$(CONFIG_CPU_ABRT_EV5TJ)	+= abort-ev5tj.o
  obj-$(CONFIG_CPU_ABRT_EV6)	+= abort-ev6.o
  obj-$(CONFIG_CPU_ABRT_EV7)	+= abort-ev7.o

+obj-$(CONFIG_CPU_PABRT_NOIFSR)	+= pabort-noifsr.o
+
  obj-$(CONFIG_CPU_CACHE_V3)	+= cache-v3.o
  obj-$(CONFIG_CPU_CACHE_V4)	+= cache-v4.o
  obj-$(CONFIG_CPU_CACHE_V4WT)	+= cache-v4wt.o
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index cc8829d..70fdd66 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -506,8 +506,24 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
  }

  asmlinkage void __exception
-do_PrefetchAbort(unsigned long addr, struct pt_regs *regs)
+do_PrefetchAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
  {
-	do_translation_fault(addr, 0, regs);
+	struct siginfo info;
+
+	switch (fsr & 15) {
+	case 5:
+	case 7:
+		do_translation_fault(addr, fsr, regs);
+		break;
+	default:
+		printk(KERN_ALERT "Prefetch abort: 0x%03x at %08lx\n",
+		       fsr, addr);
+	case 15:
+		info.si_signo = SIGSEGV;
+		info.si_errno = 0;
+		info.si_code  = SEGV_ACCERR;
+		info.si_addr  = (void __user *)addr;
+		arm_notify_die("", regs, &info, fsr, 0);
+	}
  }

diff --git a/arch/arm/mm/pabort-noifsr.S b/arch/arm/mm/pabort-noifsr.S
new file mode 100644
index 0000000..4abd848
--- /dev/null
+++ b/arch/arm/mm/pabort-noifsr.S
@@ -0,0 +1,16 @@
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+/*
+ * Function: pabort_noifsr
+ *
+ * Params  : r0 = address of aborted instruction
+ *
+ * Returns : r0 = r0 (abort address)
+ *	   : r1 = 0 (FSR)
+ *
+ */
+	.align	5
+ENTRY(pabort_noifsr)
+	mov	r1, #0
+	mov	pc, lr
+ENDPROC(pabort_noifsr)
diff --git a/arch/arm/mm/proc-arm940.S b/arch/arm/mm/proc-arm940.S
index f595117..5684581 100644
--- a/arch/arm/mm/proc-arm940.S
+++ b/arch/arm/mm/proc-arm940.S
@@ -322,7 +322,7 @@ __arm940_setup:
  	.type	arm940_processor_functions, #object
  ENTRY(arm940_processor_functions)
  	.word	nommu_early_abort
-	.word	pabort_noifar
+	.word	pabort_noifsr
  	.word	cpu_arm940_proc_init
  	.word	cpu_arm940_proc_fin
  	.word	cpu_arm940_reset
diff --git a/arch/arm/mm/proc-arm946.S b/arch/arm/mm/proc-arm946.S
index e03f6ff..f82c7fe 100644
--- a/arch/arm/mm/proc-arm946.S
+++ b/arch/arm/mm/proc-arm946.S
@@ -377,7 +377,7 @@ __arm946_setup:
  	.type	arm946_processor_functions, #object
  ENTRY(arm946_processor_functions)
  	.word	nommu_early_abort
-	.word	pabort_noifar
+	.word	pabort_noifsr
  	.word	cpu_arm946_proc_init
  	.word	cpu_arm946_proc_fin
  	.word	cpu_arm946_reset
diff --git a/arch/arm/mm/proc-arm9tdmi.S b/arch/arm/mm/proc-arm9tdmi.S
index be6c11d..db42c52 100644
--- a/arch/arm/mm/proc-arm9tdmi.S
+++ b/arch/arm/mm/proc-arm9tdmi.S
@@ -64,7 +64,7 @@ __arm9tdmi_setup:
  		.type	arm9tdmi_processor_functions, #object
  ENTRY(arm9tdmi_processor_functions)
  		.word	nommu_early_abort
-		.word	pabort_noifar
+		.word	pabort_noifsr
  		.word	cpu_arm9tdmi_proc_init
  		.word	cpu_arm9tdmi_proc_fin
  		.word	cpu_arm9tdmi_reset
-- 
1.5.4.3

