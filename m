Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXDFTyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXDFTyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXDFTxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:53:52 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47671 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932659AbXDFTxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:53:45 -0400
Date: Fri, 6 Apr 2007 12:51:42 -0700
Message-Id: <200704061951.l36JpgLu008384@zach-dev.vmware.com>
Subject: [PATCH 2/3] Backout the 2.6.21 lazy mode fix
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
Subject: Backout the 2.6.21 lazy mode fix
X-OriginalArrivalTime: 06 Apr 2007 19:53:43.0710 (UTC) FILETIME=[47FD13E0:01C77885]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the last patch; it is only for 2.6.21, and an updated version will
be merged for 2.6.22.  Do this before applying other i386 paravirt-ops
patches to avoid merge conflicts caused by code movement and cleanup.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 88bdf8174a2d arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Fri Apr 06 12:29:33 2007 -0700
+++ b/arch/i386/kernel/vmi.c	Fri Apr 06 12:30:11 2007 -0700
@@ -69,7 +69,6 @@ struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
-  	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -575,26 +574,6 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
-static void vmi_set_lazy_mode(int mode)
-{
-	static DEFINE_PER_CPU(int, lazy_mode);
-
-	if (!vmi_ops.set_lazy_mode)
-		return;
-
-	/* Modes should never nest or overlap */
-	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
-					     mode == PARAVIRT_LAZY_FLUSH));
-	
-	if (mode == PARAVIRT_LAZY_FLUSH) {
-		vmi_ops.set_lazy_mode(0);
-		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
-	} else {
-		vmi_ops.set_lazy_mode(mode);
-		__get_cpu_var(lazy_mode) = mode;
-	}
-}
-
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -825,7 +804,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
+	para_fill(set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
diff -r 88bdf8174a2d arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c	Fri Apr 06 12:29:33 2007 -0700
+++ b/arch/i386/mm/highmem.c	Fri Apr 06 12:30:11 2007 -0700
@@ -42,7 +42,6 @@ void *kmap_atomic(struct page *page, enu
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
@@ -83,7 +82,6 @@ void *kmap_atomic_pfn(unsigned long pfn,
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
diff -r 88bdf8174a2d include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h	Fri Apr 06 12:29:33 2007 -0700
+++ b/include/asm-generic/pgtable.h	Fri Apr 06 12:30:11 2007 -0700
@@ -180,7 +180,6 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
 /*
@@ -194,7 +193,6 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode()	do {} while (0)
 #define arch_leave_lazy_cpu_mode()	do {} while (0)
-#define arch_flush_lazy_cpu_mode()	do {} while (0)
 #endif
 
 /*
diff -r 88bdf8174a2d include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Fri Apr 06 12:29:33 2007 -0700
+++ b/include/asm-i386/paravirt.h	Fri Apr 06 12:30:11 2007 -0700
@@ -421,17 +421,14 @@ static inline void pmd_clear(pmd_t *pmdp
 #define PARAVIRT_LAZY_NONE 0
 #define PARAVIRT_LAZY_MMU  1
 #define PARAVIRT_LAZY_CPU  2
-#define PARAVIRT_LAZY_FLUSH 3
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
 #define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
-#define arch_flush_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
-#define arch_flush_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
