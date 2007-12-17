Return-Path: <linux-kernel-owner+w=401wt.eu-S937358AbXLQXCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937358AbXLQXCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762626AbXLQXBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:01:31 -0500
Received: from ozlabs.org ([203.10.76.45]:55666 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760274AbXLQXB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:01:27 -0500
To: linux-pci@atrey.karlin.mff.cuni.cz
CC: Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
       <jgarzik@pobox.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       <wingel@nano-system.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       <james.smart@emulex.com>, <linux-driver@qlogic.com>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 18 Dec 2007 10:01:14 +1100
Subject: [RFC/PATCH 3/4] pci: Remove pci_enable_device_bars()
In-Reply-To: <1197932473.576079.142524077033.qpush@grosgo>
Message-Id: <20071217230126.B2D71DDE36@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all in-tree users are gone, this removes pci_enable_device_bars()
completely.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/pci/pci.c   |   32 +++++++-------------------------
 include/linux/pci.h |    1 -
 2 files changed, 7 insertions(+), 26 deletions(-)

--- linux-work.orig/drivers/pci/pci.c	2007-12-18 09:38:25.000000000 +1100
+++ linux-work/drivers/pci/pci.c	2007-12-18 09:39:04.000000000 +1100
@@ -714,29 +714,6 @@ int pci_reenable_device(struct pci_dev *
 }
 
 /**
- * pci_enable_device_bars - Initialize some of a device for use
- * @dev: PCI device to be initialized
- * @bars: bitmask of BAR's that must be configured
- *
- *  Initialize device before it's used by a driver. Ask low-level code
- *  to enable selected I/O and memory resources. Wake up the device if it
- *  was suspended. Beware, this function can fail.
- */
-int
-pci_enable_device_bars(struct pci_dev *dev, int bars)
-{
-	int err;
-
-	if (atomic_add_return(1, &dev->enable_cnt) > 1)
-		return 0;		/* already enabled */
-
-	err = do_pci_enable_device(dev, bars);
-	if (err < 0)
-		atomic_dec(&dev->enable_cnt);
-	return err;
-}
-
-/**
  * pci_enable_device_io - Initialize a device for use with IO space
  * @dev: PCI device to be initialized
  *
@@ -801,7 +778,13 @@ int pci_enable_device_mem(struct pci_dev
  */
 int pci_enable_device(struct pci_dev *dev)
 {
-	return pci_enable_device_bars(dev, (1 << PCI_NUM_RESOURCES) - 1);
+	if (atomic_add_return(1, &dev->enable_cnt) > 1)
+		return 0;		/* already enabled */
+
+	err = do_pci_enable_device(dev, (1 << PCI_NUM_RESOURCES) - 1);
+	if (err < 0)
+		atomic_dec(&dev->enable_cnt);
+	return err;
 }
 
 /*
@@ -1672,7 +1655,6 @@ device_initcall(pci_init);
 
 EXPORT_SYMBOL_GPL(pci_restore_bars);
 EXPORT_SYMBOL(pci_reenable_device);
-EXPORT_SYMBOL(pci_enable_device_bars);
 EXPORT_SYMBOL(pci_enable_device_io);
 EXPORT_SYMBOL(pci_enable_device_mem);
 EXPORT_SYMBOL(pci_enable_device);
Index: linux-work/include/linux/pci.h
===================================================================
--- linux-work.orig/include/linux/pci.h	2007-12-18 09:39:20.000000000 +1100
+++ linux-work/include/linux/pci.h	2007-12-18 09:39:22.000000000 +1100
@@ -547,7 +547,6 @@ static inline int pci_write_config_dword
 }
 
 int __must_check pci_enable_device(struct pci_dev *dev);
-int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
 int __must_check pci_enable_device_io(struct pci_dev *dev);
 int __must_check pci_enable_device_mem(struct pci_dev *dev);
 int __must_check pci_reenable_device(struct pci_dev *);
