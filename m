Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZLNMaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZLNMaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZLNMaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:30:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35270 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZLNMaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:30:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH 4/8] Use prepare_to_wait_exclusive() instead prepare_to_wait()
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214212936.BBBA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:30:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if we don't use exclusive queue, wake_up() function wake _all_ waited
task. This is simply cpu wasting.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e0cb834..3562a2d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1618,7 +1618,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
 	 * we would just make things slower.
 	 */
 	for (;;) {
-		prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait_exclusive(wq, &wait, TASK_UNINTERRUPTIBLE);
 
 		if (atomic_read(&zone->concurrent_reclaimers) <=
 		    max_zone_concurrent_reclaimers)
@@ -1632,7 +1632,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
                 */
 		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
 					0, 0)) {
-			wake_up(wq);
+			wake_up_all(wq);
 			finish_wait(wq, &wait);
 			sc->nr_reclaimed += sc->nr_to_reclaim;
 			return -ERESTARTSYS;
-- 
1.6.5.2



