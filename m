Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZEUAXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZEUAXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZEUAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:23:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:41520 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbZEUAXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ZVuU9TTNNL2qQ5njmSXXttbYOJ/skzXqiVV7TrcFVE8m6Hw/eT5gx4kGbCuA31FxJZ
         W2leurjpSK08M+DaQktqy+LyfEWNrzgiuqIZ0cBEKkve++lRdqlYL1yPJKw3NkglT0bt
         BCxsEZWrkGH3MZ5hFNb3D45IwfQDF+r/SHqWs=
Date: Thu, 21 May 2009 09:23:21 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH 2/3] add inactive ratio calculation function of each zone V2
Message-Id: <20090521092321.ee57585e.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V1 
 o Change function name from calculate_zone_inactive_ratio to calculate_inactive_ratio
   - by Mel Gorman advise
 o Modify tab indent - by Mel Gorman advise

This patch devide setup_per_zone_inactive_ratio with
per-zone inactive ratio calculaton.

This patch is just for helping my next patch.
(reset wmark_min and inactive ratio of zone when hotplug happens)

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7ea4d1b..5d7a835 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1059,6 +1059,7 @@ extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmarks(void);
+extern void calculate_zone_inactive_ratio(struct zone *zone);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b518ea7..f11cfbf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4553,22 +4553,26 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static void __init setup_per_zone_inactive_ratio(void)
+void calculate_zone_inactive_ratio(struct zone *zone)
 {
-	struct zone *zone;
+	unsigned int gb, ratio;
 
-	for_each_zone(zone) {
-		unsigned int gb, ratio;
+	/* Zone size in gigabytes */
+	gb = zone->present_pages >> (30 - PAGE_SHIFT);
+	if (gb)
+		ratio = int_sqrt(10 * gb);
+	else
+		ratio = 1;
 
-		/* Zone size in gigabytes */
-		gb = zone->present_pages >> (30 - PAGE_SHIFT);
-		if (gb)
-			ratio = int_sqrt(10 * gb);
-		else
-			ratio = 1;
+	zone->inactive_ratio = ratio;
+}
 
-		zone->inactive_ratio = ratio;
-	}
+static void __init setup_per_zone_inactive_ratio(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone)
+		calculate_zone_inactive_ratio(zone);	
 }
 
 /*
-- 
1.5.4.3

