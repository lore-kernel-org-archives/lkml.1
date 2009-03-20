Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZCTK2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZCTK2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762352AbZCTK0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:26:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:35247 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762346AbZCTK0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:26:18 -0400
Date: Fri, 20 Mar 2009 10:25:34 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.929962222@chello.nl>
References: <20090319194233.929962222@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: unify irq output code
Message-ID: <tip-37dda04c68bf043ddd3ebe13fbf7bae491f5da6d@git.kernel.org>
Git-Commit-ID: 37dda04c68bf043ddd3ebe13fbf7bae491f5da6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:25:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37dda04c68bf043ddd3ebe13fbf7bae491f5da6d
Gitweb:     http://git.kernel.org/tip/37dda04c68bf043ddd3ebe13fbf7bae491f5da6d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:15:14 +0100

perf_counter: unify irq output code

Impact: cleanup

Having 3 slightly different copies of the same code around does nobody
any good. First step in revamping the output format.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.929962222@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   51 +-----------------
 arch/x86/kernel/cpu/perf_counter.c |   53 +------------------
 include/linux/perf_counter.h       |    2 +
 kernel/perf_counter.c              |  106 +++++++++++++++++++-----------------
 4 files changed, 61 insertions(+), 151 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 26f69dc..88b72eb 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -663,41 +663,6 @@ void perf_counter_do_pending(void)
 }
 
 /*
- * Record data for an irq counter.
- * This function was lifted from the x86 code; maybe it should
- * go in the core?
- */
-static void perf_store_irq_data(struct perf_counter *counter, u64 data)
-{
-	struct perf_data *irqdata = counter->irqdata;
-
-	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
-		irqdata->overrun++;
-	} else {
-		u64 *p = (u64 *) &irqdata->data[irqdata->len];
-
-		*p = data;
-		irqdata->len += sizeof(u64);
-	}
-}
-
-/*
- * Record all the values of the counters in a group
- */
-static void perf_handle_group(struct perf_counter *counter)
-{
-	struct perf_counter *leader, *sub;
-
-	leader = counter->group_leader;
-	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-		if (sub != counter)
-			sub->hw_ops->read(sub);
-		perf_store_irq_data(counter, sub->hw_event.event_config);
-		perf_store_irq_data(counter, atomic64_read(&sub->count));
-	}
-}
-
-/*
  * A counter has overflowed; update its count and record
  * things if requested.  Note that interrupts are hard-disabled
  * here so there is no possibility of being interrupted.
@@ -736,20 +701,8 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	/*
 	 * Finally record data if requested.
 	 */
-	if (record) {
-		switch (counter->hw_event.record_type) {
-		case PERF_RECORD_SIMPLE:
-			break;
-		case PERF_RECORD_IRQ:
-			perf_store_irq_data(counter, instruction_pointer(regs));
-			counter->wakeup_pending = 1;
-			break;
-		case PERF_RECORD_GROUP:
-			perf_handle_group(counter);
-			counter->wakeup_pending = 1;
-			break;
-		}
-	}
+	if (record)
+		perf_counter_output(counter, 1, regs);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d844ae4..902282d 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -674,20 +674,6 @@ static void pmc_generic_disable(struct perf_counter *counter)
 	x86_perf_counter_update(counter, hwc, idx);
 }
 
-static void perf_store_irq_data(struct perf_counter *counter, u64 data)
-{
-	struct perf_data *irqdata = counter->irqdata;
-
-	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
-		irqdata->overrun++;
-	} else {
-		u64 *p = (u64 *) &irqdata->data[irqdata->len];
-
-		*p = data;
-		irqdata->len += sizeof(u64);
-	}
-}
-
 /*
  * Save and restart an expired counter. Called by NMI contexts,
  * so it has to be careful about preempting normal counter ops:
@@ -704,22 +690,6 @@ static void perf_save_and_restart(struct perf_counter *counter)
 		__pmc_generic_enable(counter, hwc, idx);
 }
 
-static void
-perf_handle_group(struct perf_counter *sibling, u64 *status, u64 *overflown)
-{
-	struct perf_counter *counter, *group_leader = sibling->group_leader;
-
-	/*
-	 * Store sibling timestamps (if any):
-	 */
-	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
-
-		x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
-		perf_store_irq_data(sibling, counter->hw_event.event_config);
-		perf_store_irq_data(sibling, atomic64_read(&counter->count));
-	}
-}
-
 /*
  * Maximum interrupt frequency of 100KHz per CPU
  */
@@ -754,28 +724,7 @@ again:
 			continue;
 
 		perf_save_and_restart(counter);
