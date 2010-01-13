Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020Ab0AMITt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0AMITt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844Ab0AMITt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:19:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51348 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab0AMITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:19:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 1/3] vmscan: get_scan_ratio cleanup
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Jan 2010 17:19:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_scan_ratio() should have all scan-ratio related calculations.
Thus, this patch move some calculation into get_scan_ratio.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2bbee91..640486b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1501,6 +1501,13 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		percent[0] = 0;
+		percent[1] = 100;
+		return;
+	}
+
 	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
@@ -1598,22 +1605,20 @@ static void shrink_zone(int priority, struct zone *zone,
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
-	int noswap = 0;
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		noswap = 1;
-		percent[0] = 0;
-		percent[1] = 100;
-	} else
-		get_scan_ratio(zone, sc, percent);
+	get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
 
+		if (percent[file] == 0) {
+			nr[l] = 0;
+			continue;
+		}
+
 		scan = zone_nr_lru_pages(zone, sc, l);
-		if (priority || noswap) {
+		if (priority) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
-- 
1.6.5.2



