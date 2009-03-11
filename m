Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZCKRBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZCKRBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZCKRAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:00:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:64794 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZCKRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=CRyrXUoZ+wlcnBhHrxv0fLVc8lSB95Fy+aRKIe32DVPAc7LeFOG4FlDc8VaYunBK0V
         wvAEFcgFkurK9jey6r35r4OY9lrS6OdzheWnRSHqxtGLT37dVzobcBLuMlH++XrxvLDi
         FjJ3AFFXNS94JCfGp7zFfhXiyNMENoRu2t2uo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Date: Wed, 11 Mar 2009 17:34:28 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090310; KDE/4.2.0; i686; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <200903081808.05448.bzolnier@gmail.com> <20090310060833.GA7895@liondog.tnic>
In-Reply-To: <20090310060833.GA7895@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903111734.28956.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 March 2009, Borislav Petkov wrote:
> Hi,
> 
> > If the mainline is broken sg fix can wait but to be honest I don't see much
> > point in delaying it (it is an independent problem and the bugfix should be
> > a completely safe one-liner).
> 
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Tue, 10 Mar 2009 07:04:52 +0100
> Subject: [PATCH] ide-floppy: do not map dataless cmds to an sg
> 
> since it fails the virt_to_page() translation check with DEBUG_VIRTUAL
> enabled.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

I applied it with some changes:

> ---
>  drivers/ide/ide-atapi.c  |   12 ++++++++++++
>  drivers/ide/ide-floppy.c |    6 ++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index a5596a6..11a680c 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -90,6 +90,12 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
>  	rq->cmd_flags |= REQ_PREEMPT;
>  	rq->buffer = (char *)pc;
>  	rq->rq_disk = disk;
> +
> +	if (pc->req_xfer) {
> +		rq->data = pc->buf;
> +		rq->data_len = pc->req_xfer;
> +	}
> +
>  	memcpy(rq->cmd, pc->c, 12);
>  	if (drive->media == ide_tape)
>  		rq->cmd[13] = REQ_IDETAPE_PC1;
> @@ -112,6 +118,12 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
>  	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
>  	rq->cmd_type = REQ_TYPE_SPECIAL;
>  	rq->buffer = (char *)pc;
> +
> +	if (pc->req_xfer) {
> +		rq->data = pc->buf;
> +		rq->data_len = pc->req_xfer;
> +	}
> +
>  	memcpy(rq->cmd, pc->c, 12);
>  	if (drive->media == ide_tape)
>  		rq->cmd[13] = REQ_IDETAPE_PC1;

ide-atapi.c part doesn't seem to be needed for fixing the issue
so I removed it (IMO it would fit much better with your sg setup
cleanup patch than this one)

> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 2f8f453..2b4868d 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -282,8 +282,10 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
>  
>  	cmd.rq = rq;
>  
> -	ide_init_sg_cmd(&cmd, pc->req_xfer);
> -	ide_map_sg(drive, &cmd);
> +	if (blk_fs_request(rq) || pc->req_xfer) {

ditto for blk_fs_request(rq) check

> +		ide_init_sg_cmd(&cmd, pc->req_xfer);
> +		ide_map_sg(drive, &cmd);
> +	}
>  
>  	pc->rq = rq;

Thanks,
Bart
