Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbXJYBVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbXJYBVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbXJYBU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:20:56 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:29665 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752552AbXJYBUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:20:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QaF/u/oHuneBaFdo3nyx9jJ/7GApG9ZTDbBSL3CvElArTJoLmqVjw0ylZA8DbfzQlEUCXHfa6iXtWQ9fEd/6mNdvh+82a3J3zknZye7kEfL0XRhONwXt/3GLv5dopnTylqU+X7GBMonxsXIaR8LhDE4YpmiltYge4rF2byadD1A=  ;
X-YMail-OSG: jIiQeGwVM1msNHhkyvoGS4z6L76u6ACws5FPBE.n7zWwF5Eg5vBFhh4xV7TlPEucXlE1F.gvvg--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc1] resource_len() utility function
Date: Wed, 24 Oct 2007 18:20:52 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241820.52376.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new resource_len() function, so drivers can start using this
instead of driver-private code for a common idiom.  The call can be
useful with at least:

 - request_region(), release_region()
 - request_mem_region(), release_mem_region()
 - ioremap()

Candidate drivers include those using platform or PNP busses, and
maybe some others.  PCI already has a similar function.

This patch also updates a representative set of drivers in two
subsystems to use this call (SPI, and USB peripheral/gadget).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Despite comments that we have "needed" this for at least five years,
this is pure cleanup.  IMO it's appropriate for 2.6.25 and to simmer
with the rest of the MM soup for a while.

 drivers/spi/atmel_spi.c           |    2 +-
 drivers/spi/omap2_mcspi.c         |    7 +++----
 drivers/spi/spi_imx.c             |    5 ++---
 drivers/spi/spi_mpc83xx.c         |    2 +-
 drivers/spi/spi_s3c24xx.c         |    4 ++--
 drivers/spi/spi_txx9.c            |    2 +-
 drivers/spi/xilinx_spi.c          |    5 ++---
 drivers/usb/gadget/at91_udc.c     |   12 +++++-------
 drivers/usb/gadget/fsl_usb2_udc.c |    9 ++++-----
 drivers/usb/gadget/omap_udc.c     |    6 +++---
 include/linux/ioport.h            |    5 +++++
 11 files changed, 29 insertions(+), 30 deletions(-)

--- at91.orig/include/linux/ioport.h	2007-10-19 11:38:39.000000000 -0700
+++ at91/include/linux/ioport.h	2007-10-19 14:26:50.000000000 -0700
@@ -22,6 +22,11 @@ struct resource {
 	struct resource *parent, *sibling, *child;
 };
 
