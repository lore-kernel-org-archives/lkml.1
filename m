Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYLAMOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYLAMOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYLAMO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:14:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47275 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYLAMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:14:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 04/11] make get_scan_ratio() to memcg safe
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081201211342.1CD6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 21:14:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, get_scan_ratio() always calculate the balancing value for global reclaim and
memcg reclaim doesn't use it.
Therefore it doesn't have scan_global_lru() condition.

However, we plan to expand get_scan_ratio() to be usable for memcg too, latter.
Then, The dependency code of global reclaim in the get_scan_ratio() insert into
scan_global_lru() condision explictly.


this patch doesn't have any functional change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1435,13 +1435,16 @@ static void get_scan_ratio(struct zone *
 		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
 		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
-	free  = zone_page_state(zone, NR_FREE_PAGES);
 
-	/* If we have very few page cache pages, force-scan anon pages. */
-	if (unlikely(file + free <= zone->pages_high)) {
-		percent[0] = 100;
-		percent[1] = 0;
-		return;
+	if (scan_global_lru(sc)) {
+		free  = zone_page_state(zone, NR_FREE_PAGES);
+		/* If we have very few page cache pages,
+		   force-scan anon pages. */
+		if (unlikely(file + free <= zone->pages_high)) {
+			percent[0] = 100;
+			percent[1] = 0;
+			return;
+		}
 	}
 
 	/*


