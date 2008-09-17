Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYIQKFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYIQKFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYIQKFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:05:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59066 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYIQKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=QI8ZLgcOba1MA2GACnL2a4toSSvhjZA3mSg9jDgHIr0k+WwTxUBD/unG56cGFZFb69
         e3HhNzCv+SSYgbGqKhd12rB5HcApUp+CTbIJSdElk8dJnPqKfqBfcMqFD6ZWIiigMsLy
         fmYw8Y5FfTZkhyrgqQQFYpWyokXaCYchJJ/2s=
Date: Wed, 17 Sep 2008 12:05:12 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/10] ide-atapi: teach ide atapi about
	drive->waiting_for_dma
Message-ID: <20080917100512.GA28378@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <1221392158-3848-4-git-send-email-petkovbb@gmail.com> <200809152015.51684.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809152015.51684.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 15, 2008 at 08:15:51PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 14 September 2008 13:35:51 Borislav Petkov wrote:
> > This is in preparation for converting ide-cd to generic code. The actual
> > rewiring will be done later after the issue_pc/transfer_pc code knows all about
> > ide-cd.
> > 
> > There should be no functional change resulting from this patch.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-atapi.c |   16 +++++++++++++---
> >  1 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> > index d557841..763acd7 100644
> > --- a/drivers/ide/ide-atapi.c
> > +++ b/drivers/ide/ide-atapi.c
> > @@ -487,7 +487,13 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
> >  	ide_startstop_t startstop;
> >  	u8 ireason;
> >  
> > -	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
> > +	if ((drive->media == ide_cdrom || drive->media == ide_optical) &&
> > +	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)) {
> > +		if (drive->dma)
> > +			drive->waiting_for_dma = 1;
> > +	}
> 
> We really want to do this for all ATAPI devices (as a bugfix).
> 
> > +	else if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY,
> > +			       WAIT_READY)) {
> 
> IIRC similar check was removed from ide-cd so maybe this one
> is also unnecessary?

Well, according to SFF8020, this chunk is for drives which don't support the
"Accelerated DRQ" command packet DRQ type and those drives can set the DRQ bit
as late as 10ms after receiving the PACKET command and I guess those are really
old. I don't know whether it will be completely safe to remove it - for that
decision i'm too early in the game :). Anyways, a quick google scan returns
several bug reports in the past hitting that with ide-scsi, ide-floppy and
ide-tape but those are either _really_ old or hint at hardware problems with the
device...

-- 
Regards/Gruss,
    Boris.
