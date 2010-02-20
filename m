Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab0BTHPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 02:15:39 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:46126 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0BTHPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 02:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bDHOpFAt7Cpl/ezBG6JRuosxRJSS/Kqupmlg6GNsFvbJ4z1qdRY9ot6PahlZULkjcA
         DNkDooJGji90LN0bnNhvlFqoRRyJvBOcpWNJSslJuEEBy+8v9qIfRqWHvFzBlSmWh+4d
         SZ3BSz0zsrQ4MybuE9RRJcLA6ovkEOCSOL3Hk=
MIME-Version: 1.0
In-Reply-To: <201002192139.46189.david-b@pacbell.net>
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com>
	 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
	 <201002192139.46189.david-b@pacbell.net>
Date: Sat, 20 Feb 2010 01:15:36 -0600
Message-ID: <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
From: Robert Hancock <hancockrwd@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 11:39 PM, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 18 February 2010, Robert Hancock wrote:
>> >
>> > But we disabled it on purpose, because of problems, do we want those
>> > problems again?
>>
>> AFAICS, it was disabled because of problems with kernel code, not with
>> hardware (and it appears the issue was with the code that detected the
>> expanded DMA mask in the USB device driver code, not the HCD driver).
>> CCing David Brownell who may know more.
>
> That's a good summary of the high points.  Testing was potentially an
> issue, but it never quite got that far.  So I have no idea if there are
> systems where EHCI advertises 64-bit DMA support but that support is
> broken (e.g. "Yet Another Hardware Mechanism MS-Windows Ignores", so that
> only Linux would ever trip over the relevant BIOS breakage).

According to one Microsoft page I saw, Windows XP did not implement
the 64-bit addressing feature in EHCI. I haven't found any information
on whether any newer Windows versions do or not.

>
> I won't attempt to go into details, but I recall a few basic issues:
>
>  * Not all clients or implementors of the "dma mask" mechanism agreed
>   on what it was supposed to achieve.  Few, for example, really used
>   it as a mask ... and it rarely affects allocation of buffers that
>   will later get used for DMA.
>
>  * Confusing semantics for the various types of DMA restriction which
>   hardware may impose, and upper layers in driver stacks would thus
>   need (in some cases) to cope with.

I think this is pretty well nailed down at this point. I suspect the
confusion partly comes from the expectation that driver code should be
able to use dma_supported to test a particular mask against what a
device had been configured for. This function is really meant for use
in arch code, not for drivers. It's supposed to indicate if it's legal
to set a device's mask to the given value, not whether a given DMA
mask is compatible with the previously set mask. Calling this on a
device that arch code doesn't know about (like a USB device) will
quite likely give a non-useful result or possibly even blow up. If a
driver needs to check a device's mask, it can just check against it
directly.

>
>  * How to pass such restrictions up the driver stack ... as for example
>   that NETIF_* flag.  ISTR there was some block layer issue too, but
>   at this remove I can't remember any details at all.  (If networking
>   and the block layer can use 64-bit DMA, I can't imagine many other
>   subsystems would deliver wins as big.)  For example, how would one
>   pass up the knowledge that a driver for a particular USB peripheral
>   across a few hubs) can do DMA to/from address 0x1234567890abcdef, but
>   the same driver can't do that for an otherwise identical peripheral
>   connected through a different HCD?

I think this logic is also in place, for the most part. The DMA mask
from the HCD appears to be propagated into the USB device, and then
into the interface objects. For usb-storage, the SCSI layer
automatically sets the bounce limit based on the device passed into
it, so the right thing gets done. The networking layer seems like it
would need explicit handling in the drivers - I think basically a
check if the device interface's DMA mask was set to DMA_BIT_MASK(64)
and if so, set the HIGHDMA flag.

>
>  * There were probably a few PCI-specific issues too.  I don't think
>   at that time there were many users of 64-bit DMA which weren't
>   specific to PCI.  Wanting to use the generic DMA calls for such
>   stuff wasn't really done back then.  But ... the USB stack uses
>   the generic calls, and drivers sitting on top of usbcore (and its
>   tightly coupled HCDs) will never issue PCI-specific calls, since
>   they need to work on systems that don't even have PCI.
>
> I basically think that if the controller can do 64-bit DMA, it should
> be enabling it by default ... assuming the software stack can handle
> that.  (What would be the benefit of adding needless restrictions,
> and making systems needlessly apply bounce buffering.)  So while I'd
> like to see the 64-bit DMA working, it should IMO be done without any
> options to cause trouble/confusion.
>
> But at that time it wasn't straightforward to manage 64-bit DMA except
> in the very lowest level PCI drivers.  That is, EHCI could do it ...
> but driver layers on top of it had no good way to do their part.  For
> example, when they manage DMA mappings themselves.)
>
> - Dave
>
>
