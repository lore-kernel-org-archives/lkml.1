Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbZK0ASk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbZK0ASk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 19:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZK0ASk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 19:18:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52087 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZK0ASj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 19:18:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] vmscan: make lru_index() helper function
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
References: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
Message-Id: <20091127091755.A7CF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 27 Nov 2009 09:18:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current lru calculation (e.g. LRU_ACTIVE + file * LRU_FILE) is a bit
ugly.
To make helper function improve code readability a bit.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a58ff15..7e0245d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -156,6 +156,16 @@ static unsigned long zone_nr_lru_pages(struct zone *zone,
 	return zone_page_state(zone, NR_LRU_BASE + lru);
 }
 
+static inline enum lru_list lru_index(int active, int file)
+{
+	int lru = LRU_BASE;
+	if (active)
+		lru += LRU_ACTIVE;
+	if (file)
+		lru += LRU_FILE;
+
+	return lru;
+}
 
 /*
  * Add a shrinker callback to be called from the vm
@@ -978,13 +988,8 @@ static unsigned long isolate_pages_global(unsigned long nr,
 					struct mem_cgroup *mem_cont,
 					int active, int file)
 {
-	int lru = LRU_BASE;
-	if (active)
-		lru += LRU_ACTIVE;
-	if (file)
-		lru += LRU_FILE;
-	return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
-								mode, file);
+	return isolate_lru_pages(nr, &z->lru[lru_index(active, file)].list,
+				 dst, scanned, order, mode, file);
 }
 
 /*
@@ -1373,10 +1378,8 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-	move_active_pages_to_lru(zone, &l_active,
-						LRU_ACTIVE + file * LRU_FILE);
-	move_active_pages_to_lru(zone, &l_inactive,
-						LRU_BASE   + file * LRU_FILE);
+	move_active_pages_to_lru(zone, &l_active, lru_index(1, file));
+	move_active_pages_to_lru(zone, &l_inactive, lru_index(0, file));
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 }
-- 
1.6.5.2



