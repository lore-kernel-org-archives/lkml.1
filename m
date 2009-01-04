Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZADXEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZADXEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZADXBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:01:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49620 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbZADXBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:01:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 8/8] PCI PCIe portdrv: Remove struct pcie_port_service_id
Date: Mon, 5 Jan 2009 00:01:31 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl>
In-Reply-To: <200901042346.42723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901050001.31540.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The PCI Express port driver uses 'struct pcie_port_service_id' for
matching port service devices and drivers, but this structure
contains fields that duplicate information from the port device
itself (vendor, device, subvendor, subdevice) and fields that are not
used by any existing port service driver (class, class_mask,
drvier_data).  Also, both existing port service drivers (AER and
PCIe HP) don't even use the vendor and device fields for device
matching.  Therefore 'struct pcie_port_service_id' can be removed
altogether and the only useful members of it (port_type, service) can
be introduced directly into the port service device and port service
driver structures.  That simplifies the code quite a bit and reduces
its size.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/pciehp_core.c  |   12 ++----------
 drivers/pci/pcie/aer/aerdrv.c      |   16 ++--------------
 drivers/pci/pcie/aer/aerdrv_core.c |    5 ++---
 drivers/pci/pcie/portdrv_bus.c     |   12 ++++--------
 drivers/pci/pcie/portdrv_core.c    |   10 ++++------
 include/linux/pcieport_if.h        |   19 +++++++------------
 6 files changed, 21 insertions(+), 53 deletions(-)

Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -27,19 +27,12 @@
 #define PCIE_PORT_MSI_MODE		1
 #define PCIE_PORT_MSIX_MODE		2
 
-struct pcie_port_service_id {
-	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
-	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
-	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
-	__u32 port_type, service_type;	/* Port Entity */
-	kernel_ulong_t driver_data;
-};
-
 struct pcie_device {
 	int 		irq;	    /* Service IRQ/MSI/MSI-X Vector */
-	int 		interrupt_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */	
-	struct pcie_port_service_id id;	/* Service ID */
-	struct pci_dev	*port;	    /* Root/Upstream/Downstream Port */
+	int		irq_mode;   /* [0:INTx | 1:MSI | 2:MSI-X] */
+	struct pci_dev *port;	    /* Root/Upstream/Downstream Port */
+	u32		port_type;  /* Type of the port */
+	u32		service;    /* Port service this device represents */
 	void		*priv_data; /* Service Private Data */
 	struct device	device;     /* Generic Device Interface */
 };
