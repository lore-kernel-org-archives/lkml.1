Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZIVHlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZIVHlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZIVHll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:41:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:44586 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZIVHks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:40:48 -0400
Date: Tue, 22 Sep 2009 07:40:11 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19128.4280.813369.589704@cargo.ozlabs.ibm.com>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event, powerpc: Fix compilation after big perf_counter rename
Message-ID: <tip-a8f90e906783f1f815120eefe813b23cb396e9bd@git.kernel.org>
Git-Commit-ID: a8f90e906783f1f815120eefe813b23cb396e9bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 07:40:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8f90e906783f1f815120eefe813b23cb396e9bd
Gitweb:     http://git.kernel.org/tip/a8f90e906783f1f815120eefe813b23cb396e9bd
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 22 Sep 2009 09:48:08 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 09:30:40 +0200

perf_event, powerpc: Fix compilation after big perf_counter rename

This fixes two places in the powerpc perf_event (perf_counter) code
where 'list_entry' needs to be changed to 'group_entry', but were
missed in commit 65abc865 ("perf_counter: Rename list_entry ->
group_entry, counter_list -> group_list").

This also changes 'event' back to 'counter' in a couple of
contexts:

* Field and function names that deal with the limited-function
  counters: it's really the hardware counters whose function is
  limited, not the events that they count.  Hence:

  MAX_LIMITED_HWEVENTS -> MAX_LIMITED_HWCOUNTERS
  limited_event -> limited_counter
  freeze/thaw_limited_events -> freeze/thaw_limited_counters

* The machine-specific PMU description struct (struct power_pmu): this
  renames 'n_event' back to 'n_counter' since it really describes how
  many hardware counters the machine has.  (Renaming this back avoids
  a compile error in each of the machine-specific PMU back-ends where
  they initialize their power_pmu struct.)

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19128.4280.813369.589704@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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
