Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYFKSv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYFKSv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYFKSri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058AbYFKSrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:31 -0400
Message-Id: <20080611184339.628665744@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:27 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 13/24] Unevictable LRU Page Statistics
Content-Disposition: inline; filename=vmscan-noreclaim-lru-page-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Report unevictable pages per zone and system wide.

Kosaki Motohiro added support for memory controller unevictable
statistics.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---

 drivers/base/node.c |    6 ++++++
 fs/proc/proc_misc.c |    6 ++++++
 mm/memcontrol.c     |    6 ++++++
 mm/page_alloc.c     |   16 +++++++++++++++-
 mm/vmstat.c         |    3 +++
 5 files changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/page_alloc.c	2008-06-10 22:13:37.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/page_alloc.c	2008-06-10 22:36:56.000000000 -0400
@@ -1844,12 +1844,20 @@ void show_free_areas(void)
 	}
 
 	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
-		" inactive_file:%lu dirty:%lu writeback:%lu unstable:%lu\n"
+		" inactive_file:%lu"
+//TODO:  check/adjust line lengths
+#ifdef CONFIG_UNEVICTABLE_LRU
+		" unevictable:%lu"
+#endif
+		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_INACTIVE_FILE),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		global_page_state(NR_UNEVICTABLE),
+#endif
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
@@ -1876,6 +1884,9 @@ void show_free_areas(void)
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
 			" inactive_file:%lukB"
+#ifdef CONFIG_UNEVICTABLE_LRU
+			" unevictable:%lukB"
+#endif
 			" present:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
@@ -1889,6 +1900,9 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
+#ifdef CONFIG_UNEVICTABLE_LRU
+			K(zone_page_state(zone, NR_UNEVICTABLE)),
+#endif
 			K(zone->present_pages),
 			zone->pages_scanned,
 			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
Index: linux-2.6.26-rc5-mm2/mm/vmstat.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmstat.c	2008-06-10 22:13:33.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmstat.c	2008-06-10 22:36:56.000000000 -0400
@@ -606,6 +606,9 @@ static const char * const vmstat_text[] 
 	"nr_active_anon",
 	"nr_inactive_file",
 	"nr_active_file",
+#ifdef CONFIG_UNEVICTABLE_LRU
+	"nr_unevictable",
+#endif
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
Index: linux-2.6.26-rc5-mm2/drivers/base/node.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/drivers/base/node.c	2008-06-10 22:13:33.000000000 -0400
+++ linux-2.6.26-rc5-mm2/drivers/base/node.c	2008-06-10 22:37:14.000000000 -0400
@@ -67,6 +67,9 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Inactive(anon): %8lu kB\n"
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
+#ifdef CONFIG_UNEVICTABLE_LRU
+		       "Node %d Noreclaim:      %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
 		       "Node %d HighFree:       %8lu kB\n"
@@ -96,6 +99,9 @@ static ssize_t node_read_meminfo(struct 
 		       nid, node_page_state(nid, NR_INACTIVE_ANON),
 		       nid, node_page_state(nid, NR_ACTIVE_FILE),
 		       nid, node_page_state(nid, NR_INACTIVE_FILE),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		       nid, node_page_state(nid, NR_UNEVICTABLE),
+#endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
Index: linux-2.6.26-rc5-mm2/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/fs/proc/proc_misc.c	2008-06-10 22:13:33.000000000 -0400
+++ linux-2.6.26-rc5-mm2/fs/proc/proc_misc.c	2008-06-10 22:36:56.000000000 -0400
@@ -175,6 +175,9 @@ static int meminfo_read_proc(char *page,
 		"Inactive(anon): %8lu kB\n"
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
+#ifdef CONFIG_UNEVICTABLE_LRU
+		"Unevictable:    %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
 		"HighFree:       %8lu kB\n"
@@ -210,6 +213,9 @@ static int meminfo_read_proc(char *page,
 		K(pages[LRU_INACTIVE_ANON]),
 		K(pages[LRU_ACTIVE_FILE]),
 		K(pages[LRU_INACTIVE_FILE]),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		K(pages[LRU_UNEVICTABLE]),
+#endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
 		K(i.freehigh),
Index: linux-2.6.26-rc5-mm2/mm/memcontrol.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/memcontrol.c	2008-06-10 22:13:37.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/memcontrol.c	2008-06-10 22:13:38.000000000 -0400
@@ -930,6 +930,7 @@ static int mem_control_stat_show(struct 
 	{
 		unsigned long active_anon, inactive_anon;
 		unsigned long active_file, inactive_file;
+		unsigned long unevictable;
 
 		inactive_anon = mem_cgroup_get_all_zonestat(mem_cont,
 						LRU_INACTIVE_ANON);
@@ -939,10 +940,15 @@ static int mem_control_stat_show(struct 
 						LRU_INACTIVE_FILE);
 		active_file = mem_cgroup_get_all_zonestat(mem_cont,
 						LRU_ACTIVE_FILE);
+		unevictable = mem_cgroup_get_all_zonestat(mem_cont,
+							LRU_UNEVICTABLE);
+
 		cb->fill(cb, "active_anon", (active_anon) * PAGE_SIZE);
 		cb->fill(cb, "inactive_anon", (inactive_anon) * PAGE_SIZE);
 		cb->fill(cb, "active_file", (active_file) * PAGE_SIZE);
 		cb->fill(cb, "inactive_file", (inactive_file) * PAGE_SIZE);
+		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
+
 	}
 	return 0;
 }

-- 
All Rights Reversed

