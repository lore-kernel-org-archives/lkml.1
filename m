Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYIQIf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYIQIf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYIQIfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:35:13 -0400
Received: from www.tglx.de ([62.245.132.106]:53458 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbYIQIfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:35:11 -0400
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 1/1] uio: add automata sercos3 pci card support
From: John Ogness <john.ogness@linutronix.de>
References: <86d4j4z9xi.fsf@johno-ibook.fn.ogness.net>
Date: Wed, 17 Sep 2008 10:35:03 +0200
In-Reply-To: <86d4j4z9xi.fsf@johno-ibook.fn.ogness.net> (John Ogness's message of "Tue\, 16 Sep 2008 12\:01\:29 +0200")
Message-ID: <86d4j3f9vs.fsf@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kernel-side support for the Sercos III PCI card from
Automata GmbH. An example of such a card can be found here:

http://www.automataweb.com/en/kat/uid_kategorien/0000119/id_matchcode/PCI_SERC_III/bop/0/print/false/chksum/9b334826704320c91437abc5c8ff48d1/beetools.html

Automata is currently working on getting the userspace-part organized
for easy download access and use. At the time of this writing, the
userspace-part is not yet available for download.

I wish to be personally CC'ed on answers/comments posted to the list
in response to this posting.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/uio/Kconfig       |   13 ++
 drivers/uio/Makefile      |    1 
 drivers/uio/uio_sercos3.c |  229 ++++++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+)
diff -uprN a/drivers/uio/Kconfig b/drivers/uio/Kconfig
--- a/drivers/uio/Kconfig	2008-09-15 15:39:32.000000000 +0200
+++ b/drivers/uio/Kconfig	2008-09-16 12:13:24.000000000 +0200
@@ -58,4 +58,17 @@ config UIO_SMX
 
 	  If you compile this as a module, it will be called uio_smx.
 
+config UIO_SERCOS3
+	tristate "Automata Sercos III PCI card driver"
+	default n
+	help
+	  Userspace I/O interface for the Sercos III PCI card from
+	  Automata GmbH. The userspace part of this driver will be
+	  available for download from the Automata GmbH web site.
+
+	  Automata GmbH:        http://www.automataweb.com
+	  Sercos III interface: http://www.sercos.com
+
+	  If you compile this as a module, it will be called uio_sercos3.
+
 endif
diff -uprN a/drivers/uio/Makefile b/drivers/uio/Makefile
--- a/drivers/uio/Makefile	2008-09-15 15:39:32.000000000 +0200
+++ b/drivers/uio/Makefile	2008-09-15 15:20:21.000000000 +0200
@@ -3,3 +3,4 @@ obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
 obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
 obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
+obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
diff -uprN a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
--- a/drivers/uio/uio_sercos3.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/uio/uio_sercos3.c	2008-09-17 09:54:54.000000000 +0200
@@ -0,0 +1,229 @@
+/* sercos3: UIO driver for the Automata Sercos III PCI card
+
+   Copyright (C) 2008 Linutronix GmbH
+     Author: John Ogness <john.ogness@linutronix.de>
+*/
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/uio_driver.h>
+#include <linux/io.h>
+
+/* ID's for SERCOS III PCI card (PLX 9030) */
+#define SERCOS_SUB_VENDOR_ID  0x1971
+#define SERCOS_SUB_SYSID_3530 0x3530
+#define SERCOS_SUB_SYSID_3535 0x3535
+#define SERCOS_SUB_SYSID_3780 0x3780
+
+/* Interrupt Enable Register */
+#define IER0_OFFSET 0x08
+
+/* Interrupt Status Register */
+#define ISR0_OFFSET 0x18
+
+struct sercos3_priv {
+	u32 ier0_cache;
+	spinlock_t ier0_cache_lock;
+};
+
+/* this function assumes ier0_cache_lock is locked! */
+static void sercos3_disable_interrupts(struct uio_info *info,
+				       struct sercos3_priv *priv)
+{
+	void __iomem *ier0 = info->mem[3].internal_addr + IER0_OFFSET;
+	u32 tmp = ioread32(ier0);
+
+	if (tmp) {
+		/* store previously enabled interrupts */
+		priv->ier0_cache |= tmp;
+
+		/* disable interrupts */
+		iowrite32(0, ier0);
+	}
+}
+
+/* this function assumes ier0_cache_lock is locked! */
+static void sercos3_enable_interrupts(struct uio_info *info,
+				      struct sercos3_priv *priv)
+{
+	void __iomem *ier0 = info->mem[3].internal_addr + IER0_OFFSET;
+
+	if (priv->ier0_cache) {
+		/* restore previously enabled interrupts */
+		iowrite32(priv->ier0_cache, ier0);
+		priv->ier0_cache = 0;
+	}
+
+}
+
+static irqreturn_t sercos3_handler(int irq, struct uio_info *info)
+{
+	struct sercos3_priv *priv = info->priv;
+	void __iomem *isr0 = info->mem[3].internal_addr + ISR0_OFFSET;
+
+	if (!ioread32(isr0))
+		return IRQ_NONE;
+
+	spin_lock(&priv->ier0_cache_lock);
+	sercos3_disable_interrupts(info, priv);
+	spin_unlock(&priv->ier0_cache_lock);
+
+	return IRQ_HANDLED;
+}
+
+static int sercos3_irqcontrol(struct uio_info *info, s32 irq_on)
+{
+	struct sercos3_priv *priv = info->priv;
+
+	spin_lock_irq(&priv->ier0_cache_lock);
+	if (irq_on)
+		sercos3_enable_interrupts(info, priv);
+	else
+		sercos3_disable_interrupts(info, priv);
+	spin_unlock_irq(&priv->ier0_cache_lock);
+
+	return 0;
+}
+
+static int sercos3_setup_iomem(struct pci_dev *dev, struct uio_info *info,
+			       int n, int pci_bar)
+{
+	info->mem[n].addr = pci_resource_start(dev, pci_bar);
+	if (!info->mem[n].addr)
+		return -1;
+	info->mem[n].internal_addr = ioremap(pci_resource_start(dev, pci_bar),
+					     pci_resource_len(dev, pci_bar));
+	if (!info->mem[n].internal_addr)
+		return -1;
+	info->mem[n].size = pci_resource_len(dev, pci_bar);
+	info->mem[n].memtype = UIO_MEM_PHYS;
+	return 0;
+}
+
+static int __devinit sercos3_pci_probe(struct pci_dev *dev,
+				       const struct pci_device_id *id)
+{
+	struct uio_info *info;
+	struct sercos3_priv *priv;
+	int i;
+
+	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	priv = kzalloc(sizeof(struct sercos3_priv), GFP_KERNEL);
+	if (!priv)
+		goto out_free;
+
+	if (pci_enable_device(dev))
+		goto out_free_priv;
+
+	if (pci_request_regions(dev, "sercos3"))
+		goto out_disable;
+
+	/* we only need PCI BAR's 0, 2, 3, 4, 5 */
+	if (sercos3_setup_iomem(dev, info, 0, 0))
+		goto out_unmap;
+	if (sercos3_setup_iomem(dev, info, 1, 2))
+		goto out_unmap;
+	if (sercos3_setup_iomem(dev, info, 2, 3))
+		goto out_unmap;
+	if (sercos3_setup_iomem(dev, info, 3, 4))
+		goto out_unmap;
+	if (sercos3_setup_iomem(dev, info, 4, 5))
+		goto out_unmap;
+
+	spin_lock_init(&priv->ier0_cache_lock);
+	info->priv = priv;
+	info->name = "Sercos_III_PCI";
+	info->version = "0.0.1";
+	info->irq = dev->irq;
+	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->handler = sercos3_handler;
+	info->irqcontrol = sercos3_irqcontrol;
+
+	pci_set_drvdata(dev, info);
+
+	if (uio_register_device(&dev->dev, info))
+		goto out_unmap;
+
+	return 0;
+
+out_unmap:
+	for (i = 0; i < 5; i++) {
+		if (info->mem[i].internal_addr)
+			iounmap(info->mem[i].internal_addr);
+	}
+	pci_release_regions(dev);
+out_disable:
+	pci_disable_device(dev);
+out_free_priv:
+	kfree(priv);
+out_free:
+	kfree(info);
+	return -ENODEV;
+}
+
+static void sercos3_pci_remove(struct pci_dev *dev)
+{
+	struct uio_info *info = pci_get_drvdata(dev);
+	int i;
+
+	uio_unregister_device(info);
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	pci_set_drvdata(dev, NULL);
+	for (i = 0; i < 5; i++) {
+		if (info->mem[i].internal_addr)
+			iounmap(info->mem[i].internal_addr);
+	}
+	kfree(info->priv);
+	kfree(info);
+}
+
+static struct pci_device_id sercos3_pci_ids[] __devinitdata = {
+	{
+		.vendor =       PCI_VENDOR_ID_PLX,
+		.device =       PCI_DEVICE_ID_PLX_9030,
+		.subvendor =    SERCOS_SUB_VENDOR_ID,
+		.subdevice =    SERCOS_SUB_SYSID_3530,
+	},
+	{
+		.vendor =       PCI_VENDOR_ID_PLX,
+		.device =       PCI_DEVICE_ID_PLX_9030,
+		.subvendor =    SERCOS_SUB_VENDOR_ID,
+		.subdevice =    SERCOS_SUB_SYSID_3535,
+	},
+	{
+		.vendor =       PCI_VENDOR_ID_PLX,
+		.device =       PCI_DEVICE_ID_PLX_9030,
+		.subvendor =    SERCOS_SUB_VENDOR_ID,
+		.subdevice =    SERCOS_SUB_SYSID_3780,
+	},
+	{ 0, }
+};
+
+static struct pci_driver sercos3_pci_driver = {
+	.name = "sercos3",
+	.id_table = sercos3_pci_ids,
+	.probe = sercos3_pci_probe,
+	.remove = sercos3_pci_remove,
+};
+
+static int __init sercos3_init_module(void)
+{
+	return pci_register_driver(&sercos3_pci_driver);
+}
+
+static void __exit sercos3_exit_module(void)
+{
+	pci_unregister_driver(&sercos3_pci_driver);
+}
+
+module_init(sercos3_init_module);
+module_exit(sercos3_exit_module);
+
+MODULE_DESCRIPTION("UIO driver for the Automata Sercos III PCI card");
+MODULE_AUTHOR("John Ogness <john.ogness@linutronix.de>");
+MODULE_LICENSE("GPL v2");
