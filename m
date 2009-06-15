Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZFOIZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZFOIZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZFOIZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:25:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45845 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbZFOIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:25:32 -0400
Message-ID: <4A360577.10601@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:25:27 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/16] x86, mce: unify smp_thermal_interrupt
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put common functions into therm_throt.c, modify Makefile.

	unexpected_thermal_interrupt
	intel_thermal_interrupt
	smp_thermal_interrupt
	intel_set_thermal_handler

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/Makefile       |    7 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   38 ------------------------
 arch/x86/kernel/cpu/mcheck/p4.c           |   45 -----------------------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c  |   40 +++++++++++++++++++++++++-
 4 files changed, 43 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index 45004fa..53df57d 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,11 +1,12 @@
-obj-y				=  mce.o therm_throt.o
+obj-y				=  mce.o
 
 obj-$(CONFIG_X86_NEW_MCE)	+= mce-severity.o
 obj-$(CONFIG_X86_OLD_MCE)	+= k7.o p4.o p6.o
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
-obj-$(CONFIG_X86_MCE_P4THERMAL)	+= mce_intel.o
-obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o mce_intel.o
+obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
 obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
+
+obj-$(CONFIG_X86_THERMAL_VECTOR) += therm_throt.o mce_intel.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 922e3a4..3b7a057 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -9,48 +9,10 @@
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <asm/processor.h>
-#include <asm/apic.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
-#include <asm/hw_irq.h>
-#include <asm/idle.h>
 #include <asm/therm_throt.h>
 
-static void unexpected_thermal_interrupt(void)
-{
-	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
-			smp_processor_id());
-	add_taint(TAINT_MACHINE_CHECK);
-}
-
-/* P4/Xeon Thermal transition interrupt handler: */
-static void intel_thermal_interrupt(void)
-{
-	__u64 msr_val;
-
-	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
-		mce_log_therm_throt_event(msr_val);
-}
-
-/* Thermal interrupt handler for this CPU setup: */
-static void (*vendor_thermal_interrupt)(void) = unexpected_thermal_interrupt;
-
-asmlinkage void smp_thermal_interrupt(void)
-{
-	exit_idle();
-	irq_enter();
-	inc_irq_stat(irq_thermal_count);
-	intel_thermal_interrupt();
-	irq_exit();
-	ack_APIC_irq();
-}
-
-void intel_set_thermal_handler(void)
-{
-	vendor_thermal_interrupt = intel_thermal_interrupt;
-}
-
 /*
  * Support for Intel Correct Machine Check Interrupts. This allows
  * the CPU to raise an interrupt when a corrected machine check happened.
diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index 75313f5..76c5f03 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -1,8 +1,6 @@
 /*
  * P4 specific Machine Check Exception Reporting
  */
-
-#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -10,9 +8,6 @@
 
 #include <asm/therm_throt.h>
 #include <asm/processor.h>
-#include <asm/system.h>
-#include <asm/apic.h>
-#include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -33,46 +28,6 @@ struct intel_mce_extended_msrs {
 
 static int mce_num_extended_msrs;
 
-
-#ifdef CONFIG_X86_MCE_P4THERMAL
-
-static void unexpected_thermal_interrupt(void)
-{
-	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
-			smp_processor_id());
-	add_taint(TAINT_MACHINE_CHECK);
-}
-
-/* P4/Xeon Thermal transition interrupt handler: */
-static void intel_thermal_interrupt(void)
-{
-	__u64 msr_val;
-
-	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
-		mce_log_therm_throt_event(msr_val);
-}
-
-/* Thermal interrupt handler for this CPU setup: */
-static void (*vendor_thermal_interrupt)(void) = unexpected_thermal_interrupt;
-
-void smp_thermal_interrupt(struct pt_regs *regs)
-{
-	exit_idle();
-	irq_enter();
-	inc_irq_stat(irq_thermal_count);
-	vendor_thermal_interrupt();
-	irq_exit();
-	ack_APIC_irq();
-}
-
-void intel_set_thermal_handler(void)
-{
-	vendor_thermal_interrupt = intel_thermal_interrupt;
-}
-
-#endif /* CONFIG_X86_MCE_P4THERMAL */
-
 /* P4/Xeon Extended MCE MSR retrieval, return 0 if unsupported */
 static void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 7b1ae2e..b3792b1 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -13,6 +13,7 @@
  * Credits: Adapted from Zwane Mwaikambo's original code in mce_intel.c.
  *          Inspired by Ross Biro's and Al Borchers' counter code.
  */
+#include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
 #include <linux/percpu.h>
@@ -20,6 +21,8 @@
 #include <linux/cpu.h>
 
 #include <asm/therm_throt.h>
+#include <asm/idle.h>
+#include <asm/mce.h>
 
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
@@ -186,6 +189,41 @@ static __init int thermal_throttle_init_device(void)
 
 	return 0;
 }
-
 device_initcall(thermal_throttle_init_device);
+
 #endif /* CONFIG_SYSFS */
+
+/* Thermal transition interrupt handler */
+void intel_thermal_interrupt(void)
+{
+	__u64 msr_val;
+
+	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
+	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
+		mce_log_therm_throt_event(msr_val);
+}
+
+static void unexpected_thermal_interrupt(void)
+{
+	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
+			smp_processor_id());
+	add_taint(TAINT_MACHINE_CHECK);
+}
+
+static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
+
+asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
+{
+	exit_idle();
+	irq_enter();
+	inc_irq_stat(irq_thermal_count);
+	smp_thermal_vector();
+	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
+}
+
+void intel_set_thermal_handler(void)
+{
+	smp_thermal_vector = intel_thermal_interrupt;
+}
-- 
1.6.3


