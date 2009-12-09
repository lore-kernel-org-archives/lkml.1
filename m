Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZLIDbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZLIDbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 22:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZLIDbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 22:31:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63061 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZLIDbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 22:31:19 -0500
Message-ID: <4B1F19A8.5040805@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 11:29:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] perf_event: allocate children's perf_event_ctxp at the
 right time
References: <4B1F194D.7080306@cn.fujitsu.com>
In-Reply-To: <4B1F194D.7080306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, children task will allocate memory for
'child->perf_event_ctxp' if the parent is counted, we can
do it only if the parent allowed children inherit it.

It can save memory and reduce overhead

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_event.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index fbebe7b..592b293 100644
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
-- 
1.6.1.2


