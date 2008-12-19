Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYLSVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYLSVvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYLSVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:50:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:12538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbYLSVuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:50:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,250,1228118400"; 
   d="scan'208";a="416028219"
Message-Id: <20081219214837.414225000@intel.com>
References: <20081219214725.125171000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 13:47:29 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/5] x86 PAT: Move track untrack pfnmap stubs to asm-generic
Content-Disposition: inline; filename=generic_pfn_range_comments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the track and untrack pfn stub routines from memory.c to asm-generic.
Also add unlikely to pfnmap related calls in fork and exit path.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/include/asm/pgtable.h |    6 +----
 include/asm-generic/pgtable.h  |   46 +++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h             |    6 -----
 mm/memory.c                    |   48 +----------------------------------------
 4 files changed, 50 insertions(+), 56 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-12-19 09:58:16.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-12-19 10:03:59.000000000 -0800
@@ -163,12 +163,6 @@ static inline int is_pfn_mapping(struct 
 	return (vma->vm_flags & VM_PFNMAP);
 }
 
-extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
-				unsigned long pfn, unsigned long size);
-extern int track_pfn_vma_copy(struct vm_area_struct *vma);
-extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
-				unsigned long size);
-
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-12-19 09:58:16.000000000 -0800
+++ linux-2.6/mm/memory.c	2008-12-19 10:03:59.000000000 -0800
@@ -99,50 +99,6 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
-#ifndef track_pfn_vma_new
-/*
- * Interface that can be used by architecture code to keep track of
- * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
- *
- * track_pfn_vma_new is called when a _new_ pfn mapping is being established
- * for physical range indicated by pfn and size.
- */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
-			unsigned long pfn, unsigned long size)
-{
-	return 0;
-}
-#endif
-
-#ifndef track_pfn_vma_copy
-/*
- * Interface that can be used by architecture code to keep track of
- * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
- *
- * track_pfn_vma_copy is called when vma that is covering the pfnmap gets
- * copied through copy_page_range().
- */
-int track_pfn_vma_copy(struct vm_area_struct *vma)
-{
-	return 0;
-}
-#endif
-
-#ifndef untrack_pfn_vma
-/*
- * Interface that can be used by architecture code to keep track of
- * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
- *
- * untrack_pfn_vma is called while unmapping a pfnmap for a region.
- * untrack can be called for a specific region indicated by pfn and size or
- * can be for the entire vma (in which case size can be zero).
- */
-void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
-			unsigned long size)
-{
-}
-#endif
-
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
@@ -713,7 +669,7 @@ int copy_page_range(struct mm_struct *ds
 	if (is_vm_hugetlb_page(vma))
 		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
 
-	if (is_pfn_mapping(vma)) {
+	if (unlikely(is_pfn_mapping(vma))) {
 		/*
 		 * We do not free on error cases below as remove_vma
 		 * gets called on error from higher level routine
@@ -969,7 +925,7 @@ unsigned long unmap_vmas(struct mmu_gath
 		if (vma->vm_flags & VM_ACCOUNT)
 			*nr_accounted += (end - start) >> PAGE_SHIFT;
 
-		if (is_pfn_mapping(vma))
+		if (unlikely(is_pfn_mapping(vma)))
 			untrack_pfn_vma(vma, 0, 0);
 
 		while (start != end) {
Index: linux-2.6/include/asm-generic/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-generic/pgtable.h	2008-12-19 09:55:21.000000000 -0800
+++ linux-2.6/include/asm-generic/pgtable.h	2008-12-19 10:15:08.000000000 -0800
@@ -293,6 +293,52 @@ static inline void ptep_modify_prot_comm
 #define arch_flush_lazy_cpu_mode()	do {} while (0)
 #endif
 
+#ifndef __HAVE_PFNMAP_TRACKING
+/*
+ * Interface that can be used by architecture code to keep track of
+ * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
+ *
+ * track_pfn_vma_new is called when a _new_ pfn mapping is being established
+ * for physical range indicated by pfn and size.
+ */
+static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+					unsigned long pfn, unsigned long size)
+{
+	return 0;
+}
+
+/*
+ * Interface that can be used by architecture code to keep track of
+ * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
+ *
+ * track_pfn_vma_copy is called when vma that is covering the pfnmap gets
+ * copied through copy_page_range().
+ */
+static inline int track_pfn_vma_copy(struct vm_area_struct *vma)
+{
+	return 0;
+}
+
+/*
+ * Interface that can be used by architecture code to keep track of
+ * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
+ *
+ * untrack_pfn_vma is called while unmapping a pfnmap for a region.
+ * untrack can be called for a specific region indicated by pfn and size or
+ * can be for the entire vma (in which case size can be zero).
+ */
+static inline void untrack_pfn_vma(struct vm_area_struct *vma,
+					unsigned long pfn, unsigned long size)
+{
+}
+#else
+extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+				unsigned long pfn, unsigned long size);
+extern int track_pfn_vma_copy(struct vm_area_struct *vma);
+extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
+				unsigned long size);
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h	2008-12-19 09:58:16.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable.h	2008-12-19 10:15:14.000000000 -0800
@@ -339,12 +339,10 @@ static inline pgprot_t pgprot_modify(pgp
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
+#ifndef __ASSEMBLY__
 /* Indicate that x86 has its own track and untrack pfn vma functions */
-#define track_pfn_vma_new track_pfn_vma_new
-#define track_pfn_vma_copy track_pfn_vma_copy
-#define untrack_pfn_vma untrack_pfn_vma
+#define __HAVE_PFNMAP_TRACKING
 
-#ifndef __ASSEMBLY__
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,

-- 

