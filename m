Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbZANJGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbZANJGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbZANJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:05:33 -0500
Received: from ozlabs.org ([203.10.76.45]:45392 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760389AbZANJF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:05:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18797.43724.342800.891012@cargo.ozlabs.ibm.com>
Date: Wed, 14 Jan 2009 20:05:16 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] powerpc/perf_counter: Make sure PMU gets enabled properly
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure that we call the platform-specific ppc_md.enable_pmcs
function on each CPU before we try to use the PMU on that CPU.  If the
CPU goes off-line and then on-line, we need to do the enable_pmcs call
again, so we use the hw_perf_counter_setup hook to ensure that.  It gets
called as each CPU comes online, but it isn't called on the CPU that is
coming up, so this adds the CPU number as an argument to it (there were
no non-empty instances of hw_perf_counter_setup before).

This also arranges to set the pmcregs_in_use field of the lppaca (data
structure shared with the hypervisor) on each CPU when we are using the
PMU and clear it when we are not.  This allows the hypervisor to optimize
partition switches by not saving/restoring the PMU registers when we
aren't using the PMU.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This commit is available in my perfcounters git tree (master branch) at
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index df3fe05..85ad259 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -15,6 +15,7 @@
 #include <linux/hardirq.h>
 #include <asm/reg.h>
 #include <asm/pmc.h>
+#include <asm/machdep.h>
 
 struct cpu_hw_counters {
 	int n_counters;
@@ -24,6 +25,7 @@ struct cpu_hw_counters {
 	struct perf_counter *counter[MAX_HWCOUNTERS];
 	unsigned int events[MAX_HWCOUNTERS];
 	u64 mmcr[3];
+	u8 pmcs_enabled;
 };
 DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
 
@@ -262,6 +264,15 @@ u64 hw_perf_save_disable(void)
 		cpuhw->n_added = 0;
 
 		/*
+		 * Check if we ever enabled the PMU on this cpu.
+		 */
+		if (!cpuhw->pmcs_enabled) {
+			if (ppc_md.enable_pmcs)
+				ppc_md.enable_pmcs();
+			cpuhw->pmcs_enabled = 1;
+		}
+
+		/*
 		 * Set the 'freeze counters' bit.
 		 * The barrier is to make sure the mtspr has been
 		 * executed and the PMU has frozen the counters
@@ -305,6 +316,8 @@ void hw_perf_restore(u64 disable)
 		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
 		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 		mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+		if (cpuhw->n_counters == 0)
+			get_lppaca()->pmcregs_in_use = 0;
 		goto out;
 	}
 
@@ -323,6 +336,7 @@ void hw_perf_restore(u64 disable)
 	 * bit set and set the hardware counters to their initial values.
 	 * Then unfreeze the counters.
 	 */
+	get_lppaca()->pmcregs_in_use = 1;
 	mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
 	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
@@ -741,6 +755,14 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	}
 }
 
+void hw_perf_counter_setup(int cpu)
+{
+	struct cpu_hw_counters *cpuhw = &per_cpu(cpu_hw_counters, cpu);
+
+	memset(cpuhw, 0, sizeof(*cpuhw));
+	cpuhw->mmcr[0] = MMCR0_FC;
+}
+
 extern struct power_pmu ppc970_pmu;
 extern struct power_pmu power6_pmu;
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 3aef306..52f2f52 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -46,7 +46,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 
 u64 __weak hw_perf_save_disable(void)		{ return 0; }
 void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
-void __weak hw_perf_counter_setup(void)		{ barrier(); }
+void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
 int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx, int cpu)
@@ -1598,7 +1598,7 @@ static void __cpuinit perf_counter_init_cpu(int cpu)
 	cpuctx->max_pertask = perf_max_counters - perf_reserved_percpu;
 	mutex_unlock(&perf_resource_mutex);
 
-	hw_perf_counter_setup();
+	hw_perf_counter_setup(cpu);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
