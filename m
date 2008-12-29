Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYL2BlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYL2BlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 20:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYL2BkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 20:40:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:10146 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYL2Bj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 20:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=KCDnaaJBvSFrbBdIyH6mN5oxobbkv9OTzo9aO9g6U/qlmebpK6EdmhX1BcHwOKdluC
         USvGrK+f8K38dB9HnNfT1ZfhFXIqXhI48LoirDsypd0SouCUQFOYiYbs1DcDehiGRWAT
         X8+m6bwbBKErMxNn4QH17aUqbbH30xXwsSSLU=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Date: Mon, 29 Dec 2008 03:40:08 +0200
Message-Id: <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4dcbaab558466e1cd0be66f3b66c7c5d2a0c532b.1230499486.git.eduard.munteanu@linux360.ro>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro>
 <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro>
 <4dcbaab558466e1cd0be66f3b66c7c5d2a0c532b.1230499486.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1230499486.git.eduard.munteanu@linux360.ro>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemtrace now uses tracepoints instead of markers. We no longer need to
use format specifiers. Also dropped kmemtrace_mark_alloc_node(), since
it's easy to pass -1 as the NUMA node without providing a needless and
long-named variant of the same function.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/kmemtrace.h |   76 +++++++++-----------------------------------
 include/linux/slab_def.h  |   11 +++---
 include/linux/slub_def.h  |   16 +++++-----
 lib/Kconfig.debug         |    2 +-
 mm/kmemtrace.c            |   50 ++++++++++++++---------------
 mm/slab.c                 |   27 ++++++++--------
 mm/slob.c                 |   32 +++++++++---------
 mm/slub.c                 |   36 ++++++++++----------
 8 files changed, 103 insertions(+), 147 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
index 5bea8ea..7b38245 100644
--- a/include/linux/kmemtrace.h
+++ b/include/linux/kmemtrace.h
@@ -9,8 +9,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/tracepoint.h>
 #include <linux/types.h>
-#include <linux/marker.h>
 
 enum kmemtrace_type_id {
 	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
@@ -18,67 +18,23 @@ enum kmemtrace_type_id {
 	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
 };
 
-#ifdef CONFIG_KMEMTRACE
-
 extern void kmemtrace_init(void);
 
-static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-					     unsigned long call_site,
-					     const void *ptr,
-					     size_t bytes_req,
-					     size_t bytes_alloc,
-					     gfp_t gfp_flags,
-					     int node)
-{
-	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
-		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
-		   type_id, call_site, (unsigned long) ptr,
-		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
-		   (unsigned long) gfp_flags, node);
-}
-
-static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-				       unsigned long call_site,
-				       const void *ptr)
-{
-	trace_mark(kmemtrace_free, "type_id %d call_site %lu ptr %lu",
-		   type_id, call_site, (unsigned long) ptr);
-}
-
-#else /* CONFIG_KMEMTRACE */
-
-static inline void kmemtrace_init(void)
-{
-}
-
-static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-					     unsigned long call_site,
-					     const void *ptr,
-					     size_t bytes_req,
-					     size_t bytes_alloc,
-					     gfp_t gfp_flags,
-					     int node)
-{
-}
-
-static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-				       unsigned long call_site,
-				       const void *ptr)
-{
-}
-
-#endif /* CONFIG_KMEMTRACE */
-
-static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
-					unsigned long call_site,
-					const void *ptr,
-					size_t bytes_req,
-					size_t bytes_alloc,
-					gfp_t gfp_flags)
-{
-	kmemtrace_mark_alloc_node(type_id, call_site, ptr,
-				  bytes_req, bytes_alloc, gfp_flags, -1);
-}
+DEFINE_TRACE(kmemtrace_alloc,
+	     TPPROTO(enum kmemtrace_type_id type_id,
+		     unsigned long call_site,
+		     const void *ptr,
+		     size_t bytes_req,
+		     size_t bytes_alloc,
+		     gfp_t gfp_flags,
+		     int node),
+	     TPARGS(type_id, call_site, ptr,
+		    bytes_req, bytes_alloc, gfp_flags, node));
+DEFINE_TRACE(kmemtrace_free,
+	     TPPROTO(enum kmemtrace_type_id type_id,
+		     unsigned long call_site,
+		     const void *ptr),
+	     TPARGS(type_id, call_site, ptr));
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 7555ce9..e5a8b60 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -76,8 +76,9 @@ found:
 
 		ret = kmem_cache_alloc_notrace(cachep, flags);
 
