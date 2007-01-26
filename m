Return-Path: <linux-kernel-owner+w=401wt.eu-S1161180AbXAZTHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161180AbXAZTHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161181AbXAZTHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:07:47 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:42775 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161180AbXAZTHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:07:46 -0500
Date: Fri, 26 Jan 2007 11:07:39 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
In-Reply-To: <6bffcb0e0701261045q29cdb4ceq4577e5b0cec55d66@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701261103530.5622@schroedinger.engr.sgi.com>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> 
 <45BA42B9.7020203@googlemail.com>  <6bffcb0e0701261008u2fd5a7d9va16d7fd9f250e14b@mail.gmail.com>
  <Pine.LNX.4.64.0701261035430.7848@schroedinger.engr.sgi.com>
 <6bffcb0e0701261045q29cdb4ceq4577e5b0cec55d66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Michal Piotrowski wrote:

> Please try patches from
> http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/
> 
> http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/bugs_and_patches.txt

Ahh. Okay that fixes most of the issues


ZVC writeback: Fix mm and other issues

This deals with swap prefetch and various things changed in mm.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.20-rc6.orig/kernel/power/swsusp.c	2007-01-26 10:32:05.000000000 -0800
+++ linux-2.6.20-rc6/kernel/power/swsusp.c	2007-01-26 10:51:56.000000000 -0800
@@ -230,9 +230,10 @@ int swsusp_shrink_memory(void)
 		for_each_zone (zone)
 			if (populated_zone(zone)) {
 				if (is_highmem(zone)) {
-					highmem_size -= zone->free_pages;
+					highmem_size -=
+					zone_page_state(zone, NR_FREE_PAGES);
 				} else {
-					tmp -= zone->free_pages;
+					tmp -= zone_page_state(zone, NR_FREE_PAGES);
 					tmp += zone->lowmem_reserve[ZONE_NORMAL];
 					tmp += snapshot_additional_pages(zone);
 				}
Index: linux-2.6.20-rc6/mm/page_alloc.c
===================================================================
--- linux-2.6.20-rc6.orig/mm/page_alloc.c	2007-01-26 10:32:19.000000000 -0800
+++ linux-2.6.20-rc6/mm/page_alloc.c	2007-01-26 10:48:04.000000000 -0800
@@ -1581,12 +1581,12 @@ unsigned int nr_free_pagecache_pages(voi
 unsigned long nr_free_inactive_pages_node(int nid)
 {
 	enum zone_type i;
-	unsigned long sum = 0;
+	unsigned long sum = node_page_state(nid, NR_FREE_PAGES)
+				+ node_page_state(nid, NR_INACTIVE);
 	struct zone *zones = NODE_DATA(nid)->node_zones;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
-		sum += zones[i].nr_inactive +
-			zones[i].free_pages - zones[i].pages_low;
+		sum -= zones[i].pages_low;
 
 	return sum;
 }
@@ -1634,7 +1634,8 @@ void si_meminfo_node(struct sysinfo *val
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
 	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
-	val->freehigh = pgdat->node_zones[ZONE_HIGHMEM].free_pages;
+	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
+			NR_FREE_PAGES);
 #else
 	val->totalhigh = 0;
 	val->freehigh = 0;
Index: linux-2.6.20-rc6/mm/swap_prefetch.c
===================================================================
--- linux-2.6.20-rc6.orig/mm/swap_prefetch.c	2007-01-26 10:51:53.000000000 -0800
+++ linux-2.6.20-rc6/mm/swap_prefetch.c	2007-01-26 10:51:56.000000000 -0800
@@ -281,7 +281,7 @@ static void examine_free_limits(void)
 		ns->lowfree[idx] = z->pages_high * 3;
 		ns->highfree[idx] = ns->lowfree[idx] + z->pages_high;
 
-		if (z->free_pages > ns->highfree[idx]) {
+		if (zone_page_state(z, NR_FREE_PAGES) > ns->highfree[idx]) {
 			/*
 			 * We've gotten above the high watermark of free pages
 			 * so we can start prefetching till we get to the low
@@ -338,7 +338,7 @@ static int prefetch_suitable(void)
 		ns = &sp_stat.node[node];
 		idx = zone_idx(z);
 
-		free = z->free_pages;
+		free = zone_page_state(z, NR_FREE_PAGES);
 		if (free < *ns->pointfree[idx]) {
 			/*
 			 * Free pages have dropped below the low watermark so
Index: linux-2.6.20-rc6/include/linux/mm_inline.h
===================================================================
--- linux-2.6.20-rc6.orig/include/linux/mm_inline.h	2007-01-26 10:58:53.000000000 -0800
+++ linux-2.6.20-rc6/include/linux/mm_inline.h	2007-01-26 10:58:59.000000000 -0800
@@ -16,7 +16,7 @@ static inline void
 add_page_to_inactive_list_tail(struct zone *zone, struct page *page)
 {
 	list_add_tail(&page->lru, &zone->inactive_list);
-	zone->nr_inactive++;
+	__inc_zone_state(zone, NR_INACTIVE);
 }
 
 static inline void
