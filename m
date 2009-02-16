Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZBPJZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZBPJZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZBPJZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:25:00 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:65339 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZBPJY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=CQW6gQrghlvbueoB2ZyLhJc9cTF+5OQ+ZeQn6agdNxex3knUEG7vGNp9K9qeyIwSbx
         ykfVrluN6a2omK/qIjCF0w/VqfF7Axeiaa8LYTiUsS9j6yz3sPL8PwPvrepwswskkwK+
         VcZTroBAiVw0yBT0NUwWZBvOB0vMpLKfrVqS0=
Date: Mon, 16 Feb 2009 10:25:01 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/20] ide-cd: unify cdrom_newpc_intr() exit paths
Message-ID: <20090216092501.GA24323@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain> <20090216001422.27491.17281.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090216001422.27491.17281.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:14:22AM +0100, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-cd: unify cdrom_newpc_intr() exit paths
> 
> * Move cdrom_end_request() calls from cdrom_decode_status()
>   and ide_cd_check_ireason() to cdrom_newpc_intr().
> 
> * Unify cdrom_newpc_intr() exit paths.
> 
> There should be no functional changes caused by this patch.
> 
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-cd.c |   48 +++++++++++++++++++++++-------------------------
>  1 file changed, 23 insertions(+), 25 deletions(-)
> 
> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -291,7 +291,8 @@ static void cdrom_end_request(ide_drive_
>  /*
>   * Returns:
>   * 0: if the request should be continued.
> - * 1: if the request was ended.
> + * 1: if the request will be going through error recovery.
> + * 2: if the request should be ended.

Yeah, we need defines for those. Especially if they're checked in other
functions:

if (rc == 2)

is simply not ok :). Rather,

if (rc == DO_END_REQUEST)

or something like that is much better, imho.

>   */
>  static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
>  {
> @@ -324,10 +325,7 @@ static int cdrom_decode_status(ide_drive
>  		 * Just give up.
>  		 */
>  		rq->cmd_flags |= REQ_FAILED;
> -		cdrom_end_request(drive, 0);
> -		ide_error(drive, "request sense failure", stat);
> -		return 1;
> -
> +		return 2;
>  	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
>  		/* All other functions, except for READ. */
>  
> @@ -467,14 +465,12 @@ static int cdrom_decode_status(ide_drive
>  		 */
>  		if (stat & ATA_ERR)
>  			cdrom_queue_request_sense(drive, NULL, NULL);
> +		return 1;
>  	} else {
>  		blk_dump_rq_flags(rq, PFX "bad rq");
> -		cdrom_end_request(drive, 0);
> +		return 2;
>  	}
>  
> -	/* retry, or handle the next request */
> -	return 1;
> -
>  end_request:
>  	if (stat & ATA_ERR) {
>  		struct request_queue *q = drive->queue;
> @@ -487,10 +483,9 @@ end_request:
>  		hwif->rq = NULL;
>  
>  		cdrom_queue_request_sense(drive, rq->sense, rq);
> +		return 1;
>  	} else
> -		cdrom_end_request(drive, 0);
> -
> -	return 1;
> +		return 2;
>  }
>  
>  /*
> @@ -534,7 +529,6 @@ static int ide_cd_check_ireason(ide_driv
>  	if (rq->cmd_type == REQ_TYPE_ATA_PC)
>  		rq->cmd_flags |= REQ_FAILED;
>  
> -	cdrom_end_request(drive, 0);
>  	return -1;
>  }
>  
> @@ -736,7 +730,8 @@ static ide_startstop_t cdrom_newpc_intr(
>  	xfer_func_t *xferfunc;
>  	ide_expiry_t *expiry = NULL;
>  	int dma_error = 0, dma, stat, thislen, uptodate = 0;
> -	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
> +	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc;
> +	int sense = blk_sense_request(rq);
>  	unsigned int timeout;
>  	u16 len;
>  	u8 ireason;
> @@ -756,8 +751,12 @@ static ide_startstop_t cdrom_newpc_intr(
>  		}
>  	}
>  
> -	if (cdrom_decode_status(drive, 0, &stat))
> +	rc = cdrom_decode_status(drive, 0, &stat);
> +	if (rc) {
> +		if (rc == 2)
> +			goto out_end;
>  		return ide_stopped;
> +	}
>  
>  	/* using dma, transfer is complete now */
>  	if (dma) {
> @@ -802,8 +801,6 @@ static ide_startstop_t cdrom_newpc_intr(
>  					rq->cmd_flags |= REQ_FAILED;
>  				uptodate = 0;
>  			}
> -			cdrom_end_request(drive, uptodate);
> -			return ide_stopped;
>  		} else if (!blk_pc_request(rq)) {
>  			ide_cd_request_sense_fixup(drive, rq);
>  			/* complain if we still have data left to transfer */
> @@ -815,17 +812,16 @@ static ide_startstop_t cdrom_newpc_intr(
>  	}
>  
>  	/* check which way to transfer data */
> -	if (ide_cd_check_ireason(drive, rq, len, ireason, write))
> -		return ide_stopped;
> +	rc = ide_cd_check_ireason(drive, rq, len, ireason, write);
> +	if (rc)
> +		goto out_end;
>  
>  	if (blk_fs_request(rq)) {
>  		if (write == 0) {
>  			int nskip;
>  
> -			if (ide_cd_check_transfer_size(drive, len)) {
> -				cdrom_end_request(drive, 0);
> -				return ide_stopped;
> -			}
> +			if (ide_cd_check_transfer_size(drive, len))
> +				goto out_end;
>  
>  			/*
>  			 * First, figure out if we need to bit-bucket
> @@ -918,7 +914,7 @@ static ide_startstop_t cdrom_newpc_intr(
>  			else
>  				rq->data += blen;
>  		}
> -		if (!write && blk_sense_request(rq))
> +		if (sense && write == 0)
>  			rq->sense_len += blen;
>  	}
>  
> @@ -939,7 +935,7 @@ static ide_startstop_t cdrom_newpc_intr(
>  	return ide_started;
>  
>  out_end:
> -	if (blk_pc_request(rq)) {
> +	if (blk_pc_request(rq) && rc == 0) {
>  		unsigned int dlen = rq->data_len;
>  
>  		if (dma)
> @@ -951,6 +947,8 @@ out_end:
>  		hwif->rq = NULL;
>  	} else {
>  		cdrom_end_request(drive, uptodate);
> +		if (sense && rc == 2)
> +			ide_error(drive, "request sense failure", stat);
>  	}
>  	return ide_stopped;
>  }

-- 
Regards/Gruss,
    Boris.
