Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXCVWe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXCVWe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161176AbXCVWe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:34:56 -0400
Received: from www.cosmosbay.com ([86.65.150.131]:47678 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161148AbXCVWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:34:55 -0400
Message-ID: <4603047C.4070904@cosmosbay.com>
Date: Thu, 22 Mar 2007 23:34:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: akpm@osdl.org
CC: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, hch@lst.de, manfred@colorfullife.com,
       christoph@lameter.com, pj@sgi.com
Subject: [PATCH] slab: NUMA kmem_cache diet
References: <Pine.LNX.4.64.0701021545290.21477@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0701021545290.21477@sbz-30.cs.Helsinki.FI>
Content-Type: multipart/mixed;
 boundary="------------070606050003000609010805"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 22 Mar 2007 23:34:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070606050003000609010805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Some NUMA machines have a big MAX_NUMNODES (possibly 1024), but fewer possible 
nodes. This patch dynamically sizes the 'struct kmem_cache' to allocate only 
needed space.

I moved nodelists[] field at the end of struct kmem_cache, and use the 
following computation in kmem_cache_init()

cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) +
                                 nr_node_ids * sizeof(struct kmem_list3 *);


On my two nodes x86_64 machine, kmem_cache.obj_size is now 192 instead of 704
(This is because on x86_64, MAX_NUMNODES is 64)

On bigger NUMA setups, this might reduce the gfporder of "cache_cache"

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------070606050003000609010805
Content-Type: text/plain;
 name="kmem_cache_diet.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kmem_cache_diet.patch"

diff --git a/mm/slab.c b/mm/slab.c
index abf46ae..b187618 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -389,7 +389,6 @@ struct kmem_cache {
 	unsigned int buffer_size;
 	u32 reciprocal_buffer_size;
 /* 3) touched by every alloc & free from the backend */
-	struct kmem_list3 *nodelists[MAX_NUMNODES];
 
 	unsigned int flags;		/* constant flags */
 	unsigned int num;		/* # of objs per slab */
@@ -444,6 +443,17 @@ #if DEBUG
 	int obj_offset;
 	int obj_size;
 #endif
+	/*
+	 * We put nodelists[] at the end of kmem_cache, because we want to size
+	 * this array to nr_node_ids slots instead of MAX_NUMNODES
+	 * (see kmem_cache_init())
+	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
+	 * is statically defined, so we reserve the max number of nodes.
+	 */
+	struct kmem_list3 *nodelists[MAX_NUMNODES];
+	/*
+	 * Do not add fields after nodelists[]
+	 */
 };
 
 #define CFLGS_OFF_SLAB		(0x80000000UL)
@@ -678,9 +688,6 @@ static struct kmem_cache cache_cache = {
 	.shared = 1,
 	.buffer_size = sizeof(struct kmem_cache),
 	.name = "kmem_cache",
-#if DEBUG
-	.obj_size = sizeof(struct kmem_cache),
-#endif
 };
 
 #define BAD_ALIEN_MAGIC 0x01020304ul
@@ -1437,6 +1444,15 @@ void __init kmem_cache_init(void)
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
 	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
 
+	/*
+	 * struct kmem_cache size depends on nr_node_ids, which
+	 * can be less than MAX_NUMNODES.
+	 */
+	cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) +
+				 nr_node_ids * sizeof(struct kmem_list3 *);
+#if DEBUG
+	cache_cache.obj_size = cache_cache.buffer_size;
+#endif
 	cache_cache.buffer_size = ALIGN(cache_cache.buffer_size,
 					cache_line_size());
 	cache_cache.reciprocal_buffer_size =

--------------070606050003000609010805--
