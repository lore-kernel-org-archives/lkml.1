Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYHARki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYHARki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYHARk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:40:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1526 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYHARk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:40:28 -0400
Date: Fri, 1 Aug 2008 19:40:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       Arthur Jones <ajones@riverbed.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PULL REQUEST] md bug fixes and minor improvements
Message-ID: <20080801174024.GH20055@kernel.dk>
References: <18578.31924.259887.735206@notabene.brown> <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org> <20080801172231.GF20055@kernel.dk> <1217612088.24551.5.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217612088.24551.5.camel@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01 2008, Dan Williams wrote:
> 
> On Fri, 2008-08-01 at 19:22 +0200, Jens Axboe wrote:
> > It is a bit asymmetrical, largely due to the fact that the ->unplug_fn()
> > itself grabs the lock. The below patch should fix it, since Neil has
> > added a proper queue lock to the md queues. If someone can confirm that
> > this fixes it, I'll queue up a patch with proper descriptions.
> > 
> > > I guess Jens is gone too..
> > 
> > I'm back, just been busy this week :-)
> > 
> > diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> > index 621a272..f19b52f 100644
> > --- a/drivers/md/bitmap.c
> > +++ b/drivers/md/bitmap.c
> > @@ -1234,7 +1234,9 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
> >  		case 0:
> >  			bitmap_file_set_bit(bitmap, offset);
> >  			bitmap_count_page(bitmap,offset, 1);
> > +			spin_lock_irq(&bitmap->mddev->queue->queue_lock);
> >  			blk_plug_device(bitmap->mddev->queue);
> > +			spin_unlock_irq(&bitmap->mddev->queue->queue_lock);
> >  			/* fall through */
> >  		case 1:
> >  			*bmc = 2;
> > 
> 
> We also need to protect the blk_plug_device call a few lines down (and
> an obvious compile fix).

Old source I guess, just one blk_plug_device() in the copy I have here.
Just checked latest git, still just one blk_plug_device(), are you
diffing against -mm or something like that? Or linux-next?

And queue_lock is of course a pointer, I didn't even compile the
thing... Thanks for the updated variant!

-- 
Jens Axboe

