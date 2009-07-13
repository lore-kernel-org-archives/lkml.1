Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZGMCam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZGMCam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 22:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZGMCad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 22:30:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:32599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZGMCac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 22:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,388,1243839600"; 
   d="scan'208";a="532203543"
Date: Mon, 13 Jul 2009 10:30:30 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: mel@csn.ul.ie, akpm@linux-foundation.org
Subject: [PATCH] switch free memory back to MIGRATE_MOVABLE
Message-ID: <20090713023030.GA27269@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When page is back to buddy and its order is bigger than pageblock_order, we can
switch its type to MIGRATE_MOVABLE. This can reduce fragmentation. The patch
has obvious effect when read a block device and then drop caches.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/page_alloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2009-07-10 11:36:07.000000000 +0800
+++ linux/mm/page_alloc.c	2009-07-13 09:25:21.000000000 +0800
@@ -475,6 +475,15 @@ static inline void __free_one_page(struc
 		order++;
 	}
 	set_page_order(page, order);
+
+	if (order >= pageblock_order && migratetype != MIGRATE_MOVABLE) {
+		int i;
+
+		migratetype = MIGRATE_MOVABLE;
+		for (i = 0; i < (1 << (order - pageblock_order)); i++)
+			set_pageblock_migratetype(page +
+				i * pageblock_nr_pages, MIGRATE_MOVABLE);
+	}
 	list_add(&page->lru,
 		&zone->free_area[order].free_list[migratetype]);
 	zone->free_area[order].nr_free++;
