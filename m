Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbZJFOm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbZJFOm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbZJFOm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:42:57 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:39941 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbZJFOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UpwS3FzBOkGSw8PCemluiLIkpFgjkSiQBU0auN0C5xTWStK3yC+SXQsJPCEl40/gnZ
         zbAn9P4xzUQDBJ39EjMtKJSOvdZkeiT46ArSgVEjETUqi+0LTTUaDXJZq1oerHm6JNQq
         QL41HJHiN/NtHEy9r2jsYw1n7ppZ5izOFjOz4=
From: Stephane Eranian <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH 2/2] perf_events: add event constraints support for Intel processors
Date: Tue,  6 Oct 2009 16:42:09 +0200
Message-Id: <1254840129-6198-3-git-send-email-eranian@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1254840129-6198-2-git-send-email-eranian@gmail.com>
References: <>
 <1254840129-6198-1-git-send-email-eranian@gmail.com>
 <1254840129-6198-2-git-send-email-eranian@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	On some Intel processors, not all events can be measured in
	all counters. Some events can only be measured in one particular
	counter, for instance. Assigning an event to the wrong counter
	does not crash the machine but this yields bogus counts, i.e.,
	silent error.

	This patch changes the event to counter assignment logic to take
	into account event constraints for Intel P6, Core and Nehalem
	processors. There is no contraints on Intel Atom. There are
	constraints on Intel Yonah (Core Duo) but they are not provided
	in this patch given that this processor is not yet supported by
	perf_events.

	As a result of the constraints, it is possible for some event groups
	to never actually be loaded onto the PMU if they contain two events
	which can only be measured on a single counter. That situation can be
	detected with the scaling information extracted with read().

	Signed-off-by: Stephane Eranian <eranian@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c |  106 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1d16bd6..06ca1b2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -77,6 +77,18 @@ struct cpu_hw_events {
 	struct debug_store	*ds;
 };
 
+struct evt_cstr {
+	unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int		code;
+};
+
+#define EVT_CSTR0(c, m) { .code = (c), .idxmsk[0] = (m) }
+#define EVT_CSTR_END  { .code = 0, .idxmsk[0] = 0 }
+
+#define for_each_evt_cstr(e, c) \
+	for((e) = (c); (e)->idxmsk[0]; (e)++)
+
+
 /*
  * struct x86_pmu - generic x86 pmu
  */
@@ -102,6 +114,7 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
+	int 		(*get_event_idx)(struct hw_perf_event *hwc);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -110,6 +123,8 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
+static const struct evt_cstr *evt_cstr;
+
 /*
  * Not sure about some of these
  */
@@ -155,6 +170,15 @@ static u64 p6_pmu_raw_event(u64 hw_event)
 	return hw_event & P6_EVNTSEL_MASK;
 }
 
