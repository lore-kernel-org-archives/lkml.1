Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYHXJFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYHXJFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYHXJDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:51456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbYHXJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WEXcvu3qDq/wY8DUXM7KoWhTjIBIIk6rQvaoGPrhNPZQvakn0QXDP8d4eLwzlOdjzl
         XDcszwIS5WhAiyVlYHDoVsBT1dTLno0NGZlTim4pWwC4u4Ns9ge685aJdiv+1g/yF/28
         I/8sWqx448jNNLhODaubiSIvM8kKHgeIRjtRo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 08/18] x86: apic_xx.c order variables
Date: Sun, 24 Aug 2008 02:01:46 -0700
Message-Id: <1219568516-681-9-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |   46 ++++++++++++++++++++++--------------------
 arch/x86/kernel/apic_64.c |   48 ++++++++++++++++++++++++++++++---------------
 2 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 0f52bdd..cbac5ff 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -50,16 +50,37 @@
 # error SPURIOUS_APIC_VECTOR definition error
 #endif
 
-unsigned long mp_lapic_addr;
-
+#ifdef CONFIG_X86_32
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
+#endif
 
+#ifdef CONFIG_X86_64
+static int apic_calibrate_pmtmr __initdata;
+static __init int setup_apicpmtimer(char *s)
+{
+	apic_calibrate_pmtmr = 1;
+	notsc_setup(NULL);
+	return 0;
+}
+__setup("apicpmtimer", setup_apicpmtimer);
+#endif
+
+unsigned long mp_lapic_addr;
+int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
@@ -1742,15 +1763,6 @@ static void apic_pm_activate(void) { }
 
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
@@ -1788,16 +1800,6 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
-#ifdef CONFIG_X86_64
-static __init int setup_apicpmtimer(char *s)
-{
-	apic_calibrate_pmtmr = 1;
-	notsc_setup(NULL);
-	return 0;
-}
-__setup("apicpmtimer", setup_apicpmtimer);
-#endif
-
 static int __init apic_set_verbosity(char *arg)
 {
 	if (!arg)  {
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 2e10911..c40a900 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -53,16 +53,44 @@
 # error SPURIOUS_APIC_VECTOR definition error
 #endif
 
-/* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
+#ifdef CONFIG_X86_32
+/*
+ * Knob to control our willingness to enable the local APIC.
+ *
+ * +1=force-enable
+ */
+static int force_enable_local_apic;
+/*
+ * APIC command line parameters
+ */
+static int __init parse_lapic(char *arg)
+{
+	force_enable_local_apic = 1;
+	return 0;
+}
+early_param("lapic", parse_lapic);
+#endif
+
+#ifdef CONFIG_X86_64
 static int apic_calibrate_pmtmr __initdata;
-int disable_apic;
+static __init int setup_apicpmtimer(char *s)
+{
+	apic_calibrate_pmtmr = 1;
+	notsc_setup(NULL);
+	return 0;
+}
+__setup("apicpmtimer", setup_apicpmtimer);
+#endif
+
 int disable_x2apic;
 int x2apic;
-
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 
+unsigned long mp_lapic_addr;
+int disable_apic;
+/* Disable local APIC timer from the kernel commandline or via dmi quirk */
+static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -113,8 +141,6 @@ static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 static unsigned long apic_phys;
 
-unsigned long mp_lapic_addr;
-
 /*
  * Get the LAPIC version
  */
@@ -1858,16 +1884,6 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
-#ifdef CONFIG_X86_64
-static __init int setup_apicpmtimer(char *s)
-{
-	apic_calibrate_pmtmr = 1;
-	notsc_setup(NULL);
-	return 0;
-}
-__setup("apicpmtimer", setup_apicpmtimer);
-#endif
-
 static int __init apic_set_verbosity(char *arg)
 {
 	if (!arg)  {
-- 
1.5.4.5

