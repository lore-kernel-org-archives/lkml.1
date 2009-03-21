Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZCUWEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZCUWEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZCUWEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:04:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZCUWEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:04:36 -0400
Subject: [PATCH] perf_counter: remove the event config bitfields
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1237635675.4667.192.camel@laptop>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
	 <20090321094246.GA5594@elte.hu>
	 <18884.47341.106849.379374@cargo.ozlabs.ibm.com>
	 <20090321095651.GA7201@elte.hu>  <1237635675.4667.192.camel@laptop>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 23:04:28 +0100
Message-Id: <1237673068.3922.257.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 12:41 +0100, Peter Zijlstra wrote:
> On Sat, 2009-03-21 at 10:56 +0100, Ingo Molnar wrote:
> 
> > Maybe the best option is to get rid of the bitfields and use masks 
> 
> Yeah, I think that'll be sanest..

Paul, I noticed you assign the raw config without mask, is that ok?

---
Subject: perf_counter: remove the event config bitfields

Since the bitfields turned into a bit of a mess, remove them and rely on
good old masks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 6413d9c..d056515 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -602,13 +602,13 @@ hw_perf_counter_init(struct perf_counter *counter)
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
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 902282d..3f95b0c 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -217,15 +217,15 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
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
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 98f5990..4d0d787 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -82,32 +82,22 @@ enum perf_counter_record_type {
 	PERF_RECORD_GROUP		= 2,
 };
 
+#define PERF_COUNTER_RAW_MASK		0x8000000000000000ULL
+#define PERF_COUNTER_CONFIG_MASK	0x7FFFFFFFFFFFFFFFULL
+#define PERF_COUNTER_TYPE_MASK		0x7F00000000000000ULL
+#define PERF_COUNTER_EVENT_MASK		0x00FFFFFFFFFFFFFFULL
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
@@ -157,6 +147,26 @@ struct perf_counter_hw_event {
 
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
+	return (hw_event->config & PERF_COUNTER_TYPE_MASK) >> 56;
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
@@ -336,8 +346,8 @@ extern void perf_counter_output(struct perf_counter *counter,
  */
 static inline int is_software_counter(struct perf_counter *counter)
 {
-	return !counter->hw_event.raw_type &&
-		counter->hw_event.type != PERF_TYPE_HARDWARE;
+	return !perf_event_raw(&counter->hw_event) &&
+		perf_event_type(&counter->hw_event) != PERF_TYPE_HARDWARE;
 }
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f054b8c..bbd538a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1379,7 +1379,7 @@ static void perf_counter_handle_group(struct perf_counter *counter)
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
 		if (sub != counter)
 			sub->hw_ops->read(sub);
-		perf_counter_store_irq(counter, sub->hw_event.event_config);
+		perf_counter_store_irq(counter, sub->hw_event.config);
 		perf_counter_store_irq(counter, atomic64_read(&sub->count));
 	}
 }
@@ -1489,13 +1489,13 @@ static int perf_swcounter_match(struct perf_counter *counter,
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
@@ -1763,7 +1763,7 @@ static void tp_perf_counter_destroy(struct perf_counter *counter)
 static const struct hw_perf_counter_ops *
 tp_perf_counter_init(struct perf_counter *counter)
 {
-	int event_id = counter->hw_event.event_id;
+	int event_id = perf_event_id(&counter->hw_event);
 	int ret;
 
 	ret = ftrace_profile_enable(event_id);
@@ -1797,7 +1797,7 @@ sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (counter->hw_event.event_id) {
+	switch (perf_event_id(&counter->hw_event)) {
 	case PERF_COUNT_CPU_CLOCK:
 		hw_ops = &perf_ops_cpu_clock;
 
@@ -1882,9 +1882,12 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 
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
@@ -1902,6 +1905,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 		kfree(counter);
 		return NULL;
 	}
+done:
 	counter->hw_ops = hw_ops;
 
 	return counter;


