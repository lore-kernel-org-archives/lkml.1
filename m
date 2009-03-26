Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZCZJoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZCZJoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZCZJnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:43:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49633 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZCZJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:43:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=MHf4RyjYUVJY266DTrW2lmbWZjl1wwv7WdTY9Gd64L8xuLuofUb9gxLr7WvVVFNME
	NEd4aegg7AfoG+XjDqvgQ==
Date: Thu, 26 Mar 2009 02:42:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/3] slub: add per-cache slab thrash ratio
Message-ID: <alpine.DEB.2.00.0903260240390.1454@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds /sys/kernel/slab/cache/slab_thrash_ratio, which represents the
percentage of a slab's objects that the fastpath must fulfill to not be
considered thrashing on a per-cpu basis[*].

"Thrashing" here is defined as the constant swapping of the cpu slab such
that the slowpath is followed the majority of the time because the
refilled cpu slab can only accommodate a small number of allocations.
This occurs when the object allocation and freeing pattern for a cache is
such that it spends more time swapping the cpu slab than fulfulling
fastpath allocations.

 [*] A single instance of the thrash ratio not being reached in the
     fastpath does not indicate the cpu cache is thrashing.  A
     pre-defined value will later be added to determine how many times
     the ratio must not be reached before a cache is actually thrashing.

This is defined as a ratio based on the number of objects in a cache's
slab.  This is automatically changed when /sys/kernel/slab/cache/order is
changed to reflect the same ratio.

The netperf TCP_RR benchmark illustrates slab thrashing very well with a
large number of threads.  With a test length of 60 seconds, the following
thread counts were used to show the effect of the allocation and freeing
pattern of such a workload.

Before this patchset:

	threads			Transfer Rate (per sec)
	10			66636.39
	20			96311.02
	40			103948.16
	60			140977.62
	80			166714.37
	100			190431.35
	200			244092.36

To identify the thrashing caches, the same workload was run with
CONFIG_SLUB_STATS enabled.  The following caches are obviously performing
very poorly:

	cache		ALLOC_FASTPATH	ALLOC_SLOWPATH	FREE_FASTPATH	FREE_SLOWPATH
	kmalloc-256	45186169	15930724	88289		61028526
	kmalloc-2048	33507239	27541884	46525		61002601

After this patchset (both caches with slab_thrash_ratios of 20):

	threads			Transfer Rate (per sec)
	10			68857.31
	20			98335.04
	40			124376.77
	60			146014.14
	80			177352.16
	100			195467.61
	200			245555.99

Although slabs may accommodate fewer objects than others when contiguous
memory cannot be allocated for a cache's order, the ratio is still based
on its configured `order' since slabs will exist on the partial list that
will be able to fulfill such a requirement.

The value is stored in terms of the number of objects that the ratio
represents, not the ratio itself.  This avoids costly arithmetic in the
slowpath for a calculation that could otherwise be done only when
`slab_thrash_ratio' or `order' is changed.

This also will adjust the configured ratio to one that can actually be
represented in terms of whole numbers: for example, if slab_thrash_ratio
is set to 20 for a cache with 64 objects, the effective ratio is actually
3:16 (or 18.75%).  This will be shown when reading the ratio since it is
better to represent the actual ratio instead of a pseudo substitute.

The slab_thrash_ratio for each cache do not have non-zero defaults
(yet?).

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/slub_def.h |    1 +
 mm/slub.c                |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -94,6 +94,7 @@ struct kmem_cache {
 #ifdef CONFIG_SLUB_DEBUG
 	struct kobject kobj;	/* For sysfs */
 #endif
+	u16 min_free_watermark;	/* Calculated from slab thrash ratio */
 
 #ifdef CONFIG_NUMA
 	/*
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2190,6 +2190,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	unsigned long flags = s->flags;
 	unsigned long size = s->objsize;
 	unsigned long align = s->align;
+	u16 thrash_ratio = 0;
 	int order;
 
 	/*
@@ -2295,10 +2296,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	/*
 	 * Determine the number of objects per slab
 	 */
+	if (oo_objects(s->oo))
+		thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
 	s->oo = oo_make(order, size);
 	s->min = oo_make(get_order(size), size);
 	if (oo_objects(s->oo) > oo_objects(s->max))
 		s->max = s->oo;
+	s->min_free_watermark = oo_objects(s->oo) * thrash_ratio / 100;
 
 	return !!oo_objects(s->oo);
 
@@ -2320,6 +2324,7 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		goto error;
 
 	s->refcount = 1;
+	s->min_free_watermark = 0;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
 #endif
@@ -4089,6 +4094,29 @@ static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
 SLAB_ATTR(remote_node_defrag_ratio);
 #endif
 
+static ssize_t slab_thrash_ratio_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%d\n",
+		       s->min_free_watermark * 100 / oo_objects(s->oo));
+}
+
+static ssize_t slab_thrash_ratio_store(struct kmem_cache *s, const char *buf,
+				       size_t length)
+{
+	unsigned long ratio;
+	int err;
+
+	err = strict_strtoul(buf, 10, &ratio);
+	if (err)
+		return err;
+
+	if (ratio <= 100)
+		s->min_free_watermark = oo_objects(s->oo) * ratio / 100;
+
+	return length;
+}
+SLAB_ATTR(slab_thrash_ratio);
+
 #ifdef CONFIG_SLUB_STATS
 static int show_stat(struct kmem_cache *s, char *buf, enum stat_item si)
 {
@@ -4172,6 +4200,7 @@ static struct attribute *slab_attrs[] = {
 	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
+	&slab_thrash_ratio_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
