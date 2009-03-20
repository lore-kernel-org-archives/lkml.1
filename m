Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbZCTD0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbZCTD0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZCTDYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:24:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:39425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbZCTDYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042873"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 4/8] PCI: centralize device setup code
Date: Fri, 20 Mar 2009 11:25:14 +0800
Message-Id: <1237519518-24048-5-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the device setup stuff into pci_setup_device() which will be used
to setup the Virtual Function later.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/pci.h   |    1 +
 drivers/pci/probe.c |   79 ++++++++++++++++++++++++++-------------------------
 2 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 7abdef6..80ad848 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -178,6 +178,7 @@ enum pci_bar_type {
 	pci_bar_mem64,		/* A 64-bit memory BAR */
 };
 
+extern int pci_setup_device(struct pci_dev *dev);
 extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 				struct resource *res, unsigned int reg);
 extern int pci_resource_bar(struct pci_dev *dev, int resno,
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4c8abd0..f4ca550 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -674,6 +674,19 @@ static void pci_read_irq(struct pci_dev *dev)
 	dev->irq = irq;
 }
 
+static void set_pcie_port_type(struct pci_dev *pdev)
+{
+	int pos;
+	u16 reg16;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+	if (!pos)
+		return;
+	pdev->is_pcie = 1;
+	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
+	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
+}
+
 #define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
 
 /**
@@ -683,12 +696,34 @@ static void pci_read_irq(struct pci_dev *dev)
  * Initialize the device structure with information about the device's 
  * vendor,class,memory and IO-space addresses,IRQ lines etc.
  * Called at initialisation of the PCI subsystem and by CardBus services.
- * Returns 0 on success and -1 if unknown type of device (not normal, bridge
- * or CardBus).
+ * Returns 0 on success and negative if unknown type of device (not normal,
+ * bridge or CardBus).
  */
-static int pci_setup_device(struct pci_dev * dev)
+int pci_setup_device(struct pci_dev *dev)
 {
 	u32 class;
+	u8 hdr_type;
+	struct pci_slot *slot;
+
+	if (pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type))
+		return -EIO;
+
+	dev->sysdata = dev->bus->sysdata;
+	dev->dev.parent = dev->bus->bridge;
+	dev->dev.bus = &pci_bus_type;
+	dev->hdr_type = hdr_type & 0x7f;
+	dev->multifunction = !!(hdr_type & 0x80);
+	dev->cfg_size = pci_cfg_space_size(dev);
+	dev->error_state = pci_channel_io_normal;
+	set_pcie_port_type(dev);
+
+	list_for_each_entry(slot, &dev->bus->slots, list)
+		if (PCI_SLOT(dev->devfn) == slot->number)
+			dev->slot = slot;
+
+	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
+	   set this higher, assuming the system even supports it.  */
+	dev->dma_mask = 0xffffffff;
 
 	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
 		     dev->bus->number, PCI_SLOT(dev->devfn),
@@ -708,7 +743,6 @@ static int pci_setup_device(struct pci_dev * dev)
 
 	/* Early fixups, before probing the BARs */
 	pci_fixup_device(pci_fixup_early, dev);
-	class = dev->class >> 8;
 
 	switch (dev->hdr_type) {		    /* header type */
 	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
@@ -770,7 +804,7 @@ static int pci_setup_device(struct pci_dev * dev)
 	default:				    /* unknown header */
 		dev_err(&dev->dev, "unknown header type %02x, "
 			"ignoring device\n", dev->hdr_type);
-		return -1;
+		return -EIO;
 
 	bad:
 		dev_err(&dev->dev, "ignoring class %02x (doesn't match header "
@@ -804,19 +838,6 @@ static void pci_release_dev(struct device *dev)
 	kfree(pci_dev);
 }
 
-static void set_pcie_port_type(struct pci_dev *pdev)
-{
-	int pos;
-	u16 reg16;
-
-	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-	if (!pos)
-		return;
-	pdev->is_pcie = 1;
-	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
-	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
-}
-
 /**
  * pci_cfg_space_size - get the configuration space size of the PCI device.
  * @dev: PCI device
@@ -892,9 +913,7 @@ EXPORT_SYMBOL(alloc_pci_dev);
 static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
-	struct pci_slot *slot;
 	u32 l;
-	u8 hdr_type;
 	int delay = 1;
 
 	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l))
@@ -921,34 +940,16 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 		}
 	}
 
-	if (pci_bus_read_config_byte(bus, devfn, PCI_HEADER_TYPE, &hdr_type))
-		return NULL;
-
 	dev = alloc_pci_dev();
 	if (!dev)
 		return NULL;
 
 	dev->bus = bus;
-	dev->sysdata = bus->sysdata;
-	dev->dev.parent = bus->bridge;
-	dev->dev.bus = &pci_bus_type;
 	dev->devfn = devfn;
-	dev->hdr_type = hdr_type & 0x7f;
-	dev->multifunction = !!(hdr_type & 0x80);
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
-	dev->cfg_size = pci_cfg_space_size(dev);
-	dev->error_state = pci_channel_io_normal;
-	set_pcie_port_type(dev);
-
-	list_for_each_entry(slot, &bus->slots, list)
-		if (PCI_SLOT(devfn) == slot->number)
-			dev->slot = slot;
 
-	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
-	   set this higher, assuming the system even supports it.  */
-	dev->dma_mask = 0xffffffff;
-	if (pci_setup_device(dev) < 0) {
+	if (pci_setup_device(dev)) {
 		kfree(dev);
 		return NULL;
 	}
-- 
1.5.6.4

