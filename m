Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYGOOW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYGOOW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbYGOOWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:22:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41807 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760940AbYGOOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:22:15 -0400
Date: Tue, 15 Jul 2008 10:22:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: stable@kernel.org
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb-storage: fix oops on device removal
Message-ID: <Pine.LNX.4.44L0.0807151017410.2517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1110) reverts an earlier patch meant to help with
Wireless USB host controllers.  These controllers can have bulk
maxpacket values larger than 512, which puts unusual constraints on
the sizes of scatter-gather list elements.  However it turns out that
the block layer does not provide the support we need to enforce these
constraints; merely changing the DMA alignment mask doesn't help.
Hence there's no reason to keep the original patch.  The Wireless USB
problem will have to be solved a different way.

In addition, there is a reason to get rid of the earlier patch.  By
dereferencing a pointer stored in the ep_in array of struct
usb_device, the current code risks an invalid memory access when it
runs concurrently with device removal.  The members of that array are
cleared before the driver's disconnect method is called, so it should
not try to use them.  This bug has bitten several people.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Johannes Berg <johannes@sipsolutions.net>

---

Index: usb-2.6/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/scsiglue.c
+++ usb-2.6/drivers/usb/storage/scsiglue.c
@@ -71,7 +71,6 @@ static const char* host_info(struct Scsi
 static int slave_alloc (struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
-	struct usb_host_endpoint *bulk_in_ep;
 
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -80,16 +79,22 @@ static int slave_alloc (struct scsi_devi
 	 */
 	sdev->inquiry_len = 36;
 
-	/* Scatter-gather buffers (all but the last) must have a length
-	 * divisible by the bulk maxpacket size.  Otherwise a data packet
-	 * would end up being short, causing a premature end to the data
-	 * transfer.  We'll use the maxpacket value of the bulk-IN pipe
-	 * to set the SCSI device queue's DMA alignment mask.
+	/* USB has unusual DMA-alignment requirements: Although the
+	 * starting address of each scatter-gather element doesn't matter,
+	 * the length of each element except the last must be divisible
+	 * by the Bulk maxpacket value.  There's currently no way to
+	 * express this by block-layer constraints, so we'll cop out
+	 * and simply require addresses to be aligned at 512-byte
+	 * boundaries.  This is okay since most block I/O involves
+	 * hardware sectors that are multiples of 512 bytes in length,
+	 * and since host controllers up through USB 2.0 have maxpacket
+	 * values no larger than 512.
+	 *
+	 * But it doesn't suffice for Wireless USB, where Bulk maxpacket
+	 * values can be as large as 2048.  To make that work properly
+	 * will require changes to the block layer.
 	 */
-	bulk_in_ep = us->pusb_dev->ep_in[usb_pipeendpoint(us->recv_bulk_pipe)];
-	blk_queue_update_dma_alignment(sdev->request_queue,
-			le16_to_cpu(bulk_in_ep->desc.wMaxPacketSize) - 1);
-			/* wMaxPacketSize must be a power of 2 */
+	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
 	/*
 	 * The UFI spec treates the Peripheral Qualifier bits in an

