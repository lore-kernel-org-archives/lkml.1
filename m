Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZFYM2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZFYM2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZFYM2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:28:14 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45141 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZFYM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:28:13 -0400
Message-ID: <55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu>
In-Reply-To: <20090624234501.3d35642f@lxorguk.ukuu.org.uk>
References: <20090624213645.GA18843@hardeman.nu>
    <20090624234501.3d35642f@lxorguk.ukuu.org.uk>
Date: Thu, 25 Jun 2009 14:28:14 +0200 (CEST)
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP 
     id WEC1022)
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, June 25, 2009 00:45, Alan Cox wrote:
>> Lots of drivers support one or more logical devices provided by
>> different SuperI/O chips, but there seems to be no synchronisation
>> between the different drivers? Since my driver gets all info from ACPI,
>> it's no real problem here, but I'm curious...shouldn't there be some
>> kind of synchronisation between SuperI/O drivers which might all be
>> changing global registers, such as the logical device select register?
>
> I'm looking at a similar case (clash between super I/O config for serial
> and watchdog) at the moment that affects a proposed driver for some
> serial port save/restore config stuff. We can request_region to avoid
> collisions but there is no wait mechanism for super I/O devices which
> probably wants fixing with a simple list of super I/O ports and a helper
> lib. I was thinking something like
>
> 	handle = superio_request(name, dev, start, len);
>
> 	EBUSY - someone else has the I/O space registered other than
> 	super I/O. The super I/O lib would then request the I/O space and
> 	hog it.
>
> 	superio_claim(handle, block)
>
> 	Claim the super I/O providing another person isn't using it,
> 	optionally wait if so
>
> 	superio_release(handle);
>
> 	Give back the claim
>
> 	superio_free(handle)
>
> 	Free allocation

How would it work in conjunction with ACPI? When I looked at the ACPI
dumps for my motherboard, the AML code seemed happy to fiddle with global
SuperI/O registers (protected using an internal mutex).

>>    2) Location of driver
>>
>> Where should this driver go in the tree? drivers/platform/x86/?
>
> Not if the device is not x86 specific - eg a generic super I/O device

I think the SuperI/O device itself can only be found on Intel motherboards
at the moment (Winbond told me that the WPCD376I was an Intel-specific
design), but perhaps drivers/input/misc is a better fit?

>> The serial port which the WPCD376I uses for IR TX/RX is only useful for
>> Consumer IR, but it looks enough like a "normal" uart for the serial
>> driver to claim the port. I currently have to boot with
>> "8250.nr_uarts=1" to stop the serial driver from using the IR uart
>> (there is one "real" serial port in the chip). However, that's not a
>> very elegant or user-friendly option. Is there a way to blacklist the
>> port in the serial driver and/or to reclaim the port from the serial
>> driver when the CIR driver is loaded?
>
> How similar is it to a normal UART and if it looks like a normal UART why
> not drive it as one ?

(Sorry this is a brain-dump, not intended to be a rant, hopefully you can
follow my line of reasoning and provide some feedback)

I'm not that familiar with UART's in general, but the fact that I could
write a working driver using a datasheet for a 10 year older SuperI/O chip
from a different manufacturer suggests that the register layout is fairly
standard :)

There are some differences, for example, the Wake-On-IR (a separate
logical device with two sets of registers on its own) registers control
the input (there is one long-range command input and a short-range,
wide-band learning input) and output (there are 4 different IR blaster
pins which output can be directed to) as well as the baud clock generator
(24/48Mhz) for the serial port.

Considering that it's IR-only hardware, some of the uart registers and
operations (such as the modem control register, modem status interrupts,
break signals, termios and timeouts) make no sense. Baud rates can be set
freely but there is little point in doing so.

The UART detects IR activity and then continues sampling data to the RX
fifo until told to stop doing so (that's what the
how-many-0xff-bytes-in-a-row check in the irq handler does).

Also, some special handling (like disabling RX while doing TX) might be
necessary in order not to receive the sent IR commands.

Also, I don't think it's very user-friendly to have a IR device show up as
/dev/tty...how would userspace be able to find out that it's actually an
IR transceiver?

If the driver supported all of the capabilities of the hardware, there
would need to be a way to select the TX output (1-4) and RX input
(learn/command) as well as some other minor things (like getting a report
on which of the 4 TX outputs that are actually connected). These are
functionalities which are supported in Vista by using a number of
CIR-specific ioctls (and by creating a CIR-specific driver class).

The WPCD376I hardware matches the requirements Microsoft has made for
Vista MCE IR receivers (and is therefore identical, feature-wise to other
alternatives such as the SIO1049 chip, as they all want that Vista
MCE-compatible badge), so I imagine that future IR hardware will have the
same capability.

I'm not saying that the Linux kernel should replicate Vista, but some kind
of CIR-specific ioctl's or other solution will have to be defined anyway,
and the same ioctl's (or whatever) will also need to work for e.g. a
USB-based CIR transceiver or other hardware which doesn't happen to
include an UART.

Therefore I still think it's better to model the driver as an input
device, and ultimately to teach the input subsystem some specifics of CIR
devices, similar to how force-feedback devices are handled today.

-- 
David Härdeman

