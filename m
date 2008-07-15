Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYGOLtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYGOLtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYGOLs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:48:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:49415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbYGOLs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:48:57 -0400
Message-ID: <487C8EA7.6020205@suse.de>
Date: Tue, 15 Jul 2008 13:48:55 +0200
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>,
       Olaf Dabrunz <od@suse.de>
Subject: [PATCH] Introduce config option for pci reroute quirks (was: [PATCH
 0/3] Boot IRQ quirks for Broadcom and AMD/ATI)
References: <12155255883170-git-send-email-od@suse.de> <20080713210133.GA12362@elte.hu> <200807140924.59023.jbarnes@virtuousgeek.org> <20080714164548.GA28499@elte.hu> <20080714164948.GA15153@suse.de> <20080714165823.GB15153@suse.de> <20080714175137.GA2297@suse.de>
In-Reply-To: <20080714175137.GA2297@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against linux-2.6-tip, branch pci-ioapic-boot-irq-quirks.

From: Stefan Assmann <sassmann@suse.de>
Subject: Introduce config option for pci reroute quirks

The config option X86_REROUTE_FOR_BROKEN_BOOT_IRQS is introduced to
enable (or disable) the redirection of the interrupt handler to the boot
interrupt line by default. Depending on the existence of interrupt
masking / threaded interrupt handling in the kernel (vanilla, rt, ...)
and the maturity of the rerouting patch, users can enable or disable the
redirection by default.

This means that the reroute quirk can be applied to any kernel without
changing it.

Interrupt sharing could be increased if this option is enabled. However this
option is vital for threaded interrupt handling, as done by the RT kernel.
It should simplify the consolidation with the RT kernel.

The option can be overridden by either pci=ioapicreroute or
pci=noioapicreroute.

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/Kconfig                    |   24 ++++++++++++++++++++++++
 arch/x86/pci/common.c               |    8 ++++++++
 drivers/pci/quirks.c                |    2 +-
 include/asm-x86/pci.h               |    2 +-
 5 files changed, 38 insertions(+), 2 deletions(-)

--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -23,7 +23,11 @@ unsigned int pci_probe = PCI_PROBE_BIOS
 static int pci_bf_sort;
 int pci_routeirq;
 int noioapicquirk;
+#ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
+int noioapicreroute = 0;
+#else
 int noioapicreroute = 1;
+#endif
 int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
@@ -504,6 +508,10 @@ char * __devinit  pcibios_setup(char *st
 		if (noioapicreroute != -1)
 			noioapicreroute = 0;
 		return NULL;
+	} else if (!strcmp(str, "noioapicreroute")) {
+		if (noioapicreroute != -1)
+			noioapicreroute = 1;
+		return NULL;
 	}
 	return str;
 }
--- a/include/asm-x86/pci.h
+++ b/include/asm-x86/pci.h
@@ -20,7 +20,7 @@ struct pci_sysdata {

 extern int pci_routeirq;
 extern int noioapicquirk;
-extern int ioapicreroute;
+extern int noioapicreroute;

 /* scan a bus after allocating a pci_sysdata for it */
 extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1351,7 +1351,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  */
 static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
 {
-	if (noioapicquirk)
+	if (noioapicquirk || noioapicreroute)
 		return;

 	dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT;
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1525,6 +1525,10 @@ and is between 256 and 4096 characters.
 				primary IO-APIC for bridges that cannot disable
 				boot IRQs. This fixes a source of spurious IRQs
 				when the system masks IRQs.
+		noioapicreroute	[APIC] Disable workaround that uses the
+				boot IRQ equivalent of an IRQ that connects to
+				a chipset where boot IRQs cannot be disabled.
+				The opposite of ioapicreroute.
 		biosirq		[X86-32] Use PCI BIOS calls to get the interrupt
 				routing table. These calls are known to be buggy
 				on several machines and they hang the machine
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -663,6 +663,30 @@ config X86_VISWS_APIC
 	def_bool y
 	depends on X86_32 && X86_VISWS

+config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
+	bool "Reroute for broken boot IRQs"
+	default n
+	depends on X86_IO_APIC
+	help
+	  This option enables a workaround that fixes a source of
+	  spurious interrupts. This is recommended when threaded
+	  interrupt handling is used on systems where the generation of
+	  superfluous "boot interrupts" cannot be disabled.
+
+	  Some chipsets generate a legacy INTx "boot IRQ" when the IRQ
+	  entry in the chipset's IO-APIC is masked (as, e.g. the RT
+	  kernel does during interrupt handling). On chipsets where this
+	  boot IRQ generation cannot be disabled, this workaround keeps
+	  the original IRQ line masked so that only the equivalent "boot
+	  IRQ" is delivered to the CPUs. The workaround also tells the
+	  kernel to set up the IRQ handler on the boot IRQ line. In this
+	  way only one interrupt is delivered to the kernel. Otherwise
+	  the spurious second interrupt may cause the kernel to bring
+	  down (vital) interrupt lines.
+
+	  Only affects "broken" chipsets. Interrupt sharing may be
+	  increased on these systems.
+
 config X86_MCE
 	bool "Machine Check Exception"
 	depends on !X86_VOYAGER

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)
