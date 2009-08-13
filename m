Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZHMKsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZHMKsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZHMKsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:48:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:47438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZHMKsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:48:13 -0400
Message-Id: <20090813103655.425428004@chello.nl>
References: <20090813094752.433445710@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:47:56 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>
Cc: Corey J Ashford <cjashfor@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] perf_counter: Fix swcounter context invariance
Content-Disposition: inline; filename=perf-fix-swcounter-is-counting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_swcounter_is_counting() uses a lock, which means we cannot use
swcounters from NMI or when holding that particular lock, this is
unintended.

The below removes the lock, this opens up race window, but not worse
than the swcounters already experience due to RCU traversal of the
context in perf_swcounter_ctx_event().

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3519,40 +3519,32 @@ static void perf_swcounter_add(struct pe
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
 {
-	struct perf_counter_context *ctx;
-	unsigned long flags;
-	int count;
-
+	/*
+	 * The counter is active, we're good!
+	 */
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		return 1;
 
+	/*
+	 * The counter is off/error, not counting.
+	 */
 	if (counter->state != PERF_COUNTER_STATE_INACTIVE)
 		return 0;
 
 	/*
-	 * If the counter is inactive, it could be just because
-	 * its task is scheduled out, or because it's in a group
-	 * which could not go on the PMU.  We want to count in
-	 * the first case but not the second.  If the context is
-	 * currently active then an inactive software counter must
-	 * be the second case.  If it's not currently active then
-	 * we need to know whether the counter was active when the
-	 * context was last active, which we can determine by
-	 * comparing counter->tstamp_stopped with ctx->time.
-	 *
-	 * We are within an RCU read-side critical section,
-	 * which protects the existence of *ctx.
+	 * The counter is inactive, if the context is active
+	 * we're part of a group that didn't make it on the 'pmu',
+	 * not counting.
 	 */
-	ctx = counter->ctx;
-	spin_lock_irqsave(&ctx->lock, flags);
-	count = 1;
-	/* Re-check state now we have the lock */
-	if (counter->state < PERF_COUNTER_STATE_INACTIVE ||
-	    counter->ctx->is_active ||
-	    counter->tstamp_stopped < ctx->time)
-		count = 0;
-	spin_unlock_irqrestore(&ctx->lock, flags);
-	return count;
+	if (counter->ctx->is_active)
+		return 0;
+
+	/*
+	 * We're inactive and the context is too, this means the
+	 * task is scheduled out, we're counting events that happen
+	 * to us, like migration events.
+	 */
+	return 1;
 }
 
 static int perf_swcounter_match(struct perf_counter *counter,

-- 

