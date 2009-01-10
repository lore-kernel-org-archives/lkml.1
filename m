Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbZAJAYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbZAJAYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbZAJAYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:24:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:30104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbZAJAYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="655938473"
Message-Id: <20090110001404.738132000@intel.com>
References: <20090110001308.403550000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 Jan 2009 16:13:11 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       kjwinchester@gmail.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 3/6] x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
Content-Disposition: inline; filename=change_track_pfn_vma_new_param.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the protection parameter for track_pfn_vma_new() into a pgprot_t pointer.
Subsequent patch changes the x86 PAT handling to return a compatible
memtype in pgprot_t, if what was requested cannot be allowed due to conflicts.
No fuctionality change in this patch.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/mm/pat.c             |    6 +++---
 include/asm-generic/pgtable.h |    4 ++--
 mm/memory.c                   |    7 ++++---
 3 files changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2009-01-07 15:00:34.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2009-01-07 16:17:47.000000000 -0800
@@ -741,7 +741,7 @@ cleanup_ret:
  * Note that this function can be called with caller trying to map only a
  * subrange/page inside the vma.
  */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
 	int retval = 0;
@@ -758,14 +758,14 @@ int track_pfn_vma_new(struct vm_area_str
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot);
+		return reserve_pfn_range(paddr, vma_size, *prot);
 	}
 
 	/* reserve page by page using pfn and size */
 	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	for (i = 0; i < size; i += PAGE_SIZE) {
 		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, *prot);
 		if (retval)
 			goto cleanup_ret;
 	}
Index: linux-2.6/include/asm-generic/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-generic/pgtable.h	2009-01-07 15:00:35.000000000 -0800
+++ linux-2.6/include/asm-generic/pgtable.h	2009-01-07 16:12:23.000000000 -0800
@@ -301,7 +301,7 @@ static inline void ptep_modify_prot_comm
  * track_pfn_vma_new is called when a _new_ pfn mapping is being established
  * for physical range indicated by pfn and size.
  */
-static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 					unsigned long pfn, unsigned long size)
 {
 	return 0;
@@ -332,7 +332,7 @@ static inline void untrack_pfn_vma(struc
 {
 }
 #else
-extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 				unsigned long pfn, unsigned long size);
 extern int track_pfn_vma_copy(struct vm_area_struct *vma);
 extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2009-01-07 15:35:17.000000000 -0800
+++ linux-2.6/mm/memory.c	2009-01-07 16:16:10.000000000 -0800
@@ -1444,6 +1444,7 @@ int vm_insert_pfn(struct vm_area_struct 
 			unsigned long pfn)
 {
 	int ret;
+	pgprot_t pgprot = vma->vm_page_prot;
 	/*
 	 * Technically, architectures with pte_special can avoid all these
 	 * restrictions (same for remap_pfn_range).  However we would like
@@ -1458,10 +1459,10 @@ int vm_insert_pfn(struct vm_area_struct 
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_vma_new(vma, vma->vm_page_prot, pfn, PAGE_SIZE))
+	if (track_pfn_vma_new(vma, &pgprot, pfn, PAGE_SIZE))
 		return -EINVAL;
 
-	ret = insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+	ret = insert_pfn(vma, addr, pfn, pgprot);
 
 	if (ret)
 		untrack_pfn_vma(vma, pfn, PAGE_SIZE);
@@ -1604,7 +1605,7 @@ int remap_pfn_range(struct vm_area_struc
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
-	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
+	err = track_pfn_vma_new(vma, &prot, pfn, PAGE_ALIGN(size));
 	if (err) {
 		/*
 		 * To indicate that track_pfn related cleanup is not

-- 

