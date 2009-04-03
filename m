Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbZDCKl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbZDCKl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764137AbZDCKia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:38:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:42987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764114AbZDCKi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:38:26 -0400
Date: Fri, 3 Apr 2009 10:36:45 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
References: <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace-v2] kmemtrace: use tracepoints
Message-ID: <tip-ca2b84cb3c4a0d4d2143b46ec072cdff5d1b3b87@git.kernel.org>
Git-Commit-ID: ca2b84cb3c4a0d4d2143b46ec072cdff5d1b3b87
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:36:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca2b84cb3c4a0d4d2143b46ec072cdff5d1b3b87
Gitweb:     http://git.kernel.org/tip/ca2b84cb3c4a0d4d2143b46ec072cdff5d1b3b87
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:23:06 +0200

kmemtrace: use tracepoints

kmemtrace now uses tracepoints instead of markers. We no longer need to
use format specifiers to pass arguments.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
[ folded: Use the new TP_PROTO and TP_ARGS to fix the build.     ]
[ folded: fix build when CONFIG_KMEMTRACE is disabled.           ]
[ folded: define tracepoints when CONFIG_TRACEPOINTS is enabled. ]
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/slab_def.h  |   10 +-
 include/linux/slub_def.h  |   12 +--
 include/trace/kmemtrace.h |   92 +++++++++-----------
 kernel/trace/kmemtrace.c  |  206 +++++++++++++++++++++++++++++++-------------
 kernel/trace/trace.h      |    6 ++
 mm/slab.c                 |   24 +++---
 mm/slob.c                 |   28 +++----
 mm/slub.c                 |   30 +++----
 mm/util.c                 |   16 ++++
 9 files changed, 251 insertions(+), 173 deletions(-)

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
index a1f9052..5046f90 100644
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
index ad8b785..28ee69f 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmemtrace.h
@@ -9,65 +9,53 @@
 
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
 
 #ifdef CONFIG_KMEMTRACE
-
 extern void kmemtrace_init(void);
-
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
+#else
 static inline void kmemtrace_init(void)
 {
 }
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
+#endif
+
+DECLARE_TRACE(kmalloc,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmem_cache_alloc,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmalloc_node,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kmem_cache_alloc_node,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kfree,
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
+DECLARE_TRACE(kmem_cache_free,
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
 
 #endif /* __KERNEL__ */
 
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index ae201b3..4f7b5db 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -10,6 +10,7 @@
 #include <linux/debugfs.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/tracepoint.h>
 #include <trace/kmemtrace.h>
 
 #include "trace.h"
@@ -29,10 +30,150 @@ static struct tracer_flags kmem_tracer_flags = {
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
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
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
+	ring_buffer_unlock_commit(tr->buffer, event);
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
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
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
+	ring_buffer_unlock_commit(tr->buffer, event);
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
@@ -41,14 +182,14 @@ static int kmem_trace_init(struct trace_array *tr)
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
@@ -260,63 +401,6 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
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
index cb0ce3f..cbc168f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -182,6 +182,12 @@ struct trace_power {
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
index 9ec66c3..fa00fd6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3565,8 +3565,8 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     obj_size(cachep), cachep->buffer_size, flags);
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       obj_size(cachep), cachep->buffer_size, flags);
 
 	return ret;
 }
@@ -3627,9 +3627,9 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
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
@@ -3657,9 +3657,8 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 		return cachep;
 	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-				  (unsigned long) caller, ret,
-				  size, cachep->buffer_size, flags, node);
+	trace_kmalloc_node((unsigned long) caller, ret,
+			   size, cachep->buffer_size, flags, node);
 
 	return ret;
 }
@@ -3709,9 +3708,8 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 		return cachep;
 	ret = __cache_alloc(cachep, flags, caller);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-			     (unsigned long) caller, ret,
-			     size, cachep->buffer_size, flags);
+	trace_kmalloc((unsigned long) caller, ret,
+		      size, cachep->buffer_size, flags);
 
 	return ret;
 }
@@ -3757,7 +3755,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	__cache_free(cachep, objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
+	trace_kmem_cache_free(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3785,7 +3783,7 @@ void kfree(const void *objp)
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
+	trace_kfree(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index 4dd6516..0000358 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -490,9 +490,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		*m = size;
 		ret = (void *)m + align;
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, size + align, gfp, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, size + align, gfp, node);
 	} else {
 		unsigned int order = get_order(size);
 
@@ -503,9 +502,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			page->private = size;
 		}
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << order, gfp, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, PAGE_SIZE << order, gfp, node);
 	}
 
 	return ret;
@@ -527,7 +525,7 @@ void kfree(const void *block)
 	} else
 		put_page(&sp->page);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
+	trace_kfree(_RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -599,16 +597,14 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
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
 		b = slob_new_pages(flags, get_order(c->size), node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  PAGE_SIZE << get_order(c->size),
-					  flags, node);
+		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
+					    PAGE_SIZE << get_order(c->size),
+					    flags, node);
 	}
 
 	if (c->ctor)
@@ -646,7 +642,7 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		__kmem_cache_free(b, c->size);
 	}
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
+	trace_kmem_cache_free(_RET_IP_, b);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index 7aaa121..a98078b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1621,8 +1621,7 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
 	void *ret = slab_alloc(s, gfpflags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     s->objsize, s->size, gfpflags);
+	trace_kmem_cache_alloc(_RET_IP_, ret, s->objsize, s->size, gfpflags);
 
 	return ret;
 }
@@ -1641,8 +1640,8 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
 	void *ret = slab_alloc(s, gfpflags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  s->objsize, s->size, gfpflags, node);
+	trace_kmem_cache_alloc_node(_RET_IP_, ret,
+				    s->objsize, s->size, gfpflags, node);
 
 	return ret;
 }
@@ -1767,7 +1766,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	slab_free(s, page, x, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
+	trace_kmem_cache_free(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2702,8 +2701,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 
 	ret = slab_alloc(s, flags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-			     size, s->size, flags);
+	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
 
 	return ret;
 }
@@ -2729,10 +2727,9 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
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
@@ -2744,8 +2741,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 
 	ret = slab_alloc(s, flags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-				  size, s->size, flags, node);
+	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
 
 	return ret;
 }
@@ -2807,7 +2803,7 @@ void kfree(const void *x)
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
+	trace_kfree(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3290,8 +3286,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	ret = slab_alloc(s, gfpflags, -1, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
-			     s->size, gfpflags);
+	trace_kmalloc(caller, ret, size, s->size, gfpflags);
 
 	return ret;
 }
@@ -3313,8 +3308,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	ret = slab_alloc(s, gfpflags, node, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, caller, ret,
-				  size, s->size, gfpflags, node);
+	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
 
 	return ret;
 }
diff --git a/mm/util.c b/mm/util.c
index 7c122e4..2599e83 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/sched.h>
+#include <linux/tracepoint.h>
 #include <asm/uaccess.h>
 
 /**
@@ -236,3 +237,18 @@ int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
+
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
