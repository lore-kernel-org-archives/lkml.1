Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYH2RGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYH2RGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbYH2RF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:05:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2426 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754566AbYH2RF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:05:56 -0400
Date: Fri, 29 Aug 2008 13:05:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frans Pop <elendil@planet.nl>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [regression] usb: sometimes dead keyboard after boot (was: new
 errors during device detection)
In-Reply-To: <200808291503.56635.elendil@planet.nl>
Message-ID: <Pine.LNX.4.44L0.0808291209260.4447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Frans Pop wrote:

> On Tuesday 26 August 2008, Alan Stern wrote:
> > > It also seems to be fragile in practice. I have now had two occasions
> > > since your last mail where my system would come up with a dead USB
> > > keyboard and it looks like this issue is the root cause.
> >
> > It isn't any more fragile than unplugging the USB cable and then
> > plugging it back in.  If your system can't handle that sort of thing
> > then something else is wrong.  I.e., you've run across a bug, not a
> > design flaw.
> 
> The fragile part IMO is that the kernel currently allows the loading of 
> ehci to interrupt the initialization of uhci/ohci and *that* is what is 
> causing the errors.

It doesn't interrupt just the initialization of UHCI/OHCI -- it 
interrupts all their activities.

And I wouldn't say the kernel "allows" this to happen.  More like it 
has no choice.

> I have run some tests loading ehci and uhci manually and when they are 
> done separately (i.e. with a little delay between the two) there are no 
> errors at all!

You have to be careful when making statements like that.  All you know 
is that no error messages showed up _in the log_.  But I'll bet there 
were plenty of errors.

In your attached logs you tested with a keyboard and wireless mouse
receiver.  The USB HID driver is careful not to send error messages to
the log as soon as it encounters I/O errors; instead it retries at
various increasing intervals for a while before giving up.  Long enough
for the disconnect notification to be received.

If you would use usbmon (see Documentation/usb/usbmon.txt) to record 
what those HID drivers actually send and receive when ehci-hcd is 
loaded, you will see that errors did indeed occur.

> If uhci is loaded first, you only get a nice, clean "USB disconnect" 
> message (for devices already detected by uhci) when ehci is loaded.

More accurately, you get exactly the same sequence of events as if you
had unplugged the USB cable.  Sometimes it's a nice clean disconnect
message, and sometimes that message is preceded by a string of error
messages.  It depends on how the device is being used at the time.

Do you have a USB flash drive?  Try plugging that in and running
something like "cat /dev/sdX >/dev/null" when you load ehci-hcd.

> If ehci is loaded first the low-speed devices are only detected after uhci 
> is loaded as well.

As they should be.

> The *only* time you get the "device not accepting address" and "unable to 
> enumerate" errors is when you allow the ehci initialization to interrupt 
> the uhci initialization. IMO that cannot be classified anything other 
> than a bug.

That's hardly a surprise -- those messages are emitted by the device
initialization code.  So what you're saying is circular: The only time
you get initialization errors is when you interrupt device
initialization.  Well of course!

> > I can't tell exactly what's going on because your usbcore module wasn't
> > built with CONFIG_USB_DEBUG enabled.
> 
> Two problems:
> - CONFIG_USB_DEBUG causes such a huge load of output that it is totally
>   unacceptable to have that enabled permanently for a running system

It shouldn't do that.  Almost all of the extra output occurs when 
devices are plugged in or unplugged; during normal operation there 
should be very few extra messages.  (Depending on what USB drivers you 
use, I suppose...)

> - I cannot reproduce this issue on demand, even though I've tried with
>   various delays between loading uhci and ehci

That's unforunate.

> Possibly with the new patches from Greg KH [1] it would be possible to 
> disable USB debugging automatically when system boot is completed, but 
> I'd have to build a kernel with those and wait for the problem to happen 
> again.
> 
> What I can see in the logs I do have is that in the error case for some 
> reason a "reset low speed USB device" is triggered instead of either an
> "enumeration failure" or a "USB disconnect", which are what I normally 
> see.

There should always be a USB disconnect, unless the interruption 
occurs before the low-speed device was registered in the first place.

