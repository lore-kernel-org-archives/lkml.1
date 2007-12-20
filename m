Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbXLTEau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbXLTEau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXLTEam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:30:42 -0500
Received: from ozlabs.org ([203.10.76.45]:57500 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbXLTEal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:30:41 -0500
To: Greg Kroah-Hartman <greg@kroah.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz, <linux-kernel@vger.kernel.org>,
       <ink@jurassic.park.msu.ru>, Alan Cox <alan@redhat.com>,
       <james.smart@emulex.com>, <linux-driver@qlogic.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 20 Dec 2007 15:28:08 +1100
Subject: [PATCH 1/3] pci: Add pci_enable_device_{io,mem} intefaces
Message-Id: <20071220042811.205CCDDEE4@ozlabs.org>
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

This (along with the two following patches) is candidate for 2.6.25

Note that I decided not to inline for now in order to keep the
existing pci_enable_device() export untouched. I know we have somewhat
a policy of screwing up binary drivers but I'd rather not have all
nvidia users hate me tomorrow :-) Also, I'm not sure I want to expose
pci_enable_device_flags() to drivers anyway.

 drivers/pci/pci.c   |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/pci.h |    2 ++
 2 files changed, 50 insertions(+), 1 deletion(-)

--- linux-work.orig/drivers/pci/pci.c	2007-10-15 11:19:38.000000000 +1000
+++ linux-work/drivers/pci/pci.c	2007-12-18 11:01:20.000000000 +1100
@@ -736,6 +736,51 @@ pci_enable_device_bars(struct pci_dev *d
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
@@ -749,7 +794,7 @@ pci_enable_device_bars(struct pci_dev *d
  */
 int pci_enable_device(struct pci_dev *dev)
 {
-	return pci_enable_device_bars(dev, (1 << PCI_NUM_RESOURCES) - 1);
+	return __pci_enable_device_flags(dev, IORESOURCE_MEM | IORESOURCE_IO);
 }
 
 /*
@@ -1621,6 +1666,8 @@ device_initcall(pci_init);
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
--- linux-work.orig/include/linux/pci.h	2007-12-18 11:00:32.000000000 +1100
+++ linux-work/include/linux/pci.h	2007-12-18 11:00:33.000000000 +1100
@@ -548,6 +548,8 @@ static inline int pci_write_config_dword
 
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
+int __must_check pci_enable_device_io(struct pci_dev *dev);
+int __must_check pci_enable_device_mem(struct pci_dev *dev);
 int __must_check pci_reenable_device(struct pci_dev *);
 int __must_check pcim_enable_device(struct pci_dev *pdev);
 void pcim_pin_device(struct pci_dev *pdev);
