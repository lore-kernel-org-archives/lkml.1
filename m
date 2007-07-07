Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbXGGAny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbXGGAny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 20:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXGGAnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 20:43:45 -0400
Received: from smtpout.mac.com ([17.250.248.185]:59819 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXGGAno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 20:43:44 -0400
In-Reply-To: <Pine.LNX.4.44L0.0707061114190.3737-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0707061114190.3737-100000@iolanthe.rowland.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EAA83A3B-1534-458B-A6F8-D090D670D4E7@mac.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 20:43:37 -0400
To: Alan Stern <stern@rowland.harvard.edu>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 06, 2007, at 11:42:33, Alan Stern wrote:
> On Thu, 5 Jul 2007, Kyle Moffett wrote:
>> Umm, this thread is NOT ABOUT HIBERNATING!!!  Please go back and  
>> read the subject, specifically the "suspend to RAM" parts :-D.
>
> But it _is_ about the freezer; see the "Remove process freezer"  
> part. :-)  Since the freezer is used during hibernation,  
> hibernation is a legitimate topic.

Except Linus already decreed (and I heartily agree) that hibernation  
and suspend-to-RAM were fundamentally completely different operations  
and therefore any attempts to share code were basically just making a  
big muddy mess of things.  Would a thread "Remove phase-of-the-moon  
calculations from network-recv code" be relevant to lunar observation  
just because the two had to do with the phases of the moon?  No!

>> When your hardware can put itself to sleep and atomically preserve  
>> memory as it does so, you don't need an atomic copy.  For Real  
>> Suspend(TM) (IE: Suspend-to-RAM), the list of things to do is  
>> short and simple:
>>
>> 1)  Stop DMA and put most hardware into low-power states (stops  
>> all interrupt sources)
>> 2)  Ensure that the other CPUs have finished any trailing  
>> interrupt handlers and put them to sleep
>> 3)  Put the interrupt-controllers into low-power stat
>> 4)  Go to sleep
>
> Your short and simple list omits a few crucial items:
>
> A)  Decide what to do about remote wakeup requests.

Why do we care?  If the wakeup request arrives before we go to sleep,  
we obviously aren't asleep and so can't wake up.  If it arrives after  
we go to sleep then it will wake us up.  Anything that depends on a  
wakeup arriving mid-sequence is 100% masochistic race condition.

> B)  Prevent I/O requests from resuming devices that have been  
> suspended.

(1a) As I describe below, step (1) includes setting NO_BIND and NO_IO  
flags on devices as they are processed.  Anybody who wants to do IO  
while those flags are set should just go sleep on a waitqueue.

> C)  Prevent devices and drivers from being registered or  
> unregistered; in particular decide what to do about hot-plug or hot- 
> unplug events.

(1b) Again, that's where the NO_BIND flag comes in.  If its set then  
any device probe events must sleep, otherwise they can go through.

> D)  Block driver bind or unbind calls.

See points (1a) and (1b) above.

> Any of these things is capable of screwing up the course of  
> events.  (In fact A _should_ be allowed to abort a suspend.)

If any of those things screw up suspend-to-RAM then it is 100% the  
drivers fault and no "process freezer" is going to fix it, end of  
story.  And "A" cannot be made reliable.  At some point you shut off  
interrupts right before going to sleep, and at that point any remote  
wakeup event is just going to get dropped until you actually enter  
sleep mode and the hardware takes over again.  If you miss a wakeup  
event then whatever sent it should just retry, just as with *every*  
other kind of network packet.

>> How about a freezer whose job it is to "wait for pending hard  
>> interrupts to complete when we have already guaranteed that we  
>> won't get any more"?  That part should be really *REALLY* easy.   
>> You don't need to care about either userspace processes or kernel  
>> threads at all.  Specifically, Step 1 consists of:
>>
>> suspend_device(dev)
>> {
>> 	set_no_bind_flag(dev);
>> 	for (dev->subdevices)
>> 		suspend_device(dev);
>> 	set_no_io_flag(dev);
>> 	wait_for_in_progress_dma(dev);
>> 	turn_off_interrupts(dev);
>> 	go_to_low_power_state(dev);
>> }
>>
>> After you've set the "no_bind" flag, you won't get any *new*  
>> subdevices trying to bind,
>
> So what happens if a new subdevice arrives at the wrong time?  Do  
> you block instead of binding it?  While holding a mutex needed to  
> suspend the parent device?

That would be a driver bug.  If you have asynchronous probing then  
proper suspend handling includes being able to postpone driver probe  
events until after resume.  If you have synchronous probing then the  
problem doesn't exist because "set_no_bind_flag" is just telling the  
device not to raise any more device probe interrupts.

> What about drivers trying to bind to existing devices?

While binding it will clearly be holding a mutex/spinlock on the  
parent device, so the suspend process will wait for it.  When binding  
is done the suspend_device() code will take the device lock and tell  
everything else to postpone further bind requests as above.

> What happens to I/O requests submitted after the "no_io" flag is  
> set?  The driver will have to block them, effectively creating its  
> own little "freezer".

Oh, so you're calling every waitqueue in the kernel a "freezer" now?   
We do these things at the driver level *all* *the* *time*.  For  
instance, you can't submit new IOs to an ATA controller while it's  
renegotiating the bus speed, but that's never been a problem before.

>> When all the leaf devices are off, the parent device can be turned  
>> off because everything waiting on the leaf devices is blocked on  
>> them and won't unblock until the parent device *AND* the leaf  
>> device are turned on again, in that order.
>
> This is a lot like what we already do.  The differences are:
>
> There is nothing corresponding to your "no-bind" flag.
>
> Most drivers don't have anything like your "no_io" flag; they  
> assume that nobody will be around to submit an I/O request.

Most drivers have an implicit NO_BIND flag:  The device's interrupts  
are off and/or its in a low-power state.  USB is already terribly  
buggy with regards to suspend:  If you hotplug a device during  
suspend (like the touchpad in my powerbook powering down/up), then  
the USB stack will basically hang that controller.  The device is off  
and the hotplug triggers interrupts and IO, *EVEN* *WITHOUT*  
*USERSPACE*.

So if your driver doesn't already have a proper way of blocking IO  
during suspend then it probably doesn't suspend 50% of the time  
anyways.  A bug which bites *every* *time* is easy to fix, one which  
only bites when things hit a race condition is much harder.

>> Resuming is basically running the whole process in reverse.   
>> Runtime-suspend is achieved by not setting the 'no_io' or  
>> 'no_bind' flags and putting selective device-subtrees to sleep  
>> without doing anything to the rest of the system.
>
> Nobody doubts that suspend can be made to work without the freezer.  
> The point is that doing it this way dumps a bunch of extra  
> responsibility on drivers.

That responsibility has been there ever since suspend-to-RAM support  
was added.  Nobody ever denied that writing a proper driver wasn't  
tricky.  You have to simultaneously be able to handle handle hot- 
unplug, IO errors, interrupts, IO requests, suspend-to-RAM, and  
hibernation.  If your driver mutual-exclusion is buggy then it  
probably already bites you during hotplug or other similar  
scenarios.  Let's at least make the problems much more reproducible  
so we can fix the drivers properly instead of continuing to kludge  
around it for all eternity.

Cheers,
Kyle Moffett

