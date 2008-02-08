Return-Path: <linux-kernel-owner+w=401wt.eu-S964814AbYBHLBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbYBHLBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbYBHLBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:01:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58701 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbYBHLBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:01:31 -0500
Date: Fri, 8 Feb 2008 12:36:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080208113638.GA4745@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org> <200802072221.19099.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802072221.19099.prakash@punnoor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 10:21:18PM +0100, Prakash Punnoor wrote:
> On the day of Thursday 07 February 2008 Andi Kleen hast written:
> 
> > Replace the old "for all of nvidia" quirk with a quirk containing pci
> > device ID. I goobled this list together from pci.ids and googling and it
> > may be incomplete, but so far I haven't had complaints.
> 
> > +	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4 ? */
> 
> If you want to skip timer override on this board, this is a *NAK* from me. I 
> told you the last time, it only works reliably here on MCP51 with timer 

Hmm, if you told me it got lost somewhere, sorry.

> override working. Even before Asus released a bios which had an option to 
> enable the hpet, I needed the override or I got irratic behaviour. Since I 
> got hpet enabled I gave up on arguing as the wrongly triggered quirk didn't 
> bug me anymore.

Ok we can keep the HPET check if that makes you more happy.

> 
> IIRC my nforce2 needed the override. I didn't see that in the list.

The list only contains IDs where the override should be ignored; so
if it has a correct one and it's not there everything is fine.

I'm appending a revised patch. Does it work for you?

-Andi

---

Replace nvidia timer override quirk with pci id list v2

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

I also straightened out the ifdef jungle a bit.

v1->v2: Readd the HPET check to handle a NF4 system of Prakash Punnoor.
	This means with HPET we always assume timer overrides are ok.

Cc: lenb@kernel.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/early-quirks.c |   43 ++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

Index: linux/arch/x86/kernel/early-quirks.c
===================================================================
--- linux.orig/arch/x86/kernel/early-quirks.c
+++ linux/arch/x86/kernel/early-quirks.c
@@ -67,37 +67,30 @@ static int __init nvidia_hpet_check(stru
 {
 	return 0;
 }
-#endif /* CONFIG_X86_IO_APIC */
-#endif /* CONFIG_ACPI */
 
-static void __init nvidia_bugs(int num, int slot, int func)
+static void __init nvidia_timer(int num, int slot, int func)
 {
-#ifdef CONFIG_ACPI
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * All timer overrides on Nvidia are
-	 * wrong unless HPET is enabled.
-	 * Unfortunately that's not true on many Asus boards.
-	 * We don't know yet how to detect this automatically, but
-	 * at least allow a command line override.
-	 */
 	if (acpi_use_timer_override)
 		return;
-
-	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
-		acpi_skip_timer_override = 1;
-		printk(KERN_INFO "Nvidia board "
-		       "detected. Ignoring ACPI "
-		       "timer override.\n");
-		printk(KERN_INFO "If you got timer trouble "
-			"try acpi_use_timer_override\n");
+
+	/* When the board has HPET assume timer override is ok */
+	if (!acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
+		printk(KERN_INFO "Pre Nforce5 Nvidia board detected with HPET.\n"
+		       KERN_INFO "Assuming timer override is ok. If you have trouble\n"
+		       KERN_INFO "please try booting with acpi_skip_timer_override\n");
+		return;
 	}
-#endif
-#endif
-	/* RED-PEN skip them on mptables too? */
 
+	acpi_skip_timer_override = 1;
+	printk(KERN_INFO "Pre NForce5 Nvidia board "
+	       "detected. Ignoring ACPI timer override.\n");
+	printk(KERN_INFO "If you got timer trouble "
+		"try acpi_use_timer_override\n");
 }
 
+#endif
+#endif
+
 static void __init ati_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_X86_IO_APIC
@@ -121,9 +114,21 @@ struct chipset {
 	void (*f)(int num, int slot, int func);
 };
 
+#define QBRIDGE(vendor, device, func) { \
+	vendor, device, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, \
+	QFLAG_APPLY_ONCE, func }
+
 static struct chipset early_qrk[] __initdata = {
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
+	/* This list should cover at least one PCI ID from each NF3 or NF4
+	   mainboard to handle bogus timer overrides in their reference BIOS. */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x00e1, nvidia_timer), /* nforce 3 */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x00ed, nvidia_timer), /* nforce 3 */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x003d, nvidia_timer), /* mcp 04 ?? */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4 ? */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x026f, nvidia_timer), /* mcp 51/nf4 ? */
+	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x005c, nvidia_timer), /* ck 804 */
+#endif
 	{ PCI_VENDOR_ID_VIA, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
