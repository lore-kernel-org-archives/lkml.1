Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbZJBBlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbZJBBlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068AbZJBBlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:41:20 -0400
Received: from kroah.org ([198.145.64.141]:33477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbZJBBeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:24 2009
Message-Id: <20091002012424.471713554@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [110/136] USB: xhci: Handle babbling endpoints correctly.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-handle-babbling-endpoints-correctly.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 83fbcdcca03013bb5af130d6d91eba11e3d3269e upstream.

The 0.95 xHCI spec says that non-control endpoints will be halted if a
babble is detected on a transfer.  The 0.96 xHCI spec says all types of
endpoints will be halted when a babble is detected.  Some hardware that
claims to be 0.95 compliant halts the control endpoint anyway.

When a babble is detected on a control endpoint, check the hardware's
output endpoint context to see if the endpoint is marked as halted.  If
the control endpoint is halted, a reset endpoint command must be issued
and the transfer ring dequeue pointer needs to be moved past the stopped
transfer.  Basically, we treat it as if the control endpoint had stalled.

Handle bulk babbling endpoints as if we got a completion event with a
stall completion code.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -993,6 +993,16 @@ static int handle_tx_event(struct xhci_h
 			xhci_warn(xhci, "WARN: short transfer on control ep\n");
 			status = -EREMOTEIO;
 			break;
+		case COMP_BABBLE:
+			/* The 0.96 spec says a babbling control endpoint
+			 * is not halted. The 0.96 spec says it is.  Some HW
+			 * claims to be 0.95 compliant, but it halts the control
+			 * endpoint anyway.  Check if a babble halted the
+			 * endpoint.
+			 */
+			if (ep_ctx->ep_info != EP_STATE_HALTED)
+				break;
+			/* else fall through */
 		case COMP_STALL:
 			/* Did we transfer part of the data (middle) phase? */
 			if (event_trb != ep_ring->dequeue &&
@@ -1137,7 +1147,8 @@ static int handle_tx_event(struct xhci_h
 		ep_ring->stopped_td = td;
 		ep_ring->stopped_trb = event_trb;
 	} else {
-		if (GET_COMP_CODE(event->transfer_len) == COMP_STALL) {
+		if (trb_comp_code == COMP_STALL ||
+				trb_comp_code == COMP_BABBLE) {
 			/* The transfer is completed from the driver's
 			 * perspective, but we need to issue a set dequeue
 			 * command for this stalled endpoint to move the dequeue
@@ -1168,7 +1179,8 @@ td_cleanup:
 		 * control endpoints).
 		 */
 		if (usb_endpoint_xfer_control(&urb->ep->desc) ||
-			GET_COMP_CODE(event->transfer_len) != COMP_STALL) {
+			(trb_comp_code != COMP_STALL &&
+				trb_comp_code != COMP_BABBLE)) {
 			kfree(td);
 		}
 		urb->hcpriv = NULL;


