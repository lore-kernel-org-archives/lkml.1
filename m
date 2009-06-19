Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZFSQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZFSQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZFSQZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:25:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35963 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752801AbZFSQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:25:11 -0400
Date: Fri, 19 Jun 2009 12:25:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update 2 fix] PM: Introduce core framework for run-time
 PM of I/O devices
In-Reply-To: <200906190238.33576.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906191103510.3024-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Rafael J. Wysocki wrote:

> > In fact, maybe it would be best if pm_request_resume always increments
> > depth (unless it fails for some other reason) and __pm_runtime_resume
> > increments depth whenever called synchronously.  And likewise for the
> > suspend paths.
> 
> And how exactly are we going to check if pm_request_resume() was successful?
> 
> We'd have to be able to do that in a code path different from the one that has
> called pm_request_resume().

No, no.  What I meant was: Increment depth if pm_request_resume calls 
queue_work.  If it exits early, don't increment depth.

But now I'm not sure this is the right thing to do.  It's not clear 
what the right model should be for asynchronous operation.

> > > > Instead of a costly device_for_each_child(), would it be better to
> > > > maintain a counter with the number of unsuspended children?
> > > 
> > > Hmm.  How exactly are we going to count them?  The only way I see at the moment
> > > would be to increase this number by one when running pm_runtime_init() for a
> > > new child.  Seems doable.
> > 
> > That's right.  You also have to decrement the number when an
> > unsuspended child device is removed, obviously.
> 
> I forgot about that, so it is not done in the patch below.
> 
> BTW, is it just me, or are we overcomplicating that thing beyond any
> reasonable limit?
> 
> I think I'll just do the device_for_each_child() for now, because IMO this
> optimization isn't just worth complications resulting from it, because,
> realistically, how many children is a parent going to have in a notmal system?

Okay for now.  For the future...  What I'm concerned about is this: If
a driver uses asynchronous operation, it might need to tell the core
each time an I/O operation finished.  Whatever this involves will
therefore be on a hot path, so it should minimize the amount of locking
and other activity -- but device_for_each_child takes a bunch of locks.


> > The one thing to watch out for is what happens if a device is removed while
> > its runtime_resume callback is running.  :-)
> 
> I don't think it's possible.

I guess this is more of a problem in the USB stack, because we use the
same field to keep track of whether a device is suspended and whether
it has been unplugged.  Okay, forget it.


> > I guess this a question of how you view things.  My view has been that
> > whever depth (or pm_usage_cnt in the USB code) is 0, it means neither
> > the driver nor anyone else has any reason to keep the device at full
> > power.  By definition, since that's what depth is -- a count of the
> > reasons for not suspending.
> > 
> > There might be some obscure other reason, but in general depth going
> > to 0 means a delayed autosuspend request should be queued.
> 
> OK there, but pm_runtime_disable() is called by the core in some places where
> we'd rather not want the device to be suspended (like during a system-wide
> power transitions).

I'm not sure what you mean.  I was talking about pm_runtime_enable
(which decrements depth), not pm_runtime_disable (which increments it).  
When pm_runtime_enable finds that depth has gone to 0, it should queue
a delayed autosuspend request.


> > Which reminds me... Something to think about: In an async call to
> > __pm_runtime_suspend, if the runtime_suspend callback returns -EBUSY
> > then perhaps your code should automatically requeue a new delayed
> > autosuspend request.  Which implies, of course, that the autosuspend
> > delay has to be stored in the dev_pm_info structure.  This isn't a bad
> > thing, since exposing the value in sysfs gives userspace a consistent
> > way to set the delay.
> 
> I think that functionality can be added later.  Let's keep things as simple
> as possible initially, or we won't be able to make any progress.
> 
> Below is a new version of the patch.  Unfortunately, it is a major rework.
> In short, I tried to address some of your recent comments and my observations.
> It doesn't use depth any more, there's another counter (called resume_count)
> instead, also playing the role of the RPM_GRACE bit from the previous version.

Ah.  Okay.

> I've just finished it, so it may be still missing something apart from the
> updating child_count on removal of an unsuspended child.

I'll review it later.  For now, perhaps it would help to give some of
the considerations used by the USB stack.  For each device we store a
usage counter (equivalent to resume_count or depth), an autosuspend
delay value, and a time of last use.  Whenever a synchronous suspend or
any resume occurs, the time of last use is set to the current time.  
The same thing happens with delayed autosuspend requests that aren't 
requeues of an earlier request (see below).

Autosuspend is disallowed if:

	the driver doesn't support autosuspend;

	the usage counter is > 0;

	autosuspend has been disabled for this device;

	the driver requires remote wakeup during autosuspend
	but the user has disallowed wakeup.

If everything else is okay but not enough time has elapsed since the
device was last used, another delayed autosuspend request is queued and
the current one fails with -EAGAIN.

I believe the only circumstance where we would want to do an
autosuspend without decrementing the usage counter is if the usage
counter is already 0 (but the device hasn't been autosuspended yet) and
the autosuspend delay is changed.  For example, if the delay was
originally set to 30 seconds and the device has been idle for only 10
seconds, but then the user changes the delay to 5 seconds, we would do
an immediate autosuspend while leaving the counter at 0.

The model for asynchronous operation is that the usage counter remains
always at 0, and the driver updates the time-of-last-use field whenever
an I/O operation starts or completes.  The core keeps a delayed
autosuspend request queued; each time the request runs it checks
whether the device has been idle sufficiently long.  If not it
requeues itself; otherwise it carries out an autosuspend.

If an I/O operation takes too long (so that an autosuspend starts up in
the middle), the driver's suspend callback will return -EBUSY, thereby
causing another delayed autosuspend to be queued.

Alan Stern

