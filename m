Return-Path: <linux-kernel-owner+w=401wt.eu-S970430AbXEIDMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970430AbXEIDMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970338AbXEIDLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:11:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58293 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970320AbXEIDLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:11:39 -0400
Date: Wed, 09 May 2007 12:10:59 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [RFC] memory hotremove patch take 2 [04/10] (isolate all free pages)
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070509120434.B90E.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Isolate all freed pages (means in buddy_list) in the range.
See page_buddy() and free_one_page() function if unsure.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

 include/linux/page_isolation.h |    1 
 mm/page_alloc.c                |   45 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

Index: current_test/mm/page_alloc.c
===================================================================
--- current_test.orig/mm/page_alloc.c	2007-05-08 15:08:04.000000000 +0900
+++ current_test/mm/page_alloc.c	2007-05-08 15:08:26.000000000 +0900
@@ -4411,6 +4411,51 @@ free_all_isolated_pages(struct isolation
 	}
 }
 
+/*
+ * Isolate already freed pages.
+ */
+int
+capture_isolate_freed_pages(struct isolation_info *info)
+{
+	struct zone *zone;
+	unsigned long pfn;
+	struct page *page;
+	int order, order_size;
+	int nr_pages = 0;
+	unsigned long last_pfn = info->end_pfn - 1;
+	pfn = info->start_pfn;
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+	zone = info->zone;
+	if ((zone != page_zone(pfn_to_page(pfn))) ||
+	    (zone != page_zone(pfn_to_page(last_pfn))))
+		return -EINVAL;
+	drain_all_pages();
+	spin_lock(&zone->lock);
+	while (pfn < info->end_pfn) {
+		if (!pfn_valid(pfn)) {
+			pfn++;
+			continue;
+		}
+		page = pfn_to_page(pfn);
+		/* See page_is_buddy()  */
+		if (page_count(page) == 0 && PageBuddy(page)) {
+			order = page_order(page);
+			order_size = 1 << order;
+			zone->free_area[order].nr_free--;
+			__mod_zone_page_state(zone, NR_FREE_PAGES, -order_size);
+			list_del(&page->lru);
+			rmv_page_order(page);
+			isolate_page_nolock(info, page, order);
+			nr_pages += order_size;
+			pfn += order_size;
+		} else {
+			pfn++;
+		}
+	}
+	spin_unlock(&zone->lock);
+	return nr_pages;
+}
 #endif /* CONFIG_PAGE_ISOLATION */
 
 
Index: current_test/include/linux/page_isolation.h
===================================================================
--- current_test.orig/include/linux/page_isolation.h	2007-05-08 15:08:04.000000000 +0900
+++ current_test/include/linux/page_isolation.h	2007-05-08 15:08:27.000000000 +0900
@@ -40,6 +40,7 @@ extern void free_isolation_info(struct i
 extern void unuse_all_isolated_pages(struct isolation_info *info);
 extern void free_all_isolated_pages(struct isolation_info *info);
 extern void drain_all_pages(void);
+extern int capture_isolate_freed_pages(struct isolation_info *info);
 
 #else
 

-- 
Yasunori Goto 


