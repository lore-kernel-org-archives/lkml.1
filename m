Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYCCGoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYCCGoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 01:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYCCGny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 01:43:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:17716 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYCCGnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 01:43:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=kVOn3UGgDJMqlOhULWphNAMJl8hpwDYWIwPnuCS3vIoeP7Y2hTytntarhADyi3zrTlRbfBH9NuqHZ7x98EZ/hzmoqSglt2h8dB6lrS4YK78mfwmbk2jcarQFfcHxOnjD9wN7i5Y/EYx97O5vY6CWiuEKNKxvp9KzFATuooTTJgA=
Date: Mon, 3 Mar 2008 07:43:39 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/24] ide-tape: remove pipeline-specific code from
	idetape_add_chrdev_write_request
Message-ID: <20080303064339.GG4836@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <200803021933.06012.bzolnier@gmail.com> <20080302211953.GD4836@gollum.tnic> <200803030016.30122.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803030016.30122.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 12:16:29AM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> On Sunday 02 March 2008, Borislav Petkov wrote:
> > On Sun, Mar 02, 2008 at 07:33:05PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > On Saturday 01 March 2008, Borislav Petkov wrote:
> > > > Instead of plugging the request into the pipeline, queue it straight on the
> > > > device's request queue through idetape_queue_rw_tail().
> > > > 
> > > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > > ---
> > > >  drivers/ide/ide-tape.c |   81 ++---------------------------------------------
> > > >  1 files changed, 4 insertions(+), 77 deletions(-)
> > > > 
> > > > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > > > index 792c76e..abf3efa 100644
> > > > --- a/drivers/ide/ide-tape.c
> > > > +++ b/drivers/ide/ide-tape.c
> > > > @@ -2123,12 +2123,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
> > > >  
> > > >  	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
> > > >  
> > > > -	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
> > > > -		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
> > > > -				__func__);
> > > > -		return (0);
> > > > -	}
> > > > -
> > > >  	idetape_init_rq(&rq, cmd);
> > > >  	rq.rq_disk = tape->disk;
> > > >  	rq.special = (void *)bh;
> > > > @@ -2140,10 +2134,9 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
> > > >  	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
> > > >  		return 0;
> > > >  
> > > > -	if (tape->merge_stage)
> > > > -		idetape_init_merge_stage(tape);
> > > >  	if (rq.errors == IDETAPE_ERROR_GENERAL)
> > > >  		return -EIO;
> > > > +
> > > >  	return (tape->blk_size * (blocks-rq.current_nr_sectors));
> > > >  }
> > > 
> > > These two changes to idetape_queue_rw_tail() don't look correct
> > > as the pipeline mode is still used by read requests.
> > 
> > Wrt first hunk read rq pipeline functionality is removed in the following
> > patch. Would it then be better to merge the two patches? Actually, do we need
> 
> Merging patches together would cause increased complexity.
> 
> The best solution would be to move this hunk to the patch which removes
> IDETAPE_FLAG_PIPELINE_ACTIVE flag.
> 
> > to keep the driver functional in between the patches of those series for
> > the purposes of git bisection or only compile-testing it is enough? Cause
> 
> We want to keep the driver functional in between the patches, especially
> given that it shouldn't be much more difficult to do so.
> 
> > after applying the whole series you get pipelined mode ripped out anyway and
> > intermittent states with partially functional pipeline are of no importance, no?
> 
> We always want fully bisectable patches:
> 
> - if the patch series accidentaly completely breaks the code we want to be
>   able narrow it down to the guilty change
> 
> - if the patch series causes some regressions (ie. worse performance) we
>   also want to see which exact change caused it
> 
> [ Nothing changes here and removal of pipeline functionality can't be an
>   excuse for not sticking to the standard procedure. ]

Ok this changes the approach vector :). Will redo the patches from this angle
and send them in small b(i|y)tes :) in order to review them easier/faster.

Thanks.
-- 
Regards/Gruﬂ,
    Boris.
