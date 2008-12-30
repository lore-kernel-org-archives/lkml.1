Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbYL3HmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbYL3HmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYL3Hlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:41:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:28742 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYL3Hlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=IdRJWhQaroXNsjVEBJr7zM85Ko76opbXRjdTR6KMUfndR69zWSqUAxi8RYI1rMpkd6
         dD8F7DDRgxcfu8U6Ab6xq0+l/OfATMCC/j9VYYGPXAM/n7arCtWBEiewCRZ/lrivauSm
         4pjkxlQa9eNoQflEykcknLvSkArcBfnt/ABYY=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kmemtrace: Use tracepoints instead of markers.
Date: Tue, 30 Dec 2008 09:41:28 +0200
Message-Id: <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro>
 <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1230622068.git.eduard.munteanu@linux360.ro>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemtrace now uses tracepoints instead of markers. We no longer need to
use format specifiers. Also dropped kmemtrace_mark_alloc_node(), since
it's easy to pass -1 as the NUMA node without providing a needless and
long-named variant of the same function.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/kmemtrace.h |   91 ++++++++++++-------------------------------
 include/linux/slab_def.h  |    9 ++--
 include/linux/slub_def.h  |   12 ++----
 lib/Kconfig.debug         |    2 +-
 mm/kmemtrace.c            |   96 ++++++++++++++++++++++++++++++++------------
 mm/slab.c                 |   25 ++++++------
 mm/slob.c                 |   27 +++++-------
 mm/slub.c                 |   30 ++++++--------
 8 files changed, 139 insertions(+), 153 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
index 5bea8ea..b0af88d 100644
--- a/include/linux/kmemtrace.h
+++ b/include/linux/kmemtrace.h
@@ -9,76 +9,35 @@
 
 #ifdef __KERNEL__
 
+#include <linux/tracepoint.h>
 #include <linux/types.h>
-#include <linux/marker.h>
-
-enum kmemtrace_type_id {
-	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
-	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
-	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
-};
-
-#ifdef CONFIG_KMEMTRACE
 
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
+DEFINE_TRACE(kmalloc,
+	     TPPROTO(unsigned long call_site,
+		     const void *ptr,
+		     size_t bytes_req,
+		     size_t bytes_alloc,
+		     gfp_t gfp_flags,
+		     int node),
+	     TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DEFINE_TRACE(kmem_cache_alloc,
+	     TPPROTO(unsigned long call_site,
+		     const void *ptr,
+		     size_t bytes_req,
+		     size_t bytes_alloc,
+		     gfp_t gfp_flags,
+		     int node),
+	     TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DEFINE_TRACE(kfree,
+	     TPPROTO(unsigned long call_site,
+		     const void *ptr),
+	     TPARGS(call_site, ptr));
+DEFINE_TRACE(kmem_cache_free,
+	     TPPROTO(unsigned long call_site,
+		     const void *ptr),
+	     TPARGS(call_site, ptr));
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 7555ce9..fe3cea2 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -76,8 +76,8 @@ found:
 
 		ret = kmem_cache_alloc_notrace(cachep, flags);
 
-		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-				     size, slab_buffer_size(cachep), flags);
+		trace_kmalloc(_THIS_IP_, ret,
+			      size, slab_buffer_size(cachep), flags, -1);
 
 		return ret;
 	}
@@ -134,9 +134,8 @@ found:
 
 		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
-					  ret, size, slab_buffer_size(cachep),
-					  flags, node);
+		trace_kmalloc(_THIS_IP_, ret,
+			      size, slab_buffer_size(cachep), flags, node);
 
 		return ret;
 	}
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index dc28432..4654f14 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -220,8 +220,7 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 	unsigned int order = get_order(size);
 	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-			     size, PAGE_SIZE << order, flags);
+	trace_kmalloc(_THIS_IP_, ret, size, PAGE_SIZE << order, flags, -1);
 
 	return ret;
 }
@@ -242,9 +241,8 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 
 			ret = kmem_cache_alloc_notrace(s, flags);
 
-			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-					     _THIS_IP_, ret,
-					     size, s->size, flags);
+			trace_kmalloc(_THIS_IP_, ret,
+				      size, s->size, flags, -1);
 
 			return ret;
 		}
