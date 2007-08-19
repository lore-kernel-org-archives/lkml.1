Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbXHSOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbXHSOz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 10:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbXHSOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 10:55:18 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:21676 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753513AbXHSOzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 10:55:16 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com
Subject: [PATCH 2/2] pdc202xx_new: switch to using pci_get_slot() (take 2)
Date: Sun, 19 Aug 2007 18:57:40 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708191857.40309.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using pci_get_slot() in init_setup_pdc20270() to get to the mate chip
behind DC21150 bridge as there's no need for the driver itself to walk the list
of the PCI devices (and the driver didn't check the bus # of the found device).
While at it, make it emit warning about IRQ # being fixed up (just like hpt366.c
does) and "beautify" this whole function as well as init_setup_pdc20276()...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
This patch is against the current Linus' tree, it has only been compile tested
since I do not have PDC2027x chips and even less so the fancy RAID card based
on i960 CPU or having DC21150 PCI bridge, so testing is desirable  if anybody
has such stuff. :-)
This version of patch makes sure that both PCI devices behind the i960 CPU have
the same vendor/device ID.  I'm CCing LKML for a wider tester audience...

 drivers/ide/pci/pdc202xx_new.c |   60 +++++++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- linux-2.6.orig/drivers/ide/pci/pdc202xx_new.c
+++ linux-2.6/drivers/ide/pci/pdc202xx_new.c
@@ -518,44 +518,52 @@ static int __devinit init_setup_pdcnew(s
 	return ide_setup_pci_device(dev, d);
 }
 
-static int __devinit init_setup_pdc20270(struct pci_dev *dev,
-					 ide_pci_device_t *d)
+static int __devinit init_setup_pdc20270(struct pci_dev *dev, ide_pci_device_t *d)
 {
-	struct pci_dev *findev;
-	int ret;
+	struct pci_dev *bridge = dev->bus->self;
+
+	if (bridge != NULL &&
+	    bridge->vendor == PCI_VENDOR_ID_DEC &&
+	    bridge->device == PCI_DEVICE_ID_DEC_21150) {
+		struct pci_dev *dev2;
 
-	if ((dev->bus->self &&
-	     dev->bus->self->vendor == PCI_VENDOR_ID_DEC) &&
-	    (dev->bus->self->device == PCI_DEVICE_ID_DEC_21150)) {
 		if (PCI_SLOT(dev->devfn) & 2)
 			return -ENODEV;
 
-		while ((findev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
-			if ((findev->vendor == dev->vendor) &&
-			    (findev->device == dev->device) &&
-			    (PCI_SLOT(findev->devfn) & 2)) {
-				if (findev->irq != dev->irq) {
-					findev->irq = dev->irq;
-				}
-				ret = ide_setup_pci_devices(dev, findev, d);
-				if (ret < 0)
-					pci_dev_put(findev);
-				return ret;
+		dev2 = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn) + 2,
+							PCI_FUNC(dev->devfn)));
+		if (dev2 != NULL &&
+		    dev2->vendor == dev->vendor &&
+		    dev2->device == dev->device) {
+			int ret;
+
+			if (dev2->irq != dev->irq) {
+				dev2->irq = dev->irq;
+
+				printk(KERN_WARNING "%s: PCI config space "
+				       "interrupt fixed.\n", d->name);
 			}
+
+			ret = ide_setup_pci_devices(dev, dev2, d);
+			if (ret < 0)
+				pci_dev_put(dev2);
+			return ret;
 		}
 	}
 	return ide_setup_pci_device(dev, d);
 }
 
-static int __devinit init_setup_pdc20276(struct pci_dev *dev,
-					 ide_pci_device_t *d)
+static int __devinit init_setup_pdc20276(struct pci_dev *dev, ide_pci_device_t *d)
 {
-	if ((dev->bus->self) &&
-	    (dev->bus->self->vendor == PCI_VENDOR_ID_INTEL) &&
-	    ((dev->bus->self->device == PCI_DEVICE_ID_INTEL_I960) ||
-	     (dev->bus->self->device == PCI_DEVICE_ID_INTEL_I960RM))) {
-		printk(KERN_INFO "ide: Skipping Promise PDC20276 "
-			"attached to I2O RAID controller.\n");
+	struct pci_dev *bridge = dev->bus->self;
+
+	if (bridge != NULL &&
+	    bridge->vendor == PCI_VENDOR_ID_INTEL &&
+	   (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
+	    bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
+
+		printk(KERN_INFO "%s: attached to I2O RAID controller, "
+				 "skipping.\n", d->name);
 		return -ENODEV;
 	}
 	return ide_setup_pci_device(dev, d);

