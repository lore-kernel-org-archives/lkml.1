Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZL1Htb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZL1Htb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZL1Hta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:49:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45107 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZL1Hta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:49:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 4/4] memcg: add anon_scan_ratio to memory.stat file
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20091228164451.A687.A69D9226@jp.fujitsu.com>
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
Message-Id: <20091228164857.A690.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Dec 2009 16:49:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anon_scan_ratio feature doesn't only useful for global VM pressure
analysis, but it also useful for memcg memroy pressure analysis.

Then, this patch add anon_scan_ratio field to memory.stat file too.

Instead, following debug statistics was removed. It isn't so user and/or
developer friendly.

	- recent_rotated_anon
	- recent_rotated_file
	- recent_scanned_anon
	- recent_scanned_file

This removing don't cause ABI issue. because it was enclosed
CONFIG_DEBUG_VM.

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |   43 +++++++++++++++++++------------------------
 1 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 325df12..daa027c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2950,6 +2950,9 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 {
 	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
 	struct mcs_total_stat mystat;
+	struct zone *zone;
+	unsigned long total_anon = 0;
+	unsigned long total_scan_anon = 0;
 	int i;
 
 	memset(&mystat, 0, sizeof(mystat));
@@ -2978,34 +2981,26 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
 	}
 
-#ifdef CONFIG_DEBUG_VM
 	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
 
-	{
-		int nid, zid;
+	for_each_populated_zone(zone) {
+		int nid = zone->zone_pgdat->node_id;
+		int zid = zone_idx(zone);
 		struct mem_cgroup_per_zone *mz;
-		unsigned long recent_rotated[2] = {0, 0};
-		unsigned long recent_scanned[2] = {0, 0};
-
-		for_each_online_node(nid)
-			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
-
-				recent_rotated[0] +=
-					mz->reclaim_stat.recent_rotated[0];
-				recent_rotated[1] +=
-					mz->reclaim_stat.recent_rotated[1];
-				recent_scanned[0] +=
-					mz->reclaim_stat.recent_scanned[0];
-				recent_scanned[1] +=
-					mz->reclaim_stat.recent_scanned[1];
-			}
-		cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
-		cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
-		cb->fill(cb, "recent_scanned_anon", recent_scanned[0]);
-		cb->fill(cb, "recent_scanned_file", recent_scanned[1]);
+		unsigned long anon;
+		unsigned long ratio;
+
+		mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
+
+		anon = MEM_CGROUP_ZSTAT(mz, LRU_INACTIVE_ANON);
+		anon += MEM_CGROUP_ZSTAT(mz, LRU_ACTIVE_ANON);
+
+		ratio = get_anon_scan_ratio(zone, mem_cont, mem_cont->swappiness);
+
+		total_anon += anon;
+		total_scan_anon += anon * ratio;
 	}
-#endif
+	cb->fill(cb, "anon_scan_ratio", total_scan_anon / total_anon);
 
 	return 0;
 }
-- 
1.6.5.2



