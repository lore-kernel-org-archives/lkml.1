Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYJJJCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYJJJCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYJJJBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:01:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54202 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYJJJBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:01:51 -0400
Date: Fri, 10 Oct 2008 11:01:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
Message-ID: <20081010090116.GX19428@kernel.dk>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain> <20081008203002.19112.519.sendpatchset@localhost.localdomain> <87abdcg86j.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abdcg86j.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
> >
> > While at it:
> > - no need to check for hwgroup presence in ide_dump_opcode()
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> [...]
> > Index: b/drivers/ide/ide-io.c
> > ===================================================================
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> [...]
> > @@ -274,7 +269,11 @@ static void ide_complete_pm_request (ide
> >  		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
> >  		blk_start_queue(drive->queue);
> >  	}
> > -	HWGROUP(drive)->rq = NULL;
> > +	spin_unlock_irqrestore(&ide_lock, flags);
> > +
> > +	drive->hwif->hwgroup->rq = NULL;
> > +
> > +	spin_lock_irqsave(&ide_lock, flags);
> >  	if (__blk_end_request(rq, 0, 0))
> >  		BUG();
> >  	spin_unlock_irqrestore(&ide_lock, flags);
> 
> Is it really an improvement to release the lock here?

And more importantly, is it even safe? What serializes ->rq assignments
and checks without the ide_lock? Looks fishy.

But yes, dropping a lock for an assigment just to regrab it right after
is never a win. There's no contention gain, but possible bouncing
problems.

-- 
Jens Axboe

