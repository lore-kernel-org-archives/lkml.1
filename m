Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYGGBST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYGGBST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 21:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbYGGBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 21:18:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56972 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbYGGBSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 21:18:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Mon, 7 Jul 2008 03:19:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <20080701202453.GD4896@elte.hu> <200807070102.38854.rjw@sisk.pl>
In-Reply-To: <200807070102.38854.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807070319.29470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Rafael J. Wysocki wrote:
> On Tuesday, 1 of July 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Tuesday, 1 of July 2008, Ingo Molnar wrote:
> > > > 
> > > > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > > 
> > > > > Assuming it works for Rafael (still haven't had time to pull my nx6125 
> > > > > out of storage):
> > > > > 
> > > > > Signed-off-by: mjg@redhat.com
> > > > 
> > > > Rafael, could you please try the latest tip/master that i've just pushed 
> > > > out:
> > > > 
> > > >   http://people.redhat.com/mingo/tip.git/README
> > > > 
> > > > it has the final form of these changes integrated - it should in 
> > > > theory work out of box on your system, with no boot parameters or 
> > > > other explicit quirks needed anywhere.
> > > 
> > > I tested patches [1/2] (your version) and [2/2] on top of today's 
> > > linux-next and they work just fine.
> > 
> > thanks Rafael!
> 
> Well, I'm afraid that my information wasn't correct.  The patches actually
> don't work, but I had my own additional patch that fixed the problem applied,
> which I've only just discovered.  Sorry for the confusion and the issue is
> still unfixed.

Appended is a patch that actually works for me (it's missing the i386 part,
but I can't test that anyway).

Please note two things:
(1) The whole acpi_dmi_table[] thing originally depended on __i386__, so it
    wouldn't work on x86-64 no matter what.  I removed that dependecy, but
    I have no idea why it was there and so I'm not sure if that's correct. 
(2) The clear_IO_APIC_pin(apic1, pin1) done if disable_irq0_through_ioapic is
    true is absolutely essential.  The symptoms are 100% reproducible without it.

Thanks,
Rafael


---
 arch/x86/kernel/acpi/boot.c  |   43 +++++++++++++++++++++++++++++++++++++------
 arch/x86/kernel/io_apic_64.c |   19 ++++++++++++++-----
 2 files changed, 51 insertions(+), 11 deletions(-)

Index: linux-next/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-next.orig/arch/x86/kernel/acpi/boot.c
+++ linux-next/arch/x86/kernel/acpi/boot.c
@@ -1363,8 +1363,6 @@ static void __init acpi_process_madt(voi
 	return;
 }
 
-#ifdef __i386__
-
 static int __init disable_acpi_irq(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
@@ -1415,6 +1413,17 @@ static int __init force_acpi_ht(const st
 }
 
 /*
+ * Don't register any I/O APIC entries for the 8254 timer IRQ.
+ */
+static int __init
+dmi_disable_irq0_through_ioapic(const struct dmi_system_id *d)
+{
+	pr_notice("%s detected: disabling IRQ 0 through I/O APIC\n", d->ident);
+	force_disable_irq0_through_ioapic();
+	return 0;
+}
+
+/*
  * If your system is blacklisted here, but you find that acpi=force
  * works for you, please contact acpi-devel@sourceforge.net
  */
@@ -1581,11 +1590,35 @@ static struct dmi_system_id __initdata a
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
@@ -1613,9 +1646,7 @@ int __init acpi_boot_table_init(void)
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
@@ -94,6 +94,13 @@ static int no_timer_check;
 
 static int disable_timer_pin_1 __initdata;
 
+static bool disable_irq0_through_ioapic __initdata;
+
+void __init force_disable_irq0_through_ioapic(void)
+{
+	disable_irq0_through_ioapic = true;
+}
+
 int timer_through_8259 __initdata;
 
 /* Where if anywhere is the i8259 connect in external int mode */
@@ -1714,12 +1721,14 @@ static inline void __init check_timer(vo
 		apic2 = apic1;
 	}
 
-	replace_pin_at_irq(0, 0, 0, apic1, pin1);
-	apic1 = 0;
-	pin1 = 0;
-	setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
+	if (disable_irq0_through_ioapic) {
+		clear_IO_APIC_pin(apic1, pin1);
+	} else {
+		replace_pin_at_irq(0, 0, 0, apic1, pin1);
+		apic1 = 0;
+		pin1 = 0;
+		setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 
-	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
