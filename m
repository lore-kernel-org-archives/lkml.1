Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZD2Mja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZD2Mja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZD2MjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:39:06 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50719 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZD2MjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:39:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18936.19035.163066.892208@cargo.ozlabs.ibm.com>
Date: Wed, 29 Apr 2009 22:38:51 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: powerpc: allow use of limited-function counters
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POWER5+ and POWER6 have two hardware counters with limited functionality:
PMC5 counts instructions completed in run state and PMC6 counts cycles
in run state.  (Run state is the state when a hardware RUN bit is 1;
the idle task clears RUN while waiting for work to do and sets it when
there is work to do.)

These counters can't be written to by the kernel, can't generate
interrupts, and don't obey the freeze conditions.  That means we can
only use them for per-task counters (where we know we'll always be in
run state; we can't put a per-task counter on an idle task), and only
if we don't want interrupts and we do want to count in all processor
modes.

Obviously some counters can't go on a limited hardware counter, but there
are also situations where we can only put a counter on a limited hardware
counter - if there are already counters on that exclude some processor
modes and we want to put on a per-task cycle or instruction counter that
doesn't exclude any processor mode, it could go on if it can use a
limited hardware counter.

To keep track of these constraints, this adds a flags argument to the
processor-specific get_alternatives() functions, with three bits defined:
one to say that we can accept alternative event codes that go on limited
counters, one to say we only want alternatives on limited counters, and
one to say that this is a per-task counter and therefore events that are
gated by run state are equivalent to those that aren't (e.g. a "cycles"
event is equivalent to a "cycles in run state" event).  These flags
are computed for each counter and stored in the counter->hw.counter_base
field (slightly wonky name for what it does, but it was an existing
unused field).

Since the limited counters don't freeze when we freeze the other counters,
we need some special handling to avoid getting skew between things counted
on the limited counters and those counted on normal counters.  To minimize
this skew, if we are using any limited counters, we read PMC5 and PMC6
immediately after setting and clearing the freeze bit.  This is done in
a single asm in the new write_mmcr0() function.

The code here is specific to PMC5 and PMC6 being the limited hardware
counters.  Being more general (e.g. having a bitmap of limited hardware
counter numbers) would have meant more complex code to read the limited
counters when freezing and unfreezing the normal counters, with
conditional branches, which would have increased the skew.  Since it
isn't necessary for the code to be more general at this stage, it isn't.

This also extends the back-ends for POWER5+ and POWER6 to be able to
handle up to 6 counters rather than the 4 they previously handled.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/perf_counter.h |   13 ++-
 arch/powerpc/kernel/perf_counter.c      |  297 +++++++++++++++++++++++++++----
 arch/powerpc/kernel/power4-pmu.c        |    3 +-
 arch/powerpc/kernel/power5+-pmu.c       |  117 ++++++++++--
 arch/powerpc/kernel/power5-pmu.c        |    3 +-
 arch/powerpc/kernel/power6-pmu.c        |  119 +++++++++++--
 arch/powerpc/kernel/ppc970-pmu.c        |    3 +-
 7 files changed, 479 insertions(+), 76 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 9d7ff6d..56d66c3 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -12,6 +12,7 @@
 
 #define MAX_HWCOUNTERS		8
 #define MAX_EVENT_ALTERNATIVES	8
+#define MAX_LIMITED_HWCOUNTERS	2
 
 /*
  * This struct provides the constants and functions needed to
@@ -25,8 +26,11 @@ struct power_pmu {
 	int	(*compute_mmcr)(unsigned int events[], int n_ev,
 				unsigned int hwc[], u64 mmcr[]);
 	int	(*get_constraint)(unsigned int event, u64 *mskp, u64 *valp);
-	int	(*get_alternatives)(unsigned int event, unsigned int alt[]);
+	int	(*get_alternatives)(unsigned int event, unsigned int flags,
+				    unsigned int alt[]);
 	void	(*disable_pmc)(unsigned int pmc, u64 mmcr[]);
+	int	(*limited_pmc_event)(unsigned int event);
+	int	limited_pmc5_6;	/* PMC5 and PMC6 have limited function */
 	int	n_generic;
 	int	*generic_events;
 };
