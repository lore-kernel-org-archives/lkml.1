Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbXGGR3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbXGGR3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 13:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXGGR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 13:29:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2970 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752558AbXGGR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 13:29:46 -0400
Date: Sat, 7 Jul 2007 13:19:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <1183781219.3388.225.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707071255590.26860-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2007, Benjamin Herrenschmidt wrote:

> > > so the suspend process will wait for it.  When binding  
> > > is done the suspend_device() code will take the device lock and tell  
> > > everything else to postpone further bind requests as above.
> > 
> > My question referred to drivers trying to bind or unbind a device
> > _after_ the device has been suspended.  I suppose you'll say that's
> > covered by the NO_BIND flag.  But now we have the locking problem
> > mentioned above: The thread trying to bind is holding a lock which is
> > needed for resuming.
> 
> Why would it ? Just make it fail, maybe with some kind of -ERETRY... Or
> it can spin with the lock not held if it want. That's a detail really.

Spinning in the driver with the lock not held is impossible, since the 
driver is called with the lock already acquired.

Failing with -ERETRY is non-transparent.  I would prefer to block such 
requests at their source, before the lock is acquired.  Perhaps in the 
driver core, perhaps even earlier.

(And rather than trying to manage a waitqueue or struct completion, it
would be easiest to jump directly into the freezer!  The driver or the 
core wouldn't have to worry about waking up all these blocked threads.)

> > As one of the people responsible for the USB power management 
> > implementation, I would appreciate more details about this.  For 
> > example, a dmesg log with CONFIG_USB_DEBUG turned on together with a
> > complete description of the actions you took to provoke the bug.
> > 
> > (I wonder how much of this "buginess" is caused by the lack of the 
> > freezer in PPC.)
> 
> No. The freezer will hide some of those problems under the carpet, but
> not solve the basic issue which is the driver should be solid. Period.

You're missing the point.  If the driver and the freezer are both 
solid, there's no reason they can't share the work.  If many drivers 
can pass off part of their workload to the single freezer, it's a net 
win.

So it isn't a question of how solid the drivers are; it's a question 
of how solid the freezer is.  And bear in mind that if you convince 
people the freezer is not solid enough to be used, then you will have 
to find an alternative for purposes of hibernation.

> The freezer is a flawed concept in the first place.

<... Long and cogent argument which I will skip over for now ...>

> Face it, we should seriously look into doing suspend/resume without a
> freezer.

I'm willing to try, although I think it will be a tremendous amount of 
work to verify that every driver does the right thing.  There's lots of 
support missing.  For example, don't you think we should block all 
sysfs I/O during suspend?  And likewise for insmod/rmmod?

> I even tend to think that we could do STD that way too, in
> fact, while Linus is right saying it's a different problem than STR, we
> could even probably re-use some of the STR infrastructure in some
> hackish way, still without a freezer. We could have ways to block page
> cache writeout, for example, to prevent new post-snapshot dirty data
> from hitting the platter, and use direct BIOs for writeout. That's just
> an example.

What about systems with no BIOS?  I think this would be very hard or 
even impossible to make work.

Alan Stern

