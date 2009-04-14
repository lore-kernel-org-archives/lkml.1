Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZDNPyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZDNPyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZDNPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:52 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45988 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378AbZDNPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:47 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 07/14] [VOYAGER] x86: eliminate subarchitecture file entry_arch.h
Date: Tue, 14 Apr 2009 10:51:33 -0500
Message-Id: <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was a subarchitecture file designed to customise the vector gate
building functions.  Since only voyager and the standard PC
subarchitectures now have a copy, they can both be merged into
entry_32.S surrounded by the appropriate ifdefs.

As part of this reorganisation, split the voyager interrupt vectors
out into a separate include file (asm/voyager_vectors.h) that can be
included into a .S file rather than hacking voyager.h up to include
the appropriate _ASSEMBLY_ gates.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/entry_arch.h              |   59 -------------------
 arch/x86/include/asm/hw_irq.h                  |   11 ++++
 arch/x86/include/asm/mach-voyager/entry_arch.h |   26 ---------
 arch/x86/include/asm/voyager.h                 |   34 +-----------
 arch/x86/include/asm/voyager_vectors.h         |   37 ++++++++++++
 arch/x86/kernel/entry_32.S                     |   72 +++++++++++++++++++++++-
 6 files changed, 119 insertions(+), 120 deletions(-)
 delete mode 100644 arch/x86/include/asm/entry_arch.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/entry_arch.h
 create mode 100644 arch/x86/include/asm/voyager_vectors.h

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
deleted file mode 100644
index c2e6bed..0000000
--- a/arch/x86/include/asm/entry_arch.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * This file is designed to contain the BUILD_INTERRUPT specifications for
- * all of the extra named interrupt vectors used by the architecture.
- * Usually this is the Inter Process Interrupts (IPIs)
- */
-
-/*
- * The following vectors are part of the Linux architecture, there
- * is no hardware IRQ pin equivalent for them, they are triggered
- * through the ICC by us (IPIs)
- */
-#ifdef CONFIG_SMP
-BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
-BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
-BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
-BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
-
-BUILD_INTERRUPT3(invalidate_interrupt0,INVALIDATE_TLB_VECTOR_START+0,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt1,INVALIDATE_TLB_VECTOR_START+1,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt2,INVALIDATE_TLB_VECTOR_START+2,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt3,INVALIDATE_TLB_VECTOR_START+3,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt4,INVALIDATE_TLB_VECTOR_START+4,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt5,INVALIDATE_TLB_VECTOR_START+5,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt6,INVALIDATE_TLB_VECTOR_START+6,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt7,INVALIDATE_TLB_VECTOR_START+7,
-		 smp_invalidate_interrupt)
-#endif
-
-BUILD_INTERRUPT(generic_interrupt, GENERIC_INTERRUPT_VECTOR)
-
-/*
- * every pentium local APIC has two 'local interrupts', with a
- * soft-definable vector attached to both interrupts, one of
- * which is a timer interrupt, the other one is error counter
- * overflow. Linux uses the local APIC timer interrupt to get
- * a much simpler SMP time architecture:
- */
-#ifdef CONFIG_X86_LOCAL_APIC
-
-BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
-BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
-BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
-
-#ifdef CONFIG_PERF_COUNTERS
-BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
-#endif
-
-#ifdef CONFIG_X86_MCE_P4THERMAL
-BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
-#endif
-
-#endif
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b762ea4..fff91c3 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -75,6 +75,17 @@ extern atomic_t irq_mis_count;
 /* EISA */
 extern void eisa_set_level_irq(unsigned int irq);
 
+/* Voyager functions */
+extern asmlinkage void vic_cpi_interrupt(void);
+extern asmlinkage void vic_sys_interrupt(void);
+extern asmlinkage void vic_cmn_interrupt(void);
+extern asmlinkage void qic_timer_interrupt(void);
+extern asmlinkage void qic_invalidate_interrupt(void);
+extern asmlinkage void qic_reschedule_interrupt(void);
+extern asmlinkage void qic_enable_irq_interrupt(void);
+extern asmlinkage void qic_call_function_interrupt(void);
+extern asmlinkage void qic_call_function_single_interrupt(void);
+
 /* SMP */
 extern void smp_apic_timer_interrupt(struct pt_regs *);
 extern void smp_spurious_interrupt(struct pt_regs *);
