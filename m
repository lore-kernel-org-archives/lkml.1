Return-Path: <linux-kernel-owner+w=401wt.eu-S934166AbZDHQ7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbZDHQ7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbZDHQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:59:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbZDHQ7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:59:08 -0400
Date: Wed, 8 Apr 2009 16:57:32 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090408130408.681326666@chello.nl>
References: <20090408130408.681326666@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: fix NMI race in task clock
Message-ID: <tip-e30e08f65c7ef6c230424264f09c3d53f117f58b@git.kernel.org>
Git-Commit-ID: e30e08f65c7ef6c230424264f09c3d53f117f58b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:57:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e30e08f65c7ef6c230424264f09c3d53f117f58b
Gitweb:     http://git.kernel.org/tip/e30e08f65c7ef6c230424264f09c3d53f117f58b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Apr 2009 15:01:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:53:27 +0200

perf_counter: fix NMI race in task clock

We should not be updating ctx->time from NMI context, work around that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090408130408.681326666@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 863703b..84a3908 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -319,8 +319,6 @@ static void __perf_counter_disable(void *info)
 
 	spin_lock_irqsave(&ctx->lock, flags);
 
-	update_context_time(ctx);
-
 	/*
 	 * If the counter is on, turn it off.
 	 * If it is in error state, leave it in error state.
@@ -2335,13 +2333,11 @@ static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
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
@@ -2369,13 +2365,24 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
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
