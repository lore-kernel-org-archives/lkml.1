Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYCLFmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYCLFmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYCLFmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:42:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15176 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbYCLFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=BRhtFvb6bufkChMbGRWZ3WnOJUZkCOHB1/Eby6TUpWWadPb60mFkp2PsYaM7LzyPQRLT26ht52tLJUZExcXfxv8iKlSdGZ1Z6AwkwaShcTSan3qyQwl69dtKyKPxSDKLQ/kB/+Ahm1CVFSoAXqENsMI+LI+q7M+ezyBtOy35gjg=
Date: Wed, 12 Mar 2008 06:41:56 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/4] ide-tape: remove pipeline-specific code from
	idetape_add_chrdev_write_request
Message-ID: <20080312054156.GC4266@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <1205082632-3418-3-git-send-email-petkovbb@gmail.com> <200803110025.19650.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803110025.19650.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 12:25:19AM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 09 March 2008, Borislav Petkov wrote:
> > Refrain from adding more write requests to the pipeline and queue them
> > directly on the device's request queue instead. Prior to that flush all
> > penging stages in the pipeline through idetape_wait_for_pipeline().
> 
> I would prefer to keep the original code for now
> (it has some subtle differences).

Well, if you mean by this the while-loop below, the original code offloads
the pipeline gradually, stage-wise, until allocation succeeds, in contrast to
idetape_wait_for_pipeline() which iterates over all pending stages and flushes
them all in one go.

At a certain in point in time, however, the driver might land at the unlikely
state of still having some stages left in the pipeline while queueing all
incoming requests on the rq queue. Therefore, i'd prefer to make sure the
pipeline is empty before queueing. What is more, it is flushed only once, if
ever, so idetape_wait_for_pipeline() simply returns in subsequent calls and no
considerable performance penalties are imposed here.

> > The remaining pipeline stage allocation code is used for the next current
> > pipeline stage (tape->merge_stage) and data buffer for an upcoming
> > request. The so allocated pipeline stage is rewired into the tape struct
> > thru idetape_switch_buffers() and used during the next request for
> > copying user data into it (see e.g. idetape_chrdev_write()). In case the
> > allocation fails, the current request is still attempted prior to failing.
> 
> Is this really needed now that we've removed pipeline operation for write
> requests?

I did this simply to keep behavior changes at minimum - after removing the
pipeline code completely this'll be simplified too.

> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> How's about this version?
> 
> From: Borislav Petkov <petkovbb@googlemail.com>
> Subject: [PATCH 2/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
> 
> Refrain from adding more write requests to the pipeline and queue them
> directly on the device's request queue instead.
> 
> [bart: re-do for minimal behavior changes]
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   55 +------------------------------------------------
>  1 file changed, 2 insertions(+), 53 deletions(-)
> 
> Index: b/drivers/ide/ide-tape.c
> ===================================================================
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -2202,28 +2202,16 @@ static void idetape_wait_first_stage(ide
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
>  	unsigned long flags;
> -	struct request *rq;
>  
>  	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
>  
>  	/* Attempt to allocate a new stage. Beware possible race conditions. */
> -	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
> +	while (1) {
>  		spin_lock_irqsave(&tape->lock, flags);
>  		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
>  			idetape_wait_for_request(drive, tape->active_data_rq);
> @@ -2234,49 +2222,10 @@ static int idetape_add_chrdev_write_requ
>  			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
>  					&tape->flags))
>  				continue;
> -			/*
> -			 * The machine is short on memory. Fallback to non-
> -			 * pipelined operation mode for this request.
> -			 */
>  			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
>  						blocks, tape->merge_stage->bh);
>  		}
>  	}
> -	rq = &new_stage->rq;
> -	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
> -	/* Doesn't actually matter - We always assume sequential access */
> -	rq->sector = tape->first_frame;
> -	rq->current_nr_sectors = blocks;
> -	rq->nr_sectors = blocks;
> -
> -	idetape_switch_buffers(tape, new_stage);
> -	idetape_add_stage_tail(drive, new_stage);
> -	tape->pipeline_head++;
> -	idetape_calculate_speeds(drive);
> -
> -	/*
> -	 * Estimate whether the tape has stopped writing by checking if our
> -	 * write pipeline is currently empty. If we are not writing anymore,
> -	 * wait for the pipeline to be almost completely full (90%) before
> -	 * starting to service requests, so that we will be able to keep up with
> -	 * the higher speeds of the tape.
> -	 */
> -	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> -		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
> -			tape->nr_stages >= tape->max_stages -
> -			tape->uncontrolled_pipeline_head_speed * 3 * 1024 /
> -			tape->blk_size) {
> -			tape->measure_insert_time = 1;
> -			tape->insert_time = jiffies;
> -			tape->insert_size = 0;
> -			tape->insert_speed = 0;
> -			idetape_plug_pipeline(drive);
> -		}
> -	}
> -	if (test_and_clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
> -		/* Return a deferred error */
> -		return -EIO;
> -	return blocks;
>  }
>  
>  /*

-- 
Regards/Gruﬂ,
    Boris.
