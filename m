Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607Ab0AURU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0AURU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929Ab0AURUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:20:44 -0500
Received: from percival.namespace.at ([77.244.242.130]:52025 "EHLO
	percival.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0AURUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:20:43 -0500
From: Christian Hofstaedtler <ch@zeha.at>
To: x86@kernel.org
Cc: hpa@zytor.com, lenb@kernel.org, tglx@linutronix.de,
       linux-acpi@vger.kernel.org, venkatesh.pallipadi@intel.com,
       arjan@infradead.org, bruce.w.allan@intel.com,
       linux-kernel@vger.kernel.org, Christian Hofstaedtler <ch@zeha.at>
Subject: [PATCH 2/2] Default to ACPI reboots on newish X86 hardware
Date: Thu, 21 Jan 2010 18:18:43 +0100
Message-Id: <1264094323-7187-2-git-send-email-ch@zeha.at>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1264094323-7187-1-git-send-email-ch@zeha.at>
References: <alpine.LFD.2.00.1001200007560.4265@localhost.localdomain>
 <1264094323-7187-1-git-send-email-ch@zeha.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer hardware reportedly can no longer successfully reboot using the
keyboard controller, but needs to use ACPI instead.

To not cause problems with older hardware, only hardware with a BIOS
date 2003 or newer is considered for this choice.
Broken BIOSes (no DMI BIOS date, or BIOS date of 0) also get ACPI
reboots, but those will auto fallback to KBD reboots, as ACPI won't get
enabled without acpi=force.
---
 arch/x86/kernel/reboot.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 36f0c86..919453a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -453,10 +453,33 @@ static struct dmi_system_id __initdata reboot_dmi_table_all[] = {
 	{ }
 };
 
+/* See if the Hardware is new enough to support ACPI reboots. */
+static int __init reboot_acpi_likey_supported(void)
+{
+	int year;
+
+	/* No BIOS date? We can safely say "Yes" here, because ACPI-reboot
+	 * will only work when acpi=force was specified, else it falls back
+	 * to KBD-reboots anyway. */
+	if (!dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL)) {
+		return 1;
+	}
+	if (year == 0) {
+		return 1;
+	}
+
+	/* 2003 was decided as the cut-off year. */
+	if (year < 2003) {
+		return 0;
+	}
+	return 1;
+}
+
 /* Decide how we will reboot:
  * - Check the X86_32-only quirks table.
  * - Check the generic quirks table.
- * - Default to old-style Keyboard Controller reboot.
+ * - Check if we could use ACPI-based reboot.
+ * - Fall back to old-style Keyboard Controller reboot.
  */
 static int __init reboot_init(void)
 {
@@ -472,7 +495,12 @@ static int __init reboot_init(void)
 	if (reboot_type != BOOT_UNDECIDED)
 		return 0;
 
-	reboot_type = BOOT_KBD;
+	if (reboot_acpi_likey_supported()) {
+		reboot_type = BOOT_ACPI;
+	} else {
+		printk(KERN_INFO "Selecting old-style reboot for older hardware\n");
+		reboot_type = BOOT_KBD;
+	}
 
 	return 0;
 }
-- 
1.6.4.4

