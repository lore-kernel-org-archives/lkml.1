Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXGGC7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXGGC7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXGGC7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:59:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4126 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753675AbXGGC7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:59:36 -0400
Date: Fri, 6 Jul 2007 22:59:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <EAA83A3B-1534-458B-A6F8-D090D670D4E7@mac.com>
Message-ID: <Pine.LNX.4.44L0.0707062210470.7605-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Kyle Moffett wrote:

> Except Linus already decreed (and I heartily agree) that hibernation  
> and suspend-to-RAM were fundamentally completely different operations  
> and therefore any attempts to share code were basically just making a  
> big muddy mess of things.  Would a thread "Remove phase-of-the-moon  
> calculations from network-recv code" be relevant to lunar observation  
> just because the two had to do with the phases of the moon?  No!

For that matter, shutting down a CPU and hibernation are fundamentally
different operations -- but they both use the freezer.  Is that a big
muddy mess?  But never mind; I won't discuss hibernation.

> > A)  Decide what to do about remote wakeup requests.
> 
> Why do we care?  If the wakeup request arrives before we go to sleep,  
> we obviously aren't asleep and so can't wake up.  If it arrives after  
> we go to sleep then it will wake us up.  Anything that depends on a  
> wakeup arriving mid-sequence is 100% masochistic race condition.

You don't understand my point.  If a wakeup request arrives before the
system goes to sleep, and it is serviced, then a device which ought to
have been suspended will in fact be awake.  This will (if the parent's
driver is written correctly) cause the sleep transition to abort.

Not that there's necessarily anything wrong with that.  I just wanted 
to be sure you were aware of the potential problems.

> > C)  Prevent devices and drivers from being registered or  
> > unregistered; in particular decide what to do about hot-plug or hot- 
> > unplug events.
> 
> (1b) Again, that's where the NO_BIND flag comes in.  If its set then  
> any device probe events must sleep, otherwise they can go through.

I didn't say "bind", I said "registered".  Admittedly, they are rather
similar.

Still, there are difficulties.  Let's say a driver has set the NO_BIND 
flag for one of its devices.  A bind request comes in, and the driver 
puts it on a waitqueue.  Note that the binding thread holds the device 
semaphore; this is always true when a driver's probe routine is called.

Later on it comes time for the PM core to resume the device, which will
start up the threads on the waitqueue.  Before doing so it must acquire
the device semaphore.  Deadlock!

> If any of those things screw up suspend-to-RAM then it is 100% the  
> drivers fault and no "process freezer" is going to fix it, end of  
> story.

Why do you say that?  A "process freezer" can prevent bind and
registration calls from occurring, since these calls have to run in
process context.  Ergo a freezer _can_ fix some of these problems.

>  And "A" cannot be made reliable.  At some point you shut off  
> interrupts right before going to sleep, and at that point any remote  
> wakeup event is just going to get dropped until you actually enter  
> sleep mode and the hardware takes over again.  If you miss a wakeup  
> event then whatever sent it should just retry, just as with *every*  
> other kind of network packet.

Who mentioned network packets?  And who says a remote wakeup event will 
get dropped once interrupts are disabled?  More likely it will set a 
bit somewhere that causes the system to wake up immediately after it 
has gone to sleep.

> > So what happens if a new subdevice arrives at the wrong time?  Do  
> > you block instead of binding it?  While holding a mutex needed to  
> > suspend the parent device?
> 
> That would be a driver bug.  If you have asynchronous probing then  
> proper suspend handling includes being able to postpone driver probe  
> events until after resume.

One of your conditions (embodied in the pseudocode you posted earlier) 
was that drivers should be told to prevent binding and registration 
before the child devices are suspended.  Currently the PM core doesn't 
do anything like that.  You can't blame the drivers for this lack.

Of course it could be added.  Or perhaps more easily, the drivers that 
support asynchronous probing could be notified when a suspend is about 
to start so they could begin blocking bindings/registrations then.

> > What about drivers trying to bind to existing devices?
> 
> While binding it will clearly be holding a mutex/spinlock on the  
> parent device,

("Parent device"?  Do you mean the device being bound?  If so then I
agree.  Or do you mean the device's parent?  If so then your statement
is not clear at all.  There is special-case code in the driver core to
make sure it is true for USB devices, and it looks ugly as can be.)

> so the suspend process will wait for it.  When binding  
> is done the suspend_device() code will take the device lock and tell  
> everything else to postpone further bind requests as above.

My question referred to drivers trying to bind or unbind a device
_after_ the device has been suspended.  I suppose you'll say that's
covered by the NO_BIND flag.  But now we have the locking problem
mentioned above: The thread trying to bind is holding a lock which is
needed for resuming.

> Most drivers have an implicit NO_BIND flag:  The device's interrupts  
> are off and/or its in a low-power state.

That won't cause binding to block or be postponed; it will cause it to
fail.  Not the same thing at all.

>  USB is already terribly  
> buggy with regards to suspend:  If you hotplug a device during  
> suspend (like the touchpad in my powerbook powering down/up), then  
> the USB stack will basically hang that controller.  The device is off  
> and the hotplug triggers interrupts and IO, *EVEN* *WITHOUT*  
> *USERSPACE*.

As one of the people responsible for the USB power management 
implementation, I would appreciate more details about this.  For 
example, a dmesg log with CONFIG_USB_DEBUG turned on together with a
complete description of the actions you took to provoke the bug.

(I wonder how much of this "buginess" is caused by the lack of the 
freezer in PPC.)

> So if your driver doesn't already have a proper way of blocking IO  
> during suspend then it probably doesn't suspend 50% of the time  
> anyways.  A bug which bites *every* *time* is easy to fix, one which  
> only bites when things hit a race condition is much harder.

The USB drivers (at least, the ones with runtime PM support) rely on 
the freezer to block I/O during suspend.  As far as I know, they do 
suspend properly, on systems where the freezer is used.

> That responsibility has been there ever since suspend-to-RAM support  
> was added.  Nobody ever denied that writing a proper driver wasn't  
> tricky.  You have to simultaneously be able to handle handle hot- 
> unplug, IO errors, interrupts, IO requests, suspend-to-RAM, and  
> hibernation.  If your driver mutual-exclusion is buggy then it  
> probably already bites you during hotplug or other similar  
> scenarios.  Let's at least make the problems much more reproducible  
> so we can fix the drivers properly instead of continuing to kludge  
> around it for all eternity.

Is reproducibility really a problem at this stage?  A bug which bites 
50% of the time might not be quite as easy to fix as one which occurs 
every time, but it isn't terribly bad either.

Alan Stern