@@ -283,9 +281,7 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 
 		ret = kmem_cache_alloc_node_notrace(s, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _THIS_IP_, ret,
-					  size, s->size, flags, node);
+		trace_kmalloc(_THIS_IP_, ret, size, s->size, flags, node);
 
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
index 2a70a80..1ff94e0 100644
--- a/mm/kmemtrace.c
+++ b/mm/kmemtrace.c
@@ -42,6 +42,12 @@ enum kmemtrace_event_id {
 	KMEMTRACE_EVENT_FREE,
 };
 
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
+};
+
 struct kmemtrace_event {
 	u8		event_id;
 	u8		type_id;
@@ -58,8 +64,13 @@ struct kmemtrace_stats_alloc {
 	s32		numa_node;
 } __attribute__ ((__packed__));
 
-static void kmemtrace_probe_alloc(void *probe_data, void *call_data,
-				  const char *format, va_list *args)
+static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
+				   unsigned long call_site,
+				   const void *ptr,
+				   size_t bytes_req,
+				   size_t bytes_alloc,
+				   gfp_t gfp_flags,
+				   int node)
 {
 	unsigned long flags;
 	struct kmemtrace_event *ev;
@@ -81,25 +92,26 @@ static void kmemtrace_probe_alloc(void *probe_data, void *call_data,
 
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
+static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
+				  unsigned long call_site,
+				  const void *ptr)
 {
 	unsigned long flags;
 	struct kmemtrace_event *ev;
@@ -115,16 +127,48 @@ static void kmemtrace_probe_free(void *probe_data, void *call_data,
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
 }
 
+static void kmemtrace_kmalloc(unsigned long call_site,
+			      const void *ptr,
+			      size_t bytes_req,
+			      size_t bytes_alloc,
+			      gfp_t gfp_flags,
+			      int node)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, node);
+}
+
+static void kmemtrace_kmem_cache_alloc(unsigned long call_site,
+				       const void *ptr,
+				       size_t bytes_req,
+				       size_t bytes_alloc,
+				       gfp_t gfp_flags,
+				       int node)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, node);
+}
+
+static void kmemtrace_kfree(unsigned long call_site, const void *ptr)
+{
+	kmemtrace_free(KMEMTRACE_TYPE_KMALLOC, call_site, ptr);
+}
+
+static void kmemtrace_kmem_cache_free(unsigned long call_site, const void *ptr)
+{
+	kmemtrace_free(KMEMTRACE_TYPE_CACHE, call_site, ptr);
+}
+
 static struct dentry *
 kmemtrace_create_buf_file(const char *filename, struct dentry *parent,
 			  int mode, struct rchan_buf *buf, int *is_global)
@@ -173,26 +217,26 @@ static int kmemtrace_start_probes(void)
 {
 	int err;
 
-	err = marker_probe_register("kmemtrace_alloc", "type_id %d "
-				    "call_site %lu ptr %lu "
-				    "bytes_req %lu bytes_alloc %lu "
-				    "gfp_flags %lu node %d",
-				    kmemtrace_probe_alloc, NULL);
+	err = register_trace_kmalloc(kmemtrace_kmalloc);
+	if (err)
+		return err;
+	err = register_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	if (err)
+		return err;
+	err = register_trace_kfree(kmemtrace_kfree);
 	if (err)
 		return err;
-	err = marker_probe_register("kmemtrace_free", "type_id %d "
-				    "call_site %lu ptr %lu",
-				    kmemtrace_probe_free, NULL);
+	err = register_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
 
 	return err;
 }
 
 static void kmemtrace_stop_probes(void)
 {
-	marker_probe_unregister("kmemtrace_alloc",
-				kmemtrace_probe_alloc, NULL);
-	marker_probe_unregister("kmemtrace_free",
-				kmemtrace_probe_free, NULL);
+	unregister_trace_kmalloc(kmemtrace_kmalloc);
+	unregister_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	unregister_trace_kfree(kmemtrace_kfree);
+	unregister_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
 }
 
 static int kmemtrace_enabled_get(void *data, u64 *val)
diff --git a/mm/slab.c b/mm/slab.c
index 1fcb32b..505e731 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3624,8 +3624,9 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     obj_size(cachep), cachep->buffer_size, flags);
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       obj_size(cachep), cachep->buffer_size,
+			       flags, -1);
 
 	return ret;
 }
@@ -3686,9 +3687,9 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	void *ret = __cache_alloc_node(cachep, flags, nodeid,
 				       __builtin_return_address(0));
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  obj_size(cachep), cachep->buffer_size,
-				  flags, nodeid);
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       obj_size(cachep), cachep->buffer_size,
+			       flags, nodeid);
 
 	return ret;
 }
