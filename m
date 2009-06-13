Return-Path: <linux-kernel-owner+w=401wt.eu-S933655AbZFMBOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbZFMBOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 21:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZFMBOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 21:14:35 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:56008 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZFMBOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 21:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w6yDz55VbhAvljnaMEJi7PgdBtWPgEVGMevkf1OYzaB4bj+akLLURzRTdhgJPXuLVC
         Yf8gGtB7ACu82EbuVS7kDxsrtzgNVYl1rOHKr8g/5RyIVtOSMTldCXV32tcAxE2uAP9T
         FqMaPZDU+LYFa82FoEgjoB4+FxUvUuQYAP6DQ=
Message-ID: <4A32FD74.3050608@gmail.com>
Date: Sat, 13 Jun 2009 09:14:28 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Wan ZongShun <mcuos.com@gmail.com>, David Brownell <david-b@pacbell.net>
CC: Eric Miao <eric.y.miao@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add nuvoton Ehci driver to usb tree
References: <4A2A5131.3010200@gmail.com> <f17812d70906070742s77ff0ae7tb984e7a812f182ef@mail.gmail.com> <4A2D2DF7.8050806@gmail.com>
In-Reply-To: <4A2D2DF7.8050806@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sirs,

According Eric's advice,I changed my patch,

Would you like to give me some advice again?
---

Add ehci support for w90p910 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 drivers/usb/Kconfig             |    2 +
 drivers/usb/host/Kconfig        |    6 ++
 drivers/usb/host/ehci-hcd.c     |    5 +
 drivers/usb/host/ehci-w90x900.c |  181 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 194 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/host/ehci-w90x900.c

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index c6c816b..6696abe 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -38,6 +38,7 @@ config USB_ARCH_HAS_OHCI
 	default y if ARCH_AT91
 	default y if ARCH_PNX4008 && I2C
 	default y if MFD_TC6393XB
+	default y if ARCH_W90X900
 	# PPC:
 	default y if STB03xxx
 	default y if PPC_MPC52xx
@@ -57,6 +58,7 @@ config USB_ARCH_HAS_EHCI
 	default y if PPC_83xx
 	default y if SOC_AU1200
 	default y if ARCH_IXP4XX
+	default y if ARCH_W90X900
 	default PCI
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 845479f..dfbe586 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -93,6 +93,12 @@ config USB_EHCI_HCD_PPC_OF
 	  Enables support for the USB controller present on the PowerPC
 	  OpenFirmware platform bus.
 
+config USB_W90X900_EHCI
+	bool "W90X900(W90P910) EHCI support"
+	depends on USB_EHCI_HCD && ARCH_W90X900
+	---help---
+		Enables support for the W90X900 USB controller
+
 config USB_OXU210HP_HCD
 	tristate "OXU210HP HCD support"
 	depends on USB
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index c637207..bdb0372 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1072,6 +1072,11 @@ MODULE_LICENSE ("GPL");
 #define	PLATFORM_DRIVER		ixp4xx_ehci_driver
 #endif
 
+#ifdef CONFIG_USB_W90X900_EHCI
+#include "ehci-w90x900.c"
+#define	PLATFORM_DRIVER		ehci_hcd_w90x900_driver
+#endif
+
 #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
     !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER)
 #error "missing bus glue for ehci-hcd"
diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
new file mode 100644
index 0000000..cfa21ea
--- /dev/null
+++ b/drivers/usb/host/ehci-w90x900.c
@@ -0,0 +1,181 @@
+/*
+ * linux/driver/usb/host/ehci-w90x900.c
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/platform_device.h>
+
+/*ebable phy0 and phy1 for w90p910*/
+#define	ENPHY		(0x01<<8)
+#define PHY0_CTR	(0xA4)
+#define PHY1_CTR	(0xA8)
+
+static int __devinit usb_w90x900_probe(const struct hc_driver *driver,
+		      struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+	struct ehci_hcd *ehci;
+	struct resource *res;
+	int retval = 0, irq;
+	unsigned long val;
+
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		retval = -ENXIO;
+		goto err1;
+	}
+
+	hcd = usb_create_hcd(driver, &pdev->dev, "w90x900 EHCI");
+	if (!hcd) {
+		retval = -ENOMEM;
+		goto err1;
+	}
+
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = res->end - res->start + 1;
+
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
+		retval = -EBUSY;
+		goto err2;
+	}
+
+	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	if (hcd->regs == NULL) {
+		retval = -EFAULT;
+		goto err3;
+	}
+
+	ehci = hcd_to_ehci(hcd);
+	ehci->caps = hcd->regs;
+	ehci->regs = hcd->regs +
+		 HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+
+	/* enable PHY 0,1,the regs only apply to w90p910
+	*  0xA4,0xA8 were offsets of PHY0 and PHY1 controller of
+	*  w90p910 IC relative to ehci->regs.
+	*/
+	val = __raw_readl(ehci->regs+PHY0_CTR);
+	val |= ENPHY;
+	__raw_writel(val, ehci->regs+PHY0_CTR);
+
+	val = __raw_readl(ehci->regs+PHY1_CTR);
+	val |= ENPHY;
+	__raw_writel(val, ehci->regs+PHY1_CTR);
+
+	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+	ehci->sbrn = 0x20;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		goto err4;
+
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (retval != 0)
+		goto err4;
+
+	ehci_writel(ehci, 1, &ehci->regs->configured_flag);
+
+	return retval;
+err4:
+	iounmap(hcd->regs);
+err3:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+err2:
+	usb_put_hcd(hcd);
+err1:
+	return retval;
+}
+
+static
+void usb_w90x900_remove(struct usb_hcd *hcd, struct platform_device *pdev)
+{
+	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+	usb_put_hcd(hcd);
+}
+
+static const struct hc_driver ehci_w90x900_hc_driver = {
+	.description = hcd_name,
+	.product_desc = "Nuvoton w90x900 EHCI Host Controller",
+	.hcd_priv_size = sizeof(struct ehci_hcd),
+
+	/*
+	 * generic hardware linkage
+	 */
+	.irq = ehci_irq,
+	.flags = HCD_USB2|HCD_MEMORY,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset = ehci_init,
+	.start = ehci_run,
+
+	.stop = ehci_stop,
+	.shutdown = ehci_shutdown,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue = ehci_urb_enqueue,
+	.urb_dequeue = ehci_urb_dequeue,
+	.endpoint_disable = ehci_endpoint_disable,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number = ehci_get_frame,
+
+	/*
+	 * root hub support
+	 */
+	.hub_status_data = ehci_hub_status_data,
+	.hub_control = ehci_hub_control,
+#ifdef	CONFIG_PM
+	.bus_suspend = ehci_bus_suspend,
+	.bus_resume = ehci_bus_resume,
+#endif
+	.relinquish_port	= ehci_relinquish_port,
+	.port_handed_over	= ehci_port_handed_over,
+};
+
+static int __devinit ehci_w90x900_probe(struct platform_device *pdev)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	return usb_w90x900_probe(&ehci_w90x900_hc_driver, pdev);
+}
+
+static int __devexit ehci_w90x900_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	usb_w90x900_remove(hcd, pdev);
+
+	return 0;
+}
+
+static struct platform_driver ehci_hcd_w90x900_driver = {
+	.probe  = ehci_w90x900_probe,
+	.remove = __devexit_p(ehci_w90x900_remove),
+	.driver = {
+		.name = "w90x900-ehci",
+		.owner = THIS_MODULE,
+	},
+};
+
+MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
+MODULE_DESCRIPTION("w90p910 usb ehci driver!");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:w90p910-ehci");
-- 
1.5.6.3

