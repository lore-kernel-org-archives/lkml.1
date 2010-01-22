Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942Ab0AVO4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0AVO4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684Ab0AVO4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:56:02 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:43587 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0AVOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:58 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFN-01-74B-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/12] perf/core, x86: make event_constraints a member of struct x86_pmu
Date: Fri, 22 Jan 2010 15:22:06 +0100
Message-ID: <1264170127-17402-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0721 (UTC) FILETIME=[DC3F8D90:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event_constraints describe the x86 pmu and thus are better located
in struct x86_pmu than in a separate static variable. This is also
necessary to generalize some model specific functions such as
intel_get_event_idx().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3e0fc29..b893ee7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -123,6 +123,7 @@ struct x86_pmu {
 	void		(*disable_bts)(void);
 	int		(*get_event_idx)(struct cpu_hw_events *cpuc,
 					 struct hw_perf_event *hwc);
+	struct event_constraint *event_constraints;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -131,8 +132,6 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static const struct event_constraint *event_constraints;
-
 /*
  * Not sure about some of these
  */
@@ -160,7 +159,7 @@ static u64 p6_pmu_event_map(int hw_event)
  */
 #define P6_NOP_EVENT			0x0000002EULL
 
-static const struct event_constraint intel_p6_event_constraints[] =
+static struct event_constraint intel_p6_event_constraints[] =
 {
 	EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
 	EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
@@ -185,7 +184,7 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
-static const struct event_constraint intel_core_event_constraints[] =
+static struct event_constraint intel_core_event_constraints[] =
 {
 	EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
 	EVENT_CONSTRAINT(0x11, 0x2),	/* FP_ASSIST */
@@ -199,7 +198,7 @@ static const struct event_constraint intel_core_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static const struct event_constraint intel_nehalem_event_constraints[] =
+static struct event_constraint intel_nehalem_event_constraints[] =
 {
 	EVENT_CONSTRAINT(0x40, 0x3),	/* L1D_CACHE_LD */
 	EVENT_CONSTRAINT(0x41, 0x3),	/* L1D_CACHE_ST */
@@ -1413,12 +1412,12 @@ __intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 	const struct event_constraint *event_constraint;
 	int i, code;
 
-	if (!event_constraints)
+	if (!x86_pmu.event_constraints)
 		goto skip;
 
 	code = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
 
-	for_each_event_constraint(event_constraint, event_constraints) {
+	for_each_event_constraint(event_constraint, x86_pmu.event_constraints) {
 		if (code == event_constraint->code) {
 			for_each_bit(i, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
 				if (!test_and_set_bit(i, cpuc->used_mask))
@@ -1990,6 +1989,7 @@ static __initconst struct x86_pmu p6_pmu = {
 	.cntval_bits		= 32,
 	.cntval_mask		= (1ULL << 32) - 1,
 	.get_event_idx		= intel_get_event_idx,
+	.event_constraints	= intel_p6_event_constraints,
 };
 
 static __initconst struct x86_pmu intel_pmu = {
@@ -2047,12 +2047,8 @@ static __init int p6_pmu_init(void)
 	case 7:
 	case 8:
 	case 11: /* Pentium III */
-		event_constraints = intel_p6_event_constraints;
-		break;
 	case 9:
-	case 13:
-		/* Pentium M */
-		event_constraints = intel_p6_event_constraints;
+	case 13: /* Pentium M */
 		break;
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
@@ -2118,14 +2114,14 @@ static __init int intel_pmu_init(void)
 		       sizeof(hw_cache_event_ids));
 
 		pr_cont("Core2 events, ");
-		event_constraints = intel_core_event_constraints;
+		x86_pmu.event_constraints = intel_core_event_constraints;
 		break;
 	default:
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		event_constraints = intel_nehalem_event_constraints;
+		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
-- 
1.6.6


