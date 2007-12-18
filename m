Return-Path: <linux-kernel-owner+w=401wt.eu-S936274AbXLRAD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936274AbXLRAD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbXLRADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:03:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:32839 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbXLRADr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:03:47 -0500
Subject: Re: [RFC/PATCH 1/4] pci: Add pci_enable_device_{io,mem} intefaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <x7prx4vq3e.fsf@saeurebad.de>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <x7prx4vq3e.fsf@saeurebad.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 11:02:37 +1100
Message-Id: <1197936157.13400.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-18 at 00:49 +0100, Johannes Weiner wrote:

> These two functions should be refactored, the only difference is the
> flag checking.

FYI. Here's what it looks like in my next version of the patch:

Index: linux-work/drivers/pci/pci.c
===================================================================
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


