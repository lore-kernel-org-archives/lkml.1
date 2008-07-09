Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYGIPDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYGIPDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbYGIPCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:02:39 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:36481 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286AbYGIPCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:02:36 -0400
Message-Id: <20080709150047.057096638@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Martin Bligh <mbligh@google.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 11/15] LTTng instrumentation - page
Content-Disposition: inline; filename=lttng-instrumentation-page.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paging activity instrumentation. Instruments page allocation/free to keep track
of page allocation. This does not cover hugetlb activity, which is covered by a
separate patch.

Those tracepoints are used by LTTng.

About the performance impact of tracepoints (which is comparable to markers),
even without immediate values optimizations, tests done by Hideo Aoki on ia64
show no regression. His test case was using hackbench on a kernel where
scheduler instrumentation (about 5 events in code scheduler code) was added.
See the "Tracepoints" patch header for performance result detail.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Martin Bligh <mbligh@google.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 mm/page-trace.h |   16 ++++++++++++++++
 mm/page_alloc.c |    6 ++++++
 2 files changed, 22 insertions(+)

Index: linux-2.6-lttng/mm/page_alloc.c
===================================================================
--- linux-2.6-lttng.orig/mm/page_alloc.c	2008-07-07 15:56:53.000000000 -0400
+++ linux-2.6-lttng/mm/page_alloc.c	2008-07-07 15:57:46.000000000 -0400
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/memcontrol.h>
 #include <linux/debugobjects.h>
+#include "page-trace.h"
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -510,6 +511,8 @@ static void __free_pages_ok(struct page 
 	int i;
 	int reserved = 0;
 
+	trace_page_free(page, order);
+
 	for (i = 0 ; i < (1 << order) ; ++i)
 		reserved += free_pages_check(page + i);
 	if (reserved)
@@ -966,6 +969,8 @@ static void free_hot_cold_page(struct pa
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
 
+	trace_page_free(page, 0);
+
 	if (PageAnon(page))
 		page->mapping = NULL;
 	if (free_pages_check(page))
@@ -1630,6 +1635,7 @@ nopage:
 		show_mem();
 	}
 got_pg:
+	trace_page_alloc(page, order);
 	return page;
 }
 
Index: linux-2.6-lttng/mm/page-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/mm/page-trace.h	2008-07-07 15:58:11.000000000 -0400
@@ -0,0 +1,16 @@
+#ifndef _PAGE_TRACE_H
+#define _PAGE_TRACE_H
+
+#include <linux/tracepoint.h>
+
+/*
+ * mm_page_alloc : page can be NULL.
+ */
+DEFINE_TRACE(page_alloc,
+	TPPROTO(struct page *page, unsigned int order),
+	TPARGS(page, order));
+DEFINE_TRACE(page_free,
+	TPPROTO(struct page *page, unsigned int order),
+	TPARGS(page, order));
+
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
