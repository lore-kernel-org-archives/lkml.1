Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbXGGEIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbXGGEIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 00:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXGGEH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 00:07:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:60000 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXGGEH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 00:07:56 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0707062210470.7605-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0707062210470.7605-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 14:06:59 +1000
Message-Id: <1183781219.3388.225.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > so the suspend process will wait for it.  When binding  
> > is done the suspend_device() code will take the device lock and tell  
> > everything else to postpone further bind requests as above.
> 
> My question referred to drivers trying to bind or unbind a device
> _after_ the device has been suspended.  I suppose you'll say that's
> covered by the NO_BIND flag.  But now we have the locking problem
> mentioned above: The thread trying to bind is holding a lock which is
> needed for resuming.

Why would it ? Just make it fail, maybe with some kind of -ERETRY... Or
it can spin with the lock not held if it want. That's a detail really.

> As one of the people responsible for the USB power management 
> implementation, I would appreciate more details about this.  For 
> example, a dmesg log with CONFIG_USB_DEBUG turned on together with a
> complete description of the actions you took to provoke the bug.
> 
> (I wonder how much of this "buginess" is caused by the lack of the 
> freezer in PPC.)

No. The freezer will hide some of those problems under the carpet, but
not solve the basic issue which is the driver should be solid. Period.

The freezer is a flawed concept in the first place. If you go back to
square one, what is the basic idea of it ? I'll basically expose the
idea and go down all of the path I have in mind where it stops working
and becomes an incredibly difficult thing that in the end doesn't even
solve all the problems it's supposed to.

So first thing first...

I want a quiescent system with no new "IO requests" (whatever that mean
in the context of drivers) issued to avoid races during suspend/resume.

That sounds like a nice idea. Yeah. Sounds... only. Problem is. How do
you define that quiescent system ? First idea is ... let's stop
userland. There are various ways of doing that, but the freezer hooking
into the signal code is not necessarily a bad one.

No, I'm purposefully putting aside all the cases where the above doesn't
work (user process in the kernel in some uninterruptible wait, etc...),
which are the first big setback imho... our simple idea is suddenly not
so simple anymore, but we can bring those back later.

Now, there is still a problem... kernel threads. In fact, there is no
fundamental distinction between a kernel thread and a user process...
one has an MM and the other doesn't but as far as we are concerned, it's
the same. Kernel threads can issues IOs, or like khubd, detect devices,
plug/unplug them, etc etc.... all over the place.

Easy answer that comes to mind -> freeze them too. Heh, but kernel
threads don't do signals, so we end up with all those try_to_freeze().
Then what about the fact that drivers may need those kernel threads to
proceed ? Some drivers queue up their IO requests to a kernel thread to
process them and suspend() might need to flush those down, issue a
couple more such as "spin down disks" before that kernel thread can
actually be frozen... Hrm.. maybe not all of them then.

But how do you decide ? What defines that a kernel can issue an IO ? In
fact, if you look closely, anything doing kmalloc(...,GFP_KERNEL) for
example can trigger an IO... implicitely, via the VM pushing things out.
And that's just one example.

In some case, those same threads that may need to be kept non-frozen are
-also- the ones that will potentially submit new IOs or bring in new
devices.

And then, there is keventd ... what do you do about work queues ? You
have everybody pouring things at workqueues... some of these things may
well hit your driver, some may not. Same goes in some cases with
interrupt time stuff, such as timers or tasklets.. think about
networking.

In the end, the nice idea that "threads/tasks cause requests, so we just
stop them" basically falls appart. Half of the kernel can cause a driver
to be hit somewhere and a given time, it can be from a thread context,
directly caused by userland, or from some timer due to some subsystem
having a keepalive thing ticking in or whatever else.

Now, we go back to the previous issue of what do we do about
uninterruptible sleep... You want to abort suspend because, for example,
somethign called a driver that does an msleep(200) or so ? Are you aware
that 99% of laptop users close their laptops and shove it in the bag not
even waiting for the disk to spin down ? And you want suspend to abort
because some random "happen all the time" even such as a process being
somewhere temporarily in uninterruptible state in the kernel ?

So let's say we freeze them from within the scheduler even when they are
uininterruptible.. ouch... you just caused the deadlocks we talked about
before. While without a freezer, suspend() can at least rely on the fact
that it can wait for processes that have such pending locked constructs
waiting will ultimately wakeupm and wait for them (or even explicitely
wake them), it can't if they've been frozen. So what was a perfectly
solvable moderate driver synchronisation issue becomes a deadlock
nightmare.

And those are just example. During this discussion, we also brought the
example of FUSE which is a big stab at the whole freezer concept. And
I'm sure we can find more everyday.

Face it, we should seriously look into doing suspend/resume without a
freezer. I even tend to think that we could do STD that way too, in
fact, while Linus is right saying it's a different problem than STR, we
could even probably re-use some of the STR infrastructure in some
hackish way, still without a freezer. We could have ways to block page
cache writeout, for example, to prevent new post-snapshot dirty data
from hitting the platter, and use direct BIOs for writeout. That's just
an example.

Ben.


