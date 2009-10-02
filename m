Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbZJBBk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbZJBBk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932073AbZJBBks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:40:48 -0400
Received: from kroah.org ([198.145.64.141]:33494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbZJBBeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:25 2009
Message-Id: <20091002012424.944528955@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [113/136] USB: xhci: Check URB_SHORT_NOT_OK before setting short packet status.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-check-urb_short_not_ok-before-setting-short-packet-status.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 204970a4bb2f584afc430ae330cd44aee329cea4 upstream.

Make sure that the driver that submitted the URB considers a short packet
an error before setting -EREMOTEIO during a short control transfer.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -991,7 +991,10 @@ static int handle_tx_event(struct xhci_h
 			break;
 		case COMP_SHORT_TX:
 			xhci_warn(xhci, "WARN: short transfer on control ep\n");
-			status = -EREMOTEIO;
+			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
+				status = -EREMOTEIO;
+			else
+				status = 0;
 			break;
 		case COMP_BABBLE:
 			/* The 0.96 spec says a babbling control endpoint
@@ -1034,7 +1037,10 @@ static int handle_tx_event(struct xhci_h
 			if (event_trb == td->last_trb) {
 				if (td->urb->actual_length != 0) {
 					/* Don't overwrite a previously set error code */
-					if (status == -EINPROGRESS || status == 0)
+					if ((status == -EINPROGRESS ||
+								status == 0) &&
+							(td->urb->transfer_flags
+							 & URB_SHORT_NOT_OK))
 						/* Did we already see a short data stage? */
 						status = -EREMOTEIO;
 				} else {


