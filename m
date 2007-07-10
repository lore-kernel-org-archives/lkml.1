Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbXGJOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbXGJOlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXGJOlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:41:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47152 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754198AbXGJOlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:41:00 -0400
Date: Tue, 10 Jul 2007 10:41:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
In-Reply-To: <46931495.4050605@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707101015500.2595-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Tejun Heo wrote:

> > Well, it turns out that this approach may confict with suspend/resume
> > processing.  In brief, it's not a good idea to unregister devices while
> > a suspend is in progress, but on the other hand it's not a good idea to
> > block keventd waiting until the suspend is over.
> 
> Is it because keventd isn't frozen during suspend?  I'm afraid we might
> be trying to solve the problem at the wrong layer.  Device
> addition/removal should be _locked out_ during suspend/resume.
> Depending on executing thread being frozen is more subtle and fragile
> and freezing might go away altogether.

There has been a very intense thread recently on LKML and linux-pm 
discussing this and several other aspects of the freezer.

You have to be very cautious about locking out device addition/removal.  
Quite often the thread calling the driver core owns the parent device's 
semaphore, which is needed for suspending the parent.  If that thread 
were blocked, the suspend would deadlock.

Instead we should broadcast a notification to all threads which might
try to add a device, telling them not to do it until the suspend is
over.  After that notification is sent and current additions have
completed, the driver core can simply fail further calls to
device_add().

> IMHO, what's needed is a giant rwlock protecting the whole device
> addition/removal while suspend is in progress (addition/removal during
> resume should be safe as long as we put the new devices on the already
> processed list).  The lock can probably replace dpm_sem and dpm_list_sem.

Addition during resume is _not_ safe.  The new device can easily get
added to the already-processed list in the wrong position, so that the
next time the system is suspended the PM core tries to suspend the new
device's parent before suspending the new device.

> It's probably necessary to use trylock from addition/removal to avoid
> deadlock.  Drivers which support hotplugging need to rescan/revalidate
> the bus during resume anyway so failing addition/removal during suspend
> shouldn't be a problem.

I had envisioned using SRCU to synchronize existing device additions
with the beginning of a suspend.  down_read_trylock should work just as
well (aside from cacheline bouncing).

Device removal isn't as much of a problem as addition.  We could allow
it with no difficulty.  Failing it isn't really an option because
device_del() returns void.  And anyway, my idea was to have the PM core
acquire all the device semaphores at the start of the suspend -- this
would automatically block any attempted removal until the semaphore was
released.

> > I haven't paid much attention to your sysfs updates.  Is it still true
> > that calls to show/store methods are mutually exclusive with attribute
> > unregistration?  Assuming the answer is Yes, would it be possible to
> > bypass that mutual exclusion in certain explicit cases?  Here's what I
> > have in mind:
> > 
> > 	The user writes to an attribute file.
> > 
> > 	The sysfs core calls the attribute's store method.
> > 
> > 	The method tells the sysfs core to pretend that the call
> > 	temporarily doesn't exist, or has completed, or something
> > 	like that.
> > 
> > 	The method safely unregisters the attribute file, with no
> > 	mutual exclusion problems and no deadlock.  Of course, the
> > 	unregistration will still block until all _other_ method
> > 	calls for this attribute are complete.
> > 
> > 	The method tells the sysfs core to stop pretending and
> > 	go back to its normal state.
> > 
> > 	The method returns, and the sysfs core takes whatever actions
> > 	are needed to fully release the attribute file.
> > 
> > The idea is that there could be a way to allow unregistration while a 
> > method is still running, if the method specifically requests it.  If we 
> > could do this then device_schedule_callback() would be unnecessary.
> 
> Regardless of the suspend problem, I like the above idea.  Actually, I
> was thinking about doing exactly that for suicidal nodes when I first
> found out the problem.  All that's needed is an owner field which allows
> the owning thread to reenter (what was the name for this type of mutex?
>  BSD folks like it).  It's probably better to put some restrictions to
> allow only the specific case tho.

What with all the sysfs changes, I wouldn't know where to begin
looking.  The idea occurred to me mainly because I was considering
blocking all access to sysfs during a suspend -- the problem being that
a suspend is itself triggered by a write to a sysfs attribute!  
Somehow that write would have to wait for all _other_ existing accesses
to complete and block new ones.

> I like it because it shifts complexity from the drivers into driver
> core.  IOW, the driver model is kinder to drivers that way - the driver
> writer doesn't have to care whether something is suicidal or not - and I
> think that's the way we should be headed although we're not good at it yet.

It doesn't shift all the complexity.  The method still has to tell the 
sysfs core that it's going to unregister its attribute and that the 
unregistration has finished.  But this is simpler than the callback 
method we use now.

Alan Stern

