Return-Path: <linux-kernel-owner+w=401wt.eu-S937285AbYD1Tat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937285AbYD1Tat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935148AbYD1TaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:30:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57384 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937070AbYD1TaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:30:01 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, apw@shadowen.org, mingo@elte.hu, clameter@sgi.com
Message-Id: <20080428192959.23649.58799.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20080428192839.23649.82172.sendpatchset@skynet.skynet.ie>
References: <20080428192839.23649.82172.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 4/4] Print out the zonelists on request for manual verification
Date: Mon, 28 Apr 2008 20:29:59 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch prints out the zonelists during boot for manual verification by
the user if the mminit_loglevel is MMINIT_VERIFY or higher.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 mm/internal.h   |    5 +++++
 mm/mm_init.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c |    1 +
 3 files changed, 51 insertions(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.25-mm1-0025_defensive_pfn_checks/mm/internal.h linux-2.6.25-mm1-0030_display_zonelist/mm/internal.h
--- linux-2.6.25-mm1-0025_defensive_pfn_checks/mm/internal.h	2008-04-28 14:41:59.000000000 +0100
+++ linux-2.6.25-mm1-0030_display_zonelist/mm/internal.h	2008-04-28 14:47:09.000000000 +0100
@@ -81,6 +81,7 @@ do { \
 extern void mminit_verify_pageflags_layout(void);
 extern void mminit_verify_page_links(struct page *page,
 		enum zone_type zone, unsigned long nid, unsigned long pfn);
+extern void mminit_verify_zonelist(void);
 
 #else
 
@@ -97,6 +98,10 @@ static inline void mminit_verify_page_li
 		enum zone_type zone, unsigned long nid, unsigned long pfn)
 {
 }
+
+static inline void mminit_verify_zonelist(void)
+{
+}
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
 /* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.25-mm1-0025_defensive_pfn_checks/mm/mm_init.c linux-2.6.25-mm1-0030_display_zonelist/mm/mm_init.c
--- linux-2.6.25-mm1-0025_defensive_pfn_checks/mm/mm_init.c	2008-04-28 14:41:48.000000000 +0100
+++ linux-2.6.25-mm1-0030_display_zonelist/mm/mm_init.c	2008-04-28 14:47:09.000000000 +0100
@@ -11,6 +11,51 @@
 
 int __meminitdata mminit_loglevel;
 
+/* The zonelists are simply reported, validation is manual. */
+void mminit_verify_zonelist(void)
+{
+	int nid;
+
+	if (mminit_loglevel < MMINIT_VERIFY)
+		return;
+
+	for_each_online_node(nid) {
+		pg_data_t *pgdat = NODE_DATA(nid);
+		struct zone *zone;
+		struct zoneref *z;
+		struct zonelist *zonelist;
+		int i, listid, zoneid;
+
+		BUG_ON(MAX_ZONELISTS > 2);
+		for (i = 0; i < MAX_ZONELISTS * MAX_NR_ZONES; i++) {
+
+			/* Identify the zone and nodelist */
+			zoneid = i % MAX_NR_ZONES;
+			listid = i / MAX_NR_ZONES;
+			zonelist = &pgdat->node_zonelists[listid];
+			zone = &pgdat->node_zones[zoneid];
+			if (!populated_zone(zone))
+				continue;
+
+			/* Print information about the zonelist */
+			printk(KERN_DEBUG "mminit::zonelist %s %d:%s = ",
+				listid > 0 ? "thisnode" : "general", nid,
+				zone->name);
+
+			/* Iterate the zonelist */
+			for_each_zone_zonelist(zone, z, zonelist, zoneid) {
+#ifdef CONFIG_NUMA
+				printk(KERN_CONT "%d:%s ",
+					zone->node, zone->name);
+#else
+				printk(KERN_CONT "0:%s ", zone->name);
+#endif /* CONFIG_NUMA */
+			}
+			printk(KERN_CONT "\n");
+		}
+	}
+}
+
 void __init mminit_verify_pageflags_layout(void)
 {
 	int shift, width;
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.25-mm1-0025_defensive_pfn_checks/mm/page_alloc.c linux-2.6.25-mm1-0030_display_zonelist/mm/page_alloc.c
--- linux-2.6.25-mm1-0025_defensive_pfn_checks/mm/page_alloc.c	2008-04-28 14:41:59.000000000 +0100
+++ linux-2.6.25-mm1-0030_display_zonelist/mm/page_alloc.c	2008-04-28 14:47:09.000000000 +0100
@@ -2456,6 +2456,7 @@ void build_all_zonelists(void)
 
 	if (system_state == SYSTEM_BOOTING) {
 		__build_all_zonelists(NULL);
+		mminit_verify_zonelist();
 		cpuset_init_current_mems_allowed();
 	} else {
 		/* we have to stop all cpus to guarantee there is no user
