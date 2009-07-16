Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZGPIlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZGPIlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZGPIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:40:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33393 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZGPIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:40:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] move PGDEACTIVATE modification to shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
References: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
Message-Id: <20090716174018.9D57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 17:40:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: move PGDEACTIVATE modification to shrink_active_list()

Pgmoved accounting in move_active_pages_to_lru() doesn't make any sense.
it can be calculated in irq enabled area.

This patch move #-of-deactivating-pages calcution to shrink_active_list().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1217,7 +1217,6 @@ static void move_active_pages_to_lru(str
 				     struct list_head *list,
 				     enum lru_list lru)
 {
-	unsigned long pgmoved = 0;
 	struct pagevec pvec;
 	struct page *page;
 
@@ -1231,7 +1230,6 @@ static void move_active_pages_to_lru(str
 		SetPageLRU(page);
 
 		add_page_to_lru_list(zone, page, lru);
-		pgmoved++;
 
 		if (!pagevec_add(&pvec, page) || list_empty(list)) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1241,8 +1239,6 @@ static void move_active_pages_to_lru(str
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	if (!is_active_lru(lru))
-		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
 
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
@@ -1257,6 +1253,7 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_rotated = 0;
+	unsigned long nr_deactivate = 0;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1311,6 +1308,7 @@ static void shrink_active_list(unsigned 
 
 		ClearPageActive(page);	/* we are de-activating */
 		list_add(&page->lru, &l_inactive);
+		nr_deactivate++;
 	}
 
 	/*
@@ -1324,6 +1322,7 @@ static void shrink_active_list(unsigned 
 	 * get_scan_ratio.
 	 */
 	reclaim_stat->recent_rotated[!!file] += nr_rotated;
+	__count_vm_events(PGDEACTIVATE, nr_deactivate);
 
 	move_active_pages_to_lru(zone, &l_active,
 						LRU_ACTIVE + file * LRU_FILE);


