Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbZDGJJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbZDGJJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbZDGJIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:08:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:47017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbZDGJIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:08:32 -0400
Date: Tue, 7 Apr 2009 09:07:49 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094517.812109629@chello.nl>
References: <20090406094517.812109629@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: theres more to overflow than writing events
Message-ID: <tip-f6c7d5fe58b4846ee0cb4b98b6042489705eced4@git.kernel.org>
Git-Commit-ID: f6c7d5fe58b4846ee0cb4b98b6042489705eced4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:07:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6c7d5fe58b4846ee0cb4b98b6042489705eced4
Gitweb:     http://git.kernel.org/tip/f6c7d5fe58b4846ee0cb4b98b6042489705eced4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:56 +0200

perf_counter: theres more to overflow than writing events

Prepare for more generic overflow handling. The new perf_counter_overflow()
method will handle the generic bits of the counter overflow, and can return
a !0 return value, in which case the counter should be (soft) disabled, so
that it won't count until it's properly disabled.

XXX: do powerpc and swcounter

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094517.812109629@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    2 +-
 arch/x86/kernel/cpu/perf_counter.c |    3 ++-
 include/linux/perf_counter.h       |    4 ++--
 kernel/perf_counter.c              |   29 +++++++++++++++++++++++------
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 0a4d14f..f88c35d 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -732,7 +732,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	 * Finally record data if requested.
 	 */
 	if (record)
-		perf_counter_output(counter, 1, regs);
+		perf_counter_overflow(counter, 1, regs);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 4384158..1116a41 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -800,7 +800,8 @@ again:
 			continue;
 
 		perf_save_and_restart(counter);
-		perf_counter_output(counter, nmi, regs);
+		if (perf_counter_overflow(counter, nmi, regs))
+			__pmc_generic_disable(counter, &counter->hw, bit);
 	}
 
 	hw_perf_ack_status(ack);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 977fb15..ca2d4df 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -491,8 +491,8 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_counter_context *ctx, int cpu);
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
-extern void perf_counter_output(struct perf_counter *counter,
-				int nmi, struct pt_regs *regs);
+extern int perf_counter_overflow(struct perf_counter *counter,
+				 int nmi, struct pt_regs *regs);
 /*
  * Return 1 for a software counter, 0 for a hardware counter
  */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0a2ade2..195e976 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1800,8 +1800,8 @@ static void perf_output_end(struct perf_output_handle *handle)
 	rcu_read_unlock();
 }
 
-void perf_counter_output(struct perf_counter *counter,
-			 int nmi, struct pt_regs *regs)
+static void perf_counter_output(struct perf_counter *counter,
+				int nmi, struct pt_regs *regs)
 {
 	int ret;
 	u64 record_type = counter->hw_event.record_type;
@@ -2034,6 +2034,17 @@ void perf_counter_munmap(unsigned long addr, unsigned long len,
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
 
@@ -2077,6 +2088,7 @@ static void perf_swcounter_set_period(struct perf_counter *counter)
 
 static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 {
+	enum hrtimer_restart ret = HRTIMER_RESTART;
 	struct perf_counter *counter;
 	struct pt_regs *regs;
 
@@ -2092,12 +2104,14 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
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
@@ -2105,7 +2119,10 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
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
