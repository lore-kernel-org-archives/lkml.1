Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZFJF2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZFJF2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZFJF2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:28:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34208 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZFJF2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:28:47 -0400
Date: Wed, 10 Jun 2009 14:27:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
Subject: [PATCH 2/2] memcg: fix LRU rotation at __isolate_page
Message-Id: <20090610142717.09286cd2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090610142443.9370aff8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090610142443.9370aff8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depends on fix to lumpy reclaim, so, updated.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch tries to fix memcg's lru rotation sanity...make memcg use
the same logic as global LRU does.

Now, at __isolate_lru_page() retruns -EBUSY, the page is rotated to
the tail of LRU in global LRU's isolate LRU pages. But in memcg,
it's not handled. This makes memcg do the same behavior as global LRU
and rotate LRU in the page is busy.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |   13 ++++++++++++-
 mm/vmscan.c     |    4 +++-
 2 files changed, 15 insertions(+), 2 deletions(-)

Index: mmotm-2.6.30-Jun10/mm/vmscan.c
===================================================================
--- mmotm-2.6.30-Jun10.orig/mm/vmscan.c
+++ mmotm-2.6.30-Jun10/mm/vmscan.c
@@ -844,7 +844,6 @@ int __isolate_lru_page(struct page *page
 		 */
 		ClearPageLRU(page);
 		ret = 0;
-		mem_cgroup_del_lru(page);
 	}
 
 	return ret;
@@ -898,6 +897,7 @@ try_lumpy_reclaim(struct page *page, str
 			/* we are always under ISOLATE_BOTH */
 			if (__isolate_lru_page(page, ISOLATE_BOTH, 0) == 0) {
 				list_move(&page->lru, dst);
+				mem_cgroup_del_lru(page);
 				nr++;
 			} else if (do_aggressive && !PageUnevictable(page))
 					continue;
@@ -951,12 +951,14 @@ static unsigned long isolate_lru_pages(u
 		switch (__isolate_lru_page(page, mode, file)) {
 		case 0:
 			list_move(&page->lru, dst);
+			mem_cgroup_del_lru(page);
 			nr_taken++;
 			break;
 
 		case -EBUSY:
 			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
+			mem_cgroup_rotate_lru_list(page, page_lru(page));
 			continue;
 
 		default:
Index: mmotm-2.6.30-Jun10/mm/memcontrol.c
===================================================================
--- mmotm-2.6.30-Jun10.orig/mm/memcontrol.c
+++ mmotm-2.6.30-Jun10/mm/memcontrol.c
@@ -649,6 +649,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
 	int lru = LRU_FILE * !!file + !!active;
+	int ret;
 
 	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
@@ -666,9 +667,19 @@ unsigned long mem_cgroup_isolate_pages(u
 			continue;
 
 		scan++;
-		if (__isolate_lru_page(page, mode, file) == 0) {
+		ret = __isolate_lru_page(page, mode, file);
+		switch (ret) {
+		case 0:
 			list_move(&page->lru, dst);
+			mem_cgroup_del_lru(page);
 			nr_taken++;
+			break;
+		case -EBUSY:
+			/* we don't affect global LRU but rotate in our LRU */
+			mem_cgroup_rotate_lru_list(page, page_lru(page));
+			break;
+		default:
+			break;
 		}
 	}
 

