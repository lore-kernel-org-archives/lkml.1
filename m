Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZC3Fo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZC3Fo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 01:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZC3Fo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 01:44:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60010 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZC3Fo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 01:44:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kle7vIwLf2sj/A/QHwaPRoyewIK+9bbv6db1KiFwuDsp0NSOtuwZI+jQE+2WEiGqt
	7Pz4dnFGGTGsAMJHkLgEw==
Date: Sun, 29 Mar 2009 22:43:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
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
	16			71592
	32			95373
	48			113072
	64			149043
	80			172035
	96			187849
	112			204962
	128			217547
	144			232369
	160			239871
	176			242712
	192			243182

To identify the thrashing caches, the same workload was run with
CONFIG_SLUB_STATS enabled.  The following caches are obviously performing
very poorly:

	cache		ALLOC_FASTPATH	ALLOC_SLOWPATH
	kmalloc-256	98125871	31585955
	kmalloc-2048	77243698	52347453

	cache		FREE_FASTPATH	FREE_SLOWPATH
	kmalloc-256	173624		129538000
	kmalloc-2048	90520		129500630

After this patchset (both caches with slab_thrash_ratios of 20):

	threads			Transfer Rate (per sec)
	16			69505
	32			119731
	48			125014
	64			158919
	80			179679
	96			192154
	112			209988
	128			223507
	144			234565
	160			244789
	176			248971
	192			255596

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
@@ -2186,6 +2186,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	unsigned long flags = s->flags;
 	unsigned long size = s->objsize;
 	unsigned long align = s->align;
+	u16 thrash_ratio = 0;
 	int order;
 
 	/*
@@ -2291,10 +2292,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
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
 
@@ -2321,6 +2325,7 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	 */
 	set_min_partial(s, ilog2(s->size));
 	s->refcount = 1;
+	s->min_free_watermark = 0;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
 #endif
@@ -4110,6 +4115,29 @@ static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
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
@@ -4194,6 +4222,7 @@ static struct attribute *slab_attrs[] = {
 	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
+	&slab_thrash_ratio_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
