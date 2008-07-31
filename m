Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYGaL7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYGaL7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYGaL7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:59:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46735 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYGaL7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:59:41 -0400
Date: Thu, 31 Jul 2008 20:58:26 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [RFC:Patch: 003/008](memory hotplug) check node online in __alloc_pages
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
References: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080731205654.2A47.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is to add pgdat_remove_read_lock()/unlock() for parsing zonelist in
__alloc_pages_internal().
The node might be removed before pgdat_remove_read_lock(),
node_online() must be checked at first. If offlined, don't parse it.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/page_alloc.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

Index: current/mm/page_alloc.c
===================================================================
--- current.orig/mm/page_alloc.c	2008-07-31 19:01:46.000000000 +0900
+++ current/mm/page_alloc.c	2008-07-31 19:19:19.000000000 +0900
@@ -1394,10 +1394,22 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
+	pgdat_remove_read_lock();
+	if (unlikely(!node_online(zonelist_nid))) {
+		/*
+		 * Pgdat removing worked before here.
+		 * Don't touch pgdat/zone/zonelist any more.
+		 */
+		pgdat_remove_read_unlock();
+		return NULL;
+	}
+
 	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
 							&preferred_zone);
-	if (!preferred_zone)
+	if (!preferred_zone) {
+		pgdat_remove_read_unlock();
 		return NULL;
+	}
 
 	classzone_idx = zone_idx(preferred_zone);
 
@@ -1451,6 +1463,7 @@ try_next_zone:
 		zlc_active = 0;
 		goto zonelist_scan;
 	}
+	pgdat_remove_read_unlock();
 	return page;
 }
 
@@ -1536,10 +1549,21 @@ __alloc_pages_internal(gfp_t gfp_mask, u
 		return NULL;
 
 restart:
+	pgdat_remove_read_lock();
+	if (unlikely(!node_online(zonelist_nid))) {
+		/*
+		 * pgdat removing worked before here.
+		 * zone & zonelist can't be touched.
+		 */
+		pgdat_remove_read_unlock();
+		goto nopage;
+	}
 	zonelist = node_zonelist(zonelist_nid, gfp_mask);;
 	z = zonelist->_zonerefs;  /* the list of zones suitable for gfp_mask */
+	zone = z->zone;
+	pgdat_remove_read_unlock();
 
-	if (unlikely(!z->zone)) {
+	if (unlikely(!zone)) {
 		/*
 		 * Happens if we have an empty zonelist as a result of
 		 * GFP_THISNODE being used on a memoryless node
@@ -1565,9 +1589,17 @@ restart:
 	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
+	pgdat_remove_read_lock();
+
+	if (unlikely(!node_online(zonelist_nid))) {
+		pgdat_remove_read_unlock();
+		goto nopage;
+	}
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
 		wakeup_kswapd(zone, order);
 
+	pgdat_remove_read_unlock();
+
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according

-- 
Yasunori Goto 


