Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbXLUDAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbXLUDAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXLUDAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:00:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:57043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbXLUDAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:00:08 -0500
Subject: patch pci-add-pci_enable_device_-io-mem-intefaces.patch added to gregkh-2.6 tree
To: benh@kernel.crashing.org, alan@redhat.com, bzolnier@gmail.com,
       greg@kroah.com, gregkh@suse.de, ink@jurassic.park.msu.ru,
       james.smart@emulex.com, linux-driver@qlogic.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 20 Dec 2007 18:58:53 -0800
In-Reply-To: <20071220042811.205CCDDEE4@ozlabs.org>
Message-ID: <11982059332294@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: Add pci_enable_device_{io,mem} intefaces

to my gregkh-2.6 tree.  Its filename is

     pci-add-pci_enable_device_-io-mem-intefaces.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From benh@ozlabs.org Wed Dec 19 20:30:44 2007
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 20 Dec 2007 15:28:08 +1100
Subject: PCI: Add pci_enable_device_{io,mem} intefaces
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, <linux-kernel@vger.kernel.org>, <ink@jurassic.park.msu.ru>, Alan Cox <alan@redhat.com>, <james.smart@emulex.com>, <linux-driver@qlogic.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Message-ID: <20071220042811.205CCDDEE4@ozlabs.org>


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
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c   |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/pci.h |    2 ++
 2 files changed, 50 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -764,6 +764,51 @@ pci_enable_device_bars(struct pci_dev *d
 	return err;
 }
 
+static int __pci_enable_device_flags(struct pci_dev *dev,
+				     resource_size_t flags)
+{
+	int err;
+	int i, bars = 0;
+
+	if (atomic_add_return(1, &dev->enable_cnt) > 1)
+		return 0;		/* already enabled */
+
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
+		if (dev->resource[i].flags & flags)
+			bars |= (1 << i);
+
+	err = do_pci_enable_device(dev, bars);
+	if (err < 0)
+		atomic_dec(&dev->enable_cnt);
+	return err;
+}
+
+/**
+ * pci_enable_device_io - Initialize a device for use with IO space
+ * @dev: PCI device to be initialized
+ *
+ *  Initialize device before it's used by a driver. Ask low-level code
+ *  to enable I/O resources. Wake up the device if it was suspended.
+ *  Beware, this function can fail.
+ */
+int pci_enable_device_io(struct pci_dev *dev)
+{
+	return __pci_enable_device_flags(dev, IORESOURCE_IO);
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
+	return __pci_enable_device_flags(dev, IORESOURCE_MEM);
+}
+
 /**
  * pci_enable_device - Initialize device before it's used by a driver.
  * @dev: PCI device to be initialized
@@ -777,7 +822,7 @@ pci_enable_device_bars(struct pci_dev *d
  */
 int pci_enable_device(struct pci_dev *dev)
 {
-	return pci_enable_device_bars(dev, (1 << PCI_NUM_RESOURCES) - 1);
+	return __pci_enable_device_flags(dev, IORESOURCE_MEM | IORESOURCE_IO);
 }
 
 /*
@@ -1651,6 +1696,8 @@ device_initcall(pci_init);
 
 EXPORT_SYMBOL(pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_bars);
+EXPORT_SYMBOL(pci_enable_device_io);
+EXPORT_SYMBOL(pci_enable_device_mem);
 EXPORT_SYMBOL(pci_enable_device);
 EXPORT_SYMBOL(pcim_enable_device);
 EXPORT_SYMBOL(pcim_pin_device);
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -544,6 +544,8 @@ static inline int pci_write_config_dword
 
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
+int __must_check pci_enable_device_io(struct pci_dev *dev);
+int __must_check pci_enable_device_mem(struct pci_dev *dev);
 int __must_check pci_reenable_device(struct pci_dev *);
 int __must_check pcim_enable_device(struct pci_dev *pdev);
 void pcim_pin_device(struct pci_dev *pdev);


Patches currently in gregkh-2.6 which might be from benh@kernel.crashing.org are

bad/battery-class-driver.patch
driver/adb-convert-from-class_device-to-device.patch
driver/kobject-convert-hvc_console-to-use-kref-not-kobject.patch
driver/kobject-convert-hvcs-to-use-kref-not-kobject.patch
driver/kobject-convert-icom-to-use-kref-not-kobject.patch
pci/pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
pci/pci-fix-warning-in-setup-res.c-on-32-bit-platforms-with-64-bit-resources.patch
pci/pci-add-pci_enable_device_-io-mem-intefaces.patch
pci/pci-remove-pci_enable_device_bars.patch
pci/pci-remove-users-of-pci_enable_device_bars.patch
usb/usb-remove-ohci-useless-masking-unmasking-of-wdh-interrupt.patch
