Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYJJIxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYJJIxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJJIxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:53:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39616 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYJJIxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:53:24 -0400
Date: Fri, 10 Oct 2008 10:52:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ide: use queue lock instead of ide_lock when possible
Message-ID: <20081010085249.GW19428@kernel.dk>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain> <20081008203027.19112.20883.sendpatchset@localhost.localdomain> <87zllcet7k.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zllcet7k.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: use queue lock instead of ide_lock when possible
> >
> > This is just a preparation for future changes and there should be no
> > functional changes caused by this patch since ide_lock is currently
> > also used as queue lock.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> [...]
> > Index: b/drivers/ide/ide-io.c
> > ===================================================================
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> [...]
> > @@ -1469,16 +1470,16 @@ out:
> >  void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
> >  {
> >  	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
> > +	struct request_queue *q = drive->queue;
> >  	unsigned long flags;
> >  
> >  	hwgroup->rq = NULL;
> >  
> > -	spin_lock_irqsave(&ide_lock, flags);
> > -	__elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 1);
> > -	__generic_unplug_device(drive->queue);
> > -	spin_unlock_irqrestore(&ide_lock, flags);
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
> > +	__generic_unplug_device(q);
> 
> By the way, wouldn't blk_run_queue() be more appropriate here? It looks
> to me as if blk_run_queue() was the thing intended for general usage by
> low level drivers who don't know and care about schedulers, whereas the
> usage of __generic_unplug_device() should mostly be restricted to the
> block layer. On the other hand, there are other drivers in
> drivers/block/ that use __generic_unplug_device(), so I may well be
> wrong. Jens?

Yes, that is correct. But it's ok for now, there are too many variants
of this around as it is already. I'm about to do a run and clean them up
and make sure we have a single sane way of doing it that is exported.

-- 
Jens Axboe

