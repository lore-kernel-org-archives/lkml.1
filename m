Return-Path: <linux-kernel-owner+w=401wt.eu-S1751126AbXBMG62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbXBMG62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXBMG62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:58:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60614 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXBMG61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:58:27 -0500
Date: Tue, 13 Feb 2007 15:57:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
Subject: [RFC] [PATCH] more support for memory-less-node.
Message-Id: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In my last posintg, mempolicy-fix-for-memory-less-node patch, there was a 
discussion 'what do you consider definition of "node" as...?
I found there is no consensus. But I want to go ahead.
Before posing patch again, I'd like to discuss more.

-Kame

In my understanding, a "node" is a block of cpu, memory, devices.
and there could be cpu-only-node, memory-only-node, device-only-node...

There will be discussion. IMHO, to represent hardware configuration
as it is, this definition is very natural and flexible.
(And because my work is memory-hotplug, this definition fits me.)

"Don't support such crazy configuraton" is one of opinions.
I hear x86_64 doesn't support it and defines node as a block of memory,
It remaps cpus on memory-less-nodes to other nodes.
I know ia64 allows memory-less-node. (I don't know about ppc.)
It works well on my box (and HP's box).

If there is memory-less-node, codes which checks all nodes which have memory
should check NODE_DATA(nid)->present_pages.

But following is a bit heavy operation.
xxxxx
	for_each_online_node(nid)
		if (!node_present_pages(nid))
			continue;
xxxxx

This patch adds a new node mask "node_memory_online_map" for nodes
which have memory.

for_each_node_mask(nid, node_memory_online_map) walks all memory-ready-nodes.
This mask is updated at node-hotplug ops.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.20/include/linux/nodemask.h
===================================================================
--- linux-2.6.20.orig/include/linux/nodemask.h	2007-02-07 17:25:54.000000000 +0900
+++ linux-2.6.20/include/linux/nodemask.h	2007-02-13 15:31:33.000000000 +0900
@@ -344,6 +344,8 @@
 
 extern nodemask_t node_online_map;
 extern nodemask_t node_possible_map;
+/* online nodes which have memory */
+extern nodemask_t node_memory_online_map;
 
 #if MAX_NUMNODES > 1
 #define num_online_nodes()	nodes_weight(node_online_map)
Index: linux-2.6.20/mm/page_alloc.c
===================================================================
--- linux-2.6.20.orig/mm/page_alloc.c	2007-02-07 17:25:54.000000000 +0900
+++ linux-2.6.20/mm/page_alloc.c	2007-02-13 15:54:04.000000000 +0900
@@ -54,6 +54,9 @@
 EXPORT_SYMBOL(node_online_map);
 nodemask_t node_possible_map __read_mostly = NODE_MASK_ALL;
 EXPORT_SYMBOL(node_possible_map);
+nodemask_t node_memory_online_map __read_mostly = { { [0] = 1UL } };
+EXPORT_SYMBOL(node_memory_online_map);
+
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 long nr_swap_pages;
@@ -1805,6 +1808,16 @@
 	}
 }
 
+static void __meminit fixup_memory_online_nodes(void)
+{
+	int nid;
+	nodes_clear(node_memory_online_map);
+	for_each_online_node(nid) {
+		if (node_present_pages(nid))
+			node_set(nid, node_memory_online_map);
+	}
+}
+
 #else	/* CONFIG_NUMA */
 
 static void __meminit build_zonelists(pg_data_t *pgdat)
@@ -1851,6 +1864,10 @@
 		pgdat->node_zonelists[i].zlcache_ptr = NULL;
 }
 
+static void fixup_memory_online_nodes(void)
+{
+	return;
+}
 #endif	/* CONFIG_NUMA */
 
 /* return values int ....just for stop_machine_run() */
@@ -1862,6 +1879,7 @@
 		build_zonelists(NODE_DATA(nid));
 		build_zonelist_cache(NODE_DATA(nid));
 	}
+	fixup_memory_online_nodes();
 	return 0;
 }
 


