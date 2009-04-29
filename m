Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZD2NHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZD2NHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZD2NFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:05:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:44495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110AbZD2NFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:05:45 -0400
Date: Wed, 29 Apr 2009 13:05:01 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-10-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-10-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: remove get_status() from struct x86_pmu
Message-ID: <tip-b7f8859a8ed1937e2139c17b84878f1d413fa659@git.kernel.org>
Git-Commit-ID: b7f8859a8ed1937e2139c17b84878f1d413fa659
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:05:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7f8859a8ed1937e2139c17b84878f1d413fa659
Gitweb:     http://git.kernel.org/tip/b7f8859a8ed1937e2139c17b84878f1d413fa659
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:05 +0200

perf_counter, x86: remove get_status() from struct x86_pmu

This function is Intel only and not necessary for AMD cpus.

[ Impact: simplify code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-10-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   39 ++++-------------------------------
 1 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 9d90de0..d0bb029 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -51,7 +51,6 @@ struct x86_pmu {
 	int		(*handle_irq)(struct pt_regs *, int);
 	u64		(*save_disable_all)(void);
 	void		(*restore_all)(u64);
-	u64		(*get_status)(u64);
 	void		(*ack_status)(u64);
 	void		(*enable)(int, u64);
 	void		(*disable)(int, u64);
@@ -405,41 +404,15 @@ void hw_perf_restore(u64 ctrl)
  */
 EXPORT_SYMBOL_GPL(hw_perf_restore);
 
-static u64 intel_pmu_get_status(u64 mask)
+static inline u64 intel_pmu_get_status(u64 mask)
 {
 	u64 status;
 
-	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
-
-	return status;
-}
-
-static u64 amd_pmu_get_status(u64 mask)
-{
-	u64 status = 0;
-	int idx;
-
-	for (idx = 0; idx < nr_counters_generic; idx++) {
-		s64 val;
-
-		if (!(mask & (1 << idx)))
-			continue;
-
-		rdmsrl(MSR_K7_PERFCTR0 + idx, val);
-		val <<= (64 - counter_value_bits);
-		if (val >= 0)
-			status |= (1 << idx);
-	}
-
-	return status;
-}
-
-static u64 hw_perf_get_status(u64 mask)
-{
 	if (unlikely(!perf_counters_initialized))
 		return 0;
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
 
-	return x86_pmu->get_status(mask);
+	return status;
 }
 
 static void intel_pmu_ack_status(u64 ack)
@@ -795,7 +768,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 
 	cpuc->throttle_ctrl = hw_perf_save_disable();
 
-	status = hw_perf_get_status(cpuc->throttle_ctrl);
+	status = intel_pmu_get_status(cpuc->throttle_ctrl);
 	if (!status)
 		goto out;
 
@@ -820,7 +793,7 @@ again:
 	/*
 	 * Repeat if there is more work to be done:
 	 */
-	status = hw_perf_get_status(cpuc->throttle_ctrl);
+	status = intel_pmu_get_status(cpuc->throttle_ctrl);
 	if (status)
 		goto again;
 out:
@@ -931,7 +904,6 @@ static struct x86_pmu intel_pmu = {
 	.handle_irq		= intel_pmu_handle_irq,
 	.save_disable_all	= intel_pmu_save_disable_all,
 	.restore_all		= intel_pmu_restore_all,
-	.get_status		= intel_pmu_get_status,
 	.ack_status		= intel_pmu_ack_status,
 	.enable			= intel_pmu_enable_counter,
 	.disable		= intel_pmu_disable_counter,
@@ -946,7 +918,6 @@ static struct x86_pmu amd_pmu = {
 	.handle_irq		= amd_pmu_handle_irq,
 	.save_disable_all	= amd_pmu_save_disable_all,
 	.restore_all		= amd_pmu_restore_all,
-	.get_status		= amd_pmu_get_status,
 	.ack_status		= amd_pmu_ack_status,
 	.enable			= amd_pmu_enable_counter,
 	.disable		= amd_pmu_disable_counter,
