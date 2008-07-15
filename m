Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbYGOWbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbYGOWbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761994AbYGOW26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:28:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47238 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761895AbYGOW25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:28:57 -0400
Message-Id: <20080715222748.856581704@polymtl.ca>
References: <20080715222604.331269462@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 18:26:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       William Lee Irwin III <wli@holomorphy.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 13/17] LTTng instrumentation - hugetlb
Content-Disposition: inline; filename=lttng-instrumentation-hugetlb.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 15 Jul 2008 22:27:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumentation of hugetlb activity (alloc/free/reserve/grab/release).

Those tracepoints are used by LTTng.

About the performance impact of tracepoints (which is comparable to markers),
even without immediate values optimizations, tests done by Hideo Aoki on ia64
show no regression. His test case was using hackbench on a kernel where
scheduler instrumentation (about 5 events in code scheduler code) was added.
See the "Tracepoints" patch header for performance result detail.

Changelog :
- instrument page grab, buddy allocator alloc, page release.

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
 include/trace/hugetlb.h |   28 ++++++++++++++++++++++++++++
 mm/hugetlb.c            |   41 +++++++++++++++++++++++++++++------------
 2 files changed, 57 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/mm/hugetlb.c
===================================================================
--- linux-2.6-lttng.orig/mm/hugetlb.c	2008-07-15 13:54:45.000000000 -0400
+++ linux-2.6-lttng/mm/hugetlb.c	2008-07-15 14:05:36.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include <trace/hugetlb.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -123,6 +124,7 @@ static struct page *dequeue_huge_page_vm
 static void update_and_free_page(struct page *page)
 {
 	int i;
+	trace_hugetlb_page_release(page);
 	nr_huge_pages--;
 	nr_huge_pages_node[page_to_nid(page)]--;
 	for (i = 0; i < (HPAGE_SIZE / PAGE_SIZE); i++) {
@@ -141,6 +143,7 @@ static void free_huge_page(struct page *
 	int nid = page_to_nid(page);
 	struct address_space *mapping;
 
+	trace_hugetlb_page_free(page);
 	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
 	BUG_ON(page_count(page));
@@ -205,7 +208,8 @@ static struct page *alloc_fresh_huge_pag
 	if (page) {
 		if (arch_prepare_hugepage(page)) {
 			__free_pages(page, HUGETLB_PAGE_ORDER);
-			return NULL;
+			page = NULL;
+			goto end;
 		}
 		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
@@ -214,7 +218,8 @@ static struct page *alloc_fresh_huge_pag
 		spin_unlock(&hugetlb_lock);
 		put_page(page); /* free it into the hugepage allocator */
 	}
-
+end:
+	trace_hugetlb_page_grab(page);
 	return page;
 }
 
@@ -288,7 +293,8 @@ static struct page *alloc_buddy_huge_pag
 	spin_lock(&hugetlb_lock);
 	if (surplus_huge_pages >= nr_overcommit_huge_pages) {
 		spin_unlock(&hugetlb_lock);
-		return NULL;
+		page = NULL;
+		goto end;
 	} else {
 		nr_huge_pages++;
 		surplus_huge_pages++;
@@ -321,7 +327,8 @@ static struct page *alloc_buddy_huge_pag
 		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 	}
 	spin_unlock(&hugetlb_lock);
-
+end:
+	trace_hugetlb_buddy_pgalloc(page);
 	return page;
 }
 
@@ -510,6 +517,7 @@ static struct page *alloc_huge_page(stru
 		set_page_refcounted(page);
 		set_page_private(page, (unsigned long) mapping);
 	}
+	trace_hugetlb_page_alloc(page);
 	return page;
 }
 
@@ -1292,27 +1300,36 @@ out:
 
 int hugetlb_reserve_pages(struct inode *inode, long from, long to)
 {
-	long ret, chg;
+	int ret;
+	long chg;
 
 	chg = region_chg(&inode->i_mapping->private_list, from, to);
-	if (chg < 0)
-		return chg;
+	if (chg < 0) {
+		ret = chg;
+		goto end;
+	}
 
-	if (hugetlb_get_quota(inode->i_mapping, chg))
-		return -ENOSPC;
+	if (hugetlb_get_quota(inode->i_mapping, chg)) {
+		ret = -ENOSPC;
+		goto end;
+	}
 	ret = hugetlb_acct_memory(chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
-		return ret;
+		goto end;
 	}
 	region_add(&inode->i_mapping->private_list, from, to);
-	return 0;
+end:
+	trace_hugetlb_pages_reserve(inode, from, to, ret);
+	return ret;
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
Index: linux-2.6-lttng/include/trace/hugetlb.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/trace/hugetlb.h	2008-07-15 14:05:36.000000000 -0400
@@ -0,0 +1,28 @@
+#ifndef _TRACE_HUGETLB_H
+#define _TRACE_HUGETLB_H
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(hugetlb_page_release,
+	TPPROTO(struct page *page),
+	TPARGS(page));
+DEFINE_TRACE(hugetlb_page_grab,
+	TPPROTO(struct page *page),
+	TPARGS(page));
+DEFINE_TRACE(hugetlb_buddy_pgalloc,
+	TPPROTO(struct page *page),
+	TPARGS(page));
+DEFINE_TRACE(hugetlb_page_alloc,
+	TPPROTO(struct page *page),
+	TPARGS(page));
+DEFINE_TRACE(hugetlb_page_free,
+	TPPROTO(struct page *page),
+	TPARGS(page));
+DEFINE_TRACE(hugetlb_pages_reserve,
+	TPPROTO(struct inode *inode, long from, long to, int ret),
+	TPARGS(inode, from, to, ret));
+DEFINE_TRACE(hugetlb_pages_unreserve,
+	TPPROTO(struct inode *inode, long offset, long freed),
+	TPARGS(inode, offset, freed));
+
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
