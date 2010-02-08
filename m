Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0BHQSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:18:44 -0500
Received: from smtp-out.google.com ([216.239.33.17]:59426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0BHQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:18:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=uQX6Fny38PgaxB83Ujq8RGHoQiQ/zBM14s/BRV218UocCN4qU0jIWeq7+MVeEDp+V
	58QmIzFbZRDH7v7eWgtdQ==
Message-ID: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 8 Feb 2010 17:17:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH]  perf_events: AMD event scheduling (v3)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch adds correct AMD Northbridge event scheduling.
	It must be applied on top tip-x86 + hw_perf_enable() fix.

	NB events are events measuring L3 cache, Hypertransport
	traffic. They are identified by an event code  >= 0xe0.
	They measure events on the Northbride which is shared
	by all cores on a package. NB events are counted on a
	shared set of counters. When a NB event is programmed
	in a counter, the data actually comes from a shared
	counter. Thus, access to those counters needs to be
	synchronized.

	We implement the synchronization such that no two cores
	can be measuring NB events using the same counters. Thus,
	we maintain a per-NB * allocation table. The available slot
	is propagated using the event_constraint structure.

	The 2nd version takes into account the changes on how
	constraints are stored by the scheduling code.

	The 3rd version fixes formatting issues, code readability
	and one bug in amd_put_event_constraints().

	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 arch/x86/kernel/cpu/perf_event.c |  267 ++++++++++++++++++++++++++++++++++++++-
 kernel/perf_event.c              |    5 
 2 files changed, 269 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a920f17..29c294c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -80,6 +80,13 @@ struct event_constraint {
 	int	weight;
 };
 
