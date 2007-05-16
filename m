Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbXEPT5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbXEPT5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbXEPT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:57:28 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:49990 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758873AbXEPT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:57:27 -0400
Subject: [PATCH 2.6.21-rc1-mm1] add check_highest_zone to
	build_zonelists_in_zone_order
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, apw@shadowen.org,
       clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       jbarnes@virtuousgeek.org, Eric Whitney <eric.whitney@hp.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 16 May 2007 15:57:39 -0400
Message-Id: <1179345459.5867.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 2.6.21-rc1-mm1] add check_highest_zone to build_zonelists_in_zone_order

We missed this in the "change zone order" series.  We need to record
the highest populated zone, just as build_zonelists_node() does.
Memory policies apply only to this zone.  Without this, we'll be
applying policy to all zones, including DMA, I think.  Not having
thought about it much, I can't claim to understand the downside of
doing so.

Also, display selected "policy zone" during boot or reconfig
of zonelist order, if 'NUMA.  Inquiring minds [might] want to know...

Cleanup:  remove stale comment in set_zonelist_order()

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/page_alloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: Linux/mm/page_alloc.c
===================================================================
--- Linux.orig/mm/page_alloc.c	2007-05-16 10:32:20.000000000 -0400
+++ Linux/mm/page_alloc.c	2007-05-16 15:18:53.000000000 -0400
@@ -2037,7 +2037,7 @@ static char zonelist_order_name[3][8] = 
 
 
 #ifdef CONFIG_NUMA
-/* The vaule user specified ....changed by config */
+/* The value user specified ....changed by config */
 static int user_zonelist_order = ZONELIST_ORDER_DEFAULT;
 /* string for sysctl */
 #define NUMA_ZONELIST_ORDER_LEN	16
@@ -2215,8 +2215,10 @@ static void build_zonelists_in_zone_orde
 			for (j = 0; j < nr_nodes; j++) {
 				node = node_order[j];
 				z = &NODE_DATA(node)->node_zones[zone_type];
-				if (populated_zone(z))
+				if (populated_zone(z)) {
 					zonelist->zones[pos++] = z;
+					check_highest_zone(zone_type);
+				}
 			}
 		}
 		zonelist->zones[pos] = NULL;
@@ -2278,7 +2280,6 @@ static int default_zonelist_order(void)
 
 static void set_zonelist_order(void)
 {
-	/* dummy, just select node order. */
 	if (user_zonelist_order == ZONELIST_ORDER_DEFAULT)
 		current_zonelist_order = default_zonelist_order();
 	else
@@ -2458,6 +2459,9 @@ void build_all_zonelists(void)
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
+#ifdef CONFIG_NUMA
+	printk("Policy zone:  %s\n", zone_names[policy_zone]);
+#endif
 }
 
 /*


