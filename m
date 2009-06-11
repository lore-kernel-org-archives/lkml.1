Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbZFKK1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbZFKK1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbZFKK0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:26:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57577 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbZFKK0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:26:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for mmotm 2/5] 
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
Message-Id: <20090611192600.6D50.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 19:26:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since Wu's original patch
  - adding vmstat
  - rename NR_TMPFS_MAPPED to NR_SWAP_BACKED_FILE_MAPPED


----------------------
Subject: [PATCH] introduce NR_SWAP_BACKED_FILE_MAPPED zone stat

Desirable zone reclaim implementaion want to know the number of
file-backed and unmapped pages.

Thus, we need to know number of swap-backed mapped pages for
calculate above number.


Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mmzone.h |    2 ++
 mm/rmap.c              |    7 +++++++
 mm/vmstat.c            |    1 +
 3 files changed, 10 insertions(+)

Index: b/include/linux/mmzone.h
===================================================================
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -88,6 +88,8 @@ enum zone_stat_item {
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
+	NR_SWAP_BACKED_FILE_MAPPED, /* Similar to NR_FILE_MAPPED. but
+				       only account swap-backed pages */
 	NR_FILE_PAGES,
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
Index: b/mm/rmap.c
===================================================================
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -829,6 +829,10 @@ void page_add_file_rmap(struct page *pag
 {
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
+		if (PageSwapBacked(page))
+			__inc_zone_page_state(page,
+					      NR_SWAP_BACKED_FILE_MAPPED);
+
 		mem_cgroup_update_mapped_file_stat(page, 1);
 	}
 }
@@ -884,6 +888,9 @@ void page_remove_rmap(struct page *page)
 		__dec_zone_page_state(page, NR_ANON_PAGES);
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
+		if (PageSwapBacked(page))
+			__dec_zone_page_state(page,
+					NR_SWAP_BACKED_FILE_MAPPED);
 	}
 	mem_cgroup_update_mapped_file_stat(page, -1);
 	/*
Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -633,6 +633,7 @@ static const char * const vmstat_text[] 
 	"nr_mlock",
 	"nr_anon_pages",
 	"nr_mapped",
+	"nr_swap_backed_file_mapped",
 	"nr_file_pages",
 	"nr_dirty",
 	"nr_writeback",


