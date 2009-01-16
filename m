Return-Path: <linux-kernel-owner+w=401wt.eu-S937785AbZAPWKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937785AbZAPWKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762717AbZAPWJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:09:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZAPWJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:09:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI suspend: Fix compilation warnings in drivers/acpi/sleep.c
Date: Fri, 16 Jan 2009 23:09:14 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901162309.14778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix two compilation warnings in drivers/acpi/sleep.c, one triggered
by unsetting CONFIG_SUSPEND and the other triggered by unsetting
CONFIG_HIBERNATION, by moving some code under the appropriate
#ifdefs .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/sleep.c |    4 +--
 drivers/acpi/sleep.c         |   51 +++++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 27 deletions(-)

Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -90,31 +90,6 @@ void __init acpi_old_suspend_ordering(vo
 	old_suspend_ordering = true;
 }
 
-/*
- * According to the ACPI specification the BIOS should make sure that ACPI is
- * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
- * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
- * on such systems during resume.  Unfortunately that doesn't help in
- * particularly pathological cases in which SCI_EN has to be set directly on
- * resume, although the specification states very clearly that this flag is
- * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
- * cases.
- */
-static bool set_sci_en_on_resume;
-/*
- * The ACPI specification wants us to save NVS memory regions during hibernation
- * and to restore them during the subsequent resume.  However, it is not certain
- * if this mechanism is going to work on all machines, so we allow the user to
- * disable this mechanism using the 'acpi_sleep=s4_nonvs' kernel command line
- * option.
- */
-static bool s4_no_nvs;
-
-void __init acpi_s4_no_nvs(void)
-{
-	s4_no_nvs = true;
-}
-
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
@@ -193,6 +168,18 @@ static void acpi_pm_end(void)
 #endif /* CONFIG_ACPI_SLEEP */
 
 #ifdef CONFIG_SUSPEND
+/*
+ * According to the ACPI specification the BIOS should make sure that ACPI is
+ * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
+ * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
+ * on such systems during resume.  Unfortunately that doesn't help in
+ * particularly pathological cases in which SCI_EN has to be set directly on
+ * resume, although the specification states very clearly that this flag is
+ * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
+ * cases.
+ */
+static bool set_sci_en_on_resume;
+
 extern void do_suspend_lowlevel(void);
 
 static u32 acpi_suspend_states[] = {
@@ -396,6 +383,20 @@ static struct dmi_system_id __initdata a
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
+/*
+ * The ACPI specification wants us to save NVS memory regions during hibernation
+ * and to restore them during the subsequent resume.  However, it is not certain
+ * if this mechanism is going to work on all machines, so we allow the user to
+ * disable this mechanism using the 'acpi_sleep=s4_nonvs' kernel command line
+ * option.
+ */
+static bool s4_no_nvs;
+
+void __init acpi_s4_no_nvs(void)
+{
+	s4_no_nvs = true;
+}
+
 static unsigned long s4_hardware_signature;
 static struct acpi_table_facs *facs;
 static bool nosigcheck;
Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6/arch/x86/kernel/acpi/sleep.c
@@ -156,11 +156,11 @@ static int __init acpi_sleep_setup(char 
 #ifdef CONFIG_HIBERNATION
 		if (strncmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
+		if (strncmp(str, "s4_nonvs", 8) == 0)
+			acpi_s4_no_nvs();
 #endif
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
-		if (strncmp(str, "s4_nonvs", 8) == 0)
-			acpi_s4_no_nvs();
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");

