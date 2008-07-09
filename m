Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYGIPFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYGIPFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbYGIPDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:03:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41180 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbYGIPDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:03:01 -0400
Message-Id: <20080709150047.427761376@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       William Lee Irwin III <wli@holomorphy.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 12/15] LTTng instrumentation - hugetlb
Content-Disposition: inline; filename=lttng-instrumentation-hugetlb.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumentation of hugetlb activity (alloc/free/reserve).

Those tracepoints are used by LTTng.

About the performance impact of tracepoints (which is comparable to markers),
even without immediate values optimizations, tests done by Hideo Aoki on ia64
show no regression. His test case was using hackbench on a kernel where
scheduler instrumentation (about 5 events in code scheduler code) was added.
See the "Tracepoints" patch header for performance result detail.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: William Lee Irwin III <wli@holomorphy.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 mm/hugetlb-trace.h |   19 +++++++++++++++++++
 mm/hugetlb.c       |    8 +++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/mm/hugetlb.c
===================================================================
--- linux-2.6-lttng.orig/mm/hugetlb.c	2008-07-07 16:31:44.000000000 -0400
+++ linux-2.6-lttng/mm/hugetlb.c	2008-07-08 10:51:17.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include "hugetlb-trace.h"
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -141,6 +142,7 @@ static void free_huge_page(struct page *
 	int nid = page_to_nid(page);
 	struct address_space *mapping;
 
+	trace_hugetlb_page_free(page);
 	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
 	BUG_ON(page_count(page));
@@ -509,6 +511,7 @@ static struct page *alloc_huge_page(stru
 	if (!IS_ERR(page)) {
 		set_page_refcounted(page);
 		set_page_private(page, (unsigned long) mapping);
+		trace_hugetlb_page_alloc(page);
 	}
 	return page;
 }
@@ -1306,13 +1309,16 @@ int hugetlb_reserve_pages(struct inode *
 		return ret;
 	}
 	region_add(&inode->i_mapping->private_list, from, to);
+	trace_hugetlb_pages_reserve(inode, from, to);
 	return 0;
 }
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
-	long chg = region_truncate(&inode->i_mapping->private_list, offset);
+	long chg;
 
+	trace_hugetlb_pages_unreserve(inode, offset, freed);
+	chg = region_truncate(&inode->i_mapping->private_list, offset);
 	spin_lock(&inode->i_lock);
 	inode->i_blocks -= BLOCKS_PER_HUGEPAGE * freed;
 	spin_unlock(&inode->i_lock);
Index: linux-2.6-lttng/mm/hugetlb-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/mm/hugetlb-trace.h	2008-07-08 10:45:15.000000000 -0400
@@ -0,0 +1,19 @@
+#ifndef _HUGETLB_TRACE_H
+#define _HUGETLB_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(hugetlb_page_alloc,
+	TPPROTO(struct page *page),
+	TPARGS(page));
+DEFINE_TRACE(hugetlb_page_free,
+	TPPROTO(struct page *page),
+	TPARGS(page));
+DEFINE_TRACE(hugetlb_pages_reserve,
+	TPPROTO(struct inode *inode, long from, long to),
+	TPARGS(inode, from, to));
+DEFINE_TRACE(hugetlb_pages_unreserve,
+	TPPROTO(struct inode *inode, long offset, long freed),
+	TPARGS(inode, offset, freed));
+
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
