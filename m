Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZAMNwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZAMNwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbZAMNuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:50:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50469 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764AbZAMNuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:50:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 3/7] PCI PCIe portdrv: Do not enable port device before setting up interrupts (rev. 2)
Date: Tue, 13 Jan 2009 14:42:01 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl>
In-Reply-To: <200901131434.28340.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131442.01565.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The PCI Express port driver calls pci_enable_device() before setting
up interrupts, which is wrong, because if there is an interrupt pin
configured for the port, pci_enable_device() will likely set up an
interrupt link for it.  However, this shouldn't be done if either
MSI or MSI-X interrupt mode is chosen for the port.

The solution is to call pci_enable_device() after setting up
interrupts, because in that case the interrupt link won't be set up
if MSI or MSI-X are enabled.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv_core.c |   38 ++++++++++++++++++++++++++++----------
 drivers/pci/pcie/portdrv_pci.c  |   11 +++--------
 2 files changed, 31 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -208,7 +208,7 @@ int pcie_port_device_probe(struct pci_de
 int pcie_port_device_register(struct pci_dev *dev)
 {
 	struct pcie_port_data *port_data;
-	int status, capabilities, irq_mode, i;
+	int status, capabilities, irq_mode, i, nr_serv;
 	int vectors[PCIE_PORT_DEVICE_MAXSERVICES];
 	u16 reg16;
 
@@ -229,24 +229,32 @@ int pcie_port_device_register(struct pci
 		capabilities |= PCIE_PORT_SERVICE_PME;
 
 	irq_mode = assign_interrupt_mode(dev, vectors, capabilities);
+	if (irq_mode == PCIE_PORT_NO_IRQ) {
+		/*
+		 * Don't use service devices that require interrupts if there is
+		 * no way to generate them.
+		 */
+		if (!(capabilities & PCIE_PORT_SERVICE_VC)) {
+			status = -ENODEV;
+			goto Error;
+		}
+		capabilities = PCIE_PORT_SERVICE_VC;
+	}
 	port_data->port_irq_mode = irq_mode;
 
+	status = pci_enable_device(dev);
+	if (status)
+		goto Error;
+	pci_set_master(dev);
+
 	/* Allocate child services if any */
-	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
+	for (i = 0, nr_serv = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
 		int service = 1 << i;
 
 		if (!(capabilities & service))
 			continue;
 
-		/*
-		 * Don't use service devices that require interrupts if there is
-		 * no way to generate them.
-		 */
-		if (irq_mode == PCIE_PORT_NO_IRQ
-		    && service != PCIE_PORT_SERVICE_VC)
-			continue;
-
 		child = alloc_pcie_device(dev, service, vectors[i]);
 		if (!child)
 			continue;
@@ -258,9 +266,19 @@ int pcie_port_device_register(struct pci
 		}
 
 		get_device(&child->device);
+		nr_serv++;
+	}
+	if (!nr_serv) {
+		pci_disable_device(dev);
+		status = -ENODEV;
+		goto Error;
 	}
 
 	return 0;
+
+ Error:
+	kfree(port_data);
+	return status;
 }
 
 #ifdef CONFIG_PM
Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -94,18 +94,13 @@ static int __devinit pcie_portdrv_probe 
 	if (status)
 		return status;
 
-	if (pci_enable_device(dev) < 0) 
-		return -ENODEV;
-	
-	pci_set_master(dev);
         if (!dev->irq && dev->pin) {
 		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
 			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
-	if (pcie_port_device_register(dev)) {
-		pci_disable_device(dev);
-		return -ENOMEM;
-	}
+	status = pcie_port_device_register(dev);
+	if (status)
+		return status;
 
 	pcie_portdrv_save_config(dev);
 

