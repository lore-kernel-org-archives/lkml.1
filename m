Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZCWNN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZCWNN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZCWNMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:12:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:58743 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZCWNMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=s5y2mdNTmopmLJfGIjO8Gq9lZJJ5WAinyNgzbrFX5dPX8KNB/6UkEuN6wVgA1jSNnw
         +5awmtM2N6zZF7m3ghAyRqGqAM2G6Lltn1tltUdtlfHsabzgOjR0Yk97k7mN6XKkEDEW
         P+zCJ5JZPQN474T5MOZmfCnop5xaR53Ygws14=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] kmemtrace: use tracepoints
Date: Mon, 23 Mar 2009 15:12:24 +0200
Message-Id: <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
 <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
 <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
 <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemtrace now uses tracepoints instead of markers. We no longer need to
use format specifiers to pass arguments.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/slab_def.h  |   10 +-
 include/linux/slub_def.h  |   12 +--
 include/trace/kmemtrace.h |   92 ++++++++-----------
 kernel/trace/kmemtrace.c  |  225 +++++++++++++++++++++++++++++++++------------
 kernel/trace/trace.h      |    6 +
 mm/slab.c                 |   24 ++---
 mm/slob.c                 |   28 +++---
 mm/slub.c                 |   30 +++----
 8 files changed, 251 insertions(+), 176 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index f452365..5ac9b0b 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -73,8 +73,8 @@ found:
 
 		ret = kmem_cache_alloc_notrace(cachep, flags);
 
-		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-				     size, slab_buffer_size(cachep), flags);
+		trace_kmalloc(_THIS_IP_, ret,
+			      size, slab_buffer_size(cachep), flags);
 
 		return ret;
 	}
@@ -128,9 +128,9 @@ found:
 
 		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
-					  ret, size, slab_buffer_size(cachep),
-					  flags, node);
+		trace_kmalloc_node(_THIS_IP_, ret,
+				   size, slab_buffer_size(cachep),
+				   flags, node);
 
 		return ret;
 	}
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 9e3a575..83dd5ce 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -233,8 +233,7 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 	unsigned int order = get_order(size);
 	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-			     size, PAGE_SIZE << order, flags);
+	trace_kmalloc(_THIS_IP_, ret, size, PAGE_SIZE << order, flags);
 
 	return ret;
 }
@@ -255,9 +254,7 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 
 			ret = kmem_cache_alloc_notrace(s, flags);
 
-			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-					     _THIS_IP_, ret,
-					     size, s->size, flags);
+			trace_kmalloc(_THIS_IP_, ret, size, s->size, flags);
 
 			return ret;
 		}
@@ -296,9 +293,8 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 
 		ret = kmem_cache_alloc_node_notrace(s, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _THIS_IP_, ret,
-					  size, s->size, flags, node);
+		trace_kmalloc_node(_THIS_IP_, ret,
+				   size, s->size, flags, node);
 
 		return ret;
 	}
diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
index ad8b785..9e28ae1 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmemtrace.h
@@ -9,65 +9,47 @@
 
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
 
-extern void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-					     unsigned long call_site,
-					     const void *ptr,
-					     size_t bytes_req,
-					     size_t bytes_alloc,
-					     gfp_t gfp_flags,
-					     int node);
-
-extern void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-				       unsigned long call_site,
-				       const void *ptr);
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
+DECLARE_TRACE(kmalloc,
+	      TPPROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmem_cache_alloc,
+	      TPPROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmalloc_node,
+	      TPPROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kmem_cache_alloc_node,
+	      TPPROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kfree,
+	      TPPROTO(unsigned long call_site, const void *ptr),
+	      TPARGS(call_site, ptr));
+DECLARE_TRACE(kmem_cache_free,
+	      TPPROTO(unsigned long call_site, const void *ptr),
+	      TPARGS(call_site, ptr));
 
 #endif /* __KERNEL__ */
 
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index ae201b3..9e9327e 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -10,11 +10,27 @@
 #include <linux/debugfs.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/tracepoint.h>
 #include <trace/kmemtrace.h>
 
 #include "trace.h"
 #include "trace_output.h"
 
+/* Tracepoints definitions. */
+DEFINE_TRACE(kmalloc);
+DEFINE_TRACE(kmem_cache_alloc);
+DEFINE_TRACE(kmalloc_node);
+DEFINE_TRACE(kmem_cache_alloc_node);
+DEFINE_TRACE(kfree);
+DEFINE_TRACE(kmem_cache_free);
+
+EXPORT_TRACEPOINT_SYMBOL(kmalloc);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
+EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kfree);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
+
 /* Select an alternative, minimalistic output than the original one */
 #define TRACE_KMEM_OPT_MINIMAL	0x1
 
@@ -29,10 +45,154 @@ static struct tracer_flags kmem_tracer_flags = {
 	.opts = kmem_opts
 };
 
-
-static bool kmem_tracing_enabled __read_mostly;
 static struct trace_array *kmemtrace_array;
 
