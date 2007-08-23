Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXHWLZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXHWLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXHWLZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:25:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25207 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524AbXHWLZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:25:12 -0400
Date: Thu, 23 Aug 2007 13:25:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>, Jan Engelhardt <jengelh@computergmbh.de>,
       Richard Ballantyne <richardballantyne@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
Message-ID: <20070823112507.GL23758@kernel.dk>
References: <46CD14A6.4050605@gmail.com> <Pine.LNX.4.64.0708230746140.12788@fbirervta.pbzchgretzou.qr> <20070823102630.GH7267@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823102630.GH7267@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23 2007, Theodore Tso wrote:
> On Thu, Aug 23, 2007 at 07:52:46AM +0200, Jan Engelhardt wrote:
> > 
> > On Aug 23 2007 01:01, Richard Ballantyne wrote:
> > >
> > >What file system that is already in the linux kernel do people recommend
> > >I use for my laptop that now contains a solid state disk?
> > 
> > If I had to choose, the list of options seems to be:
> > 
> > - logfs
> >   [unmerged]
> > 
> > - UBI layer with any fs you like
> >   [just a guess]
> 
> The question is whether the solid state disk gives you access to the
> raw flash, or whether you have to go through the flash translation
> layer because it's trying to look (exclusively) like a PATA or SATA
> drive.  There are some SSD's that have a form factor and interfaces
> that make them a drop-in replacement for a laptop hard drive, and a
> number of the newer laptops that are supporting SSD's seem to be these
> because (a) they don't have to radically change their design, (b) so
> they can be compatible with Windows, and (c) so that users can
> purchase the laptop either with a traditional hard drive or a SSD's as
> an option, since at the moment SSD's are far more expensive than
> disks.
> 
> So if you can't get access to the raw flash layer, then what you're
> probably going to be looking at is a traditional block-oriented
> filesystem, such as ext3, although there are clearly some things that
> could be done such as disabling the elevator.   

It's more complicated than that, I'd say. If the job of the elevator was
purely to sort request based on sector criteria, then I'd agree that
noop was the best way to go. But the elevator also abritrates access to
the disk for processes. Even if you don't pay a seek penalty, you still
would rather like to get your sync reads in without having to wait for
that huge writer that just queued hundreds of megabytes of io in front
of you (and will have done so behind your read, making you wait again
for a subsequent read).

My plan in this area is to add a simple storage profile and attach it to
the queue. Just start simple, allow a device driver to inform the block
layer that this device has no seek penalty. Then the io scheduler can
make more informed decisions on what to do - eg for ssd, sector
proximity may not have much meaning, so we should not take that into
account.

-- 
Jens Axboe

