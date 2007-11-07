Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbXKGBOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbXKGBOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbXKGBMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:12:36 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44698 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755118AbXKGBM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:12:29 -0500
Message-Id: <20071107011228.102370371@sgi.com>
References: <20071107011130.382244340@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 17:11:37 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundatin.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 07/23] SLUB: Add defrag_ratio field and sysfs support.
Content-Disposition: inline; filename=0004-slab_defrag_add_defrag_ratio.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The defrag_ratio is used to set the threshold at which defragmentation
should be run on a slabcache.

The allocation ratio is measured in a percentage of the available slots.
The percentage will be lower for slabs that are more fragmented.

Add a defrag ratio field and set it to 30% by default. A limit of 30% specified
that less than 3 out of 10 available slots for objects are in use before
reclaim occurs.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/slub_def.h |    7 +++++++
 mm/slub.c                |   18 ++++++++++++++++++
 2 files changed, 25 insertions(+)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-11-06 12:36:28.000000000 -0800
+++ linux-2.6/include/linux/slub_def.h	2007-11-06 12:37:44.000000000 -0800
@@ -53,6 +53,13 @@ struct kmem_cache {
 	void (*ctor)(struct kmem_cache *, void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
+	int defrag_ratio;	/*
+				 * objects/possible-objects limit. If we have
+				 * less that the specified percentage of
+				 * objects allocated then defrag passes
+				 * will start to occur during reclaim.
+				 */
+
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
 #ifdef CONFIG_SLUB_DEBUG
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-06 12:37:25.000000000 -0800
+++ linux-2.6/mm/slub.c	2007-11-06 12:37:44.000000000 -0800
@@ -2363,6 +2363,7 @@ static int kmem_cache_open(struct kmem_c
 		goto error;
 
 	s->refcount = 1;
+	s->defrag_ratio = 30;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 100;
 #endif
@@ -4005,6 +4006,22 @@ static ssize_t free_calls_show(struct km
 }
 SLAB_ATTR_RO(free_calls);
 
+static ssize_t defrag_ratio_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%d\n", s->defrag_ratio);
+}
+
+static ssize_t defrag_ratio_store(struct kmem_cache *s,
+				const char *buf, size_t length)
+{
+	int n = simple_strtoul(buf, NULL, 10);
+
+	if (n < 100)
+		s->defrag_ratio = n;
+	return length;
+}
+SLAB_ATTR(defrag_ratio);
+
 #ifdef CONFIG_NUMA
 static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
@@ -4047,6 +4064,7 @@ static struct attribute * slab_attrs[] =
 	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
+	&defrag_ratio_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif

-- 
