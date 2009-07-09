Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbZGIIPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbZGIIPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZGIIOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:14:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48351 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZGIIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:14:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
Message-Id: <20090709171247.23C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 17:14:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog
  Since v4
   - Changed displaing order in show_free_areas() (as Wu's suggested)
  Since v3
   - Fixed misaccount page bug when lumby reclaim occur
  Since v2
   - Separated IsolateLRU field to Isolated(anon) and Isolated(file)
  Since v1
   - Renamed IsolatePages to IsolatedLRU

==================================
Subject: [PATCH] add isolate pages vmstat

If the system have plenty threads or processes, concurrent reclaim can
isolate very much pages.
Unfortunately, current /proc/meminfo and OOM log can't show it.

This patch provide the way of showing this information.


reproduce way
-----------------------
% ./hackbench 140 process 1000
   => couse OOM

active_anon:146 inactive_anon:0 isolated_anon:49245
 active_file:41 inactive_file:0 isolated_file:113
 unevictable:0
 dirty:0 writeback:0 buffer:49 unstable:0
 free:184 slab_reclaimable:276 slab_unreclaimable:5492
 mapped:87 pagetables:28239 bounce:0


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/base/node.c    |    4 ++++
 fs/proc/meminfo.c      |    4 ++++
 include/linux/mmzone.h |    2 ++
 mm/page_alloc.c        |   14 ++++++++++----
 mm/vmscan.c            |   13 +++++++++++++
 mm/vmstat.c            |    3 ++-
 6 files changed, 35 insertions(+), 5 deletions(-)

Index: b/fs/proc/meminfo.c
===================================================================
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -65,6 +65,8 @@ static int meminfo_proc_show(struct seq_
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
 		"Unevictable:    %8lu kB\n"
+		"Isolated(anon): %8lu kB\n"
+		"Isolated(file): %8lu kB\n"
 		"Mlocked:        %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
@@ -109,6 +111,8 @@ static int meminfo_proc_show(struct seq_
 		K(pages[LRU_ACTIVE_FILE]),
 		K(pages[LRU_INACTIVE_FILE]),
 		K(pages[LRU_UNEVICTABLE]),
+		K(global_page_state(NR_ISOLATED_ANON)),
+		K(global_page_state(NR_ISOLATED_FILE)),
 		K(global_page_state(NR_MLOCK)),
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
Index: b/include/linux/mmzone.h
===================================================================
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -100,6 +100,8 @@ enum zone_stat_item {
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
+	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
+	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2115,16 +2115,18 @@ void show_free_areas(void)
 		}
 	}
 
-	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
-		" inactive_file:%lu"
-		" unevictable:%lu"
+	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
+		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
+		" unevictable:%lu\n"
 		" dirty:%lu writeback:%lu unstable:%lu buffer:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
-		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
+		global_page_state(NR_ISOLATED_ANON),
+		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_FILE),
+		global_page_state(NR_ISOLATED_FILE),
 		global_page_state(NR_UNEVICTABLE),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
@@ -2151,6 +2153,8 @@ void show_free_areas(void)
 			" active_file:%lukB"
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
+			" isolated(anon):%lukB"
+			" isolated(file):%lukB"
 			" present:%lukB"
 			" mlocked:%lukB"
 			" dirty:%lukB"
@@ -2176,6 +2180,8 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_UNEVICTABLE)),
+			K(zone_page_state(zone, NR_ISOLATED_ANON)),
+			K(zone_page_state(zone, NR_ISOLATED_FILE)),
 			K(zone->present_pages),
 			K(zone_page_state(zone, NR_MLOCK)),
 			K(zone_page_state(zone, NR_FILE_DIRTY)),
Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1067,6 +1067,8 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_active;
 		unsigned int count[NR_LRU_LISTS] = { 0, };
 		int mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
+		unsigned long nr_anon;
+		unsigned long nr_file;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
@@ -1083,6 +1085,12 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
+		nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
+		nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
+
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
+		__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
+
 		if (scanning_global_lru(sc))
 			zone->pages_scanned += nr_scan;
 
@@ -1131,6 +1139,8 @@ static unsigned long shrink_inactive_lis
 			goto done;
 
 		spin_lock(&zone->lru_lock);
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
+		__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
 		/*
 		 * Put back any unfreeable pages.
 		 */
@@ -1205,6 +1215,7 @@ static void move_active_pages_to_lru(str
 	unsigned long pgmoved = 0;
 	struct pagevec pvec;
 	struct page *page;
+	int file = is_file_lru(lru);
 
 	pagevec_init(&pvec, 1);
 
@@ -1232,6 +1243,7 @@ static void move_active_pages_to_lru(str
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -pgmoved);
 	if (!is_active_lru(lru))
 		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
@@ -1267,6 +1279,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
 	else
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
 	pgmoved = 0;  /* count referenced (mapping) mapped pages */
Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -644,7 +644,8 @@ static const char * const vmstat_text[] 
 	"nr_bounce",
 	"nr_vmscan_write",
 	"nr_writeback_temp",
-
+	"nr_isolated_anon",
+	"nr_isolated_file",
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
Index: b/drivers/base/node.c
===================================================================
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -73,6 +73,8 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
 		       "Node %d Unevictable:    %8lu kB\n"
+		       "Node %d Isolated(anon): %8lu kB\n"
+		       "Node %d Isolated(file): %8lu kB\n"
 		       "Node %d Mlocked:        %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
@@ -105,6 +107,8 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
+		       nid, K(node_page_state(nid, NR_ISOLATED_ANON)),
+		       nid, K(node_page_state(nid, NR_ISOLATED_FILE)),
 		       nid, K(node_page_state(nid, NR_MLOCK)),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),


