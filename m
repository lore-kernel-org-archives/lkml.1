Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbZJBBjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbZJBBjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbZJBBeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:10 -0400
Received: from kroah.org ([198.145.64.141]:33490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbZJBBeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:24 2009
Message-Id: <20091002012424.797134310@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [112/136] USB: xhci: Check URBs actual transfer buffer size.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-check-urb-s-actual-transfer-buffer-size.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 99eb32db45061443ab7552b8fdceae68b90fde55 upstream.

Make sure that the amount of data the xHC says was transmitted is less
than or equal to the size of the requested transfer buffer.  Before, if
the host controller erroneously reported that the number of bytes
untransferred was bigger than the buffer in the URB, urb->actual_length
could be set to a very large size.

Make sure urb->actual_length <= urb->transfer_buffer_length.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1092,7 +1092,8 @@ static int handle_tx_event(struct xhci_h
 				td->urb->actual_length =
 					td->urb->transfer_buffer_length -
 					TRB_LEN(event->transfer_len);
-				if (td->urb->actual_length < 0) {
+				if (td->urb->transfer_buffer_length <
+						td->urb->actual_length) {
 					xhci_warn(xhci, "HC gave bad length "
 							"of %d bytes left\n",
 							TRB_LEN(event->transfer_len));
@@ -1167,6 +1168,20 @@ static int handle_tx_event(struct xhci_h
 td_cleanup:
 		/* Clean up the endpoint's TD list */
 		urb = td->urb;
+		/* Do one last check of the actual transfer length.
+		 * If the host controller said we transferred more data than
+		 * the buffer length, urb->actual_length will be a very big
+		 * number (since it's unsigned).  Play it safe and say we didn't
+		 * transfer anything.
+		 */
+		if (urb->actual_length > urb->transfer_buffer_length) {
+			xhci_warn(xhci, "URB transfer length is wrong, "
+					"xHC issue? req. len = %u, "
+					"act. len = %u\n",
+					urb->transfer_buffer_length,
+					urb->actual_length);
+			urb->actual_length = 0;
+		}
 		list_del(&td->td_list);
 		/* Was this TD slated to be cancelled but completed anyway? */
 		if (!list_empty(&td->cancelled_td_list)) {


