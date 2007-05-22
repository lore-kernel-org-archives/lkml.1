Return-Path: <linux-kernel-owner+w=401wt.eu-S1765800AbXEVIMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765800AbXEVIMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbXEVIGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:36 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:63389 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823AbXEVIGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:17 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 11/15] x86-64: Calgary - reserve TCEs with the same address as MEM regions
Date: Tue, 22 May 2007 04:06:00 -0400
Message-Id: <11798211673144-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <1179821167443-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com> <11798211673003-git-send-email-muli@il.ibm.com> <11798211672822-git-send-email-muli@il.ibm.com> <1179821167443-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

This works around a bug where DMAs that have the same addresses as
some MEM regions do not go through. Not clear yet if this is due to a
mis-configuration or something deeper.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   67 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index a49b19d..9efecf3 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -1538,3 +1538,70 @@ static int __init calgary_parse_options(
 	return 1;
 }
 __setup("calgary=", calgary_parse_options);
+
+static void __init calgary_fixup_one_tce_space(struct pci_dev *dev)
+{
+	struct iommu_table *tbl;
+	unsigned int npages;
+	int i;
+
+	tbl = dev->sysdata;
+
+	for (i = 0; i < 4; i++) {
+		struct resource *r = &dev->resource[PCI_BRIDGE_RESOURCES + i];
+
+		/* Don't give out TCEs that map MEM resources */
+		if (!(r->flags & IORESOURCE_MEM))
+			continue;
+
+		/* 0-based? we reserve the whole 1st MB anyway */
+		if (!r->start)
+			continue;
+
+		/* cover the whole region */
+		npages = (r->end - r->start) >> PAGE_SHIFT;
+		npages++;
+
+		printk(KERN_DEBUG "Calg: dev %p [%x] tbl %p reserving "
+		       "0x%Lx-0x%Lx [0x%x pages]\n", dev, dev->bus->number,
+		       tbl, r->start, r->end, npages);
+			
+		iommu_range_reserve(tbl, r->start, npages);
+	}
+}
+
+static int __init calgary_fixup_tce_spaces(void)
+{
+	struct pci_dev *dev = NULL;
+	void* tce_space;
+
+	if (no_iommu || swiotlb || !calgary_detected)
+		return -ENODEV;
+
+	printk(KERN_DEBUG "Calgary: fixing tce spaces\n");
+
+	do {
+		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
+		if (!dev)
+			break;
+		if (!is_cal_pci_dev(dev->device))
+			continue;
+		if (!translate_phb(dev))
+			continue;
+
+		tce_space = bus_info[dev->bus->number].tce_space;
+		if (!tce_space)
+			continue;
+
+		calgary_fixup_one_tce_space(dev);
+
+	} while (1);
+
+	return 0;
+}
+
+/*
+ * We need to be call after pcibios_assign_resources (fs_initcall level)
+ * and before device_initcall.
+ */
+rootfs_initcall(calgary_fixup_tce_spaces);
-- 
1.4.4

