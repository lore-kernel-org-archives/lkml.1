Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473Ab0A2Uwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0A2Uwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310Ab0A2Uwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:52:32 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42795 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0A2UvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:20 -0500
Message-Id: <20100129204958.491259988@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:32 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub: Add defrag_ratio field and sysfs support.
Content-Disposition: inline; filename=slub_add_defrag_ratio
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The defrag_ratio is used to set the threshold at which defragmentation
should be attempted on a slab page.

The allocation ratio is measured by the percentage of the available slots
allocated.

Add a defrag ratio field and set it to 30% by default. A limit of 30% specified
that less than 3 out of 10 available slots for objects are in use before
slab defragmeentation runs.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 Documentation/ABI/testing/sysfs-kernel-slab |   13 +++++++++++++
 include/linux/slub_def.h                    |    6 ++++++
 mm/slub.c                                   |   23 +++++++++++++++++++++++
 3 files changed, 42 insertions(+)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2010-01-29 10:37:01.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2010-01-29 10:42:43.000000000 -0600
@@ -91,6 +91,12 @@ struct kmem_cache {
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
 	unsigned long min_partial;
+	int defrag_ratio;	/*
+				 * Ratio used to check the percentage of
+				 * objects allocate in a slab page.
+				 * If less than this ratio is allocated
+				 * then reclaim attempts are made.
+				 */
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
 #ifdef CONFIG_SLUB_DEBUG
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-01-29 10:37:01.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-01-29 10:42:44.000000000 -0600
@@ -2494,6 +2494,7 @@ static int kmem_cache_open(struct kmem_c
 	 */
 	set_min_partial(s, ilog2(s->size));
 	s->refcount = 1;
+	s->defrag_ratio = 30;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
 #endif
@@ -4317,6 +4318,27 @@ static ssize_t free_calls_show(struct km
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
+	unsigned long ratio;
+	int err;
+
+	err = strict_strtoul(buf, 10, &ratio);
+	if (err)
+		return err;
+
+	if (ratio < 100)
+		s->defrag_ratio = ratio;
+	return length;
+}
+SLAB_ATTR(defrag_ratio);
+
 #ifdef CONFIG_NUMA
 static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
@@ -4441,6 +4463,7 @@ static struct attribute *slab_attrs[] = 
 	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
+	&defrag_ratio_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
Index: linux-2.6/Documentation/ABI/testing/sysfs-kernel-slab
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-kernel-slab	2010-01-29 10:43:21.000000000 -0600
+++ linux-2.6/Documentation/ABI/testing/sysfs-kernel-slab	2010-01-29 10:47:19.000000000 -0600
@@ -180,6 +180,19 @@ Description:
 		list.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
+What:		/sys/kernel/slab/cache/defrag_ratio
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Christoph Lameter <cl@linux-foundation.org>
+		Pekka Enberg <penberg@cs.helsinki.fi>,
+Description:
+		The defrag_ratio files allows the control of how agressive
+		slab fragmentation reduction works at reclaiming objects from
+		sparsely populated slabs. This is a percentage. If a slab
+		contains less than this percentage of objects then reclaim
+		will attempt to reclaim objects so that the whole slab
+		page can be freed. The default is 30%.
+
 What:		/sys/kernel/slab/cache/deactivate_to_tail
 Date:		February 2008
 KernelVersion:	2.6.25

-- 
