Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZEKKPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZEKKPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZEKKNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:50828 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbZEKKNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:13 -0400
Date: Mon, 11 May 2009 10:12:30 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18951.34946.451546.691693@drongo.ozlabs.ibm.com>
References: <18951.34946.451546.691693@drongo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Put whole group on when enabling group leader
Message-ID: <tip-6751b71ea2c7ab8c0d65f01973a3fc8ea16992f4@git.kernel.org>
Git-Commit-ID: 6751b71ea2c7ab8c0d65f01973a3fc8ea16992f4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 10:12:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6751b71ea2c7ab8c0d65f01973a3fc8ea16992f4
Gitweb:     http://git.kernel.org/tip/6751b71ea2c7ab8c0d65f01973a3fc8ea16992f4
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 11 May 2009 12:08:02 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 12:10:53 +0200

perf_counter: Put whole group on when enabling group leader

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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <18951.34946.451546.691693@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   99 +++++++++++++++++++++++++------------------------
 1 files changed, 51 insertions(+), 48 deletions(-)

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
