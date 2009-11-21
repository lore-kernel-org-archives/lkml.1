Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZKUNoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZKUNoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZKUNoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:44:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:60999 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbZKUNoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:44:14 -0500
Date: Sat, 21 Nov 2009 13:43:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212509.102316434@chello.nl>
References: <20091120212509.102316434@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix time locking
Message-ID: <tip-2b8988c9f7defe319cffe0cd362a7cd356c86f62@git.kernel.org>
Git-Commit-ID: 2b8988c9f7defe319cffe0cd362a7cd356c86f62
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b8988c9f7defe319cffe0cd362a7cd356c86f62
Gitweb:     http://git.kernel.org/tip/2b8988c9f7defe319cffe0cd362a7cd356c86f62
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:39 +0100

perf: Fix time locking

Most sites updating ctx->time and event times do so under
ctx->lock, make sure they all do.

This was made possible by removing the __perf_event_read() call
from __perf_event_sync_stat(), which already had this lock
taken.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212509.102316434@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 028619d..fdfae88 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1526,8 +1526,11 @@ static void __perf_event_read(void *info)
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
+	spin_lock(&ctx->lock);
 	update_context_time(ctx);
 	update_event_times(event);
+	spin_unlock(&ctx->lock);
+
 	event->pmu->read(event);
 }
 
@@ -1541,7 +1544,13 @@ static u64 perf_event_read(struct perf_event *event)
 		smp_call_function_single(event->oncpu,
 					 __perf_event_read, event, 1);
 	} else if (event->state == PERF_EVENT_STATE_INACTIVE) {
+		struct perf_event_context *ctx = event->ctx;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->lock, flags);
+		update_context_time(ctx);
 		update_event_times(event);
+		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
 	return atomic64_read(&event->count);
