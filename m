Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYICSpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYICSpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYICSoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:44:11 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:54497 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYICSoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:44:07 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 2/4] pull out zone cpuset and watermark checks for reuse
Date: Wed,  3 Sep 2008 19:44:10 +0100
Message-Id: <1220467452-15794-3-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220467452-15794-1-git-send-email-apw@shadowen.org>
References: <1220467452-15794-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating we need to confirm that the zone we are about to allocate
from is acceptable to the CPUSET we are in, and that it does not violate
the zone watermarks.  Pull these checks out so we can reuse them in a
later patch.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 mm/page_alloc.c |   62 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b2a2c2b..2c3874e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1274,6 +1274,44 @@ int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 	return 1;
 }
 
+/*
+ * Return 1 if this zone is an acceptable source given the cpuset
+ * constraints.
+ */
+static inline int zone_cpuset_permits(struct zone *zone,
+					int alloc_flags, gfp_t gfp_mask)
+{
+	if ((alloc_flags & ALLOC_CPUSET) &&
+	    !cpuset_zone_allowed_softwall(zone, gfp_mask))
+		return 0;
+	return 1;
+}
+
+/*
+ * Return 1 if this zone is within the watermarks specified by the
+ * allocation flags.
+ */
+static inline int zone_watermark_permits(struct zone *zone, int order,
+			int classzone_idx, int alloc_flags, gfp_t gfp_mask)
+{
+	if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
+		unsigned long mark;
+		if (alloc_flags & ALLOC_WMARK_MIN)
+			mark = zone->pages_min;
+		else if (alloc_flags & ALLOC_WMARK_LOW)
+			mark = zone->pages_low;
+		else
+			mark = zone->pages_high;
+		if (!zone_watermark_ok(zone, order, mark,
+			    classzone_idx, alloc_flags)) {
+			if (!zone_reclaim_mode ||
+					!zone_reclaim(zone, gfp_mask, order))
+				return 0;
+		}
+	}
+	return 1;
+}
+
 #ifdef CONFIG_NUMA
 /*
  * zlc_setup - Setup for "zonelist cache".  Uses cached zone data to
@@ -1427,25 +1465,11 @@ zonelist_scan:
 		if (NUMA_BUILD && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
-		if ((alloc_flags & ALLOC_CPUSET) &&
-			!cpuset_zone_allowed_softwall(zone, gfp_mask))
-				goto try_next_zone;
-
-		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
-			unsigned long mark;
-			if (alloc_flags & ALLOC_WMARK_MIN)
-				mark = zone->pages_min;
-			else if (alloc_flags & ALLOC_WMARK_LOW)
-				mark = zone->pages_low;
-			else
-				mark = zone->pages_high;
-			if (!zone_watermark_ok(zone, order, mark,
-				    classzone_idx, alloc_flags)) {
-				if (!zone_reclaim_mode ||
-				    !zone_reclaim(zone, gfp_mask, order))
-					goto this_zone_full;
-			}
-		}
+		if (!zone_cpuset_permits(zone, alloc_flags, gfp_mask))
+			goto try_next_zone;
+		if (!zone_watermark_permits(zone, order, classzone_idx,
+							alloc_flags, gfp_mask))
+			goto this_zone_full;
 
 		page = buffered_rmqueue(preferred_zone, zone, order, gfp_mask);
 		if (page)
-- 
1.6.0.rc1.258.g80295

