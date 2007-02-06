Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbXBFDyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbXBFDyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXBFDx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:53:57 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40408 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752681AbXBFDxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:53:39 -0500
Date: Mon, 5 Feb 2007 19:53:37 -0800
Message-Id: <200702060353.l163rbg0000777@zach-dev.vmware.com>
Subject: [PATCH 10/11] Vmi fix highpte
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:53:37.0768 (UTC) FILETIME=[61CCA680:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a PT map hook for HIGHPTE kernels to designate where they are mapping
page tables.  This information is required so the physical address of PTE
updates can be determined; otherwise, the mm layer would have to carry the
physical address all the way to each PTE modification callsite, which is
even more hideous that the macros required to provide the proper hooks.

So lets not mess up arch neutral code to achieve this, but keep the horror
in an #ifdef HIGHPTE in include/asm-i386/pgtable.h.  I had to use macros
here because some types are not yet defined in all the include paths for
this header.

If anyone can find a cleaner way to do this, please implement it and I will
mail you a beer.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 08dce48f1a50 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Fri Feb 02 16:31:59 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Fri Feb 02 17:19:34 2007 -0800
@@ -556,6 +556,8 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
 
+	.map_pt_hook = (void *)native_nop,
+
 	.alloc_pt = (void *)native_nop,
 	.alloc_pd = (void *)native_nop,
 	.alloc_pd_clone = (void *)native_nop,
diff -r 08dce48f1a50 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Fri Feb 02 16:31:59 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Fri Feb 02 17:28:53 2007 -0800
@@ -372,6 +372,26 @@ static void vmi_check_page_type(u32 pfn,
 #define vmi_check_page_type(p,t) do { } while (0)
 #endif
 
+static void vmi_map_pt_hook(u32 slot, pte_t *va, u32 pfn)
+{
+	/*
+	 * Internally, the VMI ROM must map virtual addresses to physical
+	 * addresses for processing MMU updates.  By the time MMU updates
+	 * are issued, this information is typically already lost.
+	 * Fortunately, the VMI provides a cache of mapping slots for active
+	 * page tables.
+	 *
+	 * We use slot zero for the linear mapping of physical memory, thus
+	 * bump the slot numbers by one.
+	 * 
+	 * HIGHMEM_PTE kernels use two additional slots for the mapped PTE and
+	 * nested PTE.
+	 *
+	 *  args:                 SLOT      VA   COUNT PFN
+	 */
+	vmi_ops.set_linear_mapping(slot+1, (u32)va, 1, pfn);
+}
+
 static void vmi_allocate_pt(u32 pfn)
 {
 	vmi_set_page_type(pfn, VMI_PAGE_L1);
@@ -820,6 +840,7 @@ static int __init activate_vmi(void)
 	vmi_ops.allocate_page = vmi_get_function(VMI_CALL_AllocatePage);
 	vmi_ops.release_page = vmi_get_function(VMI_CALL_ReleasePage);
 
+	paravirt_ops.map_pt_hook = vmi_map_pt_hook;
 	paravirt_ops.alloc_pt = vmi_allocate_pt;
 	paravirt_ops.alloc_pd = vmi_allocate_pd;
 	paravirt_ops.alloc_pd_clone = vmi_allocate_pd_clone;
diff -r 08dce48f1a50 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Fri Feb 02 16:31:59 2007 -0800
+++ b/include/asm-i386/paravirt.h	Fri Feb 02 17:17:26 2007 -0800
@@ -131,6 +131,8 @@ struct paravirt_ops
 	void (fastcall *flush_tlb_kernel)(void);
 	void (fastcall *flush_tlb_single)(u32 addr);
 
+	void (fastcall *map_pt_hook)(u32 slot, pte_t *va, u32 pfn);
+
 	void (fastcall *alloc_pt)(u32 pfn);
 	void (fastcall *alloc_pd)(u32 pfn);
 	void (fastcall *alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
@@ -354,6 +356,8 @@ static inline void startup_ipi_hook(int 
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
 #define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
 
+#define paravirt_map_pt_hook(slot, va, pfn) paravirt_ops.map_pt_hook(slot, va, pfn)
+
 #define paravirt_alloc_pt(pfn) paravirt_ops.alloc_pt(pfn)
 #define paravirt_release_pt(pfn) paravirt_ops.release_pt(pfn)
 
diff -r 08dce48f1a50 include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h	Fri Feb 02 16:31:59 2007 -0800
+++ b/include/asm-i386/pgtable.h	Fri Feb 02 17:33:24 2007 -0800
@@ -263,6 +263,7 @@ static inline pte_t pte_mkhuge(pte_t pte
  */
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
+#define paravirt_map_pt_hook(slot, va, pfn)	do { } while (0)
 #endif
 
 /*
@@ -469,10 +470,24 @@ extern pte_t *lookup_address(unsigned lo
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
-#define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
+#define pte_offset_map(dir, address)				\
+({								\
+	pte_t *__ptep;						\
+	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
+	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE0);\
+	paravirt_map_pt_hook(0,__ptep, pfn);			\
+	__ptep = __ptep + pte_index(address);			\
+	__ptep;							\
+})
+#define pte_offset_map_nested(dir, address)			\
+({								\
+	pte_t *__ptep;						\
+	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
+	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE1);\
+	paravirt_map_pt_hook(1,__ptep, pfn);			\
+	__ptep = __ptep + pte_index(address);			\
+	__ptep;							\
+})
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
 #else
