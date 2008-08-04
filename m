Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbYHDGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbYHDGnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbYHDGmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:42:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:15650 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758819AbYHDGmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:42:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,303,1215414000"; 
   d="scan'208";a="367642621"
Subject: [patch 1/2] introduce two APIs for page attribute
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: airlied@linux.ie, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 14:51:24 +0800
Message-Id: <1217832684.21811.8.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce two APIs for page attribute. flushing tlb/cache in every page
attribute is expensive. AGP gart usually will do a lot of operations to
change a page to uc, new APIs can reduce flush.

Signed-off-by: Shaohua Li <shaohua.li@intel.com> 
---
 arch/x86/mm/pageattr.c       |   58 +++++++++++++++++++++++++++++++++++++------
 include/asm-x86/cacheflush.h |    3 ++
 2 files changed, 53 insertions(+), 8 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c	2008-08-04 11:58:41.000000000 +0800
+++ linux/arch/x86/mm/pageattr.c	2008-08-04 12:04:58.000000000 +0800
@@ -752,12 +752,12 @@ static inline int cache_attr(pgprot_t at
 		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
 }
 
-static int change_page_attr_set_clr(unsigned long addr, int numpages,
+static int do_change_page_attr_set_clr(unsigned long addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split)
+				    int force_split, int *tlb_flush)
 {
 	struct cpa_data cpa;
-	int ret, cache, checkalias;
+	int ret, checkalias;
 
 	/*
 	 * Check, if we are requested to change a not supported
@@ -792,9 +792,22 @@ static int change_page_attr_set_clr(unsi
 	/*
 	 * Check whether we really changed something:
 	 */
-	if (!cpa.flushtlb)
-		goto out;
+	*tlb_flush = cpa.flushtlb;
+	cpa_fill_pool(NULL);
+
+	return ret;
+}
+
+static int change_page_attr_set_clr(unsigned long addr, int numpages,
+				    pgprot_t mask_set, pgprot_t mask_clr,
+				    int force_split)
+{
+	int cache, flush_cache = 0, ret;
 
+	ret = do_change_page_attr_set_clr(addr, numpages, mask_set, mask_clr,
+		force_split, &flush_cache);
+	if (!flush_cache)
+		goto out;
 	/*
 	 * No need to flush, when we did not set any of the caching
 	 * attributes:
@@ -811,10 +824,7 @@ static int change_page_attr_set_clr(unsi
 		cpa_flush_range(addr, numpages, cache);
 	else
 		cpa_flush_all(cache);
-
 out:
-	cpa_fill_pool(NULL);
-
 	return ret;
 }
 
@@ -852,6 +862,30 @@ int set_memory_uc(unsigned long addr, in
 }
 EXPORT_SYMBOL(set_memory_uc);
 
+int set_memory_uc_noflush(unsigned long addr, int numpages)
+{
+	int flush;
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
+	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+			    _PAGE_CACHE_UC_MINUS, NULL))
+		return -EINVAL;
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
+	return do_change_page_attr_set_clr(addr, numpages,
+				    __pgprot(_PAGE_CACHE_UC_MINUS),
+					__pgprot(0), 0, &flush);
+}
+EXPORT_SYMBOL(set_memory_uc_noflush);
+
+void set_memory_flush_all(void)
+{
+	cpa_flush_all(1);
+}
+EXPORT_SYMBOL(set_memory_flush_all);
+
 int _set_memory_wc(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(addr, numpages,
@@ -926,6 +960,14 @@ int set_pages_uc(struct page *page, int 
 }
 EXPORT_SYMBOL(set_pages_uc);
 
+int set_pages_uc_noflush(struct page *page, int numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+
+	return set_memory_uc_noflush(addr, numpages);
+}
+EXPORT_SYMBOL(set_pages_uc_noflush);
+
 int set_pages_wb(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
Index: linux/include/asm-x86/cacheflush.h
===================================================================
--- linux.orig/include/asm-x86/cacheflush.h	2008-08-04 11:58:41.000000000 +0800
+++ linux/include/asm-x86/cacheflush.h	2008-08-04 12:05:16.000000000 +0800
@@ -57,6 +57,8 @@ int _set_memory_uc(unsigned long addr, i
 int _set_memory_wc(unsigned long addr, int numpages);
 int _set_memory_wb(unsigned long addr, int numpages);
 int set_memory_uc(unsigned long addr, int numpages);
+int set_memory_uc_noflush(unsigned long addr, int numpages);
+void set_memory_flush_all(void);
 int set_memory_wc(unsigned long addr, int numpages);
 int set_memory_wb(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
@@ -87,6 +89,7 @@ int set_memory_4k(unsigned long addr, in
  */
 
 int set_pages_uc(struct page *page, int numpages);
+int set_pages_uc_noflush(struct page *page, int numpages);
 int set_pages_wb(struct page *page, int numpages);
 int set_pages_x(struct page *page, int numpages);
 int set_pages_nx(struct page *page, int numpages);


