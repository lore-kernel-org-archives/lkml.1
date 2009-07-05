Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZGEMX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZGEMX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 08:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZGEMXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 08:23:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37012 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZGEMXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 08:23:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090705121003.GB5252@localhost>
References: <20090705182451.08FF.A69D9226@jp.fujitsu.com> <20090705121003.GB5252@localhost>
Message-Id: <20090705211127.0917.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  5 Jul 2009 21:23:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jul 05, 2009 at 05:25:32PM +0800, KOSAKI Motohiro wrote:
> > Subject: [PATCH] add isolate pages vmstat
> > 
> > If the system have plenty threads or processes, concurrent reclaim can
> > isolate very much pages.
> > Unfortunately, current /proc/meminfo and OOM log can't show it.
> > 
> > This patch provide the way of showing this information.
> >
> > 
> > reproduce way
> > -----------------------
> > % ./hackbench 140 process 1000
> >    => couse OOM
> > 
> > Active_anon:4419 active_file:120 inactive_anon:1418
> >  inactive_file:61 unevictable:0 isolated:45311
> >                                          ^^^^^
> >  dirty:0 writeback:580 unstable:0
> >  free:27 slab_reclaimable:297 slab_unreclaimable:4050
> >  mapped:221 kernel_stack:5758 pagetables:28219 bounce:0
> > 
> > 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  drivers/base/node.c    |    2 ++
> >  fs/proc/meminfo.c      |    2 ++
> >  include/linux/mmzone.h |    1 +
> >  mm/page_alloc.c        |    6 ++++--
> >  mm/vmscan.c            |    4 ++++
> >  mm/vmstat.c            |    2 +-
> >  6 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > Index: b/fs/proc/meminfo.c
> > ===================================================================
> > --- a/fs/proc/meminfo.c
> > +++ b/fs/proc/meminfo.c
> > @@ -65,6 +65,7 @@ static int meminfo_proc_show(struct seq_
> >  		"Active(file):   %8lu kB\n"
> >  		"Inactive(file): %8lu kB\n"
> >  		"Unevictable:    %8lu kB\n"
> > +		"IsolatedPages:  %8lu kB\n"
> >  		"Mlocked:        %8lu kB\n"
> >  #ifdef CONFIG_HIGHMEM
> >  		"HighTotal:      %8lu kB\n"
> > @@ -109,6 +110,7 @@ static int meminfo_proc_show(struct seq_
> >  		K(pages[LRU_ACTIVE_FILE]),
> >  		K(pages[LRU_INACTIVE_FILE]),
> >  		K(pages[LRU_UNEVICTABLE]),
> > +		K(global_page_state(NR_ISOLATED)),
> 
> Glad to see you renamed it to NR_ISOLATED :)
> But for the user visible name, how about IsolatedLRU?

Ah, nice.  below is update patch.

Changelog
----------------
  since v1
    - rename "IsolatedPages" to "IsolatedLRU"


=================================
Subject: [PATCH] add isolate pages vmstat

If the system have plenty threads or processes, concurrent reclaim can
isolate very much pages.
Unfortunately, current /proc/meminfo and OOM log can't show it.

This patch provide the way of showing this information.


reproduce way
-----------------------
% ./hackbench 140 process 1000
   => couse OOM

Active_anon:4419 active_file:120 inactive_anon:1418
 inactive_file:61 unevictable:0 isolated:45311
                                         ^^^^^
 dirty:0 writeback:580 unstable:0
 free:27 slab_reclaimable:297 slab_unreclaimable:4050
 mapped:221 kernel_stack:5758 pagetables:28219 bounce:0



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/base/node.c    |    2 ++
 fs/proc/meminfo.c      |    2 ++
 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |    6 ++++--
 mm/vmscan.c            |    4 ++++
 mm/vmstat.c            |    2 +-
 6 files changed, 14 insertions(+), 3 deletions(-)

Index: b/fs/proc/meminfo.c
===================================================================
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -65,6 +65,7 @@ static int meminfo_proc_show(struct seq_
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
 		"Unevictable:    %8lu kB\n"
+		"IsolatedLRU:    %8lu kB\n"
 		"Mlocked:        %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
@@ -109,6 +110,7 @@ static int meminfo_proc_show(struct seq_
 		K(pages[LRU_ACTIVE_FILE]),
 		K(pages[LRU_INACTIVE_FILE]),
 		K(pages[LRU_UNEVICTABLE]),
+		K(global_page_state(NR_ISOLATED)),
 		K(global_page_state(NR_MLOCK)),
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
Index: b/include/linux/mmzone.h
===================================================================
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -100,6 +100,7 @@ enum zone_stat_item {
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
+	NR_ISOLATED,		/* Temporary isolated pages from lru */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2116,8 +2116,7 @@ void show_free_areas(void)
 	}
 
 	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
-		" inactive_file:%lu"
-		" unevictable:%lu"
+		" inactive_file:%lu unevictable:%lu isolated:%lu\n"
 		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu pagetables:%lu bounce:%lu\n",
@@ -2126,6 +2125,7 @@ void show_free_areas(void)
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_INACTIVE_FILE),
 		global_page_state(NR_UNEVICTABLE),
+		global_page_state(NR_ISOLATED),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		K(nr_blockdev_pages()),
@@ -2151,6 +2151,7 @@ void show_free_areas(void)
 			" active_file:%lukB"
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
+			" isolated:%lukB"
 			" present:%lukB"
 			" mlocked:%lukB"
 			" dirty:%lukB"
@@ -2176,6 +2177,7 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_UNEVICTABLE)),
+			K(zone_page_state(zone, NR_ISOLATED)),
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
+		__mod_zone_page_state(zone, NR_ISOLATED, nr_taken);
 
 		if (scanning_global_lru(sc))
 			zone->pages_scanned += nr_scan;
@@ -1131,6 +1132,7 @@ static unsigned long shrink_inactive_lis
 			goto done;
 
 		spin_lock(&zone->lru_lock);
+		__mod_zone_page_state(zone, NR_ISOLATED, -nr_taken);
 		/*
 		 * Put back any unfreeable pages.
 		 */
@@ -1232,6 +1234,7 @@ static void move_active_pages_to_lru(str
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	__mod_zone_page_state(zone, NR_ISOLATED, -pgmoved);
 	if (!is_active_lru(lru))
 		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
@@ -1267,6 +1270,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
 	else
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
+	__mod_zone_page_state(zone, NR_ISOLATED, pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
 	pgmoved = 0;  /* count referenced (mapping) mapped pages */
Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -644,7 +644,7 @@ static const char * const vmstat_text[] 
 	"nr_bounce",
 	"nr_vmscan_write",
 	"nr_writeback_temp",
-
+	"nr_isolated_pages",
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
Index: b/drivers/base/node.c
===================================================================
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -73,6 +73,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
 		       "Node %d Unevictable:    %8lu kB\n"
+		       "Node %d IsolatedPages:  %8lu kB\n"
 		       "Node %d Mlocked:        %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
@@ -105,6 +106,7 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
+		       nid, K(node_page_state(nid, NR_ISOLATED)),
 		       nid, K(node_page_state(nid, NR_MLOCK)),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),




