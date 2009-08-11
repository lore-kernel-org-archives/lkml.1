Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZHKWA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZHKWA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbZHKWA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:00:58 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:49819 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbZHKWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:00:57 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net 4DC61332928
Subject: [PATCH] amd5536udc: fixed shared interrupt bug and warning oops
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
To: dbrownell@users.sourceforge.net
Cc: vlobanov@speakeasy.net, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Wed, 12 Aug 2009 00:00:56 +0200
Message-Id: <1250028056.14854.18.camel@pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9654f85cbeabec4b8652f9785bea317cd7068edb Mon Sep 17 00:00:00 2001
From: Thomas <dahlmann.thomas@arcor.de>
Date: Tue, 11 Aug 2009 22:09:55 +0200
Subject: [PATCH] amd5536udc: fixed shared interrupt bug and warning oops
  - fixed shared interrupt bug reported by Vadim Lobanov
  - fixed possible warning oops on driver unload when connected
  - prevent interrupt flood in PIO mode ("modprobe amd5536udc use_dma=0")
    when using gadget ether
  - applied patch "Drop NULL test on list_entry result" submitted by Julia Lawall

Signed-off-by: Thomas <dahlmann.thomas@arcor.de>
---
 drivers/usb/gadget/amd5536udc.c |  103 ++++++++++++++++++++------------------
 1 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 77352cc..78fd192 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1213,6 +1213,11 @@ udc_queue(struct usb_ep *usbep, struct usb_request *usbreq, gfp_t gfp)
 				tmp &= AMD_UNMASK_BIT(ep->num);
 				writel(tmp, &dev->regs->ep_irqmsk);
 			}
+		} else if (ep->in) {
+				/* enable ep irq */
+				tmp = readl(&dev->regs->ep_irqmsk);
+				tmp &= AMD_UNMASK_BIT(ep->num);
+				writel(tmp, &dev->regs->ep_irqmsk);
 		}
 
 	} else if (ep->dma) {
@@ -2005,18 +2010,17 @@ __acquires(dev->lock)
 {
 	int tmp;
 
-	/* empty queues and init hardware */
-	udc_basic_init(dev);
-	for (tmp = 0; tmp < UDC_EP_NUM; tmp++) {
-		empty_req_queue(&dev->ep[tmp]);
-	}
-
 	if (dev->gadget.speed != USB_SPEED_UNKNOWN) {
 		spin_unlock(&dev->lock);
 		driver->disconnect(&dev->gadget);
 		spin_lock(&dev->lock);
 	}
-	/* init */
+
+	/* empty queues and init hardware */
+	udc_basic_init(dev);
+	for (tmp = 0; tmp < UDC_EP_NUM; tmp++)
+		empty_req_queue(&dev->ep[tmp]);
+
 	udc_setup_endpoints(dev);
 }
 
@@ -2378,40 +2382,34 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 		if (!ep->cancel_transfer && !list_empty(&ep->queue)) {
 			req = list_entry(ep->queue.next,
 					struct udc_request, queue);
-			if (req) {
-				/*
-				 * length bytes transfered
-				 * check dma done of last desc. in PPBDU mode
-				 */
-				if (use_dma_ppb_du) {
-					td = udc_get_last_dma_desc(req);
-					if (td) {
-						dma_done =
-							AMD_GETBITS(td->status,
-							UDC_DMA_IN_STS_BS);
-						/* don't care DMA done */
-						req->req.actual =
-							req->req.length;
-					}
-				} else {
-					/* assume all bytes transferred */
+			/*
+			 * length bytes transfered
+			 * check dma done of last desc. in PPBDU mode
+			 */
+			if (use_dma_ppb_du) {
+				td = udc_get_last_dma_desc(req);
+				if (td) {
+					dma_done =
+						AMD_GETBITS(td->status,
+						UDC_DMA_IN_STS_BS);
+					/* don't care DMA done */
 					req->req.actual = req->req.length;
 				}
+			} else {
+				/* assume all bytes transferred */
+				req->req.actual = req->req.length;
+			}
 
-				if (req->req.actual == req->req.length) {
-					/* complete req */
-					complete_req(ep, req, 0);
-					req->dma_going = 0;
-					/* further request available ? */
-					if (list_empty(&ep->queue)) {
-						/* disable interrupt */
-						tmp = readl(
-							&dev->regs->ep_irqmsk);
-						tmp |= AMD_BIT(ep->num);
-						writel(tmp,
-							&dev->regs->ep_irqmsk);
-					}
-
+			if (req->req.actual == req->req.length) {
+				/* complete req */
+				complete_req(ep, req, 0);
+				req->dma_going = 0;
+				/* further request available ? */
+				if (list_empty(&ep->queue)) {
+					/* disable interrupt */
+					tmp = readl(&dev->regs->ep_irqmsk);
+					tmp |= AMD_BIT(ep->num);
+					writel(tmp, &dev->regs->ep_irqmsk);
 				}
 			}
 		}
@@ -2478,6 +2476,13 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 				}
 			}
 
+		} else if (!use_dma && ep->in) {
+			/* disable interrupt */
+			tmp = readl(
+				&dev->regs->ep_irqmsk);
+			tmp |= AMD_BIT(ep->num);
+			writel(tmp,
+				&dev->regs->ep_irqmsk);
 		}
 	}
 	/* clear status bits */
@@ -3285,6 +3290,17 @@ static int udc_pci_probe(
 		goto finished;
 	}
 
+	spin_lock_init(&dev->lock);
+	/* udc csr registers base */
+	dev->csr = dev->virt_addr + UDC_CSR_ADDR;
+	/* dev registers base */
+	dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
+	/* ep registers base */
+	dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
+	/* fifo's base */
+	dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
+	dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);
+
 	if (request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev) != 0) {
 		dev_dbg(&dev->pdev->dev, "request_irq(%d) fail\n", pdev->irq);
 		kfree(dev);
@@ -3337,7 +3353,6 @@ static int udc_probe(struct udc *dev)
 	udc_pollstall_timer.data = 0;
 
 	/* device struct setup */
-	spin_lock_init(&dev->lock);
 	dev->gadget.ops = &udc_ops;
 
 	dev_set_name(&dev->gadget.dev, "gadget");
@@ -3346,16 +3361,6 @@ static int udc_probe(struct udc *dev)
 	dev->gadget.name = name;
 	dev->gadget.is_dualspeed = 1;
 
-	/* udc csr registers base */
-	dev->csr = dev->virt_addr + UDC_CSR_ADDR;
-	/* dev registers base */
-	dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
-	/* ep registers base */
-	dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
-	/* fifo's base */
-	dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
-	dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);
-
 	/* init registers, interrupts, ... */
 	startup_registers(dev);
 
-- 
1.5.6.3