diff --git a/arch/x86/include/asm/mach-voyager/entry_arch.h b/arch/x86/include/asm/mach-voyager/entry_arch.h
deleted file mode 100644
index ae52624..0000000
--- a/arch/x86/include/asm/mach-voyager/entry_arch.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8 -*- */
-
-/* Copyright (C) 2002
- *
- * Author: James.Bottomley@HansenPartnership.com
- *
- * linux/arch/i386/voyager/entry_arch.h
- *
- * This file builds the VIC and QIC CPI gates
- */
-
-/* initialise the voyager interrupt gates 
- *
- * This uses the macros in irq.h to set up assembly jump gates.  The
- * calls are then redirected to the same routine with smp_ prefixed */
-BUILD_INTERRUPT(vic_sys_interrupt, VIC_SYS_INT)
-BUILD_INTERRUPT(vic_cmn_interrupt, VIC_CMN_INT)
-BUILD_INTERRUPT(vic_cpi_interrupt, VIC_CPI_LEVEL0);
-
-/* do all the QIC interrupts */
-BUILD_INTERRUPT(qic_timer_interrupt, QIC_TIMER_CPI);
-BUILD_INTERRUPT(qic_invalidate_interrupt, QIC_INVALIDATE_CPI);
-BUILD_INTERRUPT(qic_reschedule_interrupt, QIC_RESCHEDULE_CPI);
-BUILD_INTERRUPT(qic_enable_irq_interrupt, QIC_ENABLE_IRQ_CPI);
-BUILD_INTERRUPT(qic_call_function_interrupt, QIC_CALL_FUNCTION_CPI);
-BUILD_INTERRUPT(qic_call_function_single_interrupt, QIC_CALL_FUNCTION_SINGLE_CPI);
diff --git a/arch/x86/include/asm/voyager.h b/arch/x86/include/asm/voyager.h
index 04fd0c9..c03a6aa 100644
--- a/arch/x86/include/asm/voyager.h
+++ b/arch/x86/include/asm/voyager.h
@@ -6,6 +6,7 @@
 
 #include <asm/voyager_bios.h>
 #include <asm/voyager_boot.h>
+#include <asm/voyager_vectors.h>
 
 #undef	VOYAGER_DEBUG
 #undef	VOYAGER_CAT_DEBUG
@@ -521,39 +522,6 @@ extern void voyager_smp_intr_init(void);
 #define VOYAGER_PSI_SUBWRITE	3
 extern void voyager_cat_psi(__u8, __u16, __u8 *);
 
-/* These define the CPIs we use in linux */
-#define VIC_CPI_LEVEL0			0
-#define VIC_CPI_LEVEL1			1
-/* now the fake CPIs */
-#define VIC_TIMER_CPI			2
-#define VIC_INVALIDATE_CPI		3
-#define VIC_RESCHEDULE_CPI		4
-#define VIC_ENABLE_IRQ_CPI		5
-#define VIC_CALL_FUNCTION_CPI		6
-#define VIC_CALL_FUNCTION_SINGLE_CPI	7
-
-/* Now the QIC CPIs:  Since we don't need the two initial levels,
- * these are 2 less than the VIC CPIs */
-#define QIC_CPI_OFFSET			1
-#define QIC_TIMER_CPI			(VIC_TIMER_CPI - QIC_CPI_OFFSET)
-#define QIC_INVALIDATE_CPI		(VIC_INVALIDATE_CPI - QIC_CPI_OFFSET)
-#define QIC_RESCHEDULE_CPI		(VIC_RESCHEDULE_CPI - QIC_CPI_OFFSET)
-#define QIC_ENABLE_IRQ_CPI		(VIC_ENABLE_IRQ_CPI - QIC_CPI_OFFSET)
-#define QIC_CALL_FUNCTION_CPI		(VIC_CALL_FUNCTION_CPI - QIC_CPI_OFFSET)
-#define QIC_CALL_FUNCTION_SINGLE_CPI	(VIC_CALL_FUNCTION_SINGLE_CPI - QIC_CPI_OFFSET)
-
-#define VIC_START_FAKE_CPI		VIC_TIMER_CPI
-#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_SINGLE_CPI
-
-/* this is the SYS_INT CPI. */
-#define VIC_SYS_INT			8
-#define VIC_CMN_INT			15
-
-/* This is the boot CPI for alternate processors.  It gets overwritten
- * by the above once the system has activated all available processors */
-#define VIC_CPU_BOOT_CPI		VIC_CPI_LEVEL0
-#define VIC_CPU_BOOT_ERRATA_CPI		(VIC_CPI_LEVEL0 + 8)
-
 extern asmlinkage void vic_cpi_interrupt(void);
 extern asmlinkage void vic_sys_interrupt(void);
 extern asmlinkage void vic_cmn_interrupt(void);
