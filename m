Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbXKGBNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbXKGBNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbXKGBMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:12:30 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44687 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755114AbXKGBM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:12:28 -0500
Message-Id: <20071107011226.844437184@sgi.com>
References: <20071107011130.382244340@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 17:11:32 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundatin.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
Content-Disposition: inline; filename=0003-slab_defrag_remote_node_defrag_ratio.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need the defrag ratio for the non NUMA situation now. The NUMA defrag works
by allocating objects from partial slabs on remote nodes. Rename it to

	remote_node_defrag_ratio

to be clear about this.

[This patch is already in mm]

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/slub_def.h |    5 ++++-
 mm/slub.c                |   17 +++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-11-06 12:34:13.000000000 -0800
+++ linux-2.6/include/linux/slub_def.h	2007-11-06 12:36:28.000000000 -0800
@@ -60,7 +60,10 @@ struct kmem_cache {
 #endif
 
 #ifdef CONFIG_NUMA
-	int defrag_ratio;
+	/*
+	 * Defragmentation by allocating from a remote node.
+	 */
+	int remote_node_defrag_ratio;
 	struct kmem_cache_node *node[MAX_NUMNODES];
 #endif
 #ifdef CONFIG_SMP
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-06 12:36:16.000000000 -0800
+++ linux-2.6/mm/slub.c	2007-11-06 12:37:25.000000000 -0800
@@ -1345,7 +1345,8 @@ static unsigned long get_any_partial(str
 	 * expensive if we do it every time we are trying to find a slab
 	 * with available objects.
 	 */
-	if (!s->defrag_ratio || get_cycles() % 1024 > s->defrag_ratio)
+	if (!s->remote_node_defrag_ratio ||
+			get_cycles() % 1024 > s->remote_node_defrag_ratio)
 		return 0;
 
 	zonelist = &NODE_DATA(slab_node(current->mempolicy))
@@ -2363,7 +2364,7 @@ static int kmem_cache_open(struct kmem_c
 
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
-	s->defrag_ratio = 100;
+	s->remote_node_defrag_ratio = 100;
 #endif
 	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		goto error;
@@ -4005,21 +4006,21 @@ static ssize_t free_calls_show(struct km
 SLAB_ATTR_RO(free_calls);
 
 #ifdef CONFIG_NUMA
-static ssize_t defrag_ratio_show(struct kmem_cache *s, char *buf)
+static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->defrag_ratio / 10);
+	return sprintf(buf, "%d\n", s->remote_node_defrag_ratio / 10);
 }
 
-static ssize_t defrag_ratio_store(struct kmem_cache *s,
+static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
 	int n = simple_strtoul(buf, NULL, 10);
 
 	if (n < 100)
-		s->defrag_ratio = n * 10;
+		s->remote_node_defrag_ratio = n * 10;
 	return length;
 }
-SLAB_ATTR(defrag_ratio);
+SLAB_ATTR(remote_node_defrag_ratio);
 #endif
 
 static struct attribute * slab_attrs[] = {
@@ -4050,7 +4051,7 @@ static struct attribute * slab_attrs[] =
 	&cache_dma_attr.attr,
 #endif
 #ifdef CONFIG_NUMA
-	&defrag_ratio_attr.attr,
+	&remote_node_defrag_ratio_attr.attr,
 #endif
 	NULL
 };

-- 
