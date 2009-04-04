Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbZDDJlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbZDDJlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 05:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbZDDJlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 05:41:07 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:64993 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061AbZDDJlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=OY+G9sA95wJnl5hcqW8tbpRxlAgiMGlwsny/bvet+Jntmk5rxUSUQHWeNIZc+/YKn5
         JlKjQFIVvsb3qgTCOCj0GTpn/KyrIm+o+HdjSW7M+zVdHuMQmbQy714ZMpJjlY0V/ePM
         nqWVCs8wLJAHxRoqwDdkMyP8AIuA2Stu+dE1Y=
Date: Sat, 4 Apr 2009 11:40:54 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ide-cd: cleanup cdrom_decode_status
Message-ID: <20090404094054.GA20223@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238655519-10074-2-git-send-email-petkovbb@gmail.com> <200904031241.44597.bzolnier@gmail.com> <9ea470500904030703k9285e0eye5487f825df77e6@mail.gmail.com> <200904032139.38756.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200904032139.38756.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> ...and this would make me spend a whole weekend trying to track down every
> little change in code's behavior I went ahead and re-did your patch splitting
> it on a more fine-grained logical changes (posted in separate patchset, while
> at it I also fixed REQ_QUIET handling for fs requests).
> 
> After that I did a diff between ide-cd.c.old_patch and ide-cd.c.new_patchset
> and besides some trivial differences I indeed found some subtle problems...
> 
> --- ide-cd.c.old_patch	2009-04-03 18:50:23.000000000 +0200
> +++ ide-cd.c.new_patchset	2009-04-03 21:12:02.000000000 +0200
> @@ -311,7 +311,7 @@
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct request *rq = hwif->rq;
> -	int err, sense_key, do_end_request;
> +	int err, sense_key, do_end_request = 0;
>  
>  	/* get the IDE error register */
>  	err = ide_read_error(drive);
> @@ -331,90 +331,104 @@
>  		return 2;
>  	}
>  
> -	/* if we got an error, pass CHECK_CONDITION as the scsi status byte */
> +	/* if we got an error, pass CHECK_CONDITION as the SCSI status byte */
>  	if (blk_pc_request(rq) && !rq->errors)
>  		rq->errors = SAM_STAT_CHECK_CONDITION;
>  
>  	if (blk_noretry_request(rq))
> -			do_end_request = 1;
> +		do_end_request = 1;
>  
>  	switch (sense_key) {
>  	case NOT_READY:
> -		if (blk_fs_request(rq) && (rq_data_dir(rq) == WRITE)) {
> +		if (blk_fs_request(rq) == 0 || rq_data_dir(rq) == READ) {
> +			cdrom_saw_media_change(drive);
> +
> +			if (blk_fs_request(rq) &&
> +			    (rq->cmd_flags & REQ_QUIET) == 0)
> +				printk(KERN_ERR PFX "%s: tray open\n",
> +					drive->name);
> +		} else {
>  			if (ide_cd_breathe(drive, rq))
>  				return 1;
> -		} else {
> -			cdrom_saw_media_change(drive);
> -			printk(KERN_ERR PFX "%s: tray open\n", drive->name);
> 
> original code didn't spam logs for pc requests

but since we want to unify behavior I don't think we should handle
the rq verbosity cases differently based on rq type and remove that
blk_fs_request(rq) check instead. Also, you've inverted the logic for
the ide_cd_breathe() case and I'd much rather have it there explicitly
for clarity. Something like:

	if (blk_fs_request(rq) && (rq_data_dir(rq) == WRITE)) {
		if (ide_cd_breathe(drive, rq))
			return 1;
	     } else {
                     cdrom_saw_media_change(drive);

                         if ((rq->cmd_flags & REQ_QUIET) == 0)
				 printk(KERN_ERR PFX "%s: tray open\n",
						 drive->name);
	     }
	break;



>  		}
>  		do_end_request = 1;
>  		break;
> -
>  	case UNIT_ATTENTION:
>  		cdrom_saw_media_change(drive);
> -		if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC)
> +
> +		if (blk_fs_request(rq) == 0)
>  			return 0;
> +		/*
> +		 * Arrange to retry the request but be sure to give up if we've
> +		 * retried too many times.
> +		 */
> +		if (++rq->errors > ERROR_MAX)
> +			do_end_request = 1;

We could just as well kill any request which has retried ERROR_MAX
times, not only the one returning UNIT_ATTENTION, as an upper bound on
the times travelling through driver and block layer, don't you think?
That's why I moved the ERROR_MAX check _after_ the switch-case. I know,
I know, a sentence about it in the commit message would've been quilt
suitable, i know :)...

