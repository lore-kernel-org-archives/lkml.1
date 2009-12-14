Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZLNMcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZLNMcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZLNMcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:32:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35340 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZLNMcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:32:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH 7/8] Use TASK_KILLABLE instead TASK_UNINTERRUPTIBLE
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214213145.BBC3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:32:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When fork bomb invoke OOM Killer, almost task might start to reclaim and
sleep on shrink_zone_begin(). if we use TASK_UNINTERRUPTIBLE, OOM killer
can't kill such task. it mean we never recover from fork bomb.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf229d3..e537361 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1618,7 +1618,10 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
 	 * we would just make things slower.
 	 */
 	for (;;) {
-		prepare_to_wait_exclusive(wq, &wait, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait_exclusive(wq, &wait, TASK_KILLABLE);
+
+		if (fatal_signal_pending(current))
+			goto stop_reclaim;
 
 		if (atomic_read(&zone->concurrent_reclaimers) <=
 		    max_zone_concurrent_reclaimers)
@@ -1631,18 +1634,21 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
                 * break out of the loop and go back to the allocator.
                 */
 		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
-					0, 0)) {
-			wake_up_all(wq);
-			finish_wait(wq, &wait);
-			sc->nr_reclaimed += sc->nr_to_reclaim;
-			return -ERESTARTSYS;
-		}
+					0, 0))
+			goto found_lots_memory;
 	}
 	finish_wait(wq, &wait);
 
  out:
 	atomic_inc(&zone->concurrent_reclaimers);
 	return 0;
+
+ found_lots_memory:
+	wake_up_all(wq);
+ stop_reclaim:
+	finish_wait(wq, &wait);
+	sc->nr_reclaimed += sc->nr_to_reclaim;
+	return -ERESTARTSYS;
 }
 
 static void shrink_zone_end(struct zone *zone, struct scan_control *sc)
-- 
1.6.5.2



