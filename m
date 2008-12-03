Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYLCE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYLCE6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYLCE6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:58:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52276 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYLCE6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:58:04 -0500
Date: Wed, 3 Dec 2008 13:57:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  9/21] make-get_scan_ratio-to-memcg-safe.patch
Message-Id: <20081203135712.4c89b83d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Index: mmotm-2.6.28-Dec02/mm/vmscan.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/vmscan.c
+++ mmotm-2.6.28-Dec02/mm/vmscan.c
@@ -1430,13 +1430,16 @@ static void get_scan_ratio(struct zone *
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

