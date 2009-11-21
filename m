Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZKUNnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZKUNnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZKUNnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:43:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:60934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbZKUNnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:43:18 -0500
Date: Sat, 21 Nov 2009 13:42:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.779516394@chello.nl>
References: <20091120212508.779516394@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize perf_event_task_sched_out
Message-ID: <tip-02ffdbc866c8b1c8644601e9aa6155700eed4c91@git.kernel.org>
Git-Commit-ID: 02ffdbc866c8b1c8644601e9aa6155700eed4c91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02ffdbc866c8b1c8644601e9aa6155700eed4c91
Gitweb:     http://git.kernel.org/tip/02ffdbc866c8b1c8644601e9aa6155700eed4c91
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:50 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:38 +0100

perf: Optimize perf_event_task_sched_out

Remove an update_context_time() call from the
perf_event_task_sched_out() path and into the branch its needed.

The call was both superfluous, because __perf_event_sched_out()
already does it, and wrong, because it was done without holding
ctx->lock.

Place it in perf_event_sync_stat(), which is the only place it
is needed and which does already hold ctx->lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.779516394@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9a18ff2..65f4dab 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1120,6 +1120,8 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 	if (!ctx->nr_stat)
 		return;
 
+	update_context_time(ctx);
+
 	event = list_first_entry(&ctx->event_list,
 				   struct perf_event, event_entry);
 
@@ -1163,8 +1165,6 @@ void perf_event_task_sched_out(struct task_struct *task,
 	if (likely(!ctx || !cpuctx->task_ctx))
 		return;
 
-	update_context_time(ctx);
-
 	rcu_read_lock();
 	parent = rcu_dereference(ctx->parent_ctx);
 	next_ctx = next->perf_event_ctxp;
