Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXH2TCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXH2TCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbXH2TCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:02:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:50203 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbXH2TCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,322,1183359600"; 
   d="scan'208";a="269769992"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH v3 -mm 4/7] I/OAT: Split PCI startup from DMA handling code
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com
Date: Wed, 29 Aug 2007 12:01:49 -0700
Message-ID: <20070829190149.7367.72036.stgit@localhost.localdomain>
In-Reply-To: <20070829190112.7367.40989.stgit@localhost.localdomain>
References: <20070829190112.7367.40989.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Split the general PCI startup from the DMA handling code in order to
prepare for adding support for DCA services and future versions of the
ioatdma device.

    [Rusty Russell] Removal of __unsafe() usage.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
---

 drivers/dma/Makefile     |    2 
 drivers/dma/ioat.c       |  196 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/ioat_dma.c   |  180 ++++++++++--------------------------------
 drivers/dma/ioatdma.h    |   20 +++--
 drivers/dma/ioatdma_hw.h |    2 
 5 files changed, 254 insertions(+), 146 deletions(-)

diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 77bee99..cec0c9c 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
-ioatdma-objs := ioat_dma.o
+ioatdma-objs := ioat.o ioat_dma.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
new file mode 100644
index 0000000..ae5817b
--- /dev/null
+++ b/drivers/dma/ioat.c
@@ -0,0 +1,196 @@
+/*
+ * Intel I/OAT DMA Linux driver
+ * Copyright(c) 2004 - 2007 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ */
+
+/*
+ * This driver supports an Intel I/OAT DMA engine, which does asynchronous
+ * copy operations.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include "ioatdma.h"
+#include "ioatdma_registers.h"
+#include "ioatdma_hw.h"
+
+MODULE_VERSION("1.24");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Intel Corporation");
+
+static struct pci_device_id ioat_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
+	{ 0, }
+};
+
+struct ioat_device {
+	struct pci_dev		*pdev;
+	void __iomem		*iobase;
+	struct ioatdma_device	*dma;
+};
+
+static int __devinit ioat_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id);
+#ifdef IOAT_DMA_REMOVE
+static void __devexit ioat_remove(struct pci_dev *pdev);
+#endif
+
+static int ioat_setup_functionality(struct pci_dev *pdev, void __iomem *iobase)
+{
+	struct ioat_device *device = pci_get_drvdata(pdev);
+	u8 version;
+	int err = 0;
+
+	version = readb(iobase + IOAT_VER_OFFSET);
+	switch (version) {
+	case IOAT_VER_1_2:
+		device->dma = ioat_dma_probe(pdev, iobase);
+		break;
+	default:
+		err = -ENODEV;
+		break;
+	}
+	return err;
+}
+
+static void ioat_shutdown_functionality(struct pci_dev *pdev)
+{
+	struct ioat_device *device = pci_get_drvdata(pdev);
+
+	if (device->dma) {
+		ioat_dma_remove(device->dma);
+		device->dma = NULL;
+	}
+}
+
+static struct pci_driver ioat_pci_drv = {
+	.name		= "ioatdma",
+	.id_table	= ioat_pci_tbl,
+	.probe		= ioat_probe,
+	.shutdown	= ioat_shutdown_functionality,
+#ifdef IOAT_DMA_REMOVE
+	.remove		= __devexit_p(ioat_remove),
+#endif
+};
+
+static int __devinit ioat_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id)
+{
+	void __iomem *iobase;
+	struct ioat_device *device;
+	unsigned long mmio_start, mmio_len;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		goto err_enable_device;
+
+	err = pci_request_regions(pdev, ioat_pci_drv.name);
+	if (err)
+		goto err_request_regions;
+
+	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	if (err)
+		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err)
+		goto err_set_dma_mask;
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	if (err)
+		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err)
+		goto err_set_dma_mask;
+
+	mmio_start = pci_resource_start(pdev, 0);
+	mmio_len = pci_resource_len(pdev, 0);
+	iobase = ioremap(mmio_start, mmio_len);
+	if (!iobase) {
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device) {
+		err = -ENOMEM;
+		goto err_kzalloc;
+	}
+	device->pdev = pdev;
+	pci_set_drvdata(pdev, device);
+	device->iobase = iobase;
+
+	pci_set_master(pdev);
+
+	err = ioat_setup_functionality(pdev, iobase);
+	if (err)
+		goto err_version;
+
+	return 0;
+
+err_version:
+	kfree(device);
+err_kzalloc:
+	iounmap(iobase);
+err_ioremap:
+err_set_dma_mask:
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+err_request_regions:
+err_enable_device:
+	return err;
+}
+
+#ifdef IOAT_DMA_REMOVE
+/*
+ * It is unsafe to remove this module: if removed while a requested
+ * dma is outstanding, esp. from tcp, it is possible to hang while
+ * waiting for something that will never finish, thus hanging at
+ * least one cpu.  However, if you're feeling lucky and need to do
+ * some testing, this usually works just fine.
+ */
+static void __devexit ioat_remove(struct pci_dev *pdev)
+{
+	struct ioat_device *device = pci_get_drvdata(pdev);
+
+	ioat_shutdown_functionality(pdev);
+
+	kfree(device);
+
+	iounmap(device->iobase);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+#endif
+
+static int __init ioat_init_module(void)
+{
+	return pci_register_driver(&ioat_pci_drv);
+}
+module_init(ioat_init_module);
+
+static void __exit ioat_exit_module(void)
+{
+	pci_unregister_driver(&ioat_pci_drv);
+}
+module_exit(ioat_exit_module);
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 2db05f6..eef83ea 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -39,19 +39,15 @@
 #define INITIAL_IOAT_DESC_COUNT 128
 
 #define to_ioat_chan(chan) container_of(chan, struct ioat_dma_chan, common)
-#define to_ioat_device(dev) container_of(dev, struct ioat_device, common)
+#define to_ioatdma_device(dev) container_of(dev, struct ioatdma_device, common)
 #define to_ioat_desc(lh) container_of(lh, struct ioat_desc_sw, node)
 #define tx_to_ioat_desc(tx) container_of(tx, struct ioat_desc_sw, async_tx)
 
 /* internal functions */
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
-static int __devinit ioat_probe(struct pci_dev *pdev,
-				const struct pci_device_id *ent);
-static void ioat_shutdown(struct pci_dev *pdev);
-static void __devexit ioat_remove(struct pci_dev *pdev);
 
-static int ioat_dma_enumerate_channels(struct ioat_device *device)
+static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 {
 	u8 xfercap_scale;
 	u32 xfercap;
@@ -158,17 +154,17 @@ static struct ioat_desc_sw *ioat_dma_alloc_descriptor(
 {
 	struct ioat_dma_descriptor *desc;
 	struct ioat_desc_sw *desc_sw;
-	struct ioat_device *ioat_device;
+	struct ioatdma_device *ioatdma_device;
 	dma_addr_t phys;
 
-	ioat_device = to_ioat_device(ioat_chan->common.device);
-	desc = pci_pool_alloc(ioat_device->dma_pool, flags, &phys);
+	ioatdma_device = to_ioatdma_device(ioat_chan->common.device);
+	desc = pci_pool_alloc(ioatdma_device->dma_pool, flags, &phys);
 	if (unlikely(!desc))
 		return NULL;
 
 	desc_sw = kzalloc(sizeof(*desc_sw), flags);
 	if (unlikely(!desc_sw)) {
-		pci_pool_free(ioat_device->dma_pool, desc, phys);
+		pci_pool_free(ioatdma_device->dma_pool, desc, phys);
 		return NULL;
 	}
 
@@ -245,9 +241,8 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
-	struct ioat_device *ioat_device = to_ioat_device(chan->device);
+	struct ioatdma_device *ioatdma_device = to_ioatdma_device(chan->device);
 	struct ioat_desc_sw *desc, *_desc;
-	u16 chanctrl;
 	int in_use_descs = 0;
 
 	ioat_dma_memcpy_cleanup(ioat_chan);
@@ -258,19 +253,19 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
 		in_use_descs++;
 		list_del(&desc->node);
-		pci_pool_free(ioat_device->dma_pool, desc->hw,
+		pci_pool_free(ioatdma_device->dma_pool, desc->hw,
 			      desc->async_tx.phys);
 		kfree(desc);
 	}
 	list_for_each_entry_safe(desc, _desc, &ioat_chan->free_desc, node) {
 		list_del(&desc->node);
-		pci_pool_free(ioat_device->dma_pool, desc->hw,
+		pci_pool_free(ioatdma_device->dma_pool, desc->hw,
 			      desc->async_tx.phys);
 		kfree(desc);
 	}
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
-	pci_pool_free(ioat_device->completion_pool,
+	pci_pool_free(ioatdma_device->completion_pool,
 		      ioat_chan->completion_virt,
 		      ioat_chan->completion_addr);
 
@@ -514,25 +509,9 @@ static enum dma_status ioat_dma_is_complete(struct dma_chan *chan,
 
 /* PCI API */
 
-static struct pci_device_id ioat_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
-	{ 0, }
-};
-
-static struct pci_driver ioat_pci_driver = {
-	.name 	= "ioatdma",
-	.id_table = ioat_pci_tbl,
-	.probe	= ioat_probe,
-	.shutdown = ioat_shutdown,
-	.remove	= __devexit_p(ioat_remove),
-};
-
 static irqreturn_t ioat_do_interrupt(int irq, void *data)
 {
-	struct ioat_device *instance = data;
+	struct ioatdma_device *instance = data;
 	unsigned long attnstatus;
 	u8 intrctrl;
 
@@ -592,7 +571,7 @@ static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
  */
 #define IOAT_TEST_SIZE 2000
 
-static int ioat_self_test(struct ioat_device *device)
+static int ioat_self_test(struct ioatdma_device *device)
 {
 	int i;
 	u8 *src;
@@ -660,46 +639,25 @@ out:
 	return err;
 }
 
-static int __devinit ioat_probe(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
+				      void __iomem *iobase)
 {
 	int err;
-	unsigned long mmio_start, mmio_len;
-	void __iomem *reg_base;
-	struct ioat_device *device;
-
-	err = pci_enable_device(pdev);
-	if (err)
-		goto err_enable_device;
-
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
-	if (err)
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-	if (err)
-		goto err_set_dma_mask;
-
-	err = pci_request_regions(pdev, ioat_pci_driver.name);
-	if (err)
-		goto err_request_regions;
-
-	mmio_start = pci_resource_start(pdev, 0);
-	mmio_len = pci_resource_len(pdev, 0);
-
-	reg_base = ioremap(mmio_start, mmio_len);
-	if (!reg_base) {
-		err = -ENOMEM;
-		goto err_ioremap;
-	}
+	struct ioatdma_device *device;
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (!device) {
 		err = -ENOMEM;
 		goto err_kzalloc;
 	}
+	device->pdev = pdev;
+	device->reg_base = iobase;
+	device->version = readb(device->reg_base + IOAT_VER_OFFSET);
 
 	/* DMA coherent memory pool for DMA descriptor allocations */
 	device->dma_pool = pci_pool_create("dma_desc_pool", pdev,
-		sizeof(struct ioat_dma_descriptor), 64, 0);
+					   sizeof(struct ioat_dma_descriptor),
+					   64, 0);
 	if (!device->dma_pool) {
 		err = -ENOMEM;
 		goto err_dma_pool;
@@ -713,26 +671,6 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 		goto err_completion_pool;
 	}
 
-	device->pdev = pdev;
-	pci_set_drvdata(pdev, device);
-#ifdef CONFIG_PCI_MSI
-	if (pci_enable_msi(pdev) == 0) {
-		device->msi = 1;
-	} else {
-		device->msi = 0;
-	}
-#endif
-	err = request_irq(pdev->irq, &ioat_do_interrupt, IRQF_SHARED, "ioat",
-		device);
-	if (err)
-		goto err_irq;
-
-	device->reg_base = reg_base;
-
-	writeb(IOAT_INTRCTRL_MASTER_INT_EN,
-	       device->reg_base + IOAT_INTRCTRL_OFFSET);
-	pci_set_master(pdev);
-
 	INIT_LIST_HEAD(&device->common.channels);
 	ioat_dma_enumerate_channels(device);
 
@@ -746,9 +684,19 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 	device->common.device_issue_pending = ioat_dma_memcpy_issue_pending;
 	device->common.device_dependency_added = ioat_dma_dependency_added;
 	device->common.dev = &pdev->dev;
-	printk(KERN_INFO
-		 "ioatdma: Intel(R) I/OAT DMA Engine found, %d channels\n",
-		 device->common.chancnt);
+	printk(KERN_INFO "ioatdma: Intel(R) I/OAT DMA Engine found,"
+	       " %d channels, device version 0x%02x\n",
+	       device->common.chancnt, device->version);
+
+	pci_set_drvdata(pdev, device);
+	err = request_irq(pdev->irq, &ioat_do_interrupt, IRQF_SHARED, "ioat",
+		device);
+	if (err)
+		goto err_irq;
+
+	writeb(IOAT_INTRCTRL_MASTER_INT_EN,
+	       device->reg_base + IOAT_INTRCTRL_OFFSET);
+	pci_set_master(pdev);
 
 	err = ioat_self_test(device);
 	if (err)
@@ -756,9 +704,10 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 
 	dma_async_device_register(&device->common);
 
-	return 0;
+	return device;
 
 err_self_test:
+	free_irq(device->pdev->irq, device);
 err_irq:
 	pci_pool_destroy(device->completion_pool);
 err_completion_pool:
@@ -766,47 +715,24 @@ err_completion_pool:
 err_dma_pool:
 	kfree(device);
 err_kzalloc:
-	iounmap(reg_base);
-err_ioremap:
-	pci_release_regions(pdev);
-err_request_regions:
-err_set_dma_mask:
-	pci_disable_device(pdev);
-err_enable_device:
-
-	printk(KERN_INFO
-		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
-
-	return err;
-}
-
-static void ioat_shutdown(struct pci_dev *pdev)
-{
-	struct ioat_device *device;
-	device = pci_get_drvdata(pdev);
-
-	dma_async_device_unregister(&device->common);
+	iounmap(iobase);
+	printk(KERN_ERR
+	       "ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
+	return NULL;
 }
 
-static void __devexit ioat_remove(struct pci_dev *pdev)
+void ioat_dma_remove(struct ioatdma_device *device)
 {
-	struct ioat_device *device;
 	struct dma_chan *chan, *_chan;
 	struct ioat_dma_chan *ioat_chan;
 
-	device = pci_get_drvdata(pdev);
 	dma_async_device_unregister(&device->common);
 
 	free_irq(device->pdev->irq, device);
-#ifdef CONFIG_PCI_MSI
-	if (device->msi)
-		pci_disable_msi(device->pdev);
-#endif
+
 	pci_pool_destroy(device->dma_pool);
 	pci_pool_destroy(device->completion_pool);
-	iounmap(device->reg_base);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
+
 	list_for_each_entry_safe(chan, _chan,
 				 &device->common.channels, device_node) {
 		ioat_chan = to_ioat_chan(chan);
@@ -816,25 +742,3 @@ static void __devexit ioat_remove(struct pci_dev *pdev)
 	kfree(device);
 }
 
-/* MODULE API */
-MODULE_VERSION("1.9");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Intel Corporation");
-
-static int __init ioat_init_module(void)
-{
-	/* it's currently unsafe to unload this module */
-	/* if forced, worst case is that rmmod hangs */
-	__unsafe(THIS_MODULE);
-
-	return pci_register_driver(&ioat_pci_driver);
-}
-
-module_init(ioat_init_module);
-
-static void __exit ioat_exit_module(void)
-{
-	pci_unregister_driver(&ioat_pci_driver);
-}
-
-module_exit(ioat_exit_module);
diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
index bf4dad7..0b8ffbd 100644
--- a/drivers/dma/ioatdma.h
+++ b/drivers/dma/ioatdma.h
@@ -31,22 +31,21 @@
 #define IOAT_LOW_COMPLETION_MASK	0xffffffc0
 
 /**
- * struct ioat_device - internal representation of a IOAT device
+ * struct ioatdma_device - internal representation of a IOAT device
  * @pdev: PCI-Express device
  * @reg_base: MMIO register space base address
  * @dma_pool: for allocating DMA descriptors
  * @common: embedded struct dma_device
- * @msi: Message Signaled Interrupt number
+ * @version: version of ioatdma device
  */
 
-struct ioat_device {
+struct ioatdma_device {
 	struct pci_dev *pdev;
 	void __iomem *reg_base;
 	struct pci_pool *dma_pool;
 	struct pci_pool *completion_pool;
-
 	struct dma_device common;
-	u8 msi;
+	u8 version;
 };
 
 /**
@@ -84,7 +83,7 @@ struct ioat_dma_chan {
 
 	int pending;
 
-	struct ioat_device *device;
+	struct ioatdma_device *device;
 	struct dma_chan common;
 
 	dma_addr_t completion_addr;
@@ -117,4 +116,13 @@ struct ioat_desc_sw {
 	struct dma_async_tx_descriptor async_tx;
 };
 
+#if defined(CONFIG_INTEL_IOATDMA) || defined(CONFIG_INTEL_IOATDMA_MODULE)
+struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
+				      void __iomem *iobase);
+void ioat_dma_remove(struct ioatdma_device *device);
+#else
+#define ioat_dma_probe(pdev, iobase)    NULL
+#define ioat_dma_remove(device)         do { } while (0)
+#endif
+
 #endif /* IOATDMA_H */
diff --git a/drivers/dma/ioatdma_hw.h b/drivers/dma/ioatdma_hw.h
index 4d7a128..9e7434e 100644
--- a/drivers/dma/ioatdma_hw.h
+++ b/drivers/dma/ioatdma_hw.h
@@ -27,7 +27,7 @@
 #define IOAT_PCI_RID			0x00
 #define IOAT_PCI_SVID			0x8086
 #define IOAT_PCI_SID			0x8086
-#define IOAT_VER			0x12	/* Version 1.2 */
+#define IOAT_VER_1_2			0x12	/* Version 1.2 */
 
 struct ioat_dma_descriptor {
 	uint32_t	size;
