Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZIVHvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZIVHvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZIVHvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:51:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbZIVHvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:51:53 -0400
Date: Tue, 22 Sep 2009 09:51:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] perf fixes
Message-ID: <20090922075144.GA21122@elte.hu>
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

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

This fixes a brown paperbag build error in PowerPC caused by the rename.

Would it be possible for you to pull this fix as the first thing today, 
to keep it together with 43c1266, the merge commit of the rename, to 
minimize the bisection breakage window for PowerPC?

 Thanks,

	Ingo

------------------>
Paul Mackerras (1):
      perf_event, powerpc: Fix compilation after big perf_counter rename


 arch/powerpc/include/asm/perf_event.h |    4 +-
 arch/powerpc/kernel/perf_event.c      |   38 ++++++++++++++++----------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event.h b/arch/powerpc/include/asm/perf_event.h
index 2499aaa..3288ce3 100644
--- a/arch/powerpc/include/asm/perf_event.h
+++ b/arch/powerpc/include/asm/perf_event.h
@@ -14,7 +14,7 @@
 
 #define MAX_HWEVENTS		8
 #define MAX_EVENT_ALTERNATIVES	8
-#define MAX_LIMITED_HWEVENTS	2
+#define MAX_LIMITED_HWCOUNTERS	2
 
 /*
  * This struct provides the constants and functions needed to
@@ -22,7 +22,7 @@
  */
 struct power_pmu {
 	const char	*name;
-	int		n_event;
+	int		n_counter;
 	int		max_alternatives;
 	unsigned long	add_fields;
 	unsigned long	test_adder;
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 197b7d9..bbcbae1 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -30,8 +30,8 @@ struct cpu_hw_events {
 	u64 events[MAX_HWEVENTS];
 	unsigned int flags[MAX_HWEVENTS];
 	unsigned long mmcr[3];
-	struct perf_event *limited_event[MAX_LIMITED_HWEVENTS];
-	u8  limited_hwidx[MAX_LIMITED_HWEVENTS];
+	struct perf_event *limited_counter[MAX_LIMITED_HWCOUNTERS];
+	u8  limited_hwidx[MAX_LIMITED_HWCOUNTERS];
 	u64 alternatives[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long amasks[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
 	unsigned long avalues[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
@@ -253,7 +253,7 @@ static int power_check_constraints(struct cpu_hw_events *cpuhw,
 	unsigned long addf = ppmu->add_fields;
 	unsigned long tadd = ppmu->test_adder;
 
-	if (n_ev > ppmu->n_event)
+	if (n_ev > ppmu->n_counter)
 		return -1;
 
 	/* First see if the events will go on as-is */
@@ -426,7 +426,7 @@ static int is_limited_pmc(int pmcnum)
 		&& (pmcnum == 5 || pmcnum == 6);
 }
 
-static void freeze_limited_events(struct cpu_hw_events *cpuhw,
+static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
 				    unsigned long pmc5, unsigned long pmc6)
 {
 	struct perf_event *event;
@@ -434,7 +434,7 @@ static void freeze_limited_events(struct cpu_hw_events *cpuhw,
 	int i;
 
 	for (i = 0; i < cpuhw->n_limited; ++i) {
-		event = cpuhw->limited_event[i];
+		event = cpuhw->limited_counter[i];
 		if (!event->hw.idx)
 			continue;
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
@@ -445,7 +445,7 @@ static void freeze_limited_events(struct cpu_hw_events *cpuhw,
 	}
 }
 
-static void thaw_limited_events(struct cpu_hw_events *cpuhw,
+static void thaw_limited_counters(struct cpu_hw_events *cpuhw,
 				  unsigned long pmc5, unsigned long pmc6)
 {
 	struct perf_event *event;
@@ -453,7 +453,7 @@ static void thaw_limited_events(struct cpu_hw_events *cpuhw,
 	int i;
 
 	for (i = 0; i < cpuhw->n_limited; ++i) {
-		event = cpuhw->limited_event[i];
+		event = cpuhw->limited_counter[i];
 		event->hw.idx = cpuhw->limited_hwidx[i];
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
 		atomic64_set(&event->hw.prev_count, val);
@@ -495,9 +495,9 @@ static void write_mmcr0(struct cpu_hw_events *cpuhw, unsigned long mmcr0)
 		       "i" (SPRN_PMC5), "i" (SPRN_PMC6));
 
 	if (mmcr0 & MMCR0_FC)
-		freeze_limited_events(cpuhw, pmc5, pmc6);
+		freeze_limited_counters(cpuhw, pmc5, pmc6);
 	else
-		thaw_limited_events(cpuhw, pmc5, pmc6);
+		thaw_limited_counters(cpuhw, pmc5, pmc6);
 
 	/*
 	 * Write the full MMCR0 including the event overflow interrupt
@@ -653,7 +653,7 @@ void hw_perf_enable(void)
 			continue;
 		idx = hwc_index[i] + 1;
 		if (is_limited_pmc(idx)) {
-			cpuhw->limited_event[n_lim] = event;
+			cpuhw->limited_counter[n_lim] = event;
 			cpuhw->limited_hwidx[n_lim] = idx;
 			++n_lim;
 			continue;
@@ -702,7 +702,7 @@ static int collect_events(struct perf_event *group, int max_count,
 		flags[n] = group->hw.event_base;
 		events[n++] = group->hw.config;
 	}
-	list_for_each_entry(event, &group->sibling_list, list_entry) {
+	list_for_each_entry(event, &group->sibling_list, group_entry) {
 		if (!is_software_event(event) &&
 		    event->state != PERF_EVENT_STATE_OFF) {
 			if (n >= max_count)
@@ -742,7 +742,7 @@ int hw_perf_group_sched_in(struct perf_event *group_leader,
 		return 0;
 	cpuhw = &__get_cpu_var(cpu_hw_events);
 	n0 = cpuhw->n_events;
-	n = collect_events(group_leader, ppmu->n_event - n0,
+	n = collect_events(group_leader, ppmu->n_counter - n0,
 			   &cpuhw->event[n0], &cpuhw->events[n0],
 			   &cpuhw->flags[n0]);
 	if (n < 0)
@@ -764,7 +764,7 @@ int hw_perf_group_sched_in(struct perf_event *group_leader,
 	cpuctx->active_oncpu += n;
 	n = 1;
 	event_sched_in(group_leader, cpu);
-	list_for_each_entry(sub, &group_leader->sibling_list, list_entry) {
+	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
 		if (sub->state != PERF_EVENT_STATE_OFF) {
 			event_sched_in(sub, cpu);
 			++n;
@@ -797,7 +797,7 @@ static int power_pmu_enable(struct perf_event *event)
 	 */
 	cpuhw = &__get_cpu_var(cpu_hw_events);
 	n0 = cpuhw->n_events;
-	if (n0 >= ppmu->n_event)
+	if (n0 >= ppmu->n_counter)
 		goto out;
 	cpuhw->event[n0] = event;
 	cpuhw->events[n0] = event->hw.config;
@@ -848,11 +848,11 @@ static void power_pmu_disable(struct perf_event *event)
 		}
 	}
 	for (i = 0; i < cpuhw->n_limited; ++i)
-		if (event == cpuhw->limited_event[i])
+		if (event == cpuhw->limited_counter[i])
 			break;
 	if (i < cpuhw->n_limited) {
 		while (++i < cpuhw->n_limited) {
-			cpuhw->limited_event[i-1] = cpuhw->limited_event[i];
+			cpuhw->limited_counter[i-1] = cpuhw->limited_counter[i];
 			cpuhw->limited_hwidx[i-1] = cpuhw->limited_hwidx[i];
 		}
 		--cpuhw->n_limited;
@@ -1078,7 +1078,7 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 	 */
 	n = 0;
 	if (event->group_leader != event) {
-		n = collect_events(event->group_leader, ppmu->n_event - 1,
+		n = collect_events(event->group_leader, ppmu->n_counter - 1,
 				   ctrs, events, cflags);
 		if (n < 0)
 			return ERR_PTR(-EINVAL);
@@ -1230,7 +1230,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 	int nmi;
 
 	if (cpuhw->n_limited)
-		freeze_limited_events(cpuhw, mfspr(SPRN_PMC5),
+		freeze_limited_counters(cpuhw, mfspr(SPRN_PMC5),
 					mfspr(SPRN_PMC6));
 
 	perf_read_regs(regs);
@@ -1260,7 +1260,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 	 * Any that we processed in the previous loop will not be negative.
 	 */
 	if (!found) {
-		for (i = 0; i < ppmu->n_event; ++i) {
+		for (i = 0; i < ppmu->n_counter; ++i) {
 			if (is_limited_pmc(i + 1))
 				continue;
 			val = read_pmc(i + 1);
