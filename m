Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbZDHNGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbZDHNGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765346AbZDHNDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765328AbZDHNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:33 -0400
Message-Id: <20090408130408.681326666@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/9] perf_counter: fix NMI race in task clock
Content-Disposition: inline; filename=perf_counter-task-clock-read.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not be updating ctx->time from NMI context, work around that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -319,8 +319,6 @@ static void __perf_counter_disable(void 
 
 	spin_lock_irqsave(&ctx->lock, flags);
 
-	update_context_time(ctx);
-
 	/*
 	 * If the counter is on, turn it off.
 	 * If it is in error state, leave it in error state.
@@ -2335,13 +2333,11 @@ static const struct hw_perf_counter_ops 
  * Software counter: task time clock
  */
 
-static void task_clock_perf_counter_update(struct perf_counter *counter)
+static void task_clock_perf_counter_update(struct perf_counter *counter, u64 now)
 {
-	u64 prev, now;
+	u64 prev;
 	s64 delta;
 
-	now = counter->ctx->time;
-
 	prev = atomic64_xchg(&counter->hw.prev_count, now);
 	delta = now - prev;
 	atomic64_add(delta, &counter->count);
@@ -2369,13 +2365,24 @@ static int task_clock_perf_counter_enabl
 static void task_clock_perf_counter_disable(struct perf_counter *counter)
 {
 	hrtimer_cancel(&counter->hw.hrtimer);
-	task_clock_perf_counter_update(counter);
+	task_clock_perf_counter_update(counter, counter->ctx->time);
+
 }
 
 static void task_clock_perf_counter_read(struct perf_counter *counter)
 {
-	update_context_time(counter->ctx);
-	task_clock_perf_counter_update(counter);
+	u64 time;
+
+	if (!in_nmi()) {
+		update_context_time(counter->ctx);
+		time = counter->ctx->time;
+	} else {
+		u64 now = perf_clock();
+		u64 delta = now - counter->ctx->timestamp;
+		time = counter->ctx->time + delta;
+	}
+
+	task_clock_perf_counter_update(counter, time);
 }
 
 static const struct hw_perf_counter_ops perf_ops_task_clock = {

-- 

