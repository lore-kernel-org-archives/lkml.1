Return-Path: <linux-kernel-owner+w=401wt.eu-S934979AbXGQPpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979AbXGQPpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbXGQPlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:41:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763419AbXGQPlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:41:15 -0400
Message-Id: <20070717173759.425576000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:40 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 12/12] mm: set_page_mapping()
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
 mm/migrate.c            |    8 ++++----
 3 files changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -432,6 +432,15 @@ static inline void unlock_page(struct pa
 	unlock_page_nocheck(page);
 }
 
+static inline struct address_space *set_page_mapping(struct page *page,
+		struct address_space *mapping)
+{
+	__unlock_page_check(page);
+	page->mapping = mapping;
+	__lock_page_check(page);
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
@@ -120,7 +120,7 @@ void __remove_from_page_cache(struct pag
 	radix_tree_lock(&ctx);
 	radix_tree_delete(ctx.tree, page->index);
 	radix_tree_unlock(&ctx);
-	page->mapping = NULL;
+	set_page_mapping(page, NULL);
 	mapping_nrpages_dec(mapping);
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 }
@@ -450,7 +450,7 @@ int add_to_page_cache(struct page *page,
 		if (!error) {
 			page_cache_get(page);
 			lock_page(page);
-			page->mapping = mapping;
+			set_page_mapping(page, mapping);
 			page->index = offset;
 			mapping_nrpages_inc(mapping);
 			__inc_zone_page_state(page, NR_FILE_PAGES);
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c
+++ linux-2.6/mm/migrate.c
@@ -328,7 +328,7 @@ static int migrate_page_move_mapping(str
 #endif
 
 	radix_tree_replace_slot(pslot, newpage);
-	page->mapping = NULL;
+	set_page_mapping(page, NULL);
 	radix_tree_unlock(&ctx);
 
 	/*
@@ -386,7 +386,7 @@ static void migrate_page_copy(struct pag
 	ClearPageActive(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	page->mapping = NULL;
+	set_page_mapping(page, NULL);
 
 	/*
 	 * If any waiters have accumulated on the new page then
@@ -578,7 +578,7 @@ static int move_to_new_page(struct page 
 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
-	newpage->mapping = page->mapping;
+	set_page_mapping(newpage, page->mapping);
 
 	mapping = page_mapping(page);
 	if (!mapping)
@@ -599,7 +599,7 @@ static int move_to_new_page(struct page 
 	if (!rc)
 		remove_migration_ptes(page, newpage);
 	else
-		newpage->mapping = NULL;
+		set_page_mapping(newpage, NULL);
 
 	unlock_page(newpage);
 

--

