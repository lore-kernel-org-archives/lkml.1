Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYLLXwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYLLXwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 18:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYLLXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 18:52:29 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:48685 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYLLXw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 18:52:28 -0500
Message-ID: <4942F93A.8040904@ct.jp.nec.com>
Date: Fri, 12 Dec 2008 15:52:26 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: hardirq: use inc_irq_stat() in non-unified functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Replace incrementing irq stat with inc_irq_stat() in non-unified functions.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 +-
 arch/x86/kernel/time_32.c                 |    2 +-
 arch/x86/kernel/time_64.c                 |    2 +-
 arch/x86/kernel/tlb_32.c                  |    2 +-
 arch/x86/kernel/tlb_64.c                  |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 5eb390a..748c8f9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -237,7 +237,7 @@ asmlinkage void mce_threshold_interrupt(void)
 		}
 	}
 out:
-	add_pda(irq_threshold_count, 1);
+	inc_irq_stat(irq_threshold_count);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index c17eaf5..4b48f25 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -26,7 +26,7 @@ asmlinkage void smp_thermal_interrupt(void)
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
-	add_pda(irq_thermal_count, 1);
+	inc_irq_stat(irq_thermal_count);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 77b400f..65309e4 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -75,7 +75,7 @@ EXPORT_SYMBOL(profile_pc);
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	/* Keep nmi watchdog up to date */
-	per_cpu(irq_stat, smp_processor_id()).irq0_irqs++;
+	inc_irq_stat(irq0_irqs);
 
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_ack) {
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 418a095..1749cac 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(profile_pc);
 
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	add_pda(irq0_irqs, 1);
+	inc_irq_stat(irq0_irqs);
 
 	global_clock_event->event_handler(global_clock_event);
 
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index f4049f3..f374f83 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -119,7 +119,7 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
-	__get_cpu_var(irq_stat).irq_tlb_count++;
+	inc_irq_stat(irq_tlb_count);
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 8f919ca..29887d7 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -154,7 +154,7 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
-	add_pda(irq_tlb_count, 1);
+	inc_irq_stat(irq_tlb_count);
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-- 
1.6.0.4

