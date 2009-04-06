Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZDFVNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZDFVNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbZDFVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:11:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55424 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664AbZDFVLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=VdZZ9BwFV/hwjaq91AX4TJwlNl9H6c4MSLlXGXq7bBiSJb+wy6UmNjWohuNBAvisTx
         jtZL74GVH6tk8K0C924WB3WK+LePzIvNdXQB2wM/Ps2Avn3hHecytvZoriF3LzXtX9Kd
         UZabfBOpJCcrYjkm1Vi/1gVWpTx+SALuBHENI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 1/5] ide-cd: respect REQ_QUIET for fs requests in cdrom_decode_status()
Date: Mon, 6 Apr 2009 22:58:40 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090403195757.31438.16866.sendpatchset@localhost.localdomain> <20090405051342.GB4189@liondog.tnic>
In-Reply-To: <20090405051342.GB4189@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904062258.41148.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009, Borislav Petkov wrote:
> On Fri, Apr 03, 2009 at 09:57:57PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide-cd: respect REQ_QUIET for fs requests in cdrom_decode_status()
> > 
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-cd.c |   15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > Index: b/drivers/ide/ide-cd.c
> > ===================================================================
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -382,7 +382,8 @@ static int cdrom_decode_status(ide_drive
> >  				cdrom_saw_media_change(drive);
> >  
> >  				/* fail the request */
> > -				printk(KERN_ERR PFX "%s: tray open\n",
> > +				if ((rq->cmd_flags & REQ_QUIET) == 0)
> > +					printk(KERN_ERR PFX "%s: tray open\n",
> >  						drive->name);
> >  			} else {
> >  				if (ide_cd_breathe(drive, rq))
> > @@ -405,19 +406,23 @@ static int cdrom_decode_status(ide_drive
> >  			 * No point in retrying after an illegal request or data
> >  			 * protect error.
> >  			 */
> > -			ide_dump_status(drive, "command error", stat);
> > +			if ((rq->cmd_flags & REQ_QUIET) == 0)
> > +				ide_dump_status(drive, "command error", stat);
> >  			do_end_request = 1;
> >  		} else if (sense_key == MEDIUM_ERROR) {
> >  			/*
> >  			 * No point in re-trying a zillion times on a bad
> >  			 * sector. If we got here the error is not correctable.
> >  			 */
> > -			ide_dump_status(drive, "media error (bad sector)",
> > -					stat);
> > +			if ((rq->cmd_flags & REQ_QUIET) == 0)
> > +				ide_dump_status(drive, "media error "
> > +						"(bad sector)", stat);
> >  			do_end_request = 1;
> >  		} else if (sense_key == BLANK_CHECK) {
> >  			/* disk appears blank ?? */
> > -			ide_dump_status(drive, "media error (blank)", stat);
> > +			if ((rq->cmd_flags & REQ_QUIET) == 0)
> > +				ide_dump_status(drive, "media error (blank)",
> > +						stat);
> >  			do_end_request = 1;
> >  		} else if ((err & ~ATA_ABORTED) != 0) {
> >  			/* go to the default handler for other errors */
> 
> 
> Let's cache the REQ_QUIET value instead, for slightly better readability:
> 
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sun, 5 Apr 2009 06:40:50 +0200
> Subject: [PATCH] ide-cd: respect REQ_QUIET for fs requests in cdrom_decode_status()
> 
> There should be no functional change resulting from this patch.
> 
> Suggested-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Yes, this version is better, applied.

I also applied patches 2-5 (correcting "From:" line in patches 3 & 5,
re-adding your attribution to 3-5 and fixing "S-o-b:" order in 3-5).

[ S-o-B order should be:

  - me
  - you
  - me (this one added now)

  to show the correct patch history -- the fact that I'm also
  the final committer doesn't matter. ]

Patch #5 had a small whitespace mismatch introduced while re-diffing
(also fixed now):

@@ -412,13 +413,14 @@
 		} else if (++rq->errors > ERROR_MAX)
 			/* we've racked up too many retries, abort */
 			do_end_request = 1;
+
+
 	}
 
 	if (blk_fs_request(rq) == 0) {
 		rq->cmd_flags |= REQ_FAILED;
 		do_end_request = 1;
 	}
-
 	/*
 	 * End a request through request sense analysis when we have sense data.
 	 * We need this in order to perform end of media processing.

Thanks,
Bart
