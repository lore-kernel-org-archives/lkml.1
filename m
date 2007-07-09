Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbXGINqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbXGINqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXGINqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:46:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39874 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGINqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:46:08 -0400
Date: Mon, 9 Jul 2007 16:46:04 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <46921928.8020900@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707091641110.31895@sbz-30.cs.Helsinki.FI>
References: <20070708034952.022985379@sgi.com>  <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu>  <20070708110224.9cd9df5b.akpm@linux-foundation.org>
  <4691A415.6040208@yahoo.com.au> <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
 <46921928.8020900@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Pekka Enberg wrote:
> > adding some non-power-of-two kmalloc caches might help with internal
> > fragmentation.

On Mon, 9 Jul 2007, Nick Piggin wrote:
> That too, although of course it will work against the external
> fragmentation problem. This is more of an O(n) problem and may not
> be responsible for as much waste as the first issue on small memory
> machines (I haven't done detailed profiling so I don't know).

I would have thought so too, but my crude hack to approximate internal 
fragmentation says otherwise. On the same Debian on UML virtual machine I 
see up to 190 KB of wasted space due to internal fragmentation (average 
allocation size being considerably smaller than object size for cache) 
with the biggest offender being kmalloc-512.

But, what we really need is some real workloads on small machines using 
something resembling my scripts to figure out the memory profile for SLUB.

			Pekka

#!/bin/bash

total_wasted=0

for i in $(find /sys/slab -type d -mindepth 1 -maxdepth 1 | sort)
do
  slabs=$(cat $i/slabs)
  objs_per_slab=$(cat $i/objs_per_slab)
  let "max_objs=$objs_per_slab*$slabs"

  object_size=$(cat $i/object_size)
  average_alloc_size=$(cat $i/average_alloc_size)

  if [ "0" -ne "$average_alloc_size" ]; then
    let "wasted=($object_size-$average_alloc_size)*max_objs"
    echo "$i: object_size=$object_size, 
average_alloc_size=$average_alloc_size, $wasted bytes wasted"
    let "total_wasted=$total_wasted+$wasted"
  fi
done
echo "Total internal fragmentation: $total_wasted bytes"

---
 include/linux/slub_def.h |    1 +
 mm/slub.c                |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

Index: 2.6/include/linux/slub_def.h
===================================================================
--- 2.6.orig/include/linux/slub_def.h	2007-07-09 16:09:24.000000000 +0300
+++ 2.6/include/linux/slub_def.h	2007-07-09 16:18:42.000000000 +0300
@@ -29,6 +29,7 @@ struct kmem_cache {
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
 	int order;
+	int average_alloc_size;
 
 	/*
 	 * Avoid an extra cache line for UP, SMP and for the node local to
Index: 2.6/mm/slub.c
===================================================================
--- 2.6.orig/mm/slub.c	2007-07-09 16:09:24.000000000 +0300
+++ 2.6/mm/slub.c	2007-07-09 16:35:53.000000000 +0300
@@ -2238,12 +2238,22 @@ 	BUG_ON(index < 0);
 	return &kmalloc_caches[index];
 }
 
+static void update_avg(struct kmem_cache *s, size_t size)
+{
+	if (s->average_alloc_size)
+		s->average_alloc_size = (s->average_alloc_size + size) / 2;
+	else
+		s->average_alloc_size = size;
+}
+
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s = get_slab(size, flags);
 
-	if (s)
+	if (s) {
+		update_avg(s, size);
 		return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	}
 	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc);
@@ -2253,8 +2263,11 @@ void *__kmalloc_node(size_t size, gfp_t 
 {
 	struct kmem_cache *s = get_slab(size, flags);
 
-	if (s)
+	if (s) {
+		update_avg(s, size);
 		return slab_alloc(s, flags, node, __builtin_return_address(0));
+	}
+
 	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc_node);
@@ -2677,6 +2690,8 @@ void *__kmalloc_track_caller(size_t size
 	if (!s)
 		return ZERO_SIZE_PTR;
 
+	update_avg(s, size);
+
 	return slab_alloc(s, gfpflags, -1, caller);
 }
 
@@ -2688,6 +2703,8 @@ void *__kmalloc_node_track_caller(size_t
 	if (!s)
 		return ZERO_SIZE_PTR;
 
+	update_avg(s, size);
+
 	return slab_alloc(s, gfpflags, node, caller);
 }
 
@@ -3268,6 +3285,12 @@ static ssize_t objects_show(struct kmem_
 }
 SLAB_ATTR_RO(objects);
 
+static ssize_t average_alloc_size_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%d\n", s->average_alloc_size);
+}
+SLAB_ATTR_RO(average_alloc_size);
+
 static ssize_t sanity_checks_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_DEBUG_FREE));
@@ -3466,6 +3489,7 @@ static struct attribute * slab_attrs[] =
 	&order_attr.attr,
 	&objects_attr.attr,
 	&slabs_attr.attr,
+	&average_alloc_size_attr.attr,
 	&partial_attr.attr,
 	&cpu_slabs_attr.attr,
 	&ctor_attr.attr,
