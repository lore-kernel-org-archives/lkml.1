Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXGHDwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXGHDwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbXGHDua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49259 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756036AbXGHDuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:19 -0400
Message-Id: <20070708035017.607053208@sgi.com>
References: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:49:59 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 07/10] SLUB: Optimize cacheline use for zeroing
Content-Disposition: inline; filename=slub_optimize_zeroing
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We touch a cacheline in the kmem_cache structure for zeroing to get the
size. However, the hot paths in slab_alloc and slab_free do not reference
any other fields in kmem_cache.

Add a new field to kmem_cache_cpu that contains the object size. That
cacheline must already be used. So we save one cacheline on every
slab_alloc.

We need to update the kmem_cache_cpu object size if an aliasing operation
changes the objsize of an non debug slab.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    1 +
 mm/slub.c                |   14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc6-mm1/include/linux/slub_def.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/slub_def.h	2007-07-07 13:56:24.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/linux/slub_def.h	2007-07-07 15:52:37.000000000 -0700
@@ -16,6 +16,7 @@ struct kmem_cache_cpu {
 	struct page *page;
 	int node;
 	unsigned int offset;
+	unsigned int objsize;
 };
 
 struct kmem_cache_node {
Index: linux-2.6.22-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slub.c	2007-07-07 13:56:24.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-07 17:49:25.000000000 -0700
@@ -1571,7 +1571,7 @@ static void __always_inline *slab_alloc(
 	local_irq_restore(flags);
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
-		memset(object, 0, s->objsize);
+		memset(object, 0, c->objsize);
 
 	return object;
 }
@@ -1864,8 +1864,9 @@ static void init_kmem_cache_cpu(struct k
 {
 	c->page = NULL;
 	c->freelist = NULL;
-	c->offset = s->offset / sizeof(void *);
 	c->node = 0;
+	c->offset = s->offset / sizeof(void *);
+	c->objsize = s->objsize;
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
@@ -3173,12 +3174,21 @@ struct kmem_cache *kmem_cache_create(con
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, ctor, ops);
 	if (s) {
+		int cpu;
+
 		s->refcount++;
 		/*
 		 * Adjust the object sizes so that we clear
 		 * the complete object on kzalloc.
 		 */
 		s->objsize = max(s->objsize, (int)size);
+
+		/*
+		 * And then we need to update the object size in the
+		 * per cpu structures
+		 */
+		for_each_online_cpu(cpu)
+			get_cpu_slab(s, cpu)->objsize = s->objsize;
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
 

-- 