@@ -3716,9 +3717,8 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 		return cachep;
 	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-				  (unsigned long) caller, ret,
-				  size, cachep->buffer_size, flags, node);
+	trace_kmalloc((unsigned long) caller, ret,
+		      size, cachep->buffer_size, flags, node);
 
 	return ret;
 }
@@ -3768,9 +3768,8 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 		return cachep;
 	ret = __cache_alloc(cachep, flags, caller);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-			     (unsigned long) caller, ret,
-			     size, cachep->buffer_size, flags);
+	trace_kmalloc((unsigned long) caller, ret,
+		      size, cachep->buffer_size, flags, -1);
 
 	return ret;
 }
@@ -3816,7 +3815,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	__cache_free(cachep, objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
+	trace_kmem_cache_free(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3844,7 +3843,7 @@ void kfree(const void *objp)
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
+	trace_kfree(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index 0f1a49f..5b55452 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -477,9 +477,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		*m = size;
 		ret = (void *)m + align;
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, size + align, gfp, node);
+		trace_kmalloc(_RET_IP_, ret, size, size + align, gfp, node);
 	} else {
 		unsigned int order = get_order(size);
 
@@ -490,9 +488,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			page->private = size;
 		}
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << order, gfp, node);
+		trace_kmalloc(_RET_IP_, ret,
+			      size, PAGE_SIZE << order, gfp, node);
 	}
 
 	return ret;
@@ -514,7 +511,7 @@ void kfree(const void *block)
 	} else
 		put_page(&sp->page);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
+	trace_kfree(_RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -585,16 +582,14 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  SLOB_UNITS(c->size) * SLOB_UNIT,
-					  flags, node);
+		trace_kmem_cache_alloc(_RET_IP_, b, c->size,
+				       SLOB_UNITS(c->size) * SLOB_UNIT,
+				       flags, node);
 	} else {
 		b = slob_new_page(flags, get_order(c->size), node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  PAGE_SIZE << get_order(c->size),
-					  flags, node);
+		trace_kmem_cache_alloc(_RET_IP_, b, c->size,
+				       PAGE_SIZE << get_order(c->size),
+				       flags, node);
 	}
 
 	if (c->ctor)
@@ -632,7 +627,7 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		__kmem_cache_free(b, c->size);
 	}
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
+	trace_kmem_cache_free(_RET_IP_, b);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index f756915..bd25817 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1620,8 +1620,8 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
 	void *ret = slab_alloc(s, gfpflags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     s->objsize, s->size, gfpflags);
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       s->objsize, s->size, gfpflags, -1);
 
 	return ret;
 }
@@ -1640,8 +1640,8 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
 	void *ret = slab_alloc(s, gfpflags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  s->objsize, s->size, gfpflags, node);
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       s->objsize, s->size, gfpflags, node);
 
 	return ret;
 }
@@ -1766,7 +1766,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	slab_free(s, page, x, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
+	trace_kmem_cache_free(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2694,8 +2694,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 
 	ret = slab_alloc(s, flags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-			     size, s->size, flags);
+	trace_kmalloc(_RET_IP_, ret, size, s->size, flags, -1);
 
 	return ret;
 }
@@ -2721,10 +2720,8 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(size > PAGE_SIZE)) {
 		ret = kmalloc_large_node(size, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << get_order(size),
-					  flags, node);
+		trace_kmalloc(_RET_IP_, ret,
+			      size, PAGE_SIZE << get_order(size), flags, node);
 
 		return ret;
 	}
@@ -2736,8 +2733,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 
 	ret = slab_alloc(s, flags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-				  size, s->size, flags, node);
+	trace_kmalloc(_RET_IP_, ret, size, s->size, flags, node);
 
 	return ret;
 }
@@ -2798,7 +2794,7 @@ void kfree(const void *x)
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
+	trace_kfree(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3272,8 +3268,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	ret = slab_alloc(s, gfpflags, -1, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
-			     s->size, gfpflags);
+	trace_kmalloc(caller, ret, size, s->size, gfpflags, -1);
 
 	return ret;
 }
@@ -3295,8 +3290,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	ret = slab_alloc(s, gfpflags, node, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, caller, ret,
-				  size, s->size, gfpflags, node);
+	trace_kmalloc(caller, ret, size, s->size, gfpflags, node);
 
 	return ret;
 }
-- 
1.6.0.6

