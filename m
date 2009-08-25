Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZHYFR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZHYFR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 01:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZHYFR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 01:17:27 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60203 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZHYFR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 01:17:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19091.29664.342227.445006@drongo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 15:17:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: [PATCH] perf_counter: Start counting time enabled when group leader gets enabled
In-Reply-To: <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	<1251121618.7538.262.camel@twins>
	<7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if a group is created where the group leader is initially
disabled but a non-leader member is initially enabled, and then the
leader is subsequently enabled some time later, the time_enabled for
the non-leader member will reflect the whole time since it was created,
not just the time since the leader was enabled.  This is incorrect,
because all of the members are effectively disabled while the leader
is disabled, since none of the members can go on the PMU if the leader
can't.

Thus we have to update the ->tstamp_enabled for all the enabled group
members when a group leader is enabled, so that the time_enabled
computation only counts the time since the leader was enabled.
Similarly, when disabling a group leader we have to update the
time_enabled and time_running for all of the group members.
Also, in update_counter_times, we have to treat a counter whose group
leader is disabled as being disabled.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Stephane, this should fix the problem you were seeing.  Let me know
whether it does or not.

 kernel/perf_counter.c |   43 ++++++++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f274e19..06bf6a4 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -469,7 +469,8 @@ static void update_counter_times(struct perf_counter *counter)
 	struct perf_counter_context *ctx = counter->ctx;
 	u64 run_end;
 
-	if (counter->state < PERF_COUNTER_STATE_INACTIVE)
+	if (counter->state < PERF_COUNTER_STATE_INACTIVE ||
+	    counter->group_leader->state < PERF_COUNTER_STATE_INACTIVE)
 		return;
 
 	counter->total_time_enabled = ctx->time - counter->tstamp_enabled;
@@ -518,7 +519,7 @@ static void __perf_counter_disable(void *info)
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
 		update_context_time(ctx);
-		update_counter_times(counter);
+		update_group_times(counter);
 		if (counter == counter->group_leader)
 			group_sched_out(counter, cpuctx, ctx);
 		else
@@ -573,7 +574,7 @@ static void perf_counter_disable(struct perf_counter *counter)
 	 * in, so we can change the state safely.
 	 */
 	if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
-		update_counter_times(counter);
+		update_group_times(counter);
 		counter->state = PERF_COUNTER_STATE_OFF;
 	}
 
@@ -851,6 +852,27 @@ retry:
 }
 
 /*
+ * Put a counter into inactive state and update time fields.
+ * Enabling the leader of a group effectively enables all
+ * the group members that aren't explicitly disabled, so we
+ * have to update their ->tstamp_enabled also.
+ * Note: this works for group members as well as group leaders
+ * since the non-leader members' sibling_lists will be empty.
+ */
+static void __perf_counter_mark_enabled(struct perf_counter *counter,
+					struct perf_counter_context *ctx)
+{
+	struct perf_counter *sub;
+
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
+	list_for_each_entry(sub, &counter->sibling_list, list_entry)
+		if (sub->state >= PERF_COUNTER_STATE_INACTIVE)
+			sub->tstamp_enabled =
+				ctx->time - sub->total_time_enabled;
+}
+
+/*
  * Cross CPU call to enable a performance counter
  */
 static void __perf_counter_enable(void *info)
@@ -877,8 +899,7 @@ static void __perf_counter_enable(void *info)
 
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
-	counter->state = PERF_COUNTER_STATE_INACTIVE;
-	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
+	__perf_counter_mark_enabled(counter, ctx);
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -971,11 +992,9 @@ static void perf_counter_enable(struct perf_counter *counter)
 	 * Since we have the lock this context can't be scheduled
 	 * in, so we can change the state safely.
 	 */
-	if (counter->state == PERF_COUNTER_STATE_OFF) {
-		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled =
-			ctx->time - counter->total_time_enabled;
-	}
+	if (counter->state == PERF_COUNTER_STATE_OFF)
+		__perf_counter_mark_enabled(counter, ctx);
+
  out:
 	spin_unlock_irq(&ctx->lock);
 }
@@ -1479,9 +1498,7 @@ static void perf_counter_enable_on_exec(struct task_struct *task)
 		counter->attr.enable_on_exec = 0;
 		if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 			continue;
-		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled =
-			ctx->time - counter->total_time_enabled;
+		__perf_counter_mark_enabled(counter, ctx);
 		enabled = 1;
 	}
 
-- 
1.5.5.rc3.7.gba13

