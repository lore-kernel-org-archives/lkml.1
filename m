Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbYLYOPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbYLYOPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYLYOPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:15:09 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:53981 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751893AbYLYOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:15:07 -0500
Date: Thu, 25 Dec 2008 17:15:05 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] USB: fsl_qe_udc: Fix recursive locking bug in
	ch9getstatus()
Message-ID: <20081225141505.GB6786@oksana.dev.rtsoft.ru>
References: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call chain is this:

qe_udc_irq() <- grabs the udc->lock spinlock
rx_irq()
qe_ep0_rx()
ep0_setup_handle()
setup_received_handle()
ch9getstatus()
qe_ep_queue() <- tries to grab the udc->lock again

It seems unsafe to temporarily drop the lock in the ch9getstatus(),
so to fix that bug the lock-less __qe_ep_queue() function
implemented and used by the ch9getstatus().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/fsl_qe_udc.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index db6fe04..2677c9e 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -1681,14 +1681,11 @@ static void qe_free_request(struct usb_ep *_ep, struct usb_request *_req)
 		kfree(req);
 }
 
-/* queues (submits) an I/O request to an endpoint */
-static int qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
-				gfp_t gfp_flags)
+static int __qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req)
 {
 	struct qe_ep *ep = container_of(_ep, struct qe_ep, ep);
 	struct qe_req *req = container_of(_req, struct qe_req, req);
 	struct qe_udc *udc;
-	unsigned long flags;
 	int reval;
 
 	udc = ep->udc;
@@ -1732,7 +1729,7 @@ static int qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
 	list_add_tail(&req->queue, &ep->queue);
 	dev_vdbg(udc->dev, "gadget have request in %s! %d\n",
 			ep->name, req->req.length);
-	spin_lock_irqsave(&udc->lock, flags);
+
 	/* push the request to device */
 	if (ep_is_in(ep))
 		reval = ep_req_send(ep, req);
@@ -1748,11 +1745,24 @@ static int qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
 	if (ep->dir == USB_DIR_OUT)
 		reval = ep_req_receive(ep, req);
 
-	spin_unlock_irqrestore(&udc->lock, flags);
-
 	return 0;
 }
 
+/* queues (submits) an I/O request to an endpoint */
+static int qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
+		       gfp_t gfp_flags)
+{
+	struct qe_ep *ep = container_of(_ep, struct qe_ep, ep);
+	struct qe_udc *udc = ep->udc;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&udc->lock, flags);
+	ret = __qe_ep_queue(_ep, _req);
+	spin_unlock_irqrestore(&udc->lock, flags);
+	return ret;
+}
+
 /* dequeues (cancels, unlinks) an I/O request from an endpoint */
 static int qe_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 {
@@ -2008,7 +2018,7 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 	udc->ep0_dir = USB_DIR_IN;
 
 	/* data phase */
-	status = qe_ep_queue(&ep->ep, &req->req, GFP_ATOMIC);
+	status = __qe_ep_queue(&ep->ep, &req->req);
 
 	if (status == 0)
 		return;
-- 
1.5.6.5

