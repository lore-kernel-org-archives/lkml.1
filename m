Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZBKEKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZBKEKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZBKEKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:10:33 -0500
Received: from ozlabs.org ([203.10.76.45]:47629 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZBKEKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:10:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18834.20374.325525.248022@cargo.ozlabs.ibm.com>
Date: Wed, 11 Feb 2009 15:09:58 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counters: allow users to count user, kernel and/or hypervisor events
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new perf_counter feature

This extends the perf_counter_hw_event struct with bits that specify
that events in user, kernel and/or hypervisor mode should not be
counted (i.e. should be excluded), and adds code to program the PMU
mode selection bits accordingly on x86 and powerpc.

For software counters, we don't currently have the infrastructure to
distinguish which mode an event occurs in, so we currently fail the
counter initialization if the setting of the hw_event.exclude_* bits
would require us to distinguish.  Context switches and CPU migrations
are currently considered to occur in kernel mode.

On x86, this changes the previous policy that only root can count
kernel events.  Now non-root users can count kernel events or exclude
them.  Non-root users still can't use NMI events, though.  On x86 we
don't appear to have any way to control whether hypervisor events are
counted or not, so hw_event.exclude_hv is ignored.

On powerpc, the selection of whether to count events in user, kernel
and/or hypervisor mode is PMU-wide, not per-counter, so this adds a
check that the hw_event.exclude_* settings are the same as other events
on the PMU.  Counters being added to a group have to have the same
settings as the other hardware counters in the group.  Counters and
groups can only be enabled in hw_perf_group_sched_in or power_perf_enable
if they have the same settings as any other counters already on the
PMU.  If we are not running on a hypervisor, the exclude_hv setting
is ignored (by forcing it to 0) since we can't ever get any
hypervisor events.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is available in my perfcounters.git tree master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/kernel/perf_counter.c |   68 ++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_counter.c |   31 ++++++++++------
 include/linux/perf_counter.h       |   19 ++++++----
 kernel/perf_counter.c              |   26 +++++++++++--
 4 files changed, 117 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 5b02113..bd6ba85 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -16,6 +16,7 @@
 #include <asm/reg.h>
 #include <asm/pmc.h>
 #include <asm/machdep.h>
+#include <asm/firmware.h>
 
 struct cpu_hw_counters {
 	int n_counters;
@@ -214,6 +215,36 @@ static int power_check_constraints(unsigned int event[], int n_ev)
 	return 0;
 }
 
+/*
+ * Check if newly-added counters have consistent settings for
+ * exclude_{user,kernel,hv} with each other and any previously
+ * added counters.
+ */
+static int check_excludes(struct perf_counter **ctrs, int n_prev, int n_new)
+{
+	int eu, ek, eh;
+	int i, n;
+	struct perf_counter *counter;
+
+	n = n_prev + n_new;
+	if (n <= 1)
+		return 0;
+
+	eu = ctrs[0]->hw_event.exclude_user;
+	ek = ctrs[0]->hw_event.exclude_kernel;
+	eh = ctrs[0]->hw_event.exclude_hv;
+	if (n_prev == 0)
+		n_prev = 1;
+	for (i = n_prev; i < n; ++i) {
+		counter = ctrs[i];
+		if (counter->hw_event.exclude_user != eu ||
+		    counter->hw_event.exclude_kernel != ek ||
+		    counter->hw_event.exclude_hv != eh)
+			return -EAGAIN;
+	}
+	return 0;
+}
+
 static void power_perf_read(struct perf_counter *counter)
 {
 	long val, delta, prev;
@@ -324,6 +355,20 @@ void hw_perf_restore(u64 disable)
 	}
 
 	/*
+	 * Add in MMCR0 freeze bits corresponding to the
+	 * hw_event.exclude_* bits for the first counter.
+	 * We have already checked that all counters have the
+	 * same values for these bits as the first counter.
+	 */
+	counter = cpuhw->counter[0];
+	if (counter->hw_event.exclude_user)
+		cpuhw->mmcr[0] |= MMCR0_FCP;
+	if (counter->hw_event.exclude_kernel)
+		cpuhw->mmcr[0] |= MMCR0_FCS;
+	if (counter->hw_event.exclude_hv)
+		cpuhw->mmcr[0] |= MMCR0_FCHV;
+
+	/*
 	 * Write the new configuration to MMCR* with the freeze
 	 * bit set and set the hardware counters to their initial values.
 	 * Then unfreeze the counters.
@@ -424,6 +469,8 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
 			   &cpuhw->counter[n0], &cpuhw->events[n0]);
 	if (n < 0)
 		return -EAGAIN;
+	if (check_excludes(cpuhw->counter, n0, n))
+		return -EAGAIN;
 	if (power_check_constraints(cpuhw->events, n + n0))
 		return -EAGAIN;
 	cpuhw->n_counters = n0 + n;
@@ -476,6 +523,8 @@ static int power_perf_enable(struct perf_counter *counter)
 		goto out;
 	cpuhw->counter[n0] = counter;
 	cpuhw->events[n0] = counter->hw.config;
+	if (check_excludes(cpuhw->counter, n0, 1))
+		goto out;
 	if (power_check_constraints(cpuhw->events, n0 + 1))
 		goto out;
 
@@ -555,6 +604,17 @@ hw_perf_counter_init(struct perf_counter *counter)
 	counter->hw.idx = 0;
 
 	/*
+	 * If we are not running on a hypervisor, force the
+	 * exclude_hv bit to 0 so that we don't care what
+	 * the user set it to.  This also means that we don't
+	 * set the MMCR0_FCHV bit, which unconditionally freezes
+	 * the counters on the PPC970 variants used in Apple G5
+	 * machines (since MSR.HV is always 1 on those machines).
+	 */
+	if (!firmware_has_feature(FW_FEATURE_LPAR))
+		counter->hw_event.exclude_hv = 0;
+	
+	/*
 	 * If this is in a group, check if it can go on with all the
 	 * other hardware counters in the group.  We assume the counter
 	 * hasn't been linked into its leader's sibling list at this point.
@@ -566,11 +626,13 @@ hw_perf_counter_init(struct perf_counter *counter)
 		if (n < 0)
 			return NULL;
 	}
-	events[n++] = ev;
-	if (power_check_constraints(events, n))
+	events[n] = ev;
+	if (check_excludes(ctrs, n, 1))
+		return NULL;
+	if (power_check_constraints(events, n + 1))
 		return NULL;
 
-	counter->hw.config = events[n - 1];
+	counter->hw.config = events[n];
 	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
 	return &power_perf_ops;
 }
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 9901e46..383d4c6 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -107,21 +107,25 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		return -EINVAL;
 
 	/*
-	 * Count user events, and generate PMC IRQs:
+	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
 	 */
-	hwc->config = ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_INT;
+	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
 	/*
-	 * If privileged enough, count OS events too, and allow
-	 * NMI events as well:
+	 * Count user and OS events unless requested not to.
 	 */
-	hwc->nmi = 0;
-	if (capable(CAP_SYS_ADMIN)) {
+	if (!hw_event->exclude_user)
+		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
+	if (!hw_event->exclude_kernel)
 		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
-		if (hw_event->nmi)
-			hwc->nmi = 1;
-	}
+
+	/*
+	 * If privileged enough, allow NMI events:
+	 */
+	hwc->nmi = 0;
+	if (capable(CAP_SYS_ADMIN) && hw_event->nmi)
+		hwc->nmi = 1;
 
 	hwc->irq_period		= hw_event->irq_period;
 	/*
@@ -248,10 +252,13 @@ __pmc_fixed_enable(struct perf_counter *counter,
 	int err;
 
 	/*
-	 * Enable IRQ generation (0x8) and ring-3 counting (0x2),
-	 * and enable ring-0 counting if allowed:
+	 * Enable IRQ generation (0x8),
+	 * and enable ring-3 counting (0x2) and ring-0 counting (0x1)
+	 * if requested:
 	 */
-	bits = 0x8ULL | 0x2ULL;
+	bits = 0x8ULL;
+	if (hwc->config & ARCH_PERFMON_EVENTSEL_USR)
+		bits |= 0x2;
 	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
 		bits |= 0x1;
 	bits <<= (idx * 4);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index f55381f..c83f51d 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -83,14 +83,17 @@ struct perf_counter_hw_event {
 	u64			irq_period;
 	u32			record_type;
 
-	u32			disabled     :  1, /* off by default      */
-				nmi	     :  1, /* NMI sampling        */
-				raw	     :  1, /* raw event type      */
-				inherit	     :  1, /* children inherit it */
-				pinned	     :  1, /* must always be on PMU */
-				exclusive    :  1, /* only counter on PMU */
-
-				__reserved_1 : 26;
+	u32			disabled       :  1, /* off by default        */
+				nmi	       :  1, /* NMI sampling          */
+				raw	       :  1, /* raw event type        */
+				inherit	       :  1, /* children inherit it   */
+				pinned	       :  1, /* must always be on PMU */
+				exclusive      :  1, /* only group on PMU     */
+				exclude_user   :  1, /* don't count user      */
+				exclude_kernel :  1, /* ditto kernel          */
+				exclude_hv     :  1, /* ditto hypervisor      */
+
+				__reserved_1 : 23;
 
 	u64			__reserved_2;
 };
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 544193c..89d5e3f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1567,11 +1567,25 @@ sw_perf_counter_init(struct perf_counter *counter)
 {
 	const struct hw_perf_counter_ops *hw_ops = NULL;
 
+	/*
+	 * Software counters (currently) can't in general distinguish
+	 * between user, kernel and hypervisor events.
+	 * However, context switches and cpu migrations are considered
+	 * to be kernel events, and page faults are never hypervisor
+	 * events.
+	 */
 	switch (counter->hw_event.type) {
 	case PERF_COUNT_CPU_CLOCK:
-		hw_ops = &perf_ops_cpu_clock;
+		if (!(counter->hw_event.exclude_user ||
+		      counter->hw_event.exclude_kernel ||
+		      counter->hw_event.exclude_hv))
+			hw_ops = &perf_ops_cpu_clock;
 		break;
 	case PERF_COUNT_TASK_CLOCK:
+		if (counter->hw_event.exclude_user ||
+		    counter->hw_event.exclude_kernel ||
+		    counter->hw_event.exclude_hv)
+			break;
 		/*
 		 * If the user instantiates this as a per-cpu counter,
 		 * use the cpu_clock counter instead.
@@ -1582,13 +1596,17 @@ sw_perf_counter_init(struct perf_counter *counter)
 			hw_ops = &perf_ops_cpu_clock;
 		break;
 	case PERF_COUNT_PAGE_FAULTS:
-		hw_ops = &perf_ops_page_faults;
+		if (!(counter->hw_event.exclude_user ||
+		      counter->hw_event.exclude_kernel))
+			hw_ops = &perf_ops_page_faults;
 		break;
 	case PERF_COUNT_CONTEXT_SWITCHES:
-		hw_ops = &perf_ops_context_switches;
+		if (!counter->hw_event.exclude_kernel)
+			hw_ops = &perf_ops_context_switches;
 		break;
 	case PERF_COUNT_CPU_MIGRATIONS:
-		hw_ops = &perf_ops_cpu_migrations;
+		if (!counter->hw_event.exclude_kernel)
+			hw_ops = &perf_ops_cpu_migrations;
 		break;
 	default:
 		break;
-- 
1.5.6.3

