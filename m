Return-Path: <linux-kernel-owner+w=401wt.eu-S1030382AbXBZSKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382AbXBZSKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030389AbXBZSKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:10:25 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:45237 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030382AbXBZSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:10:25 -0500
Date: Mon, 26 Feb 2007 18:10:15 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [USB] goku_udc: Remove crude cache coherency code
Message-ID: <20070226181015.GA7796@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is deep architecture specific magic and does should not to exist
in a driver.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 7b3a326..65c91d3 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -297,27 +297,6 @@ goku_free_request(struct usb_ep *_ep, struct usb_request *_req)
 
 /*-------------------------------------------------------------------------*/
 
-#undef USE_KMALLOC
-
-/* many common platforms have dma-coherent caches, which means that it's
- * safe to use kmalloc() memory for all i/o buffers without using any
- * cache flushing calls.  (unless you're trying to share cache lines
- * between dma and non-dma activities, which is a slow idea in any case.)
- *
- * other platforms need more care, with 2.6 having a moderately general
- * solution except for the common "buffer is smaller than a page" case.
- */
-#if	defined(CONFIG_X86)
-#define USE_KMALLOC
-
-#elif	defined(CONFIG_MIPS) && !defined(CONFIG_DMA_NONCOHERENT)
-#define USE_KMALLOC
-
-#elif	defined(CONFIG_PPC) && !defined(CONFIG_NOT_COHERENT_CACHE)
-#define USE_KMALLOC
-
-#endif
-
 /* allocating buffers this way eliminates dma mapping overhead, which
  * on some platforms will mean eliminating a per-io buffer copy.  with
  * some kinds of system caches, further tweaks may still be needed.
@@ -334,11 +313,6 @@ goku_alloc_buffer(struct usb_ep *_ep, unsigned bytes,
 		return NULL;
 	*dma = DMA_ADDR_INVALID;
 
-#if	defined(USE_KMALLOC)
-	retval = kmalloc(bytes, gfp_flags);
-	if (retval)
-		*dma = virt_to_phys(retval);
-#else
 	if (ep->dma) {
 		/* the main problem with this call is that it wastes memory
 		 * on typical 1/N page allocations: it allocates 1-N pages.
@@ -348,7 +322,6 @@ goku_alloc_buffer(struct usb_ep *_ep, unsigned bytes,
 				bytes, dma, gfp_flags);
 	} else
 		retval = kmalloc(bytes, gfp_flags);
-#endif
 	return retval;
 }
 
@@ -356,7 +329,6 @@ static void
 goku_free_buffer(struct usb_ep *_ep, void *buf, dma_addr_t dma, unsigned bytes)
 {
 	/* free memory into the right allocator */
-#ifndef	USE_KMALLOC
 	if (dma != DMA_ADDR_INVALID) {
 		struct goku_ep	*ep;
 
@@ -365,7 +337,6 @@ goku_free_buffer(struct usb_ep *_ep, void *buf, dma_addr_t dma, unsigned bytes)
 			return;
 		dma_free_coherent(&ep->dev->pdev->dev, bytes, buf, dma);
 	} else
-#endif
 		kfree (buf);
 }
 
