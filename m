Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZHMTFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZHMTFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbZHMTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:05:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbZHMTFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:05:07 -0400
Date: Thu, 13 Aug 2009 21:04:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters fixes
Message-ID: <20090813190455.GA18801@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (6):
      perf record: Fix .tid and .pid fill-in when synthesizing events
      perf report: Show the tid too in -D
      perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available
      perf tools: Fix dso__new handle() to handle deleted DSOs
      perf list: Fix large list output by using the pager
      perf report: Don't show unresolved DSOs and symbols when -S/-d is used

Frederic Weisbecker (2):
      perf tools: Add a per tracepoint counter attribute to get raw sample
      perf tools: Add a general option to enable raw sample records

Ingo Molnar (4):
      perf_counter, x86: Fix lapic printk message
      perf_counter, x86: Fix generic cache events on P6-mobile CPUs
      perf_counter, x86: Fix/improve apic fallback
      perf_counter: Provide hw_perf_counter_setup_online() APIs

Jens Axboe (1):
      perf record: Add missing -C option support for specifying profile cpu

Peter Zijlstra (4):
      perf_counter: Fix swcounter context invariance
      perf: Rework/fix the whole read vs group stuff
      perf_counter: Fix an ipi-deadlock
      perf_counter: Report the cloning task as parent on perf_counter_fork()


 arch/x86/Kconfig                   |    2 +-
 arch/x86/kernel/cpu/perf_counter.c |   40 ++++-
 include/linux/perf_counter.h       |   49 ++++--
 kernel/perf_counter.c              |  338 +++++++++++++++++++++++++-----------
 tools/perf/Makefile                |   29 ++--
 tools/perf/builtin-list.c          |    3 +-
 tools/perf/builtin-record.c        |   95 ++++++----
 tools/perf/builtin-report.c        |   12 +-
 tools/perf/util/parse-events.c     |   10 +
 tools/perf/util/symbol.c           |   17 +--
 tools/perf/util/symbol.h           |   24 +++
 11 files changed, 429 insertions(+), 190 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 738bdc6..13ffa5d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,6 +24,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
@@ -742,7 +743,6 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
-	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 
 config X86_IO_APIC
 	def_bool y
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a7aa8f9..900332b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -55,6 +55,7 @@ struct x86_pmu {
 	int		num_counters_fixed;
 	int		counter_bits;
 	u64		counter_mask;
+	int		apic;
 	u64		max_period;
 	u64		intel_ctrl;
 };
