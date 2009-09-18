Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZIRTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZIRTTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZIRTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:19:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZIRTTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:19:10 -0400
Date: Fri, 18 Sep 2009 19:18:41 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090915130023.A16204@sedona.ch.intel.com>
References: <20090915130023.A16204@sedona.ch.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] x86, perf_counter, bts: Optimize BTS overflow handling
Message-ID: <tip-5622f295b53fb60dbf9bed3e2c89d182490a8b7f@git.kernel.org>
Git-Commit-ID: 5622f295b53fb60dbf9bed3e2c89d182490a8b7f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 19:18:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5622f295b53fb60dbf9bed3e2c89d182490a8b7f
Gitweb:     http://git.kernel.org/tip/5622f295b53fb60dbf9bed3e2c89d182490a8b7f
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Tue, 15 Sep 2009 13:00:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 20:43:20 +0200

x86, perf_counter, bts: Optimize BTS overflow handling

Draining the BTS buffer on a buffer overflow interrupt takes too
long resulting in a kernel lockup when tracing the kernel.

Restructure perf_counter sampling into sample creation and sample
output.

Prepare a single reference sample for BTS sampling and update the
from and to address fields when draining the BTS buffer. Drain the
entire BTS buffer between a single perf_output_begin() /
perf_output_end() pair.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090915130023.A16204@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   60 +++++---
 include/linux/perf_counter.h       |   68 ++++++++-
 kernel/perf_counter.c              |  312 +++++++++++++++++++-----------------
 3 files changed, 266 insertions(+), 174 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f9cd084..6a0e71b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -36,10 +36,10 @@ static u64 perf_counter_mask __read_mostly;
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
@@ -1498,8 +1497,11 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
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
@@ -1510,19 +1512,38 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
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
 
@@ -1552,13 +1573,9 @@ static void x86_pmu_disable(struct perf_counter *counter)
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
 
@@ -1619,7 +1636,6 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1644,7 +1660,7 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			p6_pmu_disable_counter(hwc, idx);
 	}
 
@@ -1665,13 +1681,12 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
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
 
@@ -1729,7 +1744,6 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1754,7 +1768,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6c1ef72..c7375f9 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -691,6 +691,17 @@ struct perf_cpu_context {
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
@@ -722,16 +733,38 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
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
@@ -781,6 +814,12 @@ extern void perf_tpcounter_event(int event_id, u64 addr, u64 count,
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
@@ -807,7 +846,28 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)	{ }
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 29b73b6..2158452 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2512,18 +2512,6 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
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
 static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
 			      unsigned long offset, unsigned long head)
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
@@ -2669,12 +2657,9 @@ static void perf_output_copy(struct perf_output_handle *handle,
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
@@ -2756,7 +2741,7 @@ out:
 	return -ENOSPC;
 }
 