@@ -68,7 +61,9 @@ struct pcie_port_service_driver {
 	/* Link Reset Capability - AER service driver specific */
 	pci_ers_result_t (*reset_link) (struct pci_dev *dev);
 
-	const struct pcie_port_service_id *id_table;
+	u32 port_type;  /* Type of the port */
+	u32 service;    /* Port service this device represents */
+
 	struct device_driver driver;
 };
 #define to_service_driver(d) \
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -199,12 +199,10 @@ static void pcie_device_init(struct pci_
 	struct device *device;
 
 	dev->port = parent;
-	dev->interrupt_mode = irq_mode;
 	dev->irq = irq;
-	dev->id.vendor = parent->vendor;
-	dev->id.device = parent->device;
-	dev->id.port_type = port_type;
-	dev->id.service_type = service_type;
+	dev->irq_mode = irq_mode;
+	dev->port_type = port_type;
+	dev->service = service_type;
 
 	/* Initialize generic device interface */
 	device = &dev->device;
@@ -427,7 +425,7 @@ void pcie_port_device_remove(struct pci_
 		status = device_for_each_child(&dev->dev, &device_addr, remove_iter);
 		if (status) {
 			device = (struct device*)device_addr;
-			interrupt_mode = (to_pcie_device(device))->interrupt_mode;
+			interrupt_mode = to_pcie_device(device)->irq_mode;
 			put_device(device);
 			device_unregister(device);
 		}
Index: linux-2.6/drivers/pci/pcie/portdrv_bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_bus.c
+++ linux-2.6/drivers/pci/pcie/portdrv_bus.c
@@ -30,16 +30,12 @@ static int pcie_port_bus_match(struct de
 
 	if (drv->bus != &pcie_port_bus_type || dev->bus != &pcie_port_bus_type)
 		return 0;
-	
+
 	pciedev = to_pcie_device(dev);
 	driver = to_service_driver(drv);
-	if (   (driver->id_table->vendor != PCI_ANY_ID && 
-		driver->id_table->vendor != pciedev->id.vendor) ||
-	       (driver->id_table->device != PCI_ANY_ID &&
-		driver->id_table->device != pciedev->id.device) ||	
-	       (driver->id_table->port_type != PCIE_ANY_PORT &&
-		driver->id_table->port_type != pciedev->id.port_type) ||
-		driver->id_table->service_type != pciedev->id.service_type )
+	if ((driver->port_type != PCIE_ANY_PORT
+	     && driver->port_type != pciedev->port_type)
+	    || driver->service != pciedev->service)
 		return 0;
 
 	return 1;
Index: linux-2.6/drivers/pci/pcie/aer/aerdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv_core.c
+++ linux-2.6/drivers/pci/pcie/aer/aerdrv_core.c
@@ -327,14 +327,13 @@ static int find_aer_service_iter(struct 
 
 	if (device->bus == &pcie_port_bus_type) {
 		pcie_dev = to_pcie_device(device);
-		if (pcie_dev->id.port_type == PCIE_SW_DOWNSTREAM_PORT)
+		if (pcie_dev->port_type == PCIE_SW_DOWNSTREAM_PORT)
 			result->is_downstream = 1;
 
 		driver = device->driver;
 		if (driver) {
 			service_driver = to_service_driver(driver);
-			if (service_driver->id_table->service_type ==
-					PCIE_PORT_SERVICE_AER) {
+			if (service_driver->service == PCIE_PORT_SERVICE_AER) {
 				result->aer_driver = service_driver;
 				return 1;
 			}
Index: linux-2.6/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_core.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_core.c
@@ -496,18 +496,10 @@ static int pciehp_resume (struct pcie_de
 }
 #endif
 
-static struct pcie_port_service_id port_pci_ids[] = { {
-	.vendor = PCI_ANY_ID,
-	.device = PCI_ANY_ID,
-	.port_type = PCIE_ANY_PORT,
-	.service_type = PCIE_PORT_SERVICE_HP,
-	.driver_data =	0,
-	}, { /* end: all zeroes */ }
-};
-
 static struct pcie_port_service_driver hpdriver_portdrv = {
 	.name		= PCIE_MODULE_NAME,
-	.id_table	= &port_pci_ids[0],
+	.port_type	= PCIE_ANY_PORT,
+	.service	= PCIE_PORT_SERVICE_HP,
 
 	.probe		= pciehp_probe,
 	.remove		= pciehp_remove,
Index: linux-2.6/drivers/pci/pcie/aer/aerdrv.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv.c
+++ linux-2.6/drivers/pci/pcie/aer/aerdrv.c
@@ -48,19 +48,6 @@ static pci_ers_result_t aer_error_detect
 static void aer_error_resume(struct pci_dev *dev);
 static pci_ers_result_t aer_root_reset(struct pci_dev *dev);
 
-/*
- * PCI Express bus's AER Root service driver data structure
- */
-static struct pcie_port_service_id aer_id[] = {
-	{
-	.vendor 	= PCI_ANY_ID,
-	.device 	= PCI_ANY_ID,
-	.port_type 	= PCIE_RC_PORT,
-	.service_type 	= PCIE_PORT_SERVICE_AER,
-	},
-	{ /* end: all zeroes */ }
-};
-
 static struct pci_error_handlers aer_error_handlers = {
 	.error_detected = aer_error_detected,
 	.resume = aer_error_resume,
@@ -68,7 +55,8 @@ static struct pci_error_handlers aer_err
 
 static struct pcie_port_service_driver aerdriver = {
 	.name		= "aer",
-	.id_table	= &aer_id[0],
+	.port_type	= PCIE_ANY_PORT,
+	.service	= PCIE_PORT_SERVICE_AER,
 
 	.probe		= aer_probe,
 	.remove		= aer_remove,

