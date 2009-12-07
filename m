Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZLGGXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZLGGXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZLGGXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:23:03 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35503 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZLGGW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:22:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aRASY6xCyrrPaD8JBBL3lIoqcPUddygDL7zmevwqCyQj8/J/PLCqeCne+63ZaCmyIP
         N+v8USjWR4BaioGbUgmP4wtZtx0HLz96CH1ghMbSTuD33FVWrNqZZ+o1g3h7aNPQuBTh
         ZGebLmGOFqpEceVRSK2Gkvs3HoxUKuxOyTTlo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Walt <w41ter@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 2/2] hw-breakpoints: Fix task-bound breakpoint slot allocation
Date: Mon,  7 Dec 2009 07:22:57 +0100
Message-Id: <1260166977-5894-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260166977-5894-1-git-send-regression-fweisbec@gmail.com>
References: <1260166977-5894-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whatever the context nature of a breakpoint, we always perform the
following constraint checks before allocating it a slot:

- Check the number of pinned breakpoint bound the concerned cpus
- Check the max number of task-bound breakpoints that are belonging
  to a task.
- Add both and see if we have a reamining slot for the new breakpoint

This is the right thing to do when we are about to register a cpu-only
bound breakpoint. But not if we are dealing with a task bound
breakpoint. What we want in this case is:

- Check the number of pinned breakpoint bound the concerned cpus
- Check the number of breakpoints that already belong to the task
  in which the breakpoint to register is bound to.
- Add both

This fixes a regression that makes the "firefox -g" command fail to
register breakpoints once we deal with a secondary thread.

Reported-by: Walt <w41ter@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/hw_breakpoint.c |   74 +++++++++++++++++++++++++++++-------------------
 1 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index b600fc2..02b4925 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -83,15 +83,51 @@ static unsigned int max_task_bp_pinned(int cpu)
 	return 0;
 }
 
+static int task_bp_pinned(struct task_struct *tsk)
+{
+	struct perf_event_context *ctx = tsk->perf_event_ctxp;
+	struct list_head *list;
+	struct perf_event *bp;
+	unsigned long flags;
+	int count = 0;
+
+	if (WARN_ONCE(!ctx, "No perf context for this task"))
+		return 0;
+
+	list = &ctx->event_list;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	/*
+	 * The current breakpoint counter is not included in the list
+	 * at the open() callback time
+	 */
+	list_for_each_entry(bp, list, event_entry) {
+		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
+			count++;
+	}
+
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return count;
+}
+
 /*
  * Report the number of pinned/un-pinned breakpoints we have in
  * a given cpu (cpu > -1) or in all of them (cpu = -1).
  */
-static void fetch_bp_busy_slots(struct bp_busy_slots *slots, int cpu)
+static void
+fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp)
 {
+	int cpu = bp->cpu;
+	struct task_struct *tsk = bp->ctx->task;
+
 	if (cpu >= 0) {
 		slots->pinned = per_cpu(nr_cpu_bp_pinned, cpu);
-		slots->pinned += max_task_bp_pinned(cpu);
+		if (!tsk)
+			slots->pinned += max_task_bp_pinned(cpu);
+		else
+			slots->pinned += task_bp_pinned(tsk);
 		slots->flexible = per_cpu(nr_bp_flexible, cpu);
 
 		return;
@@ -101,7 +137,10 @@ static void fetch_bp_busy_slots(struct bp_busy_slots *slots, int cpu)
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned, cpu);
-		nr += max_task_bp_pinned(cpu);
+		if (!tsk)
+			nr += max_task_bp_pinned(cpu);
+		else
+			nr += task_bp_pinned(tsk);
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
@@ -118,33 +157,10 @@ static void fetch_bp_busy_slots(struct bp_busy_slots *slots, int cpu)
  */
 static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
 {
-	int count = 0;
-	struct perf_event *bp;
-	struct perf_event_context *ctx = tsk->perf_event_ctxp;
 	unsigned int *tsk_pinned;
-	struct list_head *list;
-	unsigned long flags;
-
-	if (WARN_ONCE(!ctx, "No perf context for this task"))
-		return;
-
-	list = &ctx->event_list;
-
-	spin_lock_irqsave(&ctx->lock, flags);
-
-	/*
-	 * The current breakpoint counter is not included in the list
-	 * at the open() callback time
-	 */
-	list_for_each_entry(bp, list, event_entry) {
-		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
-			count++;
-	}
-
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	int count = 0;
 
-	if (WARN_ONCE(count < 0, "No breakpoint counter found in the counter list"))
-		return;
+	count = task_bp_pinned(tsk);
 
 	tsk_pinned = per_cpu(task_bp_pinned, cpu);
 	if (enable) {
@@ -233,7 +249,7 @@ int reserve_bp_slot(struct perf_event *bp)
 
 	mutex_lock(&nr_bp_mutex);
 
-	fetch_bp_busy_slots(&slots, bp->cpu);
+	fetch_bp_busy_slots(&slots, bp);
 
 	/* Flexible counters need to keep at least one slot */
 	if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
-- 
1.6.2.3

