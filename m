Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZEKCI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZEKCI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZEKCIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:08:19 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45788 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZEKCIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:08:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18951.34946.451546.691693@drongo.ozlabs.ibm.com>
Date: Mon, 11 May 2009 12:08:02 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perf_counter: put whole group on when enabling group leader
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if you have a group where the leader is disabled and there
are siblings that are enabled, and then you enable the leader, we only
put the leader on the PMU, and not its enabled siblings.  This is
incorrect, since the enabled group members should be all on or all off
at any given point.

This fixes it by adding a call to group_sched_in in
__perf_counter_enable in the case where we're enabling a group leader.
To avoid the need for a forward declaration this also moves
group_sched_in up before __perf_counter_enable.  The actual content of
group_sched_in is unchanged by this patch.

[ Impact: fix bug in counter enable code ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_counter.c |   99 +++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 48 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d850a1f..a5bdc93 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -419,6 +419,54 @@ counter_sched_in(struct perf_counter *counter,
 	return 0;
 }
 
+static int
+group_sched_in(struct perf_counter *group_counter,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx,
+	       int cpu)
+{
+	struct perf_counter *counter, *partial_group;
+	int ret;
+
+	if (group_counter->state == PERF_COUNTER_STATE_OFF)
+		return 0;
+
+	ret = hw_perf_group_sched_in(group_counter, cpuctx, ctx, cpu);
+	if (ret)
+		return ret < 0 ? ret : 0;
+
+	group_counter->prev_state = group_counter->state;
+	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
+		return -EAGAIN;
+
+	/*
+	 * Schedule in siblings as one group (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		counter->prev_state = counter->state;
+		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
+			partial_group = counter;
+			goto group_error;
+		}
+	}
+
+	return 0;
+
+group_error:
+	/*
+	 * Groups can be scheduled in as one unit only, so undo any
+	 * partial group before returning:
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		if (counter == partial_group)
+			break;
+		counter_sched_out(counter, cpuctx, ctx);
+	}
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	return -EAGAIN;
+}
+
 /*
  * Return 1 for a group consisting entirely of software counters,
  * 0 if the group contains any hardware counters.
@@ -643,6 +691,9 @@ static void __perf_counter_enable(void *info)
 
 	if (!group_can_go_on(counter, cpuctx, 1))
 		err = -EEXIST;
+	else if (counter == leader)
+		err = group_sched_in(counter, cpuctx, ctx,
+				     smp_processor_id());
 	else
 		err = counter_sched_in(counter, cpuctx, ctx,
 				       smp_processor_id());
@@ -791,54 +842,6 @@ static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
 	__perf_counter_sched_out(&cpuctx->ctx, cpuctx);
 }
 
-static int
-group_sched_in(struct perf_counter *group_counter,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_counter_context *ctx,
-	       int cpu)
-{
-	struct perf_counter *counter, *partial_group;
-	int ret;
-
-	if (group_counter->state == PERF_COUNTER_STATE_OFF)
-		return 0;
-
-	ret = hw_perf_group_sched_in(group_counter, cpuctx, ctx, cpu);
-	if (ret)
-		return ret < 0 ? ret : 0;
-
-	group_counter->prev_state = group_counter->state;
-	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
-		return -EAGAIN;
-
-	/*
-	 * Schedule in siblings as one group (if any):
-	 */
-	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
-		counter->prev_state = counter->state;
-		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
-			partial_group = counter;
-			goto group_error;
-		}
-	}
-
-	return 0;
-
-group_error:
-	/*
-	 * Groups can be scheduled in as one unit only, so undo any
-	 * partial group before returning:
-	 */
-	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
-		if (counter == partial_group)
-			break;
-		counter_sched_out(counter, cpuctx, ctx);
-	}
-	counter_sched_out(group_counter, cpuctx, ctx);
-
-	return -EAGAIN;
-}
-
 static void
 __perf_counter_sched_in(struct perf_counter_context *ctx,
 			struct perf_cpu_context *cpuctx, int cpu)
