Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbXJXSKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbXJXSKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbXJXSKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:10:10 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8034 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbXJXSKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:10:07 -0400
Date: Wed, 24 Oct 2007 20:10:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: John Stoffel <john@stoffel.org>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: IDE crash...
Message-ID: <20071024181002.GG14671@kernel.dk>
References: <20071023070932.GB25962@kernel.dk> <20071023.001850.130236174.davem@davemloft.net> <20071023072359.GH25962@kernel.dk> <20071023.004321.74750417.davem@davemloft.net> <20071023074554.GA5059@kernel.dk> <18206.3808.849690.113159@stoffel.org> <20071024064859.GV14671@kernel.dk> <18207.29315.589451.547466@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18207.29315.589451.547466@stoffel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, John Stoffel wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> On Tue, Oct 23 2007, John Stoffel wrote:
> >> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> >> 
> Jens> On Tue, Oct 23 2007, David Miller wrote:
> >> >> From: Jens Axboe <jens.axboe@oracle.com>
> >> >> Date: Tue, 23 Oct 2007 09:23:59 +0200
> >> >> 
> >> >> > On Tue, Oct 23 2007, David Miller wrote:
> >> >> > > From: Jens Axboe <jens.axboe@oracle.com>
> >> >> > > Date: Tue, 23 Oct 2007 09:09:33 +0200
> >> >> > > 
> >> >> > > > Eh this wont work, it's the wrong entry... Here's a temporary
> >> >> > > > work-around.
> >> >> > > > 
> >> >> > > > diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> >> >> > > > index c89f0d3..108202b 100644
> >> >> > > > --- a/drivers/ide/ide-io.c
> >> >> > > > +++ b/drivers/ide/ide-io.c
> >> >> > > > @@ -822,6 +822,7 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
> >> >> > > >  		return;
> >> >> > > >  
> >> >> > > >  	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
> >> >> > > > +		sg_init_table(hwif->sg_table, hwif->sg_max_nents);
> >> >> > > >  		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> >> >> > > >  	} else {
> >> >> > > >  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
> >> >> > > 
> >> >> > > That's the exact patch I'm about to boot test :-)
> >> >> > 
> >> >> > That should work - once you verify that, would you mind testing this one
> >> >> > as well? Thanks!
> >> >> 
> >> >> This one works here too, thanks.
> >> 
> Jens> Great, thanks for testing that as well. Thinking a bit more
> Jens> about it, I think the forced clear should stay in
> Jens> blk_rq_map_sg() since we don't want to advertise it to
> Jens> drivers. So I'll just open-code it in there.
> >> 
> >> Should there be more bounds checking here, so that if you try to do a
> >> _force() you at least check to make sure that there's something beyond
> >> there and useable on the list?  
> >> 
> >> We're saving the time from not reallocating from scratch, but let's
> >> make it robust by doing at least some more checks here.
> 
> Jens> We have to rely on the caller passing in an sgtable that is big enough
> Jens> to map the request, we have always made that assumption. Anything else
> Jens> would be a bug, of course. Now, catching that bug would indeed be nice.
> Jens> Any suggestions?
> 
> Poor mans slab poisoning maybe?  As Alan Cox was saying about keeping
> it simple with a NULL entry on the end of the SG list, having an easy
> way to not fall of the end seems key. 
> 
> But from reading and re-reading the thread and some of the code, it
> looks like this list is really allocated, then the driver can just
> re-use the list (or a subset) as much as it likes without clearing and
> then reallocating.
> 
> So if you've got a chain of 127 items, does it make sense when you
> only use 16 of them to poison the next three or four in the chain to
> really make sure you don't fall off the end?

Yes, that is indeed how most drivers work. It's both cheaper and faster
to keep the list than allocating and initializing it every time. With
the current termination bit approach, only that bits needs to be
set/cleared to properly terminate the sgtable. So it's free, since it
happens with setting page/length/offset.

-- 
Jens Axboe

