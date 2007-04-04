Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXDEATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXDEATi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbXDEARu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:50 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36894 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932227AbXDEARC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:17:02 -0400
Message-Id: <20070404191206.319836661@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:12:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: [patch 16/20] revert map_pt_hook.
Content-Disposition: inline; filename=revert-map_pt_hook.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Back out the map_pt_hook to clear the way for kmap_atomic_pte.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/paravirt.c |    2 --
 arch/i386/kernel/vmi.c      |    2 ++
 include/asm-i386/paravirt.h |    7 -------
 include/asm-i386/pgtable.h  |   23 ++++-------------------
 4 files changed, 6 insertions(+), 28 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -303,8 +303,6 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_single = native_flush_tlb_single,
 	.flush_tlb_others = native_flush_tlb_others,
 
-	.map_pt_hook = paravirt_nop,
-
 	.alloc_pt = paravirt_nop,
 	.alloc_pd = paravirt_nop,
 	.alloc_pd_clone = paravirt_nop,
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -819,8 +819,10 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.release_pt = vmi_release_pt;
 		paravirt_ops.release_pd = vmi_release_pd;
 	}
+#if 0
 	para_wrap(map_pt_hook, vmi_map_pt_hook, set_linear_mapping,
 		  SetLinearMapping);
+#endif
 
 	/*
 	 * These MUST always be patched.  Don't support indirect jumps
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -128,8 +128,6 @@ struct paravirt_ops
 	void (*flush_tlb_single)(unsigned long addr);
 	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
 				 unsigned long va);
-
-	void (*map_pt_hook)(int type, pte_t *va, u32 pfn);
 
 	void (*alloc_pt)(u32 pfn);
 	void (*alloc_pd)(u32 pfn);
@@ -740,11 +738,6 @@ static inline void flush_tlb_others(cpum
 	PVOP_VCALL3(flush_tlb_others, &cpumask, mm, va);
 }
 
-static inline void paravirt_map_pt_hook(int type, pte_t *va, u32 pfn)
-{
-	PVOP_VCALL3(map_pt_hook, type, va, pfn);
-}
-
 static inline void paravirt_alloc_pt(unsigned pfn)
 {
 	PVOP_VCALL1(alloc_pt, pfn);
===================================================================
--- a/include/asm-i386/pgtable.h
+++ b/include/asm-i386/pgtable.h
@@ -272,7 +272,6 @@ static inline void vmalloc_sync_all(void
  */
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
-#define paravirt_map_pt_hook(slot, va, pfn)	do { } while (0)
 
 #define raw_ptep_get_and_clear(xp)     native_ptep_get_and_clear(xp)
 #endif
@@ -481,24 +480,10 @@ extern pte_t *lookup_address(unsigned lo
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address)				\
-({								\
-	pte_t *__ptep;						\
-	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
-	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE0);\
-	paravirt_map_pt_hook(KM_PTE0,__ptep, pfn);		\
-	__ptep = __ptep + pte_index(address);			\
-	__ptep;							\
-})
-#define pte_offset_map_nested(dir, address)			\
-({								\
-	pte_t *__ptep;						\
-	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
-	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE1);\
-	paravirt_map_pt_hook(KM_PTE1,__ptep, pfn);		\
-	__ptep = __ptep + pte_index(address);			\
-	__ptep;							\
-})
+#define pte_offset_map(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+#define pte_offset_map_nested(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
 #else

-- 

