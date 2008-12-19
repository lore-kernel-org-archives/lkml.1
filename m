Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYLSVum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYLSVum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYLSVuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:50:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:28552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbYLSVuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:50:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,250,1228118400"; 
   d="scan'208";a="416028215"
Message-Id: <20081219214837.126918000@intel.com>
References: <20081219214725.125171000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 13:47:27 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/5] x86 PAT: Modify follow_phys to return phys_addr prot and return value
Content-Disposition: inline; filename=modify_follow_phys.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

follow_phys does similar things as follow_pfnmap_pte. Make a minor change
to follow_phys so that it can be used in place of follow_pfnmap_pte.
Physical address return value with 0 as error return does not work in
follow_phys as the actual physical address 0 mapping may exist in pte.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 include/linux/mm.h |    2 ++
 mm/memory.c        |   31 ++++++++++++++-----------------
 2 files changed, 16 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-12-19 09:56:02.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-12-19 11:04:32.000000000 -0800
@@ -804,6 +804,8 @@ int copy_page_range(struct mm_struct *ds
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+int follow_phys(struct vm_area_struct *vma, unsigned long address,
+		unsigned int flags, unsigned long *prot, resource_size_t *phys);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-12-19 09:55:29.000000000 -0800
+++ linux-2.6/mm/memory.c	2008-12-19 11:05:40.000000000 -0800
@@ -2981,9 +2981,9 @@ int in_gate_area_no_task(unsigned long a
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
-static resource_size_t follow_phys(struct vm_area_struct *vma,
-			unsigned long address, unsigned int flags,
-			unsigned long *prot)
+int follow_phys(struct vm_area_struct *vma,
+		unsigned long address, unsigned int flags,
+		unsigned long *prot, resource_size_t *phys)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -2992,24 +2992,26 @@ static resource_size_t follow_phys(struc
 	spinlock_t *ptl;
 	resource_size_t phys_addr = 0;
 	struct mm_struct *mm = vma->vm_mm;
+	int ret = -EINVAL;
 
-	VM_BUG_ON(!(vma->vm_flags & (VM_IO | VM_PFNMAP)));
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		goto out;
 
 	pgd = pgd_offset(mm, address);
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto no_page_table;
+		goto out;
 
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		goto no_page_table;
+		goto out;
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto no_page_table;
+		goto out;
 
 	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
 	if (pmd_huge(*pmd))
-		goto no_page_table;
+		goto out;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
@@ -3024,13 +3026,13 @@ static resource_size_t follow_phys(struc
 	phys_addr <<= PAGE_SHIFT; /* Shift here to avoid overflow on PAE */
 
 	*prot = pgprot_val(pte_pgprot(pte));
+	*phys = phys_addr;
+	ret = 0;
 
 unlock:
 	pte_unmap_unlock(ptep, ptl);
 out:
-	return phys_addr;
-no_page_table:
-	return 0;
+	return ret;
 }
 
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
@@ -3041,12 +3043,7 @@ int generic_access_phys(struct vm_area_s
 	void *maddr;
 	int offset = addr & (PAGE_SIZE-1);
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		return -EINVAL;
-
-	phys_addr = follow_phys(vma, addr, write, &prot);
-
-	if (!phys_addr)
+	if (follow_phys(vma, addr, write, &prot, &phys_addr))
 		return -EINVAL;
 
 	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);

-- 

