Return-Path: <linux-kernel-owner+w=401wt.eu-S964985AbZLGUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985AbZLGUhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935153AbZLGUhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:37:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55591 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934939AbZLGUhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:37:05 -0500
Date: Mon, 7 Dec 2009 15:37:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912070956350.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912071449470.15701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Linus Torvalds wrote:

> See my second email, where I think I can get rid of the whole second pass 
> thing. I think you'll agree that it's an even nicer mirror image.

Yes, I like this approach better and better.

There is still a problem.  In your code outlines, you have presented a
classic depth-first (suspend) or depth-last (resume) tree algorithm.  
But that's not how the PM core works.  Instead it maintains dpm_list, a
list of all devices in order of registration.  Suspends and resumes are
carried out by iterating along this list, in the reverse and forward
directions respectively.

There are two advantages.  The matter of stack usage, of course.  But
more importantly, this order of devices is guaranteed to work.  For any
device D, we _know_ that the system can function properly in
circumstances where everything on dpm_list before D is active and
everything after D is inactive -- because that's the state the system
was in when D was registered.  Any other order risks errors because of
unknown dependencies.

The consequence is that there's no way to hand off an entire subtree to 
an async thread.  And as a result, your single-pass algorithm runs into 
the kind of "stall" problem I described before.

(In theory we could convert over to a tree algorithm.  IMO that would 
be nearly as dangerous as going to a full-fledged totally async 
scheme.)

But all is not lost.  We can still get what we want using a two-pass
list algorithm, where one of the passes is contained within the PM core
-- no extra callbacks are needed.  Here's how suspend would work:

	dpm_suspend()	/* Suspend all devices on dpm_list */
	{
		list_for_each_entry_reverse(dev, dpm_list, ...) {

			/* Make the parent wait for dev */
			down_read(dev->parent->lock);
			if (dev->async_pm)
				async_schedule(device_suspend, dev);
		}
		list_for_each_entry_reverse(dev, dpm_list, ...) {
			if (!dev->async_pm)
				device_suspend(dev);
		}
		async_synchronize_full();
	}

	device_suspend(dev)	/* Suspend a single device */
	{
		/* Wait until all the children are suspended */
		down_write(dev->lock);
		dev->bus->suspend(dev);
		up_write(dev->lock);

		/* Tell the parent we are finished */
		up_read(dev->parent->lock);
	}

I have glossed over a bunch of details, such as the fact that
device_suspend() really takes two arguments.  And it's necessary to be
more careful with the list operations than shown here, because devices
can be unregistered while all this is going on.

Still, this seems reasonable.  Bus subsystems and drivers can set the
dev->async_pm flag as desired, and they can use the new rwsems to
handle special dependencies without involving the PM core.  No new
callbacks are needed, nor any changes to existing methods.  
(Convincing lockdep that all this fancy footwork is valid may require
some effort, though.)

By the way, this bears a striking resemblance to Rafael's patch.  The
biggest difference is the use of the new rwsem for dependency
resolution, instead his somewhat cumbersome constraint structures.


> > There's some question about what to do if a suspend or resume fails.  A
> > bunch of async threads will have been launched for other devices, but
> > now there won't be anything to wait for them.  It's not clear how this
> > should be handled.
> 
> I think the rule for "suspend fails" is very simple: you can't fail in the 
> async codepath. There's no sane way to return errors, and trying to would 
> be too complex anyway. What would you do? 

You could prevent the suspend procedure from going any further and
abort the entire system sleep.  If you wanted to.

> In fact, even though we _can_ fail in the synchronous path, I personally 
> consider a device driver that ever fails its suspend to be terminally 
> broken. We're practically always better off suspending and simply turning 
> off the power than saying "uh, I failed the suspend".
> 
> I've occasionally hit a few drivers that caused suspend failures, and each 
> and every time it was a driver bug, and the right thing to do was to just 
> ignore the error and suspend anyway - returning an error code and trying 
> to undo the suspend is not what anybody ever really wants, even if our 
> model _allows_ for it.

There is a valid reason for aborting a sleep transition: the driver has
received a remote wakeup request.  Wakeup requests race with sleep, of
course.  A request coming after the system is asleep will wake it up;
one coming before the system is asleep should either cause it to wake
up immediately after shutting down or prevent the sleep entirely.

Causing the system to wake up immediately needs hardware support.  But
by the time the kernel is aware of a wakeup request, the request is
generally no longer present in the hardware.  (For example, an
interrupt has been delivered and the IRQ line is no longer active.)  
So the only remaining choice is to abort the sleep transition.

> (And the rule for "resume fails" is even simpler: there's nothing we can 
> really do if something fails to resume - and that's true whether the 
> failure is synchronous or asynchronous. The device is dead. Try to reset 
> it, or remove it from the device tree. Tough).

Right.

Alan Stern

