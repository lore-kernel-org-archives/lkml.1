Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbXLMFUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbXLMFUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 00:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbXLMFUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 00:20:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:45069 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXLMFUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 00:20:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,160,1196668800"; 
   d="scan'208";a="236584038"
Subject: [RFC] move free page back to MIGRATE_MOVABLE?
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: mel@csn.ul.ie, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 13:19:59 +0800
Message-Id: <1197523199.3410.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pages are MIGRATE_MOVABLE initially, and fallback to other types. If the
pages are freed, I wonder why not move them back to MIGRATE_MOVABLE.
This, for example, can help memory remove.

Thanks,
Shaohua 

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2007-12-13 11:44:36.000000000 +0800
+++ linux/mm/page_alloc.c	2007-12-13 12:04:59.000000000 +0800
@@ -386,6 +386,9 @@ static inline int page_is_buddy(struct p
 	return 0;
 }
 
+int move_freepages(struct zone *zone,
+			struct page *start_page, struct page *end_page,
+			int migratetype);
 /*
  * Freeing function for a buddy system allocator.
  *
@@ -446,6 +449,17 @@ static inline void __free_one_page(struc
 	list_add(&page->lru,
 		&zone->free_area[order].free_list[migratetype]);
 	zone->free_area[order].nr_free++;
+
+	if (order >= pageblock_order && migratetype != MIGRATE_MOVABLE) {
+		struct page *tmp = page;
+
+		move_freepages(zone, page, page + (1 << order) - 1, MIGRATE_MOVABLE);
+
+		while (tmp < page + (1 << order)) {
+			set_pageblock_migratetype(tmp, MIGRATE_MOVABLE);
+			tmp += pageblock_nr_pages;
+		}
+	}
 }
 
 static inline int free_pages_check(struct page *page)
