Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYC2AAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYC2AAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYC2AAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:00:35 -0400
Received: from gw.goop.org ([64.81.55.164]:58827 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbYC2AAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:00:34 -0400
Message-ID: <47ED8685.9040409@goop.org>
Date: Fri, 28 Mar 2008 17:00:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] hotplug-memory: refactor online_pages to separate zone
 growth from page onlining
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen balloon driver needs to separate the process of hot-installing
memory into two phases: one to allocate the page structures and
configure the zones, and another to actually online the pages of newly
installed memory.

This patch splits up the innards of online_pages() into two pieces which
correspond to these two phases.  The behaviour of online_pages() itself
is unchanged.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---
 include/linux/memory_hotplug.h |    3 +
 mm/memory_hotplug.c            |   66 ++++++++++++++++++++++++++++++++--------
 2 files changed, 57 insertions(+), 12 deletions(-)

===================================================================
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
 
===================================================================
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -180,31 +180,35 @@
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
 	arg.status_change_nid = -1;
-
+
 	nid = page_to_nid(pfn_to_page(pfn));
 	if (node_present_pages(nid) == 0)
 		arg.status_change_nid = nid;
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
-	if (ret) {
+	if (ret)
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		return ret;
-	}
+
+	return ret;
+}
+
+/* Grow the zone to fit the expected amount of memory being added */
+static struct zone *online_pages_zone(unsigned long pfn, unsigned long nr_pages)
+{
+	struct zone *zone;
+	unsigned long flags;
+
 	/*
 	 * This doesn't need a lock to do pfn_to_page().
 	 * The section can't be removed here because of the
@@ -215,6 +219,16 @@
 	grow_zone_span(zone, pfn, pfn + nr_pages);
 	grow_pgdat_span(zone->zone_pgdat, pfn, pfn + nr_pages);
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
+	return zone;
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
@@ -240,10 +254,38 @@
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
+	online_pages_zone(pfn, nr_pages);
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
 


