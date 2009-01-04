Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbZADXCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbZADXCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZADXBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:01:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbZADXBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:01:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 4/8] PCI PCIe portdrv: Do not enable port device before setting up interrupts
Date: Sun, 4 Jan 2009 23:54:56 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl>
In-Reply-To: <200901042346.42723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042354.56539.rjw@sisk.pl>
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
 drivers/pci/pcie/portdrv_core.c |   18 ++++++++++++++++--
 drivers/pci/pcie/portdrv_pci.c  |   11 +++--------
 2 files changed, 19 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -204,7 +204,7 @@ int pcie_port_device_probe(struct pci_de
  */
 int pcie_port_device_register(struct pci_dev *dev)
 {
-	int status, type, capabilities, irq_mode, i;
+	int status, type, capabilities, irq_mode, i, nr_serv;
 	int vectors[PCIE_PORT_DEVICE_MAXSERVICES];
 	u16 reg16;
 
@@ -217,9 +217,17 @@ int pcie_port_device_register(struct pci
 	/* Now get port services */
 	capabilities = get_port_device_capability(dev);
 	irq_mode = assign_interrupt_mode(dev, vectors, capabilities);
+	if (irq_mode == PCIE_PORT_NO_IRQ
+	    && !(capabilities & PCIE_PORT_SERVICE_VC))
+		return -ENODEV;
+
+	status = pci_enable_device(dev);
+	if (status)
+		return status;
+	pci_set_master(dev);
 
 	/* Allocate child services if any */
-	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
+	for (i = 0, nr_serv = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
 		int service = 1 << i;
 
@@ -250,7 +258,13 @@ int pcie_port_device_register(struct pci
 		}
 
 		get_device(&child->device);
+		nr_serv++;
 	}
+	if (!nr_serv) {
+		pci_disable_device(dev);
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
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
 

