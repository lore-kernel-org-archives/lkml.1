Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYJPK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYJPK5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYJPK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:57:46 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21100 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYJPK5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:57:45 -0400
X-BigFish: VPS-4(zz4015Mzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8TVRV-02-9PK-01
Date: Thu, 16 Oct 2008 12:57:06 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove superfluous dmi_ignore_irq0_timer_override
	quirks
Message-ID: <20081016105706.GC29183@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Oct 2008 10:57:31.0953 (UTC) FILETIME=[FD0ACA10:01C92F7D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem should be solved with commits:

x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC

IMHO it does not make sense to check within a dmi-quirk
whether an early-quirk was applied. Boot sequence is as follows:

acpi_boot_table_init()   (it applies dmi-quirks)
...
early_quirks()           (detect bogus IRQ0 override)
...
acpi_boot_init()         (setup IO APIC)

Thus with current code we will always get following warnings for
Laptops that have this dmi_ignore_irq0_timer_override dmi quirk:

  WARNING: at arch/x86/kernel/acpi/boot.c:1410
  dmi_ignore_irq0_timer_override+0x30/0x60()
  ati_ixp4x0 quirk not complete.

... just because the early-quirk (ati_ixp4x0) was not yet executed.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/acpi/boot.c |   60 -------------------------------------------
 1 files changed, 0 insertions(+), 60 deletions(-)

Please apply.

Thanks,
Andreas


diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index eb875cd..4835cf9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1414,24 +1414,6 @@ static int __init force_acpi_ht(const struct dmi_system_id *d)
 }
 
 /*
- * Force ignoring BIOS IRQ0 pin2 override
- */
-static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
-{
-	/*
-	 * The ati_ixp4x0_rev() early PCI quirk should have set
-	 * the acpi_skip_timer_override flag already:
-	 */
-	if (!acpi_skip_timer_override) {
-		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
-		pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n",
-			d->ident);
-		acpi_skip_timer_override = 1;
-	}
-	return 0;
-}
-
-/*
  * If your system is blacklisted here, but you find that acpi=force
  * works for you, please contact acpi-devel@sourceforge.net
  */
@@ -1598,48 +1580,6 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
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
-	 * is not connected at all.  Force ignoring BIOS IRQ0 pin2
-	 * override in that cases.
-	 */
-	{
-	 .callback = dmi_ignore_irq0_timer_override,
-	 .ident = "HP nx6115 laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6115"),
-		     },
-	 },
-	{
-	 .callback = dmi_ignore_irq0_timer_override,
-	 .ident = "HP NX6125 laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6125"),
-		     },
-	 },
-	{
-	 .callback = dmi_ignore_irq0_timer_override,
-	 .ident = "HP NX6325 laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
-		     },
-	 },
-	{
-	 .callback = dmi_ignore_irq0_timer_override,
-	 .ident = "HP 6715b laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
-		     },
-	 },
 	{}
 };
 
-- 
1.6.0.2



