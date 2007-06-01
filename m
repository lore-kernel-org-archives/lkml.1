Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXFAXR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXFAXR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760078AbXFAXQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:16:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42052 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760031AbXFAXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:16:57 -0400
Date: Fri, 1 Jun 2007 16:16:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601160241.33b304bf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706011615540.9781@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <20070601160241.33b304bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So a kmalloc(62) would get upped to 66, so we allocate from size-128
> and put the number 62 at bytes 124-127 and we poison bytes 62-123?

Hmmm... We are going rapidly here. This is a patch that I am testing right 
now. It right adjust the object and the patch is manageable:



SLUB mm-only: Right align kmalloc objects to trigger overwrite detection

Right align kmalloc objects if they are less than the full kmalloc slab size.
This will move the object to be flush with the end of the object in order
to allow the easy detection of writes / reads after the end of the kmalloc
object.

Without slub_debug overwrites will destroy the free pointer of the next object
or the next object. Read will yield garbage that is likely zero.

With slub_debug redzone checks will be triggered. Reads will read redzone
poison.

This patch is only for checking things out. There are issues:

1. Alignment of kmalloc objects may now be different. In particular
   objects whose size is not a multiple of wordsize may be not word alignmed.

2. __kmalloc and kfree need to touch an additional cacheline in
   struct kmem_cache thereby reducing performance.

3. An object allocated via kmalloc may no longer be freed via kmem_cache_free.

So we need to figure out some may to make this configurable. Preferably
runtime configurable.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   22 +++++++++++++++++++---
 mm/slub.c                |   11 ++++++++---
 2 files changed, 27 insertions(+), 6 deletions(-)

Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-06-01 15:56:42.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-06-01 16:00:03.000000000 -0700
@@ -120,6 +120,19 @@ static inline struct kmem_cache *kmalloc
 	return &kmalloc_caches[index];
 }
 
+static inline unsigned long kmalloc_size(size_t size)
+{
+	int index = kmalloc_index(size);
+
+	if (index >= KMALLOC_SHIFT_LOW)
+		return 1 << index;
+
+	if (index == 2)
+		return 192;
+	return 96;
+}
+
+
 #ifdef CONFIG_ZONE_DMA
 #define SLUB_DMA __GFP_DMA
 #else
@@ -135,7 +148,8 @@ static inline void *kmalloc(size_t size,
 		if (!s)
 			return NULL;
 
-		return kmem_cache_alloc(s, flags);
+		return kmem_cache_alloc(s, flags)
+				+ kmalloc_size(size) - size;
 	} else
 		return __kmalloc(size, flags);
 }
@@ -148,7 +162,8 @@ static inline void *kzalloc(size_t size,
 		if (!s)
 			return NULL;
 
-		return kmem_cache_zalloc(s, flags);
+		return kmem_cache_zalloc(s, flags)
+				+ kmalloc_size(size) - size;
 	} else
 		return __kzalloc(size, flags);
 }
@@ -159,7 +174,8 @@ extern void *__kmalloc_node(size_t size,
 static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
-		struct kmem_cache *s = kmalloc_slab(size);
+		struct kmem_cache *s = kmalloc_slab(size) +
+					kmalloc_size(size) - size;
 
 		if (!s)
 			return NULL;
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-01 15:51:05.000000000 -0700
+++ slub/mm/slub.c	2007-06-01 16:15:21.000000000 -0700
@@ -2283,9 +2283,10 @@ static struct kmem_cache *get_slab(size_
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s = get_slab(size, flags);
+	int offset = size - s->size;
 
 	if (s)
-		return slab_alloc(s, flags, -1, __builtin_return_address(0));
+		return slab_alloc(s, flags, -1, __builtin_return_address(0)) + offset;
 	return NULL;
 }
 EXPORT_SYMBOL(__kmalloc);
@@ -2294,9 +2295,10 @@ EXPORT_SYMBOL(__kmalloc);
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s = get_slab(size, flags);
+	int offset = size - s->size;
 
 	if (s)
-		return slab_alloc(s, flags, node, __builtin_return_address(0));
+		return slab_alloc(s, flags, node, __builtin_return_address(0)) + offset;
 	return NULL;
 }
 EXPORT_SYMBOL(__kmalloc_node);
@@ -2337,6 +2339,7 @@ void kfree(const void *x)
 {
 	struct kmem_cache *s;
 	struct page *page;
+	unsigned long addr = (unsigned long) x;
 
 	if (!x)
 		return;
@@ -2344,7 +2347,9 @@ void kfree(const void *x)
 	page = virt_to_head_page(x);
 	s = page->slab;
 
-	slab_free(s, page, (void *)x, __builtin_return_address(0));
+	addr &= ~((unsigned long)s->size - 1);
+
+	slab_free(s, page, (void *)addr, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kfree);
 
