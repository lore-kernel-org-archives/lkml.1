Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYGKOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYGKOa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYGKOaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:30:19 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:42145 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbYGKOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:30:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFAPgFd0hMQWVt/2dsb2JhbACBWq15
Date: Fri, 11 Jul 2008 10:30:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 12/15] LTTng instrumentation - hugetlb (update)
Message-ID: <20080711143014.GA11500@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150047.427761376@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080709150047.427761376@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:28:30 up 36 days, 19:09,  6 users,  load average: 2.77, 2.32,
	3.06
User-Agent: Mutt/1.5.16 (2007-06-11)
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
 mm/hugetlb-trace.h |   28 ++++++++++++++++++++++++++++
 mm/hugetlb.c       |   41 +++++++++++++++++++++++++++++------------
 2 files changed, 57 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/mm/hugetlb.c
===================================================================
--- linux-2.6-lttng.orig/mm/hugetlb.c	2008-07-10 00:23:34.000000000 -0400
+++ linux-2.6-lttng/mm/hugetlb.c	2008-07-11 10:23:48.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include "hugetlb-trace.h"
 
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
Index: linux-2.6-lttng/mm/hugetlb-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/mm/hugetlb-trace.h	2008-07-11 10:24:34.000000000 -0400
@@ -0,0 +1,28 @@
+#ifndef _HUGETLB_TRACE_H
+#define _HUGETLB_TRACE_H
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
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
