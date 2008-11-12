Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYKLXWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYKLXWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYKLXUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:43883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbYKLXUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="402946556"
Message-Id: <20081112212900.436502000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:51 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/8] x86 PAT: hooks in generic vm code to help archs to track pfnmap regions
Content-Disposition: inline; filename=generic_pfn_range_tracking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce generic hooks in remap_pfn_range and vm_insert_pfn and
corresponding copy and free routines with reserve and free tracking.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 include/linux/mm.h |    6 +++++
 mm/memory.c        |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletion(-)

Index: tip/mm/memory.c
===================================================================
--- tip.orig/mm/memory.c	2008-11-11 10:10:11.000000000 -0800
+++ tip/mm/memory.c	2008-11-11 12:10:18.000000000 -0800
@@ -99,6 +99,28 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
+#ifndef track_pfn_vma_new
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+			unsigned long pfn, unsigned long size)
+{
+	return 0;
+}
+#endif
+
+#ifndef track_pfn_vma_copy
+int track_pfn_vma_copy(struct vm_area_struct *vma)
+{
+	return 0;
+}
+#endif
+
+#ifndef untrack_pfn_vma
+void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
+			unsigned long size)
+{
+}
+#endif
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
@@ -669,6 +691,16 @@ int copy_page_range(struct mm_struct *ds
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
@@ -915,6 +947,9 @@ unsigned long unmap_vmas(struct mmu_gath
 		if (vma->vm_flags & VM_ACCOUNT)
 			*nr_accounted += (end - start) >> PAGE_SHIFT;
 
+		if (is_pfn_mapping(vma))
+			untrack_pfn_vma(vma, 0, 0);
+
 		while (start != end) {
 			if (!tlb_start_valid) {
 				tlb_start = start;
@@ -1473,6 +1508,7 @@ out:
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn)
 {
+	int ret;
 	/*
 	 * Technically, architectures with pte_special can avoid all these
 	 * restrictions (same for remap_pfn_range).  However we would like
@@ -1489,7 +1525,15 @@ int vm_insert_pfn(struct vm_area_struct 
 		return -EFAULT;
 
 	vma->vm_flags |= VM_PFNMAP;
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
 
@@ -1627,6 +1671,10 @@ int remap_pfn_range(struct vm_area_struc
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
+	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
+	if (err)
+		return -EINVAL;
+
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
 	pgd = pgd_offset(mm, addr);
@@ -1638,6 +1686,10 @@ int remap_pfn_range(struct vm_area_struc
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
Index: tip/include/linux/mm.h
===================================================================
--- tip.orig/include/linux/mm.h	2008-11-11 10:10:11.000000000 -0800
+++ tip/include/linux/mm.h	2008-11-11 10:10:12.000000000 -0800
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

