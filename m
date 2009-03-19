Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbZCSV4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbZCSV4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759128AbZCSVzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:55:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:61334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291AbZCSVz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,391,1233561600"; 
   d="scan'208";a="674391769"
Message-Id: <20090319215358.901545000@intel.com>
References: <20090319215112.636641000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 14:51:15 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com
Cc: arjan@infradead.org, eric@anholt.net, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 3/3] x86, CPA: Add set_pages_arrayuc and set_pages_array_wb
Content-Disposition: inline; filename=set_pages_array_modified.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new interfaces
set_pages_array_uc()
set_pages_array_wb()
that can be used change the page attribute for a bunch of pages with flush etc
done once at the end of all the changes. These interfaces are similar to
existing set_memory_array_uc() and set_memory_array_wc().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/include/asm/cacheflush.h |    3 +
 arch/x86/mm/pageattr.c            |   63 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2009-03-17 11:03:51.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2009-03-17 11:04:08.000000000 -0700
@@ -919,6 +919,20 @@ static inline int change_page_attr_clear
 		(array ? CPA_ARRAY : 0), NULL);
 }
 
+static inline int cpa_set_pages_array(struct page **pages, int numpages,
+				       pgprot_t mask)
+{
+	return change_page_attr_set_clr(NULL, numpages, mask, __pgprot(0), 0,
+		CPA_PAGES_ARRAY, pages);
+}
+
+static inline int cpa_clear_pages_array(struct page **pages, int numpages,
+					 pgprot_t mask)
+{
+	return change_page_attr_set_clr(NULL, numpages, __pgprot(0), mask, 0,
+		CPA_PAGES_ARRAY, pages);
+}
+
 int _set_memory_uc(unsigned long addr, int numpages)
 {
 	/*
@@ -1075,6 +1089,35 @@ int set_pages_uc(struct page *page, int 
 }
 EXPORT_SYMBOL(set_pages_uc);
 
+int set_pages_array_uc(struct page **pages, int addrinarray)
+{
+	unsigned long start;
+	unsigned long end;
+	int i;
+	int free_idx;
+
+	for (i = 0; i < addrinarray; i++) {
+		start = (unsigned long)page_address(pages[i]);
+		end = start + PAGE_SIZE;
+		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
+			goto err_out;
+	}
+
+	if (cpa_set_pages_array(pages, addrinarray,
+			__pgprot(_PAGE_CACHE_UC_MINUS)) == 0) {
+		return 0; /* Success */
+	}
+err_out:
+	free_idx = i;
+	for (i = 0; i < free_idx; i++) {
+		start = (unsigned long)page_address(pages[i]);
+		end = start + PAGE_SIZE;
+		free_memtype(start, end);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(set_pages_array_uc);
+
 int set_pages_wb(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
@@ -1083,6 +1126,26 @@ int set_pages_wb(struct page *page, int 
 }
 EXPORT_SYMBOL(set_pages_wb);
 
+int set_pages_array_wb(struct page **pages, int addrinarray)
+{
+	int retval;
+	unsigned long start;
+	unsigned long end;
+	int i;
+
+	retval = cpa_clear_pages_array(pages, addrinarray,
+			__pgprot(_PAGE_CACHE_MASK));
+
+	for (i = 0; i < addrinarray; i++) {
+		start = (unsigned long)page_address(pages[i]);
+		end = start + PAGE_SIZE;
+		free_memtype(start, end);
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(set_pages_array_wb);
+
 int set_pages_x(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
Index: tip/arch/x86/include/asm/cacheflush.h
===================================================================
--- tip.orig/arch/x86/include/asm/cacheflush.h	2009-03-13 11:51:31.000000000 -0700
+++ tip/arch/x86/include/asm/cacheflush.h	2009-03-17 11:04:08.000000000 -0700
@@ -90,6 +90,9 @@ int set_memory_4k(unsigned long addr, in
 int set_memory_array_uc(unsigned long *addr, int addrinarray);
 int set_memory_array_wb(unsigned long *addr, int addrinarray);
 
+int set_pages_array_uc(struct page **pages, int addrinarray);
+int set_pages_array_wb(struct page **pages, int addrinarray);
+
 /*
  * For legacy compatibility with the old APIs, a few functions
  * are provided that work on a "struct page".

-- 

