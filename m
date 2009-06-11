Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZFKApC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZFKApC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761378AbZFKAox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:44:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:59628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760919AbZFKAow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:44:52 -0400
Date: Thu, 11 Jun 2009 00:43:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Introduce struct for sample data
Message-ID: <tip-df1a132bf3d3508f863336c80a27806a2ac947e0@git.kernel.org>
Git-Commit-ID: df1a132bf3d3508f863336c80a27806a2ac947e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 00:43:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df1a132bf3d3508f863336c80a27806a2ac947e0
Gitweb:     http://git.kernel.org/tip/df1a132bf3d3508f863336c80a27806a2ac947e0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Jun 2009 21:02:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Jun 2009 02:39:02 +0200

perf_counter: Introduce struct for sample data

For easy extension of the sample data, put it in a structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   10 ++++++--
 arch/x86/kernel/cpu/perf_counter.c |   15 ++++++++++---
 include/linux/perf_counter.h       |   10 +++++++-
 kernel/perf_counter.c              |   38 ++++++++++++++++++++---------------
 4 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 4786ad9..5e0bf39 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1001,7 +1001,11 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	 * Finally record data if requested.
 	 */
 	if (record) {
-		addr = 0;
+		struct perf_sample_data data = {
+			.regs = regs,
+			.addr = 0,
+		};
+
 		if (counter->attr.sample_type & PERF_SAMPLE_ADDR) {
 			/*
 			 * The user wants a data address recorded.
@@ -1016,9 +1020,9 @@ static void record_and_restart(struct perf_counter *counter, long val,
 			sdsync = (ppmu->flags & PPMU_ALT_SIPR) ?
 				POWER6_MMCRA_SDSYNC : MMCRA_SDSYNC;
 			if (!(mmcra & MMCRA_SAMPLE_ENABLE) || (mmcra & sdsync))
-				addr = mfspr(SPRN_SDAR);
+				data.addr = mfspr(SPRN_SDAR);
 		}
-		if (perf_counter_overflow(counter, nmi, regs, addr)) {
+		if (perf_counter_overflow(counter, nmi, &data)) {
 			/*
 			 * Interrupts are coming too fast - throttle them
 			 * by setting the counter to 0, so it will be
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 240ca56..82a23d4 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1173,11 +1173,14 @@ static void intel_pmu_reset(void)
  */
 static int intel_pmu_handle_irq(struct pt_regs *regs)
 {
+	struct perf_sample_data data;
 	struct cpu_hw_counters *cpuc;
-	struct cpu_hw_counters;
 	int bit, cpu, loops;
 	u64 ack, status;
 
+	data.regs = regs;
+	data.addr = 0;
+
 	cpu = smp_processor_id();
 	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
@@ -1210,7 +1213,7 @@ again:
 		if (!intel_pmu_save_and_restart(counter))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, regs, 0))
+		if (perf_counter_overflow(counter, 1, &data))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
 
@@ -1230,12 +1233,16 @@ again:
 
 static int amd_pmu_handle_irq(struct pt_regs *regs)
 {
-	int cpu, idx, handled = 0;
+	struct perf_sample_data data;
 	struct cpu_hw_counters *cpuc;
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
+	int cpu, idx, handled = 0;
 	u64 val;
 
+	data.regs = regs;
+	data.addr = 0;
+
 	cpu = smp_processor_id();
 	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
@@ -1256,7 +1263,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, regs, 0))
+		if (perf_counter_overflow(counter, 1, &data))
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 282d8cc..d8c0eb4 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -605,8 +605,14 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_counter_context *ctx, int cpu);
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
-extern int perf_counter_overflow(struct perf_counter *counter,
-				 int nmi, struct pt_regs *regs, u64 addr);
+struct perf_sample_data {
+	struct pt_regs	*regs;
+	u64		addr;
+};
+
+extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
+				 struct perf_sample_data *data);
+
 /*
  * Return 1 for a software counter, 0 for a hardware counter
  */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ae591a1..4fe85e8 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2378,8 +2378,8 @@ static u32 perf_counter_tid(struct perf_counter *counter, struct task_struct *p)
 	return task_pid_nr_ns(p, counter->ns);
 }
 
