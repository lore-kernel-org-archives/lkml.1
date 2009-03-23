Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbZCWR02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbZCWR02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbZCWRZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:25:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZCWRZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:25:11 -0400
Message-Id: <20090323172417.059499915@chello.nl>
References: <20090323172205.389341032@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Mar 2009 18:22:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] perf_counter: remove the event config bitfields
Content-Disposition: inline; filename=perf_counter-kill-bitfield-union.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the bitfields turned into a bit of a mess, remove them and rely on
good old masks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_counter.c |    6 +--
 arch/x86/kernel/cpu/perf_counter.c |    8 ++--
 include/linux/perf_counter.h       |   74 +++++++++++++++++++++++++------------
 kernel/perf_counter.c              |   22 ++++++-----
 4 files changed, 70 insertions(+), 40 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -602,13 +602,13 @@ hw_perf_counter_init(struct perf_counter
 		return NULL;
 	if ((s64)counter->hw_event.irq_period < 0)
 		return NULL;
-	if (!counter->hw_event.raw_type) {
-		ev = counter->hw_event.event_id;
+	if (!perf_event_raw(&counter->hw_event)) {
+		ev = perf_event_id(&counter->hw_event);
 		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
 			return NULL;
 		ev = ppmu->generic_events[ev];
 	} else {
-		ev = counter->hw_event.raw_event_id;
+		ev = perf_event_config(&counter->hw_event);
 	}
 	counter->hw.config_base = ev;
 	counter->hw.idx = 0;
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -217,15 +217,15 @@ static int __hw_perf_counter_init(struct
 	/*
 	 * Raw event type provide the config in the event structure
 	 */
-	if (hw_event->raw_type) {
-		hwc->config |= pmc_ops->raw_event(hw_event->raw_event_id);
+	if (perf_event_raw(hw_event)) {
+		hwc->config |= pmc_ops->raw_event(perf_event_config(hw_event));
 	} else {
-		if (hw_event->event_id >= pmc_ops->max_events)
+		if (perf_event_id(hw_event) >= pmc_ops->max_events)
 			return -EINVAL;
 		/*
 		 * The generic map:
 		 */
-		hwc->config |= pmc_ops->event_map(hw_event->event_id);
+		hwc->config |= pmc_ops->event_map(perf_event_id(hw_event));
 	}
 	counter->wakeup_pending = 0;
 
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -82,32 +82,37 @@ enum perf_counter_record_type {
 	PERF_RECORD_GROUP		= 2,
 };
 
+#define __PERF_COUNTER_MASK(name) 			\
+	(((1ULL << PERF_COUNTER_##name##_BITS) - 1) <<	\
+	 PERF_COUNTER_##name##_SHIFT)
+
+#define PERF_COUNTER_RAW_BITS		1
+#define PERF_COUNTER_RAW_SHIFT		63
+#define PERF_COUNTER_RAW_MASK		__PERF_COUNTER_MASK(RAW)
+
+#define PERF_COUNTER_CONFIG_BITS	63
+#define PERF_COUNTER_CONFIG_SHIFT	0
+#define PERF_COUNTER_CONFIG_MASK	__PERF_COUNTER_MASK(CONFIG)
+
+#define PERF_COUNTER_TYPE_BITS		7
+#define PERF_COUNTER_TYPE_SHIFT		56
+#define PERF_COUNTER_TYPE_MASK		__PERF_COUNTER_MASK(TYPE)
+
+#define PERF_COUNTER_EVENT_BITS		56
+#define PERF_COUNTER_EVENT_SHIFT	0
+#define PERF_COUNTER_EVENT_MASK		__PERF_COUNTER_MASK(EVENT)
+
 /*
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_hw_event {
-	union {
-#ifndef __BIG_ENDIAN_BITFIELD
-		struct {
-			__u64			event_id	: 56,
-						type		:  8;
-		};
-		struct {
-			__u64			raw_event_id	: 63,
-						raw_type	:  1;
-		};
-#else
-		struct {
-			__u64			type		:  8,
-						event_id	: 56;
-		};
-		struct {
-			__u64			raw_type	:  1,
-						raw_event_id	: 63;
-		};
-#endif /* __BIT_ENDIAN_BITFIELD */
-		__u64		event_config;
-	};
+	/*
+	 * The MSB of the config word signifies if the rest contains cpu
+	 * specific (raw) counter configuration data, if unset, the next
+	 * 7 bits are an event type and the rest of the bits are the event
+	 * identifier.
+	 */
+	__u64			config;
 
 	__u64			irq_period;
 	__u64			record_type;
@@ -157,6 +162,27 @@ struct perf_counter_hw_event {
 
 struct task_struct;
 
+static inline u64 perf_event_raw(struct perf_counter_hw_event *hw_event)
+{
+	return hw_event->config & PERF_COUNTER_RAW_MASK;
+}
+
+static inline u64 perf_event_config(struct perf_counter_hw_event *hw_event)
+{
+	return hw_event->config & PERF_COUNTER_CONFIG_MASK;
+}
+
+static inline u64 perf_event_type(struct perf_counter_hw_event *hw_event)
+{
+	return (hw_event->config & PERF_COUNTER_TYPE_MASK) >>
+		PERF_COUNTER_TYPE_SHIFT;
+}
+
+static inline u64 perf_event_id(struct perf_counter_hw_event *hw_event)
+{
+	return hw_event->config & PERF_COUNTER_EVENT_MASK;
+}
+
 /**
  * struct hw_perf_counter - performance counter hardware details:
  */
@@ -336,8 +362,8 @@ extern void perf_counter_output(struct p
  */
 static inline int is_software_counter(struct perf_counter *counter)
 {
-	return !counter->hw_event.raw_type &&
-		counter->hw_event.type != PERF_TYPE_HARDWARE;
+	return !perf_event_raw(&counter->hw_event) &&
+		perf_event_type(&counter->hw_event) != PERF_TYPE_HARDWARE;
 }
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *);
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1379,7 +1379,7 @@ static void perf_counter_handle_group(st
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
 		if (sub != counter)
 			sub->hw_ops->read(sub);
-		perf_counter_store_irq(counter, sub->hw_event.event_config);
+		perf_counter_store_irq(counter, sub->hw_event.config);
 		perf_counter_store_irq(counter, atomic64_read(&sub->count));
 	}
 }
@@ -1489,13 +1489,13 @@ static int perf_swcounter_match(struct p
 	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
 		return 0;
 
-	if (counter->hw_event.raw_type)
+	if (perf_event_raw(&counter->hw_event))
 		return 0;
 
-	if (counter->hw_event.type != type)
+	if (perf_event_type(&counter->hw_event) != type)
 		return 0;
 
-	if (counter->hw_event.event_id != event)
+	if (perf_event_id(&counter->hw_event) != event)
 		return 0;
 
 	if (counter->hw_event.exclude_user && user_mode(regs))
@@ -1757,13 +1757,13 @@ extern void ftrace_profile_disable(int);
 
 static void tp_perf_counter_destroy(struct perf_counter *counter)
 {
-	ftrace_profile_disable(counter->hw_event.event_id);
+	ftrace_profile_disable(perf_event_id(&counter->hw_event));
 }
 
 static const struct hw_perf_counter_ops *
 tp_perf_counter_init(struct perf_counter *counter)
 {
-	int event_id = counter->hw_event.event_id;
+	int event_id = perf_event_id(&counter->hw_event);
 	int ret;
 
 	ret = ftrace_profile_enable(event_id);
@@ -1797,7 +1797,7 @@ sw_perf_counter_init(struct perf_counter
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (counter->hw_event.event_id) {
+	switch (perf_event_id(&counter->hw_event)) {
 	case PERF_COUNT_CPU_CLOCK:
 		hw_ops = &perf_ops_cpu_clock;
 
@@ -1882,9 +1882,12 @@ perf_counter_alloc(struct perf_counter_h
 
 	hw_ops = NULL;
 
-	if (hw_event->raw_type)
+	if (perf_event_raw(hw_event)) {
 		hw_ops = hw_perf_counter_init(counter);
-	else switch (hw_event->type) {
+		goto done;
+	}
+
+	switch (perf_event_type(hw_event)) {
 	case PERF_TYPE_HARDWARE:
 		hw_ops = hw_perf_counter_init(counter);
 		break;
@@ -1902,6 +1905,7 @@ perf_counter_alloc(struct perf_counter_h
 		kfree(counter);
 		return NULL;
 	}
+done:
 	counter->hw_ops = hw_ops;
 
 	return counter;

-- 

