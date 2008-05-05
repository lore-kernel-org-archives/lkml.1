Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbYEETCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbYEETCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759701AbYEETCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:02:10 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8207 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459AbYEETCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:02:07 -0400
Date: Mon, 5 May 2008 21:02:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Message-ID: <20080505190159.GA329@kernel.dk>
References: <200805031151.44287.prakash@punnoor.de> <481DB3F3.5080102@gmail.com> <20080504183839.GN12774@kernel.dk> <18462.46639.578272.994939@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18462.46639.578272.994939@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05 2008, Neil Brown wrote:
> On Sunday May 4, jens.axboe@oracle.com wrote:
> > On Sun, May 04 2008, Jacek Luczak wrote:
> > > Hi,
> > > 
> > > I've CC:-ed few guys which may help.
> > > 
> > > Prakash Punnoor pisze:
> > > > Hi, I got this on boot:
> > > >
> > > > usb 2-1.3: new full speed USB device using ehci_hcd and address 3
> > > > usb 2-1.3: configuration #1 chosen from 1 choice
> > > > Clocksource tsc unstable (delta = -117343945 ns)
> > > > ------------[ cut here ]------------
> > > > WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x7d/0x90()
> ...
> > 
> > Looks like it caught a real bug there - unfortunately we have to check
> > for ->queue_lock here as well, if this is another stacked devices and
> > not the bottom device. Does this make the warning go away for you?
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 087eee0..958f26b 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3264,6 +3264,8 @@ static void raid5_unplug_device(struct request_queue *q)
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(&conf->device_lock, flags);
> > +	if (q->queue_lock)
> > +		spin_lock(q->queue_lock);
> >  
> >  	if (blk_remove_plug(q)) {
> >  		conf->seq_flush++;
> > @@ -3271,6 +3273,8 @@ static void raid5_unplug_device(struct request_queue *q)
> >  	}
> >  	md_wakeup_thread(mddev->thread);
> >  
> > +	if (q->queue_lock)
> > +		spin_unlock(q->queue_lock);
> >  	spin_unlock_irqrestore(&conf->device_lock, flags);
> >  
> >  	unplug_slaves(mddev);
> > 
> 
> I suspect that will just cause more problems, as the 'q' for an md
> device never gets ->queue_lock initialised.
> I suspect the correct thing to do is set
> 	q->queue_lock = &conf->device_lock;
> 
> at some stage, probably immediately after device_lock is initialised
> in 'run'.
> 
> I was discussing this with Dan Williams starting
>   http://marc.info/?l=linux-raid&m=120951839903995&w=4
> though we don't have an agreed patch yet.

I agree with the usage of the device lock. I (mistakenly) thought that
raid5 used the bottom device queue for that unplug - I see that it does
not, so where does the warning come from? mddev->queue->queue_lock
should be NULL, since md never sets it and it's zeroed to begin with??

> I'm wondering why you mention the issues of stacked devices though.  I
> don't see how it applies.  Could you explain?

See above, if the queue had been the bottom queue, ->queue_lock may or
may not be NULL depending on whether this is the real device or
(another) stacked device.

-- 
Jens Axboe

