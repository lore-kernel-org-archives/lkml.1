Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab0BAOyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:54:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57087 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0BAOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:54:23 -0500
Date: Mon, 1 Feb 2010 14:54:13 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "flinco@libero.it" <flinco@libero.it>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: [PATCH] ACPI: Remove old blacklist entries
Message-ID: <20100201145413.GA6310@srcf.ucam.org>
References: <5550914.425471263201351807.JavaMail.defaultUser@defaultHost> <201001112040.45514.rjw@sisk.pl> <20100126155330.GA4231@rainbow> <20100127113520.596bd07c@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127113520.596bd07c@feng-i7>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:35:20AM +0800, Feng Tang wrote:

> Which only enforces the "acpi_disabled" check and should have no
> logical problem.
> 
> And I guess your platform is blacklisted and acpi_disabled is set to 1,
> while it still need parse ACPI tables to get SMP info. So I would suggest
> to add a "acpi=force" for your case.

It's actually set to force_ht, so it sounds like some blacklisting is 
now stricter than it used to be. However, given that acpi=force seems to 
work, how about just doing the following?

commit a8d9241dad684f7dda46889f00c9e627773e868e
Author: Matthew Garrett <mjg@redhat.com>
Date:   Mon Feb 1 09:51:44 2010 -0500

    ACPI: Remove old blacklist entries
    
    The kernel has a set of blacklist entries that disable ACPI functionality
    on various machines. These all seem to date from pre-git days and most
    have no indication of what they were meant to fix. Let's work on the
    assumption that we've fixed whatever it was that was broken before and so
    remove most of the entries.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index fb1035c..086f0b6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1256,35 +1256,6 @@ static int __init disable_acpi_pci(const struct dmi_system_id *d)
 	return 0;
 }
 
-static int __init dmi_disable_acpi(const struct dmi_system_id *d)
-{
-	if (!acpi_force) {
-		printk(KERN_NOTICE "%s detected: acpi off\n", d->ident);
-		disable_acpi();
-	} else {
-		printk(KERN_NOTICE
-		       "Warning: DMI blacklist says broken, but acpi forced\n");
-	}
-	return 0;
-}
-
-/*
- * Limit ACPI to CPU enumeration for HT
- */
-static int __init force_acpi_ht(const struct dmi_system_id *d)
-{
-	if (!acpi_force) {
-		printk(KERN_NOTICE "%s detected: force use of acpi=ht\n",
-		       d->ident);
-		disable_acpi();
-		acpi_ht = 1;
-	} else {
-		printk(KERN_NOTICE
-		       "Warning: acpi=force overrules DMI blacklist: acpi=ht\n");
-	}
-	return 0;
-}
-
 /*
  * Force ignoring BIOS IRQ0 pin2 override
  */
@@ -1308,116 +1279,6 @@ static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
  * works for you, please contact linux-acpi@vger.kernel.org
  */
 static struct dmi_system_id __initdata acpi_dmi_table[] = {
-	/*
-	 * Boxes that need ACPI disabled
-	 */
-	{
-	 .callback = dmi_disable_acpi,
-	 .ident = "IBM Thinkpad",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "2629H1G"),
-		     },
-	 },
-
-	/*
-	 * Boxes that need acpi=ht
-	 */
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "FSC Primergy T850",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "PRIMERGY T850"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "HP VISUALIZE NT Workstation",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP VISUALIZE NT Workstation"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "Compaq Workstation W8000",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "Workstation W8000"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "ASUS P2B-DS",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		     DMI_MATCH(DMI_BOARD_NAME, "P2B-DS"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "ASUS CUR-DLS",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		     DMI_MATCH(DMI_BOARD_NAME, "CUR-DLS"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "ABIT i440BX-W83977",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ABIT <http://www.abit.com>"),
-		     DMI_MATCH(DMI_BOARD_NAME, "i440BX-W83977 (BP6)"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM Bladecenter",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "IBM eServer BladeCenter HS20"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM eServer xSeries 360",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "eServer xSeries 360"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM eserver xSeries 330",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "eserver xSeries 330"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM eserver xSeries 440",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "eserver xSeries 440"),
-		     },
-	 },
-
-	/*
-	 * Boxes that need ACPI PCI IRQ routing disabled
-	 */
-	{
-	 .callback = disable_acpi_irq,
-	 .ident = "ASUS A7V",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC"),
-		     DMI_MATCH(DMI_BOARD_NAME, "<A7V>"),
-		     /* newer BIOS, Revision 1011, does work */
-		     DMI_MATCH(DMI_BIOS_VERSION,
-			       "ASUS A7V ACPI BIOS Revision 1007"),
-		     },
-	 },
 	{
 		/*
 		 * Latest BIOS for IBM 600E (1.16) has bad pcinum
@@ -1454,14 +1315,6 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
 		     DMI_MATCH(DMI_BIOS_DATE, "03/21/2003")
 		     },
 	 },
-	{
-	 .callback = disable_acpi_pci,
-	 .ident = "Acer TravelMate 36x Laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
-		     },
-	 },
 	{}
 };
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
