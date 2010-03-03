Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0CCQpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:45:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0CCQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:32 -0500
Message-Id: <20100303164306.222595079@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Jamie Iles <jamie.iles@picochip.com>,
       Jean Pihet <jpihet@mvista.com>, "David S. Miller" <davem@davemloft.net>,
       stable@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 05/11] perf: Generic perf_sample_data initialization
Content-Disposition: inline; filename=perf-fixup-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to extend perf_sample_data and fixes a bug on
arm and sparc, which failed to set ->raw to NULL, which can cause
crashes when combined with PERF_SAMPLE_RAW.

It also optimizes PowerPC and tracepoint, because the struct
initialization is forced to zero out the whole structure.

CC: Jamie Iles <jamie.iles@picochip.com>
CC: Jean Pihet <jpihet@mvista.com>
CC: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: David S. Miller <davem@davemloft.net>
CC: Stephane Eranian <eranian@google.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: stable@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/kernel/perf_event.c           |    4 ++--
 arch/powerpc/kernel/perf_event.c       |    8 ++++----
 arch/sparc/kernel/perf_event.c         |    2 +-
 arch/x86/kernel/cpu/perf_event.c       |    3 +--
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++----
 include/linux/perf_event.h             |    7 +++++++
 kernel/perf_event.c                    |   21 ++++++++-------------
 7 files changed, 25 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -965,7 +965,7 @@ armv6pmu_handle_irq(int irq_num,
 	 */
 	armv6_pmcr_write(pmcr);
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx <= armpmu->num_events; ++idx) {
@@ -1945,7 +1945,7 @@ static irqreturn_t armv7pmu_handle_irq(i
 	 */
 	regs = get_irq_regs();
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx <= armpmu->num_events; ++idx) {
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -1164,10 +1164,10 @@ static void record_and_restart(struct pe
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
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -1189,7 +1189,7 @@ static int __kprobes perf_event_nmi_hand
 
 	regs = args->regs;
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1096,8 +1096,7 @@ static int x86_pmu_handle_irq(struct pt_
 	int idx, handled = 0;
 	u64 val;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -590,10 +590,9 @@ static void intel_pmu_drain_bts_buffer(v
 
 	ds->bts_index = ds->bts_buffer_base;
 
+	perf_sample_data_init(&data, 0);
 
 	data.period	= event->hw.last_period;
-	data.addr	= 0;
-	data.raw	= NULL;
 	regs.ip		= 0;
 
 	/*
@@ -740,8 +739,7 @@ static int intel_pmu_handle_irq(struct p
 	int bit, loops;
 	u64 ack, status;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
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
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4108,8 +4108,7 @@ void __perf_sw_event(u32 event_id, u64 n
 	if (rctx < 0)
 		return;
 
-	data.addr = addr;
-	data.raw  = NULL;
+	perf_sample_data_init(&data, addr);
 
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
 
@@ -4154,11 +4153,10 @@ static enum hrtimer_restart perf_swevent
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
@@ -4322,17 +4320,15 @@ static const struct pmu perf_ops_task_cl
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
@@ -4448,8 +4444,7 @@ void perf_bp_event(struct perf_event *bp
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
-	sample.raw = NULL;
-	sample.addr = bp->attr.bp_addr;
+	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
 	if (!perf_exclude_event(bp, regs))
 		perf_swevent_add(bp, 1, 1, &sample, regs);

-- 

