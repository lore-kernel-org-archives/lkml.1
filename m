Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYHRTMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYHRTMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbYHRTHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:07:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763091AbYHRTHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:07:32 -0400
Date: Mon, 18 Aug 2008 11:45:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 56/60] usb-storage: revert DMA-alignment change for
	Wireless USB
Message-ID: <20080818184537.GE29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-revert-dma-alignment-change-for-wireless-usb.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit f756cbd458ab71c996a069cb3928fb1e2d7cd9cc upstream.

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
not try to use them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/scsiglue.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -73,7 +73,6 @@ static const char* host_info(struct Scsi
 static int slave_alloc (struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
-	struct usb_host_endpoint *bulk_in_ep;
 
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -82,16 +81,22 @@ static int slave_alloc (struct scsi_devi
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

-- 
