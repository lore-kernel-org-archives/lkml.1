Return-Path: <linux-kernel-owner+w=401wt.eu-S932977AbYBGTzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbYBGTzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYBGTzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:55:23 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:60705 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471AbYBGTzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:55:21 -0500
Date: Thu, 7 Feb 2008 20:55:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080207195519.GA21772@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 07 Feb 2008 19:48:59.0200 (UTC) FILETIME=[7B398C00:01C869C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This patch was originally in the old ff tree and was intended for .24; but
somehow got lost in the arch merge. Has also shipped with OpenSUSE 10.3.
I think it should go into .25] 

This replaces the old NF3/NF4 reference BIOS timer override quirk with a device 
ID list. We need to ignore the timer override on these systems, but not 
ignore it on NF5 based systems. Previously this was distingushed by checking
for HPET, but a lot of BIOS vendors didn't enable HPET in their pre Vista 
BIOSes.

Replace the old "for all of nvidia" quirk with a quirk containing pci device
ID. I goobled this list together from pci.ids and googling and it may be 
incomplete, but so far I haven't had complaints.

Cc: lenb@kernel.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/early-quirks.c |   43 ++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

Index: linux/arch/x86/kernel/early-quirks.c
===================================================================
--- linux.orig/arch/x86/kernel/early-quirks.c
+++ linux/arch/x86/kernel/early-quirks.c
@@ -60,38 +60,21 @@ static void __init via_bugs(int  num, in
 #endif
 }
 
-#ifdef CONFIG_ACPI
-#ifdef CONFIG_X86_IO_APIC
-
-static int __init nvidia_hpet_check(struct acpi_table_header *header)
-{
-	return 0;
-}
-#endif /* CONFIG_X86_IO_APIC */
-#endif /* CONFIG_ACPI */
-
-static void __init nvidia_bugs(int num, int slot, int func)
+static void __init nvidia_timer(int num, int slot, int func)
 {
 #ifdef CONFIG_ACPI
 #ifdef CONFIG_X86_IO_APIC
 	/*
-	 * All timer overrides on Nvidia are
-	 * wrong unless HPET is enabled.
-	 * Unfortunately that's not true on many Asus boards.
-	 * We don't know yet how to detect this automatically, but
-	 * at least allow a command line override.
+	 * All timer overrides on Nvidia NF3/NF4 are
+	 * wrong.
 	 */
 	if (acpi_use_timer_override)
 		return;
 
-	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
-		acpi_skip_timer_override = 1;
-		printk(KERN_INFO "Nvidia board "
-		       "detected. Ignoring ACPI "
-		       "timer override.\n");
-		printk(KERN_INFO "If you got timer trouble "
-			"try acpi_use_timer_override\n");
-	}
+	acpi_skip_timer_override = 1;
+	printk(KERN_INFO "Pre NForce5 vidia board detected."
+		         "Ignoring ACPI timer override.\n");
+	printk(KERN_INFO "If you have trouble try acpi_use_timer_override\n");
 #endif
 #endif
 	/* RED-PEN skip them on mptables too? */
@@ -121,9 +104,19 @@ struct chipset {
 	void (*f)(int num, int slot, int func);
 };
 
+#define QBRIDGE(vendor, device, func) { \
+	vendor, device, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, \
+	QFLAG_APPLY_ONCE, func }
+
 static struct chipset early_qrk[] __initdata = {
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
+	/* This list should cover at least one PCI ID from each NF3 or NF4
+	   mainboard to handle a bug in their reference BIOS. */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x00e1, nvidia_timer), /* nforce 3 */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x00ed, nvidia_timer), /* nforce 3 */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x003d, nvidia_timer), /* mcp 04 ?? */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4 ? */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x026f, nvidia_timer), /* mcp 51/nf4 ? */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x005c, nvidia_timer), /* ck 804 */
 	{ PCI_VENDOR_ID_VIA, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
