Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYACPZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYACPZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYACPYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:24 -0500
Received: from mail.suse.de ([195.135.220.2]:46741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYACPYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:22 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [6/28] CPA: Undo white space changes
Message-Id: <20080103152420.5ACFA14E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Undo random white space changes. This reverts ddb53b5735793a19dc17bcd98b050f672f28f1ea

I simply don't have the nerves to port a 20+ patch series to the 
reformatted version.  And the patch series changes most lines
anyways and drops the trailing white spaces there.

And since this was a nop losing it for now isn't a problem.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |  151 ++++++++++++++++++++--------------------------
 arch/x86/mm/pageattr_64.c |  143 ++++++++++++++++++-------------------------
 2 files changed, 130 insertions(+), 164 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -1,29 +1,28 @@
-/*
- * Copyright 2002 Andi Kleen, SuSE Labs.
+/* 
+ * Copyright 2002 Andi Kleen, SuSE Labs. 
  * Thanks to Ben LaHaise for precious feedback.
- */
+ */ 
 
+#include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/mm.h>
-
+#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
-#include <asm/sections.h>
-#include <asm/uaccess.h>
 #include <asm/pgalloc.h>
+#include <asm/sections.h>
 
 static DEFINE_SPINLOCK(cpa_lock);
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
 
-pte_t *lookup_address(unsigned long address)
-{
+
+pte_t *lookup_address(unsigned long address) 
+{ 
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
 	pmd_t *pmd;
-
 	if (pgd_none(*pgd))
 		return NULL;
 	pud = pud_offset(pgd, address);
@@ -34,22 +33,21 @@ pte_t *lookup_address(unsigned long addr
 		return NULL;
 	if (pmd_large(*pmd))
 		return (pte_t *)pmd;
+        return pte_offset_kernel(pmd, address);
+} 
 
-	return pte_offset_kernel(pmd, address);
-}
-
-static struct page *
-split_large_page(unsigned long address, pgprot_t prot, pgprot_t ref_prot)
-{
+static struct page *split_large_page(unsigned long address, pgprot_t prot,
+					pgprot_t ref_prot)
+{ 
+	int i; 
 	unsigned long addr;
 	struct page *base;
 	pte_t *pbase;
-	int i;
 
 	spin_unlock_irq(&cpa_lock);
 	base = alloc_pages(GFP_KERNEL, 0);
 	spin_lock_irq(&cpa_lock);
-	if (!base)
+	if (!base) 
 		return NULL;
 
 	/*
@@ -60,24 +58,22 @@ split_large_page(unsigned long address, 
 	page_private(base) = 0;
 
 	address = __pa(address);
-	addr = address & LARGE_PAGE_MASK;
+	addr = address & LARGE_PAGE_MASK; 
 	pbase = (pte_t *)page_address(base);
 	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
-
 	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE) {
-		set_pte(&pbase[i], pfn_pte(addr >> PAGE_SHIFT,
-					   addr == address ? prot : ref_prot));
+               set_pte(&pbase[i], pfn_pte(addr >> PAGE_SHIFT,
+                                          addr == address ? prot : ref_prot));
 	}
 	return base;
-}
+} 
 
 static void cache_flush_page(struct page *p)
-{
-	void *addr = page_address(p);
+{ 
+	void *adr = page_address(p);
 	int i;
-
 	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
-		clflush(addr + i);
+		clflush(adr+i);
 }
 
 static void flush_kernel_map(void *arg)
@@ -87,27 +83,23 @@ static void flush_kernel_map(void *arg)
 
 	/* High level code is not ready for clflush yet */
 	if (0 && cpu_has_clflush) {
-		list_for_each_entry(p, lh, lru)
+		list_for_each_entry (p, lh, lru)
 			cache_flush_page(p);
-	} else {
-		if (boot_cpu_data.x86_model >= 4)
-			wbinvd();
-	}
+	} else if (boot_cpu_data.x86_model >= 4)
+		wbinvd();
 
-	/*
-	 * Flush all to work around Errata in early athlons regarding
-	 * large page flushing.
+	/* Flush all to work around Errata in early athlons regarding 
+	 * large page flushing. 
 	 */
-	__flush_tlb_all();
+	__flush_tlb_all(); 	
 }
 
-static void set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
-{
-	unsigned long flags;
+static void set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte) 
+{ 
 	struct page *page;
+	unsigned long flags;
 
-	/* change init_mm */
-	set_pte_atomic(kpte, pte);
+	set_pte_atomic(kpte, pte); 	/* change init_mm */
 	if (SHARED_KERNEL_PMD)
 		return;
 
@@ -116,7 +108,6 @@ static void set_pmd_pte(pte_t *kpte, uns
 		pgd_t *pgd;
 		pud_t *pud;
 		pmd_t *pmd;
-
 		pgd = (pgd_t *)page_address(page) + pgd_index(address);
 		pud = pud_offset(pgd, address);
 		pmd = pmd_offset(pud, address);
@@ -125,9 +116,9 @@ static void set_pmd_pte(pte_t *kpte, uns
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
-/*
- * No more special protections in this 2/4MB area - revert to a large
- * page again.
+/* 
+ * No more special protections in this 2/4MB area - revert to a
+ * large page again. 
  */
 static inline void revert_page(struct page *kpte_page, unsigned long address)
 {
@@ -151,11 +142,12 @@ static inline void save_page(struct page
 		list_add(&kpte_page->lru, &df_list);
 }
 
-static int __change_page_attr(struct page *page, pgprot_t prot)
-{
-	struct page *kpte_page;
+static int
+__change_page_attr(struct page *page, pgprot_t prot)
+{ 
+	pte_t *kpte; 
 	unsigned long address;
-	pte_t *kpte;
+	struct page *kpte_page;
 
 	BUG_ON(PageHighMem(page));
 	address = (unsigned long)page_address(page);
@@ -163,17 +155,16 @@ static int __change_page_attr(struct pag
 	kpte = lookup_address(address);
 	if (!kpte)
 		return -EINVAL;
-
 	kpte_page = virt_to_page(kpte);
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
 
-	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) {
+	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (!pte_huge(*kpte)) {
-			set_pte_atomic(kpte, mk_pte(page, prot));
+			set_pte_atomic(kpte, mk_pte(page, prot)); 
 		} else {
-			struct page *split;
 			pgprot_t ref_prot;
+			struct page *split;
 
 			ref_prot =
 			((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
@@ -181,19 +172,16 @@ static int __change_page_attr(struct pag
 			split = split_large_page(address, prot, ref_prot);
 			if (!split)
 				return -ENOMEM;
-
-			set_pmd_pte(kpte, address, mk_pte(split, ref_prot));
+			set_pmd_pte(kpte,address,mk_pte(split, ref_prot));
 			kpte_page = split;
 		}
 		page_private(kpte_page)++;
-	} else {
-		if (!pte_huge(*kpte)) {
-			set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
-			BUG_ON(page_private(kpte_page) == 0);
-			page_private(kpte_page)--;
-		} else
-			BUG();
-	}
+	} else if (!pte_huge(*kpte)) {
+		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
+		BUG_ON(page_private(kpte_page) == 0);
+		page_private(kpte_page)--;
+	} else
+		BUG();
 
 	/*
 	 * If the pte was reserved, it means it was created at boot
@@ -209,7 +197,7 @@ static int __change_page_attr(struct pag
 		}
 	}
 	return 0;
-}
+} 
 
 static inline void flush_map(struct list_head *l)
 {
@@ -223,33 +211,32 @@ static inline void flush_map(struct list
  * than write-back somewhere - some CPUs do not like it when mappings with
  * different caching policies exist. This changes the page attributes of the
  * in kernel linear mapping too.
- *
+ * 
  * The caller needs to ensure that there are no conflicting mappings elsewhere.
  * This function only deals with the kernel linear map.
- *
+ * 
  * Caller must call global_flush_tlb() after this.
  */
 int change_page_attr(struct page *page, int numpages, pgprot_t prot)
 {
+	int err = 0; 
+	int i; 
 	unsigned long flags;
-	int err = 0, i;
 
 	spin_lock_irqsave(&cpa_lock, flags);
-	for (i = 0; i < numpages; i++, page++) {
+	for (i = 0; i < numpages; i++, page++) { 
 		err = __change_page_attr(page, prot);
-		if (err)
-			break;
-	}
+		if (err) 
+			break; 
+	} 	
 	spin_unlock_irqrestore(&cpa_lock, flags);
-
 	return err;
 }
-EXPORT_SYMBOL(change_page_attr);
 
 void global_flush_tlb(void)
 {
-	struct page *pg, *next;
 	struct list_head l;
+	struct page *pg, *next;
 
 	BUG_ON(irqs_disabled());
 
@@ -266,28 +253,26 @@ void global_flush_tlb(void)
 		__free_page(pg);
 	}
 }
-EXPORT_SYMBOL(global_flush_tlb);
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
-	if (!enable) {
+	if (!enable)
 		debug_check_no_locks_freed(page_address(page),
 					   numpages * PAGE_SIZE);
-	}
 
-	/*
-	 * the return value is ignored - the calls cannot fail,
+	/* the return value is ignored - the calls cannot fail,
 	 * large pages are disabled at boot time.
 	 */
 	change_page_attr(page, numpages, enable ? PAGE_KERNEL : __pgprot(0));
-
-	/*
-	 * we should perform an IPI and flush all tlbs,
+	/* we should perform an IPI and flush all tlbs,
 	 * but that can deadlock->flush only current cpu.
 	 */
 	__flush_tlb_all();
 }
 #endif
+
+EXPORT_SYMBOL(change_page_attr);
+EXPORT_SYMBOL(global_flush_tlb);
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -1,54 +1,48 @@
-/*
- * Copyright 2002 Andi Kleen, SuSE Labs.
+/* 
+ * Copyright 2002 Andi Kleen, SuSE Labs. 
  * Thanks to Ben LaHaise for precious feedback.
- */
+ */ 
 
+#include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/mm.h>
-
+#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
-#include <asm/uaccess.h>
 #include <asm/io.h>
 
 pte_t *lookup_address(unsigned long address)
-{
+{ 
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
-
 	if (pgd_none(*pgd))
 		return NULL;
 	pud = pud_offset(pgd, address);
 	if (!pud_present(*pud))
-		return NULL;
+		return NULL; 
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
-		return NULL;
+		return NULL; 
 	if (pmd_large(*pmd))
 		return (pte_t *)pmd;
-
 	pte = pte_offset_kernel(pmd, address);
 	if (pte && !pte_present(*pte))
-		pte = NULL;
-
+		pte = NULL; 
 	return pte;
-}
+} 
 
-static struct page *
-split_large_page(unsigned long address, pgprot_t prot, pgprot_t ref_prot)
-{
+static struct page *split_large_page(unsigned long address, pgprot_t prot,
+				     pgprot_t ref_prot)
+{ 
+	int i; 
 	unsigned long addr;
-	struct page *base;
+	struct page *base = alloc_pages(GFP_KERNEL, 0);
 	pte_t *pbase;
-	int i;
-
-	base = alloc_pages(GFP_KERNEL, 0);
-	if (!base)
+	if (!base) 
 		return NULL;
 	/*
 	 * page_private is used to track the number of entries in
@@ -58,21 +52,20 @@ split_large_page(unsigned long address, 
 	page_private(base) = 0;
 
 	address = __pa(address);
-	addr = address & LARGE_PAGE_MASK;
+	addr = address & LARGE_PAGE_MASK; 
 	pbase = (pte_t *)page_address(base);
 	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE) {
-		pbase[i] = pfn_pte(addr >> PAGE_SHIFT,
+		pbase[i] = pfn_pte(addr >> PAGE_SHIFT, 
 				   addr == address ? prot : ref_prot);
 	}
 	return base;
-}
+} 
 
-void clflush_cache_range(void *addr, int size)
+void clflush_cache_range(void *adr, int size)
 {
 	int i;
-
 	for (i = 0; i < size; i += boot_cpu_data.x86_clflush_size)
-		clflush(addr+i);
+		clflush(adr+i);
 }
 
 static void flush_kernel_map(void *arg)
@@ -83,20 +76,17 @@ static void flush_kernel_map(void *arg)
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
 	/* clflush is still broken. Disable for now. */
-	if (1 || !cpu_has_clflush) {
+	if (1 || !cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
-	} else {
-		list_for_each_entry(pg, l, lru) {
-			void *addr = page_address(pg);
-
-			clflush_cache_range(addr, PAGE_SIZE);
-		}
+	else list_for_each_entry(pg, l, lru) {
+		void *adr = page_address(pg);
+		clflush_cache_range(adr, PAGE_SIZE);
 	}
 	__flush_tlb_all();
 }
 
 static inline void flush_map(struct list_head *l)
-{
+{	
 	on_each_cpu(flush_kernel_map, l, 1, 1);
 }
 
@@ -108,56 +98,52 @@ static inline void save_page(struct page
 		list_add(&fpage->lru, &deferred_pages);
 }
 
-/*
+/* 
  * No more special protections in this 2/4MB area - revert to a
- * large page again.
+ * large page again. 
  */
 static void revert_page(unsigned long address, pgprot_t ref_prot)
 {
-	unsigned long pfn;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t large_pte;
+	unsigned long pfn;
 
 	pgd = pgd_offset_k(address);
 	BUG_ON(pgd_none(*pgd));
-	pud = pud_offset(pgd, address);
+	pud = pud_offset(pgd,address);
 	BUG_ON(pud_none(*pud));
 	pmd = pmd_offset(pud, address);
 	BUG_ON(pmd_val(*pmd) & _PAGE_PSE);
 	pfn = (__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT;
 	large_pte = pfn_pte(pfn, ref_prot);
 	large_pte = pte_mkhuge(large_pte);
-
 	set_pte((pte_t *)pmd, large_pte);
-}
+}      
 
 static int
 __change_page_attr(unsigned long address, unsigned long pfn, pgprot_t prot,
-		   pgprot_t ref_prot)
-{
+				   pgprot_t ref_prot)
+{ 
+	pte_t *kpte; 
 	struct page *kpte_page;
 	pgprot_t ref_prot2;
-	pte_t *kpte;
 
 	kpte = lookup_address(address);
-	if (!kpte)
-		return 0;
-
+	if (!kpte) return 0;
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
-	if (pgprot_val(prot) != pgprot_val(ref_prot)) {
+	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (!pte_huge(*kpte)) {
 			set_pte(kpte, pfn_pte(pfn, prot));
 		} else {
-			/*
+ 			/*
 			 * split_large_page will take the reference for this
 			 * change_page_attr on the split page.
-			 */
+ 			 */
 			struct page *split;
-
 			ref_prot2 = pte_pgprot(pte_clrhuge(*kpte));
 			split = split_large_page(address, prot, ref_prot2);
 			if (!split)
@@ -167,23 +153,21 @@ __change_page_attr(unsigned long address
 			kpte_page = split;
 		}
 		page_private(kpte_page)++;
-	} else {
-		if (!pte_huge(*kpte)) {
-			set_pte(kpte, pfn_pte(pfn, ref_prot));
-			BUG_ON(page_private(kpte_page) == 0);
-			page_private(kpte_page)--;
-		} else
-			BUG();
-	}
+	} else if (!pte_huge(*kpte)) {
+		set_pte(kpte, pfn_pte(pfn, ref_prot));
+		BUG_ON(page_private(kpte_page) == 0);
+		page_private(kpte_page)--;
+	} else
+		BUG();
 
 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
-	BUG_ON(PageReserved(kpte_page));
+ 	BUG_ON(PageReserved(kpte_page));
 
 	save_page(kpte_page);
 	if (page_private(kpte_page) == 0)
 		revert_page(address, ref_prot);
 	return 0;
-}
+} 
 
 /*
  * Change the page attributes of an page in the linear mapping.
@@ -192,19 +176,19 @@ __change_page_attr(unsigned long address
  * than write-back somewhere - some CPUs do not like it when mappings with
  * different caching policies exist. This changes the page attributes of the
  * in kernel linear mapping too.
- *
+ * 
  * The caller needs to ensure that there are no conflicting mappings elsewhere.
  * This function only deals with the kernel linear map.
- *
+ * 
  * Caller must call global_flush_tlb() after this.
  */
 int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
 {
-	int err = 0, kernel_map = 0, i;
-
-	if (address >= __START_KERNEL_map &&
-			address < __START_KERNEL_map + KERNEL_TEXT_SIZE) {
+	int err = 0, kernel_map = 0;
+	int i; 
 
+	if (address >= __START_KERNEL_map
+	    && address < __START_KERNEL_map + KERNEL_TEXT_SIZE) {
 		address = (unsigned long)__va(__pa(address));
 		kernel_map = 1;
 	}
@@ -214,8 +198,7 @@ int change_page_attr_addr(unsigned long 
 		unsigned long pfn = __pa(address) >> PAGE_SHIFT;
 
 		if (!kernel_map || pte_present(pfn_pte(0, prot))) {
-			err = __change_page_attr(address, pfn, prot,
-						PAGE_KERNEL);
+			err = __change_page_attr(address, pfn, prot, PAGE_KERNEL);
 			if (err)
 				break;
 		}
@@ -224,16 +207,14 @@ int change_page_attr_addr(unsigned long 
 		if (__pa(address) < KERNEL_TEXT_SIZE) {
 			unsigned long addr2;
 			pgprot_t prot2;
-
 			addr2 = __START_KERNEL_map + __pa(address);
 			/* Make sure the kernel mappings stay executable */
 			prot2 = pte_pgprot(pte_mkexec(pfn_pte(0, prot)));
 			err = __change_page_attr(addr2, pfn, prot2,
 						 PAGE_KERNEL_EXEC);
-		}
-	}
-	up_write(&init_mm.mmap_sem);
-
+		} 
+	} 	
+	up_write(&init_mm.mmap_sem); 
 	return err;
 }
 
@@ -241,13 +222,11 @@ int change_page_attr_addr(unsigned long 
 int change_page_attr(struct page *page, int numpages, pgprot_t prot)
 {
 	unsigned long addr = (unsigned long)page_address(page);
-
 	return change_page_attr_addr(addr, numpages, prot);
 }
-EXPORT_SYMBOL(change_page_attr);
 
 void global_flush_tlb(void)
-{
+{ 
 	struct page *pg, *next;
 	struct list_head l;
 
@@ -269,6 +248,8 @@ void global_flush_tlb(void)
 			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);
-	}
-}
+	} 
+} 
+
+EXPORT_SYMBOL(change_page_attr);
 EXPORT_SYMBOL(global_flush_tlb);
