Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYIARLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYIARLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYIARLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:11:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8353 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751615AbYIARLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:11:09 -0400
Date: Mon, 1 Sep 2008 21:11:06 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Li Yang <leoli@freescale.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
	driver
Message-ID: <20080901171106.GA13447@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <1219916613-28827-1-git-send-email-leoli@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 05:43:33PM +0800, Li Yang wrote:
> Some of Freescale SoC chips have a QE or CPM co-processor which
> supports full speed USB.  The driver adds device mode support
> of both QE and CPM USB controller to Linux USB gadget.  The
> driver is tested with MPC8360 and MPC8272, and should work with
> other models having QE/CPM given minor tweaks.
> 
> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> This is the second submission of the driver.  This version addressed:
> Comments from Anton Vorontsov.
> A lot of cosmetic problem.
> Sparse and various kernel DEBUG warnings.

Just caught this:

g_ether gadget: high speed config #1: CDC Ethernet (ECM)
BUG: sleeping function called from invalid context at mm/page_alloc.c:1450
in_atomic():1, irqs_disabled():1
Call Trace:
[c03a9c30] [c0008a90] show_stack+0x4c/0x16c (unreliable)
[c03a9c70] [c002cd28] __might_sleep+0xe4/0x114
[c03a9c80] [c006e550] __alloc_pages_internal+0x328/0x42c
[c03a9d00] [c006e67c] __get_free_pages+0x28/0x68
[c03a9d10] [c0090efc] __kmalloc+0xc0/0xe4
[c03a9d30] [c01d8efc] qe_ep_rxbd_update+0x98/0x1e0
[c03a9d50] [c01d90f0] qe_ep_init+0xac/0x37c
[c03a9d70] [c01d9458] qe_ep_enable+0x98/0xb8
[c03a9d80] [c01db268] gether_connect+0xa0/0x178
[c03a9da0] [c01dbba8] ecm_set_alt+0x108/0x12c
[c03a9db0] [c01dc988] composite_setup+0x2ec/0x3a8
[c03a9de0] [c01d8bec] setup_received_handle+0x1e4/0x26c
[c03a9e00] [c01d8ce0] ep0_setup_handle+0x6c/0x74
[c03a9e10] [c01d8e54] qe_ep0_rx+0x16c/0x17c
[c03a9e30] [c01d9db8] rx_irq+0x88/0xc0
[c03a9e40] [c01da32c] qe_udc_irq+0x10c/0x134
[c03a9e60] [c00631f4] handle_IRQ_event+0x5c/0xb0
[c03a9e80] [c006526c] handle_level_irq+0xa8/0x144
[c03a9ea0] [c002a5d0] qe_ic_cascade_low_ipic+0x58/0x70
[c03a9eb0] [c0006820] do_IRQ+0xa4/0xc8
[c03a9ec0] [c0013e14] ret_from_except+0x0/0x14
--- Exception: 501 at cpu_idle+0xa0/0x104
    LR = cpu_idle+0xa0/0x104
[c03a9f80] [c0009d88] cpu_idle+0x50/0x104 (unreliable)
[c03a9fa0] [c029307c] _etext+0x7c/0x90
[c03a9fc0] [c035491c] start_kernel+0x1ac/0x230
[c03a9ff0] [00003438] 0x3438

The workaround is obvious (below), but should we really allocate
things in interrupts? Can we just allocate everything in probe()
and free in remove()?


diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index c1a0beb..c54863b 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -433,7 +433,7 @@ static int qe_ep_rxbd_update(struct qe_ep *ep)
 
 	bd = ep->rxbase;
 
-	ep->rxframe = kmalloc(sizeof(*ep->rxframe), GFP_KERNEL);
+	ep->rxframe = kmalloc(sizeof(*ep->rxframe), GFP_ATOMIC);
 	if (ep->rxframe == NULL) {
 		dev_err(ep->udc->dev, "malloc rxframe failed\n");
 		return -ENOMEM;
@@ -447,7 +447,7 @@ static int qe_ep_rxbd_update(struct qe_ep *ep)
 		bdring_len = USB_BDRING_LEN;
 
 	size = (ep->ep.maxpacket + USB_CRC_SIZE + 2) * (bdring_len + 1);
-	ep->rxbuffer = kzalloc(size, GFP_KERNEL);
+	ep->rxbuffer = kzalloc(size, GFP_ATOMIC);
 	if (ep->rxbuffer == NULL) {
 		dev_err(ep->udc->dev, "malloc rxbuffer failed,size=%d\n",
 				size);
@@ -680,7 +680,7 @@ static int qe_ep_init(struct qe_udc *udc,
 	}
 
 	if ((ep->tm == USBP_TM_CTL) || (ep->dir == USB_DIR_IN)) {
-		ep->txframe = kmalloc(sizeof(*ep->txframe), GFP_KERNEL);
+		ep->txframe = kmalloc(sizeof(*ep->txframe), GFP_ATOMIC);
 		if (ep->txframe == NULL) {
 			dev_err(udc->dev, "malloc txframe failed\n");
 			goto en_done;
@@ -1930,7 +1930,9 @@ static int reset_queues(struct qe_udc *udc)
 		udc_reset_ep_queue(udc, pipe);
 
 	/* report disconnect; the driver is already quiesced */
+	spin_unlock(&udc->lock);
 	udc->driver->disconnect(&udc->gadget);
+	spin_lock(&udc->lock);
 
 	return 0;
 }
