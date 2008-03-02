Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbYCBXDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbYCBXDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYCBXDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:03:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:3466 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYCBXDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Sv+zSuCvf8B74hcocAZrb964jo+fyJALChPgKmMRLC7pKg5S43lQEIrL8/0Bk8OXgDnmyARBu5CyTqeYMbCpE84itpw36RAqy+s9Zep7OXxJbzG0474upUeopwj+n+boVkydjPYTPwrOhRDV70uBX6EoQ8TlXJj5S07xpaPoaHs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 02/24] ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
Date: Mon, 3 Mar 2008 00:16:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <200803021933.06012.bzolnier@gmail.com> <20080302211953.GD4836@gollum.tnic>
In-Reply-To: <20080302211953.GD4836@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803030016.30122.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 02 March 2008, Borislav Petkov wrote:
> On Sun, Mar 02, 2008 at 07:33:05PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Saturday 01 March 2008, Borislav Petkov wrote:
> > > Instead of plugging the request into the pipeline, queue it straight on the
> > > device's request queue through idetape_queue_rw_tail().
> > > 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > ---
> > >  drivers/ide/ide-tape.c |   81 ++---------------------------------------------
> > >  1 files changed, 4 insertions(+), 77 deletions(-)
> > > 
> > > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > > index 792c76e..abf3efa 100644
> > > --- a/drivers/ide/ide-tape.c
> > > +++ b/drivers/ide/ide-tape.c
> > > @@ -2123,12 +2123,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
> > >  
> > >  	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
> > >  
> > > -	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> > > -		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
> > > -				__func__);
> > > -		return (0);
> > > -	}
> > > -
> > >  	idetape_init_rq(&rq, cmd);
> > >  	rq.rq_disk = tape->disk;
> > >  	rq.special = (void *)bh;
> > > @@ -2140,10 +2134,9 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
> > >  	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
> > >  		return 0;
> > >  
> > > -	if (tape->merge_stage)
> > > -		idetape_init_merge_stage(tape);
> > >  	if (rq.errors == IDETAPE_ERROR_GENERAL)
> > >  		return -EIO;
> > > +
> > >  	return (tape->blk_size * (blocks-rq.current_nr_sectors));
> > >  }
> > 
> > These two changes to idetape_queue_rw_tail() don't look correct
> > as the pipeline mode is still used by read requests.
> 
> Wrt first hunk read rq pipeline functionality is removed in the following
> patch. Would it then be better to merge the two patches? Actually, do we need

Merging patches together would cause increased complexity.

The best solution would be to move this hunk to the patch which removes
IDETAPE_FLAG_PIPELINE_ACTIVE flag.

> to keep the driver functional in between the patches of those series for
> the purposes of git bisection or only compile-testing it is enough? Cause

We want to keep the driver functional in between the patches, especially
given that it shouldn't be much more difficult to do so.

> after applying the whole series you get pipelined mode ripped out anyway and
> intermittent states with partially functional pipeline are of no importance, no?

We always want fully bisectable patches:

- if the patch series accidentaly completely breaks the code we want to be
  able narrow it down to the guilty change

- if the patch series causes some regressions (ie. worse performance) we
  also want to see which exact change caused it

[ Nothing changes here and removal of pipeline functionality can't be an
  excuse for not sticking to the standard procedure. ]

> Wrt the second one you're right, this one should stay in for now until
> tape->merge_stage has been removed.
> 
> > > @@ -2210,81 +2203,15 @@ static void idetape_wait_first_stage(ide_drive_t *drive)
> > >  	spin_unlock_irqrestore(&tape->lock, flags);
> > >  }
> > >  
> > > -/*
> > > - * Try to add a character device originated write request to our pipeline. In
> > > - * case we don't succeed, we revert to non-pipelined operation mode for this
> > > - * request. In order to accomplish that, we
> > > - *
> > > - * 1. Try to allocate a new pipeline stage.
> > > - * 2. If we can't, wait for more and more requests to be serviced and try again
> > > - * each time.
> > > - * 3. If we still can't allocate a stage, fallback to non-pipelined operation
> > > - * mode for this request.
> > > - */
> > > +/* Queue up a character device originated write request. */
> > >  static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
> > >  {
> > >  	idetape_tape_t *tape = drive->driver_data;
> > > -	idetape_stage_t *new_stage;
> > > -	unsigned long flags;
> > > -	struct request *rq;
> > >  
> > >  	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
> > >  
> > > -	/* Attempt to allocate a new stage. Beware possible race conditions. */
> > > -	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
> > > -		spin_lock_irqsave(&tape->lock, flags);
> > > -		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> > > -			idetape_wait_for_request(drive, tape->active_data_rq);
> > > -			spin_unlock_irqrestore(&tape->lock, flags);
> > > -		} else {
> > > -			spin_unlock_irqrestore(&tape->lock, flags);
> > > -			idetape_plug_pipeline(drive);
> > > -			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
> > > -					&tape->flags))
> > > -				continue;
> > 
> > Can all the above code be safely removed (are you sure that there are no
> > hidden interactions)?  Even if so I would prefer that it is left intact by
> > this patch to ease the review.
> 
> This code does exactly what the comment above explains: it tries to free
> the pipeline for yet another request by plugging it with the already queued
> ones and if it can't do so it simply queues the request in non-pipelined
> mode. What the patch does is remove the plugging and waiting. If we
> leave this intact we'll be missing the point of the whole exercise.

idetape_empty_write_pipeline() which is called for _reads_ calls
idetape_add_chrdev_write_request() - could you tell if there are none
hidden interactions caused by not waiting for the active request to
finish?

[ I don't know and it is really not obvious from looking at ide-tape.c
  (it is quite complicated code) - that is why I want to play it safe. ]

Thanks,
Bart
