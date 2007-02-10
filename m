Return-Path: <linux-kernel-owner+w=401wt.eu-S933392AbXBJLxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbXBJLxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933389AbXBJLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:19 -0500
Received: from ns2.suse.de ([195.135.220.15]:55792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393AbXBJLue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:34 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Olivier Galibert <galibert@pobox.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [17/25] i386: Reserve resources but only when we're sure about them.
Message-Id: <20070210115030.2FD3B13DE4@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Olivier Galibert <galibert@pobox.com>

Put back the resource reservation as per
4c6e052adfe285ede5884e4e8c4d33af33932c13 but use it *only* when the range(s)
come from a chipset probe instead of the bios.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

Index: linux/arch/i386/pci/mmconfig-shared.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig-shared.c
+++ linux/arch/i386/pci/mmconfig-shared.c
@@ -166,6 +166,37 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }
 
+static __init void pci_mmcfg_insert_resources(void)
+{
+#define PCI_MMCFG_RESOURCE_NAME_LEN 19
+	int i;
+	struct resource *res;
+	char *names;
+	unsigned num_buses;
+
+	res = kcalloc(PCI_MMCFG_RESOURCE_NAME_LEN + sizeof(*res),
+			pci_mmcfg_config_num, GFP_KERNEL);
+
+	if (!res) {
+		printk(KERN_ERR "PCI: Unable to allocate MMCONFIG resources\n");
+		return;
+	}
+
+	names = (void *)&res[pci_mmcfg_config_num];
+	for (i = 0; i < pci_mmcfg_config_num; i++, res++) {
+		num_buses = pci_mmcfg_config[i].end_bus_number -
+		    pci_mmcfg_config[i].start_bus_number + 1;
+		res->name = names;
+		snprintf(names, PCI_MMCFG_RESOURCE_NAME_LEN, "PCI MMCONFIG %u",
+			pci_mmcfg_config[i].pci_segment);
+		res->start = pci_mmcfg_config[i].address;
+		res->end = res->start + (num_buses << 20) - 1;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		insert_resource(&iomem_resource, res);
+		names += PCI_MMCFG_RESOURCE_NAME_LEN;
+	}
+}
+
 void __init pci_mmcfg_init(int type)
 {
 	int known_bridge = 0;
@@ -199,6 +230,8 @@ void __init pci_mmcfg_init(int type)
 	if (pci_mmcfg_arch_init()) {
 		if (type == 1)
 			unreachable_devices();
+		if (known_bridge)
+			pci_mmcfg_insert_resources();
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
 	}
 }