-		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-				     size, slab_buffer_size(cachep), flags);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
+				      size, slab_buffer_size(cachep),
+				      flags, -1);
 
 		return ret;
 	}
@@ -134,9 +135,9 @@ found:
 
 		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
-					  ret, size, slab_buffer_size(cachep),
-					  flags, node);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
+				      ret, size, slab_buffer_size(cachep),
+				      flags, node);
 
 		return ret;
 	}
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index dc28432..ce69c68 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -220,8 +220,8 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 	unsigned int order = get_order(size);
 	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-			     size, PAGE_SIZE << order, flags);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
+			      size, PAGE_SIZE << order, flags, -1);
 
 	return ret;
 }
@@ -242,9 +242,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 
 			ret = kmem_cache_alloc_notrace(s, flags);
 
-			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-					     _THIS_IP_, ret,
-					     size, s->size, flags);
+			trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
+					      _THIS_IP_, ret,
+					      size, s->size, flags, -1);
 
 			return ret;
 		}
@@ -283,9 +283,9 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 
 		ret = kmem_cache_alloc_node_notrace(s, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _THIS_IP_, ret,
-					  size, s->size, flags, node);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
+				      _THIS_IP_, ret,
+				      size, s->size, flags, node);
 
 		return ret;
 	}
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b5417e2..9cf8eb8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -805,7 +805,7 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 config KMEMTRACE
 	bool "Kernel memory tracer (kmemtrace)"
-	depends on RELAY && DEBUG_FS && MARKERS
+	depends on RELAY && DEBUG_FS && TRACEPOINTS
 	help
 	  kmemtrace provides tracing for slab allocator functions, such as
 	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
diff --git a/mm/kmemtrace.c b/mm/kmemtrace.c
index 2a70a80..7bc81b2 100644
--- a/mm/kmemtrace.c
+++ b/mm/kmemtrace.c
@@ -58,8 +58,13 @@ struct kmemtrace_stats_alloc {
 	s32		numa_node;
 } __attribute__ ((__packed__));
 
