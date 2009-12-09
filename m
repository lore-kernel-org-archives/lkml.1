Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZLIJxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZLIJxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZLIJw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:52:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:44988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbZLIJw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:52:57 -0500
Date: Wed, 9 Dec 2009 09:52:25 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B1F19A8.5040805@cn.fujitsu.com>
References: <4B1F19A8.5040805@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Allocate children's perf_event_ctxp at the right time
Message-ID: <tip-b93f7978ad6b46133e9453b90ccc057dc2429e75@git.kernel.org>
Git-Commit-ID: b93f7978ad6b46133e9453b90ccc057dc2429e75
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b93f7978ad6b46133e9453b90ccc057dc2429e75
Gitweb:     http://git.kernel.org/tip/b93f7978ad6b46133e9453b90ccc057dc2429e75
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 9 Dec 2009 11:29:44 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 09:56:27 +0100

perf_event: Allocate children's perf_event_ctxp at the right time

In current code, children task will allocate memory for
'child->perf_event_ctxp' if the parent is counted, we can
do it only if the parent allowed children inherit it.

It can save memory and reduce overhead.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4B1F19A8.5040805@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2b06c45..77641ae 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5083,7 +5083,7 @@ again:
  */
 int perf_event_init_task(struct task_struct *child)
 {
-	struct perf_event_context *child_ctx, *parent_ctx;
+	struct perf_event_context *child_ctx = NULL, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
 	struct perf_event *event;
 	struct task_struct *parent = current;
@@ -5099,20 +5099,6 @@ int perf_event_init_task(struct task_struct *child)
 		return 0;
 
 	/*
-	 * This is executed from the parent task context, so inherit
-	 * events that have been marked for cloning.
-	 * First allocate and initialize a context for the child.
-	 */
-
-	child_ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
-	if (!child_ctx)
-		return -ENOMEM;
-
-	__perf_event_init_context(child_ctx, child);
-	child->perf_event_ctxp = child_ctx;
-	get_task_struct(child);
-
-	/*
 	 * If the parent's context is a clone, pin it so it won't get
 	 * swapped under us.
 	 */
@@ -5142,6 +5128,26 @@ int perf_event_init_task(struct task_struct *child)
 			continue;
 		}
 
+		if (!child->perf_event_ctxp) {
+			/*
+			 * This is executed from the parent task context, so
+			 * inherit events that have been marked for cloning.
+			 * First allocate and initialize a context for the
+			 * child.
+			 */
+
+			child_ctx = kzalloc(sizeof(struct perf_event_context),
+					    GFP_KERNEL);
+			if (!child_ctx) {
+				ret = -ENOMEM;
+				goto exit;
+			}
+
+			__perf_event_init_context(child_ctx, child);
+			child->perf_event_ctxp = child_ctx;
+			get_task_struct(child);
+		}
+
 		ret = inherit_group(event, parent, parent_ctx,
 					     child, child_ctx);
 		if (ret) {
@@ -5170,6 +5176,7 @@ int perf_event_init_task(struct task_struct *child)
 		get_ctx(child_ctx->parent_ctx);
 	}
 
+exit:
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);
