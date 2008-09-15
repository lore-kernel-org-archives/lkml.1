Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYIOSdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYIOSdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbYIOScO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:32:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:6991 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYIOScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=BQ9GA1NBmF5yq6DC/wGRi6jV0D3Qgw6xEUxrKLvswjFmtUWavUMW6eoTt6YPwf3TQN
         hYnA7jC4yOCqRDTKDdcaL8dsL0M6/HLQ8oKKLUQ1yleO/7g/G0PQpnTtOuVeRAsALQJv
         jdsHEjep1TOnlye2EvRbJHlsuqZ6dlqX1EoP4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 03/10] ide-atapi: teach ide atapi about drive->waiting_for_dma
Date: Mon, 15 Sep 2008 20:15:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <1221392158-3848-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1221392158-3848-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809152015.51684.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 13:35:51 Borislav Petkov wrote:
> This is in preparation for converting ide-cd to generic code. The actual
> rewiring will be done later after the issue_pc/transfer_pc code knows all about
> ide-cd.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-atapi.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index d557841..763acd7 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -487,7 +487,13 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
>  	ide_startstop_t startstop;
>  	u8 ireason;
>  
> -	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
> +	if ((drive->media == ide_cdrom || drive->media == ide_optical) &&
> +	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)) {
> +		if (drive->dma)
> +			drive->waiting_for_dma = 1;
> +	}

We really want to do this for all ATAPI devices (as a bugfix).

> +	else if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY,
> +			       WAIT_READY)) {

IIRC similar check was removed from ide-cd so maybe this one
is also unnecessary?

>  		printk(KERN_ERR "%s: Strange, packet command initiated yet "
>  				"DRQ isn't asserted\n", drive->name);
>  		return startstop;
> @@ -562,8 +568,10 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
>  		ide_dma_off(drive);
>  	}
>  
> -	if ((pc->flags & PC_FLAG_DMA_OK) &&
> -	    (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
> +	if (((pc->flags & PC_FLAG_DMA_OK) &&
> +		(drive->dev_flags & IDE_DFLAG_USING_DMA)) ||
> +	    ((drive->media == ide_cdrom || drive->media == ide_optical) &&
> +	         drive->dma)) {

drive->dma is only set by ide-cd so no need to check for media type,
also I think that it better fits in some later patch.

>  		if (scsi)
>  			hwif->sg_mapped = 1;
>  		drive->dma = !hwif->dma_ops->dma_setup(drive);
> @@ -579,6 +587,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
>  
>  	/* Issue the packet command */
>  	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
> +		if (drive->dma)
> +			drive->waiting_for_dma = 0;
>  		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
>  				    timeout, NULL);
>  		return ide_started;

Please recast the patch to have only ->waiting_for_dma change.  Thanks.
