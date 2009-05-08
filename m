Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbZEHSka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbZEHSka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZEHSkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:40:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:54672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZEHSkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:40:17 -0400
Date: Fri, 8 May 2009 18:39:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090508170028.750619201@chello.nl>
References: <20090508170028.750619201@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: optimize perf_counter_task_tick()
Message-ID: <tip-7fc23a5380797012e92a9633169440f2f4a21253@git.kernel.org>
Git-Commit-ID: 7fc23a5380797012e92a9633169440f2f4a21253
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 18:39:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fc23a5380797012e92a9633169440f2f4a21253
Gitweb:     http://git.kernel.org/tip/7fc23a5380797012e92a9633169440f2f4a21253
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 8 May 2009 18:52:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 May 2009 20:36:57 +0200

perf_counter: optimize perf_counter_task_tick()

perf_counter_task_tick() does way too much work to find out
there's nothing to do. Provide an easy short-circuit for the
normal case where there are no counters on the system.

[ Impact: micro-optimization ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090508170028.750619201@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 60e55f0..fdb0d24 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -39,6 +39,7 @@ int perf_max_counters __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
 static int perf_overcommit __read_mostly = 1;
 
+static atomic_t nr_counters __read_mostly;
 static atomic_t nr_mmap_tracking __read_mostly;
 static atomic_t nr_munmap_tracking __read_mostly;
 static atomic_t nr_comm_tracking __read_mostly;
@@ -1076,8 +1077,14 @@ static void rotate_ctx(struct perf_counter_context *ctx)
 
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
@@ -1197,6 +1204,7 @@ static void free_counter(struct perf_counter *counter)
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
