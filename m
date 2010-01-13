Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006Ab0AMIVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0AMIVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843Ab0AMIVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:21:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51510 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0AMIVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:21:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
References: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
Message-Id: <20100113171953.B3E5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Jan 2010 17:21:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog
 from v1
 - get_anon_scan_ratio don't tak zone->lru_lock anymore
   because zoneinfo_show_print takes zone->lock.


======================================
Vmscan folks was asked "why does my system makes so much swap-out?"
in lkml at several times.
At that time, I made the debug patch to show recent_anon_{scanned/rorated}
parameter at least three times.

Thus, its parameter should be showed on /proc/zoneinfo. It help
vmscan folks debugging.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h |    2 ++
 mm/vmscan.c          |   50 ++++++++++++++++++++++++++++++++++++--------------
 mm/vmstat.c          |    7 +++++--
 3 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a2602a8..e95d7ed 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -280,6 +280,8 @@ extern void scan_unevictable_unregister_node(struct node *node);
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
 
+unsigned long get_anon_scan_ratio(struct zone *zone, struct mem_cgroup *memcg, int swappiness);
+
 #ifdef CONFIG_MMU
 /* linux/mm/shmem.c */
 extern int shmem_unuse(swp_entry_t entry, struct page *page);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 640486b..0900931 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1493,8 +1493,8 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
  * percent[0] specifies how much pressure to put on ram/swap backed
  * memory, while percent[1] determines pressure on the file LRUs.
  */
-static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
-					unsigned long *percent)
+static void __get_scan_ratio(struct zone *zone, struct scan_control *sc,
+			     int need_update, unsigned long *percent)
 {
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
@@ -1535,18 +1535,19 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 	 *
 	 * anon in [0], file in [1]
 	 */
-	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
-		spin_lock_irq(&zone->lru_lock);
-		reclaim_stat->recent_scanned[0] /= 2;
-		reclaim_stat->recent_rotated[0] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
-	}
-
-	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
-		spin_lock_irq(&zone->lru_lock);
-		reclaim_stat->recent_scanned[1] /= 2;
-		reclaim_stat->recent_rotated[1] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
+	if (need_update) {
+		if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
+			spin_lock_irq(&zone->lru_lock);
+			reclaim_stat->recent_scanned[0] /= 2;
+			reclaim_stat->recent_rotated[0] /= 2;
+			spin_unlock_irq(&zone->lru_lock);
+		}
+		if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
+			spin_lock_irq(&zone->lru_lock);
+			reclaim_stat->recent_scanned[1] /= 2;
+			reclaim_stat->recent_rotated[1] /= 2;
+			spin_unlock_irq(&zone->lru_lock);
+		}
 	}
 
 	/*
@@ -1572,6 +1573,27 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 	percent[1] = 100 - percent[0];
 }
 
+static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
+			   unsigned long *percent)
+{
+	__get_scan_ratio(zone, sc, 1, percent);
+}
+
+unsigned long get_anon_scan_ratio(struct zone *zone, struct mem_cgroup *memcg, int swappiness)
+{
+	unsigned long percent[2];
+	struct scan_control sc = {
+		.may_swap = 1,
+		.swappiness = swappiness,
+		.mem_cgroup = memcg,
+	};
+
+	__get_scan_ratio(zone, &sc, 0, percent);
+
+	return percent[0];
+}
+
+
 /*
  * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
  * until we collected @swap_cluster_max pages to scan.
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6051fba..f690117 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/vmstat.h>
 #include <linux/sched.h>
+#include <linux/swap.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -760,11 +761,13 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu"
-		   "\n  inactive_ratio:    %u",
+		   "\n  inactive_ratio:    %u"
+		   "\n  anon_scan_ratio:   %lu",
 			   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
 		   zone->zone_start_pfn,
-		   zone->inactive_ratio);
+		   zone->inactive_ratio,
+		   get_anon_scan_ratio(zone, NULL, vm_swappiness));
 	seq_putc(m, '\n');
 }
 
-- 
1.6.5.2



