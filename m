Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZAIKui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZAIKui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZAIKua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:50:30 -0500
Received: from ozlabs.org ([203.10.76.45]:60683 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZAIKu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:50:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.11205.194534.503059@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:49:41 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 7/9] powerpc/perf_counter: Add generic support for POWER-family PMU hardware
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the architecture-specific functions needed to access
PMU hardware on the 64-bit PowerPC processors.  It has been designed
for the IBM POWER family (POWER 4/4+/5/5+/6 and PPC970) but will
hopefully also suit other 64-bit PowerPC machines (although probably
not Cell given how different it is in this area).  This doesn't
include back-ends for any specific processors.

This implements a system which allows back-ends to express the
constraints that their hardware has on what events can be counted
simultaneously.  The constraints are expressed as a 64-bit mask +
64-bit value for each event, and the encoding is capable of
expressing the constraints arising from having a set of multiplexers
feeding an event bus, with some events being available through
multiple multiplexer settings, such as we get on POWER4 and PPC970.
Furthermore, the back-end can supply alternative event codes for
each event, and the constraint checking code will try all possible
combinations of alternative event codes to try to find a combination
that will fit.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 59530ae..9d7ff6d 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -8,3 +8,65 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/types.h>
+
+#define MAX_HWCOUNTERS		8
+#define MAX_EVENT_ALTERNATIVES	8
+
+/*
+ * This struct provides the constants and functions needed to
+ * describe the PMU on a particular POWER-family CPU.
+ */
+struct power_pmu {
+	int	n_counter;
+	int	max_alternatives;
+	u64	add_fields;
+	u64	test_adder;
+	int	(*compute_mmcr)(unsigned int events[], int n_ev,
+				unsigned int hwc[], u64 mmcr[]);
+	int	(*get_constraint)(unsigned int event, u64 *mskp, u64 *valp);
+	int	(*get_alternatives)(unsigned int event, unsigned int alt[]);
+	void	(*disable_pmc)(unsigned int pmc, u64 mmcr[]);
+	int	n_generic;
+	int	*generic_events;
+};
+
+extern struct power_pmu *ppmu;
+
+/*
+ * The power_pmu.get_constraint function returns a 64-bit value and
+ * a 64-bit mask that express the constraints between this event and
+ * other events.
+ *
+ * The value and mask are divided up into (non-overlapping) bitfields
+ * of three different types:
+ *
+ * Select field: this expresses the constraint that some set of bits
+ * in MMCR* needs to be set to a specific value for this event.  For a
+ * select field, the mask contains 1s in every bit of the field, and
+ * the value contains a unique value for each possible setting of the
+ * MMCR* bits.  The constraint checking code will ensure that two events
+ * that set the same field in their masks have the same value in their
+ * value dwords.
+ *
+ * Add field: this expresses the constraint that there can be at most
+ * N events in a particular class.  A field of k bits can be used for
+ * N <= 2^(k-1) - 1.  The mask has the most significant bit of the field
+ * set (and the other bits 0), and the value has only the least significant
+ * bit of the field set.  In addition, the 'add_fields' and 'test_adder'
+ * in the struct power_pmu for this processor come into play.  The
+ * add_fields value contains 1 in the LSB of the field, and the
+ * test_adder contains 2^(k-1) - 1 - N in the field.
+ *
+ * NAND field: this expresses the constraint that you may not have events
+ * in all of a set of classes.  (For example, on PPC970, you can't select
+ * events from the FPU, ISU and IDU simultaneously, although any two are
+ * possible.)  For N classes, the field is N+1 bits wide, and each class
+ * is assigned one bit from the least-significant N bits.  The mask has
+ * only the most-significant bit set, and the value has only the bit
+ * for the event's class set.  The test_adder has the least significant
+ * bit set in the field.
+ *
+ * If an event is not subject to the constraint expressed by a particular
+ * field, then it will have 0 in both the mask and value for that field.
+ */
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 1308a86..fde190b 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_PERF_COUNTERS)	+= perf_counter.o
 
 obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
 
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
new file mode 100644
index 0000000..4f2d6ea
--- /dev/null
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -0,0 +1,735 @@
+/*
+ * Performance counter support - powerpc architecture code
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/perf_counter.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <asm/reg.h>
+#include <asm/pmc.h>
+
+struct cpu_hw_counters {
+	int n_counters;
+	int n_percpu;
+	int disabled;
+	int n_added;
+	struct perf_counter *counter[MAX_HWCOUNTERS];
+	unsigned int events[MAX_HWCOUNTERS];
+	u64 mmcr[3];
+};
+DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
+
+struct power_pmu *ppmu;
+
+void perf_counter_print_debug(void)
+{
+}
+
+/*
+ * Return 1 for a software counter, 0 for a hardware counter
+ */
+static inline int is_software_counter(struct perf_counter *counter)
+{
+	return !counter->hw_event.raw && counter->hw_event.type < 0;
+}
+
+/*
+ * Read one performance monitor counter (PMC).
+ */
+static unsigned long read_pmc(int idx)
+{
+	unsigned long val;
+
+	switch (idx) {
+	case 1:
+		val = mfspr(SPRN_PMC1);
+		break;
+	case 2:
+		val = mfspr(SPRN_PMC2);
+		break;
+	case 3:
+		val = mfspr(SPRN_PMC3);
+		break;
+	case 4:
+		val = mfspr(SPRN_PMC4);
+		break;
+	case 5:
+		val = mfspr(SPRN_PMC5);
+		break;
+	case 6:
+		val = mfspr(SPRN_PMC6);
+		break;
+	case 7:
+		val = mfspr(SPRN_PMC7);
+		break;
+	case 8:
+		val = mfspr(SPRN_PMC8);
+		break;
+	default:
+		printk(KERN_ERR "oops trying to read PMC%d\n", idx);
+		val = 0;
+	}
+	return val;
+}
+
+/*
+ * Write one PMC.
+ */
+static void write_pmc(int idx, unsigned long val)
+{
+	switch (idx) {
+	case 1:
+		mtspr(SPRN_PMC1, val);
+		break;
+	case 2:
+		mtspr(SPRN_PMC2, val);
+		break;
+	case 3:
+		mtspr(SPRN_PMC3, val);
+		break;
+	case 4:
+		mtspr(SPRN_PMC4, val);
+		break;
+	case 5:
+		mtspr(SPRN_PMC5, val);
+		break;
+	case 6:
+		mtspr(SPRN_PMC6, val);
+		break;
+	case 7:
+		mtspr(SPRN_PMC7, val);
+		break;
+	case 8:
+		mtspr(SPRN_PMC8, val);
+		break;
+	default:
+		printk(KERN_ERR "oops trying to write PMC%d\n", idx);
+	}
+}
+
+/*
+ * Check if a set of events can all go on the PMU at once.
+ * If they can't, this will look at alternative codes for the events
+ * and see if any combination of alternative codes is feasible.
+ * The feasible set is returned in event[].
+ */
+static int power_check_constraints(unsigned int event[], int n_ev)
+{
+	u64 mask, value, nv;
+	unsigned int alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 smasks[MAX_HWCOUNTERS], svalues[MAX_HWCOUNTERS];
+	int n_alt[MAX_HWCOUNTERS], choice[MAX_HWCOUNTERS];
+	int i, j;
+	u64 addf = ppmu->add_fields;
+	u64 tadd = ppmu->test_adder;
+
+	if (n_ev > ppmu->n_counter)
+		return -1;
+
+	/* First see if the events will go on as-is */
+	for (i = 0; i < n_ev; ++i) {
+		alternatives[i][0] = event[i];
+		if (ppmu->get_constraint(event[i], &amasks[i][0],
+					 &avalues[i][0]))
+			return -1;
+		choice[i] = 0;
+	}
+	value = mask = 0;
+	for (i = 0; i < n_ev; ++i) {
+		nv = (value | avalues[i][0]) + (value & avalues[i][0] & addf);
+		if ((((nv + tadd) ^ value) & mask) != 0 ||
+		    (((nv + tadd) ^ avalues[i][0]) & amasks[i][0]) != 0)
+			break;
+		value = nv;
+		mask |= amasks[i][0];
+	}
+	if (i == n_ev)
+		return 0;	/* all OK */
+
+	/* doesn't work, gather alternatives... */
+	if (!ppmu->get_alternatives)
+		return -1;
+	for (i = 0; i < n_ev; ++i) {
+		n_alt[i] = ppmu->get_alternatives(event[i], alternatives[i]);
+		for (j = 1; j < n_alt[i]; ++j)
+			ppmu->get_constraint(alternatives[i][j],
+					     &amasks[i][j], &avalues[i][j]);
+	}
+
+	/* enumerate all possibilities and see if any will work */
+	i = 0;
+	j = -1;
+	value = mask = nv = 0;
+	while (i < n_ev) {
+		if (j >= 0) {
+			/* we're backtracking, restore context */
+			value = svalues[i];
+			mask = smasks[i];
+			j = choice[i];
+		}
+		/*
+		 * See if any alternative k for event i,
+		 * where k > j, will satisfy the constraints.
+		 */
+		while (++j < n_alt[i]) {
+			nv = (value | avalues[i][j]) +
+				(value & avalues[i][j] & addf);
+			if ((((nv + tadd) ^ value) & mask) == 0 &&
+			    (((nv + tadd) ^ avalues[i][j])
+			     & amasks[i][j]) == 0)
+				break;
+		}
+		if (j >= n_alt[i]) {
+			/*
+			 * No feasible alternative, backtrack
+			 * to event i-1 and continue enumerating its
+			 * alternatives from where we got up to.
+			 */
+			if (--i < 0)
+				return -1;
+		} else {
+			/*
+			 * Found a feasible alternative for event i,
+			 * remember where we got up to with this event,
+			 * go on to the next event, and start with
+			 * the first alternative for it.
+			 */
+			choice[i] = j;
+			svalues[i] = value;
+			smasks[i] = mask;
+			value = nv;
+			mask |= amasks[i][j];
+			++i;
+			j = -1;
+		}
+	}
+
+	/* OK, we have a feasible combination, tell the caller the solution */
+	for (i = 0; i < n_ev; ++i)
+		event[i] = alternatives[i][choice[i]];
+	return 0;
+}
+
+static void power_perf_read(struct perf_counter *counter)
+{
+	long val, delta, prev;
+
+	if (!counter->hw.idx)
+		return;
+	/*
+	 * Performance monitor interrupts come even when interrupts
+	 * are soft-disabled, as long as interrupts are hard-enabled.
+	 * Therefore we treat them like NMIs.
+	 */
+	do {
+		prev = atomic64_read(&counter->hw.prev_count);
+		barrier();
+		val = read_pmc(counter->hw.idx);
+	} while (atomic64_cmpxchg(&counter->hw.prev_count, prev, val) != prev);
+
+	/* The counters are only 32 bits wide */
+	delta = (val - prev) & 0xfffffffful;
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &counter->hw.period_left);
+}
+
+/*
+ * Disable all counters to prevent PMU interrupts and to allow
+ * counters to be added or removed.
+ * Interrupts should have been disabled by the caller.
+ */
+u64 hw_perf_save_disable(void)
+{
+	struct cpu_hw_counters *cpuhw;
+	unsigned long ret;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+
+	ret = cpuhw->disabled;
+	if (!ret) {
+		cpuhw->disabled = 1;
+		cpuhw->n_added = 0;
+
+		/*
+		 * Set the 'freeze counters' bit.
+		 * The barrier is to make sure the mtspr has been
+		 * executed and the PMU has frozen the counters
+		 * before we return.
+		 */
+		mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | MMCR0_FC);
+		mb();
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Re-enable all counters if disable == 0.
+ * If we were previously disabled and counters were added, then
+ * put the new config on the PMU.
+ */
+void hw_perf_restore(u64 disable)
+{
+	struct perf_counter *counter;
+	struct cpu_hw_counters *cpuhw;
+	unsigned long flags;
+	long i;
+	unsigned long val;
+	s64 left;
+	unsigned int hwc_index[MAX_HWCOUNTERS];
+
+	if (disable)
+		return;
+	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	cpuhw->disabled = 0;
+
+	/*
+	 * If we didn't change anything, or only removed counters,
+	 * no need to recalculate MMCR* settings and reset the PMCs.
+	 * Just reenable the PMU with the current MMCR* settings
+	 * (possibly updated for removal of counters).
+	 */
+	if (!cpuhw->n_added) {
+		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+		mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+		goto out;
+	}
+
+	/*
+	 * Compute MMCR* values for the new set of counters
+	 */
+	if (ppmu->compute_mmcr(cpuhw->events, cpuhw->n_counters, hwc_index,
+			       cpuhw->mmcr)) {
+		/* shouldn't ever get here */
+		printk(KERN_ERR "oops compute_mmcr failed\n");
+		goto out;
+	}
+
+	/*
+	 * Write the new configuration to MMCR* with the freeze
+	 * bit set and set the hardware counters to their initial values.
+	 * Then unfreeze the counters.
+	 */
+	mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
+				| MMCR0_FC);
+
+	/*
+	 * Read off any pre-existing counters that need to move
+	 * to another PMC.
+	 */
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter->hw.idx && counter->hw.idx != hwc_index[i] + 1) {
+			power_perf_read(counter);
+			write_pmc(counter->hw.idx, 0);
+			counter->hw.idx = 0;
+		}
+	}
+
+	/*
+	 * Initialize the PMCs for all the new and moved counters.
+	 */
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter->hw.idx)
+			continue;
+		val = 0;
+		if (counter->hw_event.irq_period) {
+			left = atomic64_read(&counter->hw.period_left);
+			if (left < 0x80000000L)
+				val = 0x80000000L - left;
+		}
+		atomic64_set(&counter->hw.prev_count, val);
+		counter->hw.idx = hwc_index[i] + 1;
+		write_pmc(counter->hw.idx, val);
+	}
+	mb();
+	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
+	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+
+ out:
+	local_irq_restore(flags);
+}
+
+static int collect_events(struct perf_counter *group, int max_count,
+			  struct perf_counter *ctrs[], unsigned int *events)
+{
+	int n = 0;
+	struct perf_counter *counter;
+
+	if (!is_software_counter(group)) {
+		if (n >= max_count)
+			return -1;
+		ctrs[n] = group;
+		events[n++] = group->hw.config;
+	}
+	list_for_each_entry(counter, &group->sibling_list, list_entry) {
+		if (!is_software_counter(counter) &&
+		    counter->state != PERF_COUNTER_STATE_OFF) {
+			if (n >= max_count)
+				return -1;
+			ctrs[n] = counter;
+			events[n++] = counter->hw.config;
+		}
+	}
+	return n;
+}
+
+static void counter_sched_in(struct perf_counter *counter, int cpu)
+{
+	counter->state = PERF_COUNTER_STATE_ACTIVE;
+	counter->oncpu = cpu;
+	if (is_software_counter(counter))
+		counter->hw_ops->enable(counter);
+}
+
+/*
+ * Called to enable a whole group of counters.
+ * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
+ * Assumes the caller has disabled interrupts and has
+ * frozen the PMU with hw_perf_save_disable.
+ */
+int hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu)
+{
+	struct cpu_hw_counters *cpuhw;
+	long i, n, n0;
+	struct perf_counter *sub;
+
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	n0 = cpuhw->n_counters;
+	n = collect_events(group_leader, ppmu->n_counter - n0,
+			   &cpuhw->counter[n0], &cpuhw->events[n0]);
+	if (n < 0)
+		return -EAGAIN;
+	if (power_check_constraints(cpuhw->events, n + n0))
+		return -EAGAIN;
+	cpuhw->n_counters = n0 + n;
+	cpuhw->n_added += n;
+
+	/*
+	 * OK, this group can go on; update counter states etc.,
+	 * and enable any software counters
+	 */
+	for (i = n0; i < n0 + n; ++i)
+		cpuhw->counter[i]->hw.config = cpuhw->events[i];
+	n = 1;
+	counter_sched_in(group_leader, cpu);
+	list_for_each_entry(sub, &group_leader->sibling_list, list_entry) {
+		if (sub->state != PERF_COUNTER_STATE_OFF) {
+			counter_sched_in(sub, cpu);
+			++n;
+		}
+	}
+	cpuctx->active_oncpu += n;
+	ctx->nr_active += n;
+
+	return 1;
+}
+
+/*
+ * Add a counter to the PMU.
+ * If all counters are not already frozen, then we disable and
+ * re-enable the PMU in order to get hw_perf_restore to do the
+ * actual work of reconfiguring the PMU.
+ */
+static int power_perf_enable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuhw;
+	unsigned long flags;
+	u64 pmudis;
+	int n0;
+	int ret = -EAGAIN;
+
+	local_irq_save(flags);
+	pmudis = hw_perf_save_disable();
+
+	/*
+	 * Add the counter to the list (if there is room)
+	 * and check whether the total set is still feasible.
+	 */
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	n0 = cpuhw->n_counters;
+	if (n0 >= ppmu->n_counter)
+		goto out;
+	cpuhw->counter[n0] = counter;
+	cpuhw->events[n0] = counter->hw.config;
+	if (power_check_constraints(cpuhw->events, n0 + 1))
+		goto out;
+
+	counter->hw.config = cpuhw->events[n0];
+	++cpuhw->n_counters;
+	++cpuhw->n_added;
+
+	ret = 0;
+ out:
+	hw_perf_restore(pmudis);
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Remove a counter from the PMU.
+ * If all counters are already frozen, we can defer updating the
+ * hardware config until counters get re-enabled.
+ */
+static void power_perf_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuhw;
+	long i;
+
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	ppmu->disable_pmc(counter->hw.idx, cpuhw->mmcr);
+	if (!cpuhw->disabled)
+		mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | MMCR0_FC);
+	power_perf_read(counter);
+	write_pmc(counter->hw.idx, 0);
+	counter->hw.idx = 0;
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		if (counter == cpuhw->counter[i]) {
+			while (++i < cpuhw->n_counters)
+				cpuhw->counter[i-1] = cpuhw->counter[i];
+			--cpuhw->n_counters;
+			break;
+		}
+	}
+	if (!cpuhw->disabled) {
+		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+		mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+	}
+}
+
+struct hw_perf_counter_ops power_perf_ops = {
+	.enable = power_perf_enable,
+	.disable = power_perf_disable,
+	.read = power_perf_read
+};
+
+const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	unsigned long ev;
+	struct perf_counter *ctrs[MAX_HWCOUNTERS];
+	unsigned int events[MAX_HWCOUNTERS];
+	int n;
+
+	if (!ppmu)
+		return NULL;
+	ev = counter->hw_event.type;
+	if (!counter->hw_event.raw) {
+		if (ev >= ppmu->n_generic ||
+		    ppmu->generic_events[ev] == 0)
+			return NULL;
+		ev = ppmu->generic_events[ev];
+	}
+	counter->hw.config_base = ev;
+	counter->hw.idx = 0;
+
+	/*
+	 * If this is in a group, check if it can go on with all the
+	 * other hardware counters in the group.  We assume the counter
+	 * hasn't been linked into its leader's sibling list at this point.
+	 */
+	n = 0;
+	if (counter->group_leader != counter) {
+		n = collect_events(counter->group_leader, ppmu->n_counter - 1,
+				   ctrs, events);
+		if (n < 0)
+			return NULL;
+	}
+	events[n++] = ev;
+	if (power_check_constraints(events, n))
+		return NULL;
+
+	counter->hw.config = events[n - 1];
+	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
+	return &power_perf_ops;
+}
+
+/*
+ * Handle wakeups.
+ */
+void perf_counter_do_pending(void)
+{
+	int i;
+	struct cpu_hw_counters *ctrs = &__get_cpu_var(cpu_hw_counters);
+	struct perf_counter *counter;
+
+	set_perf_counter_pending(0);
+	for (i = 0; i < ppmu->n_counter; ++i) {
+		counter = ctrs->counter[i];
+		if (counter && counter->wakeup_pending) {
+			counter->wakeup_pending = 0;
+			wake_up(&counter->waitq);
+		}
+	}
+}
+
+/*
+ * Record data for an irq counter.
+ * This function was lifted from the x86 code; maybe it should
+ * go in the core?
+ */
+static void perf_store_irq_data(struct perf_counter *counter, u64 data)
+{
+	struct perf_data *irqdata = counter->irqdata;
+
+	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
+		irqdata->overrun++;
+	} else {
+		u64 *p = (u64 *) &irqdata->data[irqdata->len];
+
+		*p = data;
+		irqdata->len += sizeof(u64);
+	}
+}
+
+/*
+ * Record all the values of the counters in a group
+ */
+static void perf_handle_group(struct perf_counter *counter)
+{
+	struct perf_counter *leader, *sub;
+
+	leader = counter->group_leader;
+	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+		if (sub != counter)
+			sub->hw_ops->read(sub);
+		perf_store_irq_data(counter, sub->hw_event.type);
+		perf_store_irq_data(counter, atomic64_read(&sub->count));
+	}
+}
+
+/*
+ * A counter has overflowed; update its count and record
+ * things if requested.  Note that interrupts are hard-disabled
+ * here so there is no possibility of being interrupted.
+ */
+static void record_and_restart(struct perf_counter *counter, long val,
+			       struct pt_regs *regs)
+{
+	s64 prev, delta, left;
+	int record = 0;
+
+	/* we don't have to worry about interrupts here */
+	prev = atomic64_read(&counter->hw.prev_count);
+	delta = (val - prev) & 0xfffffffful;
+	atomic64_add(delta, &counter->count);
+
+	/*
+	 * See if the total period for this counter has expired,
+	 * and update for the next period.
+	 */
+	left = atomic64_read(&counter->hw.period_left) - delta;
+	if (left <= 0 && counter->hw_event.irq_period) {
+		left += counter->hw_event.irq_period;
+		if (left <= 0)
+			left = counter->hw_event.irq_period;
+		record = 1;
+	}
+	val = 0;
+	if (counter->hw_event.irq_period && left < 0x80000000L)
+		val = 0x80000000L - left;
+	write_pmc(counter->hw.idx, val);
+	atomic64_set(&counter->hw.prev_count, val);
+	atomic64_set(&counter->hw.period_left, left);
+
+	/*
+	 * Finally record data if requested.
+	 */
+	if (record) {
+		switch (counter->hw_event.record_type) {
+		case PERF_RECORD_SIMPLE:
+			break;
+		case PERF_RECORD_IRQ:
+			perf_store_irq_data(counter, instruction_pointer(regs));
+			counter->wakeup_pending = 1;
+			break;
+		case PERF_RECORD_GROUP:
+			perf_handle_group(counter);
+			counter->wakeup_pending = 1;
+			break;
+		}
+	}
+}
+
+/*
+ * Performance monitor interrupt stuff
+ */
+static void perf_counter_interrupt(struct pt_regs *regs)
+{
+	int i;
+	struct cpu_hw_counters *ctrs = &__get_cpu_var(cpu_hw_counters);
+	struct perf_counter *counter;
+	long val;
+	int need_wakeup = 0;
+
+	for (i = 0; i < ppmu->n_counter; ++i) {
+		counter = ctrs->counter[i];
+		if (!counter)
+			continue;
+		val = read_pmc(i + 1);
+		if ((int)val < 0) {
+			/* counter has overflowed */
+			record_and_restart(counter, val, regs);
+			if (counter->wakeup_pending)
+				need_wakeup = 1;
+		}
+	}
+
+	/*
+	 * Clear FC (freeze counters) and PMAO (perf mon alert occurred) bits
+	 * in order to start the counters again and reset the irq.
+	 * XXX might want to use MSR.PM to keep the counters frozen until
+	 * we get back out of this interrupt.
+	 */
+	mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~(MMCR0_FC | MMCR0_PMAO));
+
+	/*
+	 * If we need a wakeup, check whether interrupts were soft-enabled
+	 * when we took the interrupt.  If they were, we can wake stuff up
+	 * immediately; otherwise we'll have to set a flag and do the
+	 * wakeup when interrupts get soft-enabled.
+	 */
+	if (need_wakeup) {
+		if (regs->softe) {
+			irq_enter();
+			perf_counter_do_pending();
+			irq_exit();
+		} else {
+			set_perf_counter_pending(1);
+		}
+	}
+}
+
+static int init_perf_counters(void)
+{
+	unsigned long pvr;
+
+	if (reserve_pmc_hardware(perf_counter_interrupt)) {
+		printk(KERN_ERR "Couldn't init performance monitor subsystem\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+arch_initcall(init_perf_counters);
