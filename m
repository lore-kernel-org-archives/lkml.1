Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbZIHGbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbZIHGbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZIHGbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:31:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:44956 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZIHGba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:31:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,351,1249282800"; 
   d="scan'208";a="491420443"
Date: Tue, 8 Sep 2009 08:31:10 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: [patch] x86, perf_counter, bts: optimize BTS overflow handling
Message-ID: <20090908083110.A7541@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Draining the BTS buffer on a buffer overflow interrupt takes too long
resulting in a kernel lockup when tracing the kernel.

Restructure perf_counter sampling into separate sample creation and
output functions.
Prepare a single reference sample for BTS sampling and update the from
and to address fields when draining the BTS buffer.
Drain the entire BTS buffer between a single perf_output_begin() /
perf_output_end() pair.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   60 	37 +	23 -	0 !
 include/linux/perf_counter.h       |   68 	64 +	4 -	0 !
 kernel/perf_counter.c              |  306 	161 +	145 -	0 !
 3 files changed, 262 insertions(+), 172 deletions(-)

Index: b/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -36,10 +36,10 @@ static u64 perf_counter_mask __read_most
 #define BTS_RECORD_SIZE		24
 
 /* The size of a per-cpu BTS buffer in bytes: */
-#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 1024)
+#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 2048)
 
 /* The BTS overflow threshold in bytes from the end of the buffer: */
-#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 64)
+#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 128)
 
 
 /*
@@ -1488,8 +1488,7 @@ void perf_counter_print_debug(void)
 	local_irq_restore(flags);
 }
 
-static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
-				       struct perf_sample_data *data)
+static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc)
 {
 	struct debug_store *ds = cpuc->ds;
 	struct bts_record {
@@ -1498,8 +1497,11 @@ static void intel_pmu_drain_bts_buffer(s
 		u64	flags;
 	};
 	struct perf_counter *counter = cpuc->counters[X86_PMC_IDX_FIXED_BTS];
-	unsigned long orig_ip = data->regs->ip;
 	struct bts_record *at, *top;
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+	struct perf_sample_data data;
+	struct pt_regs regs;
 
 	if (!counter)
 		return;
@@ -1510,19 +1512,38 @@ static void intel_pmu_drain_bts_buffer(s
 	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
 	top = (struct bts_record *)(unsigned long)ds->bts_index;
 
+	if (top <= at)
+		return;
+
 	ds->bts_index = ds->bts_buffer_base;
 
+
+	data.period	= counter->hw.last_period;
+	data.addr	= 0;
+	regs.ip		= 0;
+
+	/*
+	 * Prepare a generic sample, i.e. fill in the invariant fields.
+	 * We will overwrite the from and to address before we output
+	 * the sample.
+	 */
+	perf_prepare_sample(&header, &data, counter, &regs);
+
+	if (perf_output_begin(&handle, counter,
+			      header.size * (top - at), 1, 1))
+		return;
+
 	for (; at < top; at++) {
-		data->regs->ip	= at->from;
-		data->addr	= at->to;
+		data.ip		= at->from;
+		data.addr	= at->to;
 
-		perf_counter_output(counter, 1, data);
+		perf_output_sample(&handle, &header, &data, counter);
 	}
 
-	data->regs->ip	= orig_ip;
-	data->addr	= 0;
+	perf_output_end(&handle);
 
 	/* There's new data available. */
+	counter->hw.interrupts++;
 	counter->pending_kill = POLL_IN;
 }
 
@@ -1552,13 +1573,9 @@ static void x86_pmu_disable(struct perf_
 	x86_perf_counter_update(counter, hwc, idx);
 
 	/* Drain the remaining BTS records. */
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
-		struct perf_sample_data data;
-		struct pt_regs regs;
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS))
+		intel_pmu_drain_bts_buffer(cpuc);
 
-		data.regs = &regs;
-		intel_pmu_drain_bts_buffer(cpuc, &data);
-	}
 	cpuc->counters[idx] = NULL;
 	clear_bit(idx, cpuc->used_mask);
 