-static void kmemtrace_probe_alloc(void *probe_data, void *call_data,
-				  const char *format, va_list *args)
+static void kmemtrace_probe_alloc(enum kmemtrace_type_id type_id,
+				  unsigned long call_site,
+				  const void *ptr,
+				  size_t bytes_req,
+				  size_t bytes_alloc,
+				  gfp_t gfp_flags,
+				  int node)
 {
 	unsigned long flags;
 	struct kmemtrace_event *ev;
@@ -81,25 +86,26 @@ static void kmemtrace_probe_alloc(void *probe_data, void *call_data,
 
 	ev = buf;
 	ev->event_id = KMEMTRACE_EVENT_ALLOC;
-	ev->type_id = va_arg(*args, int);
+	ev->type_id = type_id;
 	ev->event_size = sizeof(struct kmemtrace_event) +
 			 sizeof(struct kmemtrace_stats_alloc);
 	ev->seq_num = atomic_add_return(1, &kmemtrace_seq_num);
-	ev->call_site = va_arg(*args, unsigned long);
-	ev->ptr = va_arg(*args, unsigned long);
+	ev->call_site = call_site;
+	ev->ptr = (unsigned long) ptr;
 
 	stats = buf + sizeof(struct kmemtrace_event);
-	stats->bytes_req = va_arg(*args, unsigned long);
-	stats->bytes_alloc = va_arg(*args, unsigned long);
-	stats->gfp_flags = va_arg(*args, unsigned long);
-	stats->numa_node = va_arg(*args, int);
+	stats->bytes_req = bytes_req;
+	stats->bytes_alloc = bytes_alloc;
+	stats->gfp_flags = gfp_flags;
+	stats->numa_node = node;
 
 failed:
 	local_irq_restore(flags);
 }
 
-static void kmemtrace_probe_free(void *probe_data, void *call_data,
-				 const char *format, va_list *args)
+static void kmemtrace_probe_free(enum kmemtrace_type_id type_id,
+				 unsigned long call_site,
+				 const void *ptr)
 {
 	unsigned long flags;
 	struct kmemtrace_event *ev;
@@ -115,11 +121,11 @@ static void kmemtrace_probe_free(void *probe_data, void *call_data,
 	 * C99 does not guarantee the rvalues evaluation order.
 	 */
 	ev->event_id = KMEMTRACE_EVENT_FREE;
-	ev->type_id = va_arg(*args, int);
+	ev->type_id = type_id;
 	ev->event_size = sizeof(struct kmemtrace_event);
 	ev->seq_num = atomic_add_return(1, &kmemtrace_seq_num);
-	ev->call_site = va_arg(*args, unsigned long);
-	ev->ptr = va_arg(*args, unsigned long);
+	ev->call_site = call_site;
+	ev->ptr = (unsigned long) ptr;
 
 failed:
 	local_irq_restore(flags);
@@ -173,26 +179,18 @@ static int kmemtrace_start_probes(void)
 {
 	int err;
 
-	err = marker_probe_register("kmemtrace_alloc", "type_id %d "
-				    "call_site %lu ptr %lu "
-				    "bytes_req %lu bytes_alloc %lu "
-				    "gfp_flags %lu node %d",
-				    kmemtrace_probe_alloc, NULL);
+	err = register_trace_kmemtrace_alloc(kmemtrace_probe_alloc);
 	if (err)
 		return err;
-	err = marker_probe_register("kmemtrace_free", "type_id %d "
-				    "call_site %lu ptr %lu",
-				    kmemtrace_probe_free, NULL);
+	err = register_trace_kmemtrace_free(kmemtrace_probe_free);
 
 	return err;
 }
 
 static void kmemtrace_stop_probes(void)
 {
-	marker_probe_unregister("kmemtrace_alloc",
-				kmemtrace_probe_alloc, NULL);
-	marker_probe_unregister("kmemtrace_free",
-				kmemtrace_probe_free, NULL);
+	unregister_trace_kmemtrace_alloc(kmemtrace_probe_alloc);
+	unregister_trace_kmemtrace_free(kmemtrace_probe_free);
 }
 
 static int kmemtrace_enabled_get(void *data, u64 *val)
diff --git a/mm/slab.c b/mm/slab.c
index 1fcb32b..74d405d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3624,8 +3624,9 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     obj_size(cachep), cachep->buffer_size, flags);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			      obj_size(cachep), cachep->buffer_size,
+			      flags, -1);
 
 	return ret;
 }
@@ -3686,9 +3687,9 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	void *ret = __cache_alloc_node(cachep, flags, nodeid,
 				       __builtin_return_address(0));
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  obj_size(cachep), cachep->buffer_size,
-				  flags, nodeid);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			      obj_size(cachep), cachep->buffer_size,
+			      flags, nodeid);
 
 	return ret;
 }
@@ -3716,9 +3717,9 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 		return cachep;
 	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-				  (unsigned long) caller, ret,
-				  size, cachep->buffer_size, flags, node);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
+			      (unsigned long) caller, ret,
+			      size, cachep->buffer_size, flags, node);
 
 	return ret;
 }
