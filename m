Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZEYNFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZEYNFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZEYNEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:04:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:53310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbZEYNEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:04:40 -0400
Date: Mon, 25 May 2009 13:04:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525124600.419025548@chello.nl>
References: <20090525124600.419025548@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Fix PERF_COUNTER_CONTEXT_SWITCHES for cpu counters
Message-ID: <tip-10989fb2451763fae6f42d85fa6106c8fd010cf5@git.kernel.org>
Git-Commit-ID: 10989fb2451763fae6f42d85fa6106c8fd010cf5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 13:04:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10989fb2451763fae6f42d85fa6106c8fd010cf5
Gitweb:     http://git.kernel.org/tip/10989fb2451763fae6f42d85fa6106c8fd010cf5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 May 2009 14:45:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 14:55:01 +0200

perf_counter: Fix PERF_COUNTER_CONTEXT_SWITCHES for cpu counters

Ingo noticed that cpu counters had 0 context switches, even though
there was plenty scheduling on the cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525124600.419025548@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7a7a144..14b1fe9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -924,14 +924,13 @@ void perf_counter_task_sched_out(struct task_struct *task,
 	struct perf_counter_context *next_ctx;
 	struct pt_regs *regs;
 
+	regs = task_pt_regs(task);
+	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
+
 	if (likely(!ctx || !cpuctx->task_ctx))
 		return;
 
 	update_context_time(ctx);
-
-	regs = task_pt_regs(task);
-	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
-
 	next_ctx = next->perf_counter_ctxp;
 	if (next_ctx && context_equiv(ctx, next_ctx)) {
 		task->perf_counter_ctxp = next_ctx;
