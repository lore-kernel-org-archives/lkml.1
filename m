Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZKWKlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZKWKlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZKWKlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:41:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:53253 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968AbZKWKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:40:57 -0500
Message-Id: <20091123103819.537537928@chello.nl>
References: <20091123103722.140831906@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Nov 2009 11:37:23 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/8] perf: undo copy/paste damage
Content-Disposition: inline; filename=perf-foo-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had two almost identical functions, avoid the duplication.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1704,16 +1704,10 @@ static void free_event(struct perf_event
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 
-/*
- * Called when the last reference to the file is gone.
- */
-static int perf_release(struct inode *inode, struct file *file)
+int perf_event_release_kernel(struct perf_event *event)
 {
-	struct perf_event *event = file->private_data;
 	struct perf_event_context *ctx = event->ctx;
 
-	file->private_data = NULL;
-
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_event_remove_from_context(event);
@@ -1728,26 +1722,19 @@ static int perf_release(struct inode *in
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 
-int perf_event_release_kernel(struct perf_event *event)
+/*
+ * Called when the last reference to the file is gone.
+ */
+static int perf_release(struct inode *inode, struct file *file)
 {
-	struct perf_event_context *ctx = event->ctx;
-
-	WARN_ON_ONCE(ctx->parent_ctx);
-	mutex_lock(&ctx->mutex);
-	perf_event_remove_from_context(event);
-	mutex_unlock(&ctx->mutex);
-
-	mutex_lock(&event->owner->perf_event_mutex);
-	list_del_init(&event->owner_entry);
-	mutex_unlock(&event->owner->perf_event_mutex);
-	put_task_struct(event->owner);
+	struct perf_event *event = file->private_data;
 
-	free_event(event);
+	file->private_data = NULL;
 
-	return 0;
+	return perf_event_release_kernel(event);
 }
-EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 
 static int perf_event_read_size(struct perf_event *event)
 {

-- 

