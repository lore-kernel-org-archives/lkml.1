Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbZEHSTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbZEHSTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbZEHSSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:18:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbZEHSSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:18:05 -0400
Message-Id: <20090508170028.750619201@chello.nl>
References: <20090508165219.469818319@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:52:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/5] perf_counter: optimize perf_counter_task_tick()
Content-Disposition: inline; filename=perf_counter-opt-tick.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_counter_task_tick() does way too much work to find out there's nothing to
do. Provide an easy short-circuit for the normal case where there are no
counters on the system.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -39,6 +39,7 @@ int perf_max_counters __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
 static int perf_overcommit __read_mostly = 1;
 
+static atomic_t nr_counters __read_mostly;
 static atomic_t nr_mmap_tracking __read_mostly;
 static atomic_t nr_munmap_tracking __read_mostly;
 static atomic_t nr_comm_tracking __read_mostly;
@@ -1076,8 +1077,14 @@ static void rotate_ctx(struct perf_count
 
 void perf_counter_task_tick(struct task_struct *curr, int cpu)
 {
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
-	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
+
+	if (!atomic_read(&nr_counters))
+		return;
+
+	cpuctx = &per_cpu(perf_cpu_context, cpu);
+	ctx = &curr->perf_counter_ctx;
 
 	perf_counter_cpu_sched_out(cpuctx);
 	perf_counter_task_sched_out(curr, cpu);
@@ -1197,6 +1204,7 @@ static void free_counter(struct perf_cou
 {
 	perf_pending_sync(counter);
 
+	atomic_dec(&nr_counters);
 	if (counter->hw_event.mmap)
 		atomic_dec(&nr_mmap_tracking);
 	if (counter->hw_event.munmap)
@@ -2861,6 +2869,7 @@ done:
 
 	counter->pmu = pmu;
 
+	atomic_inc(&nr_counters);
 	if (counter->hw_event.mmap)
 		atomic_inc(&nr_mmap_tracking);
 	if (counter->hw_event.munmap)

-- 

