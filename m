Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZFKIFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZFKIFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZFKIFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:05:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36817 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZFKIFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:05:31 -0400
Date: Thu, 11 Jun 2009 17:04:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
Subject: [PATCH 3/3] memcg: fix LRU rotation of isolate_lru_pages with memcg
Message-Id: <20090611170400.638bdb90.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch tries to fix memcg's lru rotation logic to make memcg use
the same logic as global LRU does.

Now, at __isolate_lru_page() retruns -EBUSY, the page is rotated to
the tail of LRU in global LRU's isolate LRU pages. But in memcg,
it's not handled. This makes memcg do the same behavior as global LRU
and rotate LRU in the page is busy.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
Index: lumpy-reclaim-trial/mm/vmscan.c
===================================================================
--- lumpy-reclaim-trial.orig/mm/vmscan.c	2009-06-10 19:48:28.000000000 +0900
+++ lumpy-reclaim-trial/mm/vmscan.c	2009-06-10 20:06:55.000000000 +0900
@@ -844,7 +844,6 @@
 		 */
 		ClearPageLRU(page);
 		ret = 0;
-		mem_cgroup_del_lru(page);
 	}
 
 	return ret;
@@ -892,12 +891,14 @@
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
@@ -941,6 +942,7 @@
 				break;
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
+				mem_cgroup_del_lru(page);
 				nr_taken++;
 				scan++;
 				break;
Index: lumpy-reclaim-trial/mm/memcontrol.c
===================================================================
--- lumpy-reclaim-trial.orig/mm/memcontrol.c	2009-06-10 17:30:23.000000000 +0900
+++ lumpy-reclaim-trial/mm/memcontrol.c	2009-06-10 20:05:21.000000000 +0900
@@ -649,6 +649,7 @@
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
 	int lru = LRU_FILE * !!file + !!active;
+	int ret;
 
 	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
@@ -666,9 +667,19 @@
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
 

