Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbXGHV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbXGHV2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbXGHV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:28:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbXGHV2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:28:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Sun, 8 Jul 2007 23:35:29 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082335.30104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 22:16, Alan Stern wrote:
> I'll make this reply short by agreeing up front with most of what you 
> say.
> 
> On Sun, 8 Jul 2007, Benjamin Herrenschmidt wrote:
> 
> > But that's only the "main" path. Aside for that, almost all drivers also
> > have sideband "request" input and some driver don't actually live behind
> > a subsystem. That ranges from ioctl, to direct read/write on a char dev
> > from userland.
> 
> Yes, these are the problem cases.
> 
> > I think many of those cases can fairly well deal with just taking a PM
> > semaphore, that's how I did for a couple of things in the past, provided
> > that the request path isn't deadlocking with the semaphore held because
> > of the system suspending of course.  
> 
> That's what USB does as well (for the drivers which have runtime PM
> support -- at the moment only a few of them).
> 
> > But in a whole lot of cases, it's, I beleive, perfectly kosher to just
> > return an error. You're trying to capture frame from your camera while
> > the machine is suspended ? error. At worst, your capture app will be
> > unhappy when you wakeup, nothing terrible and totally fixable in
> > userland if it's a problem.
> 
> We can try falling back on this approach for now.  If the drivers are
> smart enough to fail cleanly when the device is already suspended, it
> should work.

And are they?

> But I'm not sure it's a good idea in the long run.  Think of a printer 
> daemon, for example.  It shouldn't have to experience unexpected I/O 
> problems merely because someone has decided to put the system to sleep.

Agreed.

> > In some cases, we could use a little bit more help from the subsystem.
> > Network for example, could have some explicit knowledge of the suspend
> > state, and in addition to stopping the queue would also stop calling
> > into things like change_mtu or set_multicast, provided it's agreed that
> > the driver will account for those changes on resume (the actual MTU
> > values or multicast lists are still updated in the netdev).
> 
> This will be up to the people responsible for the subsystems.  I can 
> take care of USB.
> 
> > There are two things I believe. There's a generic issue with usermode
> > helpers that make no sense to call between pre-suspend and
> > post-resume, and there's the specific issue of adding/removing
> > devices.
> > 
> > I believe that "bus" drivers such as USB should indeed get a first
> > round of notifications to tell them to stop performing bus
> > plug/unplug operations (it's debatable whether we want to keep unplug
> > going provided we can stack up the usermode events and re-send them
> > later though, but let's say no for the sake of simplicity).
> 
> Yes.  Rafael, how close is your new notifier chain to mainline?  Can it 
> at least be added to Greg KH's development tree so that I can start 
> using it?

It's in -mm.  The patches queued up in -mm are also in my patchset at
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc7/patches/

> > > So instead, why not have the PM core take care of all this?  There
> > > could be a block_task_until_suspend_is_over() routine available for all
> > > drivers to use.  Its effect would be exactly the same as sending the
> > > current task into the freezer, but it wouldn't be the freezer that
> > > exists now.  It would just be some routine that blocks until the system 
> > > suspend is over.  We could call it "the icebox" instead of "the 
> > > freezer".  :-)
> > 
> > I'm not totally sure about that. I like some of it, but I think it's
> > fairly different conceptually from the freezer (and the implementation
> > could be as trivial as a single system wide wait queue). 
> 
> Exactly.
> 
> > Basically it has a very big difference to the current freezer, and I
> > like that, which is that we don't have some 3rd party trying to find out
> > what to freeze and what not (the freezer), but instead, we have
> > explicitely drivers or kernel threads sending -themselves- to the
> > "icebox" when they think it's a good idea. Think of it as lazy freezing
> > -> you only freeze lazy tasks that are trying to do something that
> > cannot be done because of suspend.
> > 
> > > Does that make you happier?
> > 
> > I think it's a fairly significant change from the current freezer and I
> > also think it's a very good idea. The more I think about it, the more I
> > like it, in the sense that it's a simple drop-in that you could put in a
> > lot of the ioctl path of drivers to just block tasks that are trying to
> > call in while suspending, and could be used selectively by things like
> > the USB hub threads.
> 
> That's what I had in mind.  Rafael, can we add an "icebox" routine?  

Yes, I think so.

> Like Ben says, it doesn't need to be much more than a waitqueue
> that the current task puts itself on if a suspend is in progress.  
> Callers arriving at a time when the icebox isn't activated should
> simply return without blocking.  Basically the icebox should be active 
> at the same times as the existing freezer.

Hmm, I think this would be functionally equivalent to a modified freezer
with the following changes:

(1) the actual freezing functionality is not hooked up to the signal code,
but instead there are many invocations of try_to_freeze() all over the place,

(2) the freezer doesn't wait for tasks to freeze, only sets their TIF_FREEZE
flags and exits, where TIF_FREEZE now means "there's a suspend in
progress, please freeze yourself if need be".

BTW, this is similar to what I'd like to have for kernel threads RSN, except
for the "doesn't wait" part.

IMO, something like this might be used for hibernation too, but in that case
we need to do something about the tasks that haven't gone to the icebox.

I have some implementation-related questions:
* do we want each task to be notified individually or do we want a global
  variable, say "pm_entering_sleep_state", that will mean "now you're supposed
  to go to the icebox"
* at what point exactly this should be activated (ie. before the freezer or
  after it)
* how do we release tasks from the icebox (all at a time or individually, and
  if the latter then how exactly).

> > > Of course, another possibility is simply to fail the bind.  But that's 
> > > not very satisfying, since suspends should be transparent.
> > 
> > I don't think suspend has to be -that- transparent (though there is some
> > debate on whether it should be if we're gonna do some kind of fast
> > "light" suspend for things like OLPC) but overall, I agree that a bind
> > operation on sysfs should probably block until resume, and it does make
> > sense to have the logic to do that in sysfs itself. It could perfectly
> > use the above icebox thingy you came up with.
> 
> Here's a wacky idea which just might work:
> 
> In order to prevent binding and unbinding, while suspending devices all
> the PM core has to do is avoid dropping the device semaphores!  It can
> release the semaphores as it resumes the devices.
> 
> Of course, for this to work it's necessary to avoid changes to the 
> device list during the suspend.  However I believe the iteration can be 
> made safe against unregistration, so we only have to prevent device 
> registration.  (And anyway, it won't be possible to unregister a device 
> while the PM core is holding its semaphore.)
> 
> If we are willing to be somewhat non-transparent, this is easy to
> accomplish.  After the notifier chain has been alerted about the
> upcoming suspend, we tell the driver core to disallow adding new
> devices.  Maybe use SRCU to synchronize with registration calls that
> are in progress.  Thus, until the suspend is over device_add() will
> immediately return an error.  We could even add a new ESUSPENDING code
> to errno.h; it would come in handy in a few places.

