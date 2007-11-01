Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbXKAAFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbXKAAFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbXKAADY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:03:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58916 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754529AbXKAADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:03:11 -0400
Message-Id: <20071101000311.132616452@sgi.com>
References: <20071101000211.970501947@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 17:02:18 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 7/7] SLUB: Optimize per cpu access on the local cpu using this_cpu_ptr()
Content-Disposition: inline; filename=slub_this
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ptr to optimize access to the per cpu area in the fastpaths.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-10-31 14:00:28.635673087 -0700
+++ linux-2.6/mm/slub.c	2007-10-31 14:01:29.803422492 -0700
@@ -248,6 +248,15 @@ static inline struct kmem_cache_cpu *get
 #endif
 }
 
+static inline struct kmem_cache_cpu *this_cpu_slab(struct kmem_cache *s)
+{
+#ifdef CONFIG_SMP
+	return this_cpu_ptr(s->cpu_slab);
+#else
+	return &s->cpu_slab;
+#endif
+}
+
 /*
  * The end pointer in a slab is special. It points to the first object in the
  * slab but has bit 0 set to mark it.
@@ -1521,7 +1530,7 @@ static noinline unsigned long get_new_sl
 	if (!page)
 		return 0;
 
-	*pc = c = get_cpu_slab(s, smp_processor_id());
+	*pc = c = this_cpu_slab(s);
 	if (c->page) {
 		/*
 		 * Someone else populated the cpu_slab while we
@@ -1650,25 +1659,26 @@ static void __always_inline *slab_alloc(
 	struct kmem_cache_cpu *c;
 
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
-	c = get_cpu_slab(s, get_cpu());
+	preempt_disable();
+	c = this_cpu_slab(s);
 	do {
 		object = c->freelist;
 		if (unlikely(is_end(object) || !node_match(c, node))) {
 			object = __slab_alloc(s, gfpflags, node, addr, c);
 			if (unlikely(!object)) {
-				put_cpu();
+				preempt_enable();
 				goto out;
 			}
 			break;
 		}
 	} while (cmpxchg_local(&c->freelist, object,
 			get_freepointer(s, object)) != object);
-	put_cpu();
+	preempt_enable();
 #else
 	unsigned long flags;
 
 	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
+	c = this_cpu_slab(s);
 	if (unlikely((is_end(c->freelist)) || !node_match(c, node))) {
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
@@ -1794,7 +1804,8 @@ static void __always_inline slab_free(st
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
 	void **freelist;
 
-	c = get_cpu_slab(s, get_cpu());
+	preempt_disable();
+	c = this_cpu_slab(s);
 	debug_check_no_locks_freed(object, s->objsize);
 	do {
 		freelist = c->freelist;
@@ -1816,13 +1827,13 @@ static void __always_inline slab_free(st
 		}
 		set_freepointer(s, object, freelist);
 	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
-	put_cpu();
+	preempt_enable();
 #else
 	unsigned long flags;
 
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
-	c = get_cpu_slab(s, smp_processor_id());
+	c = this_cpu_slab(s);
 	if (likely(page == c->page && c->node >= 0)) {
 		set_freepointer(s, object, c->freelist);
 		c->freelist = object;

-- 