>  		break;
> -
>  	case ILLEGAL_REQUEST:
> -	case DATA_PROTECT:
>  		/*
> -		 * Don't print error message for this condition since SFF8090i
> +		 * Don't print error message for this condition -- SFF8090i
>  		 * indicates that 5/24/00 is the correct response to a request
>  		 * to close the tray if the drive doesn't have that capability.
>  		 *
>  		 * cdrom_log_sense() knows this!
>  		 */
> -		if (rq->cmd[0] != GPCMD_START_STOP_UNIT) {
> +		if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
> 
> this was checked only for ILLEGAL_REQUEST and not DATA_PROTECT

ah, that's correct, thanks for catching that.

> +			break;
> +		/* fall-through */
> +	case DATA_PROTECT:
> +		/*
> +		 * No point in retrying after an illegal request or data
> +		 * protect error.
> +		 */
> +		if ((rq->cmd_flags & REQ_QUIET) == 0)
>  			ide_dump_status(drive, "command error", stat);
> 
> original code respected REQ_QUIET for pc requests

ok, what's the rationale on being quiet per req_type? In other words, why did we
respect that for pc requests _and_ _not_ for fs requests?

> -			do_end_request = 1;
> -		}
> +		do_end_request = 1;
>  		break;
> -
>  	case MEDIUM_ERROR:
>  		/*
> -		 * No point in re-trying a zillion times on a bad sector. If we
> -		 * got here the error is not correctable.
> +		 * No point in re-trying a zillion times on a bad sector.
> +		 * If we got here the error is not correctable.
>  		 */
> -		ide_dump_status(drive, "media error (bad sector)", stat);
> +		if ((rq->cmd_flags & REQ_QUIET) == 0)
> +			ide_dump_status(drive, "media error "
> +					"(bad sector)", stat);
> 
> ditto
> 
>  		do_end_request = 1;
>  		break;
> -
>  	case BLANK_CHECK:
> -		/* disk appears blank ?? */
> -		ide_dump_status(drive, "media error (blank)", stat);
> +		/* disk appears blank? */
> +		if ((rq->cmd_flags & REQ_QUIET) == 0)
> +			ide_dump_status(drive, "media error (blank)",
> +					stat);
> 
> ditto
> 
>  		do_end_request = 1;
>  		break;
> -
>  	default:
> +		if (blk_fs_request(rq) == 0)
> +			break;
>  		if (err & ~ATA_ABORTED) {
>  			/* go to the default handler for other errors */
>  			ide_error(drive, "cdrom_decode_status", stat);
>  			return 1;
> 
> we can think about doing this also for pc requests but original code
> didn't do it so we shouldn't mix it with purely cleanup changes
> 
> -		}
> -
> -		if (!(rq->cmd_flags & REQ_QUIET)) {
> -			ide_dump_status(drive, "command error", stat);
> -			blk_dump_rq_flags(rq, PFX "failing rq");
> -		}
> -
> -		do_end_request = 1;
> 
> this looks like a real regression -- in such situation original code
> ended fs requests only if (++rq->errors > ERROR_MAX)

right.

> -		break;
> +		} else if (++rq->errors > ERROR_MAX)
> +			/* we've racked up too many retries, abort */
> +			do_end_request = 1;
>  	}
>  
> -	/* we've racked up too many retries, abort */
> -	if (++rq->errors > ERROR_MAX)
> +	if (blk_fs_request(rq) == 0) {
> +		rq->cmd_flags |= REQ_FAILED;
>  		do_end_request = 1;
> +	}
>  
> -	if (do_end_request) {
> -		rq->cmd_flags |= REQ_FAILED;
> 
> we may set this flag also for fs requests but separate patch is preferred
> 
> +	/*
> +	 * End a request through request sense analysis when we have sense data.
> +	 * We need this in order to perform end of media processing.
> +	 */
> +	if (do_end_request)
>  		goto end_request;
> -	}
>  
> -	/* If we got a CHECK_CONDITION status, queue a request sense command. */
> +	/* if we got a CHECK_CONDITION status, queue a request sense command */
>  	if (stat & ATA_ERR)
>  		cdrom_queue_request_sense(drive, NULL, NULL);
> -
>  	return 1;
>  
>  end_request:

-- 
Regards/Gruss,
    Boris.
