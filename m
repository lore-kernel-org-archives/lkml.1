Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYAPCm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYAPCm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbYAPClf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:41:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:64233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537AbYAPClN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:41:13 -0500
X-ExtLoop1: 1
Message-Id: <20080116024112.059516000@intel.com>
References: <20080116023955.597433000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 18:39:58 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/4] x86: PAT followup - Remove reserved pages mapping to zero page and not map them
Content-Disposition: inline; filename=remove_reserved_zeropages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove reserved pages mapping to zeropage. Reserved and holes are now not
mapped at all.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6.git/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/init_32.c	2008-01-15 11:02:23.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/init_32.c	2008-01-15 11:08:29.000000000 -0800
@@ -143,50 +143,6 @@
 	return 0;
 }
 
-static unsigned long __init get_res_page(void)
-{
-	static unsigned long res_phys_page;
-	if (!res_phys_page) {
-
-		res_phys_page = (unsigned long)
-		                alloc_bootmem_low_pages(PAGE_SIZE);
-		if (!res_phys_page)
-			BUG();
-
-		memset((char *)res_phys_page, 0xe, PAGE_SIZE);
-		res_phys_page = __pa(res_phys_page);
-	}
-	return res_phys_page;
-}
-
-static unsigned long __init get_res_ptepage(void)
-{
-	static unsigned long res_phys_ptepage;
-	pte_t *pte;
-	int pte_ofs;
-	unsigned long pfn;
-
-	if (!res_phys_ptepage) {
-
-		res_phys_ptepage = (unsigned long)
-		                   alloc_bootmem_low_pages(PAGE_SIZE);
-		if (!res_phys_ptepage)
-			BUG();
-
-		paravirt_alloc_pt(&init_mm,
-		                  __pa(res_phys_ptepage) >> PAGE_SHIFT);
-
-		/* Set all PTEs in the range to zero page */
-		pfn = get_res_page() >> PAGE_SHIFT;
-		pte = (pte_t *)res_phys_ptepage;
-		for (pte_ofs = 0; pte_ofs < PTRS_PER_PTE; pte++, pte_ofs++)
-			set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
-
-		res_phys_ptepage = __pa(res_phys_ptepage);
-	}
-	return res_phys_ptepage;
-}
-
 /*
  * This maps the physical memory to kernel virtual address space, a total 
  * of max_low_pfn pages, by creating page tables starting from address 
@@ -199,7 +155,6 @@
 	pmd_t *pmd;
 	pte_t *pte;
 	int pgd_idx, pmd_idx, pte_ofs;
-	unsigned long temp_pfn;
 
 	pgd_idx = pgd_index(PAGE_OFFSET);
 	pgd = pgd_base + pgd_idx;
@@ -238,9 +193,7 @@
 			}
 			if (cpu_has_pse &&
 			    !is_memory_any_valid(paddr, paddr + PMD_SIZE)) {
-
-				temp_pfn = get_res_ptepage();
-				set_pmd(pmd, __pmd(temp_pfn | _PAGE_TABLE));
+				set_pmd(pmd, __pmd(0));
 				pfn += PTRS_PER_PTE;
 				continue;
 			}
@@ -259,10 +212,7 @@
 
 				if (!is_memory_any_valid(paddr,
 				                         paddr + PAGE_SIZE)) {
-
-					temp_pfn = get_res_page() >> PAGE_SHIFT;
-					set_pte(pte,
-					        pfn_pte(temp_pfn, PAGE_KERNEL));
+					set_pte(pte, __pte(0));
 					continue;
 				}
 
Index: linux-2.6.git/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-15 11:06:37.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-15 11:09:18.000000000 -0800
@@ -494,41 +494,6 @@
 			 kcore_vsyscall;
 
 
-static unsigned long __init get_res_page(void)
-{
-	static unsigned long res_phys_page;
-	if (!res_phys_page) {
-		pte_t *pte;
-		pte = alloc_low_page(&res_phys_page);
-		unmap_low_page(pte);
-	}
-	return res_phys_page;
-}
-
-static unsigned long __init get_res_ptepage(void)
-{
-	static unsigned long res_phys_ptepage;
-	if (!res_phys_ptepage) {
-		pte_t *pte_page;
-		unsigned long page_phys;
-		unsigned long entry;
-		int i;
-
-		pte_page = alloc_low_page(&res_phys_ptepage);
-
-		page_phys = get_res_page();
-		entry = _PAGE_NX | _KERNPG_TABLE | _PAGE_GLOBAL | page_phys;
-		entry &= __supported_pte_mask;
-		for (i = 0; i < PTRS_PER_PTE; i++) {
-			pte_t *pte = pte_page + i;
-			set_pte(pte, __pte(entry));
-		}
-
-		unmap_low_page(pte_page);
-	}
-	return res_phys_ptepage;
-}
-
 static void __init phys_pte_prune(pte_t *pte_page, unsigned long address,
 		unsigned long end, unsigned long vaddr, unsigned int exec)
 {
@@ -545,15 +510,7 @@
 		if (!(address & (~PAGE_MASK)) &&
 		    (address + PAGE_SIZE <= end) &&
 		    !is_memory_any_valid(address, address + PAGE_SIZE)) {
-			unsigned long phys_page;
-
-			phys_page = get_res_page();
-			entry = _PAGE_NX | _KERNPG_TABLE | _PAGE_GLOBAL |
-				phys_page;
-
-			entry &= __supported_pte_mask;
-			set_pte(pte, __pte(entry));
-
+			set_pte(pte, __pte(0));
 			continue;
 		}
 
@@ -587,10 +544,7 @@
 		if (!(address & (~PMD_MASK)) &&
 		    (address + PMD_SIZE <= end) &&
 		    !is_memory_any_valid(address, address + PMD_SIZE)) {
-
-			pte_phys = get_res_ptepage();
-			set_pmd(pmd, __pmd(pte_phys | _KERNPG_TABLE));
-
+			set_pmd(pmd, __pmd(0));
 			continue;
 		}
 

-- 
