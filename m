Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbYEVEXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbYEVEXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYEVEXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:23:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYEVEXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:23:04 -0400
Message-Id: <20080522042301.622087604@goodmis.org>
References: <20080522042215.584408893@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 00:22:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ftrace: limit use of check pages
Content-Disposition: inline; filename=ftrace-limit-checkpages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check_pages function is called often enough that it can cause problems
with trace outputs or even bringing the system to a halt.

This patch limits the check_pages to the places that are most likely to
have problems. The check is made at the flip between the global array and
the max save array, as well as when the size of the buffers changes and
the self tests.

This patch also removes the BUG_ON from check_pages and replaces it with
a WARN_ON and disabling of the tracer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c          |   32 +++++++++++++++++++++++---------
 kernel/trace/trace_selftest.c |    1 +
 2 files changed, 24 insertions(+), 9 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-05-21 13:25:34.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-05-21 21:32:23.000000000 -0400
@@ -249,24 +249,32 @@ __update_max_tr(struct trace_array *tr, 
 	tracing_record_cmdline(current);
 }
 
+#define CHECK_COND(cond)			\
+	if (unlikely(cond)) {			\
+		tracing_disabled = 0;		\
+		WARN_ON(1);			\
+		return -1;			\
+	}
+
 /**
  * check_pages - integrity check of trace buffers
  *
  * As a safty measure we check to make sure the data pages have not
- * been corrupted. TODO: configure to disable this because it adds
- * a bit of overhead.
+ * been corrupted.
  */
-void check_pages(struct trace_array_cpu *data)
+int check_pages(struct trace_array_cpu *data)
 {
 	struct page *page, *tmp;
 
-	BUG_ON(data->trace_pages.next->prev != &data->trace_pages);
-	BUG_ON(data->trace_pages.prev->next != &data->trace_pages);
+	CHECK_COND(data->trace_pages.next->prev != &data->trace_pages);
+	CHECK_COND(data->trace_pages.prev->next != &data->trace_pages);
 
 	list_for_each_entry_safe(page, tmp, &data->trace_pages, lru) {
-		BUG_ON(page->lru.next->prev != &page->lru);
-		BUG_ON(page->lru.prev->next != &page->lru);
+		CHECK_COND(page->lru.next->prev != &page->lru);
+		CHECK_COND(page->lru.prev->next != &page->lru);
 	}
+
+	return 0;
 }
 
 /**
@@ -280,7 +288,6 @@ void *head_page(struct trace_array_cpu *
 {
 	struct page *page;
 
-	check_pages(data);
 	if (list_empty(&data->trace_pages))
 		return NULL;
 
@@ -2608,7 +2615,7 @@ tracing_entries_write(struct file *filp,
 {
 	unsigned long val;
 	char buf[64];
-	int ret;
+	int i, ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2677,8 +2684,15 @@ tracing_entries_write(struct file *filp,
 			trace_free_page();
 	}
 
+	/* check integrity */
+	for_each_tracing_cpu(i)
+		check_pages(global_trace.data[i]);
+
 	filp->f_pos += cnt;
 
+	/* If check pages failed, return ENOMEM */
+	if (tracing_disabled)
+		cnt = -ENOMEM;
  out:
 	max_tr.entries = global_trace.entries;
 	mutex_unlock(&trace_types_lock);
Index: linux-tip.git/kernel/trace/trace_selftest.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_selftest.c	2008-05-21 19:06:11.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_selftest.c	2008-05-21 20:25:05.000000000 -0400
@@ -28,6 +28,7 @@ trace_test_buffer_cpu(struct trace_array
 	page = list_entry(data->trace_pages.next, struct page, lru);
 	entries = page_address(page);
 
+	check_pages(data);
 	if (head_page(data) != entries)
 		goto failed;
 

-- 
