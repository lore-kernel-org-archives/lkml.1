Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYAJS4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYAJS4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYAJSzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:55:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:4583 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656AbYAJSzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:55:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="320739379"
Message-Id: <20080110184855.677758000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:46 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 06/11] PAT x86: Refactoring i386 cpa
Content-Disposition: inline; filename=cpa_i386.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes 32 bit cpa similar to x86_64 and makes it easier for following PAT
patches.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6.git/arch/x86/mm/pageattr_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/pageattr_32.c	2008-01-08 04:05:24.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/pageattr_32.c	2008-01-08 05:10:44.000000000 -0800
@@ -153,15 +153,12 @@
 		list_add(&kpte_page->lru, &df_list);
 }
 
-static int __change_page_attr(struct page *page, pgprot_t prot)
+static int __change_page_attr(unsigned long address, unsigned long pfn,
+                              pgprot_t prot)
 {
 	struct page *kpte_page;
-	unsigned long address;
 	pte_t *kpte;
 
-	BUG_ON(PageHighMem(page));
-	address = (unsigned long)page_address(page);
-
 	kpte = lookup_address(address);
 	if (!kpte)
 		return -EINVAL;
@@ -172,7 +169,7 @@
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) {
 		if (!pte_huge(*kpte)) {
-			set_pte_atomic(kpte, mk_pte(page, prot));
+			set_pte_atomic(kpte, pfn_pte(pfn, prot));
 		} else {
 			struct page *split;
 			pgprot_t ref_prot;
@@ -190,7 +187,7 @@
 		page_private(kpte_page)++;
 	} else {
 		if (!pte_huge(*kpte)) {
-			set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
+			set_pte_atomic(kpte, pfn_pte(pfn, PAGE_KERNEL));
 			BUG_ON(page_private(kpte_page) == 0);
 			page_private(kpte_page)--;
 		} else
@@ -231,14 +228,15 @@
  *
  * Caller must call global_flush_tlb() after this.
  */
-int change_page_attr(struct page *page, int numpages, pgprot_t prot)
+int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
 {
 	unsigned long flags;
 	int err = 0, i;
 
 	spin_lock_irqsave(&cpa_lock, flags);
-	for (i = 0; i < numpages; i++, page++) {
-		err = __change_page_attr(page, prot);
+	for (i = 0; i < numpages; i++, address += PAGE_SIZE) {
+		unsigned long pfn = __pa(address) >> PAGE_SHIFT;
+		err = __change_page_attr(address, pfn, prot);
 		if (err)
 			break;
 	}
@@ -248,6 +246,12 @@
 }
 EXPORT_SYMBOL(change_page_attr);
 
+int change_page_attr(struct page *page, int numpages, pgprot_t prot)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	return change_page_attr_addr(addr, numpages, prot);
+}
+
 void global_flush_tlb(void)
 {
 	struct page *pg, *next;

-- 
