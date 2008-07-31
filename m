Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYGaPeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYGaPeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYGaPeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:34:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58491 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752612AbYGaPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:34:05 -0400
Date: Thu, 31 Jul 2008 11:34:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before     
 late_initcall and move level 6s (sync) first
In-Reply-To: <5b329c74610e4f3332133acddab64262b7c0fc7a@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Message-ID: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Simon Arlott wrote:

> I wasn't suggesting comparing ehci_hcd_init/ohci_hcd_mod_init times,
> with fastboot I'm assuming it may manage to take a lock those need in
> the main initcall process and delay hcd inits.

What does your "it" above refer to?  One of the USB driver initcalls?

> >> It looks like usb device driver init requires it to immediately block and
> >> wait for all devices to have completed init
> >
> > Which USB device driver init are you talking about?  Your log includes
> > usblp_init, usb_stor_init, usb_usual_init, hid_init (for a USB mouse),
> > and snd_usb_audio_init.  Each one completed before the next one
> > started; none of them blocked waiting for any devices (other than their
> > own, of course) to finish initializing.
> 
> Yes - and that's the point. The initcall process when it reaches usb/ is
> this:
> 1. ehci_hcd_init
> 2. ohci_hcd_mod_init
> 3. usblp_init

It sounds like you have usblp compiled into the kernel instead of
building it as a module.  Do things change for the better if you make
usblp a module?

> There is nothing else to run between 1-2 and 3, so there is no opportunity
> to initialise devices in the background and usblp_init blocks for a while.

If it were a module then it would block in a separate thread and 
wouldn't hold up the main init process.

> If ehci_hcd_init and ohci_hcd_mod_init were moved up to before sata/ide/net
> but usblp_init was kept after these then the devices should be ready by the
> time it gets there.

It's not entirely clear why usblp is blocking at all.  Probably because
it is waiting on the device semaphores for devices that are currently
being probed -- the driver core won't allow two threads to probe the
same device concurrently.

> >>  - so regardless of where we
> >> put the usb/ directory in the initcall order, it will always wait a while
> >> because the drivers will be immediately after the hcd init...
> >
> > No, you're wrong.  To prove it, try patching the start of hub_events()
> > in drivers/usb/core/hub.c like this:
> >
> >  	 * Not the most efficient, but avoids deadlocks.
> >  	 */
> >  	while (1) {
> > +		ssleep(5);
> >
> >  		/* Grab the first entry at the beginning of the list */
> >  		spin_lock_irq(&hub_event_lock);
> >
> > Then see what happens.
> 
> I'll try this tonight, but all I'd expect to see is the background thread
> take longer to do anything?

Well, yes, of course.  My point is that the drivers (those in modules, 
anyway) won't initialize _immediately_ after the HCD init, as you 
wrote above.  There will be this 5-second delay.

> The usb device driver initcalls aren't initialised by khubd

Um.  The initcalls for USB device drivers built as modules are made by 
the modprobe thread, which is started in response to a uevent created 
by khub.  So while they aren't initialized directly by khubd, they are 
initialized indirectly by it.

On the other hand, the initcalls for drivers compiled into the kernel 
are a different story.

> and they're
> definitely blocking on the khubd device initialisation [for that device,
> as you said earlier] being completed.

Driver probing is always going to be a bottleneck, even for
non-matching device/driver pairs.  That's because the driver core
acquires the device semaphore even before calling the bus's match
routine.  When a new driver is registered, the driver core just goes
down the list of all devices registered on the bus, locking each one in
turn and trying to match & probe it.

Alan Stern

