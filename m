Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZKWLye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZKWLye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZKWLyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:54:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:56110 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbZKWLya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:54:30 -0500
Date: Mon, 23 Nov 2009 11:53:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091123103819.537537928@chello.nl>
References: <20091123103819.537537928@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Undo copy/paste damage
Message-ID: <tip-a66a3052e2d4c5815d7ad26887b1d4193206e691@git.kernel.org>
Git-Commit-ID: a66a3052e2d4c5815d7ad26887b1d4193206e691
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a66a3052e2d4c5815d7ad26887b1d4193206e691
Gitweb:     http://git.kernel.org/tip/a66a3052e2d4c5815d7ad26887b1d4193206e691
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Nov 2009 11:37:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:49:55 +0100

perf_events: Undo copy/paste damage

We had two almost identical functions, avoid the duplication.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091123103819.537537928@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   31 +++++++++----------------------
 1 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 20df8ab..e2daa10 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1704,16 +1704,10 @@ static void free_event(struct perf_event *event)
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
@@ -1728,26 +1722,19 @@ static int perf_release(struct inode *inode, struct file *file)
 
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
