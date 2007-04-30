Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXD3Kaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXD3Kaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXD3K3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:43034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965472AbXD3K2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:12 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [36/40] i386: Implement vmi_kmap_atomic_pte
Message-Id: <20070430102811.4A0C0151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

Implement vmi_kmap_atomic_pte in terms of the backend set_linear_mapping
operation.  The conversion is rather straighforward; call kmap_atomic
and then inform the hypervisor of the page mapping.

The _flush_tlb damage is due to macros being pulled in from highmem.h.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/vmi.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/vmi.c
===================================================================
--- linux.orig/arch/i386/kernel/vmi.c
+++ linux/arch/i386/kernel/vmi.c
@@ -26,6 +26,7 @@
 #include <linux/cpu.h>
 #include <linux/bootmem.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <asm/vmi.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>
@@ -65,8 +66,8 @@ static struct {
 	void (*release_page)(u32, u32);
 	void (*set_pte)(pte_t, pte_t *, unsigned);
 	void (*update_pte)(pte_t *, unsigned);
-	void (*set_linear_mapping)(int, u32, u32, u32);
-	void (*flush_tlb)(int);
+	void (*set_linear_mapping)(int, void *, u32, u32);
+	void (*_flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
   	void (*set_lazy_mode)(int mode);
@@ -221,12 +222,12 @@ static void vmi_load_esp0(struct tss_str
 
 static void vmi_flush_tlb_user(void)
 {
-	vmi_ops.flush_tlb(VMI_FLUSH_TLB);
+	vmi_ops._flush_tlb(VMI_FLUSH_TLB);
 }
 
 static void vmi_flush_tlb_kernel(void)
 {
-	vmi_ops.flush_tlb(VMI_FLUSH_TLB | VMI_FLUSH_GLOBAL);
+	vmi_ops._flush_tlb(VMI_FLUSH_TLB | VMI_FLUSH_GLOBAL);
 }
 
 /* Stub to do nothing at all; used for delays and unimplemented calls */
@@ -349,8 +350,11 @@ static void vmi_check_page_type(u32 pfn,
 #define vmi_check_page_type(p,t) do { } while (0)
 #endif
 
-static void vmi_map_pt_hook(int type, pte_t *va, u32 pfn)
+#ifdef CONFIG_HIGHPTE
+static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 {
+	void *va = kmap_atomic(page, type);
+
 	/*
 	 * Internally, the VMI ROM must map virtual addresses to physical
 	 * addresses for processing MMU updates.  By the time MMU updates
@@ -364,8 +368,11 @@ static void vmi_map_pt_hook(int type, pt
 	 *  args:                 SLOT                 VA    COUNT PFN
 	 */
 	BUG_ON(type != KM_PTE0 && type != KM_PTE1);
-	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, (u32)va, 1, pfn);
+	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, va, 1, page_to_pfn(page));
+
+	return va;
 }
+#endif
 
 static void vmi_allocate_pt(u32 pfn)
 {
@@ -660,7 +667,7 @@ void vmi_bringup(void)
 {
  	/* We must establish the lowmem mapping for MMU ops to work */
 	if (vmi_ops.set_linear_mapping)
-		vmi_ops.set_linear_mapping(0, __PAGE_OFFSET, max_low_pfn, 0);
+		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, max_low_pfn, 0);
 }
 
 /*
@@ -800,8 +807,8 @@ static inline int __init activate_vmi(vo
 	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
-	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
-	para_wrap(flush_tlb_kernel, vmi_flush_tlb_kernel, flush_tlb, FlushTLB);
+	para_wrap(flush_tlb_user, vmi_flush_tlb_user, _flush_tlb, FlushTLB);
+	para_wrap(flush_tlb_kernel, vmi_flush_tlb_kernel, _flush_tlb, FlushTLB);
 	para_fill(flush_tlb_single, InvalPage);
 
 	/*
@@ -847,9 +854,12 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.release_pt = vmi_release_pt;
 		paravirt_ops.release_pd = vmi_release_pd;
 	}
-#if 0
-	para_wrap(map_pt_hook, vmi_map_pt_hook, set_linear_mapping,
-		  SetLinearMapping);
+
+	/* Set linear is needed in all cases */
+	vmi_ops.set_linear_mapping = vmi_get_function(VMI_CALL_SetLinearMapping);
+#ifdef CONFIG_HIGHPTE
+	if (vmi_ops.set_linear_mapping)
+		paravirt_ops.kmap_atomic_pte = vmi_kmap_atomic_pte;
 #endif
 
 	/*
