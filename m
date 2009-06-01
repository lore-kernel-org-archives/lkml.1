Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZFAHyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZFAHyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZFAHx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:53:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55085 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZFAHx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:53:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18979.34810.259718.955621@cargo.ozlabs.ibm.com>
Date: Mon, 1 Jun 2009 17:49:14 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Allow software counters to count while task is not running
In-Reply-To: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes perf_swcounter_match() so that per-task software counters
can count events that occur while their associated task is not
running.  This will allow us to use the generic software counter code
for counting task migrations, which can occur while the task is
not scheduled in.

To do this, we have to distinguish between the situations where the
counter is inactive because its task has been scheduled out, and those
where the counter is inactive because it is part of a group that was
not able to go on the PMU.  In the former case we want the counter to
count, but not in the latter case.  If the context is active, we have
the latter case.  If the context is inactive then we need to know
whether the counter was counting when the context was last active,
which we can determine by comparing its ->tstamp_stopped timestamp
with the context's timestamp.

This also folds three checks in perf_swcounter_match, checking
perf_event_raw(), perf_event_type() and perf_event_id() individually,
into a single 64-bit comparison on counter->hw_event.config, as
an optimization.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_counter.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index da8dfef..ff8b463 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2867,20 +2867,56 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 
 }
 
+static int perf_swcounter_is_counting(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx;
+	unsigned long flags;
+	int count;
+
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
+		return 1;
+
+	if (counter->state != PERF_COUNTER_STATE_INACTIVE)
+		return 0;
+
+	/*
+	 * If the counter is inactive, it could be just because
+	 * its task is scheduled out, or because it's in a group
+	 * which could not go on the PMU.  We want to count in
+	 * the first case but not the second.  If the context is
+	 * currently active then an inactive software counter must
+	 * be the second case.  If it's not currently active then
+	 * we need to know whether the counter was active when the
+	 * context was last active, which we can determine by
+	 * comparing counter->tstamp_stopped with ctx->time.
+	 *
+	 * We are within an RCU read-side critical section,
+	 * which protects the existence of *ctx.
+	 */
+	ctx = counter->ctx;
+	spin_lock_irqsave(&ctx->lock, flags);
+	count = 1;
+	/* Re-check state now we have the lock */
+	if (counter->state < PERF_COUNTER_STATE_INACTIVE ||
+	    counter->ctx->is_active ||
+	    counter->tstamp_stopped < ctx->time)
+		count = 0;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	return count;
+}
+
 static int perf_swcounter_match(struct perf_counter *counter,
 				enum perf_event_types type,
 				u32 event, struct pt_regs *regs)
 {
-	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
-		return 0;
+	u64 event_config;
 
-	if (perf_event_raw(&counter->hw_event))
-		return 0;
+	event_config = ((u64) type << PERF_COUNTER_TYPE_SHIFT) | event;
 
-	if (perf_event_type(&counter->hw_event) != type)
+	if (!perf_swcounter_is_counting(counter))
 		return 0;
 
-	if (perf_event_id(&counter->hw_event) != event)
+	if (counter->hw_event.config != event_config)
 		return 0;
 
 	if (counter->hw_event.exclude_user && user_mode(regs))
-- 
1.6.0.4

