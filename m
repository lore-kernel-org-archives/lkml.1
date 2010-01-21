Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504Ab0AURUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab0AURUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837Ab0AURUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:20:43 -0500
Received: from percival.namespace.at ([77.244.242.130]:52024 "EHLO
	percival.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab0AURUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:20:42 -0500
From: Christian Hofstaedtler <ch@zeha.at>
To: x86@kernel.org
Cc: hpa@zytor.com, lenb@kernel.org, tglx@linutronix.de,
       linux-acpi@vger.kernel.org, venkatesh.pallipadi@intel.com,
       arjan@infradead.org, bruce.w.allan@intel.com,
       linux-kernel@vger.kernel.org, Christian Hofstaedtler <ch@zeha.at>
Subject: [PATCH 1/2] x86: Unify reboot_type selection
Date: Thu, 21 Jan 2010 18:18:42 +0100
Message-Id: <1264094323-7187-1-git-send-email-ch@zeha.at>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <alpine.LFD.2.00.1001200007560.4265@localhost.localdomain>
References: <alpine.LFD.2.00.1001200007560.4265@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify x86_32-only and x86_32+x86_64 reboot quirks selection functions,
so the code path is a bit easier to understand and gets a predefined
execution order.

Signed-off-by: Christian Hofstaedtler <ch@zeha.at>
---
 arch/x86/include/asm/emergency-restart.h |    1 +
 arch/x86/kernel/reboot.c                 |   43 +++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/emergency-restart.h b/arch/x86/include/asm/emergency-restart.h
index cc70c1c..72ee23a 100644
--- a/arch/x86/include/asm/emergency-restart.h
+++ b/arch/x86/include/asm/emergency-restart.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_EMERGENCY_RESTART_H
 
 enum reboot_type {
+	BOOT_UNDECIDED = '?',
 	BOOT_TRIPLE = 't',
 	BOOT_KBD = 'k',
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1545bc0..36f0c86 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_UNDECIDED;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
@@ -134,7 +134,11 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
-static struct dmi_system_id __initdata reboot_dmi_table[] = {
+/*
+ * This table only gets used on x86_32, so only use with
+ * set_bios_reboot.
+ */
+static struct dmi_system_id __initdata reboot_dmi_table_x86_32[] = {
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
 		.ident = "Dell E520",
@@ -270,13 +274,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	{ }
 };
 
-static int __init reboot_init(void)
-{
-	dmi_check_system(reboot_dmi_table);
-	return 0;
-}
-core_initcall(reboot_init);
-
 /* The following code and data reboots the machine by switching to real
    mode and jumping to the BIOS reset entry point, as if the CPU has
    really been reset.  The previous version asked the keyboard
@@ -427,7 +424,8 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
-static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
+/* This table gets used on x86_32 AND x86_64. */
+static struct dmi_system_id __initdata reboot_dmi_table_all[] = {
 	{	/* Handle problems with rebooting on Apple MacBook5 */
 		.callback = set_pci_reboot,
 		.ident = "Apple MacBook5",
@@ -455,12 +453,30 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 	{ }
 };
 
-static int __init pci_reboot_init(void)
+/* Decide how we will reboot:
+ * - Check the X86_32-only quirks table.
+ * - Check the generic quirks table.
+ * - Default to old-style Keyboard Controller reboot.
+ */
+static int __init reboot_init(void)
 {
-	dmi_check_system(pci_reboot_dmi_table);
+	/* don't override user decisions (reboot=...) */
+	if (reboot_type != BOOT_UNDECIDED)
+		return 0;
+
+#ifdef CONFIG_X86_32
+	dmi_check_system(reboot_dmi_table_x86_32);
+#endif /* CONFIG_X86_32 */
+	dmi_check_system(reboot_dmi_table_all);
+
+	if (reboot_type != BOOT_UNDECIDED)
+		return 0;
+
+	reboot_type = BOOT_KBD;
+
 	return 0;
 }
-core_initcall(pci_reboot_init);
+core_initcall(reboot_init);
 
 static inline void kb_wait(void)
 {
@@ -534,6 +550,7 @@ static void native_machine_emergency_restart(void)
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
+		case BOOT_UNDECIDED:
 		case BOOT_KBD:
 			mach_reboot_fixups(); /* for board specific fixups */
 
-- 
1.6.4.4

