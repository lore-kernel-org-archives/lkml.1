Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZFOI0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZFOI0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbZFOI0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:26:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47988 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbZFOI0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:26:15 -0400
Message-ID: <4A3605A2.6000206@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:26:10 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/16] x86, mce: squash mce_intel.c into therm_throt.c
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move intel_init_thermal() into therm_throt.c

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/Makefile      |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c   |   73 ------------------------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   66 +++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 74 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c

diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index 53df57d..659564e 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
 obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
 
-obj-$(CONFIG_X86_THERMAL_VECTOR) += therm_throt.o mce_intel.o
+obj-$(CONFIG_X86_THERMAL_VECTOR) += therm_throt.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
deleted file mode 100644
index 475478b..0000000
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * Common code for Intel machine checks
- */
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/therm_throt.h>
-#include <asm/processor.h>
-#include <asm/system.h>
-#include <asm/apic.h>
-#include <asm/mce.h>
-#include <asm/msr.h>
-
-void intel_init_thermal(struct cpuinfo_x86 *c)
-{
-	unsigned int cpu = smp_processor_id();
-	int tm2 = 0;
-	u32 l, h;
-
-	/* Thermal monitoring depends on ACPI and clock modulation*/
-	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
-		return;
-
-	/*
-	 * First check if its enabled already, in which case there might
-	 * be some SMM goo which handles it, so we can't even put a handler
-	 * since it might be delivered via SMI already:
-	 */
-	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	h = apic_read(APIC_LVTTHMR);
-	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
-		return;
-	}
-
-	if (cpu_has(c, X86_FEATURE_TM2) && (l & MSR_IA32_MISC_ENABLE_TM2))
-		tm2 = 1;
-
-	/* Check whether a vector already exists */
-	if (h & APIC_VECTOR_MASK) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal LVT vector (%#x) already installed\n",
-		       cpu, (h & APIC_VECTOR_MASK));
-		return;
-	}
-
-	/* We'll mask the thermal vector in the lapic till we're ready: */
-	h = THERMAL_APIC_VECTOR | APIC_DM_FIXED | APIC_LVT_MASKED;
-	apic_write(APIC_LVTTHMR, h);
-
-	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
-	wrmsr(MSR_IA32_THERM_INTERRUPT,
-		l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
-
-	intel_set_thermal_handler();
-
-	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	wrmsr(MSR_IA32_MISC_ENABLE, l | MSR_IA32_MISC_ENABLE_TM1, h);
-
-	/* Unmask the thermal vector: */
-	l = apic_read(APIC_LVTTHMR);
-	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
-
-	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
-	       cpu, tm2 ? "TM2" : "TM1");
-
-	/* enable thermal throttle processing */
-	atomic_set(&therm_throt_en, 1);
-}
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index b3792b1..7a508aa 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -16,13 +16,21 @@
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
+#include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/sysdev.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/smp.h>
 #include <linux/cpu.h>
 
 #include <asm/therm_throt.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/apic.h>
 #include <asm/idle.h>
 #include <asm/mce.h>
+#include <asm/msr.h>
 
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
@@ -227,3 +235,61 @@ void intel_set_thermal_handler(void)
 {
 	smp_thermal_vector = intel_thermal_interrupt;
 }
+
+void intel_init_thermal(struct cpuinfo_x86 *c)
+{
+	unsigned int cpu = smp_processor_id();
+	int tm2 = 0;
+	u32 l, h;
+
+	/* Thermal monitoring depends on ACPI and clock modulation*/
+	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
+		return;
+
+	/*
+	 * First check if its enabled already, in which case there might
+	 * be some SMM goo which handles it, so we can't even put a handler
+	 * since it might be delivered via SMI already:
+	 */
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
+	h = apic_read(APIC_LVTTHMR);
+	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
+		printk(KERN_DEBUG
+		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
+		return;
+	}
+
+	if (cpu_has(c, X86_FEATURE_TM2) && (l & MSR_IA32_MISC_ENABLE_TM2))
+		tm2 = 1;
+
+	/* Check whether a vector already exists */
+	if (h & APIC_VECTOR_MASK) {
+		printk(KERN_DEBUG
+		       "CPU%d: Thermal LVT vector (%#x) already installed\n",
+		       cpu, (h & APIC_VECTOR_MASK));
+		return;
+	}
+
+	/* We'll mask the thermal vector in the lapic till we're ready: */
+	h = THERMAL_APIC_VECTOR | APIC_DM_FIXED | APIC_LVT_MASKED;
+	apic_write(APIC_LVTTHMR, h);
+
+	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
+	wrmsr(MSR_IA32_THERM_INTERRUPT,
+		l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
+
+	intel_set_thermal_handler();
+
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
+	wrmsr(MSR_IA32_MISC_ENABLE, l | MSR_IA32_MISC_ENABLE_TM1, h);
+
+	/* Unmask the thermal vector: */
+	l = apic_read(APIC_LVTTHMR);
+	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+
+	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
+	       cpu, tm2 ? "TM2" : "TM1");
+
+	/* enable thermal throttle processing */
+	atomic_set(&therm_throt_en, 1);
+}
-- 
1.6.3


