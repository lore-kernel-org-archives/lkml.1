Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbZCPJwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbZCPJwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZCPJoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:44:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49716 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbZCPJoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:44:32 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 22/35] Use allocation flags as an index to the zone watermark
Date: Mon, 16 Mar 2009 09:46:17 +0000
Message-Id: <1237196790-7268-23-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALLOC_WMARK_MIN, ALLOC_WMARK_LOW and ALLOC_WMARK_HIGH determin whether
pages_min, pages_low or pages_high is used as the zone watermark when
allocating the pages. Two branches in the allocator hotpath determine which
watermark to use. This patch uses the flags as an array index and places
the three watermarks in a union with an array so it can be offset. This
means the flags can be used as an array index and reduces the branches
taken.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/mmzone.h |    8 +++++++-
 mm/page_alloc.c        |   18 ++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca000b8..c20c662 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -275,7 +275,13 @@ struct zone_reclaim_stat {
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */
-	unsigned long		pages_min, pages_low, pages_high;
+	union {
+		struct {
+			unsigned long	pages_min, pages_low, pages_high;
+		};
+		unsigned long pages_mark[3];
+	};
+
 	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
 	 * or/and it will be released eventually, so to avoid totally wasting several
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2704092..446cefa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1160,10 +1160,13 @@ failed:
 	return NULL;
 }
 
-#define ALLOC_NO_WATERMARKS	0x01 /* don't check watermarks at all */
-#define ALLOC_WMARK_MIN		0x02 /* use pages_min watermark */
-#define ALLOC_WMARK_LOW		0x04 /* use pages_low watermark */
-#define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
+/* The WMARK bits are used as an index zone->pages_mark */
+#define ALLOC_WMARK_MIN		0x00 /* use pages_min watermark */
+#define ALLOC_WMARK_LOW		0x01 /* use pages_low watermark */
+#define ALLOC_WMARK_HIGH	0x02 /* use pages_high watermark */
+#define ALLOC_NO_WATERMARKS	0x08 /* don't check watermarks at all */
+#define ALLOC_WMARK_MASK	0x07 /* Mask to get the watermark bits */
+
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #ifdef CONFIG_CPUSETS
@@ -1466,12 +1469,7 @@ zonelist_scan:
 
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
-			if (alloc_flags & ALLOC_WMARK_MIN)
-				mark = zone->pages_min;
-			else if (alloc_flags & ALLOC_WMARK_LOW)
-				mark = zone->pages_low;
-			else
-				mark = zone->pages_high;
+			mark = zone->pages_mark[alloc_flags & ALLOC_WMARK_MASK];
 			if (!zone_watermark_ok(zone, order, mark,
 				    classzone_idx, alloc_flags)) {
 				if (!zone_reclaim_mode ||
-- 
1.5.6.5

