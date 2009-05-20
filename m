Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZETRVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZETRVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbZETRU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:20:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:41236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZETRU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:20:58 -0400
Date: Wed, 20 May 2009 17:19:21 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090520102553.511933670@chello.nl>
References: <20090520102553.511933670@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Optimize sched in/out of counters
Message-ID: <tip-afedadf23a2c90f3ba0d963282cbe6a6be129494@git.kernel.org>
Git-Commit-ID: afedadf23a2c90f3ba0d963282cbe6a6be129494
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 17:19:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afedadf23a2c90f3ba0d963282cbe6a6be129494
Gitweb:     http://git.kernel.org/tip/afedadf23a2c90f3ba0d963282cbe6a6be129494
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 20 May 2009 12:21:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 May 2009 12:43:34 +0200

perf_counter: Optimize sched in/out of counters

Avoid a function call for !group counters by directly calling the counter
function.

[ Impact: micro-optimize the code ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090520102553.511933670@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 473ed2c..69d4de8 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -826,8 +826,12 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 
 	perf_disable();
 	if (ctx->nr_active) {
-		list_for_each_entry(counter, &ctx->counter_list, list_entry)
-			group_sched_out(counter, cpuctx, ctx);
+		list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+			if (counter != counter->group_leader)
+				counter_sched_out(counter, cpuctx, ctx);
+			else
+				group_sched_out(counter, cpuctx, ctx);
+		}
 	}
 	perf_enable();
  out:
@@ -903,8 +907,12 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		if (counter->cpu != -1 && counter->cpu != cpu)
 			continue;
 
-		if (group_can_go_on(counter, cpuctx, 1))
-			group_sched_in(counter, cpuctx, ctx, cpu);
+		if (counter != counter->group_leader)
+			counter_sched_in(counter, cpuctx, ctx, cpu);
+		else {
+			if (group_can_go_on(counter, cpuctx, 1))
+				group_sched_in(counter, cpuctx, ctx, cpu);
+		}
 
 		/*
 		 * If this pinned group hasn't been scheduled,
@@ -932,9 +940,14 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		if (counter->cpu != -1 && counter->cpu != cpu)
 			continue;
 
-		if (group_can_go_on(counter, cpuctx, can_add_hw)) {
-			if (group_sched_in(counter, cpuctx, ctx, cpu))
+		if (counter != counter->group_leader) {
+			if (counter_sched_in(counter, cpuctx, ctx, cpu))
 				can_add_hw = 0;
+		} else {
+			if (group_can_go_on(counter, cpuctx, can_add_hw)) {
+				if (group_sched_in(counter, cpuctx, ctx, cpu))
+					can_add_hw = 0;
+			}
 		}
 	}
 	perf_enable();
