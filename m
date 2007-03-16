Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbXCPI42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbXCPI42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXCPIzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:55:47 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34698 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932409AbXCPIvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:08 -0400
Message-ID: <374035060.58834@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085053.463858000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:09 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] readahead: rescue_pages() updates
Content-Disposition: inline; filename=readahead-rescue_pages-updates.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Replace @page with @mapping and @index,
  which is a more usable interface.

- Add a new parameter @ra to rescue_pages(),
  which enables detailed accounting for individual readahead methods.

- Scan all pages in the range, instead of bailing out on first uncached page.

- ClearPageReadahead() on each page.
  It's harmful to have any lookahead marks when thrashing is pending.

- Add a call to rescue_pages() in thrashing_recovery_readahead().

Stress tested in qemu.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   67 +++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -731,60 +731,60 @@ unsigned long max_sane_readahead(unsigne
 /*
  * Move pages in danger (of thrashing) to the head of inactive_list.
  * Not expected to happen frequently.
- *
- * @page will be skipped: it's grabbed and won't die away.
- * The following @nr_pages-1 pages will be protected.
  */
-static unsigned long rescue_pages(struct page *page, unsigned long nr_pages)
+static unsigned long rescue_pages(struct address_space *mapping,
+				  struct file_ra_state *ra,
+				  pgoff_t index, unsigned long nr_pages)
 {
-	int pgrescue = 0;
-	pgoff_t index = page_index(page);
-	struct address_space *mapping = page_mapping(page);
-	struct page *grabbed_page = NULL;
+	struct page *grabbed_page;
+	struct page *page;
 	struct zone *zone;
+	int pgrescue = 0;
 
-	dprintk("rescue_pages(ino=%lu, index=%lu nr=%lu)\n",
+	dprintk("rescue_pages(ino=%lu, index=%lu, nr=%lu)\n",
 			mapping->host->i_ino, index, nr_pages);
 
-	for(;;) {
+	for(; nr_pages;) {
+		grabbed_page = page = find_get_page(mapping, index);
+		if (!page) {
+			index++;
+			nr_pages--;
+			continue;
+		}
+
 		zone = page_zone(page);
 		spin_lock_irq(&zone->lru_lock);
 
-		if (!PageLRU(page))
-			goto out_unlock;
+		if (!PageLRU(page)) {
+			index++;
+			nr_pages--;
+			goto next_unlock;
+		}
 
-		while (page_mapping(page) == mapping &&
-				page_index(page) == index) {
+		do {
 			struct page *the_page = page;
 			page = list_entry((page)->lru.prev, struct page, lru);
+			index++;
+			nr_pages--;
+			ClearPageReadahead(the_page);
 			if (!PageActive(the_page) &&
 					!PageLocked(the_page) &&
 					page_count(the_page) == 1) {
 				list_move(&the_page->lru, &zone->inactive_list);
 				pgrescue++;
 			}
-			index++;
-			if (!--nr_pages)
-				goto out_unlock;
-		}
+		} while (nr_pages &&
+				page_mapping(page) == mapping &&
+				page_index(page) == index);
 
+next_unlock:
 		spin_unlock_irq(&zone->lru_lock);
+		page_cache_release(grabbed_page);
 		cond_resched();
-
-		if (grabbed_page)
-			page_cache_release(grabbed_page);
-		grabbed_page = page = find_get_page(mapping, index);
-		if (!page)
-			goto out;
 	}
 
-out_unlock:
-	spin_unlock_irq(&zone->lru_lock);
-out:
-	if (grabbed_page)
-		page_cache_release(grabbed_page);
-	ra_account(NULL, RA_EVENT_READAHEAD_RESCUE, pgrescue);
-	return nr_pages;
+	ra_account(ra, RA_EVENT_READAHEAD_RESCUE, pgrescue);
+	return pgrescue;
 }
 
 /*
@@ -1131,7 +1131,7 @@ clock_based_readahead(struct address_spa
 	ra_size = ra_size * readahead_ratio / 100;
 
 	if (page && remain_space <= la_size) {
-		rescue_pages(page, la_size);
+		rescue_pages(mapping, ra, offset, la_size);
 		goto cancel_lookahead;
 	}
 
@@ -1456,7 +1456,7 @@ has_history_pages:
 	la_size = start - offset;
 	if (page && ra_size < la_size) {
 		if (ra_size < offset)
-			rescue_pages(page, la_size);
+			rescue_pages(mapping, ra, offset, la_size);
 		return -1;
 	}
 
@@ -1584,6 +1584,7 @@ thrashing_recovery_readahead(struct addr
 		 * Further thrashings will bring us back to case (3) below.
 		 */
 		ra_size = ra->readahead_index - offset;
+		rescue_pages(mapping, ra, offset, ra_size);
 	} else {
 		/*
 		 * 3) The new chunk is lost.

--
