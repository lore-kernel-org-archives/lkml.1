Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYHAScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYHAScr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYHAScJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:32:09 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:3737 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYHAScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:32:06 -0400
Message-Id: <20080801182344.088590313@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:02 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 01/19] slub: Add defrag_ratio field and sysfs support.
Content-Disposition: inline; filename=0001-SLUB-Add-defrag_ratio-field-and-sysfs-support.patch
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
 include/linux/slub_def.h |    7 +++++++
 mm/slub.c                |   23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2008-07-31 12:20:16.000000000 -0500
+++ linux-2.6/include/linux/slub_def.h	2008-07-31 12:20:17.000000000 -0500
@@ -88,6 +88,13 @@
 	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
+	int defrag_ratio;	/*
+				 * Ratio used to check the percentage of
+				 * objects allocate in a slab page.
+				 * If less than this ratio is allocated
+				 * then reclaim attempts are made.
+				 */
+
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
 #ifdef CONFIG_SLUB_DEBUG
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-07-31 12:20:16.000000000 -0500
+++ linux-2.6/mm/slub.c	2008-07-31 12:20:17.000000000 -0500
@@ -2299,6 +2299,7 @@
 		goto error;
 
 	s->refcount = 1;
+	s->defrag_ratio = 30;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 100;
 #endif
@@ -4031,6 +4032,27 @@
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
@@ -4138,6 +4160,7 @@
 	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
+	&defrag_ratio_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif

-- 
