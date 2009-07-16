Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZGPAwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZGPAwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbZGPAwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:52:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36826 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZGPAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:52:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
Message-Id: <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 09:52:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Rename pgmoved variable in shrink_active_list()

Currently, pgmoved variable have two meanings. it cause harder reviewing a bit.
This patch separate it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1239,7 +1239,7 @@ static void move_active_pages_to_lru(str
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			struct scan_control *sc, int priority, int file)
 {
-	unsigned long pgmoved;
+	unsigned long nr_taken;
 	unsigned long pgscanned;
 	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
@@ -1247,10 +1247,11 @@ static void shrink_active_list(unsigned 
 	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	unsigned long nr_rotated = 0;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
-	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
+	nr_taken = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
 					ISOLATE_ACTIVE, zone,
 					sc->mem_cgroup, 1, file);
 	/*
@@ -1260,16 +1261,15 @@ static void shrink_active_list(unsigned 
 	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
-	reclaim_stat->recent_scanned[!!file] += pgmoved;
+	reclaim_stat->recent_scanned[!!file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	if (file)
-		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
+		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
 	else
-		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
+		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
-	pgmoved = 0;  /* count referenced (mapping) mapped pages */
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
@@ -1283,7 +1283,7 @@ static void shrink_active_list(unsigned 
 		/* page_referenced clears PageReferenced */
 		if (page_mapping_inuse(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
-			pgmoved++;
+			nr_rotated++;
 			/*
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
@@ -1312,7 +1312,7 @@ static void shrink_active_list(unsigned 
 	 * helps balance scan pressure between file and anonymous pages in
 	 * get_scan_ratio.
 	 */
-	reclaim_stat->recent_rotated[!!file] += pgmoved;
+	reclaim_stat->recent_rotated[!!file] += nr_rotated;
 
 	move_active_pages_to_lru(zone, &l_active,
 						LRU_ACTIVE + file * LRU_FILE);


