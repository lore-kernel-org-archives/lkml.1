Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZJBBeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZJBBeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZJBBeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:08 -0400
Received: from kroah.org ([198.145.64.141]:33474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbZJBBeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:24 2009
Message-Id: <20091002012424.339883108@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [109/136] USB: xhci: Make TRB completion code comparison readable.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-make-trb-completion-code-comparison-readable.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 66d1eebce5cca916e0b08d961690bb01c64751ef upstream.

Use trb_comp_code instead of getting the completion code from the transfer
event every time.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -874,6 +874,7 @@ static int handle_tx_event(struct xhci_h
 	struct urb *urb = 0;
 	int status = -EINPROGRESS;
 	struct xhci_ep_ctx *ep_ctx;
+	u32 trb_comp_code;
 
 	xhci_dbg(xhci, "In %s\n", __func__);
 	slot_id = TRB_TO_SLOT_ID(event->flags);
@@ -931,7 +932,8 @@ static int handle_tx_event(struct xhci_h
 			(unsigned int) event->flags);
 
 	/* Look for common error cases */
-	switch (GET_COMP_CODE(event->transfer_len)) {
+	trb_comp_code = GET_COMP_CODE(event->transfer_len);
+	switch (trb_comp_code) {
 	/* Skip codes that require special handling depending on
 	 * transfer type
 	 */
@@ -974,7 +976,7 @@ static int handle_tx_event(struct xhci_h
 	/* Was this a control transfer? */
 	if (usb_endpoint_xfer_control(&td->urb->ep->desc)) {
 		xhci_debug_trb(xhci, xhci->event_ring->dequeue);
-		switch (GET_COMP_CODE(event->transfer_len)) {
+		switch (trb_comp_code) {
 		case COMP_SUCCESS:
 			if (event_trb == ep_ring->dequeue) {
 				xhci_warn(xhci, "WARN: Success on ctrl setup TRB without IOC set??\n");
@@ -1031,7 +1033,7 @@ static int handle_tx_event(struct xhci_h
 				}
 			} else {
 			/* Maybe the event was for the data stage? */
-				if (GET_COMP_CODE(event->transfer_len) != COMP_STOP_INVAL) {
+				if (trb_comp_code != COMP_STOP_INVAL) {
 					/* We didn't stop on a link TRB in the middle */
 					td->urb->actual_length =
 						td->urb->transfer_buffer_length -
@@ -1043,7 +1045,7 @@ static int handle_tx_event(struct xhci_h
 			}
 		}
 	} else {
-		switch (GET_COMP_CODE(event->transfer_len)) {
+		switch (trb_comp_code) {
 		case COMP_SUCCESS:
 			/* Double check that the HW transferred everything. */
 			if (event_trb != td->last_trb) {
@@ -1120,14 +1122,14 @@ static int handle_tx_event(struct xhci_h
 			/* If the ring didn't stop on a Link or No-op TRB, add
 			 * in the actual bytes transferred from the Normal TRB
 			 */
-			if (GET_COMP_CODE(event->transfer_len) != COMP_STOP_INVAL)
+			if (trb_comp_code != COMP_STOP_INVAL)
 				td->urb->actual_length +=
 					TRB_LEN(cur_trb->generic.field[2]) -
 					TRB_LEN(event->transfer_len);
 		}
 	}
-	if (GET_COMP_CODE(event->transfer_len) == COMP_STOP_INVAL ||
-			GET_COMP_CODE(event->transfer_len) == COMP_STOP) {
+	if (trb_comp_code == COMP_STOP_INVAL ||
+			trb_comp_code == COMP_STOP) {
 		/* The Endpoint Stop Command completion will take care of any
 		 * stopped TDs.  A stopped TD may be restarted, so don't update
 		 * the ring dequeue pointer or take this TD off any lists yet.


