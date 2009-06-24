Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZFXBtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZFXBtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZFXBso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:48:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:29183 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZFXBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=qJgOuaYr8+OGwyWdhBg064NPtbYrmL7tViWJCziK4hL7wrtw28gJzwrwAsGHQHP/Nm
         Ysw2wOEsOsUBQxNmUt1seN5jTXN12L6F8wrVEv+jtjo0GdjNehl0KDChcMsYD4fTzpyV
         PFVgNOJyRzPhXhjpKzmuwrYgMhe0NvP2ig84w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests
Date: Wed, 24 Jun 2009 02:49:21 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
References: <200906232326.06830.bzolnier@gmail.com> <20090623.161611.139291300.davem@davemloft.net>
In-Reply-To: <20090623.161611.139291300.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906240249.22531.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 01:16:11 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 23 Jun 2009 23:26:06 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests
> > 
> > Such requests should be failed with -EIO (like all other requests
> > in this function) instead of being completed successfully.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Untested, you may try pinging Borislav and/or Tejun about possible
> > testing if you would like to verify the patch before applying.
> 
> This must be tested in some way.  I can see this potentially
> breaking something.
> 
> Especially this is true because ide_complete_rq() does it's
> "complete whole request right now" logic for error <= 0.

        /*
         * if failfast is set on a request, override number of sectors
         * and complete the whole request right now
         */
        if (blk_noretry_request(rq) && error <= 0)
                nr_bytes = blk_rq_sectors(rq) << 9;

It is a historical leftover from the days that we did partial request
completions.  Please notice that the patch doesn't affect this chunk.

> Borislov/Tejun, can either of you test this code path with this
> change applied?  I'd very much appreciate it.
> 
> Thanks!
> 
> >  drivers/ide/ide-io.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: b/drivers/ide/ide-io.c
> > ===================================================================
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> > @@ -152,7 +152,7 @@ void ide_kill_rq(ide_drive_t *drive, str
> >  
> >  	if ((media == ide_floppy || media == ide_tape) && drv_req) {
> >  		rq->errors = 0;
> > -		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
> > +		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
> >  	} else {
> >  		if (media == ide_tape)
> >  			rq->errors = IDE_DRV_ERROR_GENERAL;
> 