+struct amd_nb {
+	int nb_id;  /* Northbridge id */
+	int refcnt; /* reference count */
+	struct perf_event *owners[X86_PMC_IDX_MAX];
+	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
+};
+
 struct cpu_hw_events {
 	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -92,6 +99,7 @@ struct cpu_hw_events {
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
+	struct amd_nb		*amd_nb;
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w) {\
@@ -153,6 +161,8 @@ struct x86_pmu {
 
 static struct x86_pmu x86_pmu __read_mostly;
 
+static raw_spinlock_t amd_nb_lock;
+
 static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
@@ -802,7 +812,7 @@ static u64 amd_pmu_event_map(int hw_event)
 
 static u64 amd_pmu_raw_event(u64 hw_event)
 {
-#define K7_EVNTSEL_EVENT_MASK	0x7000000FFULL
+#define K7_EVNTSEL_EVENT_MASK	0xF000000FFULL
 #define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
 #define K7_EVNTSEL_EDGE_MASK	0x000040000ULL
 #define K7_EVNTSEL_INV_MASK	0x000800000ULL
@@ -2196,6 +2206,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 }
 
 static struct event_constraint unconstrained;
+static struct event_constraint emptyconstraint;
 
 static struct event_constraint bts_constraint =
 	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
@@ -2235,10 +2246,148 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 	return &unconstrained;
 }
 
+/*
+ * AMD64 events are detected based on their event codes.
+ */
+static inline int amd_is_nb_event(struct hw_perf_event *hwc)
+{
+	u64 val = hwc->config & K7_EVNTSEL_EVENT_MASK;
+	/* event code : bits [35-32] | [7-0] */
+	val = (val >> 24) | (val & 0xff);
+	return val >= 0x0e0;
+}
+
+static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
+				      struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct amd_nb *nb = cpuc->amd_nb;
+	int i;
+
+	/*
+	 * only care about NB events
+	 */
+	if (!(nb && amd_is_nb_event(hwc)))
+		return;
+
+	/*
+	 * need to scan whole list because event may not have
+	 * been assigned during scheduling
+	 *
+	 * no race condition possible because event can only
+	 * be removed on one CPU at a time AND PMU is disabled
+	 * when we come here
+	 */
+	for (i = 0; i < x86_pmu.num_events; i++) {
+		if (nb->owners[i] == event) {
+			cmpxchg(nb->owners+i, event, NULL);
+			break;
+		}
+	}
+}
+
+ /*
+  * AMD64 Northbridge events need special treatment because
+  * counter access needs to be synchronized across all cores
+  * of a package. Refer to BKDG section 3.12
+  *
+  * NB events are events measuring L3 cache, Hypertransport
+  * traffic. They are identified by an event code  >= 0xe0.
+  * They measure events on the Northbride which is shared
+  * by all cores on a package. NB events are counted on a
+  * shared set of counters. When a NB event is programmed
+  * in a counter, the data actually comes from a shared
+  * counter. Thus, access to those counters needs to be
+  * synchronized.
+  * We implement the synchronization such that no two cores
+  * can be measuring NB events using the same counters. Thus,
+  * we maintain a per-NB * allocation table. The available slot
+  * is propagated using the event_constraint structure.
+  *
+  * We provide only one choice for each NB event based on
+  * the fact that only NB events have restrictions. Consequently,
+  * if a counter is available, there is a guarantee the NB event
+  * will be assigned to it. If no slot is available, an empty
+  * constraint is returned and scheduling will evnetually fail
+  * for this event.
+  *
+  * Note that all cores attached the same NB compete for the same
+  * counters to host NB events, this is why we use atomic ops. Some
+  * multi-chip CPUs may have more than one NB.
+  *
+  * Given that resources are allocated (cmpxchg), they must be
+  * eventually freed for others to use. This is accomplished by
+  * calling amd_put_event_constraints().
+  *
+  * Non NB events are not impacted by this restriction.
+  */
 static struct event_constraint *
 amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	return &unconstrained;
+	struct hw_perf_event *hwc = &event->hw;
+	struct amd_nb *nb = cpuc->amd_nb;
+	struct perf_event *old = NULL;
+	int max = x86_pmu.num_events;
+	int i, j, k = -1;
+
+	/*
+	 * if not NB event or no NB, then no constraints
+	 */
+	if (!(nb && amd_is_nb_event(hwc)))
+		return &unconstrained;
+
+	/*
+	 * detect if already present, if so reuse
+	 *
+	 * cannot merge with actual allocation
+	 * because of possible holes
+	 *
+	 * event can already be present yet not assigned (in hwc->idx)
+	 * because of successive calls to x86_schedule_events() from
+	 * hw_perf_group_sched_in() without hw_perf_enable()
+	 */
+	for (i = 0; i < max; i++) {
+		/*
+		 * keep track of first free slot
+		 */
+		if (k == -1 && !nb->owners[i])
+			k = i;
+
+		/* already present, reuse */
+		if (nb->owners[i] == event)
+			goto done;
+	}
+	/*
+	 * not present, so grab a new slot
+	 * starting either at:
+	 */
+	if (hwc->idx != -1) {
+		/* previous assignment */
+		i = hwc->idx;
+	} else if (k != -1) {
+		/* start from free slot found */
+		i = k;
+	} else {
+		/*
+		 * event not found, no slot found in
+		 * first pass, try again from the
+		 * beginning
+		 */
+		i = 0;
+	}
+	j = i;
+	do {
+		old = cmpxchg(nb->owners+i, NULL, event);
+		if (!old)
+			break;
+		if (++i == max)
+			i = 0;
+	} while (i != j);
+done:
+	if (!old)
+		return &nb->event_constraints[i];
+
+	return &emptyconstraint;
 }
 
 static int x86_event_sched_in(struct perf_event *event,
@@ -2451,7 +2600,8 @@ static __initconst struct x86_pmu amd_pmu = {
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
-	.get_event_constraints	= amd_get_event_constraints
+	.get_event_constraints	= amd_get_event_constraints,
+	.put_event_constraints	= amd_put_event_constraints
 };
 
 static __init int p6_pmu_init(void)
@@ -2575,6 +2725,94 @@ static __init int intel_pmu_init(void)
 	return 0;
 }
 
