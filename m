Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXGHAtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXGHAtt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXGHAtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:49:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:60354 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbXGHAtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:49:41 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0707071255590.26860-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0707071255590.26860-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 10:48:52 +1000
Message-Id: <1183855732.3388.240.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Spinning in the driver with the lock not held is impossible, since the 
> driver is called with the lock already acquired.
> 
> Failing with -ERETRY is non-transparent.  I would prefer to block such 
> requests at their source, before the lock is acquired.  Perhaps in the 
> driver core, perhaps even earlier.
> 
> (And rather than trying to manage a waitqueue or struct completion, it
> would be easiest to jump directly into the freezer!  The driver or the 
> core wouldn't have to worry about waking up all these blocked threads.)

That's wrong. The freezer is NOT a solution for that sort of thing. Just
because you guys can't get your locking right.

> You're missing the point.  If the driver and the freezer are both 
> solid, there's no reason they can't share the work.  If many drivers 
> can pass off part of their workload to the single freezer, it's a net 
> win.

I've explained already multiple times that the freezer will not do what
you guys expect it to do. IOs can be submited at non-task time and there
is no clear distinction between IO generating threads that must and
those that must not be frozen.

I really can't understand why you guys work so hard at trying to avoid
the right solutions systematically.

> So it isn't a question of how solid the drivers are; it's a question 
> of how solid the freezer is.  And bear in mind that if you convince 
> people the freezer is not solid enough to be used, then you will have 
> to find an alternative for purposes of hibernation.

Because I'm intimately convinced that the freezer is a wrong approach
that cannot be made solid enough.

> > The freezer is a flawed concept in the first place.
> 
> <... Long and cogent argument which I will skip over for now ...>

Too bad, that's where the interesting points that show that the freezer
cannot work are..

> > Face it, we should seriously look into doing suspend/resume without a
> > freezer.
> 
> I'm willing to try, although I think it will be a tremendous amount of 
> work to verify that every driver does the right thing.  There's lots of 
> support missing.  For example, don't you think we should block all 
> sysfs I/O during suspend?  And likewise for insmod/rmmod?

sysfs is a matter of driver. If a sysfs read/write callback in a driver
is hitting the HW, it most certainly already has some kind of locking.
That locking can/should be extended to deal with blocking when the HW is
suspended.

However, since it seems that people universally consider it very hard to
get right (I don't but heh), Linus and Paul have come up with a solution
for most simple enough directly-mapped drivers such as PCI (ok, that
doesn't include USB) which is to simply do the HW suspend in a late
callback after IRQs are off, and not bother with the rest.

> > I even tend to think that we could do STD that way too, in
> > fact, while Linus is right saying it's a different problem than STR, we
> > could even probably re-use some of the STR infrastructure in some
> > hackish way, still without a freezer. We could have ways to block page
> > cache writeout, for example, to prevent new post-snapshot dirty data
> > from hitting the platter, and use direct BIOs for writeout. That's just
> > an example.
> 
> What about systems with no BIOS?  I think this would be very hard or 
> even impossible to make work.

You made the same mistake I did when reading Nigel's mail ... BIOs ->
Block IO requests, not BIOS :-)

Ben.


