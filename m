Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYACPcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYACPcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYACPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:47 -0500
Received: from ns.suse.de ([195.135.220.2]:46773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbYACPYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:43 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: jbeulich@novell.com, linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [26/28] CPA: Fix reference counting when changing already changed pages
Message-Id: <20080103152441.AB89814E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When changing a page that has already been modified to non standard attributes
before don't change the reference count. And when changing back a page
only decrease the ref count if the old attributes were non standard.

Cc: jbeulich@novell.com
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   36 +++++++++++++++++++-----------------
 arch/x86/mm/pageattr_64.c |   13 +++++++++----
 2 files changed, 28 insertions(+), 21 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -206,12 +206,13 @@ __change_page_attr(unsigned long address
 { 
 	pte_t *kpte; 
 	struct page *kpte_page;
-	pgprot_t ref_prot2;
+	pgprot_t ref_prot2, oldprot;
 	int level;
 
 	kpte = lookup_address(address, &level);
 	if (!kpte) return 0;
 	kpte_page = virt_to_page(kpte);
+	oldprot = pte_pgprot(*kpte);
 	BUG_ON(PageCompound(kpte_page));
 	BUG_ON(PageLRU(kpte_page));
 
@@ -219,6 +220,8 @@ __change_page_attr(unsigned long address
 
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (level == 4) {
+			if (pgprot_val(oldprot) == pgprot_val(ref_prot))
+				page_private(kpte_page)++;
 			set_pte(kpte, pfn_pte(pfn, prot));
 		} else {
  			/*
@@ -233,12 +236,14 @@ __change_page_attr(unsigned long address
 			pgprot_val(ref_prot2) &= ~_PAGE_NX;
 			set_pte(kpte, mk_pte(split, ref_prot2));
 			kpte_page = split;
+			page_private(kpte_page)++;
 		}
-		page_private(kpte_page)++;
 	} else if (level == 4) {
+		if (pgprot_val(oldprot) != pgprot_val(ref_prot)) {
+			BUG_ON(page_private(kpte_page) <= 0);
+			page_private(kpte_page)--;
+		}
 		set_pte(kpte, pfn_pte(pfn, ref_prot));
-		BUG_ON(page_private(kpte_page) == 0);
-		page_private(kpte_page)--;
 	} else {
 		/*
 		 * When you're here you either did set the same page to PAGE_KERNEL
Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -151,20 +151,16 @@ static void set_pmd_pte(pte_t *kpte, uns
  * No more special protections in this 2/4MB area - revert to a
  * large page again. 
  */
-static inline void revert_page(struct page *kpte_page, unsigned long address)
+static void
+revert_page(struct page *kpte_page, unsigned long address, pgprot_t ref_prot)
 {
-	pgprot_t ref_prot;
 	pte_t *linear;
 
-	ref_prot =
-	((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
-		? PAGE_KERNEL_LARGE_EXEC : PAGE_KERNEL_LARGE;
-
 	linear = (pte_t *)
 		pmd_offset(pud_offset(pgd_offset_k(address), address), address);
 	set_pmd_pte(linear,  address,
-		    pfn_pte((__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT,
-			    ref_prot));
+		    pte_mkhuge(pfn_pte((__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT,
+			    ref_prot)));
 }
 
 static inline void save_page(struct page *kpte_page)
@@ -223,6 +219,8 @@ __change_page_attr(struct page *page, pg
 	unsigned long address;
 	struct page *kpte_page;
 	int level;
+	pgprot_t oldprot;
+	pgprot_t ref_prot = PAGE_KERNEL;
 
 	BUG_ON(PageHighMem(page));
 	address = (unsigned long)page_address(page);
@@ -230,6 +228,8 @@ __change_page_attr(struct page *page, pg
 	kpte = lookup_address(address, &level);
 	if (!kpte)
 		return -EINVAL;
+
+	oldprot = pte_pgprot(*kpte);
 	kpte_page = virt_to_page(kpte);
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
@@ -237,27 +237,29 @@ __change_page_attr(struct page *page, pg
 	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level),
 			level < 3);
 
+	if ((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
+		ref_prot = PAGE_KERNEL_EXEC;
+
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (level == 3) {
+			if (pgprot_val(oldprot) == pgprot_val(ref_prot))
+				page_private(kpte_page)++;
 			set_pte_atomic(kpte, mk_pte(page, prot)); 
 		} else {
-			pgprot_t ref_prot;
 			struct page *split;
-
-			ref_prot =
-			((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
-				? PAGE_KERNEL_EXEC : PAGE_KERNEL;
 			split = split_large_page(address, prot, ref_prot);
 			if (!split)
 				return -ENOMEM;
 			set_pmd_pte(kpte,address,mk_pte(split, ref_prot));
 			kpte_page = split;
+			page_private(kpte_page)++;
 		}
-		page_private(kpte_page)++;
 	} else if (level == 3) {
+		if (pgprot_val(oldprot) != pgprot_val(ref_prot)) {
+			BUG_ON(page_private(kpte_page) <= 0);
+			page_private(kpte_page)--;
+		}
 		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
-		BUG_ON(page_private(kpte_page) == 0);
-		page_private(kpte_page)--;
 	} else {
 		/*
 		 * When you're here you either did set the same page to PAGE_KERNEL
@@ -279,7 +281,7 @@ __change_page_attr(struct page *page, pg
 		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
 			save_page(kpte_page);
 			paravirt_release_pt(page_to_pfn(kpte_page));
-			revert_page(kpte_page, address);
+			revert_page(kpte_page, address, ref_prot);
 		}
 	}
 	return 0;
