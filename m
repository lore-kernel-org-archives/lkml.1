Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYGaS3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYGaS3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYGaS3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:29:43 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:56299 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbYGaS3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:29:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=Z6i5NHENEUOv4+AvlRWm6IVFyhEVrI20aWfVLFzn/lcmbn9YcxjBgvQ8jdKTcG0GOjwyJqKknyZ++UpAz+tHVDUzmGTBVhx2CBTuI6rqFMAHASwW2Yb/MF8enm2i946D;
Message-ID: <48920481.7010702@simon.arlott.org.uk>
Date: Thu, 31 Jul 2008 19:29:21 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before      late_initcall
 and move level 6s (sync) first
References: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/08 16:34, Alan Stern wrote:
> On Thu, 31 Jul 2008, Simon Arlott wrote:
> 
>> I wasn't suggesting comparing ehci_hcd_init/ohci_hcd_mod_init times,
>> with fastboot I'm assuming it may manage to take a lock those need in
>> the main initcall process and delay hcd inits.
> 
> What does your "it" above refer to?  One of the USB driver initcalls?

No, a PCI device init in the main initcall process could prevent the 
parallel hcd init from completing in the usual time.

>> >> It looks like usb device driver init requires it to immediately block and
>> >> wait for all devices to have completed init
>> >
>> > Which USB device driver init are you talking about?  Your log includes
>> > usblp_init, usb_stor_init, usb_usual_init, hid_init (for a USB mouse),
>> > and snd_usb_audio_init.  Each one completed before the next one
>> > started; none of them blocked waiting for any devices (other than their
>> > own, of course) to finish initializing.
>> 
>> Yes - and that's the point. The initcall process when it reaches usb/ is
>> this:
>> 1. ehci_hcd_init
>> 2. ohci_hcd_mod_init
>> 3. usblp_init
> 
> It sounds like you have usblp compiled into the kernel instead of
> building it as a module.  Do things change for the better if you make
> usblp a module?

Only if I make ALL usb device drivers modules, otherwise the first one has 
to wait for all devices to finish initialising. (I get the same delay on 
usb_stor_init instead).
 
>> There is nothing else to run between 1-2 and 3, so there is no opportunity
>> to initialise devices in the background and usblp_init blocks for a while.
> 
> If it were a module then it would block in a separate thread and 
> wouldn't hold up the main init process.

Right, but I want to compile all of this into the kernel.

>> If ehci_hcd_init and ohci_hcd_mod_init were moved up to before sata/ide/net
>> but usblp_init was kept after these then the devices should be ready by the
>> time it gets there.
> 
> It's not entirely clear why usblp is blocking at all.  Probably because
> it is waiting on the device semaphores for devices that are currently
> being probed -- the driver core won't allow two threads to probe the
> same device concurrently.

Ok - so there could be some big improvements to be had by making the hcd 
init happen as early as possible and the device initcalls later?

>> >>  - so regardless of where we
>> >> put the usb/ directory in the initcall order, it will always wait a while
>> >> because the drivers will be immediately after the hcd init...
>> >
>> > No, you're wrong.  To prove it, try patching the start of hub_events()
>> > in drivers/usb/core/hub.c like this:
>> >
>> >  	 * Not the most efficient, but avoids deadlocks.
>> >  	 */
>> >  	while (1) {
>> > +		ssleep(5);
>> >
>> >  		/* Grab the first entry at the beginning of the list */
>> >  		spin_lock_irq(&hub_event_lock);
>> >
>> > Then see what happens.
>> 
>> I'll try this tonight, but all I'd expect to see is the background thread
>> take longer to do anything?
> 
> Well, yes, of course.  My point is that the drivers (those in modules, 
> anyway) won't initialize _immediately_ after the HCD init, as you 
> wrote above.  There will be this 5-second delay.

Right, devices wouldn't show up for modules for 5 seconds.

>> The usb device driver initcalls aren't initialised by khubd
> 
> Um.  The initcalls for USB device drivers built as modules are made by 
> the modprobe thread, which is started in response to a uevent created 
> by khub.  So while they aren't initialized directly by khubd, they are 
> initialized indirectly by it.
> 
> On the other hand, the initcalls for drivers compiled into the kernel 
> are a different story.
> 
>> and they're
>> definitely blocking on the khubd device initialisation [for that device,
>> as you said earlier] being completed.
> 
> Driver probing is always going to be a bottleneck, even for
> non-matching device/driver pairs.  That's because the driver core
> acquires the device semaphore even before calling the bus's match
> routine.  When a new driver is registered, the driver core just goes
> down the list of all devices registered on the bus, locking each one in
> turn and trying to match & probe it.

So could HCD init be moved higher in the initcall order so that the devices 
have been initialised enough by khubd that device driver initcalls take 
much less time?

I'm not really sure how to do that, except by doing usb/core/ usb/host/ 
and then usb/class/ usb/storage/ etc....

-- 
Simon Arlott
