Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZFWP4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZFWP4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbZFWP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:56:15 -0400
Received: from mail.atmel.fr ([81.80.104.162]:43744 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762AbZFWP4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:56:11 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-usb@vger.kernel.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, nicolas.ferre@atmel.com
Subject: [PATCH 3/3 v3] at91/USB: Add USB EHCI driver for at91sam9g45 series
Date: Tue, 23 Jun 2009 18:58:37 +0200
Message-Id: <1245776317-7134-3-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <200906190045.16496.david-b@pacbell.net>
References: <200906190045.16496.david-b@pacbell.net>
Message-Id: <ef5db5944ede0d28d87f908232c77c34f87b0578.1245775871.git.nicolas.ferre@atmel.com>
In-Reply-To: <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com>
References: <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add host USB High speed driver for at91sam9g45 series.
The host driver is an EHCI with its companion OHCI. EHCI is
handled by the new ehci-atmel.c whereas the OHCI is always
handled by ohci-at91.c.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2 -> v3: split patch to:
- gadget
- ohci
- ehci

 drivers/usb/Kconfig           |    1 +
 drivers/usb/host/ehci-atmel.c |  232 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c   |    5 +
 3 files changed, 238 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/host/ehci-atmel.c

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index c6c816b..3974c9c 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -57,6 +57,7 @@ config USB_ARCH_HAS_EHCI
 	default y if PPC_83xx
 	default y if SOC_AU1200
 	default y if ARCH_IXP4XX
+	default y if ARCH_AT91SAM9G45
 	default PCI
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
new file mode 100644
index 0000000..3095403
--- /dev/null
+++ b/drivers/usb/host/ehci-atmel.c
@@ -0,0 +1,232 @@
+/*
+ * Driver for EHCI UHP on Atmel chips
+ *
+ *  Copyright (C) 2009 Atmel Corporation,
+ *                     Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ *  Based on various ehci-*.c drivers
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+/* interface and function clocks */
+static struct clk *iclk, *fclk;
+static int clocked;
+
+/*-------------------------------------------------------------------------*/
+
+static void atmel_start_clock(void)
+{
+	clk_enable(iclk);
+	clk_enable(fclk);
+	clocked = 1;
+}
+
+static void atmel_stop_clock(void)
+{
+	clk_disable(fclk);
+	clk_disable(iclk);
+	clocked = 0;
+}
+
+static void atmel_start_ehci(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "start\n");
+	atmel_start_clock();
+}
+
+static void atmel_stop_ehci(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "stop\n");
+	atmel_stop_clock();
+}
+
+/*-------------------------------------------------------------------------*/
+
+static int ehci_atmel_setup(struct usb_hcd *hcd)
+{
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	int retval = 0;
+
+	/* registers start at offset 0x0 */
+	ehci->caps = hcd->regs;
+	ehci->regs = hcd->regs +
+		HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	dbg_hcs_params(ehci, "reset");
+	dbg_hcc_params(ehci, "reset");
+
+	/* cache this readonly data; minimize chip reads */
+	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+
+	retval = ehci_halt(ehci);
+	if (retval)
+		return retval;
+
+	/* data structure init */
+	retval = ehci_init(hcd);
+	if (retval)
+		return retval;
+
+	ehci->sbrn = 0x20;
+
+	ehci_reset(ehci);
+	ehci_port_power(ehci, 0);
+
+	return retval;
+}
+
+static const struct hc_driver ehci_atmel_hc_driver = {
+	.description		= hcd_name,
+	.product_desc		= "Atmel EHCI UHP HS",
+	.hcd_priv_size		= sizeof(struct ehci_hcd),
+
+	/* generic hardware linkage */
+	.irq			= ehci_irq,
+	.flags			= HCD_MEMORY | HCD_USB2,
+
+	/* basic lifecycle operations */
+	.reset			= ehci_atmel_setup,
+	.start			= ehci_run,
+	.stop			= ehci_stop,
+	.shutdown		= ehci_shutdown,
+
+	/* managing i/o requests and associated device resources */
+	.urb_enqueue		= ehci_urb_enqueue,
+	.urb_dequeue		= ehci_urb_dequeue,
+	.endpoint_disable	= ehci_endpoint_disable,
+
+	/* scheduling support */
+	.get_frame_number	= ehci_get_frame,
+
+	/* root hub support */
+	.hub_status_data	= ehci_hub_status_data,
+	.hub_control		= ehci_hub_control,
+	.bus_suspend		= ehci_bus_suspend,
+	.bus_resume		= ehci_bus_resume,
+	.relinquish_port	= ehci_relinquish_port,
+	.port_handed_over	= ehci_port_handed_over,
+};
+
+static int __init ehci_atmel_drv_probe(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+	const struct hc_driver *driver = &ehci_atmel_hc_driver;
+	struct resource *res;
+	int irq;
+	int retval;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_debug("Initializing Atmel-SoC USB Host Controller\n");
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(&pdev->dev,
+			"Found HC with no IRQ. Check %s setup!\n",
+			dev_name(&pdev->dev));
+		retval = -ENODEV;
+		goto fail_create_hcd;
+	}
+
+	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
+	if (!hcd) {
+		retval = -ENOMEM;
+		goto fail_create_hcd;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev,
+			"Found HC with no register addr. Check %s setup!\n",
+			dev_name(&pdev->dev));
+		retval = -ENODEV;
+		goto fail_request_resource;
+	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = res->end - res->start + 1;
+
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
+				driver->description)) {
+		dev_dbg(&pdev->dev, "controller already in use\n");
+		retval = -EBUSY;
+		goto fail_request_resource;
+	}
+
+	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+	if (hcd->regs == NULL) {
+		dev_dbg(&pdev->dev, "error mapping memory\n");
+		retval = -EFAULT;
+		goto fail_ioremap;
+	}
+
+	iclk = clk_get(&pdev->dev, "ehci_clk");
+	if (IS_ERR(iclk)) {
+		dev_err(&pdev->dev, "Error getting interface clock\n");
+		retval = -ENOENT;
+		goto fail_get_iclk;
+	}
+	fclk = clk_get(&pdev->dev, "uhpck");
+	if (IS_ERR(fclk)) {
+		dev_err(&pdev->dev, "Error getting function clock\n");
+		retval = -ENOENT;
+		goto fail_get_fclk;
+	}
+
+	atmel_start_ehci(pdev);
+
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (retval)
+		goto fail_add_hcd;
+
+	return retval;
+
+fail_add_hcd:
+	atmel_stop_ehci(pdev);
+	clk_put(fclk);
+fail_get_fclk:
+	clk_put(iclk);
+fail_get_iclk:
+	iounmap(hcd->regs);
+fail_ioremap:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+fail_request_resource:
+	usb_put_hcd(hcd);
+fail_create_hcd:
+	dev_err(&pdev->dev, "init %s fail, %d\n",
+		dev_name(&pdev->dev), retval);
+
+	return retval;
+}
+
+static int __exit ehci_atmel_drv_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	ehci_shutdown(hcd);
+	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+	usb_put_hcd(hcd);
+
+	atmel_stop_ehci(pdev);
+	clk_put(fclk);
+	clk_put(iclk);
+	fclk = iclk = NULL;
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:atmel-ehci");
+
+static struct platform_driver ehci_atmel_driver = {
+	.probe		= ehci_atmel_drv_probe,
+	.remove		= __exit_p(ehci_atmel_drv_remove),
+	.shutdown	= usb_hcd_platform_shutdown,
+	.driver.name	= "atmel-ehci",
+};
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index c637207..df2ddee 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1072,6 +1072,11 @@ MODULE_LICENSE ("GPL");
 #define	PLATFORM_DRIVER		ixp4xx_ehci_driver
 #endif
 
+#ifdef CONFIG_ARCH_AT91
+#include "ehci-atmel.c"
+#define	PLATFORM_DRIVER		ehci_atmel_driver
+#endif
+
 #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
     !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER)
 #error "missing bus glue for ehci-hcd"
-- 
1.5.3.7

