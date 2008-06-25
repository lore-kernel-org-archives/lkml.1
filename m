Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYFYKJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYFYKJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYFYKJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:09:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59530 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbYFYKJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:09:04 -0400
Date: Wed, 25 Jun 2008 19:07:47 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>
Subject: [-mm][PATCH 7/10]  prevent incorrect oom under split_lru
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080625190639.D861.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if zone->recent_scanned parameter become inbalanceing anon and file,
OOM killer can happened although swappable page exist.

So, if priority==0, We should try to reclaim all page for prevent OOM.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>

---
 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1460,8 +1460,10 @@ static unsigned long shrink_zone(int pri
 			 * kernel will slowly sift through each list.
 			 */
 			scan = zone_page_state(zone, NR_LRU_BASE + l);
-			scan >>= priority;
-			scan = (scan * percent[file]) / 100;
+			if (priority) {
+				scan >>= priority;
+				scan = (scan * percent[file]) / 100;
+			}
 			zone->lru[l].nr_scan += scan + 1;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)


