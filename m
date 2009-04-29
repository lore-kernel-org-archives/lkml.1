Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbZD2K4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbZD2K4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZD2Kv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:26 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:29426 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753919AbZD2KvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:06 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-WSS-ID: 0KIUZGO-02-18O-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/29] x86/perfcounters: remove ack_status() from struct x86_pmu
Date: Wed, 29 Apr 2009 12:47:07 +0200
Message-ID: <1241002046-8832-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0321 (UTC) FILETIME=[5B9B4590:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is Intel only and not necessary for AMD cpus.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d0bb029..6bbdc16 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -51,7 +51,6 @@ struct x86_pmu {
 	int		(*handle_irq)(struct pt_regs *, int);
 	u64		(*save_disable_all)(void);
 	void		(*restore_all)(u64);
-	void		(*ack_status)(u64);
 	void		(*enable)(int, u64);
 	void		(*disable)(int, u64);
 	unsigned	eventsel;
@@ -415,23 +414,11 @@ static inline u64 intel_pmu_get_status(u64 mask)
 	return status;
 }
 
-static void intel_pmu_ack_status(u64 ack)
+static inline void intel_pmu_ack_status(u64 ack)
 {
 	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
 }
 
-static void amd_pmu_ack_status(u64 ack)
-{
-}
-
-static void hw_perf_ack_status(u64 ack)
-{
-	if (unlikely(!perf_counters_initialized))
-		return;
-
-	x86_pmu->ack_status(ack);
-}
-
 static void intel_pmu_enable_counter(int idx, u64 config)
 {
 	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx,
@@ -788,7 +775,7 @@ again:
 			__x86_pmu_disable(counter, &counter->hw, bit);
 	}
 
-	hw_perf_ack_status(ack);
+	intel_pmu_ack_status(ack);
 
 	/*
 	 * Repeat if there is more work to be done:
@@ -904,7 +891,6 @@ static struct x86_pmu intel_pmu = {
 	.handle_irq		= intel_pmu_handle_irq,
 	.save_disable_all	= intel_pmu_save_disable_all,
 	.restore_all		= intel_pmu_restore_all,
-	.ack_status		= intel_pmu_ack_status,
 	.enable			= intel_pmu_enable_counter,
 	.disable		= intel_pmu_disable_counter,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
@@ -918,7 +904,6 @@ static struct x86_pmu amd_pmu = {
 	.handle_irq		= amd_pmu_handle_irq,
 	.save_disable_all	= amd_pmu_save_disable_all,
 	.restore_all		= amd_pmu_restore_all,
-	.ack_status		= amd_pmu_ack_status,
 	.enable			= amd_pmu_enable_counter,
 	.disable		= amd_pmu_disable_counter,
 	.eventsel		= MSR_K7_EVNTSEL0,
-- 
1.6.1.3


