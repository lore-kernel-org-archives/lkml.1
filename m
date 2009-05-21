Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZEUDR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZEUDR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZEUDRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:17:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbZEUDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:17:49 -0400
Message-Id: <20090521031749.185721131@goodmis.org>
References: <20090521031711.494593605@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 23:17:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 3/5] tracing: add flag output for kmem events
Content-Disposition: inline; filename=0003-tracing-add-flag-output-for-kmem-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch changes the output for gfp_flags from being a simple hex value
to the actual names.

  gfp_flags=GFP_ATOMIC  instead of gfp_flags=00000020

And even

  gfp_flags=GFP_KERNEL instead of gfp_flags=000000d0

(Thanks to Frederic Weisbecker for pointing out that the first version
 had a bad order of GFP masks)

[ Impact: more human readable output from tracer ]

Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/kmem.h |   53 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index c22c42f..9baba50 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -7,6 +7,43 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kmem
 
+/*
+ * The order of these masks is important. Matching masks will be seen
+ * first and the left over flags will end up showing by themselves.
+ *
+ * For example, if we have GFP_KERNEL before GFP_USER we wil get:
+ *
+ *  GFP_KERNEL|GFP_HARDWALL
+ *
+ * Thus most bits set go first.
+ */
+#define show_gfp_flags(flags)						\
+	(flags) ? __print_flags(flags, "|",				\
+	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
+	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
+	{(unsigned long)GFP_USER,		"GFP_USER"},		\
+	{(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY"},	\
+	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
+	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
+	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
+	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
+	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
+	{(unsigned long)__GFP_WAIT,		"GFP_WAIT"},		\
+	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
+	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
+	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
+	{(unsigned long)__GFP_REPEAT,		"GFP_REPEAT"},		\
+	{(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL"},		\
+	{(unsigned long)__GFP_NORETRY,		"GFP_NORETRY"},		\
+	{(unsigned long)__GFP_COMP,		"GFP_COMP"},		\
+	{(unsigned long)__GFP_ZERO,		"GFP_ZERO"},		\
+	{(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC"},	\
+	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
+	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
+	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
+	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
+	) : "GFP_NOWAIT"
+
 TRACE_EVENT(kmalloc,
 
 	TP_PROTO(unsigned long call_site,
@@ -33,12 +70,12 @@ TRACE_EVENT(kmalloc,
 		__entry->gfp_flags	= gfp_flags;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
 		__entry->call_site,
 		__entry->ptr,
 		__entry->bytes_req,
 		__entry->bytes_alloc,
-		__entry->gfp_flags)
+		show_gfp_flags(__entry->gfp_flags))
 );
 
 TRACE_EVENT(kmem_cache_alloc,
@@ -67,12 +104,12 @@ TRACE_EVENT(kmem_cache_alloc,
 		__entry->gfp_flags	= gfp_flags;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
 		__entry->call_site,
 		__entry->ptr,
 		__entry->bytes_req,
 		__entry->bytes_alloc,
-		__entry->gfp_flags)
+		show_gfp_flags(__entry->gfp_flags))
 );
 
 TRACE_EVENT(kmalloc_node,
@@ -104,12 +141,12 @@ TRACE_EVENT(kmalloc_node,
 		__entry->node		= node;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
 		__entry->call_site,
 		__entry->ptr,
 		__entry->bytes_req,
 		__entry->bytes_alloc,
-		__entry->gfp_flags,
+		show_gfp_flags(__entry->gfp_flags),
 		__entry->node)
 );
 
@@ -142,12 +179,12 @@ TRACE_EVENT(kmem_cache_alloc_node,
 		__entry->node		= node;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
 		__entry->call_site,
 		__entry->ptr,
 		__entry->bytes_req,
 		__entry->bytes_alloc,
-		__entry->gfp_flags,
+		show_gfp_flags(__entry->gfp_flags),
 		__entry->node)
 );
 
-- 
1.6.2.4

-- 
