Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbYEWWJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbYEWWJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbYEWWGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:06:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760184AbYEWWGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:06:47 -0400
Message-Id: <20080523195535.787625182@redhat.com>
References: <20080523195506.084894989@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 May 2008 15:55:20 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 14/16] Non-reclaimable page statistics
Content-Disposition: inline; filename=rvr-12-lts-noreclaim-non-reclaimable-page-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Report non-reclaimable pages per zone and system wide.

Note:  may want to track/report some specific reasons for 
nonreclaimability for deciding when to splice the noreclaim
lists back to the normal lru.  That will be tricky,
especially in shrink_active_list(), where we'd need someplace
to save the per page reason for non-reclaimability until the
pages are dumped back onto the noreclaim list from the pagevec.

Note:  my tests indicate that NR_NORECLAIM and probably the
other LRU stats aren't being maintained properly--especially
with large amounts of mlocked memory and the mlock patch in
this series installed.  Can't be sure of this, as I don't 
know why the pages are on the noreclaim list. Needs further
investigation.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
V2 -> V3:
+ rebase to 23-mm1 atop RvR's split LRU series

V1 -> V2:
	no changes


 drivers/base/node.c |    6 ++++++
 fs/proc/proc_misc.c |    6 ++++++
 mm/page_alloc.c     |   16 +++++++++++++++-
 mm/vmstat.c         |    3 +++
 4 files changed, 30 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc2-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/page_alloc.c	2008-05-23 14:55:22.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/page_alloc.c	2008-05-23 15:04:35.000000000 -0400
@@ -1918,12 +1918,20 @@ void show_free_areas(void)
 	}
 
 	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
-		" inactive_file:%lu dirty:%lu writeback:%lu unstable:%lu\n"
+		" inactive_file:%lu"
+//TODO:  check/adjust line lengths
+#ifdef CONFIG_NORECLAIM_LRU
+		" noreclaim:%lu"
+#endif
+		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_INACTIVE_FILE),
+#ifdef CONFIG_NORECLAIM_LRU
+		global_page_state(NR_NORECLAIM),
+#endif
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
@@ -1950,6 +1958,9 @@ void show_free_areas(void)
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
 			" inactive_file:%lukB"
+#ifdef CONFIG_NORECLAIM_LRU
+			" noreclaim:%lukB"
+#endif
 			" present:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
@@ -1963,6 +1974,9 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
+#ifdef CONFIG_NORECLAIM_LRU
+			K(zone_page_state(zone, NR_NORECLAIM)),
+#endif
 			K(zone->present_pages),
 			zone->pages_scanned,
 			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
Index: linux-2.6.26-rc2-mm1/mm/vmstat.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/vmstat.c	2008-05-23 14:50:58.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/vmstat.c	2008-05-23 15:04:35.000000000 -0400
@@ -699,6 +699,9 @@ static const char * const vmstat_text[] 
 	"nr_active_anon",
 	"nr_inactive_file",
 	"nr_active_file",
+#ifdef CONFIG_NORECLAIM_LRU
+	"nr_noreclaim",
+#endif
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
Index: linux-2.6.26-rc2-mm1/drivers/base/node.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/drivers/base/node.c	2008-05-23 14:50:58.000000000 -0400
+++ linux-2.6.26-rc2-mm1/drivers/base/node.c	2008-05-23 15:04:35.000000000 -0400
@@ -67,6 +67,9 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Inactive(anon): %8lu kB\n"
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
+#ifdef CONFIG_NORECLAIM_LRU
+		       "Node %d Noreclaim:    %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
 		       "Node %d HighFree:       %8lu kB\n"
@@ -96,6 +99,9 @@ static ssize_t node_read_meminfo(struct 
 		       nid, node_page_state(nid, NR_INACTIVE_ANON),
 		       nid, node_page_state(nid, NR_ACTIVE_FILE),
 		       nid, node_page_state(nid, NR_INACTIVE_FILE),
+#ifdef CONFIG_NORECLAIM_LRU
+		       nid, node_page_state(nid, NR_NORECLAIM),
+#endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
Index: linux-2.6.26-rc2-mm1/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/fs/proc/proc_misc.c	2008-05-23 14:50:58.000000000 -0400
+++ linux-2.6.26-rc2-mm1/fs/proc/proc_misc.c	2008-05-23 15:04:35.000000000 -0400
@@ -174,6 +174,9 @@ static int meminfo_read_proc(char *page,
 		"Inactive(anon): %8lu kB\n"
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
+#ifdef CONFIG_NORECLAIM_LRU
+		"Noreclaim:    %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
 		"HighFree:       %8lu kB\n"
@@ -209,6 +212,9 @@ static int meminfo_read_proc(char *page,
 		K(inactive_anon),
 		K(active_file),
 		K(inactive_file),
+#ifdef CONFIG_NORECLAIM_LRU
+		K(global_page_state(NR_NORECLAIM)),
+#endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
 		K(i.freehigh),

-- 
All Rights Reversed

