Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZETK0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZETK0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZETK0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:26:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:40896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZETK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:26:34 -0400
Message-Id: <20090520102553.511933670@chello.nl>
References: <20090520102118.377477360@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 12:21:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 4/4] perf_counter: optimize sched in/out of counters
Content-Disposition: inline; filename=perf_counter-opt-sched_out.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a function call for !group counters by directly calling the counter
function.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -826,8 +826,12 @@ void __perf_counter_sched_out(struct per
 
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
@@ -903,8 +907,12 @@ __perf_counter_sched_in(struct perf_coun
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
@@ -932,9 +940,14 @@ __perf_counter_sched_in(struct perf_coun
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

-- 

