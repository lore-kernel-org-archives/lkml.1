Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYKTP2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYKTP2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYKTP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:28:21 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:32929 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755058AbYKTP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:28:20 -0500
Date: Thu, 20 Nov 2008 10:28:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: jens.axboe@oracle.com, <bigeasy@linutronix.de>,
       <Thomas.Hommel@gefanuc.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <James.Bottomley@HansenPartnership.com>
Subject: Re: ISP1760 driver crashes
In-Reply-To: <20081120144125P.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.44L0.0811201026280.2447-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008, FUJITA Tomonori wrote:

> We have been used 4GB for long time if dma_mask is zero (I guess we
> use 4GB as kinda the default dma address limit at several places). The
> majority of drivers (such as pci) sets properly dev->dma_mask so the
> patch might not change anything but suddenly changing the
> long-standing rule in an odd way (use BLK_BOUNCE_HIGH if dma_mask is
> zero) doesn't sound a good idea to me.
> 
> Why not calling blk_queue_bounce_limit() in the slave_configure hook?
> I think that it's the common way for SCSI LLDs with odd bounce limit.

Thomas, here's a patch to do what Tomonori suggests.  Try replacing the 
old patch with this one.

Alan Stern


Index: usb-2.6/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/scsiglue.c
+++ usb-2.6/drivers/usb/storage/scsiglue.c
@@ -129,6 +129,14 @@ static int slave_configure(struct scsi_d
 					      max_sectors);
 	}
 
+	/* Some USB host controllers can't do DMA; they have to use PIO.
+	 * They indicate this by setting their dma_mask to NULL.  For
+	 * such controllers we need to make sure the block layer sets
+	 * up bounce buffers in addressable memory.
+	 */
+	if (!us->pusb_dev->bus->controller->dma_mask)
+		blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_HIGH);
+
 	/* We can't put these settings in slave_alloc() because that gets
 	 * called before the device type is known.  Consequently these
 	 * settings can't be overridden via the scsi devinfo mechanism. */

