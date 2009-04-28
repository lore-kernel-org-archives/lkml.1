Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbZD1Bvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbZD1Bvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbZD1BvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:51:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:9251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbZD1BvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:51:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,257,1239001200"; 
   d="scan'208";a="136585593"
Message-Id: <20090428014920.517605197@intel.com>
References: <20090428010907.912554629@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Apr 2009 09:09:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 3/5] mm: introduce PageHuge() for testing huge/gigantic pages
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

--- mm.orig/mm/page_alloc.c
+++ mm/mm/page_alloc.c
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
--- mm.orig/mm/hugetlb.c
+++ mm/mm/hugetlb.c
@@ -550,7 +550,7 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
-static void free_huge_page(struct page *page)
+void free_huge_page(struct page *page)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
--- mm.orig/include/linux/mm.h
+++ mm/include/linux/mm.h
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

