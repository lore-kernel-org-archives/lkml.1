Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZDDMR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZDDMR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZDDMRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:17:12 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51222 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZDDMRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=SU15kQ9kQ4JzaY3LGW9q9BsIaH/D/F8msNmtCkjQOtTwoKFot9EbBAKCZCcfFLEimx
         tzwglzt418TCSIcbGCkRuMj9/MEAC2UBBxOpOSV8qEiG1spezlAwzgXxTCkVxPur1tlw
         h9Ypc/9cfyiLzW2kL680HSDMiA45Pu6hkIjgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/3] ide-cd: cleanup cdrom_decode_status
Date: Sat, 4 Apr 2009 14:00:18 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238655519-10074-2-git-send-email-petkovbb@gmail.com> <200904032139.38756.bzolnier@gmail.com> <20090404094054.GA20223@liondog.tnic>
In-Reply-To: <20090404094054.GA20223@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904041400.18195.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 04 April 2009, Borislav Petkov wrote:
> Hi,
> 
> > ...and this would make me spend a whole weekend trying to track down every
> > little change in code's behavior I went ahead and re-did your patch splitting
> > it on a more fine-grained logical changes (posted in separate patchset, while
> > at it I also fixed REQ_QUIET handling for fs requests).
> > 
> > After that I did a diff between ide-cd.c.old_patch and ide-cd.c.new_patchset
> > and besides some trivial differences I indeed found some subtle problems...
> > 
> > --- ide-cd.c.old_patch	2009-04-03 18:50:23.000000000 +0200
> > +++ ide-cd.c.new_patchset	2009-04-03 21:12:02.000000000 +0200
> > @@ -311,7 +311,7 @@
> >  {
> >  	ide_hwif_t *hwif = drive->hwif;
> >  	struct request *rq = hwif->rq;
> > -	int err, sense_key, do_end_request;
> > +	int err, sense_key, do_end_request = 0;
> >  
> >  	/* get the IDE error register */
> >  	err = ide_read_error(drive);
> > @@ -331,90 +331,104 @@
> >  		return 2;
> >  	}
> >  
> > -	/* if we got an error, pass CHECK_CONDITION as the scsi status byte */
> > +	/* if we got an error, pass CHECK_CONDITION as the SCSI status byte */
> >  	if (blk_pc_request(rq) && !rq->errors)
> >  		rq->errors = SAM_STAT_CHECK_CONDITION;
> >  
> >  	if (blk_noretry_request(rq))
> > -			do_end_request = 1;
> > +		do_end_request = 1;
> >  
> >  	switch (sense_key) {
> >  	case NOT_READY:
> > -		if (blk_fs_request(rq) && (rq_data_dir(rq) == WRITE)) {
> > +		if (blk_fs_request(rq) == 0 || rq_data_dir(rq) == READ) {
> > +			cdrom_saw_media_change(drive);
> > +
> > +			if (blk_fs_request(rq) &&
> > +			    (rq->cmd_flags & REQ_QUIET) == 0)
> > +				printk(KERN_ERR PFX "%s: tray open\n",
> > +					drive->name);
> > +		} else {
> >  			if (ide_cd_breathe(drive, rq))
> >  				return 1;
> > -		} else {
> > -			cdrom_saw_media_change(drive);
> > -			printk(KERN_ERR PFX "%s: tray open\n", drive->name);
> > 
> > original code didn't spam logs for pc requests
> 
> but since we want to unify behavior I don't think we should handle
> the rq verbosity cases differently based on rq type and remove that
> blk_fs_request(rq) check instead. Also, you've inverted the logic for

Right, but it can be changed later (if you are fine with the current
patchset I'll merge it so we can base such improvements on top if it).

> the ide_cd_breathe() case and I'd much rather have it there explicitly
> for clarity. Something like:
> 
> 	if (blk_fs_request(rq) && (rq_data_dir(rq) == WRITE)) {

[ parentheses aroung rq_data_dir() check are not necessary ]

> 		if (ide_cd_breathe(drive, rq))
> 			return 1;
> 	     } else {
>                      cdrom_saw_media_change(drive);
> 
>                          if ((rq->cmd_flags & REQ_QUIET) == 0)
> 				 printk(KERN_ERR PFX "%s: tray open\n",
> 						 drive->name);
> 	     }
> 	break;
> 
> 
> 
> >  		}
> >  		do_end_request = 1;
> >  		break;
> > -
> >  	case UNIT_ATTENTION:
> >  		cdrom_saw_media_change(drive);
> > -		if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC)
> > +
> > +		if (blk_fs_request(rq) == 0)
> >  			return 0;
> > +		/*
> > +		 * Arrange to retry the request but be sure to give up if we've
> > +		 * retried too many times.
> > +		 */
> > +		if (++rq->errors > ERROR_MAX)
> > +			do_end_request = 1;
> 
> We could just as well kill any request which has retried ERROR_MAX
> times, not only the one returning UNIT_ATTENTION, as an upper bound on
> the times travelling through driver and block layer, don't you think?

Hmm, it seems like we already do -- in all cases that we don't end
request unconditionally we either return or do this check...

> That's why I moved the ERROR_MAX check _after_ the switch-case. I know,
> I know, a sentence about it in the commit message would've been quilt
> suitable, i know :)...

Yep, I don't have a remote mind-reading device here (yet)... ;)

[...]

> > +			break;
> > +		/* fall-through */
> > +	case DATA_PROTECT:
> > +		/*
> > +		 * No point in retrying after an illegal request or data
> > +		 * protect error.
> > +		 */
> > +		if ((rq->cmd_flags & REQ_QUIET) == 0)
> >  			ide_dump_status(drive, "command error", stat);
> > 
> > original code respected REQ_QUIET for pc requests
> 
> ok, what's the rationale on being quiet per req_type? In other words, why did we
> respect that for pc requests _and_ _not_ for fs requests?

Historical reasons (please note that it is fixed now in patch #1/5).
