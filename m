Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYASGvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYASGvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYASGs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:48:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:33236 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYASGsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:48:36 -0500
From: Andi Kleen <ak@suse.de>
References: <20080119748.170864000@suse.de>
In-Reply-To: <20080119748.170864000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/8] CPA: Implement GBpages support in change_page_attr()
Message-Id: <20080119064835.A68D614EAD@wotan.suse.de>
Date: Sat, 19 Jan 2008 07:48:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Teach c_p_a() to split and unsplit GB pages.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_64.c |  150 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 119 insertions(+), 31 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -40,6 +40,9 @@ pte_t *lookup_address(unsigned long addr
 	pud = pud_offset(pgd, address);
 	if (!pud_present(*pud))
 		return NULL; 
+	*level = 2;
+	if (pud_large(*pud))
+		return (pte_t *)pud;
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
 		return NULL; 
@@ -53,30 +56,85 @@ pte_t *lookup_address(unsigned long addr
 	return pte;
 } 
 
-static struct page *split_large_page(unsigned long address, pgprot_t prot,
-				     pgprot_t ref_prot)
-{ 
-	int i; 
+static pte_t *alloc_split_page(struct page **base)
+{
+	struct page *p = alloc_page(GFP_KERNEL);
+	if (!p)
+		return NULL;
+	SetPagePrivate(p);
+	page_private(p) = 0;
+	*base = p;
+	return page_address(p);
+}
+
+static struct page *free_split_page(struct page *base)
+{
+	BUG_ON(!PagePrivate(base));
+	BUG_ON(page_private(base) != 0);
+	ClearPagePrivate(base);
+	__free_page(base);
+	return NULL;
+}
+
+static struct page *
+split_pmd(unsigned long paddr, pgprot_t prot, pgprot_t ref_prot)
+{
+	int i;
 	unsigned long addr;
-	struct page *base = alloc_pages(GFP_KERNEL, 0);
-	pte_t *pbase;
-	if (!base) 
+	struct page *base;
+	pte_t *pbase = alloc_split_page(&base);
+	if (!pbase)
 		return NULL;
-	/*
-	 * page_private is used to track the number of entries in
-	 * the page table page have non standard attributes.
-	 */
-	SetPagePrivate(base);
-	page_private(base) = 0;
 
-	address = __pa(address);
-	addr = address & PMD_PAGE_MASK;
-	pbase = (pte_t *)page_address(base);
-	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE) {
-		pbase[i] = pfn_pte(addr >> PAGE_SHIFT, 
-				   addr == address ? prot : ref_prot);
+	addr = paddr & PMD_PAGE_MASK;
+	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE)
+		pbase[i] = pfn_pte(addr >> PAGE_SHIFT,
+			   addr == paddr ? prot : ref_prot);
+
+	return base;
+}
+
+static struct page *
+split_gb(unsigned long paddr, pgprot_t prot, pgprot_t ref_prot)
+{
+	unsigned long addr;
+	int i;
+	struct page *base;
+	pte_t *pbase = alloc_split_page(&base);
+
+	if (!pbase)
+		return NULL;
+	addr = paddr & PUD_PAGE_MASK;
+	for (i = 0; i < PTRS_PER_PMD; i++, addr += PMD_PAGE_SIZE) {
+		if (paddr >= addr && paddr < addr + PMD_PAGE_SIZE) {
+			struct page *l3;
+			l3 = split_pmd(paddr, prot, ref_prot);
+			if (!l3)
+				return free_split_page(base);
+			page_private(l3)++;
+			pbase[i] = mk_pte(l3, ref_prot);
+		} else {
+			pbase[i] = pfn_pte(addr>>PAGE_SHIFT, ref_prot);
+			pbase[i] = pte_mkhuge(pbase[i]);
+		}
 	}
 	return base;
+}
+
+static struct page *split_large_page(unsigned long address, pgprot_t prot,
+				     pgprot_t ref_prot, int level)
+{
+	unsigned long paddr = __pa(address);
+	if (level == 2)
+		return split_gb(paddr, prot, ref_prot);
+	else if (level == 3)
+		return split_pmd(paddr, prot, ref_prot);
+	else {
+		printk("address %lx\n", address);
+		dump_pagetable(address);
+		BUG();
+	}
+	return NULL;
 } 
 
 struct flush_arg {
@@ -132,17 +190,40 @@ static inline void save_page(struct page
 		list_add(&fpage->lru, &deferred_pages);
 }
 
+static void reset_large_pte(pte_t *pte, unsigned long addr, pgprot_t prot)
+{
+	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
+	set_pte(pte, pte_mkhuge(pfn_pte(pfn, prot)));
+}
+
+static void
+revert_gb(unsigned long address, pud_t *pud, pmd_t *pmd, pgprot_t ref_prot)
+{
+	struct page *p = virt_to_page(pmd);
+
+	/* Reserved pages have been already set up at boot. Don't touch those. */
+	if (PageReserved(p))
+		return;
+
+	--page_private(p);
+	BUG_ON(page_private(p) < 0);
+	if (page_private(p) == 0) {
+		save_page(p);
+		reset_large_pte((pte_t *)pud, address & PUD_PAGE_MASK,
+					ref_prot);
+	}
+}
+
 /* 
  * No more special protections in this 2MB area - revert to a
- * large page again. 
+ * large or GB page again.
  */
+
 static void revert_page(unsigned long address, pgprot_t ref_prot)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t large_pte;
-	unsigned long pfn;
 
 	pgd = pgd_offset_k(address);
 	BUG_ON(pgd_none(*pgd));
@@ -150,10 +231,9 @@ static void revert_page(unsigned long ad
 	BUG_ON(pud_none(*pud));
 	pmd = pmd_offset(pud, address);
 	BUG_ON(pmd_val(*pmd) & _PAGE_PSE);
-	pfn = (__pa(address) & PMD_PAGE_MASK) >> PAGE_SHIFT;
-	large_pte = pfn_pte(pfn, ref_prot);
-	large_pte = pte_mkhuge(large_pte);
-	set_pte((pte_t *)pmd, large_pte);
+	reset_large_pte((pte_t *)pmd, address & PMD_PAGE_MASK, ref_prot);
+
+	revert_gb(address, pud, pmd, ref_prot);
 }      
 
 /*
@@ -189,6 +269,7 @@ static void set_tlb_flush(unsigned long 
 static const unsigned short pat_bit[5] = {
 	[4] = _PAGE_PAT,
 	[3] = _PAGE_PAT_LARGE,
+	[2] = _PAGE_PAT_LARGE,
 };
 
 static int cache_attr_changed(pte_t pte, pgprot_t prot, int level)
@@ -228,15 +309,14 @@ __change_page_attr(unsigned long address
 				page_private(kpte_page)++;
 			set_pte(kpte, pfn_pte(pfn, prot));
 		} else {
-			/*
-			 * split_large_page will take the reference for this
-			 * change_page_attr on the split page.
-			 */
 			struct page *split;
 			ref_prot2 = pte_pgprot(pte_clrhuge(*kpte));
-			split = split_large_page(address, prot, ref_prot2);
+			split = split_large_page(address, prot, ref_prot2,
+						level);
 			if (!split)
 				return -ENOMEM;
+			if (level == 3 && !PageReserved(kpte_page))
+				page_private(kpte_page)++;
 			pgprot_val(ref_prot2) &= ~_PAGE_NX;
 			set_pte(kpte, mk_pte(split, ref_prot2));
 			kpte_page = split;
