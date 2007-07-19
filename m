Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbXGSJzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbXGSJzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXGSJyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXGSJyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:46 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/58] x86: Always flush pages in change_page_attr
Message-Id: <20070719095444.CFAB114E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a bug introduced with the CLFLUSH changes: we must always flush pages
changed in cpa(), not just when they are reverted.

Reenable CLFLUSH usage with that now (it was temporarily disabled
for .22) 

Add some BUG_ONs

Contains fixes from  Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c   |   20 +++++++++++++++++---
 arch/x86_64/mm/pageattr.c |   23 ++++++++++++++---------
 2 files changed, 31 insertions(+), 12 deletions(-)

Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -74,14 +74,12 @@ static void flush_kernel_map(void *arg)
 	struct page *pg;
 
 	/* When clflush is available always use it because it is
-	   much cheaper than WBINVD. Disable clflush for now because
-	   the high level code is not ready yet */
-	if (1 || !cpu_has_clflush)
+	   much cheaper than WBINVD. */
+	if (!cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
-		if (cpu_has_clflush)
-			cache_flush_page(adr);
+		cache_flush_page(adr);
 	}
 	__flush_tlb_all();
 }
@@ -95,7 +93,8 @@ static LIST_HEAD(deferred_pages); /* pro
 
 static inline void save_page(struct page *fpage)
 {
-	list_add(&fpage->lru, &deferred_pages);
+	if (!test_and_set_bit(PG_arch_1, &fpage->flags))
+		list_add(&fpage->lru, &deferred_pages);
 }
 
 /* 
@@ -129,9 +128,12 @@ __change_page_attr(unsigned long address
 	pte_t *kpte; 
 	struct page *kpte_page;
 	pgprot_t ref_prot2;
+
 	kpte = lookup_address(address);
 	if (!kpte) return 0;
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
+	BUG_ON(PageLRU(kpte_page));
+	BUG_ON(PageCompound(kpte_page));
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (!pte_huge(*kpte)) {
 			set_pte(kpte, pfn_pte(pfn, prot));
@@ -159,10 +161,9 @@ __change_page_attr(unsigned long address
 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
  	BUG_ON(PageReserved(kpte_page));
 
-	if (page_private(kpte_page) == 0) {
-		save_page(kpte_page);
+	save_page(kpte_page);
+	if (page_private(kpte_page) == 0)
 		revert_page(address, ref_prot);
- 	}
 	return 0;
 } 
 
@@ -234,6 +235,10 @@ void global_flush_tlb(void)
 	flush_map(&l);
 
 	list_for_each_entry_safe(pg, next, &l, lru) {
+		list_del(&pg->lru);
+		clear_bit(PG_arch_1, &pg->flags);
+		if (page_private(pg) != 0)
+			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);
 	} 
Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -82,7 +82,7 @@ static void flush_kernel_map(void *arg)
 	struct page *p;
 
 	/* High level code is not ready for clflush yet */
-	if (0 && cpu_has_clflush) {
+	if (cpu_has_clflush) {
 		list_for_each_entry (p, lh, lru)
 			cache_flush_page(p);
 	} else if (boot_cpu_data.x86_model >= 4)
@@ -136,6 +136,12 @@ static inline void revert_page(struct pa
 			    ref_prot));
 }
 
+static inline void save_page(struct page *kpte_page)
+{
+	if (!test_and_set_bit(PG_arch_1, &kpte_page->flags))
+		list_add(&kpte_page->lru, &df_list);
+}
+
 static int
 __change_page_attr(struct page *page, pgprot_t prot)
 { 
@@ -150,6 +156,9 @@ __change_page_attr(struct page *page, pg
 	if (!kpte)
 		return -EINVAL;
 	kpte_page = virt_to_page(kpte);
+	BUG_ON(PageLRU(kpte_page));
+	BUG_ON(PageCompound(kpte_page));
+
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (!pte_huge(*kpte)) {
 			set_pte_atomic(kpte, mk_pte(page, prot)); 
@@ -179,11 +188,11 @@ __change_page_attr(struct page *page, pg
 	 * time (not via split_large_page) and in turn we must not
 	 * replace it with a largepage.
 	 */
+
+	save_page(kpte_page);
 	if (!PageReserved(kpte_page)) {
 		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
-			ClearPagePrivate(kpte_page);
 			paravirt_release_pt(page_to_pfn(kpte_page));
-			list_add(&kpte_page->lru, &df_list);
 			revert_page(kpte_page, address);
 		}
 	}
@@ -236,6 +245,11 @@ void global_flush_tlb(void)
 	spin_unlock_irq(&cpa_lock);
 	flush_map(&l);
 	list_for_each_entry_safe(pg, next, &l, lru) {
+		list_del(&pg->lru);
+		clear_bit(PG_arch_1, &pg->flags);
+		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
+			continue;
+		ClearPagePrivate(pg);
 		__free_page(pg);
 	}
 }