+static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
+{
+	struct amd_nb *nb;
+	int i;
+
+	nb = kmalloc(sizeof(struct amd_nb), GFP_KERNEL);
+	if (!nb)
+		return NULL;
+
+	memset(nb, 0, sizeof(*nb));
+	nb->nb_id = nb_id;
+
+	/*
+	 * initialize all possible NB constraints
+   */
+	for (i = 0; i < x86_pmu.num_events; i++) {
+		set_bit(i, nb->event_constraints[i].idxmsk);
+		nb->event_constraints[i].weight = 1;
+	}
+	return nb;
+}
+
+static void amd_pmu_cpu_online(int cpu)
+{
+	struct cpu_hw_events *cpu1, *cpu2;
+	struct amd_nb *nb = NULL;
+	int i, nb_id;
+
+	if (boot_cpu_data.x86_max_cores < 2)
+		return;
+
+	/*
+	 * function may be called too early in the
+	 * boot process, in which case nb_id is bogus
+	 *
+	 * for BSP, there is an explicit call from
+	 * amd_pmu_init()
+	 */
+	nb_id = amd_get_nb_id(cpu);
+	if (nb_id == BAD_APICID)
+		return;
+
+	cpu1 = &per_cpu(cpu_hw_events, cpu);
+	cpu1->amd_nb = NULL;
+
+	raw_spin_lock(&amd_nb_lock);
+
+	for_each_online_cpu(i) {
+		cpu2 = &per_cpu(cpu_hw_events, i);
+		nb = cpu2->amd_nb;
+		if (!nb)
+			continue;
+		if (nb->nb_id == nb_id)
+			goto found;
+	}
+
+	nb = amd_alloc_nb(cpu, nb_id);
+	if (!nb) {
+		pr_err("perf_events: failed NB allocation for CPU%d\n", cpu);
+		raw_spin_unlock(&amd_nb_lock);
+		return;
+	}
+found:
+	nb->refcnt++;
+	cpu1->amd_nb = nb;
+
+	raw_spin_unlock(&amd_nb_lock);
+}
+
+static void amd_pmu_cpu_offline(int cpu)
+{
+	struct cpu_hw_events *cpuhw;
+
+	if (boot_cpu_data.x86_max_cores < 2)
+		return;
+
+	cpuhw = &per_cpu(cpu_hw_events, cpu);
+
+	raw_spin_lock(&amd_nb_lock);
+
+	if (--cpuhw->amd_nb->refcnt == 0)
+		kfree(cpuhw->amd_nb);
+
+	cpuhw->amd_nb = NULL;
+
+	raw_spin_unlock(&amd_nb_lock);
+}
+
 static __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -2587,6 +2825,8 @@ static __init int amd_pmu_init(void)
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
 	       sizeof(hw_cache_event_ids));
 
+	/* initialize BSP */
+	amd_pmu_cpu_online(smp_processor_id());
 	return 0;
 }
 
@@ -2918,4 +3158,25 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 void hw_perf_event_setup_online(int cpu)
 {
 	init_debug_store_on_cpu(cpu);
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		amd_pmu_cpu_online(cpu);
+		break;
+	default:
+		return;
+	}
+}
+
+void hw_perf_event_setup_offline(int cpu)
+{
+	init_debug_store_on_cpu(cpu);
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		amd_pmu_cpu_offline(cpu);
+		break;
+	default:
+		return;
+	}
 }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ab8a312..0092480 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -98,6 +98,7 @@ void __weak hw_perf_enable(void)		{ barrier(); }
 
 void __weak hw_perf_event_setup(int cpu)	{ barrier(); }
 void __weak hw_perf_event_setup_online(int cpu)	{ barrier(); }
+void __weak hw_perf_event_setup_offline(int cpu)	{ barrier(); }
 
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
@@ -5446,6 +5447,10 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 		perf_event_exit_cpu(cpu);
 		break;
 
+	case CPU_DEAD:
+		hw_perf_event_setup_offline(cpu);
+		break;
+
 	default:
 		break;
 	}
