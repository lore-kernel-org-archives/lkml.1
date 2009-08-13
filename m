Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZHMKWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZHMKWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZHMKWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:22:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:48390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZHMKWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:22:34 -0400
Date: Thu, 13 Aug 2009 10:21:51 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, eranian@googlemail.com, cjashfor@us.ibm.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, cjashfor@us.ibm.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250149915.10001.66.camel@twins>
References: <1250149915.10001.66.camel@twins>
Subject: [tip:perfcounters/urgent] perf_counter: Fix swcounter context invariance
Message-ID: <tip-bcfc2602e8541ac13b1def38e2591dca072cff7a@git.kernel.org>
Git-Commit-ID: bcfc2602e8541ac13b1def38e2591dca072cff7a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 10:21:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcfc2602e8541ac13b1def38e2591dca072cff7a
Gitweb:     http://git.kernel.org/tip/bcfc2602e8541ac13b1def38e2591dca072cff7a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Aug 2009 09:51:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 12:18:43 +0200

perf_counter: Fix swcounter context invariance

perf_swcounter_is_counting() uses a lock, which means we cannot
use swcounters from NMI or when holding that particular lock,
this is unintended.

The below removes the lock, this opens up race window, but not
worse than the swcounters already experience due to RCU
traversal of the context in perf_swcounter_ctx_event().

This also fixes the hard lockups while opening a lockdep
tracepoint counter.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Corey J Ashford <cjashfor@us.ibm.com>
LKML-Reference: <1250149915.10001.66.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   44 ++++++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e26d2fc..3dd4339 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3444,40 +3444,32 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 
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
