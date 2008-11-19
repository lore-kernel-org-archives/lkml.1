Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYKSPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYKSPgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYKSPgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:36:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59634 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753487AbYKSPgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:36:36 -0500
Date: Wed, 19 Nov 2008 10:36:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       "Hommel, Thomas (GE EntSol, Intelligent Platforms)" 
	<Thomas.Hommel@gefanuc.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: ISP1760 driver crashes
In-Reply-To: <20081119150010.GK26308@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.0811191027540.2418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Jens Axboe wrote:

> On Wed, Nov 19 2008, Alan Stern wrote:
> > On Wed, 19 Nov 2008, Sebastian Andrzej Siewior wrote:
> > 
> > > Hommel, Thomas (GE EntSol, Intelligent Platforms) wrote:
> > > 
> > > > I indeed have HIGHMEM enabled in my configuration.
> > > > I recompiled the kernel without HIGHMEM and it works. I don't think that
> > > > this a satisfying solution for a board with up to 2GB of RAM and
> > > > considerable amount of VMALLOC space, but at least this works.
> > > > If you have any more ideas how to circumvent this, please let me know.
> > > Sure, this is not a sollution but atleast now I know what happens:
> > > - The kernel allocates memory for transfer
> > > - the memory is highmem and not in kernel so the buffer is NULL
> > > - we don't have a dma-mask and therefore the dma address is 0
> > > - boom
> > > 
> > > The sollution would be probably to prevent the usb-storage core to 
> > > allocate memory from HIGHMEM.
> > 
> > usb-storage doesn't allocate the memory.  The memory is allocated by 
> > the block layer or the filesystem.
> > 
> > > Now I don't if there is a flag for something 
> > > like that and I am not using that. On the other hand this may be broken 
> > > for a long time and you are the first one which has that much memory with 
> > > no DMA-capable USB controller.
> > 
> > Jens, is there any way to tell the kernel that a device uses PIO and 
> > therefore its buffers shouldn't be allocated in high memory?  For 
> > example, shouldn't a NULL dma_mask do this?
> 
> Sure, just use blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH), then you are
> certain that you will always have a virtual mapping for the IO you
> receive.
> 
> Or you can use the bio kmap/kunmap helpers to get such a mapping
> temporarily if you wish. But if your pio condition is permanent, you may
> as well just use bouncing.

Thank you.

Thomas, the blk_queue_bounce_limit() routine is called in 
drivers/scsi/scsi_lib.c:__scsi_alloc_queue().  The value it passes is 
computed by scsi_calculate_bounce_limit(), and in that routine 
host_dev->dma_mask should be NULL (since isp1760-hcd sets the mask to 
NULL).  Therefore the bounce limit should be 0xffffffff.

Now maybe this value isn't correct.  You can try the patch below to see 
if it helps.  If it doesn't, add a printk in __scsi_alloc_queue() to 
see what bounce limit value is getting used.

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -1684,7 +1684,7 @@ static void scsi_request_fn(struct reque
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
-	u64 bounce_limit = 0xffffffff;
+	u64 bounce_limit = BLK_BOUNCE_HIGH;
 
 	if (shost->unchecked_isa_dma)
 		return BLK_BOUNCE_ISA;