+/* Trace allocations */
+static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
+				   unsigned long call_site,
+				   const void *ptr,
+				   size_t bytes_req,
+				   size_t bytes_alloc,
+				   gfp_t gfp_flags,
+				   int node)
+{
+	struct ring_buffer_event *event;
+	struct kmemtrace_alloc_entry *entry;
+	struct trace_array *tr = kmemtrace_array;
+	unsigned long irq_flags;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type = TRACE_KMEM_ALLOC;
+	entry->call_site = call_site;
+	entry->ptr = ptr;
+	entry->bytes_req = bytes_req;
+	entry->bytes_alloc = bytes_alloc;
+	entry->gfp_flags = gfp_flags;
+	entry->node	=	node;
+
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
+static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
+				  unsigned long call_site,
+				  const void *ptr)
+{
+	struct ring_buffer_event *event;
+	struct kmemtrace_free_entry *entry;
+	struct trace_array *tr = kmemtrace_array;
+	unsigned long irq_flags;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type = TRACE_KMEM_FREE;
+	entry->type_id	= type_id;
+	entry->call_site = call_site;
+	entry->ptr = ptr;
+
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
+static void kmemtrace_kmalloc(unsigned long call_site,
+			      const void *ptr,
+			      size_t bytes_req,
+			      size_t bytes_alloc,
+			      gfp_t gfp_flags)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, -1);
+}
+
+static void kmemtrace_kmem_cache_alloc(unsigned long call_site,
+				       const void *ptr,
+				       size_t bytes_req,
+				       size_t bytes_alloc,
+				       gfp_t gfp_flags)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, -1);
+}
+
+static void kmemtrace_kmalloc_node(unsigned long call_site,
+				   const void *ptr,
+				   size_t bytes_req,
+				   size_t bytes_alloc,
+				   gfp_t gfp_flags,
+				   int node)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, node);
+}
+
+static void kmemtrace_kmem_cache_alloc_node(unsigned long call_site,
+					    const void *ptr,
+					    size_t bytes_req,
+					    size_t bytes_alloc,
+					    gfp_t gfp_flags,
+					    int node)
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
+static int kmemtrace_start_probes(void)
+{
+	int err;
+
+	err = register_trace_kmalloc(kmemtrace_kmalloc);
+	if (err)
+		return err;
+	err = register_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	if (err)
+		return err;
+	err = register_trace_kmalloc_node(kmemtrace_kmalloc_node);
+	if (err)
+		return err;
+	err = register_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
+	if (err)
+		return err;
+	err = register_trace_kfree(kmemtrace_kfree);
+	if (err)
+		return err;
+	err = register_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+
+	return err;
+}
+
+static void kmemtrace_stop_probes(void)
+{
+	unregister_trace_kmalloc(kmemtrace_kmalloc);
+	unregister_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	unregister_trace_kmalloc_node(kmemtrace_kmalloc_node);
+	unregister_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
+	unregister_trace_kfree(kmemtrace_kfree);
+	unregister_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+}
+
 static int kmem_trace_init(struct trace_array *tr)
 {
 	int cpu;
@@ -41,14 +201,14 @@ static int kmem_trace_init(struct trace_array *tr)
 	for_each_cpu_mask(cpu, cpu_possible_map)
 		tracing_reset(tr, cpu);
 
-	kmem_tracing_enabled = true;
+	kmemtrace_start_probes();
 
 	return 0;
 }
 
 static void kmem_trace_reset(struct trace_array *tr)
 {
-	kmem_tracing_enabled = false;
+	kmemtrace_stop_probes();
 }
 
 static void kmemtrace_headers(struct seq_file *s)
@@ -260,63 +420,6 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 	}
 }
 
-/* Trace allocations */
-void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-			     unsigned long call_site,
-			     const void *ptr,
-			     size_t bytes_req,
-			     size_t bytes_alloc,
-			     gfp_t gfp_flags,
-			     int node)
-{
-	struct ring_buffer_event *event;
-	struct kmemtrace_alloc_entry *entry;
-	struct trace_array *tr = kmemtrace_array;
-
-	if (!kmem_tracing_enabled)
-		return;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_KMEM_ALLOC,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-
-	entry->call_site = call_site;
-	entry->ptr = ptr;
-	entry->bytes_req = bytes_req;
-	entry->bytes_alloc = bytes_alloc;
-	entry->gfp_flags = gfp_flags;
-	entry->node	=	node;
-
-	trace_buffer_unlock_commit(tr, event, 0, 0);
-}
-EXPORT_SYMBOL(kmemtrace_mark_alloc_node);
-
-void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-		       unsigned long call_site,
-		       const void *ptr)
-{
-	struct ring_buffer_event *event;
-	struct kmemtrace_free_entry *entry;
-	struct trace_array *tr = kmemtrace_array;
-
-	if (!kmem_tracing_enabled)
-		return;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_KMEM_FREE,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->type_id	= type_id;
-	entry->call_site = call_site;
-	entry->ptr = ptr;
-
-	trace_buffer_unlock_commit(tr, event, 0, 0);
-}
-EXPORT_SYMBOL(kmemtrace_mark_free);
-
 static struct tracer kmem_tracer __read_mostly = {
 	.name		= "kmemtrace",
 	.init		= kmem_trace_init,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index eed732c..1d532b9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -173,6 +173,12 @@ struct trace_power {
 	struct power_trace	state_data;
 };
 
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
+};
+
 struct kmemtrace_alloc_entry {
 	struct trace_entry	ent;
 	enum kmemtrace_type_id type_id;
diff --git a/mm/slab.c b/mm/slab.c
index aeeb4ec..86eceb7 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3561,8 +3561,8 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     obj_size(cachep), cachep->buffer_size, flags);
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       obj_size(cachep), cachep->buffer_size, flags);
 
 	return ret;
 }
