Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbYHUErf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbYHUErf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYHUErH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:47:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:60653 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYHUErF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:47:05 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/9] usb: remove code associated with !CONFIG_PPC_MERGE
Date: Wed, 20 Aug 2008 23:46:50 -0500
Message-Id: <1219294018-12557-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
CC: linux-usb@vger.kernel.org
CC: dbrownell@users.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore remove
the dead code associated with !CONFIG_PPC_MERGE.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/usb/host/ehci-hcd.c     |    5 -
 drivers/usb/host/ehci-ppc-soc.c |  201 ---------------------------------------
 drivers/usb/host/ehci.h         |    9 --
 drivers/usb/host/ohci.h         |    8 --
 4 files changed, 0 insertions(+), 223 deletions(-)
 delete mode 100644 drivers/usb/host/ehci-ppc-soc.c

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index d9d53f2..84ed135 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1014,11 +1014,6 @@ MODULE_LICENSE ("GPL");
 #define	PS3_SYSTEM_BUS_DRIVER	ps3_ehci_driver
 #endif
 
-#if defined(CONFIG_440EPX) && !defined(CONFIG_PPC_MERGE)
-#include "ehci-ppc-soc.c"
-#define	PLATFORM_DRIVER		ehci_ppc_soc_driver
-#endif
-
 #ifdef CONFIG_USB_EHCI_HCD_PPC_OF
 #include "ehci-ppc-of.c"
 #define OF_PLATFORM_DRIVER	ehci_hcd_ppc_of_driver
