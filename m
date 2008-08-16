Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYHPTYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYHPTYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYHPTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:21:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:19723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYHPTVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k2sHvHUGikW5q6HNKOcU5jgHTF5r0YFnQ8mkvPuWHpRXrIZbdDa1Qgm5NzKe1Ze7L/
         Yd7kM3hI1cK1rkiLkjrkzDqU4C2xgdcUIOpGUjdgPjL8H4UjIGXKR2f57DxDoLazJSaW
         P/fL1haiQZDJrtPPEV9tfFUt9T9qe/BOcw/mA=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 4/6] x86: apic - rearrange functions and comments
Date: Sat, 16 Aug 2008 23:21:53 +0400
Message-Id: <e752642559f71f83b08df6bc44864a5946147279.1218914042.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <7bef3d3fb91a430ad3a461f59c8a5140fa1e9d87.1218914042.git.gorcunov@gmail.com>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
 <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
 <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
 <7bef3d3fb91a430ad3a461f59c8a5140fa1e9d87.1218914042.git.gorcunov@gmail.com>
In-Reply-To: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
References: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange functions and comments to find differences
easier.

Also use apic_printk in setup_boot_APIC_clock for
64bit mode.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   69 +++++++++++++++++++++++++-------------------
 arch/x86/kernel/apic_64.c |   48 ++++++++++++++++++++++++------
 2 files changed, 77 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6cb8aaa..9e8702e 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -251,6 +251,9 @@ int lapic_get_maxlvt(void)
  * this function twice on the boot CPU, once with a bogus timeout
  * value, second time for real. The other (noncalibrating) CPUs
  * call this function only once, with the real, calibrated value.
+ *
+ * We do reads before writes even if unnecessary, to get around the
+ * P5 APIC double write bug.
  */
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
@@ -280,6 +283,36 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 }
 
 /*
+ * Setup extended LVT, AMD specific (K8, family 10h)
+ *
+ * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
+ * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ */
+
+#define APIC_EILVT_LVTOFF_MCE 0
+#define APIC_EILVT_LVTOFF_IBS 1
+
+static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
+{
+	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
+	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
+
+	apic_write(reg, v);
+}
+
+u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_MCE;
+}
+
+u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_IBS;
+}
+
+/*
  * Program the next event, relative to now
  */
 static int lapic_next_event(unsigned long delta,
@@ -298,7 +331,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 	unsigned long flags;
 	unsigned int v;
 
-	/* Lapic used for broadcast ? */
+	/* Lapic used as dummy for broadcast ? */
 	if (evt->features & CLOCK_EVT_FEAT_DUMMY)
 		return;
 
@@ -681,35 +714,6 @@ int setup_profiling_timer(unsigned int multiplier)
 }
 
 /*
- * Setup extended LVT, AMD specific (K8, family 10h)
- *
- * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
- * MCE interrupts are supported. Thus MCE offset must be set to 0.
- */
-
-#define APIC_EILVT_LVTOFF_MCE 0
-#define APIC_EILVT_LVTOFF_IBS 1
-
-static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
-{
-	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
-	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
-	apic_write(reg, v);
-}
-
-u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_MCE;
-}
-
-u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_IBS;
-}
-
-/*
  * Local APIC start and shutdown
  */
 