@@ -3623,9 +3623,9 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	void *ret = __cache_alloc_node(cachep, flags, nodeid,
 				       __builtin_return_address(0));
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  obj_size(cachep), cachep->buffer_size,
-				  flags, nodeid);
+	trace_kmem_cache_alloc_node(_RET_IP_, ret,
+				    obj_size(cachep), cachep->buffer_size,
+				    flags, nodeid);
 
 	return ret;
 }
@@ -3653,9 +3653,8 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 		return cachep;
 	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-				  (unsigned long) caller, ret,
-				  size, cachep->buffer_size, flags, node);
+	trace_kmalloc_node((unsigned long) caller, ret,
+			   size, cachep->buffer_size, flags, node);
 
 	return ret;
 }
@@ -3705,9 +3704,8 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 		return cachep;
 	ret = __cache_alloc(cachep, flags, caller);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-			     (unsigned long) caller, ret,
-			     size, cachep->buffer_size, flags);
+	trace_kmalloc((unsigned long) caller, ret,
+		      size, cachep->buffer_size, flags);
 
 	return ret;
 }
@@ -3753,7 +3751,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	__cache_free(cachep, objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
+	trace_kmem_cache_free(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3781,7 +3779,7 @@ void kfree(const void *objp)
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
+	trace_kfree(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index f9cc246..8047600 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -477,9 +477,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		*m = size;
 		ret = (void *)m + align;
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, size + align, gfp, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, size + align, gfp, node);
 	} else {
 		unsigned int order = get_order(size);
 
@@ -490,9 +489,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			page->private = size;
 		}
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << order, gfp, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, PAGE_SIZE << order, gfp, node);
 	}
 
 	return ret;
@@ -514,7 +512,7 @@ void kfree(const void *block)
 	} else
 		put_page(&sp->page);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
+	trace_kfree(_RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -586,16 +584,14 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  SLOB_UNITS(c->size) * SLOB_UNIT,
-					  flags, node);
+		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
+					    SLOB_UNITS(c->size) * SLOB_UNIT,
+					    flags, node);
 	} else {
 		b = slob_new_page(flags, get_order(c->size), node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  PAGE_SIZE << get_order(c->size),
-					  flags, node);
+		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
+					    PAGE_SIZE << get_order(c->size),
+					    flags, node);
 	}
 
 	if (c->ctor)
@@ -633,7 +629,7 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		__kmem_cache_free(b, c->size);
 	}
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
+	trace_kmem_cache_free(_RET_IP_, b);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index 6de5e07..1479080 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1626,8 +1626,7 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
 	void *ret = slab_alloc(s, gfpflags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     s->objsize, s->size, gfpflags);
+	trace_kmem_cache_alloc(_RET_IP_, ret, s->objsize, s->size, gfpflags);
 
 	return ret;
 }
@@ -1646,8 +1645,8 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
 	void *ret = slab_alloc(s, gfpflags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  s->objsize, s->size, gfpflags, node);
+	trace_kmem_cache_alloc_node(_RET_IP_, ret,
+				    s->objsize, s->size, gfpflags, node);
 
 	return ret;
 }
@@ -1772,7 +1771,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	slab_free(s, page, x, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
+	trace_kmem_cache_free(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2700,8 +2699,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 
 	ret = slab_alloc(s, flags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-			     size, s->size, flags);
+	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
 
 	return ret;
 }
@@ -2727,10 +2725,9 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(size > SLUB_MAX_SIZE)) {
 		ret = kmalloc_large_node(size, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << get_order(size),
-					  flags, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, PAGE_SIZE << get_order(size),
+				   flags, node);
 
 		return ret;
 	}
@@ -2742,8 +2739,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 
 	ret = slab_alloc(s, flags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-				  size, s->size, flags, node);
+	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
 
 	return ret;
 }
@@ -2805,7 +2801,7 @@ void kfree(const void *x)
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
+	trace_kfree(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3288,8 +3284,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	ret = slab_alloc(s, gfpflags, -1, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
-			     s->size, gfpflags);
+	trace_kmalloc(caller, ret, size, s->size, gfpflags);
 
 	return ret;
 }
@@ -3311,8 +3306,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	ret = slab_alloc(s, gfpflags, node, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, caller, ret,
-				  size, s->size, gfpflags, node);
+	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
 
 	return ret;
 }
-- 
1.6.0.6

