Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbZEOIrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbZEOIrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZEOIon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:44:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:57257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761690AbZEOIol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:44:41 -0400
Date: Fri, 15 May 2009 08:44:01 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: x86: Protect against infinite loops in intel_pmu_handle_irq()
Message-ID: <tip-9029a5e3801f1cc7cdaab80169d82427acf928d8@git.kernel.org>
Git-Commit-ID: 9029a5e3801f1cc7cdaab80169d82427acf928d8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:44:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9029a5e3801f1cc7cdaab80169d82427acf928d8
Gitweb:     http://git.kernel.org/tip/9029a5e3801f1cc7cdaab80169d82427acf928d8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 15 May 2009 08:26:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:47:06 +0200

perf_counter: x86: Protect against infinite loops in intel_pmu_handle_irq()

intel_pmu_handle_irq() can lock up in an infinite loop if the hardware
does not allow the acking of irqs. Alas, this happened in testing so
make this robust and emit a warning if it happens in the future.

Also, clean up the IRQ handlers a bit.

[ Impact: improve perfcounter irq/nmi handling robustness ]

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 46a82d1..5a7f718 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -722,9 +722,13 @@ static void intel_pmu_save_and_restart(struct perf_counter *counter)
  */
 static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 {
-	int bit, cpu = smp_processor_id();
+	struct cpu_hw_counters *cpuc;
+	struct cpu_hw_counters;
+	int bit, cpu, loops;
 	u64 ack, status;
-	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
 	perf_disable();
 	status = intel_pmu_get_status();
@@ -733,7 +737,13 @@ static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 		return 0;
 	}
 
+	loops = 0;
 again:
+	if (++loops > 100) {
+		WARN_ONCE(1, "perfcounters: irq loop stuck!\n");
+		return 1;
+	}
+
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
 	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
@@ -765,13 +775,14 @@ again:
 
 static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 {
-	int cpu = smp_processor_id();
-	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
-	u64 val;
-	int handled = 0;
+	int cpu, idx, throttle = 0, handled = 0;
+	struct cpu_hw_counters *cpuc;
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
-	int idx, throttle = 0;
+	u64 val;
+
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
 	if (++cpuc->interrupts == PERFMON_MAX_INTERRUPTS) {
 		throttle = 1;
