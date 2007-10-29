Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbXJ2JOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbXJ2JOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXJ2JO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:14:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10998 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbXJ2JO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:14:28 -0400
Date: Mon, 29 Oct 2007 10:12:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist fallout: drivers/scsi/arm/
Message-ID: <20071029091206.GE5467@kernel.dk>
References: <20071027184404.GQ8181@ftp.linux.org.uk> <20071027201700.GC22235@flint.arm.linux.org.uk> <20071029085935.GD5467@kernel.dk> <20071029090710.GB7801@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029090710.GB7801@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2007, Russell King wrote:
> On Mon, Oct 29, 2007 at 09:59:36AM +0100, Jens Axboe wrote:
> > On Sat, Oct 27 2007, Russell King wrote:
> > > On Sat, Oct 27, 2007 at 07:44:04PM +0100, Al Viro wrote:
> > > > 
> > > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > ---
> > > > diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
> > > > index 21ba571..2d09fef 100644
> > > > --- a/drivers/scsi/arm/scsi.h
> > > > +++ b/drivers/scsi/arm/scsi.h
> > > > @@ -39,7 +39,7 @@ static inline int next_SCp(struct scsi_pointer *SCp)
> > > >  		SCp->buffer++;
> > > >  		SCp->buffers_residual--;
> > > >  		SCp->ptr = (char *)
> > > > -			 (page_address(SCp->buffer->page) +
> > > > +			 (page_address(sg_page(SCp->buffer)) +
> > > >  			  SCp->buffer->offset);
> > > >  		SCp->this_residual = SCp->buffer->length;
> > > >  	} else {
> > > > @@ -77,7 +77,7 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
> > > >  		SCpnt->SCp.buffer = (struct scatterlist *) SCpnt->request_buffer;
> > > >  		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
> > > >  		SCpnt->SCp.ptr = (char *)
> > > > -			 (page_address(SCpnt->SCp.buffer->page) +
> > > > +			 (page_address(sg_page(SCpnt->SCp.buffer)) +
> > > >  			  SCpnt->SCp.buffer->offset);
> > > >  		SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
> > > >  		SCpnt->SCp.phase = SCpnt->request_bufflen;
> > > 
> > > FYI, here's what I have queued (cut'n'pasted so probably won't apply):
> > > 
> > > diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
> > > index 21ba571..bb6550e 100644
> > > --- a/drivers/scsi/arm/scsi.h
> > > +++ b/drivers/scsi/arm/scsi.h
> > > @@ -38,9 +38,7 @@ static inline int next_SCp(struct scsi_pointer *SCp)
> > >         if (ret) {
> > >                 SCp->buffer++;
> > >                 SCp->buffers_residual--;
> > > -               SCp->ptr = (char *)
> > > -                        (page_address(SCp->buffer->page) +
> > > -                         SCp->buffer->offset);
> > > +               SCp->ptr = sg_virt(SCp->buffer);
> > >                 SCp->this_residual = SCp->buffer->length;
> > >         } else {
> > >                 SCp->ptr = NULL;
> > > @@ -76,9 +74,7 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
> > > 
> > >                 SCpnt->SCp.buffer = (struct scatterlist *) SCpnt->request_buffer;
> > >                 SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
> > > -               SCpnt->SCp.ptr = (char *)
> > > -                        (page_address(SCpnt->SCp.buffer->page) +
> > > -                         SCpnt->SCp.buffer->offset);
> > > +               SCpnt->SCp.ptr = sg_virt(SCpnt->SCp.buffer);
> > >                 SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
> > >                 SCpnt->SCp.phase = SCpnt->request_bufflen;
> > 
> > Russell, will you be merging this yourself or do you want me to include
> > it in the sg fixup branch?
> 
> It's already merged into the ARM git tree as of Friday.  Waiting for
> ack's from various people for other merged patches before sending the
> set to Linus.

Great, thanks.

-- 
Jens Axboe

