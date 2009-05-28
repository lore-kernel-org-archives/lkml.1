Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbZE1BLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbZE1BLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759963AbZE1BKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:10:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:56490 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760479AbZE1BKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:10:53 -0400
Date: Thu, 28 May 2009 10:10:44 +0900
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] usb: replace dma_sync_single and dma_sync_sg with
 dma_sync_single_for_cpu and dma_sync_sg_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090528101035I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 28 May 2009 10:10:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_buffer_dmasync() and usb_buffer_dmasync_sg() are disabled (not
compiled) but it's better to remove all bad examples.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] usb: replace dma_sync_single and dma_sync_sg with dma_sync_single_for_cpu and dma_sync_sg_for_cpu

This replaces dma_sync_single() and dma_sync_sg() with
dma_sync_single_for_cpu() and dma_sync_sg_for_cpu() respectively
because they is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/usb/core/usb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 00f1fc8..948837e 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -829,12 +829,12 @@ void usb_buffer_dmasync(struct urb *urb)
 		return;
 
 	if (controller->dma_mask) {
-		dma_sync_single(controller,
+		dma_sync_single_for_cpu(controller,
 			urb->transfer_dma, urb->transfer_buffer_length,
 			usb_pipein(urb->pipe)
 				? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 		if (usb_pipecontrol(urb->pipe))
-			dma_sync_single(controller,
+			dma_sync_single_for_cpu(controller,
 					urb->setup_dma,
 					sizeof(struct usb_ctrlrequest),
 					DMA_TO_DEVICE);
@@ -952,8 +952,8 @@ void usb_buffer_dmasync_sg(const struct usb_device *dev, int is_in,
 			|| !controller->dma_mask)
 		return;
 
-	dma_sync_sg(controller, sg, n_hw_ents,
-			is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	dma_sync_sg_for_cpu(controller, sg, n_hw_ents,
+			    is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL_GPL(usb_buffer_dmasync_sg);
 #endif
-- 
1.6.0.6

