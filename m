Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbYFMQym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbYFMQym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYFMQxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:53:46 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:23981 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYFMQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:53:33 -0400
Message-Id: <20080613165304.640818638@ldl.fc.hp.com>
References: <20080613165209.507694130@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jun 2008 10:52:13 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/5] PCIE: port driver: use dev_printk when possible
Content-Disposition: inline; filename=pci-portdrv-dev_printk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to use dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pci/pcie/portdrv_core.c |   22 +++++++++++-----------
 drivers/pci/pcie/portdrv_pci.c  |    5 ++---
 2 files changed, 13 insertions(+), 14 deletions(-)

Index: work11/drivers/pci/pcie/portdrv_core.c
===================================================================
--- work11.orig/drivers/pci/pcie/portdrv_core.c	2008-06-12 16:53:49.000000000 -0600
+++ work11/drivers/pci/pcie/portdrv_core.c	2008-06-13 09:47:33.000000000 -0600
@@ -23,20 +23,20 @@ static int pcie_port_probe_service(struc
 {
 	struct pcie_device *pciedev;
 	struct pcie_port_service_driver *driver;
-	int status = -ENODEV;
+	int status;
 
 	if (!dev || !dev->driver)
-		return status;
+		return -ENODEV;
 
  	driver = to_service_driver(dev->driver);
 	if (!driver || !driver->probe)
-		return status;
+		return -ENODEV;
 
 	pciedev = to_pcie_device(dev);
 	status = driver->probe(pciedev, driver->id_table);
 	if (!status) {
-		printk(KERN_DEBUG "Load service driver %s on pcie device %s\n",
-			driver->name, dev->bus_id);
+		dev_printk(KERN_DEBUG, dev, "service driver %s loaded\n",
+			driver->name);
 		get_device(dev);
 	}
 	return status;
@@ -53,8 +53,8 @@ static int pcie_port_remove_service(stru
 	pciedev = to_pcie_device(dev);
  	driver = to_service_driver(dev->driver);
 	if (driver && driver->remove) { 
-		printk(KERN_DEBUG "Unload service driver %s on pcie device %s\n",
-			driver->name, dev->bus_id);
+		dev_printk(KERN_DEBUG, dev, "unloading service driver %s\n",
+			driver->name);
 		driver->remove(pciedev);
 		put_device(dev);
 	}
@@ -103,7 +103,7 @@ static int pcie_port_resume_service(stru
  */
 static void release_pcie_device(struct device *dev)
 {
-	printk(KERN_DEBUG "Free Port Service[%s]\n", dev->bus_id);
+	dev_printk(KERN_DEBUG, dev, "free port service\n");
 	kfree(to_pcie_device(dev));			
 }
 
@@ -150,7 +150,7 @@ static int assign_interrupt_mode(struct 
 	if (pos) {
 		struct msix_entry msix_entries[PCIE_PORT_DEVICE_MAXSERVICES] = 
 			{{0, 0}, {0, 1}, {0, 2}, {0, 3}};
-		printk("%s Found MSIX capability\n", __func__);
+		dev_info(&dev->dev, "found MSI-X capability\n");
 		status = pci_enable_msix(dev, msix_entries, nvec);
 		if (!status) {
 			int j = 0;
@@ -165,7 +165,7 @@ static int assign_interrupt_mode(struct 
 	if (status) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 		if (pos) {
-			printk("%s Found MSI capability\n", __func__);
+			dev_info(&dev->dev, "found MSI capability\n");
 			status = pci_enable_msi(dev);
 			if (!status) {
 				interrupt_mode = PCIE_PORT_MSI_MODE;
@@ -252,7 +252,7 @@ static struct pcie_device* alloc_pcie_de
 		return NULL;
 
 	pcie_device_init(parent, device, port_type, service_type, irq,irq_mode);
-	printk(KERN_DEBUG "Allocate Port Service[%s]\n", device->device.bus_id);
+	dev_printk(KERN_DEBUG, &device->device, "allocate port service\n");
 	return device;
 }
 
Index: work11/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- work11.orig/drivers/pci/pcie/portdrv_pci.c	2008-06-12 16:53:49.000000000 -0600
+++ work11/drivers/pci/pcie/portdrv_pci.c	2008-06-13 09:52:04.000000000 -0600
@@ -91,9 +91,8 @@ static int __devinit pcie_portdrv_probe 
 	
 	pci_set_master(dev);
         if (!dev->irq && dev->pin) {
-		printk(KERN_WARNING 
-		"%s->Dev[%04x:%04x] has invalid IRQ. Check vendor BIOS\n", 
-		__func__, dev->vendor, dev->device);
+		dev_warn(&dev->dev, "device [%04x/%04x] has invalid IRQ; "
+			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
 	if (pcie_port_device_register(dev)) {
 		pci_disable_device(dev);

-- 
