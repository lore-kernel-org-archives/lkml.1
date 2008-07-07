Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYGGUaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYGGUaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbYGGU36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:29:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbYGGU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:29:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Mon, 7 Jul 2008 22:31:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <200807072003.48228.rjw@sisk.pl> <Pine.LNX.4.55.0807072101070.20615@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0807072101070.20615@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072231.57925.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Maciej W. Rozycki wrote:
> On Mon, 7 Jul 2008, Rafael J. Wysocki wrote:
> 
> > Sorry, the patch I posted was _instead_ of your previous patch with the quirk,
> > because that patch didn't work.  I don't know why it didn't work, however, I
> > can only say it didn't work after removing the __i386__ dependency of
> > acpi_dmi_table[].
> 
>  I don't recall seeing a note that my patch was reverted.  I had a careful
> look at yours now and it applies on top of some diagnostic code which
> should never have been applied to the tree in the first place as it was
> not meant to and would also break the majority of systems out there.  I am
> fairly sure this piece of code is the reason my implementation of the
> workaround did not work for you.
> 
> > My patch is on top of the linux-next tree that didn't contain your patch.
> > So, my patch adds a quirk that sets disable_irq0_through_ioapic to 1 (this
> > variable is defined differently in my patch) and uses it to skip the part of
> > check_timer() that breaks my box.
> > 
> > I hope that makes things clear.
> 
>  It does, thanks.  However I insist on getting this issue dealt with the
> way I proposed -- check_timer() is too complicated and too fragile to mess
> with as our history has already shown.  If IRQ0 is not to be routed
> through the I/O APIC, then it should never be registered as an I/O APIC
> interrupt in the first place.
> 
>  I am fairly with the offending change removed my fix will work for you as
> expected as I went through the effort of checking at the run time that
> once activated it makes the kernel correctly avoid the sequence in
> check_timer() that hits your system, so it is only the DMI ID matching
> that could have gone wrong, but your change indicates this is actually not
> the case.

So I'm going to apply the appended combined patch on top of linux-next and
retest.

Thanks,
Rafael

---
 arch/x86/kernel/acpi/boot.c  |   53 ++++++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/io_apic_64.c |    5 ----
 2 files changed, 47 insertions(+), 11 deletions(-)

Index: linux-next/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-next.orig/arch/x86/kernel/acpi/boot.c
+++ linux-next/arch/x86/kernel/acpi/boot.c
@@ -83,6 +83,8 @@ int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
 
+static int disable_irq0_through_ioapic __initdata;
+
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
@@ -990,6 +992,10 @@ void __init mp_override_legacy_irq(u8 bu
 	int pin;
 	struct mp_config_intsrc mp_irq;
 
+	/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
+	if (bus_irq == 0 && disable_irq0_through_ioapic)
+		return;
+
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
@@ -1056,6 +1062,10 @@ void __init mp_config_acpi_legacy_irqs(v
 	for (i = 0; i < 16; i++) {
 		int idx;
 
+		/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
+		if (i == 0 && disable_irq0_through_ioapic)
+			continue;
+
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mp_config_intsrc *irq = mp_irqs + idx;
 
@@ -1363,8 +1373,6 @@ static void __init acpi_process_madt(voi
 	return;
 }
 
-#ifdef __i386__
-
 static int __init disable_acpi_irq(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
@@ -1415,6 +1423,17 @@ static int __init force_acpi_ht(const st
 }
 
 /*
+ * Don't register any I/O APIC entries for the 8254 timer IRQ.
+ */
+static int __init
+dmi_disable_irq0_through_ioapic(const struct dmi_system_id *d)
+{
+	pr_notice("%s detected: disabling IRQ 0 through I/O APIC\n", d->ident);
+	disable_irq0_through_ioapic = 1;
+	return 0;
+}
+
+/*
  * If your system is blacklisted here, but you find that acpi=force
  * works for you, please contact acpi-devel@sourceforge.net
  */
@@ -1581,11 +1600,35 @@ static struct dmi_system_id __initdata a
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
 
-#endif				/* __i386__ */
-
 /*
  * acpi_boot_table_init() and acpi_boot_init()
  *  called from setup_arch(), always.
@@ -1613,9 +1656,7 @@ int __init acpi_boot_table_init(void)
 {
 	int error;
 
-#ifdef __i386__
 	dmi_check_system(acpi_dmi_table);
-#endif
 
 	/*
 	 * If acpi_disabled, bail out
Index: linux-next/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-next.orig/arch/x86/kernel/io_apic_64.c
+++ linux-next/arch/x86/kernel/io_apic_64.c
@@ -1714,11 +1714,6 @@ static inline void __init check_timer(vo
 		apic2 = apic1;
 	}
 
-	replace_pin_at_irq(0, 0, 0, apic1, pin1);
-	apic1 = 0;
-	pin1 = 0;
-	setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
-
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
