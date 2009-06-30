Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZF3GqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZF3GqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZF3GqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:46:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53132 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZF3GqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:46:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cleanup page_remove_rmap()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090630154343.A73F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Jun 2009 15:46:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry for the delay resend.

=================
Subject: [PATCH] cleanup page_remove_rmap()

page_remove_rmap() has multiple PageAnon() test and it has
a bit deeply nesting.

cleanup here.

note: this patch doesn't have behavior change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/rmap.c |   57 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

Index: b/mm/rmap.c
===================================================================
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -738,34 +738,37 @@ void page_dup_rmap(struct page *page, st
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
+	/* page still mapped by someone else? */
+	if (!atomic_add_negative(-1, &page->_mapcount))
+		return;
+
+	/*
+	 * Now that the last pte has gone, s390 must transfer dirty
+	 * flag from storage key to struct page.  We can usually skip
+	 * this if the page is anon, so about to be freed; but perhaps
+	 * not if it's in swapcache - there might be another pte slot
+	 * containing the swap entry, but page not yet written to swap.
+	 */
+	if ((!PageAnon(page) || PageSwapCache(page)) && page_test_dirty(page)) {
+		page_clear_dirty(page);
+		set_page_dirty(page);
+	}
+	if (PageAnon(page)) {
+		mem_cgroup_uncharge_page(page);
+		__dec_zone_page_state(page, NR_ANON_PAGES);
+	} else {
+		__dec_zone_page_state(page, NR_FILE_MAPPED);
 	}
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


