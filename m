Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZFXCaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZFXCaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 22:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZFXCaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 22:30:05 -0400
Received: from mga07.intel.com ([143.182.124.22]:19244 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbZFXCaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 22:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,279,1243839600"; 
   d="scan'208";a="157813380"
Date: Wed, 24 Jun 2009 10:13:24 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: stephane eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Set global control MSR correctly
Message-ID: <20090624021324.GA2788@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous code made an assumption that the power on value of global
control MSR has enabled all fixed and general purpose counters properly.
However, this is not the case for certain Intel processors, such as
Atom. Each enable bit in IA32_PERF_GLOBAL_CTRL is AND'ed with the
enable bits for all privilege levels in the respective IA32_PERFEVTSELx
or IA32_PERF_FIXED_CTR_CTRL MSRs to start/stop the counting of
respective counters. Counting is enabled if the AND'ed results is true;
counting is disabled when the result is false. The end result is that
all fixed counters are always disabled on Atom processors because the
assumption is just invalid.

Reported-by: stephane eranian <eranian@googlemail.com>
Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 arch/x86/kernel/cpu/perf_counter.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 22eb3a1..a310d19 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -969,13 +969,6 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
-	/*
-	 * Quirk, IA32_FIXED_CTRs do not work on current Atom processors:
-	 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-					boot_cpu_data.x86_model == 28)
-		return -1;
-
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
@@ -1428,8 +1421,6 @@ static int intel_pmu_init(void)
 	 */
 	x86_pmu.num_counters_fixed	= max((int)edx.split.num_counters_fixed, 3);
 
-	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
-
 	/*
 	 * Install the hw-cache-events table:
 	 */
@@ -1514,6 +1505,7 @@ void __init init_hw_perf_counters(void)
 
 	perf_counter_mask |=
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
+	x86_pmu.intel_ctrl = perf_counter_mask;
 
 	perf_counters_lapic_init();
 	register_die_notifier(&perf_counter_nmi_notifier);
