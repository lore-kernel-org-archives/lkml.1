Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZDFJrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZDFJrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZDFJoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbZDFJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:36 -0400
Message-Id: <20090406094517.812109629@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/15] perf_counter: theres more to overflow than writing events
Content-Disposition: inline; filename=perf_counter-overflow.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for more generic overflow handling. The new perf_counter_overflow()
method will handle the generic bits of the counter overflow, and can return
a !0 return value, in which case the counter should be (soft) disabled, so
that it won't count until it's properly disabled.

XXX: do powerpc and swcounter

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_counter.c |    2 +-
 arch/x86/kernel/cpu/perf_counter.c |    3 ++-
 include/linux/perf_counter.h       |    4 ++--
 kernel/perf_counter.c              |   29 +++++++++++++++++++++++------
 4 files changed, 28 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -732,7 +732,7 @@ static void record_and_restart(struct pe
 	 * Finally record data if requested.
 	 */
 	if (record)
-		perf_counter_output(counter, 1, regs);
+		perf_counter_overflow(counter, 1, regs);
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -800,7 +800,8 @@ again:
 			continue;
 
 		perf_save_and_restart(counter);
-		perf_counter_output(counter, nmi, regs);
+		if (perf_counter_overflow(counter, nmi, regs))
+			__pmc_generic_disable(counter, &counter->hw, bit);
 	}
 
 	hw_perf_ack_status(ack);
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -491,8 +491,8 @@ extern int hw_perf_group_sched_in(struct
 	       struct perf_counter_context *ctx, int cpu);
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
-extern void perf_counter_output(struct perf_counter *counter,
-				int nmi, struct pt_regs *regs);
+extern int perf_counter_overflow(struct perf_counter *counter,
+				 int nmi, struct pt_regs *regs);
 /*
  * Return 1 for a software counter, 0 for a hardware counter
  */
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1800,8 +1800,8 @@ static void perf_output_end(struct perf_
 	rcu_read_unlock();
 }
 
-void perf_counter_output(struct perf_counter *counter,
-			 int nmi, struct pt_regs *regs)
+static void perf_counter_output(struct perf_counter *counter,
+				int nmi, struct pt_regs *regs)
 {
 	int ret;
 	u64 record_type = counter->hw_event.record_type;
@@ -2034,6 +2034,17 @@ void perf_counter_munmap(unsigned long a
 }
 
 /*
+ * Generic counter overflow handling.
+ */
+
+int perf_counter_overflow(struct perf_counter *counter,
+			  int nmi, struct pt_regs *regs)
+{
+	perf_counter_output(counter, nmi, regs);
+	return 0;
+}
+
+/*
  * Generic software counter infrastructure
  */
 
@@ -2077,6 +2088,7 @@ static void perf_swcounter_set_period(st
 
 static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 {
+	enum hrtimer_restart ret = HRTIMER_RESTART;
 	struct perf_counter *counter;
 	struct pt_regs *regs;
 
@@ -2092,12 +2104,14 @@ static enum hrtimer_restart perf_swcount
 			!counter->hw_event.exclude_user)
 		regs = task_pt_regs(current);
 
-	if (regs)
-		perf_counter_output(counter, 0, regs);
+	if (regs) {
+		if (perf_counter_overflow(counter, 0, regs))
+			ret = HRTIMER_NORESTART;
+	}
 
 	hrtimer_forward_now(hrtimer, ns_to_ktime(counter->hw.irq_period));
 
-	return HRTIMER_RESTART;
+	return ret;
 }
 
 static void perf_swcounter_overflow(struct perf_counter *counter,
@@ -2105,7 +2119,10 @@ static void perf_swcounter_overflow(stru
 {
 	perf_swcounter_update(counter);
 	perf_swcounter_set_period(counter);
-	perf_counter_output(counter, nmi, regs);
+	if (perf_counter_overflow(counter, nmi, regs))
+		/* soft-disable the counter */
+		;
+
 }
 
 static int perf_swcounter_match(struct perf_counter *counter,

-- 