+static const struct evt_cstr intel_p6_evt[]={
+	EVT_CSTR0(0xc1, 0x1),	/* FLOPS */
+	EVT_CSTR0(0x10, 0x1),	/* FP_COMP_OPS_EXE */
+	EVT_CSTR0(0x11, 0x1),	/* FP_ASSIST */
+	EVT_CSTR0(0x12, 0x2),	/* MUL */
+	EVT_CSTR0(0x13, 0x2),	/* DIV */
+	EVT_CSTR0(0x14, 0x1),	/* CYCLES_DIV_BUSY */
+	EVT_CSTR_END
+};
 
 /*
  * Intel PerfMon v3. Used on Core2 and later.
@@ -170,6 +194,33 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
+static const struct evt_cstr intel_core_evt[]={
+	EVT_CSTR0(0x10, 0x1),	/* FP_COMP_OPS_EXE */
+	EVT_CSTR0(0x11, 0x2),	/* FP_ASSIST */
+	EVT_CSTR0(0x12, 0x2),	/* MUL */
+	EVT_CSTR0(0x13, 0x2),	/* DIV */
+	EVT_CSTR0(0x14, 0x1),	/* CYCLES_DIV_BUSY */
+	EVT_CSTR0(0x18, 0x1),	/* IDLE_DURING_DIV */
+	EVT_CSTR0(0x19, 0x2),	/* DELAYED_BYPASS */
+	EVT_CSTR0(0xa1, 0x1),	/* RS_UOPS_DISPATCH_CYCLES */
+	EVT_CSTR0(0xcb, 0x1),	/* MEM_LOAD_RETIRED */
+	EVT_CSTR_END
+};
+
+static const struct evt_cstr intel_nhm_evt[]={
+	EVT_CSTR0(0x40, 0x3),	/* L1D_CACHE_LD */
+	EVT_CSTR0(0x41, 0x3),	/* L1D_CACHE_ST */
+	EVT_CSTR0(0x42, 0x3),	/* L1D_CACHE_LOCK */
+	EVT_CSTR0(0x43, 0x3),	/* L1D_ALL_REF */
+	EVT_CSTR0(0x4e, 0x3),	/* L1D_PREFETCH */
+	EVT_CSTR0(0x4c, 0x3),	/* LOAD_HIT_PRE */
+	EVT_CSTR0(0x51, 0x3),	/* L1D */
+	EVT_CSTR0(0x52, 0x3),	/* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
+	EVT_CSTR0(0x53, 0x3),	/* L1D_CACHE_LOCK_FB_HIT */
+	EVT_CSTR0(0xc5, 0x3),	/* CACHE_LOCK_CYCLES */
+	EVT_CSTR_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -932,6 +983,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 	 */
 	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
+	hwc->idx = -1;
+
 	/*
 	 * Count user and OS events unless requested not to.
 	 */
@@ -1366,6 +1419,45 @@ fixed_mode_idx(struct perf_event *event, struct hw_perf_event *hwc)
 }
 
 /*
+ * generic counter allocator: get next free counter
+ */
+static int gen_get_event_idx(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_events);
+	return idx == x86_pmu.num_events ? -1 : idx;
+}
+
+/*
+ * intel-specific counter allocator: check event constraints
+ */
+static int intel_get_event_idx(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	const struct evt_cstr *evt;
+	int i, code;
+
+	if (!evt_cstr)
+		goto skip;
+
+	code = hwc->config & 0xff;
+
+	for_each_evt_cstr(evt, evt_cstr) {
+		if (code == evt->code) {
+			for_each_bit(i, evt->idxmsk, X86_PMC_IDX_MAX) {
+				if (!test_and_set_bit(i, cpuc->used_mask))
+					return i;
+			}
+			return -1;
+		}
+	}
+skip:
+	return gen_get_event_idx(hwc);
+}
+
+/*
  * Find a PMC slot for the freshly enabled / scheduled in event:
  */
 static int x86_pmu_enable(struct perf_event *event)
@@ -1402,11 +1494,10 @@ static int x86_pmu_enable(struct perf_event *event)
 	} else {
 		idx = hwc->idx;
 		/* Try to get the previous generic event again */
-		if (test_and_set_bit(idx, cpuc->used_mask)) {
+		if (idx == -1 || test_and_set_bit(idx, cpuc->used_mask)) {
 try_generic:
-			idx = find_first_zero_bit(cpuc->used_mask,
-						  x86_pmu.num_events);
-			if (idx == x86_pmu.num_events)
+			idx = x86_pmu.get_event_idx(hwc);
+			if (idx == -1)
 				return -EAGAIN;
 
 			set_bit(idx, cpuc->used_mask);
@@ -1883,6 +1974,7 @@ static struct x86_pmu p6_pmu = {
 	 */
 	.event_bits		= 32,
 	.event_mask		= (1ULL << 32) - 1,
+	.get_event_idx		= intel_get_event_idx,
 };
 
 static struct x86_pmu intel_pmu = {
@@ -1906,6 +1998,7 @@ static struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
+	.get_event_idx		= intel_get_event_idx,
 };
 
 static struct x86_pmu amd_pmu = {
@@ -1926,6 +2019,7 @@ static struct x86_pmu amd_pmu = {
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
+	.get_event_idx		= gen_get_event_idx,
 };
 
 static int p6_pmu_init(void)
@@ -1938,10 +2032,12 @@ static int p6_pmu_init(void)
 	case 7:
 	case 8:
 	case 11: /* Pentium III */
+		evt_cstr = intel_p6_evt;
 		break;
 	case 9:
 	case 13:
 		/* Pentium M */
+		evt_cstr = intel_p6_evt;
 		break;
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
@@ -2013,12 +2109,14 @@ static int intel_pmu_init(void)
 		       sizeof(hw_cache_event_ids));
 
 		pr_cont("Core2 events, ");
+		evt_cstr = intel_core_evt;
 		break;
 	default:
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		evt_cstr = intel_nhm_evt;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
-- 
1.5.4.3

