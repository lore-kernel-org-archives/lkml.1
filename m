Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbZEGBwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbZEGBwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbZEGBum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:50:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:40036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761538AbZEGBuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:50:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,305,1239001200"; 
   d="scan'208";a="140041826"
Message-Id: <20090507014913.938962777@intel.com>
References: <20090507012116.996644836@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 May 2009 09:21:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, <linux-mm@kvack.org>
Subject: [PATCH 1/7] mm: introduce PageHuge() for testing huge/gigantic pages
Content-Disposition: inline; filename=giga-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce PageHuge(), which identifies huge/gigantic pages
by their dedicated compound destructor functions.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/mm.h |   24 ++++++++++++++++++++++++
 mm/hugetlb.c       |    2 +-
 mm/page_alloc.c    |   11 ++++++++++-
 3 files changed, 35 insertions(+), 2 deletions(-)

--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -299,13 +299,22 @@ void prep_compound_page(struct page *pag
 }
 
 #ifdef CONFIG_HUGETLBFS
+/*
+ * This (duplicated) destructor function distinguishes gigantic pages from
+ * normal compound pages.
+ */
+void free_gigantic_page(struct page *page)
+{
+	__free_pages_ok(page, compound_order(page));
+}
+
 void prep_compound_gigantic_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
 	struct page *p = page + 1;
 
-	set_compound_page_dtor(page, free_compound_page);
+	set_compound_page_dtor(page, free_gigantic_page);
 	set_compound_order(page, order);
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -550,7 +550,7 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
-static void free_huge_page(struct page *page)
+void free_huge_page(struct page *page)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -355,6 +355,30 @@ static inline void set_compound_order(st
 	page[1].lru.prev = (void *)order;
 }
 
+#ifdef CONFIG_HUGETLBFS
+void free_huge_page(struct page *page);
+void free_gigantic_page(struct page *page);
+
+static inline int PageHuge(struct page *page)
+{
+	compound_page_dtor *dtor;
+
+	if (!PageCompound(page))
+		return 0;
+
+	page = compound_head(page);
+	dtor = get_compound_page_dtor(page);
+
+	return  dtor == free_huge_page ||
+		dtor == free_gigantic_page;
+}
+#else
+static inline int PageHuge(struct page *page)
+{
+	return 0;
+}
+#endif
+
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of

-- 

