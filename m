Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbZKZIoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbZKZIoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbZKZIoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:44:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:58722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759806AbZKZIoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:44:07 -0500
Date: Thu, 26 Nov 2009 08:42:49 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, mel@csn.ul.ie,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi, mel@csn.ul.ie,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B0E286A.2000405@cn.fujitsu.com>
References: <4B0E286A.2000405@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert some kmem events to DEFINE_EVENT
Message-ID: <tip-53d0422c2d10808fddb2c30859193bfea164c7e3@git.kernel.org>
Git-Commit-ID: 53d0422c2d10808fddb2c30859193bfea164c7e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53d0422c2d10808fddb2c30859193bfea164c7e3
Gitweb:     http://git.kernel.org/tip/53d0422c2d10808fddb2c30859193bfea164c7e3
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:04:10 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:02 +0100

tracing: Convert some kmem events to DEFINE_EVENT

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
 333987   69800   27228  431015   693a7 mm/built-in.o.old
 330030   69800   27228  427058   68432 mm/built-in.o

8 events are converted:

  kmem_alloc: kmalloc, kmem_cache_alloc
  kmem_alloc_node: kmalloc_node, kmem_cache_alloc_node
  kmem_free: kfree, kmem_cache_free
  mm_page: mm_page_alloc_zone_locked, mm_page_pcpu_drain

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
LKML-Reference: <4B0E286A.2000405@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/kmem.h |  130 +++++++++++++-----------------------------
 mm/page_alloc.c             |    4 +-
 mm/util.c                   |    3 -
 3 files changed, 43 insertions(+), 94 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index eaf46bd..3adca0c 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -44,7 +44,7 @@
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
 	) : "GFP_NOWAIT"
 
-TRACE_EVENT(kmalloc,
+DECLARE_EVENT_CLASS(kmem_alloc,
 
 	TP_PROTO(unsigned long call_site,
 		 const void *ptr,
@@ -78,41 +78,23 @@ TRACE_EVENT(kmalloc,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
-TRACE_EVENT(kmem_cache_alloc,
+DEFINE_EVENT(kmem_alloc, kmalloc,
 
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags),
+	TP_PROTO(unsigned long call_site, const void *ptr,
+		 size_t bytes_req, size_t bytes_alloc, gfp_t gfp_flags),
 
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags)
+);
 
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-	),
+DEFINE_EVENT(kmem_alloc, kmem_cache_alloc,
 
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-	),
+	TP_PROTO(unsigned long call_site, const void *ptr,
+		 size_t bytes_req, size_t bytes_alloc, gfp_t gfp_flags),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		show_gfp_flags(__entry->gfp_flags))
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags)
 );
 
-TRACE_EVENT(kmalloc_node,
+DECLARE_EVENT_CLASS(kmem_alloc_node,
 
 	TP_PROTO(unsigned long call_site,
 		 const void *ptr,
@@ -150,45 +132,25 @@ TRACE_EVENT(kmalloc_node,
 		__entry->node)
 );
 
-TRACE_EVENT(kmem_cache_alloc_node,
+DEFINE_EVENT(kmem_alloc_node, kmalloc_node,
 
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags,
-		 int node),
+	TP_PROTO(unsigned long call_site, const void *ptr,
+		 size_t bytes_req, size_t bytes_alloc,
+		 gfp_t gfp_flags, int node),
 
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node)
+);
 
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-		__field(	int,		node		)
-	),
+DEFINE_EVENT(kmem_alloc_node, kmem_cache_alloc_node,
 
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-		__entry->node		= node;
-	),
+	TP_PROTO(unsigned long call_site, const void *ptr,
+		 size_t bytes_req, size_t bytes_alloc,
+		 gfp_t gfp_flags, int node),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		show_gfp_flags(__entry->gfp_flags),
-		__entry->node)
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node)
 );
 
-TRACE_EVENT(kfree,
+DECLARE_EVENT_CLASS(kmem_free,
 
 	TP_PROTO(unsigned long call_site, const void *ptr),
 
@@ -207,23 +169,18 @@ TRACE_EVENT(kfree,
 	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
 );
 
-TRACE_EVENT(kmem_cache_free,
+DEFINE_EVENT(kmem_free, kfree,
 
 	TP_PROTO(unsigned long call_site, const void *ptr),
 
-	TP_ARGS(call_site, ptr),
+	TP_ARGS(call_site, ptr)
+);
 
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-	),
+DEFINE_EVENT(kmem_free, kmem_cache_free,
 
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-	),
+	TP_PROTO(unsigned long call_site, const void *ptr),
 
-	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+	TP_ARGS(call_site, ptr)
 );
 
 TRACE_EVENT(mm_page_free_direct,
@@ -299,7 +256,7 @@ TRACE_EVENT(mm_page_alloc,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
-TRACE_EVENT(mm_page_alloc_zone_locked,
+DECLARE_EVENT_CLASS(mm_page,
 
 	TP_PROTO(struct page *page, unsigned int order, int migratetype),
 
@@ -325,29 +282,22 @@ TRACE_EVENT(mm_page_alloc_zone_locked,
 		__entry->order == 0)
 );
 
-TRACE_EVENT(mm_page_pcpu_drain,
+DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
 
-	TP_PROTO(struct page *page, int order, int migratetype),
+	TP_PROTO(struct page *page, unsigned int order, int migratetype),
 
-	TP_ARGS(page, order, migratetype),
+	TP_ARGS(page, order, migratetype)
+);
 
-	TP_STRUCT__entry(
-		__field(	struct page *,	page		)
-		__field(	int,		order		)
-		__field(	int,		migratetype	)
-	),
+DEFINE_EVENT_PRINT(mm_page, mm_page_pcpu_drain,
 
-	TP_fast_assign(
-		__entry->page		= page;
-		__entry->order		= order;
-		__entry->migratetype	= migratetype;
-	),
+	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype),
 
 	TP_printk("page=%p pfn=%lu order=%d migratetype=%d",
-		__entry->page,
-		page_to_pfn(__entry->page),
-		__entry->order,
-		__entry->migratetype)
+		__entry->page, page_to_pfn(__entry->page),
+		__entry->order, __entry->migratetype)
 );
 
 TRACE_EVENT(mm_page_alloc_extfrag,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bc2ac6..bdb22f5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -48,12 +48,14 @@
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
-#include <trace/events/kmem.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/kmem.h>
+
 /*
  * Array of node states.
  */
diff --git a/mm/util.c b/mm/util.c
index 7c35ad9..15d1975 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -6,9 +6,6 @@
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/kmem.h>
-
 /**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
