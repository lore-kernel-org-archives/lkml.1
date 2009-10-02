Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZJBBm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZJBBm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbZJBBm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:42:28 -0400
Received: from kroah.org ([198.145.64.141]:33442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbZJBBeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:23 2009
Message-Id: <20091002012423.698811980@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [105/136] USB: xhci: Set correct max packet size for HS/FS control endpoints.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-set-correct-max-packet-size-for-hs-fs-control-endpoints.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 47aded8ade9fee6779b121b2b156235f261239d7 upstream.

Set the max packet size for the default control endpoint on high speed
devices to be 64 bytes.  High speed devices always have a max packet size
of 64 bytes.  There's no use setting it to eight for the initial 8 byte
descriptor fetch and then issuing (and waiting for) an evaluate context
command to update it to 64 bytes for the subsequent control transfers.

The USB core guesses that the max packet size on a full speed control
endpoint is 64 bytes, and then updates it after the first 8-byte
descriptor fetch.  Change the initial setup for the xHCI internal
representation of the full speed device to have a 64 byte max packet size.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -401,15 +401,28 @@ int xhci_setup_addressable_virt_dev(stru
 	/* Step 5 */
 	ep0_ctx->ep_info2 = EP_TYPE(CTRL_EP);
 	/*
-	 * See section 4.3 bullet 6:
-	 * The default Max Packet size for ep0 is "8 bytes for a USB2
-	 * LS/FS/HS device or 512 bytes for a USB3 SS device"
 	 * XXX: Not sure about wireless USB devices.
 	 */
-	if (udev->speed == USB_SPEED_SUPER)
+	switch (udev->speed) {
+	case USB_SPEED_SUPER:
 		ep0_ctx->ep_info2 |= MAX_PACKET(512);
-	else
+		break;
+	case USB_SPEED_HIGH:
+	/* USB core guesses at a 64-byte max packet first for FS devices */
+	case USB_SPEED_FULL:
+		ep0_ctx->ep_info2 |= MAX_PACKET(64);
+		break;
+	case USB_SPEED_LOW:
 		ep0_ctx->ep_info2 |= MAX_PACKET(8);
+		break;
+	case USB_SPEED_VARIABLE:
+		xhci_dbg(xhci, "FIXME xHCI doesn't support wireless speeds\n");
+		return -EINVAL;
+		break;
+	default:
+		/* New speed? */
+		BUG();
+	}
 	/* EP 0 can handle "burst" sizes of 1, so Max Burst Size field is 0 */
 	ep0_ctx->ep_info2 |= MAX_BURST(0);
 	ep0_ctx->ep_info2 |= ERROR_COUNT(3);


