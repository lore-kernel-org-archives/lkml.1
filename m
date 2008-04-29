Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbYD2U1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbYD2U1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYD2U1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:27:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037AbYD2U1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:27:07 -0400
Date: Tue, 29 Apr 2008 22:26:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Yinghai Lu <yhlu.kernel.send@gmail.com>
Subject: Re: [git pull] PCI updates for 2.6.26
Message-ID: <20080429202632.GA4967@elte.hu>
References: <200804291012.21832.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804291012.21832.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Nothing really major here: some bug fixes, documentation fixes and 
> some trivial stuff for 2.6.26.  Some of the more important changes are 
> actually coming in through Ingo's "big box" tree, so the excitement 
> (and risk) level here should be pretty low.

i see they are now both upstream and the combination mixed well :)

there are a few other PCI items in x86.git btw that you might want to 
have a look at and which you might want to pick up into your tree - they 
dont really belong into x86.git.

one would be the patch below - it gives us a boot option to enable a lot 
more port IO resource space on modern (large) systems, and increases the 
maximum number of PCI cards that Linux can support.

given that true ISA cards with port decode mirroring problems are 
history on new systems, shouldnt this DMI opt-in feature be a 
default-enabled thing instead somehow? DMI really sucks for sane 
features, it does not scale at all as it always lags behind reality.

Can we discover it in a robust way that the system has no chance for ISA 
cards and turn the tighter non-ISA alignment of port resources on 
automatically? [for cases where Linux does the port allocation and 
sizing]

a general x86 distro will still have CONFIG_ISA enabled even today, so 
that alone wont be sufficient i think as a trigger - we need some 
runtime detection.

	Ingo

---------------------->
Subject: x86/pci: add pci=skip_isa_align command lines.
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Date: Thu, 27 Mar 2008 01:31:18 -0700

so we don't align the io port start address for pci cards.

also move out dmi check out acpi.c, because it has nothing to do with acpi.
it could spare some calling when we have several peer root buses.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    2 +
 arch/x86/pci/acpi.c                 |   41 -------------------------------
 arch/x86/pci/common.c               |   47 ++++++++++++++++++++++++++++++++++++
 arch/x86/pci/init.c                 |    2 +
 arch/x86/pci/pci.h                  |    2 +
 5 files changed, 53 insertions(+), 41 deletions(-)

Index: linux-x86.q/Documentation/kernel-parameters.txt
===================================================================
--- linux-x86.q.orig/Documentation/kernel-parameters.txt
+++ linux-x86.q/Documentation/kernel-parameters.txt
@@ -1518,6 +1518,8 @@ and is between 256 and 4096 characters. 
 				This is normally done in pci_enable_device(),
 				so this option is a temporary workaround
 				for broken drivers that don't call it.
+		skip_isa_align	[X86] do not align io start addr, so can
+				handle more pci cards
 		firmware	[ARM] Do not re-enumerate the bus but instead
 				just use the configuration from the
 				bootloader. This is currently used on
Index: linux-x86.q/arch/x86/pci/acpi.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/acpi.c
+++ linux-x86.q/arch/x86/pci/acpi.c
@@ -6,45 +6,6 @@
 #include <asm/numa.h>
 #include "pci.h"
 
-static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
-{
-	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
-	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
-	return 0;
-}
-
-static struct dmi_system_id acpi_pciprobe_dmi_table[] __devinitdata = {
-/*
- * Systems where PCI IO resource ISA alignment can be skipped
- * when the ISA enable bit in the bridge control is not set
- */
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3800",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
-		},
-	},
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3850",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3850"),
-		},
-	},
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3950",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3950"),
-		},
-	},
-	{}
-};
-
 struct pci_root_info {
 	char *name;
 	unsigned int res_num;
@@ -196,8 +157,6 @@ struct pci_bus * __devinit pci_acpi_scan
 	int pxm;
 #endif
 
-	dmi_check_system(acpi_pciprobe_dmi_table);
-
 	if (domain && !pci_domains_supported) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported "
 		       "(dom %d, bus %d)\n", domain, busnum);
Index: linux-x86.q/arch/x86/pci/common.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/common.c
+++ linux-x86.q/arch/x86/pci/common.c
@@ -90,6 +90,50 @@ static void __devinit pcibios_fixup_devi
 		rom_r->start = rom_r->end = rom_r->flags = 0;
 }
 
+static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
+{
+	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
+	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
+	return 0;
+}
+
+static struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitdata = {
+/*
+ * Systems where PCI IO resource ISA alignment can be skipped
+ * when the ISA enable bit in the bridge control is not set
+ */
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3800",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
+		},
+	},
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3850",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3850"),
+		},
+	},
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3950",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3950"),
+		},
+	},
+	{}
+};
+
+void __init dmi_check_skip_isa_align(void)
+{
+	dmi_check_system(can_skip_pciprobe_dmi_table);
+}
+
 /*
  *  Called after each bus is probed, but before its children
  *  are examined.
@@ -462,6 +506,9 @@ char * __devinit  pcibios_setup(char *st
 	} else if (!strcmp(str, "routeirq")) {
 		pci_routeirq = 1;
 		return NULL;
+	} else if (!strcmp(str, "skip_isa_align")) {
+		pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
+		return NULL;
 	}
 	return str;
 }
Index: linux-x86.q/arch/x86/pci/init.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/init.c
+++ linux-x86.q/arch/x86/pci/init.c
@@ -33,6 +33,8 @@ static __init int pci_access_init(void)
 		printk(KERN_ERR
 		"PCI: Fatal: No config space access function found\n");
 
+	dmi_check_skip_isa_align();
+
 	return 0;
 }
 arch_initcall(pci_access_init);
Index: linux-x86.q/arch/x86/pci/pci.h
===================================================================
--- linux-x86.q.orig/arch/x86/pci/pci.h
+++ linux-x86.q/arch/x86/pci/pci.h
@@ -38,6 +38,8 @@ enum pci_bf_sort_state {
 	pci_dmi_bf,
 };
 
+extern void __init dmi_check_skip_isa_align(void);
+
 /* pci-i386.c */
 
 extern unsigned int pcibios_max_latency;
