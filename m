Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbXKCXIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbXKCXIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759728AbXKCXGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:06:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759591AbXKCXGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:06:37 -0400
Date: Sat, 3 Nov 2007 19:02:33 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/10] clean up the LRU array arithmetic
Message-ID: <20071103190233.4cba2ec8@bree.surriel.com>
In-Reply-To: <20071103184229.3f20e2f0@bree.surriel.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the LRU arithmetic more explicit.  Hopefully this will make
the code a little easier to read and less prone to future errors.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.23-mm1/include/linux/mm_inline.h
===================================================================
--- linux-2.6.23-mm1.orig/include/linux/mm_inline.h
+++ linux-2.6.23-mm1/include/linux/mm_inline.h
@@ -28,7 +28,7 @@ static inline int page_file_cache(struct
 		return 0;
 
 	/* The page is page cache backed by a normal filesystem. */
-	return (LRU_INACTIVE_FILE - LRU_INACTIVE_ANON);
+	return LRU_FILE;
 }
 
 static inline void
Index: linux-2.6.23-mm1/mm/swap.c
===================================================================
--- linux-2.6.23-mm1.orig/mm/swap.c
+++ linux-2.6.23-mm1/mm/swap.c
@@ -180,12 +180,12 @@ void fastcall activate_page(struct page 
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page)) {
-		int l = LRU_INACTIVE_ANON;
+		int l = LRU_BASE;
 		l += page_file_cache(page);
 		del_page_from_lru_list(zone, page, l);
 
 		SetPageActive(page);
-		l += LRU_ACTIVE_ANON - LRU_INACTIVE_ANON;
+		l += LRU_ACTIVE;
 		add_page_to_lru_list(zone, page, l);
 		__count_vm_event(PGACTIVATE);
 		mem_cgroup_move_lists(page_get_page_cgroup(page), true);
Index: linux-2.6.23-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.23-mm1.orig/mm/vmscan.c
+++ linux-2.6.23-mm1/mm/vmscan.c
@@ -786,11 +786,11 @@ static unsigned long isolate_pages_globa
 					struct mem_cgroup *mem_cont,
 					int active, int file)
 {
-	int l = LRU_INACTIVE_ANON;
+	int l = LRU_BASE;
 	if (active)
-		l += LRU_ACTIVE_ANON - LRU_INACTIVE_ANON;
+		l += LRU_ACTIVE;
 	if (file)
-		l += LRU_INACTIVE_FILE - LRU_INACTIVE_ANON;
+		l += LRU_FILE;
 	return isolate_lru_pages(nr, &z->list[l], dst, scanned, order,
 								mode, !!file);
 }
@@ -842,7 +842,7 @@ int isolate_lru_page(struct page *page)
 
 		spin_lock_irq(&zone->lru_lock);
 		if (PageLRU(page) && get_page_unless_zero(page)) {
-			int l = LRU_INACTIVE_ANON;
+			int l = LRU_BASE;
 			ret = 0;
 			ClearPageLRU(page);
 
@@ -938,19 +938,19 @@ static unsigned long shrink_inactive_lis
 		 * Put back any unfreeable pages.
 		 */
 		while (!list_empty(&page_list)) {
-			int l = LRU_INACTIVE_ANON;
+			int l = LRU_BASE;
 			page = lru_to_page(&page_list);
 			VM_BUG_ON(PageLRU(page));
 			SetPageLRU(page);
 			list_del(&page->lru);
 			if (file) {
-				l += LRU_INACTIVE_FILE - LRU_INACTIVE_ANON;
+				l += LRU_FILE;
 				zone->recent_rotated_file += sc->activated;
 			} else {
 				zone->recent_rotated_anon += sc->activated;
 			}
 			if (PageActive(page))
-				l += LRU_ACTIVE_ANON - LRU_INACTIVE_ANON;
+				l += LRU_ACTIVE;
 			add_page_to_lru_list(zone, page, l);
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
@@ -1051,7 +1051,7 @@ static void shrink_active_list(unsigned 
 	 */
 	pagevec_init(&pvec, 1);
 	pgmoved = 0;
-	l = LRU_INACTIVE_ANON + file * (LRU_INACTIVE_FILE - LRU_INACTIVE_ANON);
+	l = LRU_BASE + file * LRU_FILE;
 	spin_lock_irq(&zone->lru_lock);
 	while (!list_empty(&list[LRU_INACTIVE_ANON])) {
 		page = lru_to_page(&list[LRU_INACTIVE_ANON]);
@@ -1083,7 +1083,7 @@ static void shrink_active_list(unsigned 
 	if (buffer_heads_over_limit)
 		pagevec_strip(&pvec);
 	pgmoved = 0;
-	l = LRU_ACTIVE_ANON + file * (LRU_ACTIVE_FILE - LRU_ACTIVE_ANON);
+	l = LRU_ACTIVE + file * LRU_FILE;
 	spin_lock_irq(&zone->lru_lock);
 	while (!list_empty(&list[LRU_ACTIVE_ANON])) {
 		page = lru_to_page(&list[LRU_ACTIVE_ANON]);
Index: linux-2.6.23-mm1/include/linux/mmzone.h
===================================================================
--- linux-2.6.23-mm1.orig/include/linux/mmzone.h
+++ linux-2.6.23-mm1/include/linux/mmzone.h
@@ -107,11 +107,22 @@ enum zone_stat_item {
 #endif
 	NR_VM_ZONE_STAT_ITEMS };
 
+/*
+ * We do arithmetic on the LRU lists in various places in the code,
+ * so it is important to keep the active lists LRU_ACTIVE higher in
+ * the array than the corresponding inactive lists, and to keep
+ * the *_FILE lists LRU_FILE higher than the corresponding _ANON lists.
+ */
+#define LRU_BASE 0
+#define LRU_ANON LRU_BASE
+#define LRU_ACTIVE 1
+#define LRU_FILE 2
+
 enum lru_list {
-	LRU_INACTIVE_ANON,	/* must be first enum  */
-	LRU_ACTIVE_ANON,	/* must match order of NR_[IN]ACTIVE_* */
-	LRU_INACTIVE_FILE,	/*  "     "     "   "       "          */
-	LRU_ACTIVE_FILE,	/*  "     "     "   "       "          */
+	LRU_INACTIVE_ANON = LRU_BASE,
+	LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
+	LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
+	LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
 	NR_LRU_LISTS };
 
 #define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
