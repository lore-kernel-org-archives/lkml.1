Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZKTVcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZKTVcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZKTVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:31:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbZKTV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:28 -0500
Message-Id: <20091120212508.779516394@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] perf: optimize perf_event_task_sched_out
Content-Disposition: inline; filename=perf-time-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an update_context_time() call from the
perf_event_task_sched_out() path and into the branch its needed.

The call was both superfluous, because __perf_event_sched_out()
already does it, and wrong, because it was done without holding
ctx->lock.

Place it in perf_event_sync_stat(), which is the only place it is
needed and which does already hold ctx->lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1120,6 +1120,8 @@ static void perf_event_sync_stat(struct 
 	if (!ctx->nr_stat)
 		return;
 
+	update_context_time(ctx);
+
 	event = list_first_entry(&ctx->event_list,
 				   struct perf_event, event_entry);
 
@@ -1163,8 +1165,6 @@ void perf_event_task_sched_out(struct ta
 	if (likely(!ctx || !cpuctx->task_ctx))
 		return;
 
-	update_context_time(ctx);
-
 	rcu_read_lock();
 	parent = rcu_dereference(ctx->parent_ctx);
 	next_ctx = next->perf_event_ctxp;

-- 

