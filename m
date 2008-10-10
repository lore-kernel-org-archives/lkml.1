Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYJJKRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYJJKRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYJJKRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:17:42 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43755 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbYJJKRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:17:40 -0400
Date: Fri, 10 Oct 2008 12:17:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
Message-ID: <20081010101705.GA19428@kernel.dk>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain> <20081008203002.19112.519.sendpatchset@localhost.localdomain> <87abdcg86j.fsf@denkblock.local> <20081010090116.GX19428@kernel.dk> <87wsggdc4t.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsggdc4t.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, Elias Oltmanns wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Fri, Oct 10 2008, Elias Oltmanns wrote:
> >> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> >> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> > Subject: [PATCH] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
> >> >
> >> > While at it:
> >> > - no need to check for hwgroup presence in ide_dump_opcode()
> >> >
> >> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> > ---
> >> [...]
> >> > Index: b/drivers/ide/ide-io.c
> >> > ===================================================================
> >> > --- a/drivers/ide/ide-io.c
> >> > +++ b/drivers/ide/ide-io.c
> >> [...]
> >> > @@ -274,7 +269,11 @@ static void ide_complete_pm_request (ide
> >> >  		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
> >> >  		blk_start_queue(drive->queue);
> >> >  	}
> >> > -	HWGROUP(drive)->rq = NULL;
> >> > +	spin_unlock_irqrestore(&ide_lock, flags);
> >> > +
> >> > +	drive->hwif->hwgroup->rq = NULL;
> >> > +
> >> > +	spin_lock_irqsave(&ide_lock, flags);
> >> >  	if (__blk_end_request(rq, 0, 0))
> >> >  		BUG();
> >> >  	spin_unlock_irqrestore(&ide_lock, flags);
> >> 
> >> Is it really an improvement to release the lock here?
> >
> > And more importantly, is it even safe? What serializes ->rq assignments
> > and checks without the ide_lock? Looks fishy.
> 
> Well, I haven't quite made up my mind whether it'll work in all cases,
> but I think the hwgroup->busy flag is supposed to take care of that.

It used to be especially problematic with multi count IO, but my
knowledge and last check on that dates back to pre-2000 I think...

-- 
Jens Axboe

