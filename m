Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXLSSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXLSSex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXLSSep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:34:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:6916 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbXLSSeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:34:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,185,1196668800"; 
   d="scan'208";a="243653267"
Date: Wed, 19 Dec 2007 10:34:43 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071219183443.GA547@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Aviod TLB flush IPIs during C3 states by voluntary leave_mm()
before entering C3.

The performance impact of TLB flush on C3 should not be significant with
respect to C3 wakeup latency. Also, CPUs tend to flush TLB in hardware while in
C3 anyways.

On a 8 logical CPU system, running make -j2, the number of tlbflush IPIs goes
down from 40 per second to ~ 0. Total number of interrupts during the run
of this workload was ~1200 per second, which makes it ~3% savings in wakeups.

There was no measurable performance or power impact however.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.24-rc/arch/x86/kernel/smp_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/kernel/smp_64.c
+++ linux-2.6.24-rc/arch/x86/kernel/smp_64.c
@@ -70,7 +70,7 @@ static DEFINE_PER_CPU(union smp_flush_st
  * We cannot call mmdrop() because we are in interrupt context, 
  * instead update mm->cpu_vm_mask.
  */
-static inline void leave_mm(int cpu)
+void leave_mm(int cpu)
 {
 	if (read_pda(mmu_state) == TLBSTATE_OK)
 		BUG();
Index: linux-2.6.24-rc/include/asm-x86/acpi_32.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-x86/acpi_32.h
+++ linux-2.6.24-rc/include/asm-x86/acpi_32.h
@@ -31,6 +31,7 @@
 #include <acpi/pdc_intel.h>
 
 #include <asm/system.h>		/* defines cmpxchg */
+#include <asm/mmu.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -138,6 +139,8 @@ static inline void disable_acpi(void) { 
 
 #define ARCH_HAS_POWER_INIT	1
 
+#define acpi_unlazy_tlb(x)	leave_mm(x)
+
 #endif /*__KERNEL__*/
 
 #endif /*_ASM_ACPI_H*/
Index: linux-2.6.24-rc/include/asm-x86/acpi_64.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-x86/acpi_64.h
+++ linux-2.6.24-rc/include/asm-x86/acpi_64.h
@@ -30,6 +30,7 @@
 
 #include <acpi/pdc_intel.h>
 #include <asm/numa.h>
+#include <asm/mmu.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -148,6 +149,8 @@ static inline void acpi_fake_nodes(const
 }
 #endif
 
+#define acpi_unlazy_tlb(x)	leave_mm(x)
+
 #endif /*__KERNEL__*/
 
 #endif /*_ASM_ACPI_H*/
Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
@@ -530,6 +530,7 @@ static void acpi_processor_idle(void)
 		break;
 
 	case ACPI_STATE_C3:
+		acpi_unlazy_tlb(smp_processor_id());
 		/*
 		 * disable bus master
 		 * bm_check implies we need ARB_DIS
@@ -1485,6 +1486,7 @@ static int acpi_idle_enter_bm(struct cpu
 		return 0;
 	}
 
+	acpi_unlazy_tlb(smp_processor_id());
 	/*
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
Index: linux-2.6.24-rc/include/asm-ia64/acpi.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-ia64/acpi.h
+++ linux-2.6.24-rc/include/asm-ia64/acpi.h
@@ -126,6 +126,8 @@ extern int __devinitdata pxm_to_nid_map[
 extern int __initdata nid_to_pxm_map[MAX_NUMNODES];
 #endif
 
+#define acpi_unlazy_tlb(x)
+
 #endif /*__KERNEL__*/
 
 #endif /*_ASM_ACPI_H*/
Index: linux-2.6.24-rc/include/asm-x86/mmu.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-x86/mmu.h
+++ linux-2.6.24-rc/include/asm-x86/mmu.h
@@ -20,4 +20,6 @@ typedef struct { 
 	void *vdso;
 } mm_context_t;
 
+void leave_mm(int cpu);
+
 #endif /* _ASM_X86_MMU_H */
Index: linux-2.6.24-rc/arch/x86/kernel/smp_32.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/kernel/smp_32.c
+++ linux-2.6.24-rc/arch/x86/kernel/smp_32.c
@@ -256,7 +256,7 @@ static DEFINE_SPINLOCK(tlbstate_lock);
  * We need to reload %cr3 since the page tables may be going
  * away from under us..
  */
-void leave_mm(unsigned long cpu)
+void leave_mm(int cpu)
 {
 	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
 		BUG();
Index: linux-2.6.24-rc/include/asm-x86/mmu_context_32.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-x86/mmu_context_32.h
+++ linux-2.6.24-rc/include/asm-x86/mmu_context_32.h
@@ -32,8 +32,6 @@ static inline void enter_lazy_tlb(struct
 #endif
 }
 
-void leave_mm(unsigned long cpu);
-
 static inline void switch_mm(struct mm_struct *prev,
 			     struct mm_struct *next,
 			     struct task_struct *tsk)
