Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYGAI2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYGAI2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYGAI2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:28:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48744 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbYGAI2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:28:10 -0400
Date: Tue, 1 Jul 2008 10:27:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mpparse: Add a knob to disable IRQ 0 through I/O
	APIC
Message-ID: <20080701082742.GA31725@elte.hu>
References: <Pine.LNX.4.55.0807010041030.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807010041030.30785@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  As discovered recently some systems exhibit problems when the 8254 
> timer IRQ is routed through the I/O APIC.  These problems do not 
> affect the timer IRQ itself and therefore cannot be detected when the 
> correctness of operation of the interrupt is verified in 
> check_timer().  Therefore the I/O APIC path of the timer IRQ has to be 
> disabled entirely.
> 
>  This is a change that lets platforms ask for the timer IRQ not to be 
> registered in the I/O APIC interrupt tables.  The local APIC and 
> ExtINTA paths are unaffected.  This request is only taken into account 
> for ACPI platforms as MP table systems seem unaffected so far.

applied to tip/x86/mpparse - thanks Maciej.

Note, since mp_config_acpi_legacy_irqs moved to acpi/boot.c i 
restructured and simplified it slightly - please double-check the form 
below.

	Ingo

--------------->
commit e38502eb8aa82314d5ab0eba45f50e6790dadd88
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Jul 1 01:12:06 2008 +0100

    x86, ioapic, acpi quirk: disable IRQ 0 through I/O APIC for some HP systems
    
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
    Cc: Len Brown <lenb@kernel.org>
    Cc: Matthew Garrett <mjg59@srcf.ucam.org>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 92a5426..9908ef4 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1427,6 +1427,17 @@ static int __init force_acpi_ht(const struct dmi_system_id *d)
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
@@ -1593,6 +1604,32 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
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
 

commit 0b3d81ad4f765513347a04434efc15cbdc4e1c54
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Tue Jul 1 01:11:35 2008 +0100

    x86, ioapic, acpi: add a knob to disable IRQ 0 through I/O APIC
    
    As discovered recently some systems exhibit problems when the 8254 timer
    IRQ is routed through the I/O APIC.  These problems do not affect the
    timer IRQ itself and therefore cannot be detected when the correctness of
    operation of the interrupt is verified in check_timer().  Therefore the
    I/O APIC path of the timer IRQ has to be disabled entirely.
    
    This is a change that lets platforms ask for the timer IRQ not to be
    registered in the I/O APIC interrupt tables.  The local APIC and ExtINTA
    paths are unaffected.  This request is only taken into account for ACPI
    platforms as MP table systems seem unaffected so far.
    
    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Cc: Len Brown <lenb@kernel.org>
    Cc: Matthew Garrett <mjg59@srcf.ucam.org>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 91bb9a9..92a5426 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -83,6 +83,8 @@ int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
 
+static int disable_irq0_through_ioapic __initdata;
+
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
@@ -992,6 +994,10 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	int pin;
 	struct mp_config_intsrc mp_irq;
 
+	/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
+	if (bus_irq == 0 && disable_irq0_through_ioapic)
+		return;
+
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
@@ -1058,6 +1064,10 @@ void __init mp_config_acpi_legacy_irqs(void)
 	for (i = 0; i < 16; i++) {
 		int idx;
 
+		/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
+		if (i == 0 && disable_irq0_through_ioapic)
+			continue;
+
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mp_config_intsrc *irq = mp_irqs + idx;
 
