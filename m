Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYAVSu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYAVSu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYAVStz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:49:55 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58245 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYAVStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:49:51 -0500
Date: Tue, 22 Jan 2008 18:36:18 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
In-Reply-To: <1201022985.3210.24.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0801221813540.8693@blonde.site>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
 <1201022985.3210.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, James Bottomley wrote:
> > --- 2.6.24-rc8-mm1/drivers/ata/libata-scsi.c	2008-01-17 16:49:47.000000000 +0000
> > +++ linux/drivers/ata/libata-scsi.c	2008-01-22 15:45:40.000000000 +0000
> > @@ -826,7 +826,7 @@ static void ata_scsi_sdev_config(struct 
> >  	sdev->max_device_blocked = 1;
> >  
> >  	/* set the min alignment */
> > -	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
> > +	blk_queue_update_dma_alignment(sdev->request_queue, ATA_SECT_SIZE - 1);
> >  }
> >  
> >  static void ata_scsi_dev_config(struct scsi_device *sdev,
> 
> Unfortunately, that's likely not the entire hot fix ... the implication
> is that we have some mapping error in the way we do direct SG_IO.

Quite possibly, I'm not sure.

> What the fix you propose does is make it far more likely that block will
> copy, perform I/O then uncopy (almost certain, since most smartd data
> transfers are well under ATA_SECT_SIZE, which is 512).  However,
> implicating a generic path like this implies that we would get the same
> problem for SCSI commands as well, so the correct hot fix is below.

I've not noticed any problems from the normal activity of the system,
only from smartd's sg_ioctl.  My impression was that it's a libata
issue, because it's going through ata_pio_sector, which does 

	ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);

referring to sect_size, without considering the possibility of any smaller
I/O size.  (Me, I don't even know why it's going PIO rather than DMA:
I'm assuming smartd does things that way, but there's no limit to my
ignorance here.)

> However, I'd like to see if we can track the problem through the SG_IO
> direct path ... how many adjacent page bytes are corrupt?  Just a few or
> a large number (I'm wondering if it's an off by one or off by alignment
> type bug)?

I've assumed it's just the one next page: because ata_pio_sector is
doing a data_xfer of sect_size ATA_SECT_SIZE 512 to an offset above
0xe00 in the smartd stack page.  The time I actually saw corruption
rather than an oops at startup, it was in a tmpfs swap vector page
running 64-bit kernel, and I didn't examine any further pages (just
checked the page before and matched it up to smartd's stack, already
suspecting that).

I don't believe it's an off-by-one at your SCSI end.

Hugh
