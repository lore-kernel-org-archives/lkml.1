Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbZJBBjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbZJBBjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbZJBBj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:39:29 -0400
Received: from kroah.org ([198.145.64.141]:33506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888AbZJBBeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:25 2009
Message-Id: <20091002012425.258073207@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [115/136] USB: xhci: Support interrupt transfers.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-support-interrupt-transfers.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 624defa12f304b4d11eda309bc207fa5a1900d0f upstream.

Interrupt transfers are submitted to the xHCI hardware using the same TRB
type as bulk transfers.  Re-use the bulk transfer enqueueing code to
enqueue interrupt transfers.

Interrupt transfers are a bit different than bulk transfers.  When the
interrupt endpoint is to be serviced, the xHC will consume (at most) one
TD.  A TD (comprised of sg list entries) can take several service
intervals to transmit.  The important thing for device drivers to note is
that if they use the scatter gather interface to submit interrupt
requests, they will not get data sent from two different scatter gather
lists in the same service interval.

For now, the xHCI driver will use the service interval from the endpoint's
descriptor (bInterval).  Drivers will need a hook to poll at a more
frequent interval.  Set urb->interval to the interval that the xHCI
hardware will use.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hcd.c  |    5 ++++
 drivers/usb/host/xhci-ring.c |   48 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |    3 ++
 3 files changed, 55 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -581,6 +581,7 @@ struct xhci_ep_ctx {
 /* bit 15 is Linear Stream Array */
 /* Interval - period between requests to an endpoint - 125u increments. */
 #define EP_INTERVAL(p)		((p & 0xff) << 16)
+#define EP_INTERVAL_TO_UFRAMES(p)		(1 << (((p) >> 16) & 0xff))
 
 /* ep_info2 bitmasks */
 /*
@@ -1223,6 +1224,8 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *
 		int slot_id, unsigned int ep_index);
 int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
 		int slot_id, unsigned int ep_index);
+int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
+		int slot_id, unsigned int ep_index);
 int xhci_queue_configure_endpoint(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
 		u32 slot_id);
 int xhci_queue_evaluate_context(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
--- a/drivers/usb/host/xhci-hcd.c
+++ b/drivers/usb/host/xhci-hcd.c
@@ -727,6 +727,11 @@ int xhci_urb_enqueue(struct usb_hcd *hcd
 		ret = xhci_queue_bulk_tx(xhci, GFP_ATOMIC, urb,
 				slot_id, ep_index);
 		spin_unlock_irqrestore(&xhci->lock, flags);
+	} else if (usb_endpoint_xfer_int(&urb->ep->desc)) {
+		spin_lock_irqsave(&xhci->lock, flags);
+		ret = xhci_queue_intr_tx(xhci, GFP_ATOMIC, urb,
+				slot_id, ep_index);
+		spin_unlock_irqrestore(&xhci->lock, flags);
 	} else {
 		ret = -EINVAL;
 	}
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1072,7 +1072,12 @@ static int handle_tx_event(struct xhci_h
 				else
 					status = 0;
 			} else {
-				xhci_dbg(xhci, "Successful bulk transfer!\n");
+				if (usb_endpoint_xfer_bulk(&td->urb->ep->desc))
+					xhci_dbg(xhci, "Successful bulk "
+							"transfer!\n");
+				else
+					xhci_dbg(xhci, "Successful interrupt "
+							"transfer!\n");
 				status = 0;
 			}
 			break;
@@ -1464,6 +1469,47 @@ static void giveback_first_trb(struct xh
 	ring_ep_doorbell(xhci, slot_id, ep_index);
 }
 
+/*
+ * xHCI uses normal TRBs for both bulk and interrupt.  When the interrupt
+ * endpoint is to be serviced, the xHC will consume (at most) one TD.  A TD
+ * (comprised of sg list entries) can take several service intervals to
+ * transmit.
+ */
+int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
+		struct urb *urb, int slot_id, unsigned int ep_index)
+{
+	struct xhci_ep_ctx *ep_ctx = xhci_get_ep_ctx(xhci,
+			xhci->devs[slot_id]->out_ctx, ep_index);
+	int xhci_interval;
+	int ep_interval;
+
+	xhci_interval = EP_INTERVAL_TO_UFRAMES(ep_ctx->ep_info);
+	ep_interval = urb->interval;
+	/* Convert to microframes */
+	if (urb->dev->speed == USB_SPEED_LOW ||
+			urb->dev->speed == USB_SPEED_FULL)
+		ep_interval *= 8;
+	/* FIXME change this to a warning and a suggestion to use the new API
+	 * to set the polling interval (once the API is added).
+	 */
+	if (xhci_interval != ep_interval) {
+		if (!printk_ratelimit())
+			dev_dbg(&urb->dev->dev, "Driver uses different interval"
+					" (%d microframe%s) than xHCI "
+					"(%d microframe%s)\n",
+					ep_interval,
+					ep_interval == 1 ? "" : "s",
+					xhci_interval,
+					xhci_interval == 1 ? "" : "s");
+		urb->interval = xhci_interval;
+		/* Convert back to frames for LS/FS devices */
+		if (urb->dev->speed == USB_SPEED_LOW ||
+				urb->dev->speed == USB_SPEED_FULL)
+			urb->interval /= 8;
+	}
+	return xhci_queue_bulk_tx(xhci, GFP_ATOMIC, urb, slot_id, ep_index);
+}
+
 static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		struct urb *urb, int slot_id, unsigned int ep_index)
 {


