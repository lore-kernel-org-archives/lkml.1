Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYGIPGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYGIPGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758888AbYGIPDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:03:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41373 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875AbYGIPDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:03:43 -0400
Message-Id: <20080709150046.031555160@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 08/15] LTTng instrumentation - filemap
Content-Disposition: inline; filename=lttng-instrumentation-filemap.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumentation of waits caused by memory accesses on mmap regions.

Those tracepoints are used by LTTng.

About the performance impact of tracepoints (which is comparable to markers),
even without immediate values optimizations, tests done by Hideo Aoki on ia64
show no regression. His test case was using hackbench on a kernel where
scheduler instrumentation (about 5 events in code scheduler code) was added.
See the "Tracepoints" patch header for performance result detail.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-mm@kvack.org
CC: Dave Hansen <haveblue@us.ibm.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 mm/filemap-trace.h |   13 +++++++++++++
 mm/filemap.c       |    3 +++
 2 files changed, 16 insertions(+)

Index: linux-2.6-lttng/mm/filemap.c
===================================================================
--- linux-2.6-lttng.orig/mm/filemap.c	2008-07-09 10:55:46.000000000 -0400
+++ linux-2.6-lttng/mm/filemap.c	2008-07-09 10:58:27.000000000 -0400
@@ -33,6 +33,7 @@
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
+#include "filemap-trace.h"
 #include "internal.h"
 
 /*
@@ -541,9 +542,11 @@ void wait_on_page_bit(struct page *page,
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
 
+	trace_filemap_wait_start(page, bit_nr);
 	if (test_bit(bit_nr, &page->flags))
 		__wait_on_bit(page_waitqueue(page), &wait, sync_page,
 							TASK_UNINTERRUPTIBLE);
+	trace_filemap_wait_end(page, bit_nr);
 }
 EXPORT_SYMBOL(wait_on_page_bit);
 
Index: linux-2.6-lttng/mm/filemap-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/mm/filemap-trace.h	2008-07-09 10:58:27.000000000 -0400
@@ -0,0 +1,13 @@
+#ifndef _FILEMAP_TRACE_H
+#define _FILEMAP_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(filemap_wait_start,
+	TPPROTO(struct page *page, int bit_nr),
+	TPARGS(page, bit_nr));
+DEFINE_TRACE(filemap_wait_end,
+	TPPROTO(struct page *page, int bit_nr),
+	TPARGS(page, bit_nr));
+
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