diff --git a/arch/x86/include/asm/voyager_vectors.h b/arch/x86/include/asm/voyager_vectors.h
new file mode 100644
index 0000000..bd6c87b
--- /dev/null
+++ b/arch/x86/include/asm/voyager_vectors.h
@@ -0,0 +1,37 @@
+#ifndef _ASM_VOYAGER_VECTORS_H
+#define _ASM_VOYAGER_VECTORS_H
+
+/* These define the CPIs we use in linux */
+#define VIC_CPI_LEVEL0			0
+#define VIC_CPI_LEVEL1			1
+/* now the fake CPIs */
+#define VIC_TIMER_CPI			2
+#define VIC_INVALIDATE_CPI		3
+#define VIC_RESCHEDULE_CPI		4
+#define VIC_ENABLE_IRQ_CPI		5
+#define VIC_CALL_FUNCTION_CPI		6
+#define VIC_CALL_FUNCTION_SINGLE_CPI	7
+
+/* Now the QIC CPIs:  Since we don't need the two initial levels,
+ * these are 2 less than the VIC CPIs */
+#define QIC_CPI_OFFSET			1
+#define QIC_TIMER_CPI			(VIC_TIMER_CPI - QIC_CPI_OFFSET)
+#define QIC_INVALIDATE_CPI		(VIC_INVALIDATE_CPI - QIC_CPI_OFFSET)
+#define QIC_RESCHEDULE_CPI		(VIC_RESCHEDULE_CPI - QIC_CPI_OFFSET)
+#define QIC_ENABLE_IRQ_CPI		(VIC_ENABLE_IRQ_CPI - QIC_CPI_OFFSET)
+#define QIC_CALL_FUNCTION_CPI		(VIC_CALL_FUNCTION_CPI - QIC_CPI_OFFSET)
+#define QIC_CALL_FUNCTION_SINGLE_CPI	(VIC_CALL_FUNCTION_SINGLE_CPI - QIC_CPI_OFFSET)
+
+#define VIC_START_FAKE_CPI		VIC_TIMER_CPI
+#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_SINGLE_CPI
+
+/* this is the SYS_INT CPI. */
+#define VIC_SYS_INT			8
+#define VIC_CMN_INT			15
+
+/* This is the boot CPI for alternate processors.  It gets overwritten
+ * by the above once the system has activated all available processors */
+#define VIC_CPU_BOOT_CPI		VIC_CPI_LEVEL0
+#define VIC_CPU_BOOT_ERRATA_CPI		(VIC_CPI_LEVEL0 + 8)
+
+#endif
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c929add..f87439e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -54,6 +54,7 @@
 #include <asm/processor-flags.h>
 #include <asm/ftrace.h>
 #include <asm/irq_vectors.h>
+#include <asm/voyager_vectors.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -809,8 +810,75 @@ ENDPROC(name)
 
 #define BUILD_INTERRUPT(name, nr)	BUILD_INTERRUPT3(name, nr, smp_##name)
 
-/* The include is where all of the SMP etc. interrupts come from */
-#include <asm/entry_arch.h>
+/*
+ * The following vectors are part of the Linux architecture, there
+ * is no hardware IRQ pin equivalent for them, they are triggered
+ * through the ICC by us (IPIs)
+ */
+#ifdef CONFIG_SMP
+BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
+BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
+BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
+BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
+
+BUILD_INTERRUPT3(invalidate_interrupt0,INVALIDATE_TLB_VECTOR_START+0,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt1,INVALIDATE_TLB_VECTOR_START+1,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt2,INVALIDATE_TLB_VECTOR_START+2,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt3,INVALIDATE_TLB_VECTOR_START+3,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt4,INVALIDATE_TLB_VECTOR_START+4,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt5,INVALIDATE_TLB_VECTOR_START+5,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt6,INVALIDATE_TLB_VECTOR_START+6,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt7,INVALIDATE_TLB_VECTOR_START+7,
+		 smp_invalidate_interrupt)
+#endif
+
+BUILD_INTERRUPT(generic_interrupt, GENERIC_INTERRUPT_VECTOR)
+
+/*
+ * every pentium local APIC has two 'local interrupts', with a
+ * soft-definable vector attached to both interrupts, one of
+ * which is a timer interrupt, the other one is error counter
+ * overflow. Linux uses the local APIC timer interrupt to get
+ * a much simpler SMP time architecture:
+ */
+#ifdef CONFIG_X86_LOCAL_APIC
+
+BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
+BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
+BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
+
+#ifdef CONFIG_PERF_COUNTERS
+BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
+#endif
+
+#ifdef CONFIG_X86_MCE_P4THERMAL
+BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
+#endif
+
+#if defined(CONFIG_X86_VOYAGER) && defined(CONFIG_SMP)
+BUILD_INTERRUPT(vic_sys_interrupt, VIC_SYS_INT)
+BUILD_INTERRUPT(vic_cmn_interrupt, VIC_CMN_INT)
+BUILD_INTERRUPT(vic_cpi_interrupt, VIC_CPI_LEVEL0);
+
+/* do all the QIC interrupts */
+BUILD_INTERRUPT(qic_timer_interrupt, QIC_TIMER_CPI);
+BUILD_INTERRUPT(qic_invalidate_interrupt, QIC_INVALIDATE_CPI);
+BUILD_INTERRUPT(qic_reschedule_interrupt, QIC_RESCHEDULE_CPI);
+BUILD_INTERRUPT(qic_enable_irq_interrupt, QIC_ENABLE_IRQ_CPI);
+BUILD_INTERRUPT(qic_call_function_interrupt, QIC_CALL_FUNCTION_CPI);
+BUILD_INTERRUPT(qic_call_function_single_interrupt,
+		 QIC_CALL_FUNCTION_SINGLE_CPI);
+#endif
+
+#endif
+
 
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
-- 
1.6.2.1

