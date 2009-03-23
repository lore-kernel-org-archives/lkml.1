Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZCWU5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZCWU5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZCWU4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:56:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:49044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbZCWU4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:56:54 -0400
Date: Mon, 23 Mar 2009 20:56:22 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090323172417.059499915@chello.nl>
References: <20090323172417.059499915@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: remove the event config bitfields
Message-ID: <tip-47211edfdf473ff304450dfaa2c949994a19f698@git.kernel.org>
Git-Commit-ID: 47211edfdf473ff304450dfaa2c949994a19f698
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 20:56:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47211edfdf473ff304450dfaa2c949994a19f698
Gitweb:     http://git.kernel.org/tip/47211edfdf473ff304450dfaa2c949994a19f698
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Mar 2009 18:22:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 21:45:08 +0100

perf_counter: remove the event config bitfields

Since the bitfields turned into a bit of a mess, remove them and rely on
good old masks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090323172417.059499915@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    6 +-
 arch/x86/kernel/cpu/perf_counter.c |    8 ++--
 include/linux/perf_counter.h       |   74 ++++++++++++++++++++++++------------
 kernel/perf_counter.c              |   22 ++++++----
 4 files changed, 70 insertions(+), 40 deletions(-)

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
index 98f5990..56099e5 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
@@ -336,8 +362,8 @@ extern void perf_counter_output(struct perf_counter *counter,
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
index f054b8c..ca14fc4 100644
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
