Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbXIUUrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbXIUUrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762825AbXIUUou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:50 -0400
Received: from ns.suse.de ([195.135.220.2]:50015 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762789AbXIUUot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:49 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/45] x86_64: Replace nvidia timer override quirk with pci id list and unify quirks
Message-Id: <20070921204448.5E0EB14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This replaces the old NF3/NF4 reference BIOS timer override quirk with a device 
ID list. We need to ignore the timer override on these systems, but not 
ignore it on NF5 based systems. Previously this was distingushed by checking
for HPET, but a lot of BIOS vendors didn't enable HPET in their pre Vista BIOSes.
Replace the old "for all of nvidia" quirk with a quirk containing pci device
ID. I goobled this list together from pci.ids and googling and it may be incomplete.

I'm still not 100% sure the list is correct, but the only way
to find out is to do testing in mainline. So let's do that.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/early-quirks.c |   50 ++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

Index: linux/arch/x86_64/kernel/early-quirks.c
===================================================================
--- linux.orig/arch/x86_64/kernel/early-quirks.c
+++ linux/arch/x86_64/kernel/early-quirks.c
@@ -33,36 +33,20 @@ static void __init via_bugs(void)
 #endif
 }
 
-#ifdef CONFIG_ACPI
-
-static int __init nvidia_hpet_check(struct acpi_table_header *header)
-{
-	return 0;
-}
-#endif
-
 static void __init nvidia_bugs(void)
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
+	printk(KERN_INFO "Nvidia board detected. Ignoring ACPI timer override.\n");
+	printk(KERN_INFO "If you got timer trouble try acpi_use_timer_override\n");
 #endif
 #endif
 	/* RED-PEN skip them on mptables too? */
@@ -83,10 +67,19 @@ static void __init ati_bugs(void)
 struct chipset {
 	u16 vendor;
 	void (*f)(void);
+	int id;
 };
 
 static struct chipset early_qrk[] __initdata = {
-	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
+	/* This list should cover at least one PCI ID from each NF3 or NF4
+	   mainboard to handle a bug in their reference BIOS. May be incomplete. */
+	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs, 0x00dd },	/* nforce 3 */
+	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs, 0x00e1 },	/* nforce 3 */
+	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs, 0x00ed },	/* nforce 3 */
+	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs, 0x003d },	/* mcp 04 ?? */
+	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs, 0x005c },	/* ck 804 */
+	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs, 0x026f },	/* mcp 51 / nf4 ? */
+	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs, 0x02f0 },	/* mcp 51 / nf4 ? */
 	{ PCI_VENDOR_ID_VIA, via_bugs },
 	{ PCI_VENDOR_ID_ATI, ati_bugs },
 	{}
@@ -99,12 +92,13 @@ void __init early_quirks(void)
 	if (!early_pci_allowed())
 		return;
 
-	/* Poor man's PCI discovery */
+	/* Poor man's PCI discovery.
+	   We just look for a chipset unique PCI bridge; not scan all devices */
 	for (num = 0; num < 32; num++) {
 		for (slot = 0; slot < 32; slot++) {
 			for (func = 0; func < 8; func++) {
 				u32 class;
-				u32 vendor;
+				u32 vendor, device;
 				u8 type;
 				int i;
 				class = read_pci_config(num,slot,func,
@@ -117,13 +111,17 @@ void __init early_quirks(void)
 
 				vendor = read_pci_config(num, slot, func,
 							 PCI_VENDOR_ID);
+				device = vendor >> 16;
+
 				vendor &= 0xffff;
 
-				for (i = 0; early_qrk[i].f; i++)
-					if (early_qrk[i].vendor == vendor) {
+				for (i = 0; early_qrk[i].f; i++) {
+					struct chipset *c = &early_qrk[i];
+					if (c->vendor == vendor && (!c->id || (c->id && c->id==device))) {
 						early_qrk[i].f();
 						return;
 					}
+				}
 
 				type = read_pci_config_byte(num, slot, func,
 							    PCI_HEADER_TYPE);
