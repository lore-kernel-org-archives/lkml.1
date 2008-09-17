Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYIQQc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYIQQc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYIQQct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:32:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:56876 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYIQQcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=n8QoonrrZttuNp9XYgOSdYeIfnv1d+++3gtHmT2SdX7vHfyEl2OboPfV4dYEJutdFx
         s/kcfmAakYHqeN2IgdHJNGawz7SVQCI9YwOfo6z8/XLFa4rToKfB6HM3jekbAhTpIkwv
         G3fM+pC3fmCwFn8wV1HCpqLiMLyyxgSikM7qg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 03/10] ide-atapi: teach ide atapi about drive->waiting_for_dma
Date: Wed, 17 Sep 2008 09:32:08 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <200809152015.51684.bzolnier@gmail.com> <20080917100512.GA28378@gollum.tnic>
In-Reply-To: <20080917100512.GA28378@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809170932.08442.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 03:05:12 Borislav Petkov wrote:
> Hi,
> 
> On Mon, Sep 15, 2008 at 08:15:51PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 14 September 2008 13:35:51 Borislav Petkov wrote:
> > > This is in preparation for converting ide-cd to generic code. The actual
> > > rewiring will be done later after the issue_pc/transfer_pc code knows all about
> > > ide-cd.
> > > 
> > > There should be no functional change resulting from this patch.
> > > 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > ---
> > >  drivers/ide/ide-atapi.c |   16 +++++++++++++---
> > >  1 files changed, 13 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> > > index d557841..763acd7 100644
> > > --- a/drivers/ide/ide-atapi.c
> > > +++ b/drivers/ide/ide-atapi.c
> > > @@ -487,7 +487,13 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
> > >  	ide_startstop_t startstop;
> > >  	u8 ireason;
> > >  
> > > -	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
> > > +	if ((drive->media == ide_cdrom || drive->media == ide_optical) &&
> > > +	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)) {
> > > +		if (drive->dma)
> > > +			drive->waiting_for_dma = 1;
> > > +	}
> > 
> > We really want to do this for all ATAPI devices (as a bugfix).
> > 
> > > +	else if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY,
> > > +			       WAIT_READY)) {
> > 
> > IIRC similar check was removed from ide-cd so maybe this one
> > is also unnecessary?

[ actually, I mistook it for cdrom_start_packet_command() check ]

> Well, according to SFF8020, this chunk is for drives which don't support the
> "Accelerated DRQ" command packet DRQ type and those drives can set the DRQ bit
> as late as 10ms after receiving the PACKET command and I guess those are really
> old. I don't know whether it will be completely safe to remove it - for that

In this case we may as well do the wait on ide-cd devices.

Thanks,
Bart