diff --git a/drivers/usb/host/ehci-ppc-soc.c b/drivers/usb/host/ehci-ppc-soc.c
deleted file mode 100644
index 529590e..0000000
--- a/drivers/usb/host/ehci-ppc-soc.c
+++ /dev/null
@@ -1,201 +0,0 @@
-/*
- * EHCI HCD (Host Controller Driver) for USB.
- *
- * (C) Copyright 2006-2007 Stefan Roese <sr@denx.de>, DENX Software Engineering
- *
- * Bus Glue for PPC On-Chip EHCI driver
- * Tested on AMCC 440EPx
- *
- * Based on "ehci-au1xxx.c" by K.Boge <karsten.boge@amd.com>
- *
- * This file is licenced under the GPL.
- */
-
-#include <linux/platform_device.h>
-
-extern int usb_disabled(void);
-
-/* called during probe() after chip reset completes */
-static int ehci_ppc_soc_setup(struct usb_hcd *hcd)
-{
-	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
-	int		retval;
-
-	retval = ehci_halt(ehci);
-	if (retval)
-		return retval;
-
-	retval = ehci_init(hcd);
-	if (retval)
-		return retval;
-
-	ehci->sbrn = 0x20;
-	return ehci_reset(ehci);
-}
-
-/**
- * usb_ehci_ppc_soc_probe - initialize PPC-SoC-based HCDs
- * Context: !in_interrupt()
- *
- * Allocates basic resources for this USB host controller, and
- * then invokes the start() method for the HCD associated with it
- * through the hotplug entry's driver_data.
- *
- */
-int usb_ehci_ppc_soc_probe(const struct hc_driver *driver,
-			   struct usb_hcd **hcd_out,
-			   struct platform_device *dev)
-{
-	int retval;
-	struct usb_hcd *hcd;
-	struct ehci_hcd *ehci;
-
-	if (dev->resource[1].flags != IORESOURCE_IRQ) {
-		pr_debug("resource[1] is not IORESOURCE_IRQ");
-		retval = -ENOMEM;
-	}
-	hcd = usb_create_hcd(driver, &dev->dev, "PPC-SOC EHCI");
-	if (!hcd)
-		return -ENOMEM;
-	hcd->rsrc_start = dev->resource[0].start;
-	hcd->rsrc_len = dev->resource[0].end - dev->resource[0].start + 1;
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_debug("request_mem_region failed");
-		retval = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		pr_debug("ioremap failed");
-		retval = -ENOMEM;
-		goto err2;
-	}
-
-	ehci = hcd_to_ehci(hcd);
-	ehci->big_endian_mmio = 1;
-	ehci->big_endian_desc = 1;
-	ehci->caps = hcd->regs;
-	ehci->regs = hcd->regs + HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
-
-	/* cache this readonly data; minimize chip reads */
-	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
-
-#if defined(CONFIG_440EPX)
-	/*
-	 * 440EPx Errata USBH_3
-	 * Fix: Enable Break Memory Transfer (BMT) in INSNREG3
-	 */
-	out_be32((void *)((ulong)(&ehci->regs->command) + 0x8c), (1 << 0));
-	ehci_dbg(ehci, "Break Memory Transfer (BMT) has beed enabled!\n");
-#endif
-
-	retval = usb_add_hcd(hcd, dev->resource[1].start, IRQF_DISABLED);
-	if (retval == 0)
-		return retval;
-
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err1:
-	usb_put_hcd(hcd);
-	return retval;
-}
-
-/* may be called without controller electrically present */
-/* may be called with controller, bus, and devices active */
-
-/**
- * usb_ehci_hcd_ppc_soc_remove - shutdown processing for PPC-SoC-based HCDs
- * @dev: USB Host Controller being removed
- * Context: !in_interrupt()
- *
- * Reverses the effect of usb_ehci_hcd_ppc_soc_probe(), first invoking
- * the HCD's stop() method.  It is always called from a thread
- * context, normally "rmmod", "apmd", or something similar.
- *
- */
-void usb_ehci_ppc_soc_remove(struct usb_hcd *hcd, struct platform_device *dev)
-{
-	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-	usb_put_hcd(hcd);
-}
-
-static const struct hc_driver ehci_ppc_soc_hc_driver = {
-	.description = hcd_name,
-	.product_desc = "PPC-SOC EHCI",
-	.hcd_priv_size = sizeof(struct ehci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq = ehci_irq,
-	.flags = HCD_MEMORY | HCD_USB2,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset = ehci_ppc_soc_setup,
-	.start = ehci_run,
-	.stop = ehci_stop,
-	.shutdown = ehci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue = ehci_urb_enqueue,
-	.urb_dequeue = ehci_urb_dequeue,
-	.endpoint_disable = ehci_endpoint_disable,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number = ehci_get_frame,
-
-	/*
-	 * root hub support
-	 */
-	.hub_status_data = ehci_hub_status_data,
-	.hub_control = ehci_hub_control,
-	.bus_suspend = ehci_bus_suspend,
-	.bus_resume = ehci_bus_resume,
-	.relinquish_port = ehci_relinquish_port,
-	.port_handed_over = ehci_port_handed_over,
-};
-
-static int ehci_hcd_ppc_soc_drv_probe(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = NULL;
-	int ret;
-
-	pr_debug("In ehci_hcd_ppc_soc_drv_probe\n");
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	/* FIXME we only want one one probe() not two */
-	ret = usb_ehci_ppc_soc_probe(&ehci_ppc_soc_hc_driver, &hcd, pdev);
-	return ret;
-}
-
-static int ehci_hcd_ppc_soc_drv_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	/* FIXME we only want one one remove() not two */
-	usb_ehci_ppc_soc_remove(hcd, pdev);
-	return 0;
-}
-
-MODULE_ALIAS("platform:ppc-soc-ehci");
-static struct platform_driver ehci_ppc_soc_driver = {
-	.probe = ehci_hcd_ppc_soc_drv_probe,
-	.remove = ehci_hcd_ppc_soc_drv_remove,
-	.shutdown = usb_hcd_platform_shutdown,
-	.driver = {
-		.name = "ppc-soc-ehci",
-	}
-};
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 5799298..8a09842 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -740,16 +740,7 @@ ehci_port_speed(struct ehci_hcd *ehci, unsigned int portsc)
 /*
  * Big-endian read/write functions are arch-specific.
  * Other arches can be added if/when they're needed.
- *
- * REVISIT: arch/powerpc now has readl/writel_be, so the
- * definition below can die once the 4xx support is
- * finally ported over.
  */
-#if defined(CONFIG_PPC) && !defined(CONFIG_PPC_MERGE)
-#define readl_be(addr)		in_be32((__force unsigned *)addr)
-#define writel_be(val, addr)	out_be32((__force unsigned *)addr, val)
-#endif
-
 #if defined(CONFIG_ARM) && defined(CONFIG_ARCH_IXP4XX)
 #define readl_be(addr)		__raw_readl((__force unsigned *)addr)
 #define writel_be(val, addr)	__raw_writel(val, (__force unsigned *)addr)
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index faf622e..222011f 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -540,15 +540,7 @@ static inline struct usb_hcd *ohci_to_hcd (const struct ohci_hcd *ohci)
  * Big-endian read/write functions are arch-specific.
  * Other arches can be added if/when they're needed.
  *
- * REVISIT: arch/powerpc now has readl/writel_be, so the
- * definition below can die once the STB04xxx support is
- * finally ported over.
  */
-#if defined(CONFIG_PPC) && !defined(CONFIG_PPC_MERGE)
-#define readl_be(addr)		in_be32((__force unsigned *)addr)
-#define writel_be(val, addr)	out_be32((__force unsigned *)addr, val)
-#endif
-
 static inline unsigned int _ohci_readl (const struct ohci_hcd *ohci,
 					__hc32 __iomem * regs)
 {
-- 
1.5.5.1

