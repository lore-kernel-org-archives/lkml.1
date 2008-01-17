Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbYAQR7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbYAQR7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYAQR6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:58:45 -0500
Received: from waste.org ([66.93.16.53]:59381 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYAQR6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:58:44 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 3] slob: reduce external fragmentation by using three
	free lists
X-Mercurial-Node: eff994add207d1f3ffbed9f5f23cb45e44896a94
Message-Id: <eff994add207d1f3ffbe.1200592640@cinder.waste.org>
In-Reply-To: <patchbomb.1200592638@cinder.waste.org>
Date: Thu, 17 Jan 2008 11:57:20 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <apkm@linux-foundation.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By putting smaller objects on their own list, we greatly reduce
overall external fragmentation and increase repeatability. This
reduces total SLOB overhead from > 50% to ~6% on a simple boot test.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 771a5ab2c6b7 -r eff994add207 mm/slob.c
--- a/mm/slob.c	Wed Jan 16 18:14:29 2008 -0600
+++ b/mm/slob.c	Wed Jan 16 18:14:29 2008 -0600
@@ -12,10 +12,17 @@
  * allocator is as little as 2 bytes, however typically most architectures
  * will require 4 bytes on 32-bit and 8 bytes on 64-bit.
  *
- * The slob heap is a linked list of pages from alloc_pages(), and
- * within each page, there is a singly-linked list of free blocks (slob_t).
- * The heap is grown on demand and allocation from the heap is currently
- * first-fit.
+ * The slob heap is a set of linked list of pages from alloc_pages(),
+ * and within each page, there is a singly-linked list of free blocks
+ * (slob_t). The heap is grown on demand. To reduce fragmentation,
+ * heap pages are segregated into three lists, with objects less than
+ * 256 bytes, objects less than 1024 bytes, and all other objects.
+ *
+ * Allocation from heap involves first searching for a page with
+ * sufficient free blocks (using a next-fit-like approach) followed by
+ * a first-fit scan of the page. Deallocation inserts objects back
+ * into the free list in address order, so this is effectively an
+ * address-ordered first fit.
  *
  * Above this is an implementation of kmalloc/kfree. Blocks returned
  * from kmalloc are prepended with a 4-byte header with the kmalloc size.
@@ -110,9 +117,13 @@
 }
 
 /*
- * All (partially) free slob pages go on this list.
+ * All partially free slob pages go on these lists.
  */
-static LIST_HEAD(free_slob_pages);
+#define SLOB_BREAK1 256
+#define SLOB_BREAK2 1024
+static LIST_HEAD(free_slob_small);
+static LIST_HEAD(free_slob_medium);
+static LIST_HEAD(free_slob_large);
 
 /*
  * slob_page: True for all slob pages (false for bigblock pages)
@@ -140,9 +151,9 @@
 	return test_bit(PG_private, &sp->flags);
 }
 
-static inline void set_slob_page_free(struct slob_page *sp)
+static void set_slob_page_free(struct slob_page *sp, struct list_head *list)
 {
-	list_add(&sp->list, &free_slob_pages);
+	list_add(&sp->list, list);
 	__set_bit(PG_private, &sp->flags);
 }
 
@@ -294,12 +305,20 @@
 {
 	struct slob_page *sp;
 	struct list_head *prev;
+	struct list_head *slob_list;
 	slob_t *b = NULL;
 	unsigned long flags;
 
+	if (size < SLOB_BREAK1)
+		slob_list = &free_slob_small;
+	else if (size < SLOB_BREAK2)
+		slob_list = &free_slob_medium;
+	else
+		slob_list = &free_slob_large;
+
 	spin_lock_irqsave(&slob_lock, flags);
 	/* Iterate through each partially free page, try to find room */
-	list_for_each_entry(sp, &free_slob_pages, list) {
+	list_for_each_entry(sp, slob_list, list) {
 #ifdef CONFIG_NUMA
 		/*
 		 * If there's a node specification, search for a partial
@@ -321,9 +340,9 @@
 		/* Improve fragment distribution and reduce our average
 		 * search time by starting our next search here. (see
 		 * Knuth vol 1, sec 2.5, pg 449) */
-		if (prev != free_slob_pages.prev &&
-				free_slob_pages.next != prev->next)
-			list_move_tail(&free_slob_pages, prev->next);
+		if (prev != slob_list->prev &&
+				slob_list->next != prev->next)
+			list_move_tail(slob_list, prev->next);
 		break;
 	}
 	spin_unlock_irqrestore(&slob_lock, flags);
@@ -341,7 +360,7 @@
 		sp->free = b;
 		INIT_LIST_HEAD(&sp->list);
 		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
-		set_slob_page_free(sp);
+		set_slob_page_free(sp, slob_list);
 		b = slob_page_alloc(sp, size, align);
 		BUG_ON(!b);
 		spin_unlock_irqrestore(&slob_lock, flags);
@@ -387,7 +406,7 @@
 		set_slob(b, units,
 			(void *)((unsigned long)(b +
 					SLOB_UNITS(PAGE_SIZE)) & PAGE_MASK));
-		set_slob_page_free(sp);
+		set_slob_page_free(sp, &free_slob_small);
 		goto out;
 	}
 
