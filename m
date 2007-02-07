Return-Path: <linux-kernel-owner+w=401wt.eu-S965629AbXBGBON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629AbXBGBON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965633AbXBGBON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:14:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42167 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbXBGBOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:14:11 -0500
Date: Wed, 7 Feb 2007 10:14:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070207101400.feda1bf9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0702060925130.9812@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702060925130.9812@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 09:26:53 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 6 Feb 2007, KAMEZAWA Hiroyuki wrote:
> 
> > This means an access to NULL,here.
> > ==
> > unsigned slab_node(struct mempolicy *policy)
> > {
> >         case MPOL_BIND:
> >                 /*
> >                  * Follow bind policy behavior and start allocation at the
> >                  * first node.
> >                  */
> >                 return zone_to_nid(policy->v.zonelist->zones[0]);
> > }
> > ==
> > length of this zonelist was 0.
> > It seems fixing a NULL access here is also O.K. 
> > This patch is just an idea.
> 
> Hmmm... Remove the node from the node_online_map instead?
> 
Changing defintion of node_online_map is harmfil. (there are cpu-only-nodes.)
How about adding  nodemask for nodes equips memory ?

===
There are memory-less-nodes (i.e. cpu only node.) on some systems.
mempolicy, which requires nodemask as its arg, should compare user's nodemask
with nodemask for node-with-memory-mask instead of node_online_map.

This patch adds node_with_memory_map and rewrite mempolicy's node_online_map
to node_with_memory_map.
(This patch supports node-hot-add.)

tested on ia64 NUMA
- 3nodes, node(2) is memory-less
- 3nodes, all nodes have memory.


Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.20/include/linux/nodemask.h
===================================================================
--- linux-2.6.20.orig/include/linux/nodemask.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/include/linux/nodemask.h	2007-02-07 10:03:53.000000000 +0900
@@ -344,6 +344,7 @@
 
 extern nodemask_t node_online_map;
 extern nodemask_t node_possible_map;
+extern nodemask_t node_with_memory_map;
 
 #if MAX_NUMNODES > 1
 #define num_online_nodes()	nodes_weight(node_online_map)
Index: linux-2.6.20/mm/page_alloc.c
===================================================================
--- linux-2.6.20.orig/mm/page_alloc.c	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/mm/page_alloc.c	2007-02-07 09:48:35.000000000 +0900
@@ -59,6 +59,8 @@
 long nr_swap_pages;
 int percpu_pagelist_fraction;
 
+nodemask_t	node_with_memory_map = NODE_MASK_NONE;
+
 static void __free_pages_ok(struct page *page, unsigned int order);
 
 /*
@@ -1861,6 +1863,8 @@
 	for_each_online_node(nid) {
 		build_zonelists(NODE_DATA(nid));
 		build_zonelist_cache(NODE_DATA(nid));
+		if (node_present_pages(nid))
+			node_set(nid, node_with_memory_map);
 	}
 	return 0;
 }
Index: linux-2.6.20/mm/mempolicy.c
===================================================================
--- linux-2.6.20.orig/mm/mempolicy.c	2007-02-07 09:29:01.000000000 +0900
+++ linux-2.6.20/mm/mempolicy.c	2007-02-07 09:50:51.000000000 +0900
@@ -130,7 +130,7 @@
 			return -EINVAL;
 		break;
 	}
-	return nodes_subset(*nodes, node_online_map) ? 0 : -EINVAL;
+	return nodes_subset(*nodes, node_with_memory_map) ? 0 : -EINVAL;
 }
 
 /* Generate a custom zonelist for the BIND policy. */
@@ -500,7 +500,7 @@
 	case MPOL_PREFERRED:
 		/* or use current node instead of online map? */
 		if (p->v.preferred_node < 0)
-			*nodes = node_online_map;
+			*nodes = node_with_memory_map;
 		else
 			node_set(p->v.preferred_node, *nodes);
 		break;
@@ -1612,7 +1612,7 @@
 	/* Set interleaving policy for system init. This way not all
 	   the data structures allocated at system boot end up in node zero. */
 
-	if (do_set_mempolicy(MPOL_INTERLEAVE, &node_online_map))
+	if (do_set_mempolicy(MPOL_INTERLEAVE, &node_with_memory_map))
 		printk("numa_policy_init: interleaving failed\n");
 }
 











