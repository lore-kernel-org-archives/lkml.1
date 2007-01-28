Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbXA1MLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbXA1MLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXA1MLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:11:11 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:19280 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751927AbXA1MKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:10:48 -0500
Message-Id: <20070128120511.229607000@programming.kicks-ass.net>
References: <20070128115118.837777000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 12:51:25 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/7] fs: fixup filevec_add_drain_all
Content-Disposition: inline; filename=s_files-per_cpu-flush-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

filevec_add_drain_all() is called under locks and schedule_on_each_cpu() can
schedule. Solve this by using the new schedule_on_each_cpu_wq().

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/file_table.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2007-01-27 23:09:23.000000000 +0100
+++ linux-2.6/fs/file_table.c	2007-01-27 23:10:02.000000000 +0100
@@ -333,6 +333,22 @@ static void __filevec_add(struct filevec
 	filevec_reinit(fvec);
 }
 
+/*
+ * Flush files per-CPU workqueue:
+ */
+static struct workqueue_struct *flush_files_workqueue;
+
+int __init flush_files_init(void)
+{
+        flush_files_workqueue = create_workqueue("flush_filesd");
+        if (!flush_files_workqueue)
+                panic("Failed to create flush_filesd\n");
+
+	return 0;
+}
+
+__initcall(flush_files_init);
+
 static void filevec_add_drain(void)
 {
 	struct filevec *fvec = &get_cpu_var(sb_fvec);
@@ -341,14 +357,15 @@ static void filevec_add_drain(void)
 	put_cpu_var(sb_fvec);
 }
 
-static void filevec_add_drain_per_cpu(struct work_struct *dummy)
+static void filevec_add_drain_per_cpu(struct work_struct *none)
 {
 	filevec_add_drain();
 }
 
 int filevec_add_drain_all(void)
 {
-	return schedule_on_each_cpu(filevec_add_drain_per_cpu);
+	return schedule_on_each_cpu_wq(flush_files_workqueue,
+				       filevec_add_drain_per_cpu);
 }
 EXPORT_SYMBOL_GPL(filevec_add_drain_all);
 

--

