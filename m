Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbYDDAXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbYDDAXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbYDDAXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:23:13 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:40058
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752931AbYDDAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:23:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 6] hotplug-memory: refactor online_pages to separate zone
	growth from page onlining
X-Mercurial-Node: 5a397e7f3c1aeb7648b94de21e26382b63f51ee7
Message-Id: <5a397e7f3c1aeb7648b9.1207267541@localhost>
In-Reply-To: <patchbomb.1207267540@localhost>
Date: Thu, 03 Apr 2008 17:05:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen balloon driver needs to separate the process of hot-installing
memory into two phases: one to allocate the page structures and
configure the zones, and another to actually online the pages of newly
installed memory.

This patch splits up the innards of online_pages() into two pieces
which correspond to these two phases.  The behaviour of online_pages()
itself is unchanged.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---
 include/linux/memory_hotplug.h |    3 +
 mm/memory_hotplug.c            |  102 ++++++++++++++++++++++++++--------------
 2 files changed, 71 insertions(+), 34 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -57,7 +57,10 @@
 /* need some defines for these for archs that don't support it */
 extern void online_page(struct page *page);
 /* VM interface that may be used by firmware interface */
+extern int prepare_online_pages(unsigned long pfn, unsigned long nr_pages);
+extern unsigned long mark_pages_onlined(unsigned long pfn, unsigned long nr_pages);
 extern int online_pages(unsigned long, unsigned long);
+
 extern void __offline_isolated_pages(unsigned long, unsigned long);
 extern int offline_pages(unsigned long, unsigned long, unsigned long);
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -134,10 +134,32 @@
 }
 EXPORT_SYMBOL_GPL(__add_pages);
 
-static void grow_zone_span(struct zone *zone,
+static void grow_pgdat_span(struct pglist_data *pgdat,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
+	unsigned long old_pgdat_end_pfn =
+		pgdat->node_start_pfn + pgdat->node_spanned_pages;
+
+	if (start_pfn < pgdat->node_start_pfn)
+		pgdat->node_start_pfn = start_pfn;
+
+	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
+					pgdat->node_start_pfn;
+}
+
+static void grow_zone_span(unsigned long start_pfn, unsigned long end_pfn)
+{
 	unsigned long old_zone_end_pfn;
+	struct zone *zone;
+	unsigned long flags;
+
+	/*
+	 * This doesn't need a lock to do pfn_to_page().
+	 * The section can't be removed here because of the
+	 * memory_block->state_sem.
+	 */
+	zone = page_zone(pfn_to_page(start_pfn));
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
 
 	zone_span_writelock(zone);
 
@@ -149,19 +171,9 @@
 				zone->zone_start_pfn;
 
 	zone_span_writeunlock(zone);
-}
 
-static void grow_pgdat_span(struct pglist_data *pgdat,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long old_pgdat_end_pfn =
-		pgdat->node_start_pfn + pgdat->node_spanned_pages;
-
-	if (start_pfn < pgdat->node_start_pfn)
-		pgdat->node_start_pfn = start_pfn;
-
-	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
-					pgdat->node_start_pfn;
+	grow_pgdat_span(zone->zone_pgdat, start_pfn, end_pfn);
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
 
 static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
@@ -180,16 +192,12 @@
 	return 0;
 }
 
-
-int online_pages(unsigned long pfn, unsigned long nr_pages)
+/* Tell anyone who's interested that we're onlining some memory */
+static int notify_going_online(unsigned long pfn, unsigned long nr_pages)
 {
-	unsigned long flags;
-	unsigned long onlined_pages = 0;
-	struct zone *zone;
-	int need_zonelists_rebuild = 0;
+	struct memory_notify arg;
 	int nid;
 	int ret;
-	struct memory_notify arg;
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
@@ -201,20 +209,18 @@
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
-	if (ret) {
+	if (ret)
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		return ret;
-	}
-	/*
-	 * This doesn't need a lock to do pfn_to_page().
-	 * The section can't be removed here because of the
-	 * memory_block->state_sem.
-	 */
-	zone = page_zone(pfn_to_page(pfn));
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	grow_zone_span(zone, pfn, pfn + nr_pages);
-	grow_pgdat_span(zone->zone_pgdat, pfn, pfn + nr_pages);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
+	return ret;
+}
+
+/* Mark a set of pages as online */
+unsigned long mark_pages_onlined(unsigned long pfn, unsigned long nr_pages)
+{
+	struct zone *zone = page_zone(pfn_to_page(pfn));
+	unsigned long onlined_pages = 0;
+	int need_zonelists_rebuild = 0;
 
 	/*
 	 * If this zone is not populated, then it is not in zonelist.
@@ -240,10 +246,38 @@
 	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
 
-	if (onlined_pages)
+	if (onlined_pages) {
+		struct memory_notify arg;
+
+		arg.start_pfn = pfn;  /* ? */
+		arg.nr_pages = onlined_pages;
+		arg.status_change_nid = -1;  /* ? */
+
 		memory_notify(MEM_ONLINE, &arg);
+	}
 
+	return onlined_pages;
+}
+
+int prepare_online_pages(unsigned long pfn, unsigned long nr_pages)
+{
+	int ret = notify_going_online(pfn, nr_pages);
+	if (ret)
+		return ret;
+
+	grow_zone_span(pfn, pfn+nr_pages);
 	return 0;
+}
+
+int online_pages(unsigned long pfn, unsigned long nr_pages)
+{
+	int ret;
+
+	ret = prepare_online_pages(pfn, nr_pages);
+	if (ret == 0)
+		mark_pages_onlined(pfn, nr_pages);
+
+	return ret;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 