This last thing is a good idea, IMHO.

> Drivers are already prepared for device registration to fail (or they
> ought to be), so this change shouldn't knock the bottom out of things.  
> device_add() isn't on a hot path, so adding an extra check and
> srcu_read_lock() won't hurt.
> 
> > Regarding unbinding, that's debatable, it might be perfectly allright to
> > unbind while suspended, though then, there is the question of a driver
> > being later on bound to a piece of HW that is suspended (though I
> > suppose that could happen today... some machines have their firmware
> > leave some devices off at boot).
> 
> I have had the same thought, that unbinding and unregistration would be 
> easier to handle than binding and registration.  As it happens, holding 
> the device semaphore will block both all three -- which makes life 
> simpler.

I think we should do something like that in the beginning and probably try to
add some flexibility later on.

> > As a general matter, If we have those pre-suspend/post-resume notifiers
> > and we adapt the few (there isn't that much) bus drivers so that they
> > stop all probe/unprobe operations before the suspend dance starts, we
> > avoid a lot of that problem. At this point, it becomes fair enough for
> > bind/unbind, in the core, to return an error (and maybe even stack trace
> > in dmesg to catch the culprits) while suspend in in progress.
> 
> Putting a WARN_ON() in device_add() would be a good idea.
> 
> > > But consider this: By writing the appropriate 
> > > sysfs attribute, a user task can cause a workqueue item to be queued to 
> > > keventd that tries to unregister a device.  That really puts you on the 
> > > spot: Unregistration can't be allowed to fail, it can't be allowed to 
> > > succeed during a suspend, and keventd can't be blocked!  So what should 
> > > we do?
> > 
> > We can either stop it at the sysfs write level, or we can have the
> > workqueue task reschedule itself later until we are resumed. In fact,
> > worqueue items being what they are (queue items), we could imagine
> > having a special list where they enqueue themselves to rescheduled after
> > resume.
> 
> There are other possibilities too.  For example, instead of using
> keventd these attributes could use a separate workqueue which would put
> itself in the icebox during a suspend.  Or maybe sysfs can be reworked 
> so that they don't need to use a workqueue at all.
> 
> > Don't get me wrong, I never said we don't need generic infrastructure
> > and utilities, such as your proposed icebox scheme, or some of those
> > workqueue bits, helpers in subsystems, etc...
> 
> I hope that everyone will agree that now is a good time to get started 
> on them.  There shouldn't be any problem about having them present 
> along with the freezer, and then it will be all that much easier to 
> remove the freezer later on if that's what we decide to do.

Agreed.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