-static void perf_output_end(struct perf_output_handle *handle)
+void perf_output_end(struct perf_output_handle *handle)
 {
 	struct perf_counter *counter = handle->counter;
 	struct perf_mmap_data *data = handle->data;
@@ -2870,82 +2855,151 @@ static void perf_output_read(struct perf_output_handle *handle,
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
 
-	header.misc = 0;
-	header.misc |= perf_misc_flags(data->regs);
+	header->type = PERF_EVENT_SAMPLE;
+	header->size = sizeof(*header);
+
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
@@ -2957,69 +3011,23 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
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
-
-	if (sample_type & PERF_SAMPLE_PERIOD)
-		perf_output_put(&handle, data->period);
+static void perf_counter_output(struct perf_counter *counter, int nmi,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	struct perf_output_handle handle;
+	struct perf_event_header header;
 
-	if (sample_type & PERF_SAMPLE_READ)
-		perf_output_read(&handle, counter);
+	perf_prepare_sample(&header, data, counter, regs);
 
-	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		if (callchain)
-			perf_output_copy(&handle, callchain, callchain_size);
-		else {
-			u64 nr = 0;
-			perf_output_put(&handle, nr);
-		}
-	}
+	if (perf_output_begin(&handle, counter, header.size, nmi, 1))
+		return;
 
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
@@ -3501,7 +3509,8 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
  */
 
 static int __perf_counter_overflow(struct perf_counter *counter, int nmi,
-				   int throttle, struct perf_sample_data *data)
+				   int throttle, struct perf_sample_data *data,
+				   struct pt_regs *regs)
 {
 	int events = atomic_read(&counter->event_limit);
 	struct hw_perf_counter *hwc = &counter->hw;
@@ -3557,14 +3566,15 @@ static int __perf_counter_overflow(struct perf_counter *counter, int nmi,
 			perf_counter_disable(counter);
 	}
 
-	perf_counter_output(counter, nmi, data);
+	perf_counter_output(counter, nmi, data, regs);
 	return ret;
 }
 
 int perf_counter_overflow(struct perf_counter *counter, int nmi,
-			  struct perf_sample_data *data)
+			  struct perf_sample_data *data,
+			  struct pt_regs *regs)
 {
-	return __perf_counter_overflow(counter, nmi, 1, data);
+	return __perf_counter_overflow(counter, nmi, 1, data, regs);
 }
 
 /*
@@ -3602,7 +3612,8 @@ again:
 }
 
 static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct perf_sample_data *data)
+				    int nmi, struct perf_sample_data *data,
+				    struct pt_regs *regs)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 	int throttle = 0;
@@ -3615,7 +3626,8 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 		return;
 
 	for (; overflow; overflow--) {
-		if (__perf_counter_overflow(counter, nmi, throttle, data)) {
+		if (__perf_counter_overflow(counter, nmi, throttle,
+					    data, regs)) {
 			/*
 			 * We inhibit the overflow from happening when
 			 * hwc->interrupts == MAX_INTERRUPTS.
@@ -3634,7 +3646,8 @@ static void perf_swcounter_unthrottle(struct perf_counter *counter)
 }
 
 static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct perf_sample_data *data)
+			       int nmi, struct perf_sample_data *data,
+			       struct pt_regs *regs)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 
@@ -3643,11 +3656,11 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
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
@@ -3706,7 +3719,8 @@ static int perf_swcounter_match(struct perf_counter *counter,
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_type_id type,
 				     u32 event, u64 nr, int nmi,
-				     struct perf_sample_data *data)
+				     struct perf_sample_data *data,
+				     struct pt_regs *regs)
 {
 	struct perf_counter *counter;
 
@@ -3715,8 +3729,8 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_swcounter_match(counter, type, event, data->regs))
-			perf_swcounter_add(counter, nr, nmi, data);
+		if (perf_swcounter_match(counter, type, event, regs))
+			perf_swcounter_add(counter, nr, nmi, data, regs);
 	}
 	rcu_read_unlock();
 }
@@ -3737,7 +3751,8 @@ static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
 
 static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
 				    u64 nr, int nmi,
-				    struct perf_sample_data *data)
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 	int *recursion = perf_swcounter_recursion_context(cpuctx);
@@ -3750,7 +3765,7 @@ static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
 	barrier();
 
 	perf_swcounter_ctx_event(&cpuctx->ctx, type, event,
-				 nr, nmi, data);
+				 nr, nmi, data, regs);
 	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
@@ -3758,7 +3773,7 @@ static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
 	 */
 	ctx = rcu_dereference(current->perf_counter_ctxp);
 	if (ctx)
-		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data);
+		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data, regs);
 	rcu_read_unlock();
 
 	barrier();
@@ -3772,11 +3787,11 @@ void __perf_swcounter_event(u32 event, u64 nr, int nmi,
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
@@ -3813,6 +3828,7 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 {
 	enum hrtimer_restart ret = HRTIMER_RESTART;
 	struct perf_sample_data data;
+	struct pt_regs *regs;
 	struct perf_counter *counter;
 	u64 period;
 
@@ -3820,17 +3836,17 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
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
 
@@ -3966,15 +3982,17 @@ void perf_tpcounter_event(int event_id, u64 addr, u64 count, void *record,
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
 
