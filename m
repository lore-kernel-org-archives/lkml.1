Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYLCFH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYLCFH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYLCFHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:07:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60105 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYLCFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:07:50 -0500
Date: Wed, 3 Dec 2008 14:06:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  16/21] memcg-rename-scan-glonal-lru.patch
Message-Id: <20081203140654.ec38be9d.kamezawa.hiroyu@jp.fujitsu.com>
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

Rename scan_global_lru() to scanning_global_lru().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/vmscan.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: mmotm-2.6.28-Dec02/mm/vmscan.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/vmscan.c
+++ mmotm-2.6.28-Dec02/mm/vmscan.c
@@ -126,15 +126,15 @@ static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-#define scan_global_lru(sc)	(!(sc)->mem_cgroup)
+#define scanning_global_lru(sc)	(!(sc)->mem_cgroup)
 #else
-#define scan_global_lru(sc)	(1)
+#define scanning_global_lru(sc)	(1)
 #endif
 
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
 						  struct scan_control *sc)
 {
-	if (!scan_global_lru(sc))
+	if (!scanning_global_lru(sc))
 		mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
 
 	return &zone->reclaim_stat;
@@ -143,7 +143,7 @@ static struct zone_reclaim_stat *get_rec
 static unsigned long zone_nr_pages(struct zone *zone, struct scan_control *sc,
 				   enum lru_list lru)
 {
-	if (!scan_global_lru(sc))
+	if (!scanning_global_lru(sc))
 		return mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone, lru);
 
 	return zone_page_state(zone, NR_LRU_BASE + lru);
@@ -1144,7 +1144,7 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scan_global_lru(sc))
+		if (scanning_global_lru(sc))
 			zone->pages_scanned += nr_scan;
 
 		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
@@ -1183,7 +1183,7 @@ static unsigned long shrink_inactive_lis
 		if (current_is_kswapd()) {
 			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scan);
 			__count_vm_events(KSWAPD_STEAL, nr_freed);
-		} else if (scan_global_lru(sc))
+		} else if (scanning_global_lru(sc))
 			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
 
 		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
@@ -1282,7 +1282,7 @@ static void shrink_active_list(unsigned 
 	 * zone->pages_scanned is used for detect zone's oom
 	 * mem_cgroup remembers nr_scan by itself.
 	 */
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
 	reclaim_stat->recent_scanned[!!file] += pgmoved;
@@ -1391,7 +1391,7 @@ static int inactive_anon_is_low(struct z
 {
 	int low;
 
-	if (scan_global_lru(sc))
+	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
 		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, zone);
@@ -1445,7 +1445,7 @@ static void get_scan_ratio(struct zone *
 	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
 		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
 
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
 		   force-scan anon pages. */
@@ -1527,7 +1527,7 @@ static void shrink_zone(int priority, st
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)
@@ -1602,7 +1602,7 @@ static void shrink_zones(int priority, s
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
 		 */
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
 			note_zone_scanning_priority(zone, priority);
@@ -1655,12 +1655,12 @@ static unsigned long do_try_to_free_page
 
 	delayacct_freepages_start();
 
-	if (scan_global_lru(sc))
+	if (scanning_global_lru(sc))
 		count_vm_event(ALLOCSTALL);
 	/*
 	 * mem_cgroup will not do shrink_slab.
 	 */
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
@@ -1679,7 +1679,7 @@ static unsigned long do_try_to_free_page
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
 		 */
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages, NULL);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
@@ -1710,7 +1710,7 @@ static unsigned long do_try_to_free_page
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (!sc->all_unreclaimable && scan_global_lru(sc))
+	if (!sc->all_unreclaimable && scanning_global_lru(sc))
 		ret = sc->nr_reclaimed;
 out:
 	/*
@@ -1723,7 +1723,7 @@ out:
 	if (priority < 0)
 		priority = 0;
 
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))

