Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYEZTXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYEZTXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYEZTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:23:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:33000 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYEZTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pY3W2ZzBBPPb6GLe7FqirZXg38lsYBOjxknP5VlRP0Fill6yiQWR1OtrWmbnG0jAY+djPBhule3Gf8I0nq+Dsmu6XVD1AHLz76/07ByVKYr4nbNBcz59YWbfmgsJwjN8WzHiaWDyi4YJYNQYNUk/1WyzAvJKMIwNPWgEBoJnLko=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 04/40] ide-scsi: fix Interrupt Reason checking in idescsi_pc_intr()
Date: Tue, 27 May 2008 20:30:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080518185503.5636.98141.sendpatchset@localhost.localdomain> <20080519051032.GB31130@gollum.tnic>
In-Reply-To: <20080519051032.GB31130@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805272030.48438.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008, Borislav Petkov wrote:
> On Sun, May 18, 2008 at 08:55:03PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Set PC_FLAG_WRITING pc flag in idescsi_queue() (if needed)
> > and then fix Interrupt Reason checking in idescsi_pc_intr().
> > 
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/scsi/ide-scsi.c |   17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> > 
> > Index: b/drivers/scsi/ide-scsi.c
> > ===================================================================
> > --- a/drivers/scsi/ide-scsi.c
> > +++ b/drivers/scsi/ide-scsi.c
> > @@ -427,7 +427,15 @@ static ide_startstop_t idescsi_pc_intr (
> >  		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
> >  		return ide_do_reset (drive);
> >  	}
> > -	if (ireason & IO) {
> > +	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
> > +		/* Hopefully, we will never get here */
> > +		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
> > +				"to %s!\n", drive->name,
> > +				(ireason & IO) ? "Write" : "Read",
> > +				(ireason & IO) ? "Read" : "Write");
> > +		return ide_do_reset(drive);
> > +	}
> > +	if (!(pc->flags & PC_FLAG_WRITING)) {
> >  		temp = pc->xferred + bcount;
> >  		if (temp > pc->req_xfer) {
> >  			if (temp > pc->buf_size) {
> > @@ -436,7 +444,6 @@ static ide_startstop_t idescsi_pc_intr (
> >  					"- discarding data\n");
> >  				temp = pc->buf_size - pc->xferred;
> >  				if (temp) {
> > -					pc->flags &= ~PC_FLAG_WRITING;
> >  					if (pc->sg)
> >  						idescsi_input_buffers(drive, pc,
> >  									temp);
> > @@ -457,15 +464,11 @@ static ide_startstop_t idescsi_pc_intr (
> >  			printk (KERN_NOTICE "ide-scsi: The scsi wants to send us more data than expected - allowing transfer\n");
> >  #endif /* IDESCSI_DEBUG_LOG */
> >  		}
> > -	}
> > -	if (ireason & IO) {
> > -		pc->flags &= ~PC_FLAG_WRITING;
> >  		if (pc->sg)
> >  			idescsi_input_buffers(drive, pc, bcount);
> >  		else
> >  			hwif->input_data(drive, NULL, pc->cur_pos, bcount);
> >  	} else {
> > -		pc->flags |= PC_FLAG_WRITING;
> 
> Yeah, what was the driver doing turning on/off that flag in the irq handler? Are
> those pc's getting reused in ide-scsi... I guess this is one of the bugs you
> were talking about :).

I guess that it was a left-over from the old days...

[ nowadays idescsi_queue() dynamically allocates new pc-s ]

Thanks,
Bart
