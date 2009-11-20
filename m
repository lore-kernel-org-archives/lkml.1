Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZKTVaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZKTVaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:30:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZKTV2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:48333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbZKTV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:27 -0500
Message-Id: <20091120212508.863685796@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:51 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] perf: optimize __perf_event_read()
Content-Disposition: inline; filename=perf-time-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both callers actually have IRQs disabled, no need doing so again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1517,7 +1517,6 @@ static void __perf_event_read(void *info
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
-	unsigned long flags;
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -1529,12 +1528,10 @@ static void __perf_event_read(void *info
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	local_irq_save(flags);
 	if (ctx->is_active)
 		update_context_time(ctx);
 	event->pmu->read(event);
 	update_event_times(event);
-	local_irq_restore(flags);
 }
 
 static u64 perf_event_read(struct perf_event *event)

-- 

