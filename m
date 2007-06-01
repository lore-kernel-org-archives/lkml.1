Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbXFAX3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbXFAX3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXFAX3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:29:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57017 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752691AbXFAX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:29:29 -0400
Date: Fri, 1 Jun 2007 16:29:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706011617330.9781@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Linus Torvalds wrote:

> So for *both* of the above reasons, it's actually stupid to return NULL 
> for a zero-sized allocation. It would be much better to return another 
> pointer that will trap on access. A good candidate might be to return
> 
> 	#define BADPTR ((void *)16)

Something like this? (Not tested yet just for review):


SLUB: Return BADPTR instead of warning for kmalloc(0)

Remove the WARN_ON_ONCE and simply return BADPTR.

BADPTR can be used legitimately as long as it is not dereferenced.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   18 ++++++++----------
 mm/slub.c                |    8 ++++----
 2 files changed, 12 insertions(+), 14 deletions(-)

Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-06-01 16:19:36.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-06-01 16:24:54.000000000 -0700
@@ -12,6 +12,8 @@
 #include <linux/kobject.h>
 #include <linux/log2.h>
 
+#define BADPTR ((void *)16)
+
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
@@ -74,13 +76,9 @@ extern struct kmem_cache kmalloc_caches[
  */
 static inline int kmalloc_index(size_t size)
 {
-	/*
-	 * We should return 0 if size == 0 (which would result in the
-	 * kmalloc caller to get NULL) but we use the smallest object
-	 * here for legacy reasons. Just issue a warning so that
-	 * we can discover locations where we do 0 sized allocations.
-	 */
-	WARN_ON_ONCE(size == 0);
+
+	if (!size)
+		return 0;
 
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
@@ -133,7 +131,7 @@ static inline void *kmalloc(size_t size,
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return BADPTR;
 
 		return kmem_cache_alloc(s, flags);
 	} else
@@ -146,7 +144,7 @@ static inline void *kzalloc(size_t size,
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return BADPTR;
 
 		return kmem_cache_zalloc(s, flags);
 	} else
@@ -162,7 +160,7 @@ static inline void *kmalloc_node(size_t 
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return BADPTR;
 
 		return kmem_cache_alloc_node(s, flags, node);
 	} else
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-01 16:21:00.000000000 -0700
+++ slub/mm/slub.c	2007-06-01 16:27:12.000000000 -0700
@@ -2286,7 +2286,7 @@ void *__kmalloc(size_t size, gfp_t flags
 
 	if (s)
 		return slab_alloc(s, flags, -1, __builtin_return_address(0));
-	return NULL;
+	return BADPTR;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2297,7 +2297,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 
 	if (s)
 		return slab_alloc(s, flags, node, __builtin_return_address(0));
-	return NULL;
+	return BADPTR;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2707,7 +2707,7 @@ void *__kmalloc_track_caller(size_t size
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return BADPTR;
 
 	return slab_alloc(s, gfpflags, -1, caller);
 }
@@ -2718,7 +2718,7 @@ void *__kmalloc_node_track_caller(size_t
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return BADPTR;
 
 	return slab_alloc(s, gfpflags, node, caller);
 }
