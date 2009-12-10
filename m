Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbZLJIDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbZLJIDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbZLJIDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:03:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45454 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760699AbZLJID3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:03:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 17:00:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: [RFC mm][PATCH 4/5] add a lowmem check function
Message-Id: <20091210170036.dde2c147.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Final purpose of this patch is for improving oom/memoy shortage detection
better. In general there are OOM cases that lowmem is exhausted. What
this lowmem means is determined by the situation, but in general, 
limited amount of memory for some special use is lowmem.

This patch adds an integer lowmem_zone, which is initialized to -1.
If zone_idx(zone) <= lowmem_zone, the zone is lowmem.

This patch uses simple definition that the zone for special use is the lowmem.
Not taking the amount of memory into account.

For example,
  - if HIGHMEM is used, NORMAL is lowmem.
  - If the system has both of NORMAL and DMA32, DMA32 is lowmem.
  - When the system consists of only one zone, there are no lowmem.

This will be used for lowmem accounting per mm_struct and its information
will be used for oom-killer.

Changelog: 2009/12/09
 - stop using policy_zone and use unified definition on each config.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mm.h |    9 +++++++
 mm/page_alloc.c    |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

Index: mmotm-2.6.32-Dec8/include/linux/mm.h
===================================================================
--- mmotm-2.6.32-Dec8.orig/include/linux/mm.h
+++ mmotm-2.6.32-Dec8/include/linux/mm.h
@@ -583,6 +583,15 @@ static inline void set_page_links(struct
 }
 
 /*
+ * Check a page is in lower zone
+ */
+extern int lowmem_zone;
+static inline bool is_lowmem_page(struct page *page)
+{
+	return page_zonenum(page) <= lowmem_zone;
+}
+
+/*
  * Some inline functions in vmstat.h depend on page_zone()
  */
 #include <linux/vmstat.h>
Index: mmotm-2.6.32-Dec8/mm/page_alloc.c
===================================================================
--- mmotm-2.6.32-Dec8.orig/mm/page_alloc.c
+++ mmotm-2.6.32-Dec8/mm/page_alloc.c
@@ -2311,6 +2311,59 @@ static void zoneref_set_zone(struct zone
 	zoneref->zone_idx = zone_idx(zone);
 }
 
+/* the zone is lowmem if zone_idx(zone) <= lowmem_zone */
+int lowmem_zone __read_mostly;
+/*
+ * Find out LOWMEM zone on this host. LOWMEM means a zone for special use
+ * and its size seems small and precious than other zones. For example,
+ * NORMAL zone is considered to be LOWMEM on a host which has HIGHMEM.
+ *
+ * This lowmem zone is determined by zone ordering and equipped memory layout.
+ * The amount of memory is not taken into account now.
+ */
+static void find_lowmem_zone(void)
+{
+	unsigned long pages[MAX_NR_ZONES];
+	struct zone *zone;
+	int idx;
+
+	for (idx = 0; idx < MAX_NR_ZONES; idx++)
+		pages[idx] = 0;
+	/* count the number of pages */
+	for_each_populated_zone(zone) {
+		idx = zone_idx(zone);
+		pages[idx] += zone->present_pages;
+	}
+	/* If We have HIGHMEM...we ignore ZONE_MOVABLE in this case. */
+#ifdef CONFIG_HIGHMEM
+	if (pages[ZONE_HIGHMEM]) {
+		lowmem_zone = ZONE_NORMAL;
+		return;
+	}
+#endif
+	/* If We have MOVABLE zone...which works like HIGHMEM. */
+	if (pages[ZONE_MOVABLE]) {
+		lowmem_zone = ZONE_NORMAL;
+		return;
+	}
+#ifdef CONFIG_ZONE_DMA32
+	/* If we have DMA32 and there is ZONE_NORMAL...*/
+	if (pages[ZONE_DMA32] && pages[ZONE_NORMAL]) {
+		lowmem_zone = ZONE_DMA32;
+		return;
+	}
+#endif
+#ifdef CONFIG_ZONE_DMA
+	/* If we have DMA and there is ZONE_NORMAL...*/
+	if (pages[ZONE_DMA] && pages[ZONE_NORMAL]) {
+		lowmem_zone = ZONE_DMA;
+		return;
+	}
+#endif
+	lowmem_zone = -1;
+	return;
+}
+
 /*
  * Builds allocation fallback zone lists.
  *
@@ -2790,12 +2843,21 @@ void build_all_zonelists(void)
 	else
 		page_group_by_mobility_disabled = 0;
 
+	find_lowmem_zone();
+
 	printk("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
 			nr_online_nodes,
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
+
+	if (lowmem_zone >= 0)
+		printk("LOWMEM zone is detected as %s\n",
+			zone_names[lowmem_zone]);
+	else
+		printk("There are no special LOWMEM. The system seems flat\n");
+
 #ifdef CONFIG_NUMA
 	printk("Policy zone: %s\n", zone_names[policy_zone]);
 #endif

