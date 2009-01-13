Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbZAMNwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbZAMNwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759084AbZAMNuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:50:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240AbZAMNuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:50:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/7] PCI PCIe portdrv: Aviod using service devices with wrong interrupts (rev. 2)
Date: Tue, 13 Jan 2009 14:39:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl>
In-Reply-To: <200901131434.28340.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131439.39436.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The PCI Express port driver should not attempt to register service
devices that require the ability to generate interrupts if generating
interrupts is not possible.  Namely, if the port has no interrupt pin
configured and we cannot set up MSI or MSI-X for it, there is no way
it can generate interrupts and in such a case the port services that
rely on interrupts (PME, PCIe HP, AER) should not be enabled for it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv_core.c |   41 +++++++++++++++++++++++++++-------------
 include/linux/pcieport_if.h     |    1 
 2 files changed, 29 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -22,6 +22,7 @@
 #define PCIE_PORT_SERVICE_VC		8	/* Virtual Channel */
 
 /* Root/Upstream/Downstream Port's Interrupt Mode */
+#define PCIE_PORT_NO_IRQ		(-1)
 #define PCIE_PORT_INTx_MODE		0
 #define PCIE_PORT_MSI_MODE		1
 #define PCIE_PORT_MSIX_MODE		2
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -43,7 +43,7 @@ static int assign_interrupt_mode(struct 
 {
 	struct pcie_port_data *port_data = pci_get_drvdata(dev);
 	int i, pos, nvec, status = -EINVAL;
-	int interrupt_mode = PCIE_PORT_INTx_MODE;
+	int interrupt_mode = PCIE_PORT_NO_IRQ;
 
 	/* Set INTx as default */
 	for (i = 0, nvec = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
@@ -51,7 +51,9 @@ static int assign_interrupt_mode(struct 
 			nvec++;
 		vectors[i] = dev->irq;
 	}
-	
+	if (dev->pin)
+		interrupt_mode = PCIE_PORT_INTx_MODE;
+
 	/* Check MSI quirk */
 	if (port_data->port_type == PCIE_RC_PORT && pcie_mch_quirk)
 		return interrupt_mode;
@@ -141,7 +143,7 @@ static void pcie_device_init(struct pci_
 	dev->id.vendor = parent->vendor;
 	dev->id.device = parent->device;
 	dev->id.port_type = port_type;
-	dev->id.service_type = (1 << service_type);
+	dev->id.service_type = service_type;
 
 	/* Initialize generic device interface */
 	device = &dev->device;
@@ -232,19 +234,32 @@ int pcie_port_device_register(struct pci
 	/* Allocate child services if any */
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
+		int service = 1 << i;
 
-		if (capabilities & (1 << i)) {
-			child = alloc_pcie_device(dev, i, vectors[i]);
-			if (child) {
-				status = device_register(&child->device);
-				if (status) {
-					kfree(child);
-					continue;
-				}
-				get_device(&child->device);
-			}
+		if (!(capabilities & service))
+			continue;
+
+		/*
+		 * Don't use service devices that require interrupts if there is
+		 * no way to generate them.
+		 */
+		if (irq_mode == PCIE_PORT_NO_IRQ
+		    && service != PCIE_PORT_SERVICE_VC)
+			continue;
+
+		child = alloc_pcie_device(dev, service, vectors[i]);
+		if (!child)
+			continue;
+
+		status = device_register(&child->device);
+		if (status) {
+			kfree(child);
+			continue;
 		}
+
+		get_device(&child->device);
 	}
+
 	return 0;
 }
 

