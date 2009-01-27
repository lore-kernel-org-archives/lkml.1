Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZA0PZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZA0PZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZA0PZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:25:17 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:61406 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZA0PZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DxyHY6s7r4WWl5I7KbQgh6fIC/wYzuU9RMpH6Eepgs6CfnuBblZ3TLQRZ/PE3401jy
         jDPbbFEPme9Rw8XTW46vy4/hrYKDZT4Edyg/3TxNO7jY5RJH/t39fWe/t1oAQUFe4Hx5
         Jyjt7qjnkBjx7QGFXLRk+PBJvcro/xHvlhls8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 3/3] ide-cd: fix DMA for non bio-backed requests
Date: Tue, 27 Jan 2009 16:06:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090126; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1233002440-4325-1-git-send-email-petkovbb@gmail.com> <1233002440-4325-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1233002440-4325-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271606.04097.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2009, Borislav Petkov wrote:
> This one fixes http://bugzilla.kernel.org/show_bug.cgi?id=12320.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-cd.c |    3 +++
>  drivers/ide/ide-io.c |    9 ++++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 94981f9..84bc370 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -784,6 +784,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  		if (blk_fs_request(rq)) {
>  			ide_end_request(drive, 1, rq->nr_sectors);
>  			return ide_stopped;
> +		} else if (rq->cmd_type == REQ_TYPE_ATA_PC && !rq->bio) {
> +			ide_end_request(drive, 1, 1);
> +			return ide_stopped;
>  		}
>  		goto end_request;
>  	}
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index 9927b03..615b6e7 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -291,11 +291,14 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct scatterlist *sg = hwif->sg_table;
>  
> -	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
> -		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> -	} else {
> +	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
>  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
>  		hwif->sg_nents = 1;
> +	} else if (!rq->bio) {
> +		sg_init_one(sg, rq->data, rq->data_len);
> +		hwif->sg_nents = 1;
> +	} else {
> +		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
>  	}
>  }

applied

Thanks for fixing this.
