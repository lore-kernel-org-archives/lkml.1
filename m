Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYACP3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYACP3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYACPYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:38 -0500
Received: from ns2.suse.de ([195.135.220.15]:43016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYACPYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:23 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [8/28] CPA: Return the page table level in lookup_address()
Message-Id: <20080103152422.7A89D14E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for the next change.

And change all the callers.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault_32.c       |    3 ++-
 arch/x86/mm/init_32.c        |    3 ++-
 arch/x86/mm/pageattr_32.c    |    7 +++++--
 arch/x86/mm/pageattr_64.c    |    7 +++++--
 arch/x86/xen/mmu.c           |    9 ++++++---
 include/asm-x86/pgtable_32.h |    2 +-
 include/asm-x86/pgtable_64.h |    2 +-
 7 files changed, 22 insertions(+), 11 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -13,7 +13,7 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
-pte_t *lookup_address(unsigned long address)
+pte_t *lookup_address(unsigned long address, int *level)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
@@ -27,8 +27,10 @@ pte_t *lookup_address(unsigned long addr
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
 		return NULL; 
+	*level = 3;
 	if (pmd_large(*pmd))
 		return (pte_t *)pmd;
+	*level = 4;
 	pte = pte_offset_kernel(pmd, address);
 	if (pte && !pte_present(*pte))
 		pte = NULL; 
@@ -129,8 +131,9 @@ __change_page_attr(unsigned long address
 	pte_t *kpte; 
 	struct page *kpte_page;
 	pgprot_t ref_prot2;
+	int level;
 
-	kpte = lookup_address(address);
+	kpte = lookup_address(address, &level);
 	if (!kpte) return 0;
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
 	BUG_ON(PageLRU(kpte_page));
Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -409,7 +409,7 @@ extern struct list_head pgd_list;
 
 extern int kern_addr_valid(unsigned long addr); 
 
-pte_t *lookup_address(unsigned long addr);
+pte_t *lookup_address(unsigned long addr, int *level);
 
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -18,7 +18,7 @@ static DEFINE_SPINLOCK(cpa_lock);
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
 
 
-pte_t *lookup_address(unsigned long address) 
+pte_t *lookup_address(unsigned long address, int *level)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
@@ -31,8 +31,10 @@ pte_t *lookup_address(unsigned long addr
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		return NULL;
+	*level = 2;
 	if (pmd_large(*pmd))
 		return (pte_t *)pmd;
+	*level = 3;
         return pte_offset_kernel(pmd, address);
 } 
 
@@ -148,11 +150,12 @@ __change_page_attr(struct page *page, pg
 	pte_t *kpte; 
 	unsigned long address;
 	struct page *kpte_page;
+	int level;
 
 	BUG_ON(PageHighMem(page));
 	address = (unsigned long)page_address(page);
 
-	kpte = lookup_address(address);
+	kpte = lookup_address(address, &level);
 	if (!kpte)
 		return -EINVAL;
 	kpte_page = virt_to_page(kpte);
Index: linux/include/asm-x86/pgtable_32.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_32.h
+++ linux/include/asm-x86/pgtable_32.h
@@ -443,7 +443,7 @@ static inline pte_t pte_modify(pte_t pte
  * NOTE: the return type is pte_t but if the pmd is PSE then we return it
  * as a pte too.
  */
-extern pte_t *lookup_address(unsigned long address);
+extern pte_t *lookup_address(unsigned long address, int *level);
 
 /*
  * Make a given kernel text page executable/non-executable.
Index: linux/arch/x86/mm/fault_32.c
===================================================================
--- linux.orig/arch/x86/mm/fault_32.c
+++ linux/arch/x86/mm/fault_32.c
@@ -643,7 +643,8 @@ no_context:
 
 #ifdef CONFIG_X86_PAE
 		if (error_code & 16) {
-			pte_t *pte = lookup_address(address);
+			int level;
+			pte_t *pte = lookup_address(address, &level);
 
 			if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
 				printk(KERN_CRIT "kernel tried to execute "
Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -528,11 +528,12 @@ int __init set_kernel_exec(unsigned long
 {
 	pte_t *pte;
 	int ret = 1;
+	int level;
 
 	if (!nx_enabled)
 		goto out;
 
-	pte = lookup_address(vaddr);
+	pte = lookup_address(vaddr, &level);
 	BUG_ON(!pte);
 
 	if (!pte_exec_kernel(*pte))
Index: linux/arch/x86/xen/mmu.c
===================================================================
--- linux.orig/arch/x86/xen/mmu.c
+++ linux/arch/x86/xen/mmu.c
@@ -58,7 +58,8 @@
 
 xmaddr_t arbitrary_virt_to_machine(unsigned long address)
 {
-	pte_t *pte = lookup_address(address);
+	int level;
+	pte_t *pte = lookup_address(address, &level);
 	unsigned offset = address & PAGE_MASK;
 
 	BUG_ON(pte == NULL);
@@ -70,8 +71,9 @@ void make_lowmem_page_readonly(void *vad
 {
 	pte_t *pte, ptev;
 	unsigned long address = (unsigned long)vaddr;
+	int level;
 
-	pte = lookup_address(address);
+	pte = lookup_address(address, &level);
 	BUG_ON(pte == NULL);
 
 	ptev = pte_wrprotect(*pte);
@@ -84,8 +86,9 @@ void make_lowmem_page_readwrite(void *va
 {
 	pte_t *pte, ptev;
 	unsigned long address = (unsigned long)vaddr;
+	int level;
 
-	pte = lookup_address(address);
+	pte = lookup_address(address, &level);
 	BUG_ON(pte == NULL);
 
 	ptev = pte_mkwrite(*pte);
