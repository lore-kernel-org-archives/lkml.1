Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbYGAANi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbYGAANi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbYGAANO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:13:14 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62159 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753696AbYGAANM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:13:12 -0400
Date: Tue, 1 Jul 2008 01:12:06 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Message-ID: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>

 Some HP laptops have a problem with their DSDT reporting as
HP/SB400/10000, which includes some code which overrides all temperature
trip points to 16C if the INTIN2 input of the I/O APIC is enabled.  This
input is incorrectly designated the ISA IRQ 0 via an interrupt source
override even though it is wired to the output of the master 8259A and
INTIN0 is not connected at all.  So far two models have been identified, 
namely nx6125 and nx6325.

 Use a knob provided by the I/O APIC interrupt registration code to
abandon any attempts to route IRQ 0 through the I/O APIC for these
systems.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
Hello,

 Matthew, you have not added your sign-off with the original patch, please 
do so now.

 Rafael, please try this change together with 
patch-2.6.26-rc1-20080505-mpparse-acpi-noirq0-2 and see if this fixes your 
system.

 I have tried the patches with a wildcard entry added to acpi_dmi_table[]
so that it trips for my system.  The result is as follows:

ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=-1 pin1=-1 apic2=-1 pin2=-1
...trying to set up timer as Virtual Wire IRQ... works.

(note the absence of any timer pin), which means the changes work as
expected.  Here the timer has been set up as a native local APIC interrupt
routed through the 8259A set up as a "virtual wire".

 Ingo, please apply the two patches where appropriate.

  Maciej

patch-2.6.26-rc1-20080505-mjg59-acpi-noirq0-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/acpi/boot.c linux-2.6.26-rc1-20080505/arch/x86/kernel/acpi/boot.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/acpi/boot.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/acpi/boot.c	2008-06-30 23:31:48.000000000 +0000
@@ -1049,6 +1049,17 @@ static int __init force_acpi_ht(const st
 }
 
 /*
+ * Don't register any I/O APIC entries for the 8254 timer IRQ.
+ */
+static int __init
+dmi_disable_irq0_through_ioapic(const struct dmi_system_id *d)
+{
+	pr_notice("%s detected: disabling IRQ 0 through I/O APIC\n", d->ident);
+	set_disable_irq0_through_ioapic(1);
+	return 0;
+}
+
+/*
  * If your system is blacklisted here, but you find that acpi=force
  * works for you, please contact acpi-devel@sourceforge.net
  */
@@ -1215,6 +1226,32 @@ static struct dmi_system_id __initdata a
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	/*
+	 * HP laptops which use a DSDT reporting as HP/SB400/10000,
+	 * which includes some code which overrides all temperature
+	 * trip points to 16C if the INTIN2 input of the I/O APIC
+	 * is enabled.  This input is incorrectly designated the
+	 * ISA IRQ 0 via an interrupt source override even though
+	 * it is wired to the output of the master 8259A and INTIN0
+	 * is not connected at all.  Abandon any attempts to route
+	 * IRQ 0 through the I/O APIC therefore.
+	 */
+	{
+	 .callback = dmi_disable_irq0_through_ioapic,
+	 .ident = "HP NX6125 laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6125"),
+		     },
+	 },
+	{
+	 .callback = dmi_disable_irq0_through_ioapic,
+	 .ident = "HP NX6325 laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+		     },
+	 },
 	{}
 };
 