-static void perf_counter_output(struct perf_counter *counter,
-				int nmi, struct pt_regs *regs, u64 addr)
+static void perf_counter_output(struct perf_counter *counter, int nmi,
+				struct perf_sample_data *data)
 {
 	int ret;
 	u64 sample_type = counter->attr.sample_type;
@@ -2404,10 +2404,10 @@ static void perf_counter_output(struct perf_counter *counter,
 	header.size = sizeof(header);
 
 	header.misc = PERF_EVENT_MISC_OVERFLOW;
-	header.misc |= perf_misc_flags(regs);
+	header.misc |= perf_misc_flags(data->regs);
 
 	if (sample_type & PERF_SAMPLE_IP) {
-		ip = perf_instruction_pointer(regs);
+		ip = perf_instruction_pointer(data->regs);
 		header.type |= PERF_SAMPLE_IP;
 		header.size += sizeof(ip);
 	}
@@ -2460,7 +2460,7 @@ static void perf_counter_output(struct perf_counter *counter,
 	}
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		callchain = perf_callchain(regs);
+		callchain = perf_callchain(data->regs);
 
 		if (callchain) {
 			callchain_size = (1 + callchain->nr) * sizeof(u64);
@@ -2486,7 +2486,7 @@ static void perf_counter_output(struct perf_counter *counter,
 		perf_output_put(&handle, time);
 
 	if (sample_type & PERF_SAMPLE_ADDR)
-		perf_output_put(&handle, addr);
+		perf_output_put(&handle, data->addr);
 
 	if (sample_type & PERF_SAMPLE_ID)
 		perf_output_put(&handle, counter->id);
@@ -2950,8 +2950,8 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
  * Generic counter overflow handling.
  */
 
-int perf_counter_overflow(struct perf_counter *counter,
-			  int nmi, struct pt_regs *regs, u64 addr)
+int perf_counter_overflow(struct perf_counter *counter, int nmi,
+			  struct perf_sample_data *data)
 {
 	int events = atomic_read(&counter->event_limit);
 	int throttle = counter->pmu->unthrottle != NULL;
@@ -3005,7 +3005,7 @@ int perf_counter_overflow(struct perf_counter *counter,
 			perf_counter_disable(counter);
 	}
 
-	perf_counter_output(counter, nmi, regs, addr);
+	perf_counter_output(counter, nmi, data);
 	return ret;
 }
 
@@ -3054,24 +3054,25 @@ static void perf_swcounter_set_period(struct perf_counter *counter)
 static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 {
 	enum hrtimer_restart ret = HRTIMER_RESTART;
+	struct perf_sample_data data;
 	struct perf_counter *counter;
-	struct pt_regs *regs;
 	u64 period;
 
 	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
 	counter->pmu->read(counter);
 
-	regs = get_irq_regs();
+	data.addr = 0;
+	data.regs = get_irq_regs();
 	/*
 	 * In case we exclude kernel IPs or are somehow not in interrupt
 	 * context, provide the next best thing, the user IP.
 	 */
-	if ((counter->attr.exclude_kernel || !regs) &&
+	if ((counter->attr.exclude_kernel || !data.regs) &&
 			!counter->attr.exclude_user)
-		regs = task_pt_regs(current);
+		data.regs = task_pt_regs(current);
 
-	if (regs) {
-		if (perf_counter_overflow(counter, 0, regs, 0))
+	if (data.regs) {
+		if (perf_counter_overflow(counter, 0, &data))
 			ret = HRTIMER_NORESTART;
 	}
 
@@ -3084,9 +3085,14 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 static void perf_swcounter_overflow(struct perf_counter *counter,
 				    int nmi, struct pt_regs *regs, u64 addr)
 {
+	struct perf_sample_data data = {
+		.regs = regs,
+		.addr = addr,
+	};
+
 	perf_swcounter_update(counter);
 	perf_swcounter_set_period(counter);
-	if (perf_counter_overflow(counter, nmi, regs, addr))
+	if (perf_counter_overflow(counter, nmi, &data))
 		/* soft-disable the counter */
 		;
 
