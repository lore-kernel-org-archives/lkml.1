Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXDFTxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXDFTxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXDFTxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:53:48 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47669 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932516AbXDFTxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:53:45 -0400
Date: Fri, 6 Apr 2007 12:51:41 -0700
Message-Id: <200704061951.l36JpfeP008378@zach-dev.vmware.com>
Subject: [PATCH 1/3] Proper fix for highmem kmap_atomic functions for VMI for 2.6.21
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
Subject: Proper fix for highmem kmap_atomic functions for VMI for 2.6.21
X-OriginalArrivalTime: 06 Apr 2007 19:53:43.0585 (UTC) FILETIME=[47EA0110:01C77885]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since lazy MMU batching mode still allows interrupts to enter, it is possible
for interrupt handlers to try to use kmap_atomic, which fails when lazy mode
is active, since the PTE update to highmem will be delayed.  The best
workaround is to issue an explicit flush in kmap_atomic_functions case; this is
the only way nested PTE updates can happen in the interrupt handler.

This patch applies to Linus' 2.6 git tree and is intended for 2.6.21.
It should be applied ahead of any paravirt-ops changes in the -mm tree.
It must be reverted before applying the rest of the paravirt-ops queue
for 2.6.22, as it causes conflicts.  An updated patch will be re-merged
after the queue.

Thanks to Jeremy Fitzhardinge for noting the bug and suggestions on a fix.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r be8c61492e28 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Fri Mar 30 14:13:45 2007 -0700
+++ b/arch/i386/kernel/vmi.c	Fri Apr 06 11:46:13 2007 -0700
@@ -69,6 +69,7 @@ struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
+  	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -574,6 +575,26 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
+static void vmi_set_lazy_mode(int mode)
+{
+	static DEFINE_PER_CPU(int, lazy_mode);
+
+	if (!vmi_ops.set_lazy_mode)
+		return;
+
+	/* Modes should never nest or overlap */
+	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
+					     mode == PARAVIRT_LAZY_FLUSH));
+	
+	if (mode == PARAVIRT_LAZY_FLUSH) {
+		vmi_ops.set_lazy_mode(0);
+		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
+	} else {
+		vmi_ops.set_lazy_mode(mode);
+		__get_cpu_var(lazy_mode) = mode;
+	}
+}
+
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -804,7 +825,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
diff -r be8c61492e28 arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c	Fri Mar 30 14:13:45 2007 -0700
+++ b/arch/i386/mm/highmem.c	Thu Apr 05 18:12:15 2007 -0700
@@ -42,6 +42,7 @@ void *kmap_atomic(struct page *page, enu
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
@@ -82,6 +83,7 @@ void *kmap_atomic_pfn(unsigned long pfn,
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
diff -r be8c61492e28 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h	Fri Mar 30 14:13:45 2007 -0700
+++ b/include/asm-generic/pgtable.h	Thu Apr 05 18:11:18 2007 -0700
@@ -180,6 +180,7 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
 /*
@@ -193,6 +194,7 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode()	do {} while (0)
 #define arch_leave_lazy_cpu_mode()	do {} while (0)
+#define arch_flush_lazy_cpu_mode()	do {} while (0)
 #endif
 
 /*
diff -r be8c61492e28 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Fri Mar 30 14:13:45 2007 -0700
+++ b/include/asm-i386/paravirt.h	Fri Apr 06 11:38:45 2007 -0700
@@ -421,14 +421,17 @@ static inline void pmd_clear(pmd_t *pmdp
 #define PARAVIRT_LAZY_NONE 0
 #define PARAVIRT_LAZY_MMU  1
 #define PARAVIRT_LAZY_CPU  2
+#define PARAVIRT_LAZY_FLUSH 3
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
 #define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_flush_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_flush_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
