Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbXBJL6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbXBJL6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933415AbXBJLvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:55793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397AbXBJLue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:34 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Olivier Galibert <galibert@pobox.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [16/25] i386: Detect and support the E7520 and the 945G/GZ/P/PL
Message-Id: <20070210115029.2486913DDE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Olivier Galibert <galibert@pobox.com>

It seems that the only way to reliably support mmconfig in the presence of
funky biosen is to detect the hostbridge and read where the window is mapped
from its registers.  Do that for the E7520 and the 945G/GZ/P/PL for a start.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |  121 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 119 insertions(+), 2 deletions(-)

Index: linux/arch/i386/pci/mmconfig-shared.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig-shared.c
+++ linux/arch/i386/pci/mmconfig-shared.c
@@ -3,6 +3,7 @@
  *                     MMCONFIG - common code between i386 and x86-64.
  *
  * This code does:
+ * - known chipset handling
  * - ACPI decoding and validation
  *
  * Per-architecture code takes care of the mappings and accesses
@@ -55,12 +56,128 @@ static __init void unreachable_devices(v
 	}
 }
 
+static __init const char *pci_mmcfg_e7520(void)
+{
+	u32 win;
+	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
+
+	pci_mmcfg_config_num = 1;
+	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+	if (!pci_mmcfg_config)
+		return NULL;
+	pci_mmcfg_config[0].address = (win & 0xf000) << 16;
+	pci_mmcfg_config[0].pci_segment = 0;
+	pci_mmcfg_config[0].start_bus_number = 0;
+	pci_mmcfg_config[0].end_bus_number = 255;
+
+	return "Intel Corporation E7520 Memory Controller Hub";
+}
+
+static __init const char *pci_mmcfg_intel_945(void)
+{
+	u32 pciexbar, mask = 0, len = 0;
+
+	pci_mmcfg_config_num = 1;
+
+	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+
+	/* Enable bit */
+	if (!(pciexbar & 1))
+		pci_mmcfg_config_num = 0;
+
+	/* Size bits */
+	switch ((pciexbar >> 1) & 3) {
+	case 0:
+		mask = 0xf0000000U;
+		len  = 0x10000000U;
+		break;
+	case 1:
+		mask = 0xf8000000U;
+		len  = 0x08000000U;
+		break;
+	case 2:
+		mask = 0xfc000000U;
+		len  = 0x04000000U;
+		break;
+	default:
+		pci_mmcfg_config_num = 0;
+	}
+
+	/* Errata #2, things break when not aligned on a 256Mb boundary */
+	/* Can only happen in 64M/128M mode */
+
+	if ((pciexbar & mask) & 0x0fffffffU)
+		pci_mmcfg_config_num = 0;
+
+	if (pci_mmcfg_config_num) {
+		pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+		if (!pci_mmcfg_config)
+			return NULL;
+		pci_mmcfg_config[0].address = pciexbar & mask;
+		pci_mmcfg_config[0].pci_segment = 0;
+		pci_mmcfg_config[0].start_bus_number = 0;
+		pci_mmcfg_config[0].end_bus_number = (len >> 20) - 1;
+	}
+
+	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
+}
+
+struct pci_mmcfg_hostbridge_probe {
+	u32 vendor;
+	u32 device;
+	const char *(*probe)(void);
+};
+
+static __initdata struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] = {
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+};
+
+static int __init pci_mmcfg_check_hostbridge(void)
+{
+	u32 l;
+	u16 vendor, device;
+	int i;
+	const char *name;
+
+	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
+	vendor = l & 0xffff;
+	device = (l >> 16) & 0xffff;
+
+	pci_mmcfg_config_num = 0;
+	pci_mmcfg_config = NULL;
+	name = NULL;
+
+	for (i = 0; !name && i < ARRAY_SIZE(pci_mmcfg_probes); i++)
+		if ((pci_mmcfg_probes[i].vendor == PCI_ANY_ID ||
+		     pci_mmcfg_probes[i].vendor == vendor) &&
+		    (pci_mmcfg_probes[i].device == PCI_ANY_ID ||
+		     pci_mmcfg_probes[i].device == device))
+			name = pci_mmcfg_probes[i].probe();
+
+	if (name) {
+		if (pci_mmcfg_config_num)
+			printk(KERN_INFO "PCI: Found %s with MMCONFIG support.\n", name);
+		else
+			printk(KERN_INFO "PCI: Found %s without MMCONFIG support.\n",
+			       name);
+	}
+
+	return name != NULL;
+}
+
 void __init pci_mmcfg_init(int type)
 {
+	int known_bridge = 0;
+
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
-	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+	if (type == 1 && pci_mmcfg_check_hostbridge())
+		known_bridge = 1;
+
+	if (!known_bridge)
+		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -69,7 +186,7 @@ void __init pci_mmcfg_init(int type)
 
 	/* Only do this check when type 1 works. If it doesn't work
            assume we run on a Mac and always use MCFG */
-	if (type == 1 &&
+	if (type == 1 && !known_bridge &&
 	    !e820_all_mapped(pci_mmcfg_config[0].address,
 			     pci_mmcfg_config[0].address + MMCONFIG_APER_MIN,
 			     E820_RESERVED)) {
