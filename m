Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZLNM3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZLNM3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZLNM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:29:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44798 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbZLNM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:29:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH 3/8] Don't use sleep_on()
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214212449.BBB7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:29:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on() is SMP and/or kernel preemption unsafe. This patch
replace it with safe code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   40 ++++++++++++++++++++++++++++++----------
 1 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 74c36fe..3be5345 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1599,15 +1599,32 @@ static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
 
 static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
 {
-	if (!current_is_kswapd() &&
-	    atomic_read(&zone->concurrent_reclaimers) > max_zone_concurrent_reclaimers &&
-	    (sc->gfp_mask & (__GFP_IO|__GFP_FS)) == (__GFP_IO|__GFP_FS)) {
-		/*
-		 * Do not add to the lock contention if this zone has
-		 * enough processes doing page reclaim already, since
-		 * we would just make things slower.
-		 */
-		sleep_on(&zone->reclaim_wait);
+	DEFINE_WAIT(wait);
+	wait_queue_head_t *wq = &zone->reclaim_wait;
+
+	if (current_is_kswapd())
+		goto out;
+
+	/*
+	 * GFP_NOIO and GFP_NOFS mean caller may have some lock implicitly.
+	 * Thus, we can't wait here. otherwise it might cause deadlock.
+	 */
+	if ((sc->gfp_mask & (__GFP_IO|__GFP_FS)) != (__GFP_IO|__GFP_FS))
+		goto out;
+
+	/*
+	 * Do not add to the lock contention if this zone has
+	 * enough processes doing page reclaim already, since
+	 * we would just make things slower.
+	 */
+	for (;;) {
+		prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
+
+		if (atomic_read(&zone->concurrent_reclaimers) <=
+		    max_zone_concurrent_reclaimers)
+			break;
+
+		schedule();
 
 		/*
 		 * If other processes freed enough memory while we waited,
@@ -1615,12 +1632,15 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
 		 */
 		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
 					0, 0)) {
-			wake_up(&zone->reclaim_wait);
+			wake_up(wq);
+			finish_wait(wq, &wait);
 			sc->nr_reclaimed += sc->nr_to_reclaim;
 			return -ERESTARTSYS;
 		}
 	}
+	finish_wait(wq, &wait);
 
+ out:
 	atomic_inc(&zone->concurrent_reclaimers);
 	return 0;
 }
-- 
1.6.5.2



