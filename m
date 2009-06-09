Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZFIVzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZFIVzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbZFIVxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbZFIVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:38 -0400
Message-Id: <20090609215339.785773173@goodmis.org>
References: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 6/8] tracing/events: modify kmem print to new format
Content-Disposition: inline; filename=0006-tracing-events-modify-kmem-print-to-new-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use new format for better parsing of kmem events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/kmem.h |   98 +++++++++++++++++++-----------------------
 1 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 9baba50..5c8f942 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -17,32 +17,36 @@
  *
  * Thus most bits set go first.
  */
-#define show_gfp_flags(flags)						\
-	(flags) ? __print_flags(flags, "|",				\
-	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
-	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
-	{(unsigned long)GFP_USER,		"GFP_USER"},		\
-	{(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY"},	\
-	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
-	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
-	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
-	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
-	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
-	{(unsigned long)__GFP_WAIT,		"GFP_WAIT"},		\
-	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
-	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
-	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
-	{(unsigned long)__GFP_REPEAT,		"GFP_REPEAT"},		\
-	{(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL"},		\
-	{(unsigned long)__GFP_NORETRY,		"GFP_NORETRY"},		\
-	{(unsigned long)__GFP_COMP,		"GFP_COMP"},		\
-	{(unsigned long)__GFP_ZERO,		"GFP_ZERO"},		\
-	{(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC"},	\
-	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
-	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
-	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
-	) : "GFP_NOWAIT"
+#define show_gfp_flags_format()						\
+	"0=GFP_NOWAIT,"							\
+	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
+	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
+	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
+	"0x%lx=%s,0x%lx=%s>"
+#define show_gfp_flags_args()						\
+	(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE", \
+	(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER",		\
+	(unsigned long)GFP_USER,		"GFP_USER",		\
+	(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY",	\
+	(unsigned long)GFP_KERNEL,		"GFP_KERNEL",		\
+	(unsigned long)GFP_NOFS,		"GFP_NOFS",		\
+	(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC",		\
+	(unsigned long)GFP_NOIO,		"GFP_NOIO",		\
+	(unsigned long)__GFP_HIGH,		"GFP_HIGH",		\
+	(unsigned long)__GFP_WAIT,		"GFP_WAIT",		\
+	(unsigned long)__GFP_IO,		"GFP_IO",		\
+	(unsigned long)__GFP_COLD,		"GFP_COLD",		\
+	(unsigned long)__GFP_NOWARN,		"GFP_NOWARN",		\
+	(unsigned long)__GFP_REPEAT,		"GFP_REPEAT",		\
+	(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL",		\
+	(unsigned long)__GFP_NORETRY,		"GFP_NORETRY",		\
+	(unsigned long)__GFP_COMP,		"GFP_COMP",		\
+	(unsigned long)__GFP_ZERO,		"GFP_ZERO",		\
+	(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC",	\
+	(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL",		\
+	(unsigned long)__GFP_THISNODE,		"GFP_THISNODE",		\
+	(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE",	\
+	(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"
 
 TRACE_EVENT(kmalloc,
 
@@ -70,12 +74,9 @@ TRACE_EVENT(kmalloc,
 		__entry->gfp_flags	= gfp_flags;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		show_gfp_flags(__entry->gfp_flags))
+	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
+		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
+		  show_gfp_flags_format(), show_gfp_flags_args())
 );
 
 TRACE_EVENT(kmem_cache_alloc,
@@ -104,12 +105,9 @@ TRACE_EVENT(kmem_cache_alloc,
 		__entry->gfp_flags	= gfp_flags;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		show_gfp_flags(__entry->gfp_flags))
+	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
+		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
+		  show_gfp_flags_format(), show_gfp_flags_args())
 );
 
 TRACE_EVENT(kmalloc_node,
@@ -141,13 +139,9 @@ TRACE_EVENT(kmalloc_node,
 		__entry->node		= node;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		show_gfp_flags(__entry->gfp_flags),
-		__entry->node)
+	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
+		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
+		  show_gfp_flags_format() " node=<int:node>", show_gfp_flags_args())
 );
 
 TRACE_EVENT(kmem_cache_alloc_node,
@@ -179,13 +173,9 @@ TRACE_EVENT(kmem_cache_alloc_node,
 		__entry->node		= node;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		show_gfp_flags(__entry->gfp_flags),
-		__entry->node)
+	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
+		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
+		  show_gfp_flags_format() " node=<int:node>", show_gfp_flags_args())
 );
 
 TRACE_EVENT(kfree,
@@ -204,7 +194,7 @@ TRACE_EVENT(kfree,
 		__entry->ptr		= ptr;
 	),
 
-	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr>")
 );
 
 TRACE_EVENT(kmem_cache_free,
@@ -223,7 +213,7 @@ TRACE_EVENT(kmem_cache_free,
 		__entry->ptr		= ptr;
 	),
 
-	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr>")
 );
 #endif /* _TRACE_KMEM_H */
 
-- 
1.6.3.1

-- 
