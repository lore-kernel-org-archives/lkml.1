Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZFCF3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZFCF3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZFCF3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:29:35 -0400
Received: from mga05.intel.com ([192.55.52.89]:10648 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751805AbZFCF3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,296,1241420400"; 
   d="scan'208";a="695982475"
Date: Wed, 3 Jun 2009 13:12:55 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Remove the IRQ (non-NMI) handling
	bits
Message-ID: <20090603051255.GA2791@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the IRQ (non-NMI) handling bits as NMI will be used always.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 include/asm/entry_arch.h  |    1 -
 include/asm/hw_irq.h      |    1 -
 include/asm/irq_vectors.h |    5 -----
 kernel/cpu/perf_counter.c |   21 ++++++---------------
 kernel/entry_64.S         |    2 --
 kernel/irqinit.c          |    1 -
 6 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 794bb12..89c59b2 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -49,7 +49,6 @@ BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
 #ifdef CONFIG_PERF_COUNTERS
-BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
 BUILD_INTERRUPT(perf_pending_interrupt, LOCAL_PENDING_VECTOR)
 #endif
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index d2b24a3..6df45f6 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -29,7 +29,6 @@
 extern void apic_timer_interrupt(void);
 extern void generic_interrupt(void);
 extern void error_interrupt(void);
-extern void perf_counter_interrupt(void);
 extern void perf_pending_interrupt(void);
 
 extern void spurious_interrupt(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index e006719..3c2de12 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -108,11 +108,6 @@
 #define LOCAL_TIMER_VECTOR		0xef
 
 /*
- * Performance monitoring interrupt vector:
- */
-#define LOCAL_PERF_VECTOR		0xee
-
-/*
  * Generic system vector for platform specific use
  */
 #define GENERIC_INTERRUPT_VECTOR	0xed
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index e16e8c1..12cc05e 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -40,7 +40,7 @@ struct cpu_hw_counters {
 struct x86_pmu {
 	const char	*name;
 	int		version;
-	int		(*handle_irq)(struct pt_regs *, int);
+	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
 	void		(*enable_all)(void);
 	void		(*enable)(struct hw_perf_counter *, int);
@@ -755,7 +755,7 @@ static void intel_pmu_reset(void)
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
  */
-static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
+static int intel_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct cpu_hw_counters *cpuc;
 	struct cpu_hw_counters;
@@ -794,7 +794,7 @@ again:
 		if (!intel_pmu_save_and_restart(counter))
 			continue;
 
-		if (perf_counter_overflow(counter, nmi, regs, 0))
+		if (perf_counter_overflow(counter, 1, regs, 0))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
 
@@ -812,7 +812,7 @@ again:
 	return 1;
 }
 
-static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
+static int amd_pmu_handle_irq(struct pt_regs *regs)
 {
 	int cpu, idx, handled = 0;
 	struct cpu_hw_counters *cpuc;
@@ -840,22 +840,13 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, nmi, regs, 0))
+		if (perf_counter_overflow(counter, 1, regs, 0))
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
 	return handled;
 }
 
-void smp_perf_counter_interrupt(struct pt_regs *regs)
-{
-	irq_enter();
-	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
-	ack_APIC_irq();
-	x86_pmu.handle_irq(regs, 0);
-	irq_exit();
-}
-
 void smp_perf_pending_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
@@ -910,7 +901,7 @@ perf_counter_nmi_handler(struct notifier_block *self,
 	 * If the first NMI handles both, the latter will be empty and daze
 	 * the CPU.
 	 */
-	x86_pmu.handle_irq(regs, 1);
+	x86_pmu.handle_irq(regs);
 
 	return NOTIFY_STOP;
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1008511..fbe821d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1013,8 +1013,6 @@ apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
 #ifdef CONFIG_PERF_COUNTERS
-apicinterrupt LOCAL_PERF_VECTOR \
-	perf_counter_interrupt smp_perf_counter_interrupt
 apicinterrupt LOCAL_PENDING_VECTOR \
 	perf_pending_interrupt smp_perf_pending_interrupt
 #endif
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index aab3d27..343ec2e 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -201,7 +201,6 @@ static void __init apic_intr_init(void)
 
 	/* Performance monitoring interrupts: */
 # ifdef CONFIG_PERF_COUNTERS
-	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
 	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
 # endif
 
