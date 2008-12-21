Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYLUU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYLUU61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYLUU5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:57:54 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:59074 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYLUU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:57:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=tUGZdweg38Fi7vlRWHyITDTI+DiTyC3Xm+jSax2nwWDp/4kvALfrIUUzlviAn+MtWh
         WsgI6h9trpFHHm3k2F3kFsH5YexvdwrPf7Ck6ozuVmi4boDgCjoeT1qFUQuq0h8jFEI5
         iPBkHrGnYMxvbKGc1R2wPY1mQswFcUNSu9kFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 2/8] ide-atapi: assign expiry and timeout based on device type
Date: Sun, 21 Dec 2008 20:06:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081219; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com> <1229586052-3542-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1229586052-3542-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812212006.04629.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Borislav Petkov wrote:
> There should be no functionality change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-atapi.c |   35 ++++++++++++++++++++---------------
>  1 files changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index 5c143b4..5295b26 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -514,9 +514,28 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
>  		cmd_len = COMMAND_SIZE(rq->cmd[0]);
>  		if (cmd_len < ATAPI_MIN_CDB_BYTES)
>  			cmd_len = ATAPI_MIN_CDB_BYTES;
> -	} else
> +
> +		timeout = rq->timeout;
> +		expiry  = ide_cd_expiry;
> +
> +	} else {
>  		cmd_len = ATAPI_MIN_CDB_BYTES;
>  
> +		/*
> +		 * If necessary schedule the packet transfer to occur 'timeout'
> +		 * miliseconds later in ide_delayed_transfer_pc() after the
> +		 * device says it's ready for a packet.
> +		 */
> +		if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
> +			timeout = drive->pc_delay;
> +			expiry = &ide_delayed_transfer_pc;
> +		} else {
> +			timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
> +							       : WAIT_TAPE_CMD;
> +			expiry = NULL;
> +		}
> +	}
> +
>  	ireason = ide_read_ireason(drive);
>  	if (drive->media == ide_tape)
>  		ireason = ide_wait_ireason(drive, ireason);
> @@ -528,20 +547,6 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
>  		return ide_do_reset(drive);
>  	}

If we add dev_is_idecd() check here in patch #1 it won't be necessary to
needlessly move the code around in this patch and it would also result in
smaller resulting code (42 bytes saved on x86-32)...

[ I updated patches 1-2 accordingly while merging them. ]

> -	/*
> -	 * If necessary schedule the packet transfer to occur 'timeout'
> -	 * miliseconds later in ide_delayed_transfer_pc() after the device
> -	 * says it's ready for a packet.
> -	 */
> -	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
> -		timeout = drive->pc_delay;
> -		expiry = &ide_delayed_transfer_pc;
> -	} else {
> -		timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
> -						       : WAIT_TAPE_CMD;
> -		expiry = NULL;
> -	}
> -
>  	/* Set the interrupt routine */
>  	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
