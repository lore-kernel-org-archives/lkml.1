Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbXA1NbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbXA1NbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXA1Na6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:30:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573AbXA1N3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:29:30 -0500
Message-Id: <20070128132435.434675000@programming.kicks-ass.net>
References: <20070128131343.628722000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 14:13:49 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/14] mm: fix speculative page get preemption bug
Content-Disposition: inline; filename=mm-lockless-preempt-fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Livelock scenario pointed out by Nick.

SetPageNoNewRefs(page);
	  *** preempted here ***
		      page_cache_get_speculative() {
			while (PageNoNewRefs(page)) /* livelock */
		      }

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/pagemap.h |   25 +++++++++++++++++++++++--
 mm/filemap.c            |    6 ++----
 mm/migrate.c            |    8 +++-----
 mm/swap_state.c         |    6 ++----
 mm/vmscan.c             |    8 +++-----
 5 files changed, 33 insertions(+), 20 deletions(-)

Index: linux-2.6-rt/include/linux/pagemap.h
===================================================================
--- linux-2.6-rt.orig/include/linux/pagemap.h	2006-11-29 14:20:48.000000000 +0100
+++ linux-2.6-rt/include/linux/pagemap.h	2006-11-29 14:20:55.000000000 +0100
@@ -53,6 +53,28 @@ static inline void mapping_set_gfp_mask(
 #define page_cache_release(page)	put_page(page)
 void release_pages(struct page **pages, int nr, int cold);
 
+static inline void set_page_no_new_refs(struct page *page)
+{
+	VM_BUG_ON(PageNoNewRefs(page));
+	preempt_disable();
+	SetPageNoNewRefs(page);
+	smp_wmb();
+}
+
+static inline void end_page_no_new_refs(struct page *page)
+{
+	VM_BUG_ON(!PageNoNewRefs(page));
+	smp_wmb();
+	ClearPageNoNewRefs(page);
+	preempt_enable();
+}
+
+static inline void wait_on_new_refs(struct page *page)
+{
+	while (unlikely(PageNoNewRefs(page)))
+		cpu_relax();
+}
+
 /*
  * speculatively take a reference to a page.
  * If the page is free (_count == 0), then _count is untouched, and 0
@@ -128,8 +150,7 @@ static inline int page_cache_get_specula
 	 * page refcount has been raised. See below comment.
 	 */
 
-	while (unlikely(PageNoNewRefs(page)))
-		cpu_relax();
+	wait_on_new_refs(page);
 
 	/*
 	 * smp_rmb is to ensure the load of page->flags (for PageNoNewRefs())
Index: linux-2.6-rt/mm/filemap.c
===================================================================
--- linux-2.6-rt.orig/mm/filemap.c	2006-11-29 14:20:52.000000000 +0100
+++ linux-2.6-rt/mm/filemap.c	2006-11-29 14:20:55.000000000 +0100
@@ -440,8 +440,7 @@ int add_to_page_cache(struct page *page,
 	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 
 	if (error == 0) {
-		SetPageNoNewRefs(page);
-		smp_wmb();
+		set_page_no_new_refs(page);
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
 		if (!error) {
@@ -453,8 +452,7 @@ int add_to_page_cache(struct page *page,
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 		}
 		write_unlock_irq(&mapping->tree_lock);
-		smp_wmb();
-		ClearPageNoNewRefs(page);
+		end_page_no_new_refs(page);
 		radix_tree_preload_end();
 	}
 	return error;
Index: linux-2.6-rt/mm/migrate.c
===================================================================
--- linux-2.6-rt.orig/mm/migrate.c	2006-11-29 14:20:48.000000000 +0100
+++ linux-2.6-rt/mm/migrate.c	2006-11-29 14:20:55.000000000 +0100
@@ -303,8 +303,7 @@ static int migrate_page_move_mapping(str
 		return 0;
 	}
 
-	SetPageNoNewRefs(page);
-	smp_wmb();
+	set_page_no_new_refs(page);
 	write_lock_irq(&mapping->tree_lock);
 
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
@@ -313,7 +312,7 @@ static int migrate_page_move_mapping(str
 	if (page_count(page) != 2 + !!PagePrivate(page) ||
 			(struct page *)radix_tree_deref_slot(pslot) != page) {
 		write_unlock_irq(&mapping->tree_lock);
-		ClearPageNoNewRefs(page);
+		end_page_no_new_refs(page);
 		return -EAGAIN;
 	}
 
@@ -331,8 +330,7 @@ static int migrate_page_move_mapping(str
 	radix_tree_replace_slot(pslot, newpage);
 	page->mapping = NULL;
   	write_unlock_irq(&mapping->tree_lock);
-	smp_wmb();
-	ClearPageNoNewRefs(page);
+	end_page_no_new_refs(page);
 
 	/*
 	 * Drop cache reference from old page.
Index: linux-2.6-rt/mm/swap_state.c
===================================================================
--- linux-2.6-rt.orig/mm/swap_state.c	2006-11-29 14:20:48.000000000 +0100
+++ linux-2.6-rt/mm/swap_state.c	2006-11-29 14:20:55.000000000 +0100
@@ -78,8 +78,7 @@ static int __add_to_swap_cache(struct pa
 	BUG_ON(PagePrivate(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
-		SetPageNoNewRefs(page);
-		smp_wmb();
+		set_page_no_new_refs(page);
 		write_lock_irq(&swapper_space.tree_lock);
 		error = radix_tree_insert(&swapper_space.page_tree,
 						entry.val, page);
@@ -92,8 +91,7 @@ static int __add_to_swap_cache(struct pa
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 		}
 		write_unlock_irq(&swapper_space.tree_lock);
-		smp_wmb();
-		ClearPageNoNewRefs(page);
+		end_page_no_new_refs(page);
 		radix_tree_preload_end();
 	}
 	return error;
Index: linux-2.6-rt/mm/vmscan.c
===================================================================
--- linux-2.6-rt.orig/mm/vmscan.c	2006-11-29 14:20:48.000000000 +0100
+++ linux-2.6-rt/mm/vmscan.c	2006-11-29 14:20:55.000000000 +0100
@@ -390,8 +390,7 @@ int remove_mapping(struct address_space 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
-	SetPageNoNewRefs(page);
-	smp_wmb();
+	set_page_no_new_refs(page);
 	write_lock_irq(&mapping->tree_lock);
 	/*
 	 * The non racy check for a busy page.
@@ -436,14 +435,13 @@ int remove_mapping(struct address_space 
 	write_unlock_irq(&mapping->tree_lock);
 
 free_it:
-	smp_wmb();
-	__ClearPageNoNewRefs(page);
+	end_page_no_new_refs(page);
 	__put_page(page); /* The pagecache ref */
 	return 1;
 
 cannot_free:
 	write_unlock_irq(&mapping->tree_lock);
-	ClearPageNoNewRefs(page);
+	end_page_no_new_refs(page);
 	return 0;
 }
 

--