@@ -3768,9 +3769,9 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 		return cachep;
 	ret = __cache_alloc(cachep, flags, caller);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-			     (unsigned long) caller, ret,
-			     size, cachep->buffer_size, flags);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
+			      (unsigned long) caller, ret,
+			      size, cachep->buffer_size, flags, -1);
 
 	return ret;
 }
@@ -3816,7 +3817,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	__cache_free(cachep, objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
+	trace_kmemtrace_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3844,7 +3845,7 @@ void kfree(const void *objp)
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
+	trace_kmemtrace_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index 0f1a49f..15f812c 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -477,9 +477,9 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		*m = size;
 		ret = (void *)m + align;
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, size + align, gfp, node);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
+				      _RET_IP_, ret,
+				      size, size + align, gfp, node);
 	} else {
 		unsigned int order = get_order(size);
 
@@ -490,9 +490,9 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			page->private = size;
 		}
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << order, gfp, node);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
+				      _RET_IP_, ret,
+				      size, PAGE_SIZE << order, gfp, node);
 	}
 
 	return ret;
@@ -514,7 +514,7 @@ void kfree(const void *block)
 	} else
 		put_page(&sp->page);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -585,16 +585,16 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  SLOB_UNITS(c->size) * SLOB_UNIT,
-					  flags, node);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE,
+				      _RET_IP_, b, c->size,
+				      SLOB_UNITS(c->size) * SLOB_UNIT,
+				      flags, node);
 	} else {
 		b = slob_new_page(flags, get_order(c->size), node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  PAGE_SIZE << get_order(c->size),
-					  flags, node);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE,
+				      _RET_IP_, b, c->size,
+				      PAGE_SIZE << get_order(c->size),
+				      flags, node);
 	}
 
 	if (c->ctor)
@@ -632,7 +632,7 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		__kmem_cache_free(b, c->size);
 	}
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
+	trace_kmemtrace_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index f756915..3a2ec3a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1620,8 +1620,8 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
 	void *ret = slab_alloc(s, gfpflags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     s->objsize, s->size, gfpflags);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			      s->objsize, s->size, gfpflags, -1);
 
 	return ret;
 }
@@ -1640,8 +1640,8 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
 	void *ret = slab_alloc(s, gfpflags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  s->objsize, s->size, gfpflags, node);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			      s->objsize, s->size, gfpflags, node);
 
 	return ret;
 }
@@ -1766,7 +1766,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	slab_free(s, page, x, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
+	trace_kmemtrace_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2694,8 +2694,8 @@ void *__kmalloc(size_t size, gfp_t flags)
 
 	ret = slab_alloc(s, flags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-			     size, s->size, flags);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
+			      size, s->size, flags, -1);
 
 	return ret;
 }
@@ -2721,10 +2721,10 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(size > PAGE_SIZE)) {
 		ret = kmalloc_large_node(size, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << get_order(size),
-					  flags, node);
+		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
+				      _RET_IP_, ret,
+				      size, PAGE_SIZE << get_order(size),
+				      flags, node);
 
 		return ret;
 	}
@@ -2736,8 +2736,8 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 
 	ret = slab_alloc(s, flags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-				  size, s->size, flags, node);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
+			      size, s->size, flags, node);
 
 	return ret;
 }
@@ -2798,7 +2798,7 @@ void kfree(const void *x)
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
+	trace_kmemtrace_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3272,8 +3272,8 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	ret = slab_alloc(s, gfpflags, -1, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
-			     s->size, gfpflags);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
+			      s->size, gfpflags, -1);
 
 	return ret;
 }
@@ -3295,8 +3295,8 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	ret = slab_alloc(s, gfpflags, node, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, caller, ret,
-				  size, s->size, gfpflags, node);
+	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret,
+			      size, s->size, gfpflags, node);
 
 	return ret;
 }
-- 
1.6.0.6

