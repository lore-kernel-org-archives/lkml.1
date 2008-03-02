Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYCBTEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYCBTEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbYCBTDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:03:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:37702 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbYCBTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Kl+5TuNRIcgUcNh5E9fQPz6KfSVwPPBYKTA9CIuK6DaB+PQQRhJi1psR9htJDlixseEZ7nzp0KlCxuZy8CwcsJSl/9YKQGT9/bXKBSmiNJLkBBzX3U8Z2yeyB7+YFRTMQF9s0z+K7TyissyQKFjBFLYmmBGykI29yI0VtlUO1qI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 02/24] ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
Date: Sun, 2 Mar 2008 19:33:05 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204361928-30229-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021933.06012.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008, Borislav Petkov wrote:
> Instead of plugging the request into the pipeline, queue it straight on the
> device's request queue through idetape_queue_rw_tail().
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   81 ++---------------------------------------------
>  1 files changed, 4 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 792c76e..abf3efa 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -2123,12 +2123,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
>  
>  	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
>  
> -	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> -		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
> -				__func__);
> -		return (0);
> -	}
> -
>  	idetape_init_rq(&rq, cmd);
>  	rq.rq_disk = tape->disk;
>  	rq.special = (void *)bh;
> @@ -2140,10 +2134,9 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
>  	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
>  		return 0;
>  
> -	if (tape->merge_stage)
> -		idetape_init_merge_stage(tape);
>  	if (rq.errors == IDETAPE_ERROR_GENERAL)
>  		return -EIO;
> +
>  	return (tape->blk_size * (blocks-rq.current_nr_sectors));
>  }

These two changes to idetape_queue_rw_tail() don't look correct
as the pipeline mode is still used by read requests.

> @@ -2210,81 +2203,15 @@ static void idetape_wait_first_stage(ide_drive_t *drive)
>  	spin_unlock_irqrestore(&tape->lock, flags);
>  }
>  
> -/*
> - * Try to add a character device originated write request to our pipeline. In
> - * case we don't succeed, we revert to non-pipelined operation mode for this
> - * request. In order to accomplish that, we
> - *
> - * 1. Try to allocate a new pipeline stage.
> - * 2. If we can't, wait for more and more requests to be serviced and try again
> - * each time.
> - * 3. If we still can't allocate a stage, fallback to non-pipelined operation
> - * mode for this request.
> - */
> +/* Queue up a character device originated write request. */
>  static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
> -	idetape_stage_t *new_stage;
> -	unsigned long flags;
> -	struct request *rq;
>  
>  	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
>  
> -	/* Attempt to allocate a new stage. Beware possible race conditions. */
> -	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
> -		spin_lock_irqsave(&tape->lock, flags);
> -		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> -			idetape_wait_for_request(drive, tape->active_data_rq);
> -			spin_unlock_irqrestore(&tape->lock, flags);
> -		} else {
> -			spin_unlock_irqrestore(&tape->lock, flags);
> -			idetape_plug_pipeline(drive);
> -			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
> -					&tape->flags))
> -				continue;

Can all the above code be safely removed (are you sure that there are no
hidden interactions)?  Even if so I would prefer that it is left intact by
this patch to ease the review.

The main change to idetape_add_chrdev_write_request is fine.
