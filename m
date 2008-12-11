Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYLKIGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYLKIGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYLKIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:05:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39949 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbYLKIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:05:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH for -mm] bailing out check first
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081211170321.500B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 11 Dec 2008 17:05:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch intent to fix trivial problem of rvr bailing out patch.
Is this useful?



==
Subject: [PATCH for -mm] bailing out check first

current reclaim bailing out logic has a bit inefficiency.

example, if system has 4 node and reclaim logic can get enough memory from first node,
current logic works as following.

1. reclaim node-1 and success reclaim enough memory.
   then, bailing out happend.
2. shrink_zones() call shrink_zone(node-2) and scan 32 page on each lru list.
   after that, shrink_zone stop node-2 reclaim by bailing out logic.
3. shrink_zones() call shrink_zone(node-3) ...
4. shrink_zones() call shrink_zone(node-4) ...

step 2-4 are unnecessary.
it can be removed.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1452,15 +1452,6 @@ static void shrink_zone(int priority, st
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-		for_each_evictable_lru(l) {
-			if (nr[l]) {
-				nr_to_scan = min(nr[l], swap_cluster_max);
-				nr[l] -= nr_to_scan;
-
-				nr_reclaimed += shrink_list(l, nr_to_scan,
-							    zone, sc, priority);
-			}
-		}
 		/*
 		 * On large memory systems, scan >> priority can become
 		 * really large. This is fine for the starting priority;
@@ -1472,6 +1463,16 @@ static void shrink_zone(int priority, st
 		if (nr_reclaimed > swap_cluster_max &&
 		    priority < DEF_PRIORITY && !current_is_kswapd())
 			break;
+
+		for_each_evictable_lru(l) {
+			if (nr[l]) {
+				nr_to_scan = min(nr[l], swap_cluster_max);
+				nr[l] -= nr_to_scan;
+
+				nr_reclaimed += shrink_list(l, nr_to_scan,
+							    zone, sc, priority);
+			}
+		}
 	}
 
 	sc->nr_reclaimed = nr_reclaimed;


