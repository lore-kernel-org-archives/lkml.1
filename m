Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXCXOGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXCXOGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 10:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXCXOGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 10:06:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:29173 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbXCXOGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 10:06:34 -0400
Message-ID: <46053091.9090307@ru.mvista.com>
Date: Sat, 24 Mar 2007 17:07:13 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 3/3] Use correct IDE error recovery
References: <20070221012304.GC1777@freefall.freebsd.org> <200703072216.08295.bzolnier@gmail.com> <B2D4536E-D449-4D10-B745-30D25CAC40A4@freebsd.org> <200703240053.42845.bzolnier@gmail.com>
In-Reply-To: <200703240053.42845.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Since I think that it's worth to have it in 2.6.21-final and respin didn't
> happen I did the required changes myself (it also turned out that I missed
> few things during initial review), then applied the patch...

> Please let my know whether you are fine with my changes, thanks.

> [PATCH] ide: use correct IDE error recovery

> From: Suleiman Souhlal <suleiman@google.com>

> IDE error recovery is using IDLE IMMEDIATE if the drive is busy or has DRQ set.
> This violates the ATA spec (can only send IDLE IMMEDIATE when drive is not
> busy) and really hoses up some drives (modern drives will not be able to

    I wonder if that really ever worked...

> recover using this error handling).  The correct thing to do is issue a SRST
> followed by a SET FEATURES command.  This is what Western Digital recommends
> for error recovery and what Western Digital says Windows does.  It also does
> not violate the ATA spec as far as I can tell.

    The patch even does things *not* required by the spec. :-)

> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -519,21 +519,24 @@ static ide_startstop_t ide_ata_error(ide
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
> +	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
>  		++rq->errors;
> +		return ide_do_reset(drive);
>  	}
> +
> +	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)

    Hm, is there any need for ==?

> +		drive->special.b.recalibrate = 1;
> +
> +	++rq->errors;
> +
>  	return ide_stopped;
>  }
>  
> @@ -1025,6 +1028,13 @@ static ide_startstop_t start_request (id
>  	if (!drive->special.all) {
>  		ide_driver_t *drv;
>  
> +		/*
> +		 * We reset the drive so we need to issue a SETFEATURES.
> +		 * Do it _after_ do_special() restored device parameters.
> +		 */
> +		if (drive->current_speed == 0xff)
> +			ide_config_drive_speed(drive, drive->desired_speed);
> +

    Hmm, IIRC, drive's UltraDMA mode shall *not* be cleared by reset, 
therefore there's no need to restore it.

>  		if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
>  		    rq->cmd_type == REQ_TYPE_ATA_TASK ||
>  		    rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
> Index: b/drivers/ide/ide-iops.c
> ===================================================================
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -1094,6 +1094,9 @@ static void pre_reset(ide_drive_t *drive
>  	if (HWIF(drive)->pre_reset != NULL)
>  		HWIF(drive)->pre_reset(drive);
>  
> +	if (drive->current_speed != 0xff)
> +		drive->desired_speed = drive->current_speed;
> +	drive->current_speed = 0xff;
>  }
>  /*
> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -615,6 +615,7 @@ typedef struct ide_drive_s {
>          u8	init_speed;	/* transfer rate set at boot */
>          u8	pio_speed;      /* unused by core, used by some drivers for fallback from DMA */
>          u8	current_speed;	/* current transfer rate set */
> +	u8	desired_speed;	/* desired transfer rate set */

    Oh, more of that *_speed crap. :-)

>          u8	dn;		/* now wide spread use */
>          u8	wcache;		/* status of write cache */
>  	u8	acoustic;	/* acoustic management */

MBR, Sergei