@@ -72,8 +73,8 @@ static const u64 p6_perfmon_event_map[] =
 {
   [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0000,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0000,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
@@ -613,6 +614,7 @@ static DEFINE_MUTEX(pmc_reserve_mutex);
 
 static bool reserve_pmc_hardware(void)
 {
+#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -627,9 +629,11 @@ static bool reserve_pmc_hardware(void)
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
+#endif
 
 	return true;
 
+#ifdef CONFIG_X86_LOCAL_APIC
 eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
@@ -644,10 +648,12 @@ perfctr_fail:
 		enable_lapic_nmi_watchdog();
 
 	return false;
+#endif
 }
 
 static void release_pmc_hardware(void)
 {
+#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	for (i = 0; i < x86_pmu.num_counters; i++) {
@@ -657,6 +663,7 @@ static void release_pmc_hardware(void)
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
+#endif
 }
 
 static void hw_perf_counter_destroy(struct perf_counter *counter)
@@ -748,6 +755,15 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
 		atomic64_set(&hwc->period_left, hwc->sample_period);
+	} else {
+		/*
+		 * If we have a PMU initialized but no APIC
+		 * interrupts, we cannot sample hardware
+		 * counters (user-space has to fall back and
+		 * sample via a hrtimer based software counter):
+		 */
+		if (!x86_pmu.apic)
+			return -EOPNOTSUPP;
 	}
 
 	counter->destroy = hw_perf_counter_destroy;
@@ -1449,18 +1465,22 @@ void smp_perf_pending_interrupt(struct pt_regs *regs)
 
 void set_perf_counter_pending(void)
 {
+#ifdef CONFIG_X86_LOCAL_APIC
 	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
+#endif
 }
 
 void perf_counters_lapic_init(void)
 {
-	if (!x86_pmu_initialized())
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (!x86_pmu.apic || !x86_pmu_initialized())
 		return;
 
 	/*
 	 * Always use NMI for PMU
 	 */
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
+#endif
 }
 
 static int __kprobes
@@ -1484,7 +1504,9 @@ perf_counter_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
+#endif
 	/*
 	 * Can't rely on the handled return value to say it was our NMI, two
 	 * counters could trigger 'simultaneously' raising two back-to-back NMIs.
@@ -1515,6 +1537,7 @@ static struct x86_pmu p6_pmu = {
 	.event_map		= p6_pmu_event_map,
 	.raw_event		= p6_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
+	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
 	.version		= 0,
 	.num_counters		= 2,
@@ -1541,6 +1564,7 @@ static struct x86_pmu intel_pmu = {
 	.event_map		= intel_pmu_event_map,
 	.raw_event		= intel_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
+	.apic			= 1,
 	/*
 	 * Intel PMCs cannot be accessed sanely above 32 bit width,
 	 * so we install an artificial 1<<31 period regardless of
@@ -1564,6 +1588,7 @@ static struct x86_pmu amd_pmu = {
 	.num_counters		= 4,
 	.counter_bits		= 48,
 	.counter_mask		= (1ULL << 48) - 1,
+	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
 };
@@ -1589,13 +1614,14 @@ static int p6_pmu_init(void)
 		return -ENODEV;
 	}
 
+	x86_pmu = p6_pmu;
+
 	if (!cpu_has_apic) {
-		pr_info("no Local APIC, try rebooting with lapic");
-		return -ENODEV;
+		pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
+		pr_info("no hardware sampling interrupt available.\n");
+		x86_pmu.apic = 0;
 	}
 
-	x86_pmu				= p6_pmu;
-
 	return 0;
 }
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a9d823a..b53f700 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -115,7 +115,7 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_TID				= 1U << 1,
 	PERF_SAMPLE_TIME			= 1U << 2,
 	PERF_SAMPLE_ADDR			= 1U << 3,
-	PERF_SAMPLE_GROUP			= 1U << 4,
+	PERF_SAMPLE_READ			= 1U << 4,
 	PERF_SAMPLE_CALLCHAIN			= 1U << 5,
 	PERF_SAMPLE_ID				= 1U << 6,
 	PERF_SAMPLE_CPU				= 1U << 7,
@@ -127,16 +127,32 @@ enum perf_counter_sample_format {
 };
 
 /*
- * Bits that can be set in attr.read_format to request that
- * reads on the counter should return the indicated quantities,
- * in increasing order of bit value, after the counter value.
+ * The format of the data returned by read() on a perf counter fd,
+ * as specified by attr.read_format:
+ *
+ * struct read_format {
+ * 	{ u64		value;
+ * 	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
+ * 	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ * 	  { u64		id;           } && PERF_FORMAT_ID
+ * 	} && !PERF_FORMAT_GROUP
+ *
+ * 	{ u64		nr;
+ * 	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
+ * 	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ * 	  { u64		value;
+ * 	    { u64	id;           } && PERF_FORMAT_ID
+ * 	  }		cntr[nr];
+ * 	} && PERF_FORMAT_GROUP
+ * };
  */
 enum perf_counter_read_format {
 	PERF_FORMAT_TOTAL_TIME_ENABLED		= 1U << 0,
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
+	PERF_FORMAT_GROUP			= 1U << 3,
 
-	PERF_FORMAT_MAX = 1U << 3, 		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 4, 		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
@@ -343,10 +359,8 @@ enum perf_event_type {
 	 * struct {
 	 * 	struct perf_event_header	header;
 	 * 	u32				pid, tid;
-	 * 	u64				value;
-	 * 	{ u64		time_enabled; 	} && PERF_FORMAT_ENABLED
-	 * 	{ u64		time_running; 	} && PERF_FORMAT_RUNNING
-	 * 	{ u64		parent_id;	} && PERF_FORMAT_ID
+	 *
+	 * 	struct read_format		values;
 	 * };
 	 */
 	PERF_EVENT_READ			= 8,
@@ -364,11 +378,22 @@ enum perf_event_type {
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
 	 * 	{ u64			period;   } && PERF_SAMPLE_PERIOD
 	 *
-	 *	{ u64			nr;
-	 *	  { u64 id, val; }	cnt[nr];  } && PERF_SAMPLE_GROUP
+	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
 	 *
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
+	 *
+	 * 	#
+	 * 	# The RAW record below is opaque data wrt the ABI
+	 * 	#
+	 * 	# That is, the ABI doesn't make any promises wrt to
+	 * 	# the stability of its content, it may vary depending
+	 * 	# on event, hardware, kernel version and phase of
+	 * 	# the moon.
+	 * 	#
+	 * 	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
+	 * 	#
+	 *
 	 *	{ u32			size;
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 * };
@@ -694,6 +719,8 @@ struct perf_sample_data {
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
 				 struct perf_sample_data *data);
+extern void perf_counter_output(struct perf_counter *counter, int nmi,
+				struct perf_sample_data *data);
 
 /*
  * Return 1 for a software counter, 0 for a hardware counter
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b0b20a0..534e20d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -88,6 +88,7 @@ void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
 void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
+void __weak hw_perf_counter_setup_online(int cpu)	{ barrier(); }
 
 int __weak
 hw_perf_group_sched_in(struct perf_counter *group_leader,
@@ -306,6 +307,10 @@ counter_sched_out(struct perf_counter *counter,
 		return;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	if (counter->pending_disable) {
+		counter->pending_disable = 0;
+		counter->state = PERF_COUNTER_STATE_OFF;
+	}
 	counter->tstamp_stopped = ctx->time;
 	counter->pmu->disable(counter);
 	counter->oncpu = -1;
@@ -1691,7 +1696,32 @@ static int perf_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static u64 perf_counter_read_tree(struct perf_counter *counter)
+static int perf_counter_read_size(struct perf_counter *counter)
+{
+	int entry = sizeof(u64); /* value */
+	int size = 0;
+	int nr = 1;
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		size += sizeof(u64);
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		size += sizeof(u64);
+
+	if (counter->attr.read_format & PERF_FORMAT_ID)
+		entry += sizeof(u64);
+
+	if (counter->attr.read_format & PERF_FORMAT_GROUP) {
+		nr += counter->group_leader->nr_siblings;
+		size += sizeof(u64);
+	}
+
+	size += entry * nr;
+
+	return size;
+}
+
+static u64 perf_counter_read_value(struct perf_counter *counter)
 {
 	struct perf_counter *child;
 	u64 total = 0;
@@ -1703,14 +1733,96 @@ static u64 perf_counter_read_tree(struct perf_counter *counter)
 	return total;
 }
 
+static int perf_counter_read_entry(struct perf_counter *counter,
+				   u64 read_format, char __user *buf)
+{
+	int n = 0, count = 0;
+	u64 values[2];
+
+	values[n++] = perf_counter_read_value(counter);
+	if (read_format & PERF_FORMAT_ID)
+		values[n++] = primary_counter_id(counter);
+
+	count = n * sizeof(u64);
+
+	if (copy_to_user(buf, values, count))
+		return -EFAULT;
+
+	return count;
+}
+
+static int perf_counter_read_group(struct perf_counter *counter,
+				   u64 read_format, char __user *buf)
+{
+	struct perf_counter *leader = counter->group_leader, *sub;
+	int n = 0, size = 0, err = -EFAULT;
+	u64 values[3];
+
+	values[n++] = 1 + leader->nr_siblings;
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+		values[n++] = leader->total_time_enabled +
+			atomic64_read(&leader->child_total_time_enabled);
+	}
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+		values[n++] = leader->total_time_running +
+			atomic64_read(&leader->child_total_time_running);
+	}
+
+	size = n * sizeof(u64);
+
+	if (copy_to_user(buf, values, size))
+		return -EFAULT;
+
+	err = perf_counter_read_entry(leader, read_format, buf + size);
+	if (err < 0)
+		return err;
+
+	size += err;
+
+	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+		err = perf_counter_read_entry(counter, read_format,
+				buf + size);
+		if (err < 0)
+			return err;
+
+		size += err;
+	}
+
+	return size;
+}
+
+static int perf_counter_read_one(struct perf_counter *counter,
+				 u64 read_format, char __user *buf)
+{
+	u64 values[4];
+	int n = 0;
+
+	values[n++] = perf_counter_read_value(counter);
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+		values[n++] = counter->total_time_enabled +
+			atomic64_read(&counter->child_total_time_enabled);
+	}
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+		values[n++] = counter->total_time_running +
+			atomic64_read(&counter->child_total_time_running);
+	}
+	if (read_format & PERF_FORMAT_ID)
+		values[n++] = primary_counter_id(counter);
+
+	if (copy_to_user(buf, values, n * sizeof(u64)))
+		return -EFAULT;
+
+	return n * sizeof(u64);
+}
+
 /*
  * Read the performance counter - simple non blocking version for now
  */
 static ssize_t
 perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 {
-	u64 values[4];
-	int n;
+	u64 read_format = counter->attr.read_format;
+	int ret;
 
 	/*
 	 * Return end-of-file for a read on a counter that is in
@@ -1720,28 +1832,18 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	if (counter->state == PERF_COUNTER_STATE_ERROR)
 		return 0;
 
+	if (count < perf_counter_read_size(counter))
+		return -ENOSPC;
+
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->child_mutex);
-	values[0] = perf_counter_read_tree(counter);
-	n = 1;
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		values[n++] = counter->total_time_enabled +
-			atomic64_read(&counter->child_total_time_enabled);
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		values[n++] = counter->total_time_running +
-			atomic64_read(&counter->child_total_time_running);
-	if (counter->attr.read_format & PERF_FORMAT_ID)
-		values[n++] = primary_counter_id(counter);
+	if (read_format & PERF_FORMAT_GROUP)
+		ret = perf_counter_read_group(counter, read_format, buf);
+	else
+		ret = perf_counter_read_one(counter, read_format, buf);
 	mutex_unlock(&counter->child_mutex);
 
-	if (count < n * sizeof(u64))
-		return -EINVAL;
-	count = n * sizeof(u64);
-
-	if (copy_to_user(buf, values, count))
-		return -EFAULT;
-
-	return count;
+	return ret;
 }
 
 static ssize_t
@@ -2245,7 +2347,7 @@ static void perf_pending_counter(struct perf_pending_entry *entry)
 
 	if (counter->pending_disable) {
 		counter->pending_disable = 0;
-		perf_counter_disable(counter);
+		__perf_counter_disable(counter);
 	}
 
 	if (counter->pending_wakeup) {
@@ -2630,7 +2732,80 @@ static u32 perf_counter_tid(struct perf_counter *counter, struct task_struct *p)
 	return task_pid_nr_ns(p, counter->ns);
 }
 
-static void perf_counter_output(struct perf_counter *counter, int nmi,
+static void perf_output_read_one(struct perf_output_handle *handle,
+				 struct perf_counter *counter)
+{
+	u64 read_format = counter->attr.read_format;
+	u64 values[4];
+	int n = 0;
+
+	values[n++] = atomic64_read(&counter->count);
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+		values[n++] = counter->total_time_enabled +
+			atomic64_read(&counter->child_total_time_enabled);
+	}
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+		values[n++] = counter->total_time_running +
+			atomic64_read(&counter->child_total_time_running);
+	}
+	if (read_format & PERF_FORMAT_ID)
+		values[n++] = primary_counter_id(counter);
+
+	perf_output_copy(handle, values, n * sizeof(u64));
+}
+
+/*
+ * XXX PERF_FORMAT_GROUP vs inherited counters seems difficult.
+ */
+static void perf_output_read_group(struct perf_output_handle *handle,
+			    struct perf_counter *counter)
+{
+	struct perf_counter *leader = counter->group_leader, *sub;
+	u64 read_format = counter->attr.read_format;
+	u64 values[5];
+	int n = 0;
+
+	values[n++] = 1 + leader->nr_siblings;
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		values[n++] = leader->total_time_enabled;
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		values[n++] = leader->total_time_running;
+
+	if (leader != counter)
+		leader->pmu->read(leader);
+
+	values[n++] = atomic64_read(&leader->count);
+	if (read_format & PERF_FORMAT_ID)
+		values[n++] = primary_counter_id(leader);
+
+	perf_output_copy(handle, values, n * sizeof(u64));
+
+	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+		n = 0;
+
+		if (sub != counter)
+			sub->pmu->read(sub);
+
+		values[n++] = atomic64_read(&sub->count);
+		if (read_format & PERF_FORMAT_ID)
+			values[n++] = primary_counter_id(sub);
+
+		perf_output_copy(handle, values, n * sizeof(u64));
+	}
+}
+
+static void perf_output_read(struct perf_output_handle *handle,
+			     struct perf_counter *counter)
+{
+	if (counter->attr.read_format & PERF_FORMAT_GROUP)
+		perf_output_read_group(handle, counter);
+	else
+		perf_output_read_one(handle, counter);
+}
+
+void perf_counter_output(struct perf_counter *counter, int nmi,
 				struct perf_sample_data *data)
 {
 	int ret;
@@ -2641,10 +2816,6 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 	struct {
 		u32 pid, tid;
 	} tid_entry;
-	struct {
-		u64 id;
-		u64 counter;
-	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
 	int callchain_size = 0;
 	u64 time;
@@ -2699,10 +2870,8 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		header.size += sizeof(u64);
 
-	if (sample_type & PERF_SAMPLE_GROUP) {
-		header.size += sizeof(u64) +
-			counter->nr_siblings * sizeof(group_entry);
-	}
+	if (sample_type & PERF_SAMPLE_READ)
+		header.size += perf_counter_read_size(counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		callchain = perf_callchain(data->regs);
@@ -2759,26 +2928,8 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		perf_output_put(&handle, data->period);
 
-	/*
-	 * XXX PERF_SAMPLE_GROUP vs inherited counters seems difficult.
-	 */
-	if (sample_type & PERF_SAMPLE_GROUP) {
-		struct perf_counter *leader, *sub;
-		u64 nr = counter->nr_siblings;
-
-		perf_output_put(&handle, nr);
-
-		leader = counter->group_leader;
-		list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-			if (sub != counter)
-				sub->pmu->read(sub);
-
-			group_entry.id = primary_counter_id(sub);
-			group_entry.counter = atomic64_read(&sub->count);
-
-			perf_output_put(&handle, group_entry);
-		}
-	}
+	if (sample_type & PERF_SAMPLE_READ)
+		perf_output_read(&handle, counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		if (callchain)
@@ -2817,8 +2968,6 @@ struct perf_read_event {
 
 	u32				pid;
 	u32				tid;
-	u64				value;
-	u64				format[3];
 };
 
 static void
@@ -2830,34 +2979,20 @@ perf_counter_read_event(struct perf_counter *counter,
 		.header = {
 			.type = PERF_EVENT_READ,
 			.misc = 0,
-			.size = sizeof(event) - sizeof(event.format),
+			.size = sizeof(event) + perf_counter_read_size(counter),
 		},
 		.pid = perf_counter_pid(counter, task),
 		.tid = perf_counter_tid(counter, task),
-		.value = atomic64_read(&counter->count),
 	};
-	int ret, i = 0;
-
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
-		event.header.size += sizeof(u64);
-		event.format[i++] = counter->total_time_enabled;
-	}
-
-	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
-		event.header.size += sizeof(u64);
-		event.format[i++] = counter->total_time_running;
-	}
-
-	if (counter->attr.read_format & PERF_FORMAT_ID) {
-		event.header.size += sizeof(u64);
-		event.format[i++] = primary_counter_id(counter);
-	}
+	int ret;
 
 	ret = perf_output_begin(&handle, counter, event.header.size, 0, 0);
 	if (ret)
 		return;
 
-	perf_output_copy(&handle, &event, event.header.size);
+	perf_output_put(&handle, event);
+	perf_output_read(&handle, counter);
+
 	perf_output_end(&handle);
 }
 
