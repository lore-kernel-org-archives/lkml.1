Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbZF2Brl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbZF2Brl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZF2BrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:47:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:24954 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbZF2BrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:47:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,305,1243839600"; 
   d="scan'208";a="470353709"
Subject: [PATCH 3/5]memhp: make pages from movable zone always isolatable
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
Content-Type: text/plain
Date: Mon, 29 Jun 2009 09:47:18 +0800
Message-Id: <1246240038.26292.19.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages on movable zone have two types, MIGRATE_MOVABLE and MIGRATE_RESERVE,
both them can be movable, because only movable memory allocation can get
pages from movable zone. This makes pages in movable zone always be able
to migrate.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2009-06-26 09:44:07.000000000 +0800
+++ linux/mm/page_alloc.c	2009-06-26 09:52:03.000000000 +0800
@@ -4900,13 +4900,16 @@ int set_migratetype_isolate(struct page 
 	struct zone *zone;
 	unsigned long flags;
 	int ret = -EBUSY;
+	int zone_idx;
 
 	zone = page_zone(page);
+	zone_idx = zone_idx(zone);
 	spin_lock_irqsave(&zone->lock, flags);
 	/*
 	 * In future, more migrate types will be able to be isolation target.
 	 */
-	if (get_pageblock_migratetype(page) != MIGRATE_MOVABLE)
+	if (get_pageblock_migratetype(page) != MIGRATE_MOVABLE &&
+	    zone_idx != ZONE_MOVABLE)
 		goto out;
 	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 	move_freepages_block(zone, page, MIGRATE_ISOLATE);


