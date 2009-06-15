Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZFOIYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZFOIYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZFOIYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:24:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45783 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZFOIYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:24:46 -0400
Message-ID: <4A360548.3010304@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:24:40 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/16] x86, mce: unify smp_thermal_interrupt, prepare
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let them in same shape.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h                |   25 ++++++++++++++-----------
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   20 ++++++++++++++++++--
 arch/x86/kernel/cpu/mcheck/p4.c           |   10 ++++++----
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6568cde..3bc827c 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -110,6 +110,7 @@ extern int mce_disabled;
 extern int mce_p5_enabled;
 
 #ifdef CONFIG_X86_OLD_MCE
+extern int nr_mce_banks;
 void amd_mcheck_init(struct cpuinfo_x86 *c);
 void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
 void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
@@ -128,15 +129,6 @@ static inline void enable_p5_mce(void) {}
 /* Call the installed machine check handler for this CPU setup. */
 extern void (*machine_check_vector)(struct pt_regs *, long error_code);
 
-#ifdef CONFIG_X86_OLD_MCE
-extern int nr_mce_banks;
-extern void intel_set_thermal_handler(void);
-#else
-static inline void intel_set_thermal_handler(void) { }
-#endif
-
-void intel_init_thermal(struct cpuinfo_x86 *c);
-
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
@@ -175,8 +167,6 @@ int mce_available(struct cpuinfo_x86 *c);
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
 
-void mce_log_therm_throt_event(__u64 status);
-
 extern atomic_t mce_entry;
 
 void do_machine_check(struct pt_regs *, long);
@@ -205,5 +195,18 @@ void mcheck_init(struct cpuinfo_x86 *c);
 
 extern void (*mce_threshold_vector)(void);
 
+/*
+ * Thermal handler
+ */
+
+void intel_set_thermal_handler(void);
+void intel_init_thermal(struct cpuinfo_x86 *c);
+
+#ifdef CONFIG_X86_NEW_MCE
+void mce_log_therm_throt_event(__u64 status);
+#else
+static inline void mce_log_therm_throt_event(__u64 status) {}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index a5232b2..922e3a4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -16,6 +16,14 @@
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
 
+static void unexpected_thermal_interrupt(void)
+{
+	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
+			smp_processor_id());
+	add_taint(TAINT_MACHINE_CHECK);
+}
+
+/* P4/Xeon Thermal transition interrupt handler: */
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
@@ -25,14 +33,22 @@ static void intel_thermal_interrupt(void)
 		mce_log_therm_throt_event(msr_val);
 }
 
+/* Thermal interrupt handler for this CPU setup: */
+static void (*vendor_thermal_interrupt)(void) = unexpected_thermal_interrupt;
+
 asmlinkage void smp_thermal_interrupt(void)
 {
-	ack_APIC_irq();
 	exit_idle();
 	irq_enter();
-	intel_thermal_interrupt();
 	inc_irq_stat(irq_thermal_count);
+	intel_thermal_interrupt();
 	irq_exit();
+	ack_APIC_irq();
+}
+
+void intel_set_thermal_handler(void)
+{
+	vendor_thermal_interrupt = intel_thermal_interrupt;
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index ddeed6e..75313f5 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -12,6 +12,7 @@
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -47,10 +48,9 @@ static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
 
-	ack_APIC_irq();
-
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	therm_throt_process(msr_val & THERM_STATUS_PROCHOT);
+	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
+		mce_log_therm_throt_event(msr_val);
 }
 
 /* Thermal interrupt handler for this CPU setup: */
@@ -58,10 +58,12 @@ static void (*vendor_thermal_interrupt)(void) = unexpected_thermal_interrupt;
 
 void smp_thermal_interrupt(struct pt_regs *regs)
 {
+	exit_idle();
 	irq_enter();
-	vendor_thermal_interrupt();
 	inc_irq_stat(irq_thermal_count);
+	vendor_thermal_interrupt();
 	irq_exit();
+	ack_APIC_irq();
 }
 
 void intel_set_thermal_handler(void)
-- 
1.6.3


