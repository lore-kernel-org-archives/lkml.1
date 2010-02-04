Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0BDJ5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:57:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:60141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108Ab0BDJ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:57:21 -0500
Date: Thu, 4 Feb 2010 09:56:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Optimize perf_event_task_tick()
Message-ID: <tip-9717e6cd3db22eade7dbae0fc9235c66325a7132@git.kernel.org>
Git-Commit-ID: 9717e6cd3db22eade7dbae0fc9235c66325a7132
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:56:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9717e6cd3db22eade7dbae0fc9235c66325a7132
Gitweb:     http://git.kernel.org/tip/9717e6cd3db22eade7dbae0fc9235c66325a7132
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 28 Jan 2010 13:57:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:59:49 +0100

perf_events: Optimize perf_event_task_tick()

Pretty much all of the calls do perf_disable/perf_enable cycles, pull
that out to cut back on hardware programming.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 40f8b07..087025f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1573,12 +1573,8 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	raw_spin_lock(&ctx->lock);
 
 	/* Rotate the first entry last of non-pinned groups */
-	perf_disable();
-
 	list_rotate_left(&ctx->flexible_groups);
 
-	perf_enable();
-
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1593,6 +1589,8 @@ void perf_event_task_tick(struct task_struct *curr)
 	cpuctx = &__get_cpu_var(perf_cpu_context);
 	ctx = curr->perf_event_ctxp;
 
+	perf_disable();
+
 	perf_ctx_adjust_freq(&cpuctx->ctx);
 	if (ctx)
 		perf_ctx_adjust_freq(ctx);
@@ -1608,6 +1606,8 @@ void perf_event_task_tick(struct task_struct *curr)
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
+
+	perf_enable();
 }
 
 static int event_enable_on_exec(struct perf_event *event,
