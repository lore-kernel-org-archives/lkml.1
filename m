Return-Path: <linux-kernel-owner+w=401wt.eu-S934487AbZLGA32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487AbZLGA32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934448AbZLGA30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:29:26 -0500
Received: from kroah.org ([198.145.64.141]:34386 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbZLGAND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:48 2009
Message-Id: <20091207000648.061330734@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [045/119] USB: xhci: Fix bug memory free after failed initialization.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-fix-bug-memory-free-after-failed-initialization.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit d94c05e33d9212ee67b8d4998f984cc71df8168b upstream.

If the xHCI driver fails during the memory initialization, xhci->ir_set
may not be a valid pointer.  Check that it points to valid DMA'able memory
before writing to that address during the memory freeing process.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -756,9 +756,11 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 	int i;
 
 	/* Free the Event Ring Segment Table and the actual Event Ring */
-	xhci_writel(xhci, 0, &xhci->ir_set->erst_size);
-	xhci_write_64(xhci, 0, &xhci->ir_set->erst_base);
-	xhci_write_64(xhci, 0, &xhci->ir_set->erst_dequeue);
+	if (xhci->ir_set) {
+		xhci_writel(xhci, 0, &xhci->ir_set->erst_size);
+		xhci_write_64(xhci, 0, &xhci->ir_set->erst_base);
+		xhci_write_64(xhci, 0, &xhci->ir_set->erst_dequeue);
+	}
 	size = sizeof(struct xhci_erst_entry)*(xhci->erst.num_entries);
 	if (xhci->erst.entries)
 		pci_free_consistent(pdev, size,


