Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbZAMNwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbZAMNwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbZAMNuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:50:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50466 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525AbZAMNt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:49:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/7] PCI PCIe portdrv: Use driver data to simplify code
Date: Tue, 13 Jan 2009 14:38:34 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl>
In-Reply-To: <200901131434.28340.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131438.34839.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

PCI Express port driver extension, as defined by
struct pcie_port_device_ext in portdrv.h, is allocated and
initialized, but never used (it also is never freed).  Extend it to
hold the PCI Express port type as well as the port interrupt mode,
change its name and use it to simplify the code in portdrv_core.c .

Additionally, remove the redundant interrupt_mode member of
struct pcie_device defined in include/linux/pcieport_if.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv.h      |    5 +-
 drivers/pci/pcie/portdrv_core.c |   95 +++++++++++++++-------------------------
 include/linux/pcieport_if.h     |    1 
 3 files changed, 39 insertions(+), 62 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -28,8 +28,9 @@
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
-struct pcie_port_device_ext {
-	int interrupt_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */
+struct pcie_port_data {
+	int port_type;		/* Type of the port */
+	int port_irq_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */
 };
 
 extern struct bus_type pcie_port_bus_type;
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -15,10 +15,9 @@
 #include <linux/slab.h>
 #include <linux/pcieport_if.h>
 
+#include "../pci.h"
 #include "portdrv.h"
 
-extern int pcie_mch_quirk;	/* MSI-quirk Indicator */
-
 /**
  * release_pcie_device - free PCI Express port service device structure
  * @dev: Port service device to release
@@ -31,28 +30,6 @@ static void release_pcie_device(struct d
 	kfree(to_pcie_device(dev));			
 }
 
-static int is_msi_quirked(struct pci_dev *dev)
-{
-	int port_type, quirk = 0;
-	u16 reg16;
-
-	pci_read_config_word(dev, 
-		pci_find_capability(dev, PCI_CAP_ID_EXP) + 
-		PCIE_CAPABILITIES_REG, &reg16);
-	port_type = (reg16 >> 4) & PORT_TYPE_MASK;
-	switch(port_type) {
-	case PCIE_RC_PORT:
-		if (pcie_mch_quirk == 1)
-			quirk = 1;
-		break;
-	case PCIE_SW_UPSTREAM_PORT:
-	case PCIE_SW_DOWNSTREAM_PORT:
-	default:
-		break;	
-	}
-	return quirk;
-}
-
 /**
  * assign_interrupt_mode - choose interrupt mode for PCI Express port services
  *                         (INTx, MSI-X, MSI) and set up vectors
@@ -64,6 +41,7 @@ static int is_msi_quirked(struct pci_dev
  */
 static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
 {
+	struct pcie_port_data *port_data = pci_get_drvdata(dev);
 	int i, pos, nvec, status = -EINVAL;
 	int interrupt_mode = PCIE_PORT_INTx_MODE;
 
@@ -75,7 +53,7 @@ static int assign_interrupt_mode(struct 
 	}
 	
 	/* Check MSI quirk */
-	if (is_msi_quirked(dev))
+	if (port_data->port_type == PCIE_RC_PORT && pcie_mch_quirk)
 		return interrupt_mode;
 
 	/* Select MSI-X over MSI if supported */		
@@ -132,13 +110,11 @@ static int get_port_device_capability(st
 			pos + PCIE_SLOT_CAPABILITIES_REG, &reg32);
 		if (reg32 & SLOT_HP_CAPABLE_MASK)
 			services |= PCIE_PORT_SERVICE_HP;
-	} 
-	/* PME Capable - root port capability */
-	if (((reg16 >> 4) & PORT_TYPE_MASK) == PCIE_RC_PORT)
-		services |= PCIE_PORT_SERVICE_PME;
-
+	}
+	/* AER capable */
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR))
 		services |= PCIE_PORT_SERVICE_AER;
+	/* VC support */
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_VC))
 		services |= PCIE_PORT_SERVICE_VC;
 
