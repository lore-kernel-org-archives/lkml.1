Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbZFKK0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbZFKK0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbZFKK0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:26:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57549 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZFKK0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:26:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for mmotm 1/5] cleanp page_remove_rmap()
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
Message-Id: <20090611192514.6D4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 19:26:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] cleanp page_remove_rmap()

page_remove_rmap() has multiple PageAnon() test and it has
a bit deeply nesting.

cleanup here.

note: this patch doesn't have behavior change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com> 
---
 mm/rmap.c |   59 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

Index: b/mm/rmap.c
===================================================================
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -862,34 +862,39 @@ void page_dup_rmap(struct page *page, st
  */
 void page_remove_rmap(struct page *page)
 {
-	if (atomic_add_negative(-1, &page->_mapcount)) {
-		/*
-		 * Now that the last pte has gone, s390 must transfer dirty
-		 * flag from storage key to struct page.  We can usually skip
-		 * this if the page is anon, so about to be freed; but perhaps
-		 * not if it's in swapcache - there might be another pte slot
-		 * containing the swap entry, but page not yet written to swap.
-		 */
-		if ((!PageAnon(page) || PageSwapCache(page)) &&
-		    page_test_dirty(page)) {
-			page_clear_dirty(page);
-			set_page_dirty(page);
-		}
-		if (PageAnon(page))
-			mem_cgroup_uncharge_page(page);
-		__dec_zone_page_state(page,
-			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
-		mem_cgroup_update_mapped_file_stat(page, -1);
-		/*
-		 * It would be tidy to reset the PageAnon mapping here,
-		 * but that might overwrite a racing page_add_anon_rmap
-		 * which increments mapcount after us but sets mapping
-		 * before us: so leave the reset to free_hot_cold_page,
-		 * and remember that it's only reliable while mapped.
-		 * Leaving it set also helps swapoff to reinstate ptes
-		 * faster for those pages still in swapcache.
-		 */
+	if (!atomic_add_negative(-1, &page->_mapcount)) {
+		/* the page is still mapped another one */
+		return;
 	}
+
+	/*
+	 * Now that the last pte has gone, s390 must transfer dirty
+	 * flag from storage key to struct page.  We can usually skip
+	 * this if the page is anon, so about to be freed; but perhaps
+	 * not if it's in swapcache - there might be another pte slot
+	 * containing the swap entry, but page not yet written to swap.
+	 */
+	if ((!PageAnon(page) || PageSwapCache(page)) &&
+		page_test_dirty(page)) {
+		page_clear_dirty(page);
+		set_page_dirty(page);
+	}
+	if (PageAnon(page)) {
+		mem_cgroup_uncharge_page(page);
+		__dec_zone_page_state(page, NR_ANON_PAGES);
+	} else {
+		__dec_zone_page_state(page, NR_FILE_MAPPED);
+	}
+	mem_cgroup_update_mapped_file_stat(page, -1);
+	/*
+	 * It would be tidy to reset the PageAnon mapping here,
+	 * but that might overwrite a racing page_add_anon_rmap
+	 * which increments mapcount after us but sets mapping
+	 * before us: so leave the reset to free_hot_cold_page,
+	 * and remember that it's only reliable while mapped.
+	 * Leaving it set also helps swapoff to reinstate ptes
+	 * faster for those pages still in swapcache.
+	 */
 }
 
 /*


