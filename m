Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZHYHhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZHYHhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbZHYHhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:37:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbZHYHhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:37:13 -0400
Date: Tue, 25 Aug 2009 07:36:40 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <19091.29664.342227.445006@drongo.ozlabs.ibm.com>
References: <19091.29664.342227.445006@drongo.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Start counting time enabled when group leader gets enabled
Message-ID: <tip-fa289beca9de9119c7760bd984f3640da21bc94c@git.kernel.org>
Git-Commit-ID: fa289beca9de9119c7760bd984f3640da21bc94c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 07:36:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa289beca9de9119c7760bd984f3640da21bc94c
Gitweb:     http://git.kernel.org/tip/fa289beca9de9119c7760bd984f3640da21bc94c
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 25 Aug 2009 15:17:20 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 09:34:38 +0200

perf_counter: Start counting time enabled when group leader gets enabled

Currently, if a group is created where the group leader is
initially disabled but a non-leader member is initially
enabled, and then the leader is subsequently enabled some time
later, the time_enabled for the non-leader member will reflect
the whole time since it was created, not just the time since
the leader was enabled.

This is incorrect, because all of the members are effectively
disabled while the leader is disabled, since none of the
members can go on the PMU if the leader can't.

Thus we have to update the ->tstamp_enabled for all the enabled
group members when a group leader is enabled, so that the
time_enabled computation only counts the time since the leader
was enabled.

Similarly, when disabling a group leader we have to update the
time_enabled and time_running for all of the group members.

Also, in update_counter_times, we have to treat a counter whose
group leader is disabled as being disabled.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
LKML-Reference: <19091.29664.342227.445006@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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
 
