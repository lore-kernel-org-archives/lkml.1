Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZFAHxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZFAHxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZFAHx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:53:26 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55086 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbZFAHx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:53:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18979.35052.915728.626374@cargo.ozlabs.ibm.com>
Date: Mon, 1 Jun 2009 17:53:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Remove unused prev_state field
In-Reply-To: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the prev_state field of struct perf_counter since it is
now unused.  It was only used by the cpu migration counter, which
doesn't use it any more.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_counter.h |    1 -
 kernel/perf_counter.c        |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e630602..82ab958 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -427,7 +427,6 @@ struct perf_counter {
 	const struct pmu		*pmu;
 
 	enum perf_counter_active_state	state;
-	enum perf_counter_active_state	prev_state;
 	atomic64_t			count;
 
 	/*
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c7a20fa..d6d2f9d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -570,7 +570,6 @@ group_sched_in(struct perf_counter *group_counter,
 	if (ret)
 		return ret < 0 ? ret : 0;
 
-	group_counter->prev_state = group_counter->state;
 	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
 		return -EAGAIN;
 
@@ -578,7 +577,6 @@ group_sched_in(struct perf_counter *group_counter,
 	 * Schedule in siblings as one group (if any):
 	 */
 	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
-		counter->prev_state = counter->state;
 		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
 			partial_group = counter;
 			goto group_error;
@@ -655,7 +653,6 @@ static void add_counter_to_ctx(struct perf_counter *counter,
 			       struct perf_counter_context *ctx)
 {
 	list_add_counter(counter, ctx);
-	counter->prev_state = PERF_COUNTER_STATE_OFF;
 	counter->tstamp_enabled = ctx->time;
 	counter->tstamp_running = ctx->time;
 	counter->tstamp_stopped = ctx->time;
@@ -818,7 +815,6 @@ static void __perf_counter_enable(void *info)
 	ctx->is_active = 1;
 	update_context_time(ctx);
 
-	counter->prev_state = counter->state;
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
-- 
1.6.0.4