@@ -1619,7 +1636,6 @@ static int p6_pmu_handle_irq(struct pt_r
 	int idx, handled = 0;
 	u64 val;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1644,7 +1660,7 @@ static int p6_pmu_handle_irq(struct pt_r
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			p6_pmu_disable_counter(hwc, idx);
 	}
 
@@ -1665,13 +1681,12 @@ static int intel_pmu_handle_irq(struct p
 	int bit, loops;
 	u64 ack, status;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	perf_disable();
-	intel_pmu_drain_bts_buffer(cpuc, &data);
+	intel_pmu_drain_bts_buffer(cpuc);
 	status = intel_pmu_get_status();
 	if (!status) {
 		perf_enable();
@@ -1702,7 +1717,7 @@ again:
 
 		data.period = counter->hw.last_period;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
 
@@ -1729,7 +1744,6 @@ static int amd_pmu_handle_irq(struct pt_
 	int idx, handled = 0;
 	u64 val;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1754,7 +1768,7 @@ static int amd_pmu_handle_irq(struct pt_
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
Index: b/include/linux/perf_counter.h
===================================================================
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -685,6 +685,17 @@ struct perf_cpu_context {
 	int				recursion[4];
 };
 
+struct perf_output_handle {
+	struct perf_counter	*counter;
+	struct perf_mmap_data	*data;
+	unsigned long		head;
+	unsigned long		offset;
+	int			nmi;
+	int			sample;
+	int			locked;
+	unsigned long		flags;
+};
+
 #ifdef CONFIG_PERF_COUNTERS
 
 /*
@@ -716,16 +727,38 @@ extern int hw_perf_group_sched_in(struct
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
 struct perf_sample_data {
-	struct pt_regs			*regs;
+	u64				type;
+
+	u64				ip;
+	struct {
+		u32	pid;
+		u32	tid;
+	}				tid_entry;
+	u64				time;
 	u64				addr;
+	u64				id;
+	u64				stream_id;
+	struct {
+		u32	cpu;
+		u32	reserved;
+	}				cpu_entry;
 	u64				period;
+	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 };
 
+extern void perf_output_sample(struct perf_output_handle *handle,
+			       struct perf_event_header *header,
+			       struct perf_sample_data *data,
+			       struct perf_counter *counter);
+extern void perf_prepare_sample(struct perf_event_header *header,
+				struct perf_sample_data *data,
+				struct perf_counter *counter,
+				struct pt_regs *regs);
+
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
-				 struct perf_sample_data *data);
-extern void perf_counter_output(struct perf_counter *counter, int nmi,
-				struct perf_sample_data *data);
+				 struct perf_sample_data *data,
+				 struct pt_regs *regs);
 
 /*
  * Return 1 for a software counter, 0 for a hardware counter
@@ -775,6 +808,12 @@ extern void perf_tpcounter_event(int eve
 #define perf_instruction_pointer(regs)	instruction_pointer(regs)
 #endif
 
+extern int perf_output_begin(struct perf_output_handle *handle,
+			     struct perf_counter *counter, unsigned int size,
+			     int nmi, int sample);
+extern void perf_output_end(struct perf_output_handle *handle);
+extern void perf_output_copy(struct perf_output_handle *handle,
+			     const void *buf, unsigned int len);
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -801,7 +840,28 @@ static inline void perf_counter_mmap(str
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
+
+static inline int
+perf_output_begin(struct perf_output_handle *handle, struct perf_counter *c,
+		  unsigned int size, int nmi, int sample)		{ }
+static inline void perf_output_end(struct perf_output_handle *handle)	{ }
+static inline void
+perf_output_copy(struct perf_output_handle *handle,
+		 const void *buf, unsigned int len)			{ }
+static inline void
+perf_output_sample(struct perf_output_handle *handle,
+		   struct perf_event_header *header,
+		   struct perf_sample_data *data,
+		   struct perf_counter *counter)			{ }
+static inline void
+perf_prepare_sample(struct perf_event_header *header,
+		    struct perf_sample_data *data,
+		    struct perf_counter *counter,
+		    struct pt_regs *regs)				{ }
 #endif
 
+#define perf_output_put(handle, x) \
+	perf_output_copy((handle), &(x), sizeof(x))
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_COUNTER_H */
Index: b/kernel/perf_counter.c
===================================================================
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2504,18 +2504,6 @@ __weak struct perf_callchain_entry *perf
 /*
  * Output
  */
-
-struct perf_output_handle {
-	struct perf_counter	*counter;
-	struct perf_mmap_data	*data;
-	unsigned long		head;
-	unsigned long		offset;
-	int			nmi;
-	int			sample;
-	int			locked;
-	unsigned long		flags;
-};
-
 static bool perf_output_space(struct perf_mmap_data *data,
 			      unsigned int offset, unsigned int head)
 {
@@ -2633,8 +2621,8 @@ out:
 	local_irq_restore(handle->flags);
 }
 
-static void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len)
+void perf_output_copy(struct perf_output_handle *handle,
+		      const void *buf, unsigned int len)
 {
 	unsigned int pages_mask;
 	unsigned int offset;
@@ -2669,12 +2657,9 @@ static void perf_output_copy(struct perf
 	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
 }
 
-#define perf_output_put(handle, x) \
-	perf_output_copy((handle), &(x), sizeof(x))
-
-static int perf_output_begin(struct perf_output_handle *handle,
-			     struct perf_counter *counter, unsigned int size,
-			     int nmi, int sample)
+int perf_output_begin(struct perf_output_handle *handle,
+		      struct perf_counter *counter, unsigned int size,
+		      int nmi, int sample)
 {
 	struct perf_counter *output_counter;
 	struct perf_mmap_data *data;
@@ -2749,7 +2734,7 @@ out:
 	return -ENOSPC;
 }
 
-static void perf_output_end(struct perf_output_handle *handle)
+void perf_output_end(struct perf_output_handle *handle)
 {
 	struct perf_counter *counter = handle->counter;
 	struct perf_mmap_data *data = handle->data;
@@ -2863,82 +2848,151 @@ static void perf_output_read(struct perf
 		perf_output_read_one(handle, counter);
 }
 
-void perf_counter_output(struct perf_counter *counter, int nmi,
-				struct perf_sample_data *data)
+void perf_output_sample(struct perf_output_handle *handle,
+			struct perf_event_header *header,
+			struct perf_sample_data *data,
+			struct perf_counter *counter)
+{
+	u64 sample_type = data->type;
+
+	perf_output_put(handle, *header);
+
+	if (sample_type & PERF_SAMPLE_IP)
+		perf_output_put(handle, data->ip);
+
+	if (sample_type & PERF_SAMPLE_TID)
+		perf_output_put(handle, data->tid_entry);
+
+	if (sample_type & PERF_SAMPLE_TIME)
+		perf_output_put(handle, data->time);
+
+	if (sample_type & PERF_SAMPLE_ADDR)
+		perf_output_put(handle, data->addr);
+
+	if (sample_type & PERF_SAMPLE_ID)
+		perf_output_put(handle, data->id);
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		perf_output_put(handle, data->stream_id);
+
+	if (sample_type & PERF_SAMPLE_CPU)
+		perf_output_put(handle, data->cpu_entry);
+
+	if (sample_type & PERF_SAMPLE_PERIOD)
+		perf_output_put(handle, data->period);
+
+	if (sample_type & PERF_SAMPLE_READ)
+		perf_output_read(handle, counter);
+
+	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
+		if (data->callchain) {
+			int size = 1;
+
+			if (data->callchain)
+				size += data->callchain->nr;
+
+			size *= sizeof(u64);
+
+			perf_output_copy(handle, data->callchain, size);
+		} else {
+			u64 nr = 0;
+			perf_output_put(handle, nr);
+		}
+	}
+
+	if (sample_type & PERF_SAMPLE_RAW) {
+		if (data->raw) {
+			perf_output_put(handle, data->raw->size);
+			perf_output_copy(handle, data->raw->data,
+					 data->raw->size);
+		} else {
+			struct {
+				u32	size;
+				u32	data;
+			} raw = {
+				.size = sizeof(u32),
+				.data = 0,
+			};
+			perf_output_put(handle, raw);
+		}
+	}
+}
+
+void perf_prepare_sample(struct perf_event_header *header,
+			 struct perf_sample_data *data,
+			 struct perf_counter *counter,
+			 struct pt_regs *regs)
 {
-	int ret;
 	u64 sample_type = counter->attr.sample_type;
-	struct perf_output_handle handle;
-	struct perf_event_header header;
-	u64 ip;
-	struct {
-		u32 pid, tid;
-	} tid_entry;
-	struct perf_callchain_entry *callchain = NULL;
-	int callchain_size = 0;
-	u64 time;
-	struct {
-		u32 cpu, reserved;
-	} cpu_entry;
 
-	header.type = PERF_EVENT_SAMPLE;
-	header.size = sizeof(header);
+	data->type = sample_type;
+
+	header->type = PERF_EVENT_SAMPLE;
+	header->size = sizeof(*header);
 
-	header.misc = 0;
-	header.misc |= perf_misc_flags(data->regs);
+	header->misc = 0;
+	header->misc |= perf_misc_flags(regs);
 
 	if (sample_type & PERF_SAMPLE_IP) {
-		ip = perf_instruction_pointer(data->regs);
-		header.size += sizeof(ip);
+		data->ip = perf_instruction_pointer(regs);
+
+		header->size += sizeof(data->ip);
 	}
 
 	if (sample_type & PERF_SAMPLE_TID) {
 		/* namespace issues */
-		tid_entry.pid = perf_counter_pid(counter, current);
-		tid_entry.tid = perf_counter_tid(counter, current);
+		data->tid_entry.pid = perf_counter_pid(counter, current);
+		data->tid_entry.tid = perf_counter_tid(counter, current);
 
-		header.size += sizeof(tid_entry);
+		header->size += sizeof(data->tid_entry);
 	}
 
 	if (sample_type & PERF_SAMPLE_TIME) {
 		/*
 		 * Maybe do better on x86 and provide cpu_clock_nmi()
 		 */
-		time = sched_clock();
+		data->time = sched_clock();
 
-		header.size += sizeof(u64);
+		header->size += sizeof(data->time);
 	}
 
 	if (sample_type & PERF_SAMPLE_ADDR)
-		header.size += sizeof(u64);
+		header->size += sizeof(data->addr);
 
-	if (sample_type & PERF_SAMPLE_ID)
-		header.size += sizeof(u64);
+	if (sample_type & PERF_SAMPLE_ID) {
+		data->id = primary_counter_id(counter);
 
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		header.size += sizeof(u64);
+		header->size += sizeof(data->id);
+	}
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID) {
+		data->stream_id = counter->id;
+
+		header->size += sizeof(data->stream_id);
+	}
 
 	if (sample_type & PERF_SAMPLE_CPU) {
-		header.size += sizeof(cpu_entry);
+		data->cpu_entry.cpu		= raw_smp_processor_id();
+		data->cpu_entry.reserved	= 0;
 
-		cpu_entry.cpu = raw_smp_processor_id();
-		cpu_entry.reserved = 0;
+		header->size += sizeof(data->cpu_entry);
 	}
 
 	if (sample_type & PERF_SAMPLE_PERIOD)
-		header.size += sizeof(u64);
+		header->size += sizeof(data->period);
 
 	if (sample_type & PERF_SAMPLE_READ)
-		header.size += perf_counter_read_size(counter);
+		header->size += perf_counter_read_size(counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		callchain = perf_callchain(data->regs);
+		int size = 1;
 
-		if (callchain) {
-			callchain_size = (1 + callchain->nr) * sizeof(u64);
-			header.size += callchain_size;
-		} else
-			header.size += sizeof(u64);
+		data->callchain = perf_callchain(regs);
+
+		if (data->callchain)
+			size += data->callchain->nr;
+
+		header->size += size * sizeof(u64);
 	}
 
 	if (sample_type & PERF_SAMPLE_RAW) {
@@ -2950,69 +3004,23 @@ void perf_counter_output(struct perf_cou
 			size += sizeof(u32);
 
 		WARN_ON_ONCE(size & (sizeof(u64)-1));
-		header.size += size;
-	}
-
-	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
-	if (ret)
-		return;
-
-	perf_output_put(&handle, header);
-
-	if (sample_type & PERF_SAMPLE_IP)
-		perf_output_put(&handle, ip);
-
-	if (sample_type & PERF_SAMPLE_TID)
-		perf_output_put(&handle, tid_entry);
-
-	if (sample_type & PERF_SAMPLE_TIME)
-		perf_output_put(&handle, time);
-
-	if (sample_type & PERF_SAMPLE_ADDR)
-		perf_output_put(&handle, data->addr);
-
-	if (sample_type & PERF_SAMPLE_ID) {
-		u64 id = primary_counter_id(counter);
-
-		perf_output_put(&handle, id);
+		header->size += size;
 	}
+}
 
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		perf_output_put(&handle, counter->id);
-
-	if (sample_type & PERF_SAMPLE_CPU)
-		perf_output_put(&handle, cpu_entry);
+static void perf_counter_output(struct perf_counter *counter, int nmi,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	struct perf_output_handle handle;
+	struct perf_event_header header;
 
-	if (sample_type & PERF_SAMPLE_PERIOD)
-		perf_output_put(&handle, data->period);
+	perf_prepare_sample(&header, data, counter, regs);
 
-	if (sample_type & PERF_SAMPLE_READ)
-		perf_output_read(&handle, counter);
+	if (perf_output_begin(&handle, counter, header.size, nmi, 1))
+		return;
 
-	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		if (callchain)
-			perf_output_copy(&handle, callchain, callchain_size);
-		else {
-			u64 nr = 0;
-			perf_output_put(&handle, nr);
-		}
-	}
-
-	if (sample_type & PERF_SAMPLE_RAW) {
-		if (data->raw) {
-			perf_output_put(&handle, data->raw->size);
-			perf_output_copy(&handle, data->raw->data, data->raw->size);
-		} else {
-			struct {
-				u32	size;
-				u32	data;
-			} raw = {
-				.size = sizeof(u32),
-				.data = 0,
-			};
-			perf_output_put(&handle, raw);
-		}
-	}
+	perf_output_sample(&handle, &header, data, counter);
 
 	perf_output_end(&handle);
 }
@@ -3494,7 +3502,8 @@ static void perf_log_throttle(struct per
  */
 
 int perf_counter_overflow(struct perf_counter *counter, int nmi,
-			  struct perf_sample_data *data)
+			  struct perf_sample_data *data,
+			  struct pt_regs *regs)
 {
 	int events = atomic_read(&counter->event_limit);
 	int throttle = counter->pmu->unthrottle != NULL;
@@ -3549,7 +3558,7 @@ int perf_counter_overflow(struct perf_co
 			perf_counter_disable(counter);
 	}
 
-	perf_counter_output(counter, nmi, data);
+	perf_counter_output(counter, nmi, data, regs);
 	return ret;
 }
 
@@ -3588,7 +3597,8 @@ again:
 }
 
 static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct perf_sample_data *data)
+				    int nmi, struct perf_sample_data *data,
+				    struct pt_regs *regs)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 	u64 overflow;
@@ -3600,7 +3610,7 @@ static void perf_swcounter_overflow(stru
 		return;
 
 	for (; overflow; overflow--) {
-		if (perf_counter_overflow(counter, nmi, data)) {
+		if (perf_counter_overflow(counter, nmi, data, regs)) {
 			/*
 			 * We inhibit the overflow from happening when
 			 * hwc->interrupts == MAX_INTERRUPTS.
@@ -3618,7 +3628,8 @@ static void perf_swcounter_unthrottle(st
 }
 
 static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct perf_sample_data *data)
+			       int nmi, struct perf_sample_data *data,
+			       struct pt_regs *regs)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 
@@ -3627,11 +3638,11 @@ static void perf_swcounter_add(struct pe
 	if (!hwc->sample_period)
 		return;
 
-	if (!data->regs)
+	if (!regs)
 		return;
 
 	if (!atomic64_add_negative(nr, &hwc->period_left))
-		perf_swcounter_overflow(counter, nmi, data);
+		perf_swcounter_overflow(counter, nmi, data, regs);
 }
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
@@ -3690,7 +3701,8 @@ static int perf_swcounter_match(struct p
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_type_id type,
 				     u32 event, u64 nr, int nmi,
-				     struct perf_sample_data *data)
+				     struct perf_sample_data *data,
+				     struct pt_regs *regs)
 {
 	struct perf_counter *counter;
 
@@ -3699,8 +3711,8 @@ static void perf_swcounter_ctx_event(str
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_swcounter_match(counter, type, event, data->regs))
-			perf_swcounter_add(counter, nr, nmi, data);
+		if (perf_swcounter_match(counter, type, event, regs))
+			perf_swcounter_add(counter, nr, nmi, data, regs);
 	}
 	rcu_read_unlock();
 }
@@ -3721,7 +3733,8 @@ static int *perf_swcounter_recursion_con
 
 static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
 				    u64 nr, int nmi,
-				    struct perf_sample_data *data)
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 	int *recursion = perf_swcounter_recursion_context(cpuctx);
@@ -3734,7 +3747,7 @@ static void do_perf_swcounter_event(enum
 	barrier();
 
 	perf_swcounter_ctx_event(&cpuctx->ctx, type, event,
-				 nr, nmi, data);
+				 nr, nmi, data, regs);
 	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
@@ -3742,7 +3755,7 @@ static void do_perf_swcounter_event(enum
 	 */
 	ctx = rcu_dereference(current->perf_counter_ctxp);
 	if (ctx)
-		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data);
+		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data, regs);
 	rcu_read_unlock();
 
 	barrier();
@@ -3756,11 +3769,11 @@ void __perf_swcounter_event(u32 event, u
 			    struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data = {
-		.regs = regs,
 		.addr = addr,
 	};
 
-	do_perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, &data);
+	do_perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi,
+				&data, regs);
 }
 
 static void perf_swcounter_read(struct perf_counter *counter)
@@ -3797,6 +3810,7 @@ static enum hrtimer_restart perf_swcount
 {
 	enum hrtimer_restart ret = HRTIMER_RESTART;
 	struct perf_sample_data data;
+	struct pt_regs *regs;
 	struct perf_counter *counter;
 	u64 period;
 
@@ -3804,17 +3818,17 @@ static enum hrtimer_restart perf_swcount
 	counter->pmu->read(counter);
 
 	data.addr = 0;
-	data.regs = get_irq_regs();
+	regs = get_irq_regs();
 	/*
 	 * In case we exclude kernel IPs or are somehow not in interrupt
 	 * context, provide the next best thing, the user IP.
 	 */
-	if ((counter->attr.exclude_kernel || !data.regs) &&
+	if ((counter->attr.exclude_kernel || !regs) &&
 			!counter->attr.exclude_user)
-		data.regs = task_pt_regs(current);
+		regs = task_pt_regs(current);
 
-	if (data.regs) {
-		if (perf_counter_overflow(counter, 0, &data))
+	if (regs) {
+		if (perf_counter_overflow(counter, 0, &data, regs))
 			ret = HRTIMER_NORESTART;
 	}
 
@@ -3950,15 +3964,17 @@ void perf_tpcounter_event(int event_id, 
 	};
 
 	struct perf_sample_data data = {
-		.regs = get_irq_regs(),
 		.addr = addr,
 		.raw = &raw,
 	};
 
-	if (!data.regs)
-		data.regs = task_pt_regs(current);
+	struct pt_regs *regs = get_irq_regs();
+
+	if (!regs)
+		regs = task_pt_regs(current);
 
-	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, count, 1, &data);
+	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
+				&data, regs);
 }
 EXPORT_SYMBOL_GPL(perf_tpcounter_event);
 
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

