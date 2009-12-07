Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbZLGANL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbZLGANL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbZLGANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:08 -0500
Received: from kroah.org ([198.145.64.141]:34392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454AbZLGANF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:48 2009
Message-Id: <20091207000648.580930573@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       John Youn <John.Youn@synopsys.com>
Subject: [047/119] USB: xhci: Fix scratchpad deallocation.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-fix-scratchpad-deallocation.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 5294bea40666db5c5d6c336b8e4e55d69fa576ca upstream.

The scratchpad_free() function uses xhci->page_size to free some memory
with pci_free_consistent().  However, the page_size is set to zero before
the call, causing kernel oopses on driver unload.  Call scratchpad_free()
before setting xhci->page_size to zero.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: John Youn <John.Youn@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -797,9 +797,9 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 				xhci->dcbaa, xhci->dcbaa->dma);
 	xhci->dcbaa = NULL;
 
+	scratchpad_free(xhci);
 	xhci->page_size = 0;
 	xhci->page_shift = 0;
-	scratchpad_free(xhci);
 }
 
 int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)