-
-		switch (counter->hw_event.record_type) {
-		case PERF_RECORD_SIMPLE:
-			continue;
-		case PERF_RECORD_IRQ:
-			perf_store_irq_data(counter, instruction_pointer(regs));
-			break;
-		case PERF_RECORD_GROUP:
-			perf_handle_group(counter, &status, &ack);
-			break;
-		}
-		/*
-		 * From NMI context we cannot call into the scheduler to
-		 * do a task wakeup - but we mark these generic as
-		 * wakeup_pending and initate a wakeup callback:
-		 */
-		if (nmi) {
-			counter->wakeup_pending = 1;
-			set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
-		} else {
-			wake_up(&counter->waitq);
-		}
+		perf_counter_output(counter, nmi, regs);
 	}
 
 	hw_perf_ack_status(ack);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 8f93949..a4b76c0 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -317,6 +317,8 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx, int cpu);
 
+extern void perf_counter_output(struct perf_counter *counter,
+				int nmi, struct pt_regs *regs);
 /*
  * Return 1 for a software counter, 0 for a hardware counter
  */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 68a56a6..f054b8c 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1354,6 +1354,60 @@ static const struct file_operations perf_fops = {
 };
 
 /*
+ * Output
+ */
+
+static void perf_counter_store_irq(struct perf_counter *counter, u64 data)
+{
+	struct perf_data *irqdata = counter->irqdata;
+
+	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
+		irqdata->overrun++;
+	} else {
+		u64 *p = (u64 *) &irqdata->data[irqdata->len];
+
+		*p = data;
+		irqdata->len += sizeof(u64);
+	}
+}
+
+static void perf_counter_handle_group(struct perf_counter *counter)
+{
+	struct perf_counter *leader, *sub;
+
+	leader = counter->group_leader;
+	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+		if (sub != counter)
+			sub->hw_ops->read(sub);
+		perf_counter_store_irq(counter, sub->hw_event.event_config);
+		perf_counter_store_irq(counter, atomic64_read(&sub->count));
+	}
+}
+
+void perf_counter_output(struct perf_counter *counter,
+			 int nmi, struct pt_regs *regs)
+{
+	switch (counter->hw_event.record_type) {
+	case PERF_RECORD_SIMPLE:
+		return;
+
+	case PERF_RECORD_IRQ:
+		perf_counter_store_irq(counter, instruction_pointer(regs));
+		break;
+
+	case PERF_RECORD_GROUP:
+		perf_counter_handle_group(counter);
+		break;
+	}
+
+	if (nmi) {
+		counter->wakeup_pending = 1;
+		set_perf_counter_pending();
+	} else
+		wake_up(&counter->waitq);
+}
+
+/*
  * Generic software counter infrastructure
  */
 
@@ -1395,54 +1449,6 @@ static void perf_swcounter_set_period(struct perf_counter *counter)
 	atomic64_set(&hwc->count, -left);
 }
 
-static void perf_swcounter_store_irq(struct perf_counter *counter, u64 data)
-{
-	struct perf_data *irqdata = counter->irqdata;
-
-	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
-		irqdata->overrun++;
-	} else {
-		u64 *p = (u64 *) &irqdata->data[irqdata->len];
-
-		*p = data;
-		irqdata->len += sizeof(u64);
-	}
-}
-
-static void perf_swcounter_handle_group(struct perf_counter *sibling)
-{
-	struct perf_counter *counter, *group_leader = sibling->group_leader;
-
-	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
-		counter->hw_ops->read(counter);
-		perf_swcounter_store_irq(sibling, counter->hw_event.event_config);
-		perf_swcounter_store_irq(sibling, atomic64_read(&counter->count));
-	}
-}
-
-static void perf_swcounter_interrupt(struct perf_counter *counter,
-				     int nmi, struct pt_regs *regs)
-{
-	switch (counter->hw_event.record_type) {
-	case PERF_RECORD_SIMPLE:
-		break;
-
-	case PERF_RECORD_IRQ:
-		perf_swcounter_store_irq(counter, instruction_pointer(regs));
-		break;
-
-	case PERF_RECORD_GROUP:
-		perf_swcounter_handle_group(counter);
-		break;
-	}
-
-	if (nmi) {
-		counter->wakeup_pending = 1;
-		set_perf_counter_pending();
-	} else
-		wake_up(&counter->waitq);
-}
-
 static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 {
 	struct perf_counter *counter;
@@ -1461,7 +1467,7 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 		regs = task_pt_regs(current);
 
 	if (regs)
-		perf_swcounter_interrupt(counter, 0, regs);
+		perf_counter_output(counter, 0, regs);
 
 	hrtimer_forward_now(hrtimer, ns_to_ktime(counter->hw.irq_period));
 
@@ -1473,7 +1479,7 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 {
 	perf_swcounter_update(counter);
 	perf_swcounter_set_period(counter);
-	perf_swcounter_interrupt(counter, nmi, regs);
+	perf_counter_output(counter, nmi, regs);
 }
 
 static int perf_swcounter_match(struct perf_counter *counter,
