Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZHNFjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZHNFjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZHNFjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:39:20 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50369 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZHNFjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:39:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
Date: Fri, 14 Aug 2009 15:39:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Check task on counter read IPI
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, code in perf_counter.c that is called through an IPI
checks, for per-task counters, that the counter's task is still the
current task.  This is to handle the race condition where the cpu
switches from the task we want to another task in the interval between
sending the IPI and the IPI arriving and being handled on the target
CPU.

For some reason, __perf_counter_read is missing this check, yet there
is no reason why the race condition can't occur.  This adds a check
that the current task is the one we want.  If it isn't, we just
return.  In that case the counter->count value should be up to date,
since it will have been updated when the counter was scheduled out,
which must have happened since the IPI was sent.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
I don't have an example of an actual failure due to this race, but it
seems obvious that it could occur and we need to guard against it, so
I think this should go in .31.

 kernel/perf_counter.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

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
