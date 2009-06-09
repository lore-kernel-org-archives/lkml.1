Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbZFIJYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbZFIJYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZFIJYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:24:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60962 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbZFIJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:24:23 -0400
Date: Tue, 9 Jun 2009 18:22:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH] memcg: fix mem_cgroup_isolate_lru_page to use the same
 rotate logic at busy path
Message-Id: <20090609182253.009c98a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch tries to fix memcg's lru rotation sanity...make memcg use
the same logic as global LRU does.

Now, at __isolate_lru_page() retruns -EBUSY, the page is rotated to
the tail of LRU in global LRU's isolate LRU pages. But in memcg,
it's not handled. This makes memcg do the same behavior as global LRU
and rotate LRU in the page is busy.

Note: __isolate_lru_page() is not isolate_lru_page() and it's just used
in sc->isolate_pages() logic.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |   13 ++++++++++++-
 mm/vmscan.c     |    4 +++-
 2 files changed, 15 insertions(+), 2 deletions(-)

Index: mmotm-2.6.30-Jun4/mm/vmscan.c
===================================================================
--- mmotm-2.6.30-Jun4.orig/mm/vmscan.c
+++ mmotm-2.6.30-Jun4/mm/vmscan.c
@@ -842,7 +842,6 @@ int __isolate_lru_page(struct page *page
 		 */
 		ClearPageLRU(page);
 		ret = 0;
-		mem_cgroup_del_lru(page);
 	}
 
 	return ret;
@@ -890,12 +889,14 @@ static unsigned long isolate_lru_pages(u
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
@@ -937,6 +938,7 @@ static unsigned long isolate_lru_pages(u
 			switch (__isolate_lru_page(cursor_page, mode, file)) {
 			case 0:
 				list_move(&cursor_page->lru, dst);
+				mem_cgroup_del_lru(page);
 				nr_taken++;
 				scan++;
 				break;
Index: mmotm-2.6.30-Jun4/mm/memcontrol.c
===================================================================
--- mmotm-2.6.30-Jun4.orig/mm/memcontrol.c
+++ mmotm-2.6.30-Jun4/mm/memcontrol.c
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
 