> As mentioned before, this seems to indicate to me a subtle timing 
> difference between the boots and IMO confirms the danger of allowing the 
> initialization of ehci to interrupt an ongoing initialization of uhci.
> 
> My guess is that this "reset" is insufficient to cause the bus to be 
> properly rescanned when ehci hands it back to uhci. I also guess that a
> "reset" can occur if the interruption by the ehci loading happens 
> somewhere between the times that would otherwise cause an "enumeration 
> failure" and a clean "USB disconnect".

Offhand I can't think what time that would be.  Which is why having a 
debugging log would be a big help.  Unlike those error messages you 
dislike so much, this sounds like a genuine bug.

> You made the comment that this issue isn't worse than yanking out 
> cables/devices at random times. AFAIK it is still very much discouraged 
> to do that for e.g. storage devices, especially when data has recently 
> been written to them, without at least syncing and preferably unmounting 
> the device first. For a lot of devices (like keyboards) it doesn't really 
> matter of course.

True.

> There is one huge difference though: if a user yanks out a (storage) 
> device while it is in use he's just being dumb and IMO deserves what he 
> gets.

Or clumsy (tripped over the cable).  :-)

> It's basically the same as pulling a SATA cable or the power cable 
> of a desktop system.
> But when the _kernel_ does the same, it is IMO being irresponsible.
> 
> I'm don't think it is reasonable to go so far as to completely prohibit 
> ehci from loading after uhci, especially not during system boot. But 
> maybe it should be made to first check with the low speed drivers what 
> their state is _before_ just barging in and rudely interrupting things on 
> the hardware level.

What exactly should it check for?

> And maybe the kernel should (eventually) even go so far as to check 
> whether a low speed USB driver is in use by a mounted storage device and 
> maybe then loading ehci should be blocked. Just as 'modprobe -r' for a 
> ATA module is blocked if the driver is still in use.

Linus made a similar suggestion (regarding a different problem) some
time within the last year.  After looking into the matter he realized
that it is very difficult, effectively impossible, to tell at the USB
level whether a storage device is mounted.

Besides, what happens during your boot-up procedure if ehci-hcd is too 
slow?  A storage device will be discovered and mounted using uhci-hcd, 
and then ehci-hcd would _never_ get loaded!

> My tests show that it is quite easy to avoid errors by just making sure 
> that ehci does not interrupt *the initialization process* of uhci. 

I think that's an oversimplification, but never mind.  (And actually 
you don't mean the initialization process of uhci-hcd; you mean that a 
device attached to a UHCI controller is being initialized.)

> Wouldn't it be possible to let ehci first check the state of the 
> uhci/ohci drivers and to have it *delay* its own initialization if those 
> are still busy initializing themselves?

It would be possible to have ehci-hcd delay initializing its controller 
while other USB devices are being initialized.  Or more generally, 
while khubd was running.

It's not at all clear (to me at least) whether this would solve any
_real_ problems.  It might do nothing more than prevent certain sorts
of error messages from appearing in the system log.  But I guess that 
would be good enough for you...

> Conversely uhci/ohci should probably not respond to new devices being 
> plugged in when they have been notified by ehci that it wants to (or has 
> started to) initialize itself.

By then it's too late; devices that were attached previously will
already be in the middle of their initialization procedures.

> Another option (probably on top of the above suggestion) would be to 
> slightly delay ohci/uhci initialization during system boot. This would 
> allow the general hardware discovery process to reach the later ehci PCI 
> device and start the ehci initialization.

People would _really_ dislike that!  They do not want to endure extra 
delays before they can start typing on their USB keyboards.

> ohci/uhci initialization could then start after ehci initialization has 
> completed; if no ehci device is present, ohci/uhci initialization would 
> still just start after the delay times out.

That won't work in situations where uhci-hcd and ehci-hcd are built 
into the kernel, as opposed to being loadable modules.

> My boot logs show that the devices are generally detected within the same 
> second, so such a delay could be quite short.

Ha!  Someone on LKML (I forget who) mentioned just a few weeks ago that 
his system could boot up to the user prompt in only 2 seconds, and he 
certainly wouldn't put up with an extra one-second delay merely to 
avoid a few error message in the log.

> Does this sound at all logical and feasible?

The first proposal is feasible; I can write a patch to implement it.  
How much it will end up helping anything isn't clear, though.

Alan Stern

