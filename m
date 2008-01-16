Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbYAPW0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbYAPW0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:26:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbYAPWPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:38296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbYAPWPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:32 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [31/36] CPA: Fix reference counting when changing already changed pages
Message-Id: <20080116221531.5BFAF150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When changing a page that has already been modified to non standard attributes
before don't change the reference count. And when changing back a page
only decrease the ref count if the old attributes were non standard.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/pageattr_32.c |   44 +++++++++++++++++++++++++-------------------
 arch/x86/mm/pageattr_64.c |   16 ++++++++++++----
 include/asm-x86/pgtable.h |    2 ++
 3 files changed, 39 insertions(+), 23 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -206,20 +206,26 @@ __change_page_attr(unsigned long address
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
 
 	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level),
 			level < 4);
 
+	ref_prot = canon_pgprot(ref_prot);
+	prot = canon_pgprot(prot);
+
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (level == 4) {
+			if (pgprot_val(oldprot) == pgprot_val(ref_prot))
+				page_private(kpte_page)++;
 			set_pte(kpte, pfn_pte(pfn, prot));
 		} else {
 			/*
@@ -234,12 +240,14 @@ __change_page_attr(unsigned long address
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
 		 * When you're here you either set the same page to PAGE_KERNEL
Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -151,20 +151,17 @@ static void set_pmd_pte(pte_t *kpte, uns
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
+		    pte_mkhuge(pfn_pte((__pa(address) & LARGE_PAGE_MASK)
+					>> PAGE_SHIFT,
+			    ref_prot)));
 }
 
 static inline void save_page(struct page *kpte_page)
@@ -223,6 +220,8 @@ __change_page_attr(struct page *page, pg
 	unsigned long address;
 	struct page *kpte_page;
 	int level;
+	pgprot_t oldprot;
+	pgprot_t ref_prot = PAGE_KERNEL;
 
 	BUG_ON(PageHighMem(page));
 	address = (unsigned long)page_address(page);
@@ -230,6 +229,8 @@ __change_page_attr(struct page *page, pg
 	kpte = lookup_address(address, &level);
 	if (!kpte)
 		return -EINVAL;
+
+	oldprot = pte_pgprot(*kpte);
 	kpte_page = virt_to_page(kpte);
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
@@ -237,27 +238,32 @@ __change_page_attr(struct page *page, pg
 	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level),
 			level < 3);
 
-	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
+	if ((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
+		ref_prot = PAGE_KERNEL_EXEC;
+
+	ref_prot = canon_pgprot(ref_prot);
+	prot = canon_pgprot(prot);
+
+	if (pgprot_val(prot) != pgprot_val(ref_prot)) {
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
-		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
-		BUG_ON(page_private(kpte_page) == 0);
-		page_private(kpte_page)--;
+		if (pgprot_val(oldprot) != pgprot_val(ref_prot)) {
+			BUG_ON(page_private(kpte_page) <= 0);
+			page_private(kpte_page)--;
+		}
+		set_pte_atomic(kpte, mk_pte(page, ref_prot));
 	} else {
 		/*
 		 * When you're here you either set the same page to PAGE_KERNEL
@@ -279,7 +285,7 @@ __change_page_attr(struct page *page, pg
 		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
 			save_page(kpte_page);
 			paravirt_release_pt(page_to_pfn(kpte_page));
-			revert_page(kpte_page, address);
+			revert_page(kpte_page, address, ref_prot);
 		}
 	}
 	return 0;
Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -201,6 +201,8 @@ static inline pte_t pte_modify(pte_t pte
 
 #define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
 
+#define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
