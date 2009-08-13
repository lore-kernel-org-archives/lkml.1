Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZHMKsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZHMKsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZHMKsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:48:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:47430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZHMKsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:48:09 -0400
Message-Id: <20090813103655.244097721@chello.nl>
References: <20090813094752.433445710@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:47:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>
Cc: Corey J Ashford <cjashfor@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf_counter: Fix an ipi-deadlock
Content-Disposition: inline; filename=perf-fix-pending.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_pending_counter() is called from IRQ context and will call
perf_counter_disable(), however perf_counter_disable() uses
smp_call_function_single() which doesn't fancy being used with IRQs
disabled due to IPI deadlocks.

Fix this by making it use the local __perf_counter_disable() call and
teaching the counter_sched_out() code about pending disables as well.

This should cover the case where a counter migrates before the pending
queue gets processed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -307,6 +307,10 @@ counter_sched_out(struct perf_counter *c
 		return;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	if (counter->pending_disable) {
+		counter->pending_disable = 0;
+		counter->state = PERF_COUNTER_STATE_OFF;
+	}
 	counter->tstamp_stopped = ctx->time;
 	counter->pmu->disable(counter);
 	counter->oncpu = -1;
@@ -2315,7 +2319,7 @@ static void perf_pending_counter(struct 
 
 	if (counter->pending_disable) {
 		counter->pending_disable = 0;
-		perf_counter_disable(counter);
+		__perf_counter_disable(counter);
 	}
 
 	if (counter->pending_wakeup) {

-- 

