Return-Path: <linux-kernel-owner+w=401wt.eu-S1751103AbZL1Hr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbZL1Hr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZL1Hr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:47:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42336 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZL1HrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:47:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/4] vmstat: remove zone->lock from walk_zones_in_node
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091228164451.A687.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Dec 2009 16:47:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zone->lock is one of performance critical locks. Then, it shouldn't
be hold for long time. Currently, we have four walk_zones_in_node()
usage and almost use-case don't need to hold zone->lock.

Thus, this patch move locking responsibility from walk_zones_in_node
to its sub function. Also this patch kill unnecessary zone->lock taking.

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmstat.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6051fba..a5d45bc 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -418,15 +418,12 @@ static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
 {
 	struct zone *zone;
 	struct zone *node_zones = pgdat->node_zones;
-	unsigned long flags;
 
 	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
 		if (!populated_zone(zone))
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
 		print(m, pgdat, zone);
-		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 }
 
@@ -455,6 +452,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
 	int order, mtype;
+	unsigned long flags;
 
 	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
 		seq_printf(m, "Node %4d, zone %8s, type %12s ",
@@ -468,8 +466,11 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 
 			area = &(zone->free_area[order]);
 
+			spin_lock_irqsave(&zone->lock, flags);
 			list_for_each(curr, &area->free_list[mtype])
 				freecount++;
+			spin_unlock_irqrestore(&zone->lock, flags);
+
 			seq_printf(m, "%6lu ", freecount);
 		}
 		seq_putc(m, '\n');
@@ -709,6 +710,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 							struct zone *zone)
 {
 	int i;
+
 	seq_printf(m, "Node %d, zone %8s", pgdat->node_id, zone->name);
 	seq_printf(m,
 		   "\n  pages free     %lu"
-- 
1.6.5.2




