Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbYEUEnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbYEUEnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYEUEn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:43:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37206 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYEUEn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:43:28 -0400
Date: Tue, 20 May 2008 21:43:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix sleep-while-holding-spinlock in sata_nv
Message-ID: <20080520214311.2d2aa8d3@infradead.org>
In-Reply-To: <48338624.3000304@shaw.ca>
References: <fa.m+kShlzXY/wmFlvZXsE0W7wQIxU@ifi.uio.no>
	<48338624.3000304@shaw.ca>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 20:17:08 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Arjan van de Ven wrote:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: [PATCH] ata: fix sleep-while-holding-spinlock in sata_nv
> > 
> > blk_queue_bounce_limit() is a sleeping function, so reorganize
> > the code a little to not call it while holding a spinlock.
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > ---
> >  drivers/ata/sata_nv.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> > index 858f706..a7bc56d 100644
> > --- a/drivers/ata/sata_nv.c
> > +++ b/drivers/ata/sata_nv.c
> > @@ -671,6 +671,11 @@ static int nv_adma_slave_config(struct
> > scsi_device *sdev) port1 = ap->host->ports[1]->private_data;
> >  	sdev0 = ap->host->ports[0]->link.device[0].sdev;
> >  	sdev1 = ap->host->ports[1]->link.device[0].sdev;
> > +
> > +	blk_queue_segment_boundary(sdev->request_queue,
> > segment_boundary);
> > +	blk_queue_max_hw_segments(sdev->request_queue,
> > sg_tablesize);
> > +	spin_unlock_irqrestore(ap->lock, flags);
> > +
> >  	if ((port0->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
> >  	    (port1->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
> >  		/** We have to set the DMA mask to 32-bit if
> > either port is in @@ -701,14 +706,11 @@ static int
> > nv_adma_slave_config(struct scsi_device *sdev) pp->adma_dma_mask);
> >  	}
> >  
> > -	blk_queue_segment_boundary(sdev->request_queue,
> > segment_boundary);
> > -	blk_queue_max_hw_segments(sdev->request_queue,
> > sg_tablesize); ata_port_printk(ap, KERN_INFO,
> >  		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs
> > %hu\n", (unsigned long long)*ap->host->dev->dma_mask,
> >  		segment_boundary, sg_tablesize);
> >  
> > -	spin_unlock_irqrestore(ap->lock, flags);
> >  
> >  	return rc;
> >  }
> 
> I'm not certain this is safe to do it quite this way. It would be
> better to keep that spinlock held so that no operations could be in
> progress on either port while these operations are happening.

blk_bounce_limit can sleep. that's just a fact of life ;(

> 
> It would be better to fix the regression from 
> 419c434c35614609fd0c79d335c134bf4b88b30b in block/blk_settings.c that 
> resulted in the blk_queue_bounce_limit allocation wrongly allocating 
> emergency ISA pages in the first place as a 32-bit DMA mask does not 
> need them.

the condition under which it sleeps might be slightly buggy on your
exact x86 machine... but that doesn't mean that that is guaranteed to
be so forever going forward.... it's still a sleeping function.

