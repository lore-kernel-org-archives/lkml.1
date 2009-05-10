Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZEJVhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZEJVhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbZEJVgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:36:10 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:60750 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbZEJVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=sa5g3TiLNM41oVeMX5qoJav51jVkz1qqxCbOn7g10JGDuhq/hvZU8+JVIoBjxNp1eK
         DU0Pak2Wn16f4ETOxKwifvF/RH/vj0O0AM2w++JJIbcGSvE06HId3iCviU0LTZE7fO34
         jj9ECB07OUO2iCMs/HnMc52eSKzGeKkFxsdhs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 09/14] ide-atapi: use local sense buffer
Date: Sun, 10 May 2009 23:32:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-10-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1241855134-4984-10-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905102332.39043.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009 09:45:29 Borislav Petkov wrote:
> Save a pointer to the sense buffer in rq->sense in order to access it
> later in the ->pc_callback method. Also, remove remaining references to
> pc->buf in ide-floppy code.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-atapi.c        |   10 ++++++++--
>  drivers/ide/ide-floppy.c       |   12 ++++++------
>  drivers/ide/ide-floppy_ioctl.c |    4 ++--
>  drivers/ide/ide-tape.c         |    5 +++--
>  4 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index bd59fea..df3e3bb 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -93,6 +93,13 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
>  	rq->cmd_type = REQ_TYPE_SPECIAL;
>  	rq->special = (char *)pc;
>  
> +	/*
> +	 * FIXME: temporarily save a ptr to the sense buffer in rq->sense for
> +	 * the ->do_callback sense massaging. Will remove later.
> +	 */
> +	if (pc->c[0] == REQUEST_SENSE)
> +		rq->sense = buf;
> +
>  	if (buf && bufflen) {
>  		error = blk_rq_map_kern(drive->queue, rq, buf, bufflen,
>  					GFP_NOIO);
> @@ -252,8 +259,7 @@ void ide_retry_pc(ide_drive_t *drive)
>  	/* init pc from sense_rq */
>  	ide_init_pc(pc);
>  	memcpy(pc->c, sense_rq->cmd, 12);
> -	pc->buf = bio_data(sense_rq->bio);	/* pointer to mapped address */

Shouldn't this belong to patch #12?

> -	pc->req_xfer = blk_rq_bytes(sense_rq);

I think that we can remove ->req_xfer now completely, patch #13.5? :)

> +	sense_rq->sense = bio_data(sense_rq->bio);	/* pointer to mapped address */

Can't we just use bio_data(rq->bio) in ->pc_callback?

also:

WARNING: line over 80 characters
#42: FILE: drivers/ide/ide-atapi.c:262:
+       sense_rq->sense = bio_data(sense_rq->bio);      /* pointer to mapped address */

>  	if (drive->media == ide_tape)
>  		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 060c893..cb6c6f8 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -77,7 +77,12 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
>  	    (rq && blk_pc_request(rq)))
>  		uptodate = 1; /* FIXME */
>  	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
> -		u8 *buf = pc->buf;
> +
> +		u8 *buf;
> +
> +		BUG_ON(!rq->sense);
> +
> +		buf = rq->sense;

BUG_ON shouldn't be needed after testing this

>  		if (!pc->error) {
>  			floppy->sense_key = buf[2] & 0x0F;
> @@ -209,8 +214,6 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
>  	pc->rq = rq;
>  	if (rq->cmd_flags & REQ_RW)
>  		pc->flags |= PC_FLAG_WRITING;
> -	pc->buf = NULL;
> -	pc->buf_size = blk_rq_bytes(rq);

patch #12

>  	pc->flags |= PC_FLAG_DMA_OK;
>  }
>  
> @@ -225,9 +228,6 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
>  		if (rq_data_dir(rq) == WRITE)
>  			pc->flags |= PC_FLAG_WRITING;
>  	}
> -	/* pio will be performed by ide_pio_bytes() which handles sg fine */
> -	pc->buf = NULL;
> -	pc->buf_size = blk_rq_bytes(rq);

ditto

>  }
>  
>  static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
> diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
> index 7a03d34..9c22882 100644
> --- a/drivers/ide/ide-floppy_ioctl.c
> +++ b/drivers/ide/ide-floppy_ioctl.c
> @@ -47,7 +47,6 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
>  		return -EINVAL;
>  
>  	ide_floppy_create_read_capacity_cmd(pc);
> -	pc->buf_size = sizeof(pc_buf);

ditto
 
>  	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc_buf, pc->req_xfer)) {
>  		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
> @@ -198,11 +197,12 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive,
>  					  int __user *arg)
>  {
>  	struct ide_disk_obj *floppy = drive->driver_data;
> +	u8 sense_buf[18];
>  	int progress_indication = 0x10000;
>  
>  	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
>  		ide_create_request_sense_cmd(drive, pc);
> -		if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->buf,
> +		if (ide_queue_pc_tail(drive, floppy->disk, pc, sense_buf,
>  				      pc->req_xfer))
>  			return -EIO;

Separate patch?

Please be consistent here and either do such changes in separate patches
or integrate them all into patch #5.5.
