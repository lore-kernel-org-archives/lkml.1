Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYFKPHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYFKPHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbYFKPGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:06:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:43742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760114AbYFKPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:06:52 -0400
From: Stefan Assmann <sassmann@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 5/5] reroute PCI interrupt to legacy boot interrupt equivalent
Date: Wed, 11 Jun 2008 16:35:17 +0200
Message-Id: <12131949182094-git-send-email-sassmann@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12131949173532-git-send-email-sassmann@suse.de>
References: <12131949173532-git-send-email-sassmann@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@suse.de>

Some chipsets (e.g. intel 6700PXH) generate a legacy INTx when the
IRQ entry in the chipset's IO-APIC is masked (as, e.g. the RT kernel
does during interrupt handling). On chipsets where this INTx generation
cannot be disabled, we reroute the valid interrupts to their legacy
equivalent to get rid of spurious interrupts that might otherwise bring
down (vital) interrupt lines through spurious interrupt detection in
note_interrupt().

This patch benefited from discussions with Alexander Graf, Torsten Duwe,
Ihno Krumreich, Daniel Gollub, Hannes Reinecke. The conclusions we drew
and the patch itself are the authors' responsibility alone.

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 drivers/acpi/pci_irq.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/quirks.c   |   28 ++++++++++++++++++++++++
 include/linux/pci.h    |    6 +++++
 3 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index e556f30..31cf1dc 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -384,6 +384,27 @@ acpi_pci_free_irq(struct acpi_prt_entry *entry,
 	return irq;
 }
 
+#ifdef CONFIG_X86_IO_APIC
+extern int noioapicquirk;
+
+static int bridge_has_boot_interrupt_variant(struct pci_bus *bus)
+{
+	struct pci_bus *bus_it;
+
+	for (bus_it = bus ; bus_it ; bus_it = bus_it->parent) {
+		if (!bus_it->self)
+			return 0;
+
+		printk(KERN_INFO "vendor=%04x device=%04x\n", bus_it->self->vendor,
+				bus_it->self->device);
+
+		if (bus_it->self->irq_reroute_variant)
+			return bus_it->self->irq_reroute_variant;
+	}
+	return 0;
+}
+#endif /* CONFIG_X86_IO_APIC */
+
 /*
  * acpi_pci_irq_lookup
  * success: return IRQ >= 0
@@ -413,6 +434,41 @@ acpi_pci_irq_lookup(struct pci_bus *bus,
 	}
 
 	ret = func(entry, triggering, polarity, link);
+
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Some chipsets (e.g. intel 6700PXH) generate a legacy INTx when the
+	 * IRQ entry in the chipset's IO-APIC is masked (as, e.g. the RT kernel
+	 * does during interrupt handling). When this INTx generation cannot be
+	 * disabled, we reroute these interrupts to their legacy equivalent to
+	 * get rid of spurious interrupts.
+	 */
+        if (!noioapicquirk) {
+		switch (bridge_has_boot_interrupt_variant(bus)) {
+		case 0:
+			/* no rerouting necessary */
+			break;
+
+		case INTEL_IRQ_REROUTE_VARIANT:
+			/*
+			 * Remap according to INTx routing table in 6700PXH
+			 * specs, intel order number 302628-002, section
+			 * 2.15.2. Other chipsets (80332, ...) have the same
+			 * mapping and are handled here as well.
+			 */
+			printk(KERN_INFO "pci irq %d -> rerouted to legacy "
+					 "irq %d\n", ret, (ret % 4) + 16);
+			ret = (ret % 4) + 16;
+			break;
+
+		default:
+			printk(KERN_INFO "not rerouting irq %d to legacy irq: "
+					 "unknown mapping\n", ret);
+			break;
+		}
+	}
+#endif /* CONFIG_X86_IO_APIC */
+
 	return ret;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c392f84..4b5b49e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1365,6 +1365,34 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
 
 #ifdef CONFIG_X86_IO_APIC
 /*
+ * Boot interrupts on some chipsets cannot be turned off. For these chipsets,
+ * remap the original interrupt in the linux kernel to the boot interrupt, so
+ * that a PCI device's interrupt handler is installed on the boot interrupt
+ * line instead.
+ */
+static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
+{
+	int i;
+
+	if (noioapicquirk)
+		return;
+
+	dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT;
+
+	printk(KERN_INFO "PCI quirk: reroute interrupts for 0x%04x:0x%04x\n",
+			dev->vendor, dev->device);
+	return;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_80333_0,	quirk_reroute_to_boot_interrupts_intel);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_80333_1,	quirk_reroute_to_boot_interrupts_intel);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ESB2_0,	quirk_reroute_to_boot_interrupts_intel);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXH_0,	quirk_reroute_to_boot_interrupts_intel);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXH_1,	quirk_reroute_to_boot_interrupts_intel);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXHV,	quirk_reroute_to_boot_interrupts_intel);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_80332_0,	quirk_reroute_to_boot_interrupts_intel);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_80332_1,	quirk_reroute_to_boot_interrupts_intel);
+
+/*
  * On some chipsets we can disable the generation of legacy INTx boot
  * interrupts.
  */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d18b1dd..6755cf5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -117,6 +117,11 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) 1,
 };
 
+enum pci_irq_reroute_variant {
+	INTEL_IRQ_REROUTE_VARIANT = 1,
+	MAX_IRQ_REROUTE_VARIANTS = 3
+};
+
 typedef unsigned short __bitwise pci_bus_flags_t;
 enum pci_bus_flags {
 	PCI_BUS_FLAGS_NO_MSI   = (__force pci_bus_flags_t) 1,
@@ -194,6 +199,7 @@ struct pci_dev {
 	unsigned int	no_d1d2:1;   /* only allow d0 or d3 */
 	unsigned int	block_ucfg_access:1;	/* userspace config space access is blocked */
 	unsigned int	broken_parity_status:1;	/* Device generates false positive parity */
+	unsigned int	irq_reroute_variant:2;	/* device needs IRQ rerouting variant */
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
 	unsigned int	is_managed:1;
-- 
1.5.2.4