+static inline resource_size_t __pure resource_len(const struct resource *r)
+{
+	return r->end + 1 - r->start;
+}
+
 struct resource_list {
 	struct resource_list *next;
 	struct resource *res;
--- at91.orig/drivers/usb/gadget/at91_udc.c	2007-10-13 15:16:13.000000000 -0700
+++ at91/drivers/usb/gadget/at91_udc.c	2007-10-19 14:26:33.000000000 -0700
@@ -1656,9 +1656,7 @@ static int __init at91udc_probe(struct p
 	if (!res)
 		return -ENXIO;
 
-	if (!request_mem_region(res->start,
-			res->end - res->start + 1,
-			driver_name)) {
+	if (!request_mem_region(res->start, resource_len(res), driver_name)) {
 		DBG("someone's using UDC memory\n");
 		return -EBUSY;
 	}
@@ -1670,9 +1668,9 @@ static int __init at91udc_probe(struct p
 	udc->pdev = pdev;
 	udc->enabled = 0;
 
-	udc->udp_baseaddr = ioremap(res->start, res->end - res->start + 1);
+	udc->udp_baseaddr = ioremap(res->start, resource_len(res));
 	if (!udc->udp_baseaddr) {
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_len(res));
 		return -ENOMEM;
 	}
 
@@ -1735,7 +1733,7 @@ static int __init at91udc_probe(struct p
 fail1:
 	device_unregister(&udc->gadget.dev);
 fail0:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_len(res));
 	DBG("%s probe failed, %d\n", driver_name, retval);
 	return retval;
 }
@@ -1761,7 +1759,7 @@ static int __exit at91udc_remove(struct 
 
 	iounmap(udc->udp_baseaddr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_len(res));
 
 	clk_put(udc->iclk);
 	clk_put(udc->fclk);
--- at91.orig/drivers/usb/gadget/fsl_usb2_udc.c	2007-10-13 15:16:13.000000000 -0700
+++ at91/drivers/usb/gadget/fsl_usb2_udc.c	2007-10-19 11:43:12.000000000 -0700
@@ -2268,14 +2268,13 @@ static int __init fsl_udc_probe(struct p
 		return -ENXIO;
 	}
 
-	if (!request_mem_region(res->start, res->end - res->start + 1,
-				driver_name)) {
+	if (!request_mem_region(res->start, resource_len(res), driver_name)) {
 		ERR("request mem region for %s failed \n", pdev->name);
 		kfree(udc_controller);
 		return -EBUSY;
 	}
 
-	dr_regs = ioremap(res->start, res->end - res->start + 1);
+	dr_regs = ioremap(res->start, resource_len(res));
 	if (!dr_regs) {
 		ret = -ENOMEM;
 		goto err1;
@@ -2376,7 +2375,7 @@ err3:
 err2:
 	iounmap(dr_regs);
 err1:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_len(res));
 	kfree(udc_controller);
 	return ret;
 }
@@ -2405,7 +2404,7 @@ static int __exit fsl_udc_remove(struct 
 	dma_pool_destroy(udc_controller->td_pool);
 	free_irq(udc_controller->irq, udc_controller);
 	iounmap(dr_regs);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_len(res));
 
 	device_unregister(&udc_controller->gadget.dev);
 	/* free udc --wait for the release() finished */
--- at91.orig/drivers/usb/gadget/omap_udc.c	2007-10-13 15:16:13.000000000 -0700
+++ at91/drivers/usb/gadget/omap_udc.c	2007-10-19 11:43:12.000000000 -0700
@@ -2758,7 +2758,7 @@ static int __init omap_udc_probe(struct 
 
 	/* NOTE:  "knows" the order of the resources! */
 	if (!request_mem_region(pdev->resource[0].start,
-			pdev->resource[0].end - pdev->resource[0].start + 1,
+			resource_len(&pdev->resource[0]),
 			driver_name)) {
 		DBG("request_mem_region failed\n");
 		return -EBUSY;
@@ -2962,7 +2962,7 @@ cleanup0:
 	}
 
 	release_mem_region(pdev->resource[0].start,
-			pdev->resource[0].end - pdev->resource[0].start + 1);
+			resource_len(&pdev->resource[0]));
 
 	return status;
 }
@@ -3001,7 +3001,7 @@ static int __exit omap_udc_remove(struct
 	}
 
 	release_mem_region(pdev->resource[0].start,
-			pdev->resource[0].end - pdev->resource[0].start + 1);
+			resource_len(&pdev->resource[0]));
 
 	device_unregister(&udc->gadget.dev);
 	wait_for_completion(&done);
--- at91.orig/drivers/spi/atmel_spi.c	2007-10-19 11:38:28.000000000 -0700
+++ at91/drivers/spi/atmel_spi.c	2007-10-19 11:43:12.000000000 -0700
@@ -657,7 +657,7 @@ static int __init atmel_spi_probe(struct
 	spin_lock_init(&as->lock);
 	INIT_LIST_HEAD(&as->queue);
 	as->pdev = pdev;
-	as->regs = ioremap(regs->start, (regs->end - regs->start) + 1);
+	as->regs = ioremap(regs->start, resource_len(regs));
 	if (!as->regs)
 		goto out_free_buffer;
 	as->irq = irq;
--- at91.orig/drivers/spi/omap2_mcspi.c	2007-10-19 11:38:28.000000000 -0700
+++ at91/drivers/spi/omap2_mcspi.c	2007-10-19 11:43:12.000000000 -0700
@@ -964,8 +964,7 @@ static int __init omap2_mcspi_probe(stru
 		status = -ENODEV;
 		goto err1;
 	}
-	if (!request_mem_region(r->start, (r->end - r->start) + 1,
-			pdev->dev.bus_id)) {
+	if (!request_mem_region(r->start, resource_len(r), pdev->dev.bus_id)) {
 		status = -EBUSY;
 		goto err1;
 	}
@@ -1020,7 +1019,7 @@ err3:
 err2:
 	clk_put(mcspi->ick);
 err1a:
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_len(r));
 err1:
 	spi_master_put(master);
 	return status;
@@ -1041,7 +1040,7 @@ static int __exit omap2_mcspi_remove(str
 	clk_put(mcspi->ick);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_len(r));
 
 	spi_unregister_master(master);
 	kfree(dma_channels);
--- at91.orig/drivers/spi/spi_imx.c	2007-10-19 11:38:28.000000000 -0700
+++ at91/drivers/spi/spi_imx.c	2007-10-19 11:43:12.000000000 -0700
@@ -1487,15 +1487,14 @@ static int __init spi_imx_probe(struct p
 		status = -ENODEV;
 		goto err_no_iores;
 	}
-	drv_data->ioarea = request_mem_region(res->start,
-						res->end - res->start + 1,
+	drv_data->ioarea = request_mem_region(res->start, resource_len(res),
 						pdev->name);
 	if (drv_data->ioarea == NULL) {
 		dev_err(&pdev->dev, "probe - cannot reserve region\n");
 		status = -ENXIO;
 		goto err_no_iores;
 	}
-	drv_data->regs = ioremap(res->start, res->end - res->start + 1);
+	drv_data->regs = ioremap(res->start, resource_len(res));
 	if (drv_data->regs == NULL) {
 		dev_err(&pdev->dev, "probe - cannot map IO\n");
 		status = -ENXIO;
--- at91.orig/drivers/spi/spi_mpc83xx.c	2007-10-19 11:38:28.000000000 -0700
+++ at91/drivers/spi/spi_mpc83xx.c	2007-10-19 11:43:12.000000000 -0700
@@ -452,7 +452,7 @@ static int __init mpc83xx_spi_probe(stru
 	mpc83xx_spi->bitbang.master->setup = mpc83xx_spi_setup;
 	init_completion(&mpc83xx_spi->done);
 
-	mpc83xx_spi->base = ioremap(r->start, r->end - r->start + 1);
+	mpc83xx_spi->base = ioremap(r->start, resource_len(r));
 	if (mpc83xx_spi->base == NULL) {
 		ret = -ENOMEM;
 		goto put_master;
--- at91.orig/drivers/spi/spi_s3c24xx.c	2007-10-19 11:38:28.000000000 -0700
+++ at91/drivers/spi/spi_s3c24xx.c	2007-10-19 11:43:12.000000000 -0700
@@ -284,7 +284,7 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_iores;
 	}
 
-	hw->ioarea = request_mem_region(res->start, (res->end - res->start)+1,
+	hw->ioarea = request_mem_region(res->start, resource_len(res),
 					pdev->name);
 
 	if (hw->ioarea == NULL) {
@@ -293,7 +293,7 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_iores;
 	}
 
-	hw->regs = ioremap(res->start, (res->end - res->start)+1);
+	hw->regs = ioremap(res->start, resource_len(res));
 	if (hw->regs == NULL) {
 		dev_err(&pdev->dev, "Cannot map IO\n");
 		err = -ENXIO;
--- at91.orig/drivers/spi/spi_txx9.c	2007-10-19 11:38:28.000000000 -0700
+++ at91/drivers/spi/spi_txx9.c	2007-10-19 11:43:12.000000000 -0700
@@ -382,7 +382,7 @@ static int __init txx9spi_probe(struct p
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
 		goto exit;
-	c->membase = ioremap(res->start, res->end - res->start + 1);
+	c->membase = ioremap(res->start, resource_len(res));
 	if (!c->membase)
 		goto exit;
 
--- at91.orig/drivers/spi/xilinx_spi.c	2007-10-13 14:35:41.000000000 -0700
+++ at91/drivers/spi/xilinx_spi.c	2007-10-19 11:43:12.000000000 -0700
@@ -341,13 +341,12 @@ static int __init xilinx_spi_probe(struc
 	xspi->bitbang.master->setup = xilinx_spi_setup;
 	init_completion(&xspi->done);
 
-	if (!request_mem_region(r->start,
-			r->end - r->start + 1, XILINX_SPI_NAME)) {
+	if (!request_mem_region(r->start, resource_len(r), XILINX_SPI_NAME)) {
 		ret = -ENXIO;
 		goto put_master;
 	}
 
-	xspi->regs = ioremap(r->start, r->end - r->start + 1);
+	xspi->regs = ioremap(r->start, resource_len(r));
 	if (xspi->regs == NULL) {
 		ret = -ENOMEM;
 		goto put_master;
