Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXGHFO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXGHFO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 01:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXGHFOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 01:14:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:47055 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbXGHFOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 01:14:48 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 15:14:21 +1000
Message-Id: <1183871661.3388.282.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> You agree that drivers need to block various activities during suspend.  
> Principally I/O requests, but other things as well.  So when one of 
> these requests arrives, the driver has to make it wait somehow and then 
> has to allow it to proceed at the appropriate time.

Yes. The main thing I see here is that here is nothing common among
drivers in what a "request" is and how it's processed.

For example, for block drivers, it's actually fairly simple to just stop
processing the request queue and wait for pending ones to complete.

For network, in a similar vein, we can mostly just tell the network
stack to stop sending us packets.

That's what I call the "main path". This is often the trivial part to
deal with, mostly because for a whole lot of drivers, it can be done via
a couple of helpers in the subsystem that the driver provides a service
too, via a helper, asking that subsystem to stop calling into the said
driver (the asking should be done by the driver itself of course, for
ordering reasons).

We have some helpers, but I think not enough, and that's where we should
focus imho. For example, I added fb_set_suspend() so that fbdev's can
request fbcon to stop accessing them (it doesn't solve the problem of
userland mmap's, that will have to be done, if we want to do it, in a
more sneaky way, using VM tricks, but the DRM nowadays has the
infrastructure to do it).

But that's only the "main" path. Aside for that, almost all drivers also
have sideband "request" input and some driver don't actually live behind
a subsystem. That ranges from ioctl, to direct read/write on a char dev
from userland.

I think many of those cases can fairly well deal with just taking a PM
semaphore, that's how I did for a couple of things in the past, provided
that the request path isn't deadlocking with the semaphore held because
of the system suspending of course.  

But in a whole lot of cases, it's, I beleive, perfectly kosher to just
return an error. You're trying to capture frame from your camera while
the machine is suspended ? error. At worst, your capture app will be
unhappy when you wakeup, nothing terrible and totally fixable in
userland if it's a problem.

In some cases, we could use a little bit more help from the subsystem.
Network for example, could have some explicit knowledge of the suspend
state, and in addition to stopping the queue would also stop calling
into things like change_mtu or set_multicast, provided it's agreed that
the driver will account for those changes on resume (the actual MTU
values or multicast lists are still updated in the netdev).

> Normally a waitqueue or a struct completion would be used for this
> purpose.  

I think there's no "normal" scenario, each driver or family of drivers
will do things very differently.

> But either one puts the burden on the driver of defining a
> data structure and signalling it at the right time.

Yes.

> That time is generally when the device is resumed, but there's nothing
> wrong with delaying it slightly, to after all the devices have been resumed (i.e.,
> the time when the current PM code takes everything out of the freezer).

In fact, the best is to have parallel suspend/resume of drivers and asynchronous resume but that's out of topic :-) (For the record, I did some bits like ADB resume like that, that is asynchronous, to speed up wakeup time).
>   
> In fact, we definitely don't want to unblock plug events until this
> later time.

There are two things I believe. There's a generic issue with usermode helpers that make no sense to call between pre-suspend and post-resume, and there's the specific issue of adding/removing devices.

I believe that "bus" drivers such as USB should indeed get a first round of notifications to tell them to stop performing bus plug/unplug operations (it's debatable whether we want to keep unplug going provided we can stack up the usermode events and re-send them later though, but let's say no for the sake of simplicity).

> So instead, why not have the PM core take care of all this?  There
> could be a block_task_until_suspend_is_over() routine available for all
> drivers to use.  Its effect would be exactly the same as sending the
> current task into the freezer, but it wouldn't be the freezer that
> exists now.  It would just be some routine that blocks until the system 
> suspend is over.  We could call it "the icebox" instead of "the 
> freezer".  :-)

I'm not totally sure about that. I like some of it, but I think it's
fairly different conceptually from the freezer (and the implementation
could be as trivial as a single system wide wait queue). 

