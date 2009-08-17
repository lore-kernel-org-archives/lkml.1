Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZHQJkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZHQJkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZHQJkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:40:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZHQJkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:40:05 -0400
Date: Mon, 17 Aug 2009 09:39:35 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
References: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
Subject: [tip:perfcounters/urgent] perf_counter: Check task on counter read IPI
Message-ID: <tip-e1ac3614ff606ae03677f47459113f98a19af63c@git.kernel.org>
Git-Commit-ID: e1ac3614ff606ae03677f47459113f98a19af63c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 09:39:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1ac3614ff606ae03677f47459113f98a19af63c
Gitweb:     http://git.kernel.org/tip/e1ac3614ff606ae03677f47459113f98a19af63c
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Fri, 14 Aug 2009 15:39:10 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 11:38:13 +0200

perf_counter: Check task on counter read IPI

In general, code in perf_counter.c that is called through an
IPI checks, for per-task counters, that the counter's task is
still the current task.  This is to handle the race condition
where the cpu switches from the task we want to another task in
the interval between sending the IPI and the IPI arriving and
being handled on the target CPU.

For some reason, __perf_counter_read is missing this check, yet
there is no reason why the race condition can't occur.  This
adds a check that the current task is the one we want.  If it
isn't, we just return.  In that case the counter->count value
should be up to date, since it will have been updated when the
counter was scheduled out, which must have happened since the
IPI was sent.

I don't have an example of an actual failure due to this race,
but it seems obvious that it could occur and we need to guard
against it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 534e20d..b8fe739 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1503,10 +1503,21 @@ static void perf_counter_enable_on_exec(struct task_struct *task)
  */
 static void __perf_counter_read(void *info)
 {
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter *counter = info;
 	struct perf_counter_context *ctx = counter->ctx;
 	unsigned long flags;
 
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu.  If not it has been
+	 * scheduled out before the smp call arrived.  In that case
+	 * counter->count would have been updated to a recent sample
+	 * when the counter was scheduled out.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
 	local_irq_save(flags);
 	if (ctx->is_active)
 		update_context_time(ctx);
