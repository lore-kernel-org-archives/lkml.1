Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbYFBNxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbYFBNxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbYFBNwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:52:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:37751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbYFBNv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:57 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Olaf Dabrunz <od@suse.de>, Stefan Assmann <sassmann@suse.de>
Subject: [PATCH 2/7] reroute PCI interrupt to legacy boot interrupt equivalent
Date: Mon,  2 Jun 2008 14:45:02 +0200
Message-Id: <12124107074065-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
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

The patch should eventually simply use another bitfield in the pci_dev
structure for the rerouting variant. This was in another variant of the patch
by Daniel Gollub. It is the cleanest and most simple approach.

This patch benefited from discussions with Alexander Graf, Torsten Duwe,
Ihno Krumreich, Daniel Gollub, Hannes Reinecke. The conclusions we drew
and the patch itself are the authors' responsibility alone.

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 drivers/acpi/pci_irq.c     |   63 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/quirks.c       |   51 ++++++++++++++++++++++++++++++++++-
 include/linux/pci.h        |    2 +
 include/linux/pci_ids.h    |    4 +++
 include/linux/pci_quirks.h |   28 +++++++++++++++++++
 5 files changed, 147 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/pci_quirks.h

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 89022a7..ebdfbfe 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -384,6 +384,34 @@ acpi_pci_free_irq(struct acpi_prt_entry *entry,
 	return irq;
 }
 
+#ifdef CONFIG_X86_IO_APIC
+static int
+bridge_has_boot_interrupt_variant(struct pci_bus *bus)
+{
+	struct pci_bus *bus_it;
+	int i;
+
+	for (bus_it = bus ; bus_it ; bus_it = bus_it->parent) {
+		if (!bus_it->self)
+			return 0;
+
+		printk(KERN_INFO "vendor=%04x device=%04x\n", bus_it->self->vendor,
+				bus_it->self->device);
+		for (i = 0; i < MAX_QUIRK_BOOTIRQ_REROUTE_DEVS; i++) {
+			if (quirk_bootirq_reroute_devs[i].vendor == 0)
+				return 0;
+
+			if (quirk_bootirq_reroute_devs[i].vendor == bus_it->self->vendor &&
+			    quirk_bootirq_reroute_devs[i].device == bus_it->self->device)
+				return quirk_bootirq_reroute_devs[i].quirk_variant;
+		}
+	}
+	return 0;
+}
+
+extern int reroute_to_boot_interrupts;
+#endif /* CONFIG_X86_IO_APIC */
+
 /*
  * acpi_pci_irq_lookup
  * success: return IRQ >= 0
@@ -413,6 +441,41 @@ acpi_pci_irq_lookup(struct pci_bus *bus,
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
+        if (reroute_to_boot_interrupts) {
+		switch (bridge_has_boot_interrupt_variant(bus)) {
+		case 0:
+			/* no rerouting necessary */
+			break;
+
+		case VARIANT_INTEL_BUS_INT_REMAPPING:
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
index 6245486..6173be5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1375,8 +1375,57 @@ int nobootirqquirk_setup(char *str)
 	return 1;
 }
 __setup("nobootirqquirk", nobootirqquirk_setup);
-#endif /* CONFIG_X86_IO_APIC */
 
+/*
+ * Boot interrupts on some chipsets cannot be turned off. For these chipsets,
+ * remap the original interrupt in the linux kernel to the boot interrupt, so
+ * that a PCI device's interrupt handler is installed on the boot interrupt
+ * line instead.
+ */
+int reroute_to_boot_interrupts;
+EXPORT_SYMBOL(reroute_to_boot_interrupts);
+
+struct quirk_bootirq_reroute_dev
+	quirk_bootirq_reroute_devs[MAX_QUIRK_BOOTIRQ_REROUTE_DEVS];
+EXPORT_SYMBOL(quirk_bootirq_reroute_devs);
+
+static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
+{
+	int i;
+
+	if (nobootirqquirk)
+		return;
+
+	for (i = 0; i < MAX_QUIRK_BOOTIRQ_REROUTE_DEVS; i++) {
+		if (quirk_bootirq_reroute_devs[i].vendor == 0)
+			break;
+
+		if (quirk_bootirq_reroute_devs[i].vendor == dev->vendor &&
+		    quirk_bootirq_reroute_devs[i].device == dev->device)
+			return;		/* already on list */
+	}
+
+	quirk_bootirq_reroute_devs[i].vendor = dev->vendor;
+	quirk_bootirq_reroute_devs[i].device = dev->device;
+
+	quirk_bootirq_reroute_devs[i].quirk_variant =
+					VARIANT_INTEL_BUS_INT_REMAPPING;
+
+	reroute_to_boot_interrupts = 1;
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
+#endif /* CONFIG_X86_IO_APIC */
 
 /*
  * Toshiba TC86C001 IDE controller reports the standard 8-byte BAR0 size
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d18b1dd..6c46cad 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1070,5 +1070,7 @@ static inline void pci_mmcfg_early_init(void) { }
 static inline void pci_mmcfg_late_init(void) { }
 #endif
 
+#include <linux/pci_quirks.h>
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9b940e6..c675399 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2233,6 +2233,10 @@
 #define PCI_DEVICE_ID_INTEL_PXH_0	0x0329
 #define PCI_DEVICE_ID_INTEL_PXH_1	0x032A
 #define PCI_DEVICE_ID_INTEL_PXHV	0x032C
+#define PCI_DEVICE_ID_INTEL_80332_0	0x0330
+#define PCI_DEVICE_ID_INTEL_80332_1	0x0332
+#define PCI_DEVICE_ID_INTEL_80333_0	0x0370
+#define PCI_DEVICE_ID_INTEL_80333_1	0x0372
 #define PCI_DEVICE_ID_INTEL_82375	0x0482
 #define PCI_DEVICE_ID_INTEL_82424	0x0483
 #define PCI_DEVICE_ID_INTEL_82378	0x0484
diff --git a/include/linux/pci_quirks.h b/include/linux/pci_quirks.h
new file mode 100644
index 0000000..d875b87
--- /dev/null
+++ b/include/linux/pci_quirks.h
@@ -0,0 +1,28 @@
+/*
+ *	pci_quirks.h
+ *
+ *	PCI quirks defines
+ *	Copyright 2008, Olaf Dabrunz
+ */
+
+#ifndef LINUX_PCI_QUIRKS_H
+#define LINUX_PCI_QUIRKS_H
+
+#ifdef CONFIG_X86_IO_APIC
+#define MAX_QUIRK_BOOTIRQ_REROUTE_VARIANTS	32
+#define VARIANT_INTEL_BUS_INT_REMAPPING		1
+
+struct quirk_bootirq_reroute_dev {
+	unsigned short	vendor;
+	unsigned short	device;
+	unsigned short	quirk_variant;
+};
+
+/* max number of different quirky devices */
+#define MAX_QUIRK_BOOTIRQ_REROUTE_DEVS		32
+
+extern struct quirk_bootirq_reroute_dev
+	quirk_bootirq_reroute_devs[];
+#endif /* CONFIG_X86_IO_APIC */
+
+#endif /* LINUX_PCI_QUIRKS_H */
-- 
1.5.2.4

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

