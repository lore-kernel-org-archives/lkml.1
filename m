Return-Path: <linux-kernel-owner+w=401wt.eu-S964944AbXBOICj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbXBOICj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 03:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964945AbXBOICj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 03:02:39 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:51677
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964944AbXBOICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 03:02:38 -0500
Message-Id: <45D4219D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 15 Feb 2007 08:02:21 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <alan@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust legacy IDE resource setting (v2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The change to force legacy mode IDE channels' resources to fixed
non-zero values confuses (at least some versions of) X, because the
values reported by the kernel and those readable from PCI config space
aren't consistent anymore. Therefore, this patch arranges for the
respective BARs to also get updated if possible.

(The only change to the original version is an added comment.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.20/drivers/pci/probe.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-pci-ide-legacy/drivers/pci/probe.c	2007-02-15 08:54:58.000000000 +0100
@@ -639,7 +639,34 @@ static void pci_read_irq(struct pci_dev 
 	dev->irq = irq;
 }
 
-#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+static void change_legacy_io_resource(struct pci_dev * dev, unsigned index,
+                                      unsigned start, unsigned end)
+{
+	unsigned base = start & PCI_BASE_ADDRESS_IO_MASK;
+	unsigned len = (end | ~PCI_BASE_ADDRESS_IO_MASK) - base + 1;
+
+	/*
+	 * Some X versions get confused when the BARs reported through
+	 * /sys or /proc differ from those seen in config space, thus
+	 * try to update the config space values, too.
+	 */
+	if (!(pci_resource_flags(dev, index) & IORESOURCE_IO))
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (not I/O)\n",
+		       pci_name(dev), index);
+	else if (pci_resource_len(dev, index) != len)
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (size %04X)\n",
+		       pci_name(dev), index, (unsigned)pci_resource_len(dev, index));
+	else {
+		printk(KERN_INFO "%s: trying to change BAR%u from %04X to %04X\n",
+		       pci_name(dev), index,
+		       (unsigned)pci_resource_start(dev, index), base);
+		pci_write_config_dword(dev, PCI_BASE_ADDRESS_0 + index * 4, base);
+	}
+	pci_resource_start(dev, index) = start;
+	pci_resource_end(dev, index)   = end;
+	pci_resource_flags(dev, index) =
+		IORESOURCE_IO | IORESOURCE_PCI_FIXED | PCI_BASE_ADDRESS_SPACE_IO;
+}
 
 /**
  * pci_setup_device - fill in class and map information of a device
@@ -692,20 +719,12 @@ static int pci_setup_device(struct pci_d
 			u8 progif;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 0, 0x1F0, 0x1F7);
+				change_legacy_io_resource(dev, 1, 0x3F6, 0x3F6);
 			}
 			if ((progif & 4) == 0) {
-				dev->resource[2].start = 0x170;
-				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = LEGACY_IO_RESOURCE;
-				dev->resource[3].start = 0x376;
-				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 2, 0x170, 0x177);
+				change_legacy_io_resource(dev, 3, 0x376, 0x376);
 			}
 		}
 		break;


