Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZD2NHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZD2NHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZD2NGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:06:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:44522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbZD2NGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:06:03 -0400
Date: Wed, 29 Apr 2009 13:05:13 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-11-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-11-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: remove ack_status() from struct x86_pmu
Message-ID: <tip-dee5d9067ca78b317538fd67930be4e09a83dbc5@git.kernel.org>
Git-Commit-ID: dee5d9067ca78b317538fd67930be4e09a83dbc5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:05:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dee5d9067ca78b317538fd67930be4e09a83dbc5
Gitweb:     http://git.kernel.org/tip/dee5d9067ca78b317538fd67930be4e09a83dbc5
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:05 +0200

perf_counter, x86: remove ack_status() from struct x86_pmu

This function is Intel only and not necessary for AMD cpus.

[ Impact: simplify code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-11-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
