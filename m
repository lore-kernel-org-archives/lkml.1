Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbXGFPmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbXGFPmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760717AbXGFPmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:42:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49380 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760184AbXGFPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:42:35 -0400
Date: Fri, 6 Jul 2007 11:42:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <CF60EC03-0171-4052-924D-57555A393168@mac.com>
Message-ID: <Pine.LNX.4.44L0.0707061114190.3737-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Kyle Moffett wrote:

> Umm, this thread is NOT ABOUT HIBERNATING!!!  Please go back and read  
> the subject, specifically the "suspend to RAM" parts :-D.

But it _is_ about the freezer; see the "Remove process freezer" part.  
:-)  Since the freezer is used during hibernation, hibernation is a
legitimate topic.

>  When your  
> hardware can put itself to sleep and atomically preserve memory as it  
> does so, you don't need an atomic copy.  For Real Suspend(TM) (IE:  
> Suspend-to-RAM), the list of things to do is short and simple:
> 
> 1)  Stop DMA and put most hardware into low-power states (stops all  
> interrupt sources)
> 2)  Ensure that the other CPUs have finished any trailing interrupt  
> handlers and put them to sleep
> 3)  Put the interrupt-controllers into low-power state
> 4)  Go to sleep

Your short and simple list omits a few crucial items:

A)  Decide what to do about remote wakeup requests.
B)  Prevent I/O requests from resuming devices that have been 
suspended.
C)  Prevent devices and drivers from being registered or unregistered; 
in particular decide what to do about hot-plug or hot-unplug events.
D)  Block driver bind or unbind calls.

Any of these things is capable of screwing up the course of events.
(In fact A _should_ be allowed to abort a suspend.)

> > As Pavel rightly said, you can get rid of the freezer, but you're  
> > only going to have to implement another one that does the  
> > essentially the same thing, even if it is at some other level.
> 
> How about a freezer whose job it is to "wait for pending hard  
> interrupts to complete when we have already guaranteed that we won't  
> get any more"?  That part should be really *REALLY* easy.  You don't  
> need to care about either userspace processes or kernel threads at  
> all.  Specifically, Step 1 consists of:
> 
> suspend_device(dev)
> {
> 	set_no_bind_flag(dev);
> 	for (dev->subdevices)
> 		suspend_device(dev);
> 	set_no_io_flag(dev);
> 	wait_for_in_progress_dma(dev);
> 	turn_off_interrupts(dev);
> 	go_to_low_power_state(dev);
> }
> 
> After you've set the "no_bind" flag, you won't get any *new*  
> subdevices trying to bind, 

So what happens if a new subdevice arrives at the wrong time?  Do you 
block instead of binding it?  While holding a mutex needed to suspend 
the parent device?

What about drivers trying to bind to existing devices?

What happens to I/O requests submitted after the "no_io" flag is set?  
The driver will have to block them, effectively creating its own little 
"freezer".

> therefore it's safe to iterate over the  
> list of present sub-devices and suspend them.  Once those are  
> suspended and in low-power states you can set a "no_io" flag to  
> prevent the driver from submitting more IO.  At that point you can  
> lazily wait for existing DMA/IO/interrupts to finish on the device,  
> since *NOBODY* will be submitting them anymore, and we certainly  
> aren't probing for new devices.  Then you can just turn off the power  
> to the device.  When all the leaf devices are off, the parent device  
> can be turned off because everything waiting on the leaf devices is  
> blocked on them and won't unblock until the parent device *AND* the  
> leaf device are turned on again, in that order.

This is a lot like what we already do.  The differences are:

	There is nothing corresponding to your "no-bind" flag.

	Most drivers don't have anything like your "no_io" flag;
	they assume that nobody will be around to submit an I/O
	request.

> Scheduling and userspace are all still fully enabled in this  
> scenario.  Once all your devices are turned off, the only remaining  
> running threads will be those which haven't done IO since the  
> beginning of the suspend.  We can then disable preemption, turn off  
> the timer interrupts, and tell the other CPUs to park all their  
> remaining threads in schedule() and sleep.  Then we put the IRQ  
> controller to sleep and go to sleep ourselves.  If our driver model  
> locking is sufficient to handle putting a parent device to sleep  
> while threads are sleeping on a child device then there are exactly 0  
> problems.
> 
> Resuming is basically running the whole process in reverse.  Runtime- 
> suspend is achieved by not setting the 'no_io' or 'no_bind' flags and  
> putting selective device-subtrees to sleep without doing anything to  
> the rest of the system.

Nobody doubts that suspend can be made to work without the freezer.  
The point is that doing it this way dumps a bunch of extra 
responsibility on drivers.

Alan Stern

