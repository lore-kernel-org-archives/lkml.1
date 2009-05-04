Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbZEDReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbZEDReg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbZEDReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:34:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:54694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbZEDReI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:34:08 -0400
Date: Mon, 4 May 2009 17:33:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: round-robin per-CPU counters too
Message-ID: <tip-b82914ce33146186d554b0f5c41e4e13693614ce@git.kernel.org>
Git-Commit-ID: b82914ce33146186d554b0f5c41e4e13693614ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 17:33:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b82914ce33146186d554b0f5c41e4e13693614ce
Gitweb:     http://git.kernel.org/tip/b82914ce33146186d554b0f5c41e4e13693614ce
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 4 May 2009 18:54:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 May 2009 19:29:57 +0200

perf_counter: round-robin per-CPU counters too

This used to be unstable when we had the rq->lock dependencies,
but now that they are that of the past we can turn on percpu
counter RR too.

[ Impact: handle counter over-commit for per-CPU counters too ]

LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8660ae5..b9679c3 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1069,18 +1069,14 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
 	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
-	const int rotate_percpu = 0;
 
-	if (rotate_percpu)
-		perf_counter_cpu_sched_out(cpuctx);
+	perf_counter_cpu_sched_out(cpuctx);
 	perf_counter_task_sched_out(curr, cpu);
 
-	if (rotate_percpu)
-		rotate_ctx(&cpuctx->ctx);
+	rotate_ctx(&cpuctx->ctx);
 	rotate_ctx(ctx);
 
-	if (rotate_percpu)
-		perf_counter_cpu_sched_in(cpuctx, cpu);
+	perf_counter_cpu_sched_in(cpuctx, cpu);
 	perf_counter_task_sched_in(curr, cpu);
 }
 
