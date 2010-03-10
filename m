Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0CJNLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:11:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:59012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0CJNK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:10:57 -0500
Date: Wed, 10 Mar 2010 13:09:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       jamie.iles@picochip.com, jpihet@mvista.com, davem@davemloft.net,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       eranian@google.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jamie.iles@picochip.com, jpihet@mvista.com,
       davem@davemloft.net, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.315416040@chello.nl>
References: <20100304140100.315416040@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Provide generic perf_sample_data initialization
Message-ID: <tip-dc1d628a67a8f042e711ea5accc0beedc3ef0092@git.kernel.org>
Git-Commit-ID: dc1d628a67a8f042e711ea5accc0beedc3ef0092
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:09:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc1d628a67a8f042e711ea5accc0beedc3ef0092
Gitweb:     http://git.kernel.org/tip/dc1d628a67a8f042e711ea5accc0beedc3ef0092
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 3 Mar 2010 15:55:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:23 +0100

perf: Provide generic perf_sample_data initialization

This makes it easier to extend perf_sample_data and fixes a bug on arm
and sparc, which failed to set ->raw to NULL, which can cause crashes
when combined with PERF_SAMPLE_RAW.

It also optimizes PowerPC and tracepoint, because the struct
initialization is forced to zero out the whole structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jean Pihet <jpihet@mvista.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Jamie Iles <jamie.iles@picochip.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: stable@kernel.org
LKML-Reference: <20100304140100.315416040@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/perf_event.c           |    4 ++--
 arch/powerpc/kernel/perf_event.c       |    8 ++++----
 arch/sparc/kernel/perf_event.c         |    2 +-
 arch/x86/kernel/cpu/perf_event.c       |    3 +--
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++----
 include/linux/perf_event.h             |    7 +++++++
 kernel/perf_event.c                    |   21 ++++++++-------------
 7 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index c54ceb3..3875d99 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -965,7 +965,7 @@ armv6pmu_handle_irq(int irq_num,
 	 */
 	armv6_pmcr_write(pmcr);
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx <= armpmu->num_events; ++idx) {
@@ -1945,7 +1945,7 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 	 */
 	regs = get_irq_regs();
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx <= armpmu->num_events; ++idx) {
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index b6cf8f1..5120bd4 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1164,10 +1164,10 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	 * Finally record data if requested.
 	 */
 	if (record) {
-		struct perf_sample_data data = {
-			.addr	= ~0ULL,
-			.period	= event->hw.last_period,
-		};
+		struct perf_sample_data data;
+
+		perf_sample_data_init(&data, ~0ULL);
+		data.period = event->hw.last_period;
 
 		if (event->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 9f2b2ba..6504208 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1189,7 +1189,7 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 97cddbf..42aafd1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1097,8 +1097,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 73102df..44b60c8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -590,10 +590,9 @@ static void intel_pmu_drain_bts_buffer(void)
 
 	ds->bts_index = ds->bts_buffer_base;
 
+	perf_sample_data_init(&data, 0);
 
 	data.period	= event->hw.last_period;
-	data.addr	= 0;
-	data.raw	= NULL;
 	regs.ip		= 0;
 
 	/*
@@ -742,8 +741,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	int bit, loops;
 	u64 ack, status;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 90e0521..6f8cd7d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -801,6 +801,13 @@ struct perf_sample_data {
 	struct perf_raw_record		*raw;
 };
 
+static inline
+void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
+{
+	data->addr = addr;
+	data->raw  = NULL;
+}
+
 extern void perf_output_sample(struct perf_output_handle *handle,
 			       struct perf_event_header *header,
 			       struct perf_sample_data *data,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e687450..4393b9e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4108,8 +4108,7 @@ void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 	if (rctx < 0)
 		return;
 
-	data.addr = addr;
-	data.raw  = NULL;
+	perf_sample_data_init(&data, addr);
 
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
 
@@ -4154,11 +4153,10 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	struct perf_event *event;
 	u64 period;
 
-	event	= container_of(hrtimer, struct perf_event, hw.hrtimer);
+	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
 	event->pmu->read(event);
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
@@ -4322,17 +4320,15 @@ static const struct pmu perf_ops_task_clock = {
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
 {
+	struct pt_regs *regs = get_irq_regs();
+	struct perf_sample_data data;
 	struct perf_raw_record raw = {
 		.size = entry_size,
 		.data = record,
 	};
 
-	struct perf_sample_data data = {
-		.addr = addr,
-		.raw = &raw,
-	};
-
-	struct pt_regs *regs = get_irq_regs();
+	perf_sample_data_init(&data, addr);
+	data.raw = &raw;
 
 	if (!regs)
 		regs = task_pt_regs(current);
@@ -4448,8 +4444,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
-	sample.raw = NULL;
-	sample.addr = bp->attr.bp_addr;
+	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
 	if (!perf_exclude_event(bp, regs))
 		perf_swevent_add(bp, 1, 1, &sample, regs);
