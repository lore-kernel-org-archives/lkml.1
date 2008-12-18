Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753091AbYLRUCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbYLRUCy (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYLRUBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:27028 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYLRUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="91793682"
Message-Id: <20081218194617.408164000@intel.com>
References: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:29 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/7] x86 PAT: hooks in generic vm code to help archs to track pfnmap regions - v3
Content-Disposition: inline; filename=generic_pfn_range_tracking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce generic hooks in remap_pfn_range and vm_insert_pfn and
corresponding copy and free routines with reserve and free tracking.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 include/linux/mm.h |    6 ++++
 mm/memory.c        |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-12-18 10:10:50.000000000 -0800
+++ linux-2.6/mm/memory.c	2008-12-18 10:11:23.000000000 -0800
@@ -99,6 +99,50 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
+#ifndef track_pfn_vma_new
+/*
+ * Interface that can be used by architecture code to keep track of
+ * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
+ *
+ * track_pfn_vma_new is called when a _new_ pfn mapping is being established
+ * for physical range indicated by pfn and size.
+ */
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+			unsigned long pfn, unsigned long size)
+{
+	return 0;
+}
+#endif
+
+#ifndef track_pfn_vma_copy
+/*
+ * Interface that can be used by architecture code to keep track of
+ * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
+ *
+ * track_pfn_vma_copy is called when vma that is covering the pfnmap gets
+ * copied through copy_page_range().
+ */
+int track_pfn_vma_copy(struct vm_area_struct *vma)
+{
+	return 0;
+}
+#endif
+
+#ifndef untrack_pfn_vma
+/*
+ * Interface that can be used by architecture code to keep track of
+ * memory type of pfn mappings (remap_pfn_range, vm_insert_pfn)
+ *
+ * untrack_pfn_vma is called while unmapping a pfnmap for a region.
+ * untrack can be called for a specific region indicated by pfn and size or
+ * can be for the entire vma (in which case size can be zero).
+ */
+void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
+			unsigned long size)
+{
+}
+#endif
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
@@ -669,6 +713,16 @@ int copy_page_range(struct mm_struct *ds
 	if (is_vm_hugetlb_page(vma))
 		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
 
+	if (is_pfn_mapping(vma)) {
+		/*
+		 * We do not free on error cases below as remove_vma
+		 * gets called on error from higher level routine
+		 */
+		ret = track_pfn_vma_copy(vma);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * We need to invalidate the secondary MMU mappings only when
 	 * there could be a permission downgrade on the ptes of the
@@ -915,6 +969,9 @@ unsigned long unmap_vmas(struct mmu_gath
 		if (vma->vm_flags & VM_ACCOUNT)
 			*nr_accounted += (end - start) >> PAGE_SHIFT;
 
+		if (is_pfn_mapping(vma))
+			untrack_pfn_vma(vma, 0, 0);
+
 		while (start != end) {
 			if (!tlb_start_valid) {
 				tlb_start = start;
@@ -1473,6 +1530,7 @@ out:
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn)
 {
+	int ret;
 	/*
 	 * Technically, architectures with pte_special can avoid all these
 	 * restrictions (same for remap_pfn_range).  However we would like
@@ -1487,7 +1545,15 @@ int vm_insert_pfn(struct vm_area_struct 
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+	if (track_pfn_vma_new(vma, vma->vm_page_prot, pfn, PAGE_SIZE))
+		return -EINVAL;
+
+  	ret = insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+
+	if (ret)
+		untrack_pfn_vma(vma, pfn, PAGE_SIZE);
+
+	return ret;
 }
 EXPORT_SYMBOL(vm_insert_pfn);
 
@@ -1625,6 +1691,10 @@ int remap_pfn_range(struct vm_area_struc
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
+	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
+	if (err)
+		return -EINVAL;
+
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
 	pgd = pgd_offset(mm, addr);
@@ -1636,6 +1706,10 @@ int remap_pfn_range(struct vm_area_struc
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
+
+	if (err)
+		untrack_pfn_vma(vma, pfn, PAGE_ALIGN(size));
+
 	return err;
 }
 EXPORT_SYMBOL(remap_pfn_range);
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-12-18 10:10:50.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-12-18 10:11:23.000000000 -0800
@@ -155,6 +155,12 @@ static inline int is_pfn_mapping(struct 
 	return (vma->vm_flags & VM_PFNMAP);
 }
 
+extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+				unsigned long pfn, unsigned long size);
+extern int track_pfn_vma_copy(struct vm_area_struct *vma);
+extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
+				unsigned long size);
+
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask

-- 