@@ -152,15 +128,15 @@ static int get_port_device_capability(st
  * @port_type: Type of the port
  * @service_type: Type of service to associate with the service device
  * @irq: Interrupt vector to associate with the service device
- * @irq_mode: Interrupt mode of the service (INTx, MSI-X, MSI)
  */
 static void pcie_device_init(struct pci_dev *parent, struct pcie_device *dev, 
-	int port_type, int service_type, int irq, int irq_mode)
+	int service_type, int irq)
 {
+	struct pcie_port_data *port_data = pci_get_drvdata(parent);
 	struct device *device;
+	int port_type = port_data->port_type;
 
 	dev->port = parent;
-	dev->interrupt_mode = irq_mode;
 	dev->irq = irq;
 	dev->id.vendor = parent->vendor;
 	dev->id.device = parent->device;
@@ -185,10 +161,9 @@ static void pcie_device_init(struct pci_
  * @port_type: Type of the port
  * @service_type: Type of service to associate with the service device
  * @irq: Interrupt vector to associate with the service device
- * @irq_mode: Interrupt mode of the service (INTx, MSI-X, MSI)
  */
 static struct pcie_device* alloc_pcie_device(struct pci_dev *parent,
-	int port_type, int service_type, int irq, int irq_mode)
+	int service_type, int irq)
 {
 	struct pcie_device *device;
 
@@ -196,7 +171,7 @@ static struct pcie_device* alloc_pcie_de
 	if (!device)
 		return NULL;
 
-	pcie_device_init(parent, device, port_type, service_type, irq,irq_mode);
+	pcie_device_init(parent, device, service_type, irq);
 	return device;
 }
 
@@ -230,39 +205,36 @@ int pcie_port_device_probe(struct pci_de
  */
 int pcie_port_device_register(struct pci_dev *dev)
 {
-	struct pcie_port_device_ext *p_ext;
-	int status, type, capabilities, irq_mode, i;
+	struct pcie_port_data *port_data;
+	int status, capabilities, irq_mode, i;
 	int vectors[PCIE_PORT_DEVICE_MAXSERVICES];
 	u16 reg16;
 
-	/* Allocate port device extension */
-	if (!(p_ext = kmalloc(sizeof(struct pcie_port_device_ext), GFP_KERNEL)))
+	port_data = kzalloc(sizeof(*port_data), GFP_KERNEL);
+	if (!port_data)
 		return -ENOMEM;
-
-	pci_set_drvdata(dev, p_ext);
+	pci_set_drvdata(dev, port_data);
 
 	/* Get port type */
 	pci_read_config_word(dev,
 		pci_find_capability(dev, PCI_CAP_ID_EXP) +
 		PCIE_CAPABILITIES_REG, &reg16);
-	type = (reg16 >> 4) & PORT_TYPE_MASK;
+	port_data->port_type = (reg16 >> 4) & PORT_TYPE_MASK;
 
-	/* Now get port services */
 	capabilities = get_port_device_capability(dev);
+	/* Root ports are capable of generating PME too */
+	if (port_data->port_type == PCIE_RC_PORT)
+		capabilities |= PCIE_PORT_SERVICE_PME;
+
 	irq_mode = assign_interrupt_mode(dev, vectors, capabilities);
-	p_ext->interrupt_mode = irq_mode;
+	port_data->port_irq_mode = irq_mode;
 
 	/* Allocate child services if any */
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
 
 		if (capabilities & (1 << i)) {
-			child = alloc_pcie_device(
-				dev, 		/* parent */
-				type,		/* port type */
-				i,		/* service type */
-				vectors[i],	/* irq */
-				irq_mode	/* interrupt mode */);
+			child = alloc_pcie_device(dev, i, vectors[i]);
 			if (child) {
 				status = device_register(&child->device);
 				if (status) {
@@ -349,25 +321,30 @@ static int remove_iter(struct device *de
  */
 void pcie_port_device_remove(struct pci_dev *dev)
 {
-	struct device *device;
-	unsigned long device_addr;
-	int interrupt_mode = PCIE_PORT_INTx_MODE;
+	struct pcie_port_data *port_data = pci_get_drvdata(dev);
 	int status;
 
 	do {
+		unsigned long device_addr;
+
 		status = device_for_each_child(&dev->dev, &device_addr, remove_iter);
 		if (status) {
-			device = (struct device*)device_addr;
-			interrupt_mode = (to_pcie_device(device))->interrupt_mode;
+			struct device *device = (struct device*)device_addr;
 			put_device(device);
 			device_unregister(device);
 		}
 	} while (status);
-	/* Switch to INTx by default if MSI enabled */
-	if (interrupt_mode == PCIE_PORT_MSIX_MODE)
+
+	switch (port_data->port_irq_mode) {
+	case PCIE_PORT_MSIX_MODE:
 		pci_disable_msix(dev);
-	else if (interrupt_mode == PCIE_PORT_MSI_MODE)
+		break;
+	case PCIE_PORT_MSI_MODE:
 		pci_disable_msi(dev);
+		break;
+	}
+
+	kfree(port_data);
 }
 
 /**
Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -36,7 +36,6 @@ struct pcie_port_service_id {
 
 struct pcie_device {
 	int 		irq;	    /* Service IRQ/MSI/MSI-X Vector */
-	int 		interrupt_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */	
 	struct pcie_port_service_id id;	/* Service ID */
 	struct pci_dev	*port;	    /* Root/Upstream/Downstream Port */
 	void		*priv_data; /* Service Private Data */

