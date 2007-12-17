Return-Path: <linux-kernel-owner+w=401wt.eu-S936827AbXLQXBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936827AbXLQXBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbXLQXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:01:27 -0500
Received: from ozlabs.org ([203.10.76.45]:55641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbXLQXB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:01:26 -0500
To: linux-pci@atrey.karlin.mff.cuni.cz
CC: Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
       <jgarzik@pobox.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       <wingel@nano-system.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       <james.smart@emulex.com>, <linux-driver@qlogic.com>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 18 Dec 2007 10:01:13 +1100
Subject: [RFC/PATCH 1/4] pci: Add pci_enable_device_{io,mem} intefaces
Message-Id: <1197932473.576079.142524077033.qpush@grosgo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci_enable_device_bars() interface isn't well suited to PCI
because you can't actually enable/disable BARs individually on
a device. So for example, if a device has 2 memory BARs 0 and 1,
and one of them (let's say 1) has not been successfully allocated
by the firmware or the kernel, then enabling memory decoding
shouldn't be permitted for the entire device since it will decode
whatever random address is still in that BAR 1.

So a device must be either fully enabled for IO, for Memory, or
for both. Not on a per-BAR basis.

This provides two new functions, pci_enable_device_io() and
pci_enable_device_mem() to replace pci_enable_device_bars(). The
implementation internally builds a BAR mask in order to be able
to use existing arch infrastructure.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/pci/pci.c   |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    2 +
 2 files changed, 56 insertions(+)

--- linux-work.orig/drivers/pci/pci.c	2007-12-18 09:37:56.000000000 +1100
+++ linux-work/drivers/pci/pci.c	2007-12-18 09:38:25.000000000 +1100
@@ -737,6 +737,58 @@ pci_enable_device_bars(struct pci_dev *d
 }
 
 /**
+ * pci_enable_device_io - Initialize a device for use with IO space
+ * @dev: PCI device to be initialized
+ *
+ *  Initialize device before it's used by a driver. Ask low-level code
+ *  to enable I/O resources. Wake up the device if it was suspended.
+ *  Beware, this function can fail.
+ */
+int pci_enable_device_io(struct pci_dev *dev)
+{
+	int err;
+	int i, bars = 0;
+
+	if (atomic_add_return(1, &dev->enable_cnt) > 1)
+		return 0;		/* already enabled */
+
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
+		if (dev->resource[i].flags & IORESOURCE_IO)
+			bars |= (1 << i);
+
+	err = do_pci_enable_device(dev, bars);
+	if (err < 0)
+		atomic_dec(&dev->enable_cnt);
+	return err;
+}
+
+/**
+ * pci_enable_device_mem - Initialize a device for use with Memory space
+ * @dev: PCI device to be initialized
+ *
+ *  Initialize device before it's used by a driver. Ask low-level code
+ *  to enable Memory resources. Wake up the device if it was suspended.
+ *  Beware, this function can fail.
+ */
+int pci_enable_device_mem(struct pci_dev *dev)
+{
+	int err;
+	int i, bars = 0;
+
+	if (atomic_add_return(1, &dev->enable_cnt) > 1)
+		return 0;		/* already enabled */
+
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
+		if (dev->resource[i].flags & IORESOURCE_MEM)
+			bars |= (1 << i);
+
+	err = do_pci_enable_device(dev, bars);
+	if (err < 0)
+		atomic_dec(&dev->enable_cnt);
+	return err;
+}
+
+/**
  * pci_enable_device - Initialize device before it's used by a driver.
  * @dev: PCI device to be initialized
  *
@@ -1621,6 +1673,8 @@ device_initcall(pci_init);
 EXPORT_SYMBOL_GPL(pci_restore_bars);
 EXPORT_SYMBOL(pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_bars);
+EXPORT_SYMBOL(pci_enable_device_io);
+EXPORT_SYMBOL(pci_enable_device_mem);
 EXPORT_SYMBOL(pci_enable_device);
 EXPORT_SYMBOL(pcim_enable_device);
 EXPORT_SYMBOL(pcim_pin_device);
Index: linux-work/include/linux/pci.h
===================================================================
--- linux-work.orig/include/linux/pci.h	2007-12-18 09:38:36.000000000 +1100
+++ linux-work/include/linux/pci.h	2007-12-18 09:38:53.000000000 +1100
@@ -548,6 +548,8 @@ static inline int pci_write_config_dword
 
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
+int __must_check pci_enable_device_io(struct pci_dev *dev);
+int __must_check pci_enable_device_mem(struct pci_dev *dev);
 int __must_check pci_reenable_device(struct pci_dev *);
 int __must_check pcim_enable_device(struct pci_dev *pdev);
 void pcim_pin_device(struct pci_dev *pdev);
