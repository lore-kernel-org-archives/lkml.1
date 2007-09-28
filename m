Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbXI1IFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbXI1IFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbXI1IBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653AbXI1IBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:46 -0400
Message-Id: <20070928080042.700553000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/12] mm: set_page_mapping()
Content-Disposition: inline; filename=set_page_mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wrap:
 	page->mapping = some_mapping;

because the lock class is dependent on page_mapping()

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/pagemap.h |    9 +++++++++
 mm/filemap.c            |    4 ++--
 mm/migrate.c            |    6 +++---
 3 files changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -199,6 +199,15 @@ static inline void unlock_page_check(str
 	__unlock_page_check(page, _RET_IP_);
 }
 
+static inline struct address_space *set_page_mapping(struct page *page,
+		struct address_space *mapping)
+{
+	__unlock_page_check(page, _RET_IP_);
+	page->mapping = mapping;
+	__lock_page_check(page, 0, _RET_IP_); /* XXX we lost trylock */
+	return mapping;
+}
+
 /*
  * lock_page_nosync should only be used if we can't pin the page's inode.
  * Doesn't play quite so well with block device plugging.
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -117,7 +117,7 @@ void __remove_from_page_cache(struct pag
 	struct address_space *mapping = page->mapping;
 
 	radix_tree_delete(&mapping->page_tree, page->index);
-	page->mapping = NULL;
+	set_page_mapping(page, NULL);
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	BUG_ON(page_mapped(page));
@@ -446,7 +446,7 @@ int add_to_page_cache(struct page *page,
 		if (!error) {
 			page_cache_get(page);
 			trylock_page(page);
-			page->mapping = mapping;
+			set_page_mapping(page, mapping);
 			page->index = offset;
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c
+++ linux-2.6/mm/migrate.c
@@ -381,7 +381,7 @@ static void migrate_page_copy(struct pag
 	ClearPageActive(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	page->mapping = NULL;
+	set_page_mapping(page, NULL);
 
 	/*
 	 * If any waiters have accumulated on the new page then
@@ -573,7 +573,7 @@ static int move_to_new_page(struct page 
 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
-	newpage->mapping = page->mapping;
+	set_page_mapping(newpage, page->mapping);
 
 	mapping = page_mapping(page);
 	if (!mapping)
@@ -594,7 +594,7 @@ static int move_to_new_page(struct page 
 	if (!rc)
 		remove_migration_ptes(page, newpage);
 	else
-		newpage->mapping = NULL;
+		set_page_mapping(newpage, NULL);
 
 	unlock_page(newpage);
 

--

