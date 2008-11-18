Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYKRJUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYKRJUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYKRJUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:20:11 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:22919 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYKRJUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:20:07 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62694830"
From: Bryan Wu <cooloney@kernel.org>
To: bigeasy@linutronix.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] USB/ISP1760: Add support for the generic platfrom device centralized driver model (v2)
Date: Tue, 18 Nov 2008 17:21:33 +0800
Message-Id: <1227000093-19034-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

v2-v1:
 - cleanup style issue
 - add Kconfig option CONFIG_USB_ISP1760_PDEV
 - isp1760 interrupt is default setup TRIGGER_LOW

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/host/Kconfig      |    6 +++
 drivers/usb/host/isp1760-if.c |   95 +++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/isp1760.h   |   19 ++++++++
 3 files changed, 120 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/usb/isp1760.h

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 427b3ac..1e38e8a 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -123,6 +123,12 @@ config USB_ISP1760_HCD
 	  To compile this driver as a module, choose M here: the
 	  module will be called isp1760.
 
+config USB_ISP1760_PDEV
+	bool "Support for the generic platfrom device driver model"
+	depends on USB_ISP1760_HCD
+	---help---
+	  Enables support for the generic platfrom device centralized driver model
+
 config USB_ISP1362_HCD
 	tristate "ISP1362 HCD support"
 	depends on USB
diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index b87ca7c..cf0431c 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -3,6 +3,7 @@
  * Currently there is support for
  * - OpenFirmware
  * - PCI
+ * - PDEV (generic platform device centralized driver model)
  *
  * (c) 2007 Sebastian Siewior <bigeasy@linutronix.de>
  *
@@ -23,6 +24,11 @@
 #include <linux/pci.h>
 #endif
 
+#ifdef CONFIG_USB_ISP1760_PDEV
+#include <linux/platform_device.h>
+#include <linux/usb/isp1760.h>
+#endif
+
 #ifdef CONFIG_PPC_OF
 static int of_isp1760_probe(struct of_device *dev,
 		const struct of_device_id *match)
@@ -286,12 +292,98 @@ static struct pci_driver isp1761_pci_driver = {
 };
 #endif
 
+#ifdef CONFIG_USB_ISP1760_PDEV
+static int __devinit isp1760_pdev_probe(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+	struct resource	*addr;
+	int irq;
+	unsigned int devflags = 0;
+	struct isp1760_platform_data *priv = pdev->dev.platform_data;
+
+	/* basic sanity checks first.  board-specific init logic should
+	 * have initialized these two resources and probably board
+	 * specific platform_data.  we don't probe for IRQs, and do only
+	 * minimal sanity checking.
+	 */
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	if (pdev->num_resources < 2)
+		return -ENODEV;
+
+	addr = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+
+	if (!addr || irq < 0)
+		return -ENODEV;
+
+	if (priv) {
+		if (priv->is_isp1761)
+			devflags |= ISP1760_FLAG_ISP1761;
+		if (priv->port1_disable)
+			devflags |= ISP1760_FLAG_PORT1_DIS;
+		if (priv->bus_width_16)
+			devflags |= ISP1760_FLAG_BUS_WIDTH_16;
+		if (priv->port1_otg)
+			devflags |= ISP1760_FLAG_OTG_EN;
+		if (priv->analog_oc)
+			devflags |= ISP1760_FLAG_ANALOG_OC;
+		if (priv->dack_polarity_high)
+			devflags |= ISP1760_FLAG_DACK_POL_HIGH;
+		if (priv->dreq_polarity_high)
+			devflags |= ISP1760_FLAG_DREQ_POL_HIGH;
+	}
+
+	hcd = isp1760_register(addr->start, resource_size(addr), irq,
+		IRQF_DISABLED | IRQF_SHARED | IRQF_TRIGGER_LOW,
+		&pdev->dev, dev_name(&pdev->dev),
+		devflags);
+
+	if (IS_ERR(hcd))
+		return PTR_ERR(hcd);
+
+	return 0;
+}
+
+static int __devexit
+isp1760_pdev_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
+	usb_put_hcd(hcd);
+	return 0;
+}
+
+struct platform_driver isp1760_pdev_driver = {
+	.probe =	isp1760_pdev_probe,
+	.remove =	__devexit_p(isp1760_pdev_remove),
+	.driver = {
+		.name =	"isp1760-hcd",
+		.owner = THIS_MODULE,
+	},
+};
+#endif /* CONFIG_USB_ISP1760_PDEV */
+
 static int __init isp1760_init(void)
 {
 	int ret;
 
 	init_kmem_once();
 
+#ifdef CONFIG_USB_ISP1760_PDEV
+	ret = platform_driver_register(&isp1760_pdev_driver);
+	if (ret) {
+		deinit_kmem_cache();
+		return ret;
+	}
+#endif
+
 #ifdef CONFIG_PPC_OF
 	ret = of_register_platform_driver(&isp1760_of_driver);
 	if (ret) {
@@ -325,6 +417,9 @@ static void __exit isp1760_exit(void)
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&isp1761_pci_driver);
 #endif
+#ifdef CONFIG_USB_ISP1760_PDEV
+	platform_driver_unregister(&isp1760_pdev_driver);
+#endif
 	deinit_kmem_cache();
 }
 module_exit(isp1760_exit);
diff --git a/include/linux/usb/isp1760.h b/include/linux/usb/isp1760.h
new file mode 100644
index 0000000..74ffbce
--- /dev/null
+++ b/include/linux/usb/isp1760.h
@@ -0,0 +1,19 @@
+/*
+ * board initialization should put one of these into dev->platform_data
+ * and place the isp1760 onto platform_bus named "isp1760-hcd".
+ */
+
+#ifndef __LINUX_USB_ISP1760_H
+#define __LINUX_USB_ISP1760_H
+
+struct isp1760_platform_data {
+	unsigned is_isp1761:1;			/* Chip is ISP1761 */
+	unsigned port1_disable:1;		/* Port 1 disabled */
+	unsigned bus_width_16:1;		/* 16/32-bit data bus width */
+	unsigned port1_otg:1;			/* Port 1 supports OTG */
+	unsigned analog_oc:1;			/* Analog overcurrent */
+	unsigned dack_polarity_high:1;		/* DACK active high */
+	unsigned dreq_polarity_high:1;		/* DREQ active high */
+};
+
+#endif /* __LINUX_USB_ISP1760_H */
-- 
1.5.6.3
