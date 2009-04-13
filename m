Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZDMWX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZDMWX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZDMWXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:23:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbZDMWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:23:21 -0400
Date: Mon, 13 Apr 2009 22:22:10 GMT
From: tip-bot for Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, penberg@cs.helsinki.fi, zhaolei@cn.fujitsu.com,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DEE6DA.80600@cn.fujitsu.com>
References: <49DEE6DA.80600@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing, kmemtrace: Make kmem tracepoints use TRACE_EVENT macro
Message-ID: <tip-fc182a4330fc22ea1b68fa3d5064dd85a73a4c4a@git.kernel.org>
Git-Commit-ID: fc182a4330fc22ea1b68fa3d5064dd85a73a4c4a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 22:22:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc182a4330fc22ea1b68fa3d5064dd85a73a4c4a
Gitweb:     http://git.kernel.org/tip/fc182a4330fc22ea1b68fa3d5064dd85a73a4c4a
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 10 Apr 2009 14:27:38 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 15:22:56 +0200

tracing, kmemtrace: Make kmem tracepoints use TRACE_EVENT macro

TRACE_EVENT is a more generic way to define tracepoints.
Doing so adds these new capabilities to this tracepoint:

  - zero-copy and per-cpu splice() tracing
  - binary tracing without printf overhead
  - structured logging records exposed under /debug/tracing/events
  - trace events embedded in function tracer output and other plugins
  - user-defined, per tracepoint filter expressions

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <49DEE6DA.80600@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/kmem.h              |   39 +-------
 include/trace/kmem_event_types.h  |  193 +++++++++++++++++++++++++++++++++++++
 include/trace/trace_event_types.h |    1 +
 include/trace/trace_events.h      |    1 +
 4 files changed, 197 insertions(+), 37 deletions(-)

diff --git a/include/trace/kmem.h b/include/trace/kmem.h
index 24d2519..46efc24 100644
--- a/include/trace/kmem.h
+++ b/include/trace/kmem.h
@@ -1,44 +1,9 @@
 #ifndef _TRACE_KMEM_H
 #define _TRACE_KMEM_H
 
-#include <linux/tracepoint.h>
 #include <linux/types.h>
+#include <linux/tracepoint.h>
 
-DECLARE_TRACE(kmalloc,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
-DECLARE_TRACE(kmem_cache_alloc,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
-DECLARE_TRACE(kmalloc_node,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags,
-		      int node),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
-DECLARE_TRACE(kmem_cache_alloc_node,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags,
-		      int node),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
-DECLARE_TRACE(kfree,
-	      TP_PROTO(unsigned long call_site, const void *ptr),
-	      TP_ARGS(call_site, ptr));
-DECLARE_TRACE(kmem_cache_free,
-	      TP_PROTO(unsigned long call_site, const void *ptr),
-	      TP_ARGS(call_site, ptr));
+#include <trace/kmem_event_types.h>
 
 #endif /* _TRACE_KMEM_H */
diff --git a/include/trace/kmem_event_types.h b/include/trace/kmem_event_types.h
new file mode 100644
index 0000000..4ff420f
--- /dev/null
+++ b/include/trace/kmem_event_types.h
@@ -0,0 +1,193 @@
+
+/* use <trace/kmem.h> instead */
+#ifndef TRACE_EVENT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kmem
+
+TRACE_EVENT(kmalloc,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags)
+);
+
+TRACE_EVENT(kmem_cache_alloc,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags)
+);
+
+TRACE_EVENT(kmalloc_node,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags,
+		 int node),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		node		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->node		= node;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags,
+		__entry->node)
+);
+
+TRACE_EVENT(kmem_cache_alloc_node,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags,
+		 int node),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		node		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->node		= node;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags,
+		__entry->node)
+);
+
+TRACE_EVENT(kfree,
+
+	TP_PROTO(unsigned long call_site, const void *ptr),
+
+	TP_ARGS(call_site, ptr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+	),
+
+	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+);
+
+TRACE_EVENT(kmem_cache_free,
+
+	TP_PROTO(unsigned long call_site, const void *ptr),
+
+	TP_ARGS(call_site, ptr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+	),
+
+	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+);
+
+#undef TRACE_SYSTEM
diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
index 33b6bfc..552a50e 100644
--- a/include/trace/trace_event_types.h
+++ b/include/trace/trace_event_types.h
@@ -4,3 +4,4 @@
 #include <trace/irq_event_types.h>
 #include <trace/lockdep_event_types.h>
 #include <trace/skb_event_types.h>
+#include <trace/kmem_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 0e2aa80..13d6b85 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -4,3 +4,4 @@
 #include <trace/irq.h>
 #include <trace/lockdep.h>
 #include <trace/skb.h>
+#include <trace/kmem.h>
