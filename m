Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbZIPWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbZIPWp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760365AbZIPWj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:39:58 -0400
Received: from kroah.org ([198.145.64.141]:48948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760343AbZIPWjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:15 2009
Message-Id: <20090916223715.565352707@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 16/45] perf_counter: Start counting time enabled when group leader gets enabled
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=perf_counter-start-counting-time-enabled-when-group-leader-gets-enabled.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Paul Mackerras <paulus@samba.org>

commit fa289beca9de9119c7760bd984f3640da21bc94c upstream.

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
LKML-Reference: <19091.29664.342227.445006@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_counter.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -469,7 +469,8 @@ static void update_counter_times(struct 
 	struct perf_counter_context *ctx = counter->ctx;
 	u64 run_end;
 
-	if (counter->state < PERF_COUNTER_STATE_INACTIVE)
+	if (counter->state < PERF_COUNTER_STATE_INACTIVE ||
+	    counter->group_leader->state < PERF_COUNTER_STATE_INACTIVE)
 		return;
 
 	counter->total_time_enabled = ctx->time - counter->tstamp_enabled;
@@ -518,7 +519,7 @@ static void __perf_counter_disable(void 
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
 		update_context_time(ctx);
-		update_counter_times(counter);
+		update_group_times(counter);
 		if (counter == counter->group_leader)
 			group_sched_out(counter, cpuctx, ctx);
 		else
@@ -573,7 +574,7 @@ static void perf_counter_disable(struct 
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
@@ -877,8 +899,7 @@ static void __perf_counter_enable(void *
 
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
-	counter->state = PERF_COUNTER_STATE_INACTIVE;
-	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
+	__perf_counter_mark_enabled(counter, ctx);
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -971,11 +992,9 @@ static void perf_counter_enable(struct p
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
@@ -1479,9 +1498,7 @@ static void perf_counter_enable_on_exec(
 		counter->attr.enable_on_exec = 0;
 		if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 			continue;
-		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled =
-			ctx->time - counter->total_time_enabled;
+		__perf_counter_mark_enabled(counter, ctx);
 		enabled = 1;
 	}
 


