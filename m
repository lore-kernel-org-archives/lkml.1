Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYGSMaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYGSMaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYGSMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:30:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYGSMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:30:27 -0400
Date: Sat, 19 Jul 2008 15:30:09 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 1/8] slub: Add defrag_ratio field and sysfs support.
Message-ID: <Pine.LNX.4.64.0807191529450.13345@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

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
---
 include/linux/slub_def.h |    7 +++++++
 mm/slub.c                |   23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index d117ea2..6f8d25f 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -88,6 +88,13 @@ struct kmem_cache {
 	void (*ctor)(struct kmem_cache *, void *);
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
diff --git a/mm/slub.c b/mm/slub.c
index 35ab38a..1b910ab 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2338,6 +2338,7 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		goto error;
 
 	s->refcount = 1;
+	s->defrag_ratio = 30;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 100;
 #endif
@@ -4071,6 +4072,27 @@ static ssize_t free_calls_show(struct kmem_cache *s, char *buf)
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
@@ -4178,6 +4200,7 @@ static struct attribute *slab_attrs[] = {
 	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
+	&defrag_ratio_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
-- 
1.5.4.3