@@ -34,6 +38,13 @@ struct power_pmu {
 extern struct power_pmu *ppmu;
 
 /*
+ * Values for flags to get_alternatives()
+ */
+#define PPMU_LIMITED_PMC_OK	1	/* can put this on a limited PMC */
+#define PPMU_LIMITED_PMC_REQD	2	/* have to put this on a limited PMC */
+#define PPMU_ONLY_COUNT_RUN	4	/* only counting in run state */
+
+/*
  * The power_pmu.get_constraint function returns a 64-bit value and
  * a 64-bit mask that express the constraints between this event and
  * other events.
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index bd76d0f..c47a02e 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -23,10 +23,14 @@ struct cpu_hw_counters {
 	int n_percpu;
 	int disabled;
 	int n_added;
+	int n_limited;
+	u8  pmcs_enabled;
 	struct perf_counter *counter[MAX_HWCOUNTERS];
 	unsigned int events[MAX_HWCOUNTERS];
+	unsigned int flags[MAX_HWCOUNTERS];
 	u64 mmcr[3];
-	u8 pmcs_enabled;
+	struct perf_counter *limited_counter[MAX_LIMITED_HWCOUNTERS];
+	u8  limited_hwidx[MAX_LIMITED_HWCOUNTERS];
 };
 DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
 
@@ -127,7 +131,8 @@ static void write_pmc(int idx, unsigned long val)
  * and see if any combination of alternative codes is feasible.
  * The feasible set is returned in event[].
  */
-static int power_check_constraints(unsigned int event[], int n_ev)
+static int power_check_constraints(unsigned int event[], unsigned int cflags[],
+				   int n_ev)
 {
 	u64 mask, value, nv;
 	unsigned int alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
@@ -144,11 +149,15 @@ static int power_check_constraints(unsigned int event[], int n_ev)
 
 	/* First see if the events will go on as-is */
 	for (i = 0; i < n_ev; ++i) {
-		alternatives[i][0] = event[i];
+		if ((cflags[i] & PPMU_LIMITED_PMC_REQD)
+		    && !ppmu->limited_pmc_event(event[i])) {
+			ppmu->get_alternatives(event[i], cflags[i],
+					       alternatives[i]);
+			event[i] = alternatives[i][0];
+		}
 		if (ppmu->get_constraint(event[i], &amasks[i][0],
 					 &avalues[i][0]))
 			return -1;
-		choice[i] = 0;
 	}
 	value = mask = 0;
 	for (i = 0; i < n_ev; ++i) {
@@ -166,7 +175,9 @@ static int power_check_constraints(unsigned int event[], int n_ev)
 	if (!ppmu->get_alternatives)
 		return -1;
 	for (i = 0; i < n_ev; ++i) {
-		n_alt[i] = ppmu->get_alternatives(event[i], alternatives[i]);
+		choice[i] = 0;
+		n_alt[i] = ppmu->get_alternatives(event[i], cflags[i],
+						  alternatives[i]);
 		for (j = 1; j < n_alt[i]; ++j)
 			ppmu->get_constraint(alternatives[i][j],
 					     &amasks[i][j], &avalues[i][j]);
@@ -231,28 +242,41 @@ static int power_check_constraints(unsigned int event[], int n_ev)
  * exclude_{user,kernel,hv} with each other and any previously
  * added counters.
  */
-static int check_excludes(struct perf_counter **ctrs, int n_prev, int n_new)
+static int check_excludes(struct perf_counter **ctrs, unsigned int cflags[],
+			  int n_prev, int n_new)
 {
-	int eu, ek, eh;
-	int i, n;
+	int eu = 0, ek = 0, eh = 0;
+	int i, n, first;
 	struct perf_counter *counter;
 
 	n = n_prev + n_new;
 	if (n <= 1)
 		return 0;
 
-	eu = ctrs[0]->hw_event.exclude_user;
-	ek = ctrs[0]->hw_event.exclude_kernel;
-	eh = ctrs[0]->hw_event.exclude_hv;
-	if (n_prev == 0)
-		n_prev = 1;
-	for (i = n_prev; i < n; ++i) {
+	first = 1;
+	for (i = 0; i < n; ++i) {
+		if (cflags[i] & PPMU_LIMITED_PMC_OK) {
+			cflags[i] &= ~PPMU_LIMITED_PMC_REQD;
+			continue;
+		}
 		counter = ctrs[i];
-		if (counter->hw_event.exclude_user != eu ||
-		    counter->hw_event.exclude_kernel != ek ||
-		    counter->hw_event.exclude_hv != eh)
+		if (first) {
+			eu = counter->hw_event.exclude_user;
+			ek = counter->hw_event.exclude_kernel;
+			eh = counter->hw_event.exclude_hv;
+			first = 0;
+		} else if (counter->hw_event.exclude_user != eu ||
+			   counter->hw_event.exclude_kernel != ek ||
+			   counter->hw_event.exclude_hv != eh) {
 			return -EAGAIN;
+		}
 	}
+
+	if (eu || ek || eh)
+		for (i = 0; i < n; ++i)
+			if (cflags[i] & PPMU_LIMITED_PMC_OK)
+				cflags[i] |= PPMU_LIMITED_PMC_REQD;
+
 	return 0;
 }
 
@@ -280,6 +304,85 @@ static void power_perf_read(struct perf_counter *counter)
 }
 
 /*
+ * On some machines, PMC5 and PMC6 can't be written, don't respect
+ * the freeze conditions, and don't generate interrupts.  This tells
+ * us if `counter' is using such a PMC.
+ */
+static int is_limited_pmc(int pmcnum)
+{
+	return ppmu->limited_pmc5_6 && (pmcnum == 5 || pmcnum == 6);
+}
+
+static void freeze_limited_counters(struct cpu_hw_counters *cpuhw,
+				    unsigned long pmc5, unsigned long pmc6)
+{
+	struct perf_counter *counter;
+	u64 val, prev, delta;
+	int i;
+
+	for (i = 0; i < cpuhw->n_limited; ++i) {
+		counter = cpuhw->limited_counter[i];
+		if (!counter->hw.idx)
+			continue;
+		val = (counter->hw.idx == 5) ? pmc5 : pmc6;
+		prev = atomic64_read(&counter->hw.prev_count);
+		counter->hw.idx = 0;
+		delta = (val - prev) & 0xfffffffful;
+		atomic64_add(delta, &counter->count);
+	}
+}
+
+static void thaw_limited_counters(struct cpu_hw_counters *cpuhw,
+				  unsigned long pmc5, unsigned long pmc6)
+{
+	struct perf_counter *counter;
+	u64 val;
+	int i;
+
+	for (i = 0; i < cpuhw->n_limited; ++i) {
+		counter = cpuhw->limited_counter[i];
+		counter->hw.idx = cpuhw->limited_hwidx[i];
+		val = (counter->hw.idx == 5) ? pmc5 : pmc6;
+		atomic64_set(&counter->hw.prev_count, val);
+		perf_counter_update_userpage(counter);
+	}
+}
+
+/*
+ * Since limited counters don't respect the freeze conditions, we
+ * have to read them immediately after freezing or unfreezing the
+ * other counters.  We try to keep the values from the limited
+ * counters as consistent as possible by keeping the delay (in
+ * cycles and instructions) between freezing/unfreezing and reading
+ * the limited counters as small and consistent as possible.
+ * Therefore, if any limited counters are in use, we read them
+ * both, and always in the same order, to minimize variability,
+ * and do it inside the same asm that writes MMCR0.
+ */
+static void write_mmcr0(struct cpu_hw_counters *cpuhw, unsigned long mmcr0)
+{
+	unsigned long pmc5, pmc6;
+
+	if (!cpuhw->n_limited) {
+		mtspr(SPRN_MMCR0, mmcr0);
+		return;
+	}
+
+	/*
+	 * Write MMCR0, then read PMC5 and PMC6 immediately.
+	 */
+	asm volatile("mtspr %3,%2; mfspr %0,%4; mfspr %1,%5"
+		     : "=&r" (pmc5), "=&r" (pmc6)
+		     : "r" (mmcr0), "i" (SPRN_MMCR0),
+		       "i" (SPRN_PMC5), "i" (SPRN_PMC6));
+
+	if (mmcr0 & MMCR0_FC)
+		freeze_limited_counters(cpuhw, pmc5, pmc6);
+	else
+		thaw_limited_counters(cpuhw, pmc5, pmc6);
+}
+
+/*
  * Disable all counters to prevent PMU interrupts and to allow
  * counters to be added or removed.
  */
@@ -321,7 +424,7 @@ u64 hw_perf_save_disable(void)
 		 * executed and the PMU has frozen the counters
 		 * before we return.
 		 */
-		mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | MMCR0_FC);
+		write_mmcr0(cpuhw, mfspr(SPRN_MMCR0) | MMCR0_FC);
 		mb();
 	}
 	local_irq_restore(flags);
@@ -342,6 +445,8 @@ void hw_perf_restore(u64 disable)
 	unsigned long val;
 	s64 left;
 	unsigned int hwc_index[MAX_HWCOUNTERS];
+	int n_lim;
+	int idx;
 
 	if (disable)
 		return;
@@ -414,10 +519,18 @@ void hw_perf_restore(u64 disable)
 	/*
 	 * Initialize the PMCs for all the new and moved counters.
 	 */
+	cpuhw->n_limited = n_lim = 0;
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
 		if (counter->hw.idx)
 			continue;
+		idx = hwc_index[i] + 1;
+		if (is_limited_pmc(idx)) {
+			cpuhw->limited_counter[n_lim] = counter;
+			cpuhw->limited_hwidx[n_lim] = idx;
+			++n_lim;
+			continue;
+		}
 		val = 0;
 		if (counter->hw_event.irq_period) {
 			left = atomic64_read(&counter->hw.period_left);
@@ -425,15 +538,16 @@ void hw_perf_restore(u64 disable)
 				val = 0x80000000L - left;
 		}
 		atomic64_set(&counter->hw.prev_count, val);
-		counter->hw.idx = hwc_index[i] + 1;
-		write_pmc(counter->hw.idx, val);
+		counter->hw.idx = idx;
+		write_pmc(idx, val);
 		perf_counter_update_userpage(counter);
 	}
+	cpuhw->n_limited = n_lim;
 	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
 
  out_enable:
 	mb();
-	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+	write_mmcr0(cpuhw, cpuhw->mmcr[0]);
 
 	/*
 	 * Enable instruction sampling if necessary
@@ -448,7 +562,8 @@ void hw_perf_restore(u64 disable)
 }
 
 static int collect_events(struct perf_counter *group, int max_count,
-			  struct perf_counter *ctrs[], unsigned int *events)
+			  struct perf_counter *ctrs[], unsigned int *events,
+			  unsigned int *flags)
 {
 	int n = 0;
 	struct perf_counter *counter;
@@ -457,6 +572,7 @@ static int collect_events(struct perf_counter *group, int max_count,
 		if (n >= max_count)
 			return -1;
 		ctrs[n] = group;
+		flags[n] = group->hw.counter_base;
 		events[n++] = group->hw.config;
 	}
 	list_for_each_entry(counter, &group->sibling_list, list_entry) {
@@ -465,6 +581,7 @@ static int collect_events(struct perf_counter *group, int max_count,
 			if (n >= max_count)
 				return -1;
 			ctrs[n] = counter;
+			flags[n] = counter->hw.counter_base;
 			events[n++] = counter->hw.config;
 		}
 	}
@@ -497,12 +614,14 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	n0 = cpuhw->n_counters;
 	n = collect_events(group_leader, ppmu->n_counter - n0,
-			   &cpuhw->counter[n0], &cpuhw->events[n0]);
+			   &cpuhw->counter[n0], &cpuhw->events[n0],
+			   &cpuhw->flags[n0]);
 	if (n < 0)
 		return -EAGAIN;
-	if (check_excludes(cpuhw->counter, n0, n))
+	if (check_excludes(cpuhw->counter, cpuhw->flags, n0, n))
 		return -EAGAIN;
-	if (power_check_constraints(cpuhw->events, n + n0))
+	i = power_check_constraints(cpuhw->events, cpuhw->flags, n + n0);
+	if (i < 0)
 		return -EAGAIN;
 	cpuhw->n_counters = n0 + n;
 	cpuhw->n_added += n;
@@ -554,9 +673,10 @@ static int power_perf_enable(struct perf_counter *counter)
 		goto out;
 	cpuhw->counter[n0] = counter;
 	cpuhw->events[n0] = counter->hw.config;
-	if (check_excludes(cpuhw->counter, n0, 1))
+	cpuhw->flags[n0] = counter->hw.counter_base;
+	if (check_excludes(cpuhw->counter, cpuhw->flags, n0, 1))
 		goto out;
-	if (power_check_constraints(cpuhw->events, n0 + 1))
+	if (power_check_constraints(cpuhw->events, cpuhw->flags, n0 + 1))
 		goto out;
 
 	counter->hw.config = cpuhw->events[n0];
@@ -592,12 +712,24 @@ static void power_perf_disable(struct perf_counter *counter)
 				cpuhw->counter[i-1] = cpuhw->counter[i];
 			--cpuhw->n_counters;
 			ppmu->disable_pmc(counter->hw.idx - 1, cpuhw->mmcr);
-			write_pmc(counter->hw.idx, 0);
-			counter->hw.idx = 0;
+			if (counter->hw.idx) {
+				write_pmc(counter->hw.idx, 0);
+				counter->hw.idx = 0;
+			}
 			perf_counter_update_userpage(counter);
 			break;
 		}
 	}
+	for (i = 0; i < cpuhw->n_limited; ++i)
+		if (counter == cpuhw->limited_counter[i])
+			break;
+	if (i < cpuhw->n_limited) {
+		while (++i < cpuhw->n_limited) {
+			cpuhw->limited_counter[i-1] = cpuhw->limited_counter[i];
+			cpuhw->limited_hwidx[i-1] = cpuhw->limited_hwidx[i];
+		}
+		--cpuhw->n_limited;
+	}
 	if (cpuhw->n_counters == 0) {
 		/* disable exceptions if no counters are running */
 		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
@@ -613,6 +745,61 @@ struct hw_perf_counter_ops power_perf_ops = {
 	.read = power_perf_read
 };
 
+/*
+ * Return 1 if we might be able to put counter on a limited PMC,
+ * or 0 if not.
+ * A counter can only go on a limited PMC if it counts something
+ * that a limited PMC can count, doesn't require interrupts, and
+ * doesn't exclude any processor mode.
+ */
+static int can_go_on_limited_pmc(struct perf_counter *counter, unsigned int ev,
+				 unsigned int flags)
+{
+	int n;
+	unsigned int alt[MAX_EVENT_ALTERNATIVES];
+
+	if (counter->hw_event.exclude_user
+	    || counter->hw_event.exclude_kernel
+	    || counter->hw_event.exclude_hv
+	    || counter->hw_event.irq_period)
+		return 0;
+
+	if (ppmu->limited_pmc_event(ev))
+		return 1;
+
+	/*
+	 * The requested event isn't on a limited PMC already;
+	 * see if any alternative code goes on a limited PMC.
+	 */
+	if (!ppmu->get_alternatives)
+		return 0;
+
+	flags |= PPMU_LIMITED_PMC_OK | PPMU_LIMITED_PMC_REQD;
+	n = ppmu->get_alternatives(ev, flags, alt);
+	if (n)
+		return alt[0];
+
+	return 0;
+}
+
+/*
+ * Find an alternative event that goes on a normal PMC, if possible,
+ * and return the event code, or 0 if there is no such alternative.
+ * (Note: event code 0 is "don't count" on all machines.)
+ */
+static unsigned long normal_pmc_alternative(unsigned long ev,
+					    unsigned long flags)
+{
+	unsigned int alt[MAX_EVENT_ALTERNATIVES];
+	int n;
+
+	flags &= ~(PPMU_LIMITED_PMC_OK | PPMU_LIMITED_PMC_REQD);
+	n = ppmu->get_alternatives(ev, flags, alt);
+	if (!n)
+		return 0;
+	return alt[0];
+}
+
 /* Number of perf_counters counting hardware events */
 static atomic_t num_counters;
 /* Used to avoid races in calling reserve/release_pmc_hardware */
@@ -634,9 +821,10 @@ static void hw_perf_counter_destroy(struct perf_counter *counter)
 const struct hw_perf_counter_ops *
 hw_perf_counter_init(struct perf_counter *counter)
 {
-	unsigned long ev;
+	unsigned long ev, flags;
 	struct perf_counter *ctrs[MAX_HWCOUNTERS];
 	unsigned int events[MAX_HWCOUNTERS];
+	unsigned int cflags[MAX_HWCOUNTERS];
 	int n;
 	int err;
 
@@ -662,7 +850,36 @@ hw_perf_counter_init(struct perf_counter *counter)
 	 */
 	if (!firmware_has_feature(FW_FEATURE_LPAR))
 		counter->hw_event.exclude_hv = 0;
-	
+
+	/*
+	 * If this is a per-task counter, then we can use
+	 * PM_RUN_* events interchangeably with their non RUN_*
+	 * equivalents, e.g. PM_RUN_CYC instead of PM_CYC.
+	 * XXX we should check if the task is an idle task.
+	 */
+	flags = 0;
+	if (counter->ctx->task)
+		flags |= PPMU_ONLY_COUNT_RUN;
+
+	/*
+	 * If this machine has limited counters, check whether this
+	 * event could go on a limited counter.
+	 */
+	if (ppmu->limited_pmc5_6) {
+		if (can_go_on_limited_pmc(counter, ev, flags)) {
+			flags |= PPMU_LIMITED_PMC_OK;
+		} else if (ppmu->limited_pmc_event(ev)) {
+			/*
+			 * The requested event is on a limited PMC,
+			 * but we can't use a limited PMC; see if any
+			 * alternative goes on a normal PMC.
+			 */
+			ev = normal_pmc_alternative(ev, flags);
+			if (!ev)
+				return ERR_PTR(-EINVAL);
+		}
+	}
+
 	/*
 	 * If this is in a group, check if it can go on with all the
 	 * other hardware counters in the group.  We assume the counter
@@ -671,18 +888,20 @@ hw_perf_counter_init(struct perf_counter *counter)
 	n = 0;
 	if (counter->group_leader != counter) {
 		n = collect_events(counter->group_leader, ppmu->n_counter - 1,
-				   ctrs, events);
+				   ctrs, events, cflags);
 		if (n < 0)
 			return ERR_PTR(-EINVAL);
 	}
 	events[n] = ev;
 	ctrs[n] = counter;
-	if (check_excludes(ctrs, n, 1))
+	cflags[n] = flags;
+	if (check_excludes(ctrs, cflags, n, 1))
 		return ERR_PTR(-EINVAL);
-	if (power_check_constraints(events, n + 1))
+	if (power_check_constraints(events, cflags, n + 1))
 		return ERR_PTR(-EINVAL);
 
 	counter->hw.config = events[n];
+	counter->hw.counter_base = cflags[n];
 	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
 
 	/*
@@ -764,6 +983,10 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	int found = 0;
 	int nmi;
 
+	if (cpuhw->n_limited)
+		freeze_limited_counters(cpuhw, mfspr(SPRN_PMC5),
+					mfspr(SPRN_PMC6));
+
 	/*
 	 * If interrupts were soft-disabled when this PMU interrupt
 	 * occurred, treat it as an NMI.
@@ -776,6 +999,8 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
+		if (is_limited_pmc(counter->hw.idx))
+			continue;
 		val = read_pmc(counter->hw.idx);
 		if ((int)val < 0) {
 			/* counter has overflowed */
@@ -792,6 +1017,8 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	 */
 	if (!found) {
 		for (i = 0; i < ppmu->n_counter; ++i) {
+			if (is_limited_pmc(i + 1))
+				continue;
 			val = read_pmc(i + 1);
 			if ((int)val < 0)
 				write_pmc(i + 1, 0);
@@ -805,7 +1032,7 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	 * XXX might want to use MSR.PM to keep the counters frozen until
 	 * we get back out of this interrupt.
 	 */
-	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+	write_mmcr0(cpuhw, cpuhw->mmcr[0]);
 
 	if (nmi)
 		nmi_exit();
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index 1407b19..744a275 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -320,7 +320,8 @@ static unsigned int ppc_inst_cmpl[] = {
 	0x1001, 0x4001, 0x6001, 0x7001, 0x8001
 };
 
-static int p4_get_alternatives(unsigned int event, unsigned int alt[])
+static int p4_get_alternatives(unsigned int event, unsigned int flags,
+			       unsigned int alt[])
 {
 	int i, j, na;
 
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index 1222c8e..8154eaa 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -78,8 +78,8 @@
  * Layout of constraint bits:
  * 6666555555555544444444443333333333222222222211111111110000000000
  * 3210987654321098765432109876543210987654321098765432109876543210
- *             [  ><><>< ><> <><>[  >      <  ><  ><  ><  ><><><><>
- *             NC  G0G1G2 G3 T0T1 UC        B0  B1  B2  B3 P4P3P2P1
+ *             [  ><><>< ><> <><>[  >  <  ><  ><  ><  ><><><><><><>
+ *             NC  G0G1G2 G3 T0T1 UC    B0  B1  B2  B3 P6P5P4P3P2P1
  *
  * NC - number of counters
  *     51: NC error 0x0008_0000_0000_0000
@@ -105,18 +105,18 @@
  *     30: IDU|GRS events needed 0x00_4000_0000
  *
  * B0
- *     20-23: Byte 0 event source 0x00f0_0000
+ *     24-27: Byte 0 event source 0x0f00_0000
  *	      Encoding as for the event code
  *
  * B1, B2, B3
- *     16-19, 12-15, 8-11: Byte 1, 2, 3 event sources
+ *     20-23, 16-19, 12-15: Byte 1, 2, 3 event sources
  *
- * P4
- *     7: P1 error 0x80
- *     6-7: Count of events needing PMC4
+ * P6
+ *     11: P6 error 0x800
+ *     10-11: Count of events needing PMC6
  *
- * P1..P3
- *     0-6: Count of events needing PMC1..PMC3
+ * P1..P5
+ *     0-9: Count of events needing PMC1..PMC5
  */
 
 static const int grsel_shift[8] = {
@@ -143,11 +143,13 @@ static int power5p_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
 	if (pmc) {
-		if (pmc > 4)
+		if (pmc > 6)
 			return -1;
 		sh = (pmc - 1) * 2;
 		mask |= 2 << sh;
 		value |= 1 << sh;
+		if (pmc >= 5 && !(event == 0x500009 || event == 0x600005))
+			return -1;
 	}
 	if (event & PM_BUSEVENT_MSK) {
 		unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
@@ -173,16 +175,26 @@ static int power5p_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 			value |= (u64)((event >> PM_GRS_SH) & fmask) << sh;
 		}
 		/* Set byte lane select field */
-		mask  |= 0xfULL << (20 - 4 * byte);
-		value |= (u64)unit << (20 - 4 * byte);
+		mask  |= 0xfULL << (24 - 4 * byte);
+		value |= (u64)unit << (24 - 4 * byte);
+	}
+	if (pmc < 5) {
+		/* need a counter from PMC1-4 set */
+		mask  |= 0x8000000000000ull;
+		value |= 0x1000000000000ull;
 	}
-	mask  |= 0x8000000000000ull;
-	value |= 0x1000000000000ull;
 	*maskp = mask;
 	*valp = value;
 	return 0;
 }
 
+static int power5p_limited_pmc_event(unsigned int event)
+{
+	int pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+
+	return pmc == 5 || pmc == 6;
+}
+
 #define MAX_ALT	3	/* at most 3 alternatives for any event */
 
 static const unsigned int event_alternatives[][MAX_ALT] = {
@@ -193,6 +205,7 @@ static const unsigned int event_alternatives[][MAX_ALT] = {
 	{ 0x410c7,  0x441084 },			/* PM_THRD_L2MISS_BOTH_CYC */
 	{ 0x800c4,  0xc20e0 },			/* PM_DTLB_MISS */
 	{ 0xc50c6,  0xc60e0 },			/* PM_MRK_DTLB_MISS */
+	{ 0x100005, 0x600005 },			/* PM_RUN_CYC */
 	{ 0x100009, 0x200009 },			/* PM_INST_CMPL */
 	{ 0x200015, 0x300015 },			/* PM_LSU_LMQ_SRQ_EMPTY_CYC */
 	{ 0x300009, 0x400009 },			/* PM_INST_DISP */
@@ -260,24 +273,85 @@ static int find_alternative_bdecode(unsigned int event)
 	return -1;
 }
 
-static int power5p_get_alternatives(unsigned int event, unsigned int alt[])
+static int power5p_get_alternatives(unsigned int event, unsigned int flags,
+				    unsigned int alt[])
 {
 	int i, j, ae, nalt = 1;
+	int nlim;
 
 	alt[0] = event;
 	nalt = 1;
+	nlim = power5p_limited_pmc_event(event);
 	i = find_alternative(event);
 	if (i >= 0) {
 		for (j = 0; j < MAX_ALT; ++j) {
 			ae = event_alternatives[i][j];
 			if (ae && ae != event)
 				alt[nalt++] = ae;
+			nlim += power5p_limited_pmc_event(ae);
 		}
 	} else {
 		ae = find_alternative_bdecode(event);
 		if (ae > 0)
 			alt[nalt++] = ae;
 	}
+
+	if (flags & PPMU_ONLY_COUNT_RUN) {
+		/*
+		 * We're only counting in RUN state,
+		 * so PM_CYC is equivalent to PM_RUN_CYC
+		 * and PM_INST_CMPL === PM_RUN_INST_CMPL.
+		 * This doesn't include alternatives that don't provide
+		 * any extra flexibility in assigning PMCs (e.g.
+		 * 0x100005 for PM_RUN_CYC vs. 0xf for PM_CYC).
+		 * Note that even with these additional alternatives
+		 * we never end up with more than 3 alternatives for any event.
+		 */
+		j = nalt;
+		for (i = 0; i < nalt; ++i) {
+			switch (alt[i]) {
+			case 0xf:	/* PM_CYC */
+				alt[j++] = 0x600005;	/* PM_RUN_CYC */
+				++nlim;
+				break;
+			case 0x600005:	/* PM_RUN_CYC */
+				alt[j++] = 0xf;
+				break;
+			case 0x100009:	/* PM_INST_CMPL */
+				alt[j++] = 0x500009;	/* PM_RUN_INST_CMPL */
+				++nlim;
+				break;
+			case 0x500009:	/* PM_RUN_INST_CMPL */
+				alt[j++] = 0x100009;	/* PM_INST_CMPL */
+				alt[j++] = 0x200009;
+				break;
+			}
+		}
+		nalt = j;
+	}
+
+	if (!(flags & PPMU_LIMITED_PMC_OK) && nlim) {
+		/* remove the limited PMC events */
+		j = 0;
+		for (i = 0; i < nalt; ++i) {
+			if (!power5p_limited_pmc_event(alt[i])) {
+				alt[j] = alt[i];
+				++j;
+			}
+		}
+		nalt = j;
+	} else if ((flags & PPMU_LIMITED_PMC_REQD) && nlim < nalt) {
+		/* remove all but the limited PMC events */
+		j = 0;
+		for (i = 0; i < nalt; ++i) {
+			if (power5p_limited_pmc_event(alt[i])) {
+				alt[j] = alt[i];
+				++j;
+			}
+		}
+		nalt = j;
+	}
+
 	return nalt;
 }
 
@@ -390,7 +464,7 @@ static int power5p_compute_mmcr(unsigned int event[], int n_ev,
 	unsigned char unituse[16];
 	int ttmuse;
 
-	if (n_ev > 4)
+	if (n_ev > 6)
 		return -1;
 
 	/* First pass to count resource use */
@@ -399,7 +473,7 @@ static int power5p_compute_mmcr(unsigned int event[], int n_ev,
 	for (i = 0; i < n_ev; ++i) {
 		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
 		if (pmc) {
-			if (pmc > 4)
+			if (pmc > 6)
 				return -1;
 			if (pmc_inuse & (1 << (pmc - 1)))
 				return -1;
@@ -488,13 +562,16 @@ static int power5p_compute_mmcr(unsigned int event[], int n_ev,
 			if (pmc >= 4)
 				return -1;
 			pmc_inuse |= 1 << pmc;
-		} else {
+		} else if (pmc <= 4) {
 			/* Direct event */
 			--pmc;
 			if (isbus && (byte & 2) &&
 			    (psel == 8 || psel == 0x10 || psel == 0x28))
 				/* add events on higher-numbered bus */
 				mmcr1 |= 1ull << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
+		} else {
+			/* Instructions or run cycles on PMC5/6 */
+			--pmc;
 		}
 		if (isbus && unit == PM_GRS) {
 			bit = psel & 7;
@@ -538,7 +615,7 @@ static int power5p_generic_events[] = {
 };
 
 struct power_pmu power5p_pmu = {
-	.n_counter = 4,
+	.n_counter = 6,
 	.max_alternatives = MAX_ALT,
 	.add_fields = 0x7000000000055ull,
 	.test_adder = 0x3000040000000ull,
@@ -548,4 +625,6 @@ struct power_pmu power5p_pmu = {
 	.disable_pmc = power5p_disable_pmc,
 	.n_generic = ARRAY_SIZE(power5p_generic_events),
 	.generic_events = power5p_generic_events,
+	.limited_pmc5_6 = 1,
+	.limited_pmc_event = power5p_limited_pmc_event,
 };
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 116c4bb..6e667dc 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -269,7 +269,8 @@ static int find_alternative_bdecode(unsigned int event)
 	return -1;
 }
 
-static int power5_get_alternatives(unsigned int event, unsigned int alt[])
+static int power5_get_alternatives(unsigned int event, unsigned int flags,
+				   unsigned int alt[])
 {
 	int i, j, ae, nalt = 1;
 
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index fce1fc2..d44049f 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -182,7 +182,7 @@ static int p6_compute_mmcr(unsigned int event[], int n_ev,
 	unsigned int ttmset = 0;
 	unsigned int pmc_inuse = 0;
 
-	if (n_ev > 4)
+	if (n_ev > 6)
 		return -1;
 	for (i = 0; i < n_ev; ++i) {
 		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
@@ -202,6 +202,8 @@ static int p6_compute_mmcr(unsigned int event[], int n_ev,
 			for (pmc = 0; pmc < 4; ++pmc)
 				if (!(pmc_inuse & (1 << pmc)))
 					break;
+			if (pmc >= 4)
+				return -1;
 			pmc_inuse |= 1 << pmc;
 		}
 		hwc[i] = pmc;
@@ -240,7 +242,8 @@ static int p6_compute_mmcr(unsigned int event[], int n_ev,
 		}
 		if (power6_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
-		mmcr1 |= (u64)psel << MMCR1_PMCSEL_SH(pmc);
+		if (pmc < 4)
+			mmcr1 |= (u64)psel << MMCR1_PMCSEL_SH(pmc);
 	}
 	mmcr[0] = 0;
 	if (pmc_inuse & 1)
@@ -256,19 +259,20 @@ static int p6_compute_mmcr(unsigned int event[], int n_ev,
  * Layout of constraint bits:
  *
  *	0-1	add field: number of uses of PMC1 (max 1)
- *	2-3, 4-5, 6-7: ditto for PMC2, 3, 4
- *	8-10	select field: nest (subunit) event selector
+ *	2-3, 4-5, 6-7, 8-9, 10-11: ditto for PMC2, 3, 4, 5, 6
+ *	12-15	add field: number of uses of PMC1-4 (max 4)
  *	16-19	select field: unit on byte 0 of event bus
  *	20-23, 24-27, 28-31 ditto for bytes 1, 2, 3
+ *	32-34	select field: nest (subunit) event selector
  */
 static int p6_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 {
-	int pmc, byte, sh;
-	unsigned int mask = 0, value = 0;
+	int pmc, byte, sh, subunit;
+	u64 mask = 0, value = 0;
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
 	if (pmc) {
-		if (pmc > 4)
+		if (pmc > 4 && !(event == 0x500009 || event == 0x600005))
 			return -1;
 		sh = (pmc - 1) * 2;
 		mask |= 2 << sh;
@@ -276,26 +280,38 @@ static int p6_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 	}
 	if (event & PM_BUSEVENT_MSK) {
 		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
-		sh = byte * 4;
+		sh = byte * 4 + (16 - PM_UNIT_SH);
 		mask |= PM_UNIT_MSKS << sh;
-		value |= (event & PM_UNIT_MSKS) << sh;
+		value |= (u64)(event & PM_UNIT_MSKS) << sh;
 		if ((event & PM_UNIT_MSKS) == (5 << PM_UNIT_SH)) {
-			mask |= PM_SUBUNIT_MSKS;
-			value |= event & PM_SUBUNIT_MSKS;
+			subunit = (event >> PM_SUBUNIT_SH) & PM_SUBUNIT_MSK;
+			mask  |= (u64)PM_SUBUNIT_MSK << 32;
+			value |= (u64)subunit << 32;
 		}
 	}
+	if (pmc <= 4) {
+		mask  |= 0x8000;	/* add field for count of PMC1-4 uses */
+		value |= 0x1000;
+	}
 	*maskp = mask;
 	*valp = value;
 	return 0;
 }
 
+static int p6_limited_pmc_event(unsigned int event)
+{
+	int pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+
+	return pmc == 5 || pmc == 6;
+}
+
 #define MAX_ALT	4	/* at most 4 alternatives for any event */
 
 static const unsigned int event_alternatives[][MAX_ALT] = {
 	{ 0x0130e8, 0x2000f6, 0x3000fc },	/* PM_PTEG_RELOAD_VALID */
 	{ 0x080080, 0x10000d, 0x30000c, 0x4000f0 }, /* PM_LD_MISS_L1 */
 	{ 0x080088, 0x200054, 0x3000f0 },	/* PM_ST_MISS_L1 */
-	{ 0x10000a, 0x2000f4 },			/* PM_RUN_CYC */
+	{ 0x10000a, 0x2000f4, 0x600005 },	/* PM_RUN_CYC */
 	{ 0x10000b, 0x2000f5 },			/* PM_RUN_COUNT */
 	{ 0x10000e, 0x400010 },			/* PM_PURR */
 	{ 0x100010, 0x4000f8 },			/* PM_FLUSH */
@@ -340,13 +356,15 @@ static int find_alternatives_list(unsigned int event)
 	return -1;
 }
 
-static int p6_get_alternatives(unsigned int event, unsigned int alt[])
+static int p6_get_alternatives(unsigned int event, unsigned int flags,
+			       unsigned int alt[])
 {
-	int i, j;
+	int i, j, nlim;
 	unsigned int aevent, psel, pmc;
 	unsigned int nalt = 1;
 
 	alt[0] = event;
+	nlim = p6_limited_pmc_event(event);
 
 	/* check the alternatives table */
 	i = find_alternatives_list(event);
@@ -358,6 +376,7 @@ static int p6_get_alternatives(unsigned int event, unsigned int alt[])
 				break;
 			if (aevent != event)
 				alt[nalt++] = aevent;
+			nlim += p6_limited_pmc_event(aevent);
 		}
 
 	} else {
@@ -375,13 +394,75 @@ static int p6_get_alternatives(unsigned int event, unsigned int alt[])
 				((pmc > 2? pmc - 2: pmc + 2) << PM_PMC_SH);
 	}
 
+	if (flags & PPMU_ONLY_COUNT_RUN) {
+		/*
+		 * We're only counting in RUN state,
+		 * so PM_CYC is equivalent to PM_RUN_CYC,
+		 * PM_INST_CMPL === PM_RUN_INST_CMPL, PM_PURR === PM_RUN_PURR.
+		 * This doesn't include alternatives that don't provide
+		 * any extra flexibility in assigning PMCs (e.g.
+		 * 0x10000a for PM_RUN_CYC vs. 0x1e for PM_CYC).
+		 * Note that even with these additional alternatives
+		 * we never end up with more than 4 alternatives for any event.
+		 */
+		j = nalt;
+		for (i = 0; i < nalt; ++i) {
+			switch (alt[i]) {
+			case 0x1e:	/* PM_CYC */
+				alt[j++] = 0x600005;	/* PM_RUN_CYC */
+				++nlim;
+				break;
+			case 0x10000a:	/* PM_RUN_CYC */
+				alt[j++] = 0x1e;	/* PM_CYC */
+				break;
+			case 2:		/* PM_INST_CMPL */
+				alt[j++] = 0x500009;	/* PM_RUN_INST_CMPL */
+				++nlim;
+				break;
+			case 0x500009:	/* PM_RUN_INST_CMPL */
+				alt[j++] = 2;		/* PM_INST_CMPL */
+				break;
+			case 0x10000e:	/* PM_PURR */
+				alt[j++] = 0x4000f4;	/* PM_RUN_PURR */
+				break;
+			case 0x4000f4:	/* PM_RUN_PURR */
+				alt[j++] = 0x10000e;	/* PM_PURR */
+				break;
+			}
+		}
+		nalt = j;
+	}
+
+	if (!(flags & PPMU_LIMITED_PMC_OK) && nlim) {
+		/* remove the limited PMC events */
+		j = 0;
+		for (i = 0; i < nalt; ++i) {
+			if (!p6_limited_pmc_event(alt[i])) {
+				alt[j] = alt[i];
+				++j;
+			}
+		}
+		nalt = j;
+	} else if ((flags & PPMU_LIMITED_PMC_REQD) && nlim < nalt) {
+		/* remove all but the limited PMC events */
+		j = 0;
+		for (i = 0; i < nalt; ++i) {
+			if (p6_limited_pmc_event(alt[i])) {
+				alt[j] = alt[i];
+				++j;
+			}
+		}
+		nalt = j;
+	}
+
 	return nalt;
 }
 
 static void p6_disable_pmc(unsigned int pmc, u64 mmcr[])
 {
 	/* Set PMCxSEL to 0 to disable PMCx */
-	mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
+	if (pmc <= 3)
+		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
 }
 
 static int power6_generic_events[] = {
@@ -394,14 +475,16 @@ static int power6_generic_events[] = {
 };
 
 struct power_pmu power6_pmu = {
-	.n_counter = 4,
+	.n_counter = 6,
 	.max_alternatives = MAX_ALT,
-	.add_fields = 0x55,
-	.test_adder = 0,
+	.add_fields = 0x1555,
+	.test_adder = 0x3000,
 	.compute_mmcr = p6_compute_mmcr,
 	.get_constraint = p6_get_constraint,
 	.get_alternatives = p6_get_alternatives,
 	.disable_pmc = p6_disable_pmc,
 	.n_generic = ARRAY_SIZE(power6_generic_events),
 	.generic_events = power6_generic_events,
+	.limited_pmc5_6 = 1,
+	.limited_pmc_event = p6_limited_pmc_event,
 };
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index aed8ccd..af2d188 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -243,7 +243,8 @@ static int p970_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
 	return 0;
 }
 
-static int p970_get_alternatives(unsigned int event, unsigned int alt[])
+static int p970_get_alternatives(unsigned int event, unsigned int flags,
+				 unsigned int alt[])
 {
 	alt[0] = event;
 
-- 
1.6.0.4

