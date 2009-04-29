Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZD2NGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZD2NGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZD2NFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:05:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbZD2NFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:05:33 -0400
Date: Wed, 29 Apr 2009 13:04:50 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-9-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-9-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: make interrupt handler model specific
Message-ID: <tip-39d81eab2374d71b2d9c82f66258a1a4f57ddd2e@git.kernel.org>
Git-Commit-ID: 39d81eab2374d71b2d9c82f66258a1a4f57ddd2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:04:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39d81eab2374d71b2d9c82f66258a1a4f57ddd2e
Gitweb:     http://git.kernel.org/tip/39d81eab2374d71b2d9c82f66258a1a4f57ddd2e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:04 +0200

perf_counter, x86: make interrupt handler model specific

This separates the perfcounter interrupt handler for AMD and Intel
cpus. The AMD interrupt handler implementation is a follow-on patch.

[ Impact: refactor and clean up code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-9-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 808a1a1..9d90de0 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -4,6 +4,7 @@
  *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
  *  Copyright(C) 2009 Jaswinder Singh Rajput
+ *  Copyright(C) 2009 Advanced Micro Devices, Inc., Robert Richter
  *
  *  For licencing details see kernel-base/COPYING
  */
@@ -47,6 +48,7 @@ struct cpu_hw_counters {
  * struct x86_pmu - generic x86 pmu
  */
 struct x86_pmu {
+	int		(*handle_irq)(struct pt_regs *, int);
 	u64		(*save_disable_all)(void);
 	void		(*restore_all)(u64);
 	u64		(*get_status)(u64);
@@ -241,6 +243,10 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	struct hw_perf_counter *hwc = &counter->hw;
 	int err;
 
+	/* disable temporarily */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return -ENOSYS;
+
 	if (unlikely(!perf_counters_initialized))
 		return -EINVAL;
 
@@ -780,7 +786,7 @@ static void perf_save_and_restart(struct perf_counter *counter)
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
  */
-static int __smp_perf_counter_interrupt(struct pt_regs *regs, int nmi)
+static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 {
 	int bit, cpu = smp_processor_id();
 	u64 ack, status;
@@ -827,6 +833,8 @@ out:
 	return ret;
 }
 
+static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi) { return 0; }
+
 void perf_counter_unthrottle(void)
 {
 	struct cpu_hw_counters *cpuc;
@@ -851,7 +859,7 @@ void smp_perf_counter_interrupt(struct pt_regs *regs)
 	irq_enter();
 	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
 	ack_APIC_irq();
-	__smp_perf_counter_interrupt(regs, 0);
+	x86_pmu->handle_irq(regs, 0);
 	irq_exit();
 }
 
@@ -908,7 +916,7 @@ perf_counter_nmi_handler(struct notifier_block *self,
 	regs = args->regs;
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	ret = __smp_perf_counter_interrupt(regs, 1);
+	ret = x86_pmu->handle_irq(regs, 1);
 
 	return ret ? NOTIFY_STOP : NOTIFY_OK;
 }
@@ -920,6 +928,7 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
 };
 
 static struct x86_pmu intel_pmu = {
+	.handle_irq		= intel_pmu_handle_irq,
 	.save_disable_all	= intel_pmu_save_disable_all,
 	.restore_all		= intel_pmu_restore_all,
 	.get_status		= intel_pmu_get_status,
@@ -934,6 +943,7 @@ static struct x86_pmu intel_pmu = {
 };
 
 static struct x86_pmu amd_pmu = {
+	.handle_irq		= amd_pmu_handle_irq,
 	.save_disable_all	= amd_pmu_save_disable_all,
 	.restore_all		= amd_pmu_restore_all,
 	.get_status		= amd_pmu_get_status,
