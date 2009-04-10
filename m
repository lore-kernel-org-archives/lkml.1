Return-Path: <linux-kernel-owner+w=401wt.eu-S937665AbZDJG2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937665AbZDJG2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760808AbZDJG1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:27:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51231 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbZDJG1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:27:45 -0400
Message-ID: <49DEE6DA.80600@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 14:27:38 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tracepoint: Make kmem tracepoint use TRACE_EVENT macro
References: <49DEE68A.5040902@cn.fujitsu.com>
In-Reply-To: <49DEE68A.5040902@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRACE_EVENT is more unify and generic for define a tracepoint.
It also add ftrace support for this tracepoint.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/trace/kmem.h              |   39 +-------
 include/trace/kmem_event_types.h  |  193 +++++++++++++++++++++++++++++++++++++
 include/trace/trace_event_types.h |    1 +
 include/trace/trace_events.h      |    1 +
 4 files changed, 197 insertions(+), 37 deletions(-)
 create mode 100644 include/trace/kmem_event_types.h

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
-- 
1.5.5.3


