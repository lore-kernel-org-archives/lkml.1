Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZGFLzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZGFLzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZGFLzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:55:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48347 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZGFLzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:55:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090706182750.0C54.A69D9226@jp.fujitsu.com>
References: <28c262360907050751t1fccbf4t4ace572b4e003a13@mail.gmail.com> <20090706182750.0C54.A69D9226@jp.fujitsu.com>
Message-Id: <20090706204412.0C5D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Jul 2009 20:55:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > ? ? ? ?printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> > > - ? ? ? ? ? ? ? " inactive_file:%lu"
> > > - ? ? ? ? ? ? ? " unevictable:%lu"
> > > + ? ? ? ? ? ? ? " inactive_file:%lu unevictable:%lu isolated:%lu\n"
> > 
> > It's good.
> > I have a one suggestion.
> > 
> > I know this patch came from David's OOM problem a few days ago.
> > 
> > I think total pages isolated of all lru doesn't help us much.
> > It just represents why [in]active[anon/file] is zero.
> > 
> > How about adding isolate page number per each lru ?
> > 
> > IsolatedPages(file)
> > IsolatedPages(anon)
> > 
> > It can help knowing exact number of each lru.
> 
> Good suggestion!
> Will fix.


New version here.

thanks.


============ CUT HERE ===============
Subject: [PATCH] add isolate pages vmstat

If the system have plenty threads or processes, concurrent reclaim can
isolate very much pages.
Unfortunately, current /proc/meminfo and OOM log can't show it.

This patch provide the way of showing this information.


reproduce way
-----------------------
% ./hackbench 140 process 1000
   => couse OOM

Active_anon:146 active_file:41 inactive_anon:0
 inactive_file:0 unevictable:0
 isolated_anon:49245 isolated_file:113
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 dirty:0 writeback:0 buffer:49 unstable:0
 free:184 slab_reclaimable:276 slab_unreclaimable:5492
 mapped:87 pagetables:28239 bounce:0


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/base/node.c    |    4 ++++
 fs/proc/meminfo.c      |    4 ++++
 include/linux/mmzone.h |    2 ++
 mm/page_alloc.c        |   10 ++++++++--
 mm/vmscan.c            |    5 +++++
 mm/vmstat.c            |    3 ++-
 6 files changed, 25 insertions(+), 3 deletions(-)

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
@@ -2116,8 +2116,8 @@ void show_free_areas(void)
 	}
 
 	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
-		" inactive_file:%lu"
-		" unevictable:%lu"
+		" inactive_file:%lu unevictable:%lu\n"
+		" isolated_anon:%lu isolated_file:%lu\n"
 		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu pagetables:%lu bounce:%lu\n",
@@ -2126,6 +2126,8 @@ void show_free_areas(void)
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_INACTIVE_FILE),
 		global_page_state(NR_UNEVICTABLE),
+		global_page_state(NR_ISOLATED_ANON),
+		global_page_state(NR_ISOLATED_FILE),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		nr_blockdev_pages(),
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
@@ -1082,6 +1082,7 @@ static unsigned long shrink_inactive_lis
 						-count[LRU_ACTIVE_ANON]);
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
 
 		if (scanning_global_lru(sc))
 			zone->pages_scanned += nr_scan;
@@ -1131,6 +1132,7 @@ static unsigned long shrink_inactive_lis
 			goto done;
 
 		spin_lock(&zone->lru_lock);
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 		/*
 		 * Put back any unfreeable pages.
 		 */
@@ -1205,6 +1207,7 @@ static void move_active_pages_to_lru(str
 	unsigned long pgmoved = 0;
 	struct pagevec pvec;
 	struct page *page;
+	int file = is_file_lru(lru);
 
 	pagevec_init(&pvec, 1);
 
@@ -1232,6 +1235,7 @@ static void move_active_pages_to_lru(str
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -pgmoved);
 	if (!is_active_lru(lru))
 		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
@@ -1267,6 +1271,7 @@ static void shrink_active_list(unsigned 
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