@@ -1542,6 +1546,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
 #ifdef CONFIG_PM
 
 static struct {
+	/*
+	 * 'active' is true if the local APIC was enabled by us and
+	 * not the BIOS; this signifies that we are also responsible
+	 * for disabling it before entering apm/acpi suspend
+	 */
 	int active;
 	/* r/w apic fields */
 	unsigned int apic_id;
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 13dea93..46523c0 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -81,6 +81,9 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 static void lapic_timer_broadcast(cpumask_t mask);
 static void apic_pm_activate(void);
 
+/*
+ * The local apic timer can be used for any function which is CPU local.
+ */
 static struct clock_event_device lapic_clockevent = {
 	.name		= "lapic",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
@@ -127,6 +130,11 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
+/*
+ * Paravirt kernels also might be using these below ops. So we still
+ * use generic apic_read()/apic_write(), which might be pointing to different
+ * ops in PARAVIRT case.
+ */
 void xapic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
@@ -175,7 +183,6 @@ static struct apic_ops xapic_ops = {
 };
 
 struct apic_ops __read_mostly *apic_ops = &xapic_ops;
-
 EXPORT_SYMBOL_GPL(apic_ops);
 
 static void x2apic_wait_icr_idle(void)
@@ -244,6 +251,10 @@ int lapic_get_maxlvt(void)
 	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
 }
 
+/*
+ * Local APIC timer
+ */
+
 /* Clock divisor is set to 1 */
 #define APIC_DIVISOR 1
 
@@ -257,7 +268,6 @@ int lapic_get_maxlvt(void)
  * We do reads before writes even if unnecessary, to get around the
  * P5 APIC double write bug.
  */
-
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
@@ -474,10 +484,10 @@ static int __init calibrate_APIC_clock(void)
 void __init setup_boot_APIC_clock(void)
 {
 	/*
-	 * The local apic timer can be disabled via the kernel commandline.
-	 * Register the lapic timer as a dummy clock event source on SMP
-	 * systems, so the broadcast mechanism is used. On UP systems simply
-	 * ignore it.
+	 * The local apic timer can be disabled via the kernel
+	 * commandline or from the CPU detection code. Register the lapic
+	 * timer as a dummy clock event source on SMP systems, so the
+	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
 	if (disable_apic_timer) {
 		printk(KERN_INFO "Disabling APIC timer\n");
@@ -489,7 +499,9 @@ void __init setup_boot_APIC_clock(void)
 		return;
 	}
 
-	printk(KERN_INFO "Using local APIC timer interrupts.\n");
+	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
+		    "calibrating APIC timer ...\n");
+
 	if (calibrate_APIC_clock()) {
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1)
@@ -508,6 +520,7 @@ void __init setup_boot_APIC_clock(void)
 		printk(KERN_WARNING "APIC timer registered as dummy,"
 			" due to nmi_watchdog=%d!\n", nmi_watchdog);
 
+	/* Setup the lapic or request the broadcast */
 	setup_APIC_timer();
 }
 
@@ -577,6 +590,7 @@ void smp_apic_timer_interrupt(struct pt_regs *regs)
 	irq_enter();
 	local_apic_timer_interrupt();
 	irq_exit();
+
 	set_irq_regs(old_regs);
 }
 
@@ -1248,6 +1262,13 @@ void __init connect_bsp_APIC(void)
 	enable_apic_mode();
 }
 
+/**
+ * disconnect_bsp_APIC - detach the APIC from the interrupt system
+ * @virt_wire_setup:	indicates, whether virtual wire mode is selected
+ *
+ * Virtual wire mode is necessary to deliver legacy interrupts even when the
+ * APIC is disabled.
+ */
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
 	/* Go back to Virtual Wire compatibility mode */
@@ -1347,9 +1368,11 @@ int hard_smp_processor_id(void)
 #ifdef CONFIG_PM
 
 static struct {
-	/* 'active' is true if the local APIC was enabled by us and
-	   not the BIOS; this signifies that we are also responsible
-	   for disabling it before entering apm/acpi suspend */
+	/*
+	 * 'active' is true if the local APIC was enabled by us and
+	 * not the BIOS; this signifies that we are also responsible
+	 * for disabling it before entering apm/acpi suspend
+	 */
 	int active;
 	/* r/w apic fields */
 	unsigned int apic_id;
@@ -1458,6 +1481,11 @@ static int lapic_resume(struct sys_device *dev)
 	return 0;
 }
 
+/*
+ * This device has no shutdown method - fully functioning local APICs
+ * are needed on every CPU up until machine_halt/restart/poweroff.
+ */
+
 static struct sysdev_class lapic_sysclass = {
 	.name		= "lapic",
 	.resume		= lapic_resume,
-- 
1.6.0.rc1.34.g0fe8c

