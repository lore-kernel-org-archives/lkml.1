Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYGHWrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYGHWrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYGHWr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:47:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41992 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYGHWr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:47:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for July 8: nx6325-related commits
Date: Wed, 9 Jul 2008 00:48:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <20080708192251.3275d283.sfr@canb.auug.org.au>
In-Reply-To: <20080708192251.3275d283.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807090048.48589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tuesday, 8 of July 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080704:
> 
> Temporarily dropped tree: ttydev (since it would not import on top of any
> tree I have)
> 
> The usb.current gained a white space conflict against Linus' tree (which I
> assume will be gone as soon as Greg rebases his tree).
> 
> The usb tree gained a conflict against Linus' tree.
> 
> The tip-core tree gained a conflict against Linus' tree.
> 
> The sched tree lost a build fix patch.
> 
> The x86 tree lost a conflict against Linus' tree but gained two against
> the ftrace tree.

Commits 0b3d81ad4f765513347a04434efc15cbdc4e1c54
("x86, ioapic, acpi: add a knob to disable IRQ 0 through I/O APIC") and
e38502eb8aa82314d5ab0eba45f50e6790dadd88
("x86, ioapic, acpi quirk: disable IRQ 0 through I/O APIC for some HP systems")
don't work on x86_64, because acpi_dmi_table[] depends on __i386__.

Moreover, if you make them work (by removing that dependency), they hang my
nx6325 solid early during boot.

The revert patch is appended for your convenience. ;-)

Thanks,
Rafael

---
 arch/x86/kernel/acpi/boot.c |   47 --------------------------------------------
 1 file changed, 47 deletions(-)

Index: linux-next/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-next.orig/arch/x86/kernel/acpi/boot.c
+++ linux-next/arch/x86/kernel/acpi/boot.c
@@ -83,8 +83,6 @@ int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
 
-static int disable_irq0_through_ioapic __initdata;
-
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
@@ -996,10 +994,6 @@ mp_override_legacy_irq(u8 bus_irq, u8 po
 	int pin;
 	struct mp_config_intsrc mp_irq;
 
-	/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
-	if (bus_irq == 0 && disable_irq0_through_ioapic)
-		return;
-
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
@@ -1066,10 +1060,6 @@ static void __init mp_config_acpi_legacy
 	for (i = 0; i < 16; i++) {
 		int idx;
 
-		/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
-		if (i == 0 && disable_irq0_through_ioapic)
-			continue;
-
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mp_config_intsrc *irq = mp_irqs + idx;
 
@@ -1429,17 +1419,6 @@ static int __init force_acpi_ht(const st
 }
 
 /*
- * Don't register any I/O APIC entries for the 8254 timer IRQ.
- */
-static int __init
-dmi_disable_irq0_through_ioapic(const struct dmi_system_id *d)
-{
-	pr_notice("%s detected: disabling IRQ 0 through I/O APIC\n", d->ident);
-	disable_irq0_through_ioapic = 1;
-	return 0;
-}
-
-/*
  * If your system is blacklisted here, but you find that acpi=force
  * works for you, please contact acpi-devel@sourceforge.net
  */
@@ -1606,32 +1585,6 @@ static struct dmi_system_id __initdata a
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
-	/*
-	 * HP laptops which use a DSDT reporting as HP/SB400/10000,
-	 * which includes some code which overrides all temperature
-	 * trip points to 16C if the INTIN2 input of the I/O APIC
-	 * is enabled.  This input is incorrectly designated the
-	 * ISA IRQ 0 via an interrupt source override even though
-	 * it is wired to the output of the master 8259A and INTIN0
-	 * is not connected at all.  Abandon any attempts to route
-	 * IRQ 0 through the I/O APIC therefore.
-	 */
-	{
-	 .callback = dmi_disable_irq0_through_ioapic,
-	 .ident = "HP NX6125 laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6125"),
-		     },
-	 },
-	{
-	 .callback = dmi_disable_irq0_through_ioapic,
-	 .ident = "HP NX6325 laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
-		     },
-	 },
 	{}
 };
 
