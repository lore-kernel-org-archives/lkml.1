Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbZLGAVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbZLGAVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbZLGAVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:21:38 -0500
Received: from kroah.org ([198.145.64.141]:34658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932816AbZLGANo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:56 2009
Message-Id: <20091207000656.432492565@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Dahlmann <dahlmann.thomas@arcor.de>,
       Robert Richter <robert.richter@amd.com>,
       David Brownell <david-b@pacbell.net>
Subject: [088/119] usb: amd5536udc: fixed shared interrupt bug and warning oops
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-amd5536udc-fixed-shared-interrupt-bug-and-warning-oops.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>

commit c5deb832d7a3f9618b09e6eeaa91a1a845c90c65 upstream.

- fixed shared interrupt bug reported by Vadim Lobanov
 - fixed possible warning oops on driver unload when connected
 - prevent interrupt flood in PIO mode ("modprobe amd5536udc use_dma=0")
   when using gadget ether

Signed-off-by: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: Robert Richter <robert.richter@amd.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/amd5536udc.c |   49 ++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 19 deletions(-)

--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1213,7 +1213,12 @@ udc_queue(struct usb_ep *usbep, struct u
 				tmp &= AMD_UNMASK_BIT(ep->num);
 				writel(tmp, &dev->regs->ep_irqmsk);
 			}
-		}
+		} else if (ep->in) {
+				/* enable ep irq */
+				tmp = readl(&dev->regs->ep_irqmsk);
+				tmp &= AMD_UNMASK_BIT(ep->num);
+				writel(tmp, &dev->regs->ep_irqmsk);
+			}
 
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
 
@@ -2478,6 +2482,13 @@ static irqreturn_t udc_data_in_isr(struc
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
@@ -3285,6 +3296,17 @@ static int udc_pci_probe(
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
@@ -3337,7 +3359,6 @@ static int udc_probe(struct udc *dev)
 	udc_pollstall_timer.data = 0;
 
 	/* device struct setup */
-	spin_lock_init(&dev->lock);
 	dev->gadget.ops = &udc_ops;
 
 	dev_set_name(&dev->gadget.dev, "gadget");
@@ -3346,16 +3367,6 @@ static int udc_probe(struct udc *dev)
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
 


