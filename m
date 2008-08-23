Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYHWJzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYHWJzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 05:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYHWJyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 05:54:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:5249 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYHWJyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 05:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p6clKTeyhuW4H+snTYO9XIXt1nFcmwyCcMsYYm+lSIhJ5+Z+K+PJzX6iUe4cFM2ifY
         PO8DWv8tWGM8ZZjQW3QOND31AaZ0BRqfCPvsurY+Eptufe/W0n/AuShUczn7xzeoZM1L
         7TgPTiHyByZXS1rmNJuTuxCcTDq3EWoHNxrSE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: apic_xx.c order variables
Date: Sat, 23 Aug 2008 02:54:02 -0700
Message-Id: <1219485242-16570-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index c168cec..68412b1 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -50,16 +50,27 @@
 # error SPURIOUS_APIC_VECTOR definition error
 #endif
 
-unsigned long mp_lapic_addr;
-
 /*
  * Knob to control our willingness to enable the local APIC.
  *
  * +1=force-enable
  */
 static int force_enable_local_apic;
-int disable_apic;
+/*
+ * APIC command line parameters
+ */
+static int __init parse_lapic(char *arg)
+{
+	force_enable_local_apic = 1;
+	return 0;
+}
+early_param("lapic", parse_lapic);
+/* Local APIC was disabled by the BIOS and enabled by the kernel */
+static int enabled_via_apicbase;
+int pic_mode;
 
+unsigned long mp_lapic_addr;
+int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
@@ -75,8 +86,6 @@ char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
  */
 unsigned int apic_verbosity;
 
-int pic_mode;
-
 /* Have we found an MP table */
 int smp_found_config;
 
@@ -110,9 +119,6 @@ static struct clock_event_device lapic_clockevent = {
 };
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
-/* Local APIC was disabled by the BIOS and enabled by the kernel */
-static int enabled_via_apicbase;
-
 static unsigned long apic_phys;
 
 /*
@@ -1728,15 +1734,6 @@ static void apic_pm_activate(void) { }
 
 #endif	/* CONFIG_PM */
 
-/*
- * APIC command line parameters
- */
-static int __init parse_lapic(char *arg)
-{
-	force_enable_local_apic = 1;
-	return 0;
-}
-early_param("lapic", parse_lapic);
 
 static int __init setup_disableapic(char *arg)
 {
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index cd86085..e021129 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -46,16 +46,31 @@
 #include <mach_ipi.h>
 #include <mach_apic.h>
 
-/* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
-int disable_apic;
-int disable_x2apic;
-int x2apic;
+static __init int setup_apicpmtimer(char *s)
+{
+	apic_calibrate_pmtmr = 1;
+	notsc_setup(NULL);
+	return 0;
+}
+__setup("apicpmtimer", setup_apicpmtimer);
 
+int x2apic;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
+int disable_x2apic;
+static __init int setup_nox2apic(char *str)
+{
+	disable_x2apic = 1;
+	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+	return 0;
+}
+early_param("nox2apic", setup_nox2apic);
 
+unsigned long mp_lapic_addr;
+int disable_apic;
+/* Disable local APIC timer from the kernel commandline or via dmi quirk */
+static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -104,8 +119,6 @@ static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 static unsigned long apic_phys;
 
-unsigned long mp_lapic_addr;
-
 /*
  * Get the LAPIC version
  */
@@ -1752,15 +1765,6 @@ __cpuinit int apic_is_clustered_box(void)
 	return (clusters > 2);
 }
 
-static __init int setup_nox2apic(char *str)
-{
-	disable_x2apic = 1;
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_X2APIC);
-	return 0;
-}
-early_param("nox2apic", setup_nox2apic);
-
-
 /*
  * APIC command line parameters
  */
@@ -1800,14 +1804,6 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
-static __init int setup_apicpmtimer(char *s)
-{
-	apic_calibrate_pmtmr = 1;
-	notsc_setup(NULL);
-	return 0;
-}
-__setup("apicpmtimer", setup_apicpmtimer);
-
 static int __init apic_set_verbosity(char *arg)
 {
 	if (!arg)  {
