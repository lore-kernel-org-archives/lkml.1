Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYCBV3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYCBV3C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:29:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbYCBV2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:28:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:31002 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbYCBV2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=lwAcsS2bHy3bTlcfNKUV9k60/dyWncTIQV5+/xXwOoFWOyeBTPH54DDyOZNxmUZr6whBrPHIU04ybMzgvDUao2y10e9IvtRiJwd99+ZPg9HlU6vXyjkmgNmxipkrUbWxoFDcxFy8Gy5r2XWK6DviSyBeNFydTejE1AHvy0IDEGI=
Date: Sun, 2 Mar 2008 22:28:35 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/24] ide-tape: remove pipeline-specific code from
	idetape_add_chrdev_read_request
Message-ID: <20080302212835.GE4836@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-4-git-send-email-petkovbb@gmail.com> <200803021936.12741.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803021936.12741.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 07:36:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 01 March 2008, Borislav Petkov wrote:
> > We fall back to non-pipelined operation through idetape_queue_rw_tail with cmd
> > set to REQ_IDETAPE_READ. Also, remove idetape_switch_buffers() since it becomes
> > unused.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-tape.c |   46 +---------------------------------------------
> >  1 files changed, 1 insertions(+), 45 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > index abf3efa..e919d41 100644
> > --- a/drivers/ide/ide-tape.c
> > +++ b/drivers/ide/ide-tape.c
> > @@ -1776,16 +1776,6 @@ static void idetape_init_merge_stage(idetape_tape_t *tape)
> >  	}
> >  }
> >  
> > -static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
> > -{
> > -	struct idetape_bh *tmp;
> > -
> > -	tmp = stage->bh;
> > -	stage->bh = tape->merge_stage->bh;
> > -	tape->merge_stage->bh = tmp;
> > -	idetape_init_merge_stage(tape);
> > -}
> > -
> >  /* Add a new stage at the end of the pipeline. */
> >  static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
> >  {
> > @@ -2403,9 +2393,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
> >  static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
> >  {
> >  	idetape_tape_t *tape = drive->driver_data;
> > -	unsigned long flags;
> > -	struct request *rq_ptr;
> > -	int bytes_read;
> >  
> >  	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
> >  
> > @@ -2413,39 +2400,8 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
> >  	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
> >  		return 0;
> >  
> > -	/* Wait for the next block to reach the head of the pipeline. */
> > -	idetape_init_read(drive, tape->max_stages);
> 
> Can it be simply removed?  Why?

Bugger, actually this one _has_ to stay since it inits the tape->merge_stage
buffer.

> > -	if (tape->first_stage == NULL) {
> > -		if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
> > -			return 0;
> > -		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
> > +	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
> >  					tape->merge_stage->bh);
> 
> Looking at the driver code tape->first_stage is not always NULL,
> seems like ide_tape_add_stage_tail() should vanish first?

At this moment there are no more stages in the pipeline besides only
tape->merge_stage. But this boils down to whether we want to keep the driver
functional in intermittent stages of the removal, as i pointed out before...

-- 
Regards/Gruﬂ,
    Boris.
