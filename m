Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXDZFLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXDZFLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXDZFJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:09:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754722AbXDZFJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:09:34 -0400
Message-Id: <20070426050934.252670624@sgi.com>
References: <20070426050743.867613938@sgi.com>
User-Agent: quilt/0.45-1
Date: Wed, 25 Apr 2007 22:07:47 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/7] SLUB: Conform more to SLABs SLAB_HWCACHE_ALIGN behavior
Content-Disposition: inline; filename=slub_hwalign
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently SLUB is using a strict L1_CACHE_BYTES alignment if
SLAB_HWCACHE_ALIGN is specified. SLAB does not align to a cacheline if the
object is smaller than half of a cacheline. Small objects are then aligned
by SLAB to a fraction of a cacheline.

Make SLUB just forget about the alignment requirement if the object size
is less than L1_CACHE_BYTES. It seems that fractional alignments are no
good because they grow the object and reduce the object density in a cache
line needlessly causing additional cache line fetches.

If we are already throwing the user suggestion of a cache line alignment
away then lets do the best we can. Maybe SLAB_HWCACHE_ALIGN also needs
to be tossed given its wishy-washy handling but doing so would require
an audit of all kmem_cache_allocs throughout the kernel source.

In any case one needs to explictly specify an alignment during
kmem_cache_create to either slab allocator in order to ensure that the
objects are cacheline aligned.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc7-mm1/mm/slub.c
===================================================================
--- linux-2.6.21-rc7-mm1.orig/mm/slub.c	2007-04-25 21:23:56.000000000 -0700
+++ linux-2.6.21-rc7-mm1/mm/slub.c	2007-04-25 21:23:59.000000000 -0700
@@ -1482,9 +1482,19 @@ static int calculate_order(int size)
  * various ways of specifying it.
  */
 static unsigned long calculate_alignment(unsigned long flags,
-		unsigned long align)
+		unsigned long align, unsigned long size)
 {
-	if (flags & SLAB_HWCACHE_ALIGN)
+	/*
+	 * If the user wants hardware cache aligned objects then
+	 * follow that suggestion if the object is sufficiently
+	 * large.
+	 *
+	 * The hardware cache alignment cannot override the
+	 * specified alignment though. If that is greater
+	 * then use it.
+	 */
+	if ((flags & SLAB_HWCACHE_ALIGN) &&
+			size > L1_CACHE_BYTES / 2)
 		return max_t(unsigned long, align, L1_CACHE_BYTES);
 
 	if (align < ARCH_SLAB_MINALIGN)
@@ -1673,7 +1683,7 @@ static int calculate_sizes(struct kmem_c
 	 * user specified (this is unecessarily complex due to the attempt
 	 * to be compatible with SLAB. Should be cleaned up some day).
 	 */
-	align = calculate_alignment(flags, align);
+	align = calculate_alignment(flags, align, s->objsize);
 
 	/*
 	 * SLUB stores one object immediately after another beginning from
@@ -2250,7 +2260,7 @@ static struct kmem_cache *find_mergeable
 		return NULL;
 
 	size = ALIGN(size, sizeof(void *));
-	align = calculate_alignment(flags, align);
+	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
 
 	list_for_each(h, &slab_caches) {

--
