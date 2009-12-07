Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbZLGA2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbZLGA2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934469AbZLGA2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:28:38 -0500
Received: from kroah.org ([198.145.64.141]:34390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447AbZLGANE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:48 2009
Message-Id: <20091207000648.343901902@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [046/119] USB: xhci: Fix TRB physical to virtual address translation.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-fix-trb-physical-to-virtual-address-translation.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 2fa88daa6f299bfb83672c3b525d786ad03b4735 upstream.

The trb_in_td() function in the xHCI driver is supposed to translate a
physical transfer buffer request (TRB) into a virtual pointer to the ring
segment that TRB is in.

Unfortunately, a mistake in this function may cause endless loops as the
driver searches through the linked list of ring segments over and over
again.  Fix a couple bugs that may lead to loops or bad output:

1. Bail out if we get a NULL pointer when translating the segment's
private structure and the starting DMA address of the segment chunk.  If
this happens, we've been handed a starting TRB pointer from a different
ring.

2. Make sure the function works when there's multiple segments in the
ring.  In the while loop to search through the ring segments, use the
current segment variable (cur_seg), rather than the starting segment
variable (start_seg) that is passed in.

3. Stop searching the ring if we've run through all the segments in the
ring.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -822,9 +822,11 @@ static struct xhci_segment *trb_in_td(
 	cur_seg = start_seg;
 
 	do {
+		if (start_dma == 0)
+			return 0;
 		/* We may get an event for a Link TRB in the middle of a TD */
 		end_seg_dma = xhci_trb_virt_to_dma(cur_seg,
-				&start_seg->trbs[TRBS_PER_SEGMENT - 1]);
+				&cur_seg->trbs[TRBS_PER_SEGMENT - 1]);
 		/* If the end TRB isn't in this segment, this is set to 0 */
 		end_trb_dma = xhci_trb_virt_to_dma(cur_seg, end_trb);
 
@@ -851,8 +853,9 @@ static struct xhci_segment *trb_in_td(
 		}
 		cur_seg = cur_seg->next;
 		start_dma = xhci_trb_virt_to_dma(cur_seg, &cur_seg->trbs[0]);
-	} while (1);
+	} while (cur_seg != start_seg);
 
+	return 0;
 }
 
 /*


