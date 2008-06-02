Return-Path: <linux-kernel-owner+w=401wt.eu-S1762379AbYFBNxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762379AbYFBNxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbYFBNwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:52:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:53263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbYFBNv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:58 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Olaf Dabrunz <od@suse.de>, Stefan Assmann <sassmann@suse.de>
Subject: [PATCH 7/7] bootirqquirk= parameter to enable bootirq quirks for additional chips
Date: Mon,  2 Jun 2008 14:45:07 +0200
Message-Id: <1212410707427-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Dabrunz <od@suse.de>

The existing bootirq quirks and the reroute workaround may work for other chips
where we could not test them. This parameter allows users to apply these to
other chips without the need to re-build the kernel.

This patch was conceived simultaneously by Stefan Assmann, Daniel Gollub and
Olaf Dabrunz. The implementation is the author's.

    bootirqquirk=0x<vendor>,0x<device>,<quirk_type>

    - quirk type  1 - 32 selects an IRQ reroute algorithm for devices
      connected to that PCI bridge (currently only algorithm "1" is
      implemented),

    - quirk type 33 -  x applies one of the known quirks to the PCI
      device, currently these:

        33 -> quirk_disable_intel_boot_interrupt
        34 -> quirk_disable_broadcom_boot_interrupt
        35 -> quirk_disable_amd_8111_boot_interrupt
        36 -> quirk_disable_amd_813x_boot_interrupt
        37 -> quirk_disable_amd_sb700s_boot_interrupt

Signed-off-by: Olaf Dabrunz <od@suse.de>
Signed-off-by: Stefan Assmann <sassmann@suse.de>
---
 drivers/pci/quirks.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 090ce38..bb7fa65 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1576,6 +1576,113 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXH_1,	quirk_re
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXHV,	quirk_reroute_to_boot_interrupts_intel);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_80332_0,	quirk_reroute_to_boot_interrupts_intel);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_80332_1,	quirk_reroute_to_boot_interrupts_intel);
+
+/*
+ * For additional boot irq quirks save boot time settings or call the quirks
+ * directly.
+ */
+
+#define MAX_BOOTTIME_CONFIG_PCI_FIXUPS_EARLY			32
+struct pci_fixup __start_bc_pci_fixups_early[MAX_BOOTTIME_CONFIG_PCI_FIXUPS_EARLY];
+struct pci_fixup *__end_bc_pci_fixups_early = __start_bc_pci_fixups_early +
+					MAX_BOOTTIME_CONFIG_PCI_FIXUPS_EARLY;
+
+static void (*bootirq_quirk_func[])(struct pci_dev *dev) = {
+	&quirk_disable_intel_boot_interrupt,
+	&quirk_disable_broadcom_boot_interrupt,
+	&quirk_disable_amd_8111_boot_interrupt,
+	&quirk_disable_amd_813x_boot_interrupt,
+	&quirk_disable_amd_sb700s_boot_interrupt,
+};
+
+int __init bootirqquirk_setup(char *str)
+{
+	int ints[4];
+	struct quirk_bootirq_reroute_dev tmp;
+	int i;
+
+	str = get_options(str, ARRAY_SIZE(ints), ints);
+	if (!str)
+		return 0;
+
+	if (nobootirqquirk)
+		return 1;
+
+	/* all parameters are required */
+	if (ints[0] != 3)
+		return 0;
+
+	/* save settings */
+	tmp.vendor = ints[1];
+	tmp.device = ints[2];
+	tmp.quirk_variant = ints[3];
+
+	/*
+	 * quirk variants > MAX_QUIRK_BOOTIRQ_REROUTE_VARIANTS select quirk
+	 * functions
+	 */
+	if (tmp.quirk_variant > MAX_QUIRK_BOOTIRQ_REROUTE_VARIANTS) {
+		for (i = 0; i < MAX_BOOTTIME_CONFIG_PCI_FIXUPS_EARLY; i++) {
+			if (__start_bc_pci_fixups_early[i].vendor == 0)
+				break;
+
+			if (__start_bc_pci_fixups_early[i].vendor == tmp.vendor &&
+			    __start_bc_pci_fixups_early[i].device == tmp.device)
+				return 1;	/* already in array */
+		}
+
+		if (i >= MAX_BOOTTIME_CONFIG_PCI_FIXUPS_EARLY) {
+			printk(KERN_INFO "PCI quirk: too many boottime "
+					"configurable early quirk entries when "
+					"trying to add 0x%04x:0x%04x\n",
+					tmp.vendor, tmp.device);
+			return 0;
+		}
+
+		if (tmp.quirk_variant > ARRAY_SIZE(bootirq_quirk_func) +
+				MAX_QUIRK_BOOTIRQ_REROUTE_VARIANTS) {
+			printk(KERN_INFO "PCI quirk: no such quirk function: "
+					"%d\n", tmp.quirk_variant);
+			return 0;
+		}
+
+		__start_bc_pci_fixups_early[i].vendor = tmp.vendor;
+		__start_bc_pci_fixups_early[i].device = tmp.device;
+		__start_bc_pci_fixups_early[i].hook =
+				bootirq_quirk_func[tmp.quirk_variant -
+				(MAX_QUIRK_BOOTIRQ_REROUTE_VARIANTS + 1)];
+	} else {
+		for (i = 0; i < MAX_QUIRK_BOOTIRQ_REROUTE_DEVS; i++) {
+			if (quirk_bootirq_reroute_devs[i].vendor == 0)
+				break;
+
+			if (quirk_bootirq_reroute_devs[i].vendor == tmp.vendor &&
+			    quirk_bootirq_reroute_devs[i].device == tmp.device)
+				return 1;	/* already in array */
+		}
+
+		if (i >= MAX_QUIRK_BOOTIRQ_REROUTE_DEVS) {
+			printk(KERN_INFO "PCI quirk: too many reroute entries when "
+					"trying to add 0x%04x:0x%04x\n",
+					tmp.vendor, tmp.device);
+			return 0;
+		}
+
+		quirk_bootirq_reroute_devs[i].vendor = tmp.vendor;
+		quirk_bootirq_reroute_devs[i].device = tmp.device;
+		quirk_bootirq_reroute_devs[i].quirk_variant = tmp.quirk_variant;
+
+		reroute_to_boot_interrupts = 1;
+	}
+
+	printk(KERN_INFO "PCI quirk: reroute interrupts for 0x%04x:0x%04x\n",
+			tmp.vendor, tmp.device);
+	return 1;
+}
+
+/* bootirqquirk=0x<vendor>,0x<device>,<quirk_type> */
+__setup("bootirqquirk=", bootirqquirk_setup);
+
 #endif /* CONFIG_X86_IO_APIC */
 
 /*
@@ -1773,6 +1880,17 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 		return;
 	}
 	pci_do_fixups(dev, start, end);
+
+	switch(pass) {
+	case pci_fixup_early:
+		start = __start_bc_pci_fixups_early;
+		end = __end_bc_pci_fixups_early;
+		break;
+
+	default:
+		return;
+	}
+	pci_do_fixups(dev, start, end);
 }
 EXPORT_SYMBOL(pci_fixup_device);
 
-- 
1.5.2.4

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

