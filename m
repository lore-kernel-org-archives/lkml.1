Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYL0Nru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYL0Nru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 08:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYL0Nrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 08:47:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:35117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYL0Nrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 08:47:40 -0500
Subject: [PATCH] x86: perf_counter remove unwanted hw_perf_enable_all
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       perfctr-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Sat, 27 Dec 2008 19:15:43 +0530
Message-Id: <1230385543.3373.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clean, reduce kernel size a bit, avoid sparse warnings

Fixes sparse warnings:

arch/x86/kernel/cpu/perf_counter.c:153:6: warning: symbol 'hw_perf_enable_all' was not declared. Should it be static?
arch/x86/kernel/cpu/perf_counter.c:279:3: warning: returning void-valued expression
arch/x86/kernel/cpu/perf_counter.c:206:3: warning: returning void-valued expression
arch/x86/kernel/cpu/perf_counter.c:206:3: warning: returning void-valued expression

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index da46eca..9376771 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -150,14 +150,6 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	return 0;
 }
 
-void hw_perf_enable_all(void)
-{
-	if (unlikely(!perf_counters_initialized))
-		return;
-
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, perf_counter_mask);
-}
-
 u64 hw_perf_save_disable(void)
 {
 	u64 ctrl;
@@ -200,12 +192,10 @@ static inline void
 __pmc_generic_disable(struct perf_counter *counter,
 			   struct hw_perf_counter *hwc, unsigned int idx)
 {
-	int err;
-
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
-		return __pmc_fixed_disable(counter, hwc, idx);
-
-	err = wrmsr_safe(hwc->config_base + idx, hwc->config, 0);
+		__pmc_fixed_disable(counter, hwc, idx);
+	else
+		wrmsr_safe(hwc->config_base + idx, hwc->config, 0);
 }
 
 static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
@@ -276,10 +266,10 @@ __pmc_generic_enable(struct perf_counter *counter,
 			  struct hw_perf_counter *hwc, int idx)
 {
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
-		return __pmc_fixed_enable(counter, hwc, idx);
-
-	wrmsr(hwc->config_base + idx,
-	      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+		__pmc_fixed_enable(counter, hwc, idx);
+	else
+		wrmsr(hwc->config_base + idx,
+		      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
 }
 
 static int
-- 
1.5.5.1