Basically it has a very big difference to the current freezer, and I
like that, which is that we don't have some 3rd party trying to find out
what to freeze and what not (the freezer), but instead, we have
explicitely drivers or kernel threads sending -themselves- to the
"icebox" when they think it's a good idea. Think of it as lazy freezing
-> you only freeze lazy tasks that are trying to do something that
cannot be done because of suspend.

> Does that make you happier?

I think it's a fairly significant change from the current freezer and I
also think it's a very good idea. The more I think about it, the more I
like it, in the sense that it's a simple drop-in that you could put in a
lot of the ioctl path of drivers to just block tasks that are trying to
call in while suspending, and could be used selectively by things like
the USB hub threads.

> User tasks can cause driver binding by writing to sysfs.  Binding 
> _can't_ be blocked in the driver; by then it's already too late.  If 
> it is going to be blocked at all, it has to be blocked earlier.  One 
> possibility is in the sysfs attribute code; another is to block all 
> sysfs access.
> 
> Of course, another possibility is simply to fail the bind.  But that's 
> not very satisfying, since suspends should be transparent.

I don't think suspend has to be -that- transparent (though there is some
debate on whether it should be if we're gonna do some kind of fast
"light" suspend for things like OLPC) but overall, I agree that a bind
operation on sysfs should probably block until resume, and it does make
sense to have the logic to do that in sysfs itself. It could perfectly
use the above icebox thingy you came up with.

> Ben, you haven't given enough thought to the work needed to avoid 
> locking problems.
> 
> For instance, you agree that during suspend we must not allow device or
> driver registration or unregistration, right? 

Registration is fine, binding/ubinding is not (no problem putting the
driver on/off a list, though of course, you can't unregister a bound
driver without unbinding, it's prefectly find to unregister an unbound
driver).

> And we must not allow driver binding or unbinding. 

That's where the meat is.

> But these events generally involve acquiring a device semaphore, in the
> driver core and quite often in the core's caller.  Since that semaphore
> is also needed for calling the suspend and resume methods, we have to be
> very careful about blocking binding/unbinding/registration/unregistration.

> It has to be done at a time when no device semaphores are held.

I think that should indeed be handled within the driver core. Though I
tend to think our driver core is a bit of a locking mess at the
moment :-) (Who says it could use more RCU-like constructs ?).

Regarding unbinding, that's debatable, it might be perfectly allright to
unbind while suspended, though then, there is the question of a driver
being later on bound to a piece of HW that is suspended (though I
suppose that could happen today... some machines have their firmware
leave some devices off at boot).

As a general matter, If we have those pre-suspend/post-resume notifiers
and we adapt the few (there isn't that much) bus drivers so that they
stop all probe/unprobe operations before the suspend dance starts, we
avoid a lot of that problem. At this point, it becomes fair enough for
bind/unbind, in the core, to return an error (and maybe even stack trace
in dmesg to catch the culprits) while suspend in in progress.

The only remaining annoying case is manual bind/unbind via sysfs which
is a good candidate for the above described icebox.

> You also agree that kernel threads and workqueues must be allowed to 
> operate during suspend.

Yes, unless kernel threads explicitely decide to stop themselves (for
example, khubd is a good candidate for that). Again, not a 3rd party
trying to decide what to freeze and what not, but the drivers or kernel
threads themselves deciding it.
 
> But consider this: By writing the appropriate 
> sysfs attribute, a user task can cause a workqueue item to be queued to 
> keventd that tries to unregister a device.  That really puts you on the 
> spot: Unregistration can't be allowed to fail, it can't be allowed to 
> succeed during a suspend, and keventd can't be blocked!  So what should 
> we do?

We can either stop it at the sysfs write level, or we can have the
workqueue task reschedule itself later until we are resumed. In fact,
worqueue items being what they are (queue items), we could imagine
having a special list where they enqueue themselves to rescheduled after
resume.

Don't get me wrong, I never said we don't need generic infrastructure
and utilities, such as your proposed icebox scheme, or some of those
workqueue bits, helpers in subsystems, etc...

I just think that the freezer approach, as it is, is backward. We can't
have a 3rd party try to discriminate what to freeze and what not, it
will always get something wrong, and in some cases with the wrong timing
or ordering.

Cheers,
Ben.


