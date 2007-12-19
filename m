Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbXLTBIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbXLTBIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXLTBI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:08:27 -0500
Received: from 225.sub-75-208-182.myvzw.com ([75.208.182.225]:53531 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753842AbXLTBI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:08:26 -0500
Message-Id: <20071219223604.749182363@goop.org>
References: <20071219223534.129042140@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 14:35:39 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 5/5] x86: clean up pagetable-related printk format warnings
Content-Disposition: inline; filename=x86-pagetable-printk-warnings.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up a number of warnings about printk format mismatches.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/kernel/setup_32.c   |    6 +++---
 arch/x86/mm/fault_32.c       |    2 +-
 arch/x86/mm/fault_64.c       |    8 ++++----
 include/asm-x86/pgtable_64.h |    8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

===================================================================
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -335,7 +335,7 @@ unsigned long __init find_max_low_pfn(vo
 		if (highmem_pages + MAXMEM_PFN < max_pfn)
 			max_pfn = MAXMEM_PFN + highmem_pages;
 		if (highmem_pages + MAXMEM_PFN > max_pfn) {
-			printk("only %luMB highmem pages available, ignoring highmem size of %uMB.\n", pages_to_mb(max_pfn - MAXMEM_PFN), pages_to_mb(highmem_pages));
+			printk("only %luMB highmem pages available, ignoring highmem size of %luMB.\n", pages_to_mb(max_pfn - MAXMEM_PFN), pages_to_mb(highmem_pages));
 			highmem_pages = 0;
 		}
 		max_low_pfn = MAXMEM_PFN;
@@ -362,12 +362,12 @@ unsigned long __init find_max_low_pfn(vo
 			highmem_pages = 0;
 #ifdef CONFIG_HIGHMEM
 		if (highmem_pages >= max_pfn) {
-			printk(KERN_ERR "highmem size specified (%uMB) is bigger than pages available (%luMB)!.\n", pages_to_mb(highmem_pages), pages_to_mb(max_pfn));
+			printk(KERN_ERR "highmem size specified (%luMB) is bigger than pages available (%luMB)!.\n", pages_to_mb(highmem_pages), pages_to_mb(max_pfn));
 			highmem_pages = 0;
 		}
 		if (highmem_pages) {
 			if (max_low_pfn-highmem_pages < 64*1024*1024/PAGE_SIZE){
-				printk(KERN_ERR "highmem size %uMB results in smaller than 64MB lowmem, ignoring it.\n", pages_to_mb(highmem_pages));
+				printk(KERN_ERR "highmem size %luMB results in smaller than 64MB lowmem, ignoring it.\n", pages_to_mb(highmem_pages));
 				highmem_pages = 0;
 			}
 			max_low_pfn -= highmem_pages;
===================================================================
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -557,7 +557,7 @@ no_context:
 			page &= ~_PAGE_NX;
 		}
 #else
-		printk("*pde = %08lx ", page);
+		printk("*pde = %08x ", page);
 #endif
 
 		/*
===================================================================
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -157,22 +157,22 @@ void dump_pagetable(unsigned long addres
 	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK); 
 	pgd += pgd_index(address);
 	if (bad_address(pgd)) goto bad;
-	printk("PGD %lx ", pgd_val(*pgd));
+	printk("PGD %llx ", pgd_val(*pgd));
 	if (!pgd_present(*pgd)) goto ret; 
 
 	pud = pud_offset(pgd, address);
 	if (bad_address(pud)) goto bad;
-	printk("PUD %lx ", pud_val(*pud));
+	printk("PUD %llx ", pud_val(*pud));
 	if (!pud_present(*pud))	goto ret;
 
 	pmd = pmd_offset(pud, address);
 	if (bad_address(pmd)) goto bad;
-	printk("PMD %lx ", pmd_val(*pmd));
+	printk("PMD %llx ", pmd_val(*pmd));
 	if (!pmd_present(*pmd) || pmd_large(*pmd)) goto ret;
 
 	pte = pte_offset_kernel(pmd, address);
 	if (bad_address(pte)) goto bad;
-	printk("PTE %lx", pte_val(*pte)); 
+	printk("PTE %llx", pte_val(*pte));
 ret:
 	printk("\n");
 	return;
===================================================================
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -57,13 +57,13 @@ extern void clear_kernel_mapping(unsigne
 #ifndef __ASSEMBLY__
 
 #define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), pte_val(e))
+	printk("%s:%d: bad pte %p(%016llx).\n", __FILE__, __LINE__, &(e), pte_val(e))
 #define pmd_ERROR(e) \
-	printk("%s:%d: bad pmd %p(%016lx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
+	printk("%s:%d: bad pmd %p(%016llx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
 #define pud_ERROR(e) \
-	printk("%s:%d: bad pud %p(%016lx).\n", __FILE__, __LINE__, &(e), pud_val(e))
+	printk("%s:%d: bad pud %p(%016llx).\n", __FILE__, __LINE__, &(e), pud_val(e))
 #define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd %p(%016lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
+	printk("%s:%d: bad pgd %p(%016llx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
 
 #define pgd_none(x)	(!pgd_val(x))
 #define pud_none(x)	(!pud_val(x))

-- 

