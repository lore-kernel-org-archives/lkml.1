Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYAXEYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYAXEYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYAXEYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:24:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35189 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYAXEYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:24:01 -0500
Date: Thu, 24 Jan 2008 13:23:53 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 6/8] mem_notify v5: (optional) fixed incorrect shrink_zone
Cc: kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080124132249.1772.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


on X86, ZONE_DMA is very very small.
It is often no used at all. 

Unfortunately, 
when NR_ACTIVE==0, NR_INACTIVE==0, shrink_zone() try to reclaim 1 page.
because

    zone->nr_scan_active +=
        (zone_page_state(zone, NR_ACTIVE) >> priority) + 1;
                                                        ^^^^^

it cause unnecessary low memory notify ;-)


ChangeLog
	v5: new

---
 mm/vmscan.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-01-18 14:18:27.000000000 +0900
+++ b/mm/vmscan.c	2008-01-18 14:49:06.000000000 +0900
@@ -948,7 +948,7 @@ static inline void note_zone_scanning_pr
 
 static inline int zone_is_near_oom(struct zone *zone)
 {
-	return zone->pages_scanned >= (zone_page_state(zone, NR_ACTIVE)
+	return zone->pages_scanned > (zone_page_state(zone, NR_ACTIVE)
 				+ zone_page_state(zone, NR_INACTIVE))*3;
 }
 
@@ -1214,18 +1214,29 @@ static unsigned long shrink_zone(int pri
 	unsigned long nr_inactive;
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
+	unsigned long tmp;
+	unsigned long zone_active;
+	unsigned long zone_inactive;
 
 	if (scan_global_lru(sc)) {
 		/*
 		 * Add one to nr_to_scan just to make sure that the kernel
 		 * will slowly sift through the active list.
 		 */
-		zone->nr_scan_active +=
-			(zone_page_state(zone, NR_ACTIVE) >> priority) + 1;
+		zone_active = zone_page_state(zone, NR_ACTIVE);
+		tmp = (zone_active >> priority) + 1;
+		if (unlikely(tmp > zone_active))
+			tmp = zone_active;
+		zone->nr_scan_active += tmp;
 		nr_active = zone->nr_scan_active;
-		zone->nr_scan_inactive +=
-			(zone_page_state(zone, NR_INACTIVE) >> priority) + 1;
+
+		zone_inactive = zone_page_state(zone, NR_INACTIVE);
+		tmp = (zone_inactive >> priority) + 1;
+		if (unlikely(tmp > zone_inactive))
+			tmp = zone_inactive;
+		zone->nr_scan_inactive += tmp;
 		nr_inactive = zone->nr_scan_inactive;
+
 		if (nr_inactive >= sc->swap_cluster_max)
 			zone->nr_scan_inactive = 0;
 		else


