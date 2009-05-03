Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZECMOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZECMOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 08:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZECMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 08:14:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43866 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZECMOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 08:14:34 -0400
Date: Sun, 3 May 2009 15:14:32 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: npiggin@suse.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SLQB: Use _RET_IP_ instead of __builtin_return_address(0)
Message-ID: <Pine.LNX.4.64.0905031513410.32397@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch changes SLQB to use the shorter _RET_IP_ form for consistency
with SLUB and to prepare SQLB for eventual kmemtrace hooks.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slqb.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index 474fd2f..f538f2c 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -246,7 +246,7 @@ static LIST_HEAD(slab_caches);
  * Tracking user of a slab.
  */
 struct track {
-	void *addr;		/* Called from address */
+	unsigned long addr;	/* Called from address */
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
@@ -385,7 +385,7 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 }
 
 static void set_track(struct kmem_cache *s, void *object,
-				enum track_item alloc, void *addr)
+				enum track_item alloc, unsigned long addr)
 {
 	struct track *p;
 
@@ -409,8 +409,8 @@ static void init_tracking(struct kmem_cache *s, void *object)
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	set_track(s, object, TRACK_FREE, NULL);
-	set_track(s, object, TRACK_ALLOC, NULL);
+	set_track(s, object, TRACK_FREE, 0UL);
+	set_track(s, object, TRACK_ALLOC, 0UL);
 }
 
 static void print_track(const char *s, struct track *t)
@@ -753,7 +753,7 @@ static void setup_object_debug(struct kmem_cache *s, struct slqb_page *page,
 }
 
 static int alloc_debug_processing(struct kmem_cache *s,
-					void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	struct slqb_page *page;
 	page = virt_to_head_slqb_page(object);
@@ -781,7 +781,7 @@ bad:
 }
 
 static int free_debug_processing(struct kmem_cache *s,
-					void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	struct slqb_page *page;
 	page = virt_to_head_slqb_page(object);
@@ -1528,7 +1528,7 @@ try_remote:
  * (debug checking and memset()ing).
  */
 static __always_inline void *slab_alloc(struct kmem_cache *s,
-				gfp_t gfpflags, int node, void *addr)
+				gfp_t gfpflags, int node, unsigned long addr)
 {
 	void *object;
 	unsigned long flags;
@@ -1550,7 +1550,7 @@ again:
 }
 
 static __always_inline void *__kmem_cache_alloc(struct kmem_cache *s,
-				gfp_t gfpflags, void *caller)
+				gfp_t gfpflags, unsigned long caller)
 {
 	int node = -1;
 #ifdef CONFIG_NUMA
@@ -1562,14 +1562,14 @@ static __always_inline void *__kmem_cache_alloc(struct kmem_cache *s,
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return __kmem_cache_alloc(s, gfpflags, __builtin_return_address(0));
+	return __kmem_cache_alloc(s, gfpflags, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, node, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -1757,7 +1757,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 
 	debug_check_no_locks_freed(object, s->objsize);
 	if (likely(object) && unlikely(slab_debug(s))) {
-		if (unlikely(!free_debug_processing(s, object, __builtin_return_address(0))))
+		if (unlikely(!free_debug_processing(s, object, _RET_IP_)))
 			return;
 	}
 
@@ -2528,7 +2528,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return __kmem_cache_alloc(s, flags, __builtin_return_address(0));
+	return __kmem_cache_alloc(s, flags, _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -3124,7 +3124,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
 	if (unlikely(current->flags & (PF_SPREAD_SLAB | PF_MEMPOLICY)))
 		node = alternate_nid(s, flags, node);
 #endif
-	return slab_alloc(s, flags, node, (void *)caller);
+	return slab_alloc(s, flags, node, caller);
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t flags, int node,
@@ -3136,7 +3136,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t flags, int node,
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, (void *)caller);
+	return slab_alloc(s, flags, node, caller);
 }
 #endif
 
-- 
1.5.6.3

