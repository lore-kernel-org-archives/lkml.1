Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbXH2R6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbXH2R6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXH2R5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:57:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6650 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXH2R5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:57:54 -0400
Date: Wed, 29 Aug 2007 19:57:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Theodore Tso <tytso@mit.edu>, Jan Engelhardt <jengelh@computergmbh.de>,
       Richard Ballantyne <richardballantyne@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
Message-ID: <20070829175751.GB7932@kernel.dk>
References: <46CD14A6.4050605@gmail.com> <Pine.LNX.4.64.0708230746140.12788@fbirervta.pbzchgretzou.qr> <20070823102630.GH7267@thunk.org> <20070823112507.GL23758@kernel.dk> <46D5AEAD.50909@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D5AEAD.50909@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29 2007, Bill Davidsen wrote:
> Jens Axboe wrote:
> >On Thu, Aug 23 2007, Theodore Tso wrote:
> >>On Thu, Aug 23, 2007 at 07:52:46AM +0200, Jan Engelhardt wrote:
> >>>On Aug 23 2007 01:01, Richard Ballantyne wrote:
> >>>>What file system that is already in the linux kernel do people recommend
> >>>>I use for my laptop that now contains a solid state disk?
> >>>If I had to choose, the list of options seems to be:
> >>>
> >>>- logfs
> >>>  [unmerged]
> >>>
> >>>- UBI layer with any fs you like
> >>>  [just a guess]
> >>The question is whether the solid state disk gives you access to the
> >>raw flash, or whether you have to go through the flash translation
> >>layer because it's trying to look (exclusively) like a PATA or SATA
> >>drive.  There are some SSD's that have a form factor and interfaces
> >>that make them a drop-in replacement for a laptop hard drive, and a
> >>number of the newer laptops that are supporting SSD's seem to be these
> >>because (a) they don't have to radically change their design, (b) so
> >>they can be compatible with Windows, and (c) so that users can
> >>purchase the laptop either with a traditional hard drive or a SSD's as
> >>an option, since at the moment SSD's are far more expensive than
> >>disks.
> >>
> >>So if you can't get access to the raw flash layer, then what you're
> >>probably going to be looking at is a traditional block-oriented
> >>filesystem, such as ext3, although there are clearly some things that
> >>could be done such as disabling the elevator.   
> >
> >It's more complicated than that, I'd say. If the job of the elevator was
> >purely to sort request based on sector criteria, then I'd agree that
> >noop was the best way to go. But the elevator also abritrates access to
> >the disk for processes. Even if you don't pay a seek penalty, you still
> >would rather like to get your sync reads in without having to wait for
> >that huge writer that just queued hundreds of megabytes of io in front
> >of you (and will have done so behind your read, making you wait again
> >for a subsequent read).
> 
> In most cases the time in the elevator is minimal compared to the 
> benefits. Even without your next suggestion.

Runtime overhead, yes. Head optimizations like trying to avoid seeks,
definitely no. That can be several miliseconds for a request, and if you
waste that time often, then you are going noticably slower than you
could be.

> >My plan in this area is to add a simple storage profile and attach it to
> >the queue. Just start simple, allow a device driver to inform the block
> >layer that this device has no seek penalty. Then the io scheduler can
> >make more informed decisions on what to do - eg for ssd, sector
> >proximity may not have much meaning, so we should not take that into
> >account.
> >
> Eventually the optimal solution may require both bandwidth and seek 
> information. If "solid state disk" means flash, it's on a peripheral 
> bus, it's probably not all that fast at transfer rate. If it means NV 
> memory, battery backed or core, probably nothing changes, again *if* 
> it's on a peripheral bus, but if it's on a card plugged to the 
> backplane, the transfer rate may be high enough to make ordering cost 
> more than waiting. This could be extended to nbd and iSCSI devices as 
> well, I think, to optimize performance.

I've yet to see any real runtime overhead problems for any workload, so
the ordering is not an issue imo. It's easy enough to bypass for any io
scheduler, should it become interesting.

-- 
Jens Axboe

