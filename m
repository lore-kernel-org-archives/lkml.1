Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZEYMsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZEYMsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZEYMrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:47:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbZEYMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:47:09 -0400
Message-Id: <20090525124600.419025548@chello.nl>
References: <20090525124523.010479297@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 14:45:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 5/5] perf_counter: fix PERF_COUNTER_CONTEXT_SWITCHES for cpu counters
Content-Disposition: inline; filename=perf_counter-fix-swcounter-context-switches.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo noticed that cpu counters had 0 context switches, even though there
was plenty scheduling on the cpu.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -932,14 +932,13 @@ void perf_counter_task_sched_out(struct 
 	struct perf_counter_context *next_ctx;
 	struct pt_regs *regs;
 
+	regs = task_pt_regs(task);
+	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
+
 	if (likely(!ctx || !cpuctx->task_ctx))
 		return;
 
 	update_context_time(ctx);
-
-	regs = task_pt_regs(task);
-	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
-
 	next_ctx = next->perf_counter_ctxp;
 	if (next_ctx && context_equiv(ctx, next_ctx)) {
 		task->perf_counter_ctxp = next_ctx;

-- 

