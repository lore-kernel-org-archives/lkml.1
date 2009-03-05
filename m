Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZCEMKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZCEMKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZCEMKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:10:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:29598 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZCEMKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=nrkP92kDw2TlgzrJ7S33YThCCRwbFGUsU9EouCdfJM8HCVTiiwOY5uEg5fGbfRK0ew
         OoQKcxoB2cEdCVhqt5xugZ9wZASv/RD0PQ7H7zKF1R0hkEnzjfn1n0CXMXO3XKmPLvHr
         zlx1G8IMavP03mv665Bt9NJrC2bYAtIT40jUw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Date: Thu, 5 Mar 2009 13:12:29 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090304; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <1236158216-23052-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1236158216-23052-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903051312.29784.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 04 March 2009, Borislav Petkov wrote:
> ... since some do not transfer any data from the drive and
> rq->buffer is unset leading to an OOPS when checking VM translations
> (CONFIG_DEBUG_VIRTUAL).
> 
> Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Thanks for fixing it but I worry that the patch is not entirely correct
(why o why did you have to throw in unrelated changes...?)

also ideally there should have been two patches:
- minimal bugfix for the buggy patch
- unification/cleanup of PIO sg setup

> ---
>  drivers/ide/ide-atapi.c  |    9 ++++++++-
>  drivers/ide/ide-cd.c     |    4 ----
>  drivers/ide/ide-floppy.c |    4 ----
>  3 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index a5596a6..ef78cbf 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -570,7 +570,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
>  
>  ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
> -	struct ide_atapi_pc *pc;
> +	struct ide_atapi_pc *uninitialized_var(pc);
>  	ide_hwif_t *hwif = drive->hwif;
>  	ide_expiry_t *expiry = NULL;
>  	struct request *rq = hwif->rq;
> @@ -587,6 +587,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
>  
>  		if (drive->dma)
>  			drive->dma = !ide_dma_prepare(drive, cmd);
> +

?

>  	} else {
>  		pc = drive->pc;
>  
> @@ -614,6 +615,12 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
>  						       : WAIT_TAPE_CMD;
>  	}
>  
> +	if (drive->media != ide_tape &&
> +	      !drive->dma && (blk_fs_request(rq) || rq->data_len)) {
> +		ide_init_sg_cmd(cmd, blk_rq_bytes(rq));
> +		ide_map_sg(drive, cmd);
> +	}
> +
>  	ide_init_packet_cmd(cmd, tf_flags, bcount, drive->dma);
>  
>  	(void)do_rw_taskfile(drive, cmd);
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 091d414..106cacb 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -916,10 +916,6 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
>  
>  	cmd.rq = rq;
>  
> -	ide_init_sg_cmd(&cmd,
> -		blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
> -	ide_map_sg(drive, &cmd);
> -
>  	return ide_issue_pc(drive, &cmd);
>  out_end:
>  	nsectors = rq->hard_nr_sectors;
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 2f8f453..b91deef 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -281,10 +281,6 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
>  		cmd.tf_flags |= IDE_TFLAG_WRITE;
>  
>  	cmd.rq = rq;
> -
> -	ide_init_sg_cmd(&cmd, pc->req_xfer);

There was a reason for using ->req_xfer.

I don't see where rq->data_len is set for REQ_TYPE_SPECIAL requests
(ide_queue_pc_tail() and friends)?

> -	ide_map_sg(drive, &cmd);
> -
>  	pc->rq = rq;
>  
>  	return ide_floppy_issue_pc(drive, &cmd, pc);
