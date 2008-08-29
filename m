Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYH2NER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYH2NER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYH2NEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:04:00 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:21212 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYH2ND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:03:59 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [regression] usb: sometimes dead keyboard after boot (was: new errors during device detection)
Date: Fri, 29 Aug 2008 15:03:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0808261626140.2139-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808261626140.2139-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8O/tIWA2gTE5feU"
Message-Id: <200808291503.56635.elendil@planet.nl>
X-OriginalArrivalTime: 29 Aug 2008 13:03:57.0067 (UTC) FILETIME=[B24B55B0:01C909D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8O/tIWA2gTE5feU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 26 August 2008, Alan Stern wrote:
> > It also seems to be fragile in practice. I have now had two occasions
> > since your last mail where my system would come up with a dead USB
> > keyboard and it looks like this issue is the root cause.
>
> It isn't any more fragile than unplugging the USB cable and then
> plugging it back in.  If your system can't handle that sort of thing
> then something else is wrong.  I.e., you've run across a bug, not a
> design flaw.

The fragile part IMO is that the kernel currently allows the loading of 
ehci to interrupt the initialization of uhci/ohci and *that* is what is 
causing the errors.

I have run some tests loading ehci and uhci manually and when they are 
done separately (i.e. with a little delay between the two) there are no 
errors at all!

If uhci is loaded first, you only get a nice, clean "USB disconnect" 
message (for devices already detected by uhci) when ehci is loaded.
If ehci is loaded first the low-speed devices are only detected after uhci 
is loaded as well.

The *only* time you get the "device not accepting address" and "unable to 
enumerate" errors is when you allow the ehci initialization to interrupt 
the uhci initialization. IMO that cannot be classified anything other 
than a bug.

See also the attachments with dmesg output:
- modprobe_uhci-ehci: uhci first; ehci later
- modprobe_ehci-uhci: ehci first; uhci later
- modprobe_uhci+ehci: both simultaneously (uhci slightly earlier)

> > Attached a full diff between dmesg from two consecutive boots: first
> > without keyboard; after reboot the keyboard is detected. The actual
> > difference is fairly small and clearly shows that usb 3-1 is not
> > handed off correctly, probably due to a small difference in timing.
> >
> > Note that I've never seen this problem with earlier kernels.
>
> I can't tell exactly what's going on because your usbcore module wasn't
> built with CONFIG_USB_DEBUG enabled.

Two problems:
- CONFIG_USB_DEBUG causes such a huge load of output that it is totally
  unacceptable to have that enabled permanently for a running system
- I cannot reproduce this issue on demand, even though I've tried with
  various delays between loading uhci and ehci

Possibly with the new patches from Greg KH [1] it would be possible to 
disable USB debugging automatically when system boot is completed, but 
I'd have to build a kernel with those and wait for the problem to happen 
again.

What I can see in the logs I do have is that in the error case for some 
reason a "reset low speed USB device" is triggered instead of either an
"enumeration failure" or a "USB disconnect", which are what I normally 
see. As mentioned before, this seems to indicate to me a subtle timing 
difference between the boots and IMO confirms the danger of allowing the 
initialization of ehci to interrupt an ongoing initialization of uhci.

My guess is that this "reset" is insufficient to cause the bus to be 
properly rescanned when ehci hands it back to uhci. I also guess that a
"reset" can occur if the interruption by the ehci loading happens 
somewhere between the times that would otherwise cause an "enumeration 
failure" and a clean "USB disconnect".

> Have you experimented with unloading and reloading uhci-hcd and
> ehci-hcd by hand (over the network if your only keyboard is USB)?

I have now. See results and comments above.

> If you remove both and then load uhci-hcd first followed by ehci-hcd,
> does the same thing happen?

No, unfortunately I cannot reproduce it on demand. Probably because the 
timing is too subtle and the "window" in which the problem occurs is 
quite small.

> > Even in the case where ehci-hcd is loaded much later I don't think
> > error messages would be right. At least, assuming that the kernel can
> > guarantee that the driver hand-off can be done cleanly (without risk
> > of damaging interruptions in the working of already connected
> > devices). And if it cannot guarantee that, then maybe it should just
> > refuse to load ehci-hcd at all!
>
> Well, that's a problem.  The kernel _can't_ make that guarantee, not
> once some USB devices have been set up.  So according to your
> reasoning, ehci-hcd shouldn't be allowed to load if uhci-hcd is already
> loaded!

You made the comment that this issue isn't worse than yanking out 
cables/devices at random times. AFAIK it is still very much discouraged 
to do that for e.g. storage devices, especially when data has recently 
been written to them, without at least syncing and preferably unmounting 
the device first. For a lot of devices (like keyboards) it doesn't really 
matter of course.
There is one huge difference though: if a user yanks out a (storage) 
device while it is in use he's just being dumb and IMO deserves what he 
gets. It's basically the same as pulling a SATA cable or the power cable 
of a desktop system.
But when the _kernel_ does the same, it is IMO being irresponsible.

I'm don't think it is reasonable to go so far as to completely prohibit 
ehci from loading after uhci, especially not during system boot. But 
maybe it should be made to first check with the low speed drivers what 
their state is _before_ just barging in and rudely interrupting things on 
the hardware level.

And maybe the kernel should (eventually) even go so far as to check 
whether a low speed USB driver is in use by a mounted storage device and 
maybe then loading ehci should be blocked. Just as 'modprobe -r' for a 
ATA module is blocked if the driver is still in use.

> Can you suggest a reasonable method for suppressing the unwanted error
> messages?  Maybe I'm too close to the problem, but nothing occurs to
> me.  Part of the problem is that these errors could occur at any point
> during the life cycle of a USB device: during detection, during
> enumeration, during configuration, or during normal operation.  It
> doesn't seem reasonable to have a flag to suppress _every_ error
> message generated by the USB subsystem.

My tests show that it is quite easy to avoid errors by just making sure 
that ehci does not interrupt *the initialization process* of uhci. 
Wouldn't it be possible to let ehci first check the state of the 
uhci/ohci drivers and to have it *delay* its own initialization if those 
are still busy initializing themselves?
Conversely uhci/ohci should probably not respond to new devices being 
plugged in when they have been notified by ehci that it wants to (or has 
started to) initialize itself.

Another option (probably on top of the above suggestion) would be to 
slightly delay ohci/uhci initialization during system boot. This would 
allow the general hardware discovery process to reach the later ehci PCI 
device and start the ehci initialization.
ohci/uhci initialization could then start after ehci initialization has 
completed; if no ehci device is present, ohci/uhci initialization would 
still just start after the delay times out.
My boot logs show that the devices are generally detected within the same 
second, so such a delay could be quite short.


Does this sound at all logical and feasible?

Cheers,
FJP

[1] http://lkml.org/lkml/2008/8/8/529


--Boundary-00=_8O/tIWA2gTE5feU
Content-Type: text/plain;
  charset="iso 8859-15";
  name="modprobe_ehci-uhci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="modprobe_ehci-uhci"

ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x902c4400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
input: USB Compliant Keyboard as /class/input/input18
input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.2-1
input: USB Compliant Keyboard as /class/input/input19
input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.2-1
usb 5-1: new low speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input20
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-1

--Boundary-00=_8O/tIWA2gTE5feU
Content-Type: text/plain;
  charset="iso 8859-15";
  name="modprobe_uhci-ehci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="modprobe_uhci-ehci"

USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
input: USB Compliant Keyboard as /class/input/input9
input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.2-1
input: USB Compliant Keyboard as /class/input/input10
input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.2-1
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input11
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x902c4400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
usb 3-1: USB disconnect, address 2
usb 4-1: USB disconnect, address 2
usb 3-1: new low speed USB device using uhci_hcd and address 3
usb 3-1: configuration #1 chosen from 1 choice
input: USB Compliant Keyboard as /class/input/input12
input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.2-1
input: USB Compliant Keyboard as /class/input/input13
input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.2-1
usb 4-1: new low speed USB device using uhci_hcd and address 3
usb 4-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input14
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-1

--Boundary-00=_8O/tIWA2gTE5feU
Content-Type: text/plain;
  charset="iso 8859-15";
  name="modprobe_uhci+ehci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="modprobe_uhci+ehci"

USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 3-1: new low speed USB device using uhci_hcd and address 2
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x902c4400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
usb 3-1: device not accepting address 2, error -71
hub 3-0:1.0: unable to enumerate USB device on port 1
usb 3-1: new low speed USB device using uhci_hcd and address 4
usb 3-1: configuration #1 chosen from 1 choice
input: USB Compliant Keyboard as /class/input/input27
input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.2-1
input: USB Compliant Keyboard as /class/input/input28
input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.2-1
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input29
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-1

--Boundary-00=_8O/tIWA2gTE5feU--