@@ -2893,10 +3028,10 @@ static void perf_counter_task_output(struct perf_counter *counter,
 		return;
 
 	task_event->event.pid = perf_counter_pid(counter, task);
-	task_event->event.ppid = perf_counter_pid(counter, task->real_parent);
+	task_event->event.ppid = perf_counter_pid(counter, current);
 
 	task_event->event.tid = perf_counter_tid(counter, task);
-	task_event->event.ptid = perf_counter_tid(counter, task->real_parent);
+	task_event->event.ptid = perf_counter_tid(counter, current);
 
 	perf_output_put(&handle, task_event->event);
 	perf_output_end(&handle);
@@ -3443,40 +3578,32 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
 {
-	struct perf_counter_context *ctx;
-	unsigned long flags;
-	int count;
-
+	/*
+	 * The counter is active, we're good!
+	 */
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		return 1;
 
+	/*
+	 * The counter is off/error, not counting.
+	 */
 	if (counter->state != PERF_COUNTER_STATE_INACTIVE)
 		return 0;
 
 	/*
-	 * If the counter is inactive, it could be just because
-	 * its task is scheduled out, or because it's in a group
-	 * which could not go on the PMU.  We want to count in
-	 * the first case but not the second.  If the context is
-	 * currently active then an inactive software counter must
-	 * be the second case.  If it's not currently active then
-	 * we need to know whether the counter was active when the
-	 * context was last active, which we can determine by
-	 * comparing counter->tstamp_stopped with ctx->time.
-	 *
-	 * We are within an RCU read-side critical section,
-	 * which protects the existence of *ctx.
+	 * The counter is inactive, if the context is active
+	 * we're part of a group that didn't make it on the 'pmu',
+	 * not counting.
 	 */
-	ctx = counter->ctx;
-	spin_lock_irqsave(&ctx->lock, flags);
-	count = 1;
-	/* Re-check state now we have the lock */
-	if (counter->state < PERF_COUNTER_STATE_INACTIVE ||
-	    counter->ctx->is_active ||
-	    counter->tstamp_stopped < ctx->time)
-		count = 0;
-	spin_unlock_irqrestore(&ctx->lock, flags);
-	return count;
+	if (counter->ctx->is_active)
+		return 0;
+
+	/*
+	 * We're inactive and the context is too, this means the
+	 * task is scheduled out, we're counting events that happen
+	 * to us, like migration events.
+	 */
+	return 1;
 }
 
 static int perf_swcounter_match(struct perf_counter *counter,
@@ -3928,9 +4055,9 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	atomic64_set(&hwc->period_left, hwc->sample_period);
 
 	/*
-	 * we currently do not support PERF_SAMPLE_GROUP on inherited counters
+	 * we currently do not support PERF_FORMAT_GROUP on inherited counters
 	 */
-	if (attr->inherit && (attr->sample_type & PERF_SAMPLE_GROUP))
+	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto done;
 
 	switch (attr->type) {
@@ -4592,6 +4719,11 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 		perf_counter_init_cpu(cpu);
 		break;
 
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		hw_perf_counter_setup_online(cpu);
+		break;
+
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		perf_counter_exit_cpu(cpu);
@@ -4616,6 +4748,8 @@ void __init perf_counter_init(void)
 {
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
+	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
+			(void *)(long)smp_processor_id());
 	register_cpu_notifier(&perf_cpu_nb);
 }
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 60411e9..c045b42 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -382,22 +382,29 @@ endif
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
-
 	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd > /dev/null 2>&1 && echo y")
 
-	has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
-
-	has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
-
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
-	else ifeq ($(has_bfd_iberty),y)
-		EXTLIBS += -lbfd -liberty
-	else ifeq ($(has_bfd_iberty_z),y)
-		EXTLIBS += -lbfd -liberty -lz
 	else
-		msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
-		BASIC_CFLAGS += -DNO_DEMANGLE
+		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
+		ifeq ($(has_bfd_iberty),y)
+			EXTLIBS += -lbfd -liberty
+		else
+			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
+			ifeq ($(has_bfd_iberty_z),y)
+				EXTLIBS += -lbfd -liberty -lz
+			else
+				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -liberty > /dev/null 2>&1 && echo y")
+				ifeq ($(has_cplus_demangle),y)
+					EXTLIBS += -liberty
+					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+				else
+					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
+					BASIC_CFLAGS += -DNO_DEMANGLE
+				endif
+			endif
+		endif
 	endif
 endif
 
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index f990fa8..d88c696 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -10,11 +10,12 @@
 
 #include "perf.h"
 
-#include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/cache.h"
 
 int cmd_list(int argc __used, const char **argv __used, const char *prefix __used)
 {
+	setup_pager();
 	print_events();
 	return 0;
 }
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0345aad..3d051b9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -34,7 +34,9 @@ static int			output;
 static const char		*output_name			= "perf.data";
 static int			group				= 0;
 static unsigned int		realtime_prio			= 0;
+static int			raw_samples			= 0;
 static int			system_wide			= 0;
+static int			profile_cpu			= -1;
 static pid_t			target_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
@@ -203,46 +205,48 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static void pid_synthesize_comm_event(pid_t pid, int full)
+static pid_t pid_synthesize_comm_event(pid_t pid, int full)
 {
 	struct comm_event comm_ev;
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
-	int fd;
-	size_t size;
-	char *field, *sep;
+	FILE *fp;
+	size_t size = 0;
 	DIR *tasks;
 	struct dirent dirent, *next;
+	pid_t tgid = 0;
 
-	snprintf(filename, sizeof(filename), "/proc/%d/stat", pid);
+	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
 
-	fd = open(filename, O_RDONLY);
-	if (fd < 0) {
+	fp = fopen(filename, "r");
+	if (fd == NULL) {
 		/*
 		 * We raced with a task exiting - just return:
 		 */
 		if (verbose)
 			fprintf(stderr, "couldn't open %s\n", filename);
-		return;
-	}
-	if (read(fd, bf, sizeof(bf)) < 0) {
-		fprintf(stderr, "couldn't read %s\n", filename);
-		exit(EXIT_FAILURE);
+		return 0;
 	}
-	close(fd);
 
-	/* 9027 (cat) R 6747 9027 6747 34816 9027 ... */
 	memset(&comm_ev, 0, sizeof(comm_ev));
-	field = strchr(bf, '(');
-	if (field == NULL)
-		goto out_failure;
-	sep = strchr(++field, ')');
-	if (sep == NULL)
-		goto out_failure;
-	size = sep - field;
-	memcpy(comm_ev.comm, field, size++);
-
-	comm_ev.pid = pid;
+	while (!comm_ev.comm[0] || !comm_ev.pid) {
+		if (fgets(bf, sizeof(bf), fp) == NULL)
+			goto out_failure;
+
+		if (memcmp(bf, "Name:", 5) == 0) {
+			char *name = bf + 5;
+			while (*name && isspace(*name))
+				++name;
+			size = strlen(name) - 1;
+			memcpy(comm_ev.comm, name, size++);
+		} else if (memcmp(bf, "Tgid:", 5) == 0) {
+			char *tgids = bf + 5;
+			while (*tgids && isspace(*tgids))
+				++tgids;
+			tgid = comm_ev.pid = atoi(tgids);
+		}
+	}
+
 	comm_ev.header.type = PERF_EVENT_COMM;
 	size = ALIGN(size, sizeof(u64));
 	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
@@ -251,7 +255,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 		comm_ev.tid = pid;
 
 		write_output(&comm_ev, comm_ev.header.size);
-		return;
+		goto out_fclose;
 	}
 
 	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
@@ -268,7 +272,10 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 		write_output(&comm_ev, comm_ev.header.size);
 	}
 	closedir(tasks);
-	return;
+
+out_fclose:
+	fclose(fp);
+	return tgid;
 
 out_failure:
 	fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
@@ -276,7 +283,7 @@ out_failure:
 	exit(EXIT_FAILURE);
 }
 
-static void pid_synthesize_mmap_samples(pid_t pid)
+static void pid_synthesize_mmap_samples(pid_t pid, pid_t tgid)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -328,7 +335,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			mmap_ev.len -= mmap_ev.start;
 			mmap_ev.header.size = (sizeof(mmap_ev) -
 					       (sizeof(mmap_ev.filename) - size));
-			mmap_ev.pid = pid;
+			mmap_ev.pid = tgid;
 			mmap_ev.tid = pid;
 
 			write_output(&mmap_ev, mmap_ev.header.size);
@@ -347,14 +354,14 @@ static void synthesize_all(void)
 
 	while (!readdir_r(proc, &dirent, &next) && next) {
 		char *end;
-		pid_t pid;
+		pid_t pid, tgid;
 
 		pid = strtol(dirent.d_name, &end, 10);
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		pid_synthesize_comm_event(pid, 1);
-		pid_synthesize_mmap_samples(pid);
+		tgid = pid_synthesize_comm_event(pid, 1);
+		pid_synthesize_mmap_samples(pid, tgid);
 	}
 
 	closedir(proc);
@@ -392,7 +399,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
 				  PERF_FORMAT_ID;
 
-	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
@@ -412,6 +419,8 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+	if (raw_samples)
+		attr->sample_type	|= PERF_SAMPLE_RAW;
 
 	attr->mmap		= track;
 	attr->comm		= track;
@@ -426,6 +435,8 @@ try_again:
 
 		if (err == EPERM)
 			die("Permission error - are you root?\n");
+		else if (err ==  ENODEV && profile_cpu != -1)
+			die("No such device - did you specify an out-of-range profile CPU?\n");
 
 		/*
 		 * If it's cycles then fall back to hrtimer
@@ -559,16 +570,22 @@ static int __cmd_record(int argc, const char **argv)
 		if (pid == -1)
 			pid = getpid();
 
-		open_counters(-1, pid);
-	} else for (i = 0; i < nr_cpus; i++)
-		open_counters(i, target_pid);
+		open_counters(profile_cpu, pid);
+	} else {
+		if (profile_cpu != -1) {
+			open_counters(profile_cpu, target_pid);
+		} else {
+			for (i = 0; i < nr_cpus; i++)
+				open_counters(i, target_pid);
+		}
+	}
 
 	if (file_new)
 		perf_header__write(header, output);
 
 	if (!system_wide) {
-		pid_synthesize_comm_event(pid, 0);
-		pid_synthesize_mmap_samples(pid);
+		pid_t tgid = pid_synthesize_comm_event(pid, 0);
+		pid_synthesize_mmap_samples(pid, tgid);
 	} else
 		synthesize_all();
 
@@ -636,10 +653,14 @@ static const struct option options[] = {
 		    "record events on existing pid"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
+	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
+		    "collect raw sample records from all opened counters"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &append_file,
 			    "append to the output file to do incremental profiling"),
+	OPT_INTEGER('C', "profile_cpu", &profile_cpu,
+			    "CPU to profile on"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file"),
 	OPT_LONG('c', "count", &default_interval,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 99274ce..b53a60f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1526,11 +1526,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		more_data += sizeof(u64);
 	}
 
-	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d: %p period: %Ld\n",
+	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
-		event->ip.pid,
+		event->ip.pid, event->ip.tid,
 		(void *)(long)ip,
 		(long long)period);
 
@@ -1590,10 +1590,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	if (show & show_mask) {
 		struct symbol *sym = resolve_symbol(thread, &map, &dso, &ip);
 
-		if (dso_list && dso && dso->name && !strlist__has_entry(dso_list, dso->name))
+		if (dso_list && (!dso || !dso->name ||
+				 !strlist__has_entry(dso_list, dso->name)))
 			return 0;
 
-		if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
+		if (sym_list && (!sym || !strlist__has_entry(sym_list, sym->name)))
 			return 0;
 
 		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
@@ -1612,10 +1613,11 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread = threads__findnew(event->mmap.pid);
 	struct map *map = map__new(&event->mmap);
 
-	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
+	dprintf("%p [%p]: PERF_EVENT_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->mmap.pid,
+		event->mmap.tid,
 		(void *)(long)event->mmap.start,
 		(void *)(long)event->mmap.len,
 		(void *)(long)event->mmap.pgoff,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4858d83..0441784 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -379,6 +379,7 @@ static int parse_tracepoint_event(const char **strp,
 				    struct perf_counter_attr *attr)
 {
 	const char *evt_name;
+	char *flags;
 	char sys_name[MAX_EVENT_LENGTH];
 	char id_buf[4];
 	int fd;
@@ -400,6 +401,15 @@ static int parse_tracepoint_event(const char **strp,
 	strncpy(sys_name, *strp, sys_length);
 	sys_name[sys_length] = '\0';
 	evt_name = evt_name + 1;
+
+	flags = strchr(evt_name, ':');
+	if (flags) {
+		*flags = '\0';
+		flags++;
+		if (!strncmp(flags, "record", strlen(flags)))
+			attr->sample_type |= PERF_SAMPLE_RAW;
+	}
+
 	evt_length = strlen(evt_name);
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return 0;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f1dcede..5c0f42e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -7,23 +7,8 @@
 #include <gelf.h>
 #include <elf.h>
 
-#ifndef NO_DEMANGLE
-#include <bfd.h>
-#else
-static inline
-char *bfd_demangle(void __used *v, const char __used *c, int __used i)
-{
-	return NULL;
-}
-#endif
-
 const char *sym_hist_filter;
 
-#ifndef DMGL_PARAMS
-#define DMGL_PARAMS      (1 << 0)       /* Include function args */
-#define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
-#endif
-
 enum dso_origin {
 	DSO__ORIG_KERNEL = 0,
 	DSO__ORIG_JAVA_JIT,
@@ -816,6 +801,8 @@ more:
 	}
 out:
 	free(name);
+	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
+		return 0;
 	return ret;
 }
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1e003ec..b53bf01 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -7,6 +7,30 @@
 #include <linux/rbtree.h>
 #include "module.h"
 
+#ifdef HAVE_CPLUS_DEMANGLE
+extern char *cplus_demangle(const char *, int);
+
+static inline char *bfd_demangle(void __used *v, const char *c, int i)
+{
+	return cplus_demangle(c, i);
+}
+#else
+#ifdef NO_DEMANGLE
+static inline char *bfd_demangle(void __used *v, const char __used *c,
+				 int __used i)
+{
+	return NULL;
+}
+#else
+#include <bfd.h>
+#endif
+#endif
+
+#ifndef DMGL_PARAMS
+#define DMGL_PARAMS      (1 << 0)       /* Include function args */
+#define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
+#endif
+
 struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
