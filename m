Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZFWKFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZFWKFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbZFWKEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:04:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:33670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840AbZFWKEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:04:33 -0400
Date: Tue, 23 Jun 2009 10:04:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Optimize perf_counter_alloc()'s inherit case
Message-ID: <tip-f344011ccb85469445369153c3d27c4ee4bc2ac8@git.kernel.org>
Git-Commit-ID: f344011ccb85469445369153c3d27c4ee4bc2ac8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 10:04:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f344011ccb85469445369153c3d27c4ee4bc2ac8
Gitweb:     http://git.kernel.org/tip/f344011ccb85469445369153c3d27c4ee4bc2ac8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 22 Jun 2009 13:58:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 11:42:46 +0200

perf_counter: Optimize perf_counter_alloc()'s inherit case

We don't need to add usage counts for swcounter and attr usage
models for inherited counters since the parent counter will
always have one, which suffices to generate the needed output.

This avoids up to 3 global atomic increments per inherited
counter.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0a45490..c2b19c1 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1508,11 +1508,13 @@ static void free_counter(struct perf_counter *counter)
 {
 	perf_pending_sync(counter);
 
-	atomic_dec(&nr_counters);
-	if (counter->attr.mmap)
-		atomic_dec(&nr_mmap_counters);
-	if (counter->attr.comm)
-		atomic_dec(&nr_comm_counters);
+	if (!counter->parent) {
+		atomic_dec(&nr_counters);
+		if (counter->attr.mmap)
+			atomic_dec(&nr_mmap_counters);
+		if (counter->attr.comm)
+			atomic_dec(&nr_comm_counters);
+	}
 
 	if (counter->destroy)
 		counter->destroy(counter);
@@ -3515,6 +3517,8 @@ static void sw_perf_counter_destroy(struct perf_counter *counter)
 {
 	u64 event = counter->attr.config;
 
+	WARN_ON(counter->parent);
+
 	atomic_dec(&perf_swcounter_enabled[event]);
 }
 
@@ -3551,8 +3555,10 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
-		atomic_inc(&perf_swcounter_enabled[event]);
-		counter->destroy = sw_perf_counter_destroy;
+		if (!counter->parent) {
+			atomic_inc(&perf_swcounter_enabled[event]);
+			counter->destroy = sw_perf_counter_destroy;
+		}
 		pmu = &perf_ops_generic;
 		break;
 	}
@@ -3663,11 +3669,13 @@ done:
 
 	counter->pmu = pmu;
 
-	atomic_inc(&nr_counters);
-	if (counter->attr.mmap)
-		atomic_inc(&nr_mmap_counters);
-	if (counter->attr.comm)
-		atomic_inc(&nr_comm_counters);
+	if (!counter->parent) {
+		atomic_inc(&nr_counters);
+		if (counter->attr.mmap)
+			atomic_inc(&nr_mmap_counters);
+		if (counter->attr.comm)
+			atomic_inc(&nr_comm_counters);
+	}
 
 	return counter;
 }
