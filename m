Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZKUNnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZKUNnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZKUNnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:43:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:60938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZKUNnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:43:18 -0500
Date: Sat, 21 Nov 2009 13:42:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.863685796@chello.nl>
References: <20091120212508.863685796@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize __perf_event_read()
Message-ID: <tip-f6f83785222b0ee037f7be90731f62a649292b5e@git.kernel.org>
Git-Commit-ID: f6f83785222b0ee037f7be90731f62a649292b5e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6f83785222b0ee037f7be90731f62a649292b5e
Gitweb:     http://git.kernel.org/tip/f6f83785222b0ee037f7be90731f62a649292b5e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:38 +0100

perf: Optimize __perf_event_read()

Both callers actually have IRQs disabled, no need doing so
again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.863685796@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 65f4dab..e66f6c4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1517,7 +1517,6 @@ static void __perf_event_read(void *info)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
-	unsigned long flags;
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -1529,12 +1528,10 @@ static void __perf_event_read(void *info)
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	local_irq_save(flags);
 	if (ctx->is_active)
 		update_context_time(ctx);
 	event->pmu->read(event);
 	update_event_times(event);
-	local_irq_restore(flags);
 }
 
 static u64 perf_event_read(struct perf_event *event)
