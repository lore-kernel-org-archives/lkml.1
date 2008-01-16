Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbYAPWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbYAPWPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYAPWPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:38179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYAPWPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:00 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [1/36] Undo pat cpa patch
Message-Id: <20080116221459.614B7150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:14:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Going to implement this differently

 commit 5ec5c5a2302ca8794da03f8bedec931a2a814ae9
 Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 Date:   Tue Jan 15 09:36:03 2008 +0100

    patches/x86-pat-cpa_i386.patch
    
    This makes 32 bit cpa similar to x86_64 and makes it easier for following PA
T
    patches.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -153,12 +153,15 @@ static inline void save_page(struct page
 		list_add(&kpte_page->lru, &df_list);
 }
 
-static int __change_page_attr(unsigned long address, unsigned long pfn,
-                              pgprot_t prot)
+static int __change_page_attr(struct page *page, pgprot_t prot)
 {
 	struct page *kpte_page;
+	unsigned long address;
 	pte_t *kpte;
 
+	BUG_ON(PageHighMem(page));
+	address = (unsigned long)page_address(page);
+
 	kpte = lookup_address(address);
 	if (!kpte)
 		return -EINVAL;
@@ -169,7 +172,7 @@ static int __change_page_attr(unsigned l
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) {
 		if (!pte_huge(*kpte)) {
-			set_pte_atomic(kpte, pfn_pte(pfn, prot));
+			set_pte_atomic(kpte, mk_pte(page, prot));
 		} else {
 			struct page *split;
 			pgprot_t ref_prot;
@@ -187,7 +190,7 @@ static int __change_page_attr(unsigned l
 		page_private(kpte_page)++;
 	} else {
 		if (!pte_huge(*kpte)) {
-			set_pte_atomic(kpte, pfn_pte(pfn, PAGE_KERNEL));
+			set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
 			BUG_ON(page_private(kpte_page) == 0);
 			page_private(kpte_page)--;
 		} else
@@ -228,15 +231,14 @@ static inline void flush_map(struct list
  *
  * Caller must call global_flush_tlb() after this.
  */
-int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
+int change_page_attr(struct page *page, int numpages, pgprot_t prot)
 {
 	unsigned long flags;
 	int err = 0, i;
 
 	spin_lock_irqsave(&cpa_lock, flags);
-	for (i = 0; i < numpages; i++, address += PAGE_SIZE) {
-		unsigned long pfn = __pa(address) >> PAGE_SHIFT;
-		err = __change_page_attr(address, pfn, prot);
+	for (i = 0; i < numpages; i++, page++) {
+		err = __change_page_attr(page, prot);
 		if (err)
 			break;
 	}
@@ -246,12 +248,6 @@ int change_page_attr_addr(unsigned long 
 }
 EXPORT_SYMBOL(change_page_attr);
 
-int change_page_attr(struct page *page, int numpages, pgprot_t prot)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	return change_page_attr_addr(addr, numpages, prot);
-}
-
 void global_flush_tlb(void)
 {
 	struct page *pg, *next;
