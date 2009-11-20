Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZKTV2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZKTV2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZKTV23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:48327 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZKTV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:26 -0500
Message-Id: <20091120212509.102316434@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:54 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] perf: fix time locking
Content-Disposition: inline; filename=perf-time-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most sites updating ctx->time and event times do so under ctx->lock,
make sure they all do.

This was made possible by removing the __perf_event_read() call from
__perf_event_sync_stat(), which already had this lock taken.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1526,8 +1526,11 @@ static void __perf_event_read(void *info
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
+	spin_lock(&ctx->lock);
 	update_context_time(ctx);
 	update_event_times(event);
+	spin_unlock(&ctx->lock);
+
 	event->pmu->read(event);
 }
 
@@ -1541,7 +1544,13 @@ static u64 perf_event_read(struct perf_e
 		smp_call_function_single(event->oncpu,
 					 __perf_event_read, event, 1);
 	} else if (event->state == PERF_EVENT_STATE_INACTIVE) {
+		struct perf_event_context *ctx = event->ctx;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->lock, flags);
+		update_context_time(ctx);
 		update_event_times(event);
+		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
 	return atomic64_read(&event->count);

-- 

