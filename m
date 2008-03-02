Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYCBVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYCBVU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbYCBVUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:20:10 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:53095 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbYCBVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:20:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=lDcKqzPA8nyVHvYNIf4mTWJkFekaom48emyvE2/wpqtKdXmOM+Qxd7dKPdp6Cqxlf2zz1LuNBbAGBSj7mEX9k+eM7ls/CMa8GNkNYTwDSA2B4uMfFmgW/7bXJk7gXSzlVMrXtCocDGwNQbateocSnHNdYQBYoMCwkqpZIfzjPaM=
Date: Sun, 2 Mar 2008 22:19:53 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/24] ide-tape: remove pipeline-specific code from
	idetape_add_chrdev_write_request
Message-ID: <20080302211953.GD4836@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-3-git-send-email-petkovbb@gmail.com> <200803021933.06012.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803021933.06012.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 07:33:05PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 01 March 2008, Borislav Petkov wrote:
> > Instead of plugging the request into the pipeline, queue it straight on the
> > device's request queue through idetape_queue_rw_tail().
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-tape.c |   81 ++---------------------------------------------
> >  1 files changed, 4 insertions(+), 77 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > index 792c76e..abf3efa 100644
> > --- a/drivers/ide/ide-tape.c
> > +++ b/drivers/ide/ide-tape.c
> > @@ -2123,12 +2123,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
> >  
> >  	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
> >  
> > -	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> > -		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
> > -				__func__);
> > -		return (0);
> > -	}
> > -
> >  	idetape_init_rq(&rq, cmd);
> >  	rq.rq_disk = tape->disk;
> >  	rq.special = (void *)bh;
> > @@ -2140,10 +2134,9 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
> >  	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
> >  		return 0;
> >  
> > -	if (tape->merge_stage)
> > -		idetape_init_merge_stage(tape);
> >  	if (rq.errors == IDETAPE_ERROR_GENERAL)
> >  		return -EIO;
> > +
> >  	return (tape->blk_size * (blocks-rq.current_nr_sectors));
> >  }
> 
> These two changes to idetape_queue_rw_tail() don't look correct
> as the pipeline mode is still used by read requests.

Wrt first hunk read rq pipeline functionality is removed in the following
patch. Would it then be better to merge the two patches? Actually, do we need
to keep the driver functional in between the patches of those series for
the purposes of git bisection or only compile-testing it is enough? Cause
after applying the whole series you get pipelined mode ripped out anyway and
intermittent states with partially functional pipeline are of no importance, no?

Wrt the second one you're right, this one should stay in for now until
tape->merge_stage has been removed.

> > @@ -2210,81 +2203,15 @@ static void idetape_wait_first_stage(ide_drive_t *drive)
> >  	spin_unlock_irqrestore(&tape->lock, flags);
> >  }
> >  
> > -/*
> > - * Try to add a character device originated write request to our pipeline. In
> > - * case we don't succeed, we revert to non-pipelined operation mode for this
> > - * request. In order to accomplish that, we
> > - *
> > - * 1. Try to allocate a new pipeline stage.
> > - * 2. If we can't, wait for more and more requests to be serviced and try again
> > - * each time.
> > - * 3. If we still can't allocate a stage, fallback to non-pipelined operation
> > - * mode for this request.
> > - */
> > +/* Queue up a character device originated write request. */
> >  static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
> >  {
> >  	idetape_tape_t *tape = drive->driver_data;
> > -	idetape_stage_t *new_stage;
> > -	unsigned long flags;
> > -	struct request *rq;
> >  
> >  	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
> >  
> > -	/* Attempt to allocate a new stage. Beware possible race conditions. */
> > -	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
> > -		spin_lock_irqsave(&tape->lock, flags);
> > -		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> > -			idetape_wait_for_request(drive, tape->active_data_rq);
> > -			spin_unlock_irqrestore(&tape->lock, flags);
> > -		} else {
> > -			spin_unlock_irqrestore(&tape->lock, flags);
> > -			idetape_plug_pipeline(drive);
> > -			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
> > -					&tape->flags))
> > -				continue;
> 
> Can all the above code be safely removed (are you sure that there are no
> hidden interactions)?  Even if so I would prefer that it is left intact by
> this patch to ease the review.

This code does exactly what the comment above explains: it tries to free
the pipeline for yet another request by plugging it with the already queued
ones and if it can't do so it simply queues the request in non-pipelined
mode. What the patch does is remove the plugging and waiting. If we
leave this intact we'll be missing the point of the whole exercise.

-- 
Regards/Gruﬂ,
    Boris.
