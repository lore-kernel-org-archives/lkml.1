Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbYG0Vs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbYG0Vs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 17:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbYG0Vss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 17:48:48 -0400
Received: from www.tglx.de ([62.245.132.106]:33641 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757727AbYG0Vss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 17:48:48 -0400
Date: Sun, 27 Jul 2008 23:47:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
Message-ID: <alpine.LFD.1.10.0807272343480.574@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_idle_save resp. pm_idle_old can be NULL when the restore code in 
acpi_processor_cst_has_changed() resp. cpuidle_uninstall_idle_handler()
is called. This can set pm_idle unconditinally to NULL, which causes the
kernel to panic when calling pm_idle in the x86 idle code. This was
covered by an extra check for !pm_idle in the x86 idle code, which was
removed during the x86 idle code refactoring.

Instead of restoring the pm_idle check in the x86 code prevent the
acpi/cpuidle code to set pm_idle to NULL.

Reported by: Dhaval Giani http://lkml.org/lkml/2008/7/2/309
Based on a debug patch from Ingo Molnar

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b7f2963..283c08f 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1332,9 +1332,15 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 	if (!pr->flags.power_setup_done)
 		return -ENODEV;
 
-	/* Fall back to the default idle loop */
-	pm_idle = pm_idle_save;
-	synchronize_sched();	/* Relies on interrupts forcing exit from idle. */
+	/*
+	 * Fall back to the default idle loop, when pm_idle_save had
+	 * been initialized.
+	 */
+	if (pm_idle_save) {
+		pm_idle = pm_idle_save;
+		/* Relies on interrupts forcing exit from idle. */
+		synchronize_sched();
+	}
 
 	pr->flags.power = 0;
 	result = acpi_processor_get_power_info(pr);
@@ -1896,7 +1902,8 @@ int acpi_processor_power_exit(struct acpi_processor *pr,
 
 	/* Unregister the idle handler when processor #0 is removed. */
 	if (pr->id == 0) {
-		pm_idle = pm_idle_save;
+		if (pm_idle_save)
+			pm_idle = pm_idle_save;
 
 		/*
 		 * We are about to unload the current idle thread pm callback
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5405769..5ce07b5 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -94,7 +94,7 @@ void cpuidle_install_idle_handler(void)
  */
 void cpuidle_uninstall_idle_handler(void)
 {
-	if (enabled_devices && (pm_idle != pm_idle_old)) {
+	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
 		pm_idle = pm_idle_old;
 		cpuidle_kick_cpus();
 	}
