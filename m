Return-Path: <linux-kernel-owner+w=401wt.eu-S2992593AbXCGVQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992593AbXCGVQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992614AbXCGVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:16:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:50668 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992593AbXCGVQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:16:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XFemZg7A1n2tsjoFB7dWF1wSD1sn57mufjiI1SdJbaLcLzDsDZzdQH8z7yslu9NgjaJ1wc890q2izj+UYd00Sq9czmwVXVwm+LSNH9HyH3iS6QCDnmWcpIxCi+15ySB9oVTEhent+FihCfcWXX9azKQy2yZOXnnc3bxlZ9bjIVs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Subject: Re: [PATCH 3/3] Use correct IDE error recovery
Date: Wed, 7 Mar 2007 22:16:08 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070221012304.GC1777@freefall.freebsd.org>
In-Reply-To: <20070221012304.GC1777@freefall.freebsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703072216.08295.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

(sorry for the long delay)

On Wednesday 21 February 2007, Suleiman Souhlal wrote:
> IDE error recovery is using WIN_IDLEIMMEDIATE which was only valid for
> IDE V1 and IDE V2.  Modern drives will not be able to recover using
> this error handling.  The correct thing to do is issue a SRST followed
> by a SET_FEATURES.

This change looks fine, indeed we are better of using SRST + SET_FEATURES
than IDLE_IMMEDIATE.

> Signed-off-by:	Suleiman Souhlal <suleiman@google.com>
> 
> ---
>  drivers/ide/ide-io.c   |   35 +++++++++++-----
>  drivers/ide/ide-iops.c |  105 ++++++++++++++++++++++++++++--------------------
>  include/linux/ide.h    |    2 +
>  3 files changed, 88 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index c193553..2f05b4d 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -519,21 +519,21 @@ static ide_startstop_t ide_ata_error(ide
>  	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ && hwif->err_stops_fifo == 0)
>  		try_to_flush_leftover_data(drive);
>  
> +	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
> +		ide_kill_rq(drive, rq);
> +		return ide_stopped;
> +	}
> +
>  	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
> -		/* force an abort */
> -		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
> +		rq->errors |= ERROR_RESET;
>  
> -	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq))
> -		ide_kill_rq(drive, rq);
> -	else {
> -		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
> -			++rq->errors;
> -			return ide_do_reset(drive);
> -		}
> -		if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
> -			drive->special.b.recalibrate = 1;

Is the removal of ERROR_RECAL handling intentional?
There is nothing about it in the patch description...

> +	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
>  		++rq->errors;
> +		return ide_do_reset(drive);
>  	}
> +
> +	++rq->errors;
> +
>  	return ide_stopped;
>  }
>  
> @@ -586,6 +586,13 @@ EXPORT_SYMBOL_GPL(__ide_error);
>   *	both new-style (taskfile) and old style command handling here.
>   *	In the case of taskfile command handling there is work left to
>   *	do
> + *	This used to send a idle immediate to the drive if the drive was
> + *	busy or had drq set.  This violates the ATA spec (can only send IDLE
> + *	immediate when drive is not busy) and really hoses up some drives.

Could this part of the comment be merged into the patch description?
We don't want to clutter the code with the history of the changes.

> + *	We've changed it to just do a SRST followed by a set features (set
> + *	udma mode) it those cases.  This is what Western Digital recommends

hmm, it doesn't have to be UDMA mode,
->current_speed can also be PIO/SWDMA/MWDMA

> + *	for error recovery and what Western Digital says Windows does.  It
> + *	also does not violate the ATA spec as far as I can tell.
>   */

The patch fixes code in ide_ata_error() and updates the comment
for ide_error() but ide_atapi_error() is not left untouched
(it still uses IDLE IMMEDIATE).

I suppose that ide_atapi_error() (for ATAPI devices) needs similar fix?

>  ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
> @@ -1004,6 +1011,12 @@ #endif
>  		goto kill_rq;
>  	}
>  
> +	/* We reset the drive so we need to issue a SETFEATURES. */
> +	if ((drive->current_speed == 0xff) &&
> +	    ((rq->cmd_type == REQ_TYPE_ATA_CMD) ||
> +	    (rq->cmd_type == REQ_TYPE_ATA_TASK)))
> +		ide_config_drive_speed_irq(drive, drive->desired_speed);

Please update the patch to not depend on ide_config_drive_speed() fixes
[PATCH 2/3] which need more work (shouldn't be a problem as the code here
uses _irq variant anyway).

Please respin the patch so I could merge it.

Thanks,
Bart
