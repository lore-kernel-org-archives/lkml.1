Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZFAITx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZFAITx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZFAITj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:19:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbZFAITh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:19:37 -0400
Date: Mon, 1 Jun 2009 08:19:07 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18979.34810.259718.955621@cargo.ozlabs.ibm.com>
References: <18979.34810.259718.955621@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Allow software counters to count while task is not running
Message-ID: <tip-880ca15adf2392770a68047e7a98e076ff4d21da@git.kernel.org>
Git-Commit-ID: 880ca15adf2392770a68047e7a98e076ff4d21da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:19:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  880ca15adf2392770a68047e7a98e076ff4d21da
Gitweb:     http://git.kernel.org/tip/880ca15adf2392770a68047e7a98e076ff4d21da
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 1 Jun 2009 17:49:14 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Jun 2009 10:04:06 +0200

perf_counter: Allow software counters to count while task is not running

This changes perf_swcounter_match() so that per-task software
counters can count events that occur while their associated
task is not running.  This will allow us to use the generic
software counter code for counting task migrations, which can
occur while the task is not scheduled in.

To do this, we have to distinguish between the situations where
the counter is inactive because its task has been scheduled
out, and those where the counter is inactive because it is part
of a group that was not able to go on the PMU.  In the former
case we want the counter to count, but not in the latter case.
If the context is active, we have the latter case.  If the
context is inactive then we need to know whether the counter
was counting when the context was last active, which we can
determine by comparing its ->tstamp_stopped timestamp with the
context's timestamp.

This also folds three checks in perf_swcounter_match, checking
perf_event_raw(), perf_event_type() and perf_event_id()
individually, into a single 64-bit comparison on
counter->hw_event.config, as an optimization.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <18979.34810.259718.955621@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
