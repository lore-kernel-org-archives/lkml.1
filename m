Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZFXJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZFXJBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZFXJB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:01:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:56977 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZFXJBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:01:25 -0400
Date: Wed, 24 Jun 2009 09:00:34 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, yong.y.wang@intel.com, arjan@infradead.org,
       yong.y.wang@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, yong.y.wang@intel.com,
       arjan@infradead.org, yong.y.wang@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090624021324.GA2788@ywang-moblin2.bj.intel.com>
References: <20090624021324.GA2788@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/urgent] perf_counter, x86: Set global control MSR correctly
Message-ID: <tip-c14dab5c0782ef632742963a66276a195418a63c@git.kernel.org>
Git-Commit-ID: c14dab5c0782ef632742963a66276a195418a63c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:00:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c14dab5c0782ef632742963a66276a195418a63c
Gitweb:     http://git.kernel.org/tip/c14dab5c0782ef632742963a66276a195418a63c
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Wed, 24 Jun 2009 10:13:24 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 10:51:24 +0200

perf_counter, x86: Set global control MSR correctly

Previous code made an assumption that the power on value of global
control MSR has enabled all fixed and general purpose counters properly.

However, this is not the case for certain Intel processors, such as
Atom - and it might also be firmware dependent.

Each enable bit in IA32_PERF_GLOBAL_CTRL is AND'ed with the
enable bits for all privilege levels in the respective IA32_PERFEVTSELx
or IA32_PERF_FIXED_CTR_CTRL MSRs to start/stop the counting of
respective counters. Counting is enabled if the AND'ed results is true;
counting is disabled when the result is false.

The end result is that all fixed counters are always disabled on Atom
processors because the assumption is just invalid.

Fix this by not initializing the ctrl-mask out of the global MSR,
but setting it to perf_counter_mask.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090624021324.GA2788@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

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
