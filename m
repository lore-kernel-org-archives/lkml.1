Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYGLAsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYGLAsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 20:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYGLAsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 20:48:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYGLAsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 20:48:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: today's linux-next fails to boot
Date: Sat, 12 Jul 2008 02:50:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <4877400B.1000400@gmail.com> <20080711190749.GB21758@elte.hu> <200807112306.39455.rjw@sisk.pl>
In-Reply-To: <200807112306.39455.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807120250.16459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Friday, 11 of July 2008, Rafael J. Wysocki wrote:
> On Friday, 11 of July 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
[--snip--]
> 
> Well, it turns out that linux-next from today doesn't boot on my box too
> (64-bit) and I don't see anything obviously suspicious.  Bisection time.

I have identified the source of the breakage on my box, but I don't really
think it's the same problem that Edwin is observing.

Namely, it turns out that some code in arch/x86/kernel/acpi/boot.c, as in
today's linux-next, doesn't really make sense, because we have two conflicting
DMA-based quirks in there for the same set of boxes (HP nx6325 and nx6125) and
one of them actually breaks my box.

I have reported that already, but it probably got lost somewhere.

Below is a patch that fixes things for me, on top of today's linux-next.
Please apply.

Thanks,
Rafael

---
Remove some code that breaks my HP nx6325 from arch/x86/kernel/acpi/boot.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/boot.c |   47 --------------------------------------------
 1 file changed, 47 deletions(-)

Index: linux-next/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-next.orig/arch/x86/kernel/acpi/boot.c
+++ linux-next/arch/x86/kernel/acpi/boot.c
@@ -84,8 +84,6 @@ int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
 
-static int disable_irq0_through_ioapic __initdata;
-
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
@@ -982,10 +980,6 @@ void __init mp_override_legacy_irq(u8 bu
 	int pin;
 	struct mp_config_intsrc mp_irq;
 
-	/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
-	if (bus_irq == 0 && disable_irq0_through_ioapic)
-		return;
-
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
@@ -1052,10 +1046,6 @@ void __init mp_config_acpi_legacy_irqs(v
 	for (i = 0; i < 16; i++) {
 		int idx;
 
-		/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
-		if (i == 0 && disable_irq0_through_ioapic)
-			continue;
-
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mp_config_intsrc *irq = mp_irqs + idx;
 
@@ -1413,17 +1403,6 @@ static int __init force_acpi_ht(const st
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
  * Force ignoring BIOS IRQ0 pin2 override
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
@@ -1608,32 +1587,6 @@ static struct dmi_system_id __initdata a
 	 * is enabled.  This input is incorrectly designated the
 	 * ISA IRQ 0 via an interrupt source override even though
 	 * it is wired to the output of the master 8259A and INTIN0
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
-	/*
-	 * HP laptops which use a DSDT reporting as HP/SB400/10000,
-	 * which includes some code which overrides all temperature
-	 * trip points to 16C if the INTIN2 input of the I/O APIC
-	 * is enabled.  This input is incorrectly designated the
-	 * ISA IRQ 0 via an interrupt source override even though
-	 * it is wired to the output of the master 8259A and INTIN0
 	 * is not connected at all.  Force ignoring BIOS IRQ0 pin2
 	 * override in that cases.
 	 */
