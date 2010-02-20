Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0BTSNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 13:13:55 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:62142 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab0BTSNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 13:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XXKvBN6ihjXJdrvloKNANrxag8CiUOtalPCUL0++pEAy/nzuGAoFuKkmuwb37jZ2xX
         YYaGkCyuyZjbkukzX75sQ6vRaSy2SkvpnunZlmUwbuvcjGXVywLT4fXMVWupBh2gYD7c
         QNMJcno/S4VMY9UjXz3avI/oUZ4qY0ltfnI7I=
MIME-Version: 1.0
In-Reply-To: <201002200008.00048.david-b@pacbell.net>
References: <4B7CAF95.6020306@gmail.com>
	 <201002192139.46189.david-b@pacbell.net>
	 <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
	 <201002200008.00048.david-b@pacbell.net>
Date: Sat, 20 Feb 2010 12:13:51 -0600
Message-ID: <51f3faa71002201013s61651744q6abb47c31f850cd@mail.gmail.com>
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

On Sat, Feb 20, 2010 at 2:07 AM, David Brownell <david-b@pacbell.net> wrote:
> On Friday 19 February 2010, Robert Hancock wrote:
>> > That's a good summary of the high points.  Testing was potentially an
>> > issue, but it never quite got that far.  So I have no idea if there are
>> > systems where EHCI advertises 64-bit DMA support but that support is
>> > broken (e.g. "Yet Another Hardware Mechanism MS-Windows Ignores", so that
>> > only Linux would ever trip over the relevant BIOS breakage).
>>
>> According to one Microsoft page I saw, Windows XP did not implement
>> the 64-bit addressing feature in EHCI. I haven't found any information
>> on whether any newer Windows versions do or not.
>
> Note that it's pure speculation on my part whether or not any such
> BIOS setup is needed.  One would hope it wouldn't be required ...
> but then engineers have been known to create all sorts of options
> that require tweaking ... and trigger errors when the options aren't
> stroked in the right way.
>
>
>> > I won't attempt to go into details, but I recall a few basic issues:
>> >
>> >  * Not all clients or implementors of the "dma mask" mechanism agreed
>> >   on what it was supposed to achieve.  Few, for example, really used
>> >   it as a mask ... and it rarely affects allocation of buffers that
>> >   will later get used for DMA.
>> >
>> >  * Confusing semantics for the various types of DMA restriction which
>> >   hardware may impose, and upper layers in driver stacks would thus
>> >   need (in some cases) to cope with.
>>
>> I think this is pretty well nailed down at this point. I suspect the
>> confusion partly comes from the expectation that driver code should be
>> able to use dma_supported to test a particular mask against what a
>> device had been configured for. This function is really meant for use
>> in arch code, not for drivers.
>
> If so, that suggests a minor hole in the DMA interface, since drivers
> do need such info.

Well, if you need to test a mask against a device's existing one, then
all you really need is something like:

if( *dev->dma_mask & mymask == mymask)

A wrapper for that might not be a bad idea, but it's fairly trivial..

>
> As you note, mask manipulation can be done in drivers ... but on the flip
> side, such things are a bit error prone and deserve API wrappers.  (Plus,
> there's the whole confusion about whether it's really a "mask", where a
> given bit flags whether that address line is valid.  Seems more like using
> a bitstring of N ones as a representation of N, where only N matters.)

Yeah, that's the de-facto valid definition.. I'm sure not much kernel
code copes well with somebody setting a mask like "allow 64-bit
addresses, except not where bits 48 and 53 are set"..

>
>
>> >  * How to pass such restrictions up the driver stack ... as for example
>> >   that NETIF_* flag.  ISTR there was some block layer issue too, but
>> >   at this remove I can't remember any details at all.  (If networking
>> >   and the block layer can use 64-bit DMA, I can't imagine many other
>> >   subsystems would deliver wins as big.)  For example, how would one
>> >   pass up the knowledge that a driver for a particular USB peripheral
>> >   across a few hubs) can do DMA to/from address 0x1234567890abcdef, but
>> >   the same driver can't do that for an otherwise identical peripheral
>> >   connected through a different HCD?
>>
>> I think this logic is also in place, for the most part. The DMA mask
>> from the HCD appears to be propagated into the USB device, and then
>> into the interface objects.
>
> Yeah, I recall thinking about that stuff way back when... intended to
> set that up correctly.  IT was at least partially tested.
>
>
>> For usb-storage, the SCSI layer
>> automatically sets the bounce limit based on the device passed into
>> it, so the right thing gets done. The networking layer seems like it
>> would need explicit handling in the drivers - I think basically a
>> check if the device interface's DMA mask was set to DMA_BIT_MASK(64)
>> and if so, set the HIGHDMA flag.
>
> Another example of how roundabout all that stuff is.  "64" being the
> relevant number, in contrast to something less.  So if for example the
> DMA address bus width is 48 bits, things will be strange.
>
> I wonder why the two layers don't adopt the same approach ... seemingly
> they're making different assumptions about driver behavior, suggesting
> that one of them may well be overly optimistic.

Hmm, it seems I was wrong about the usage of NETIF_F_HIGHDMA. I was
thinking it indicated 64-bit addressing support, but actually it just
indicates whether the driver can access highmem addresses and has
nothing to do with 64-bit at all. Essentially all network devices
should set that flag unless they can't access highmem, which would
only realistically happen if somebody was using PIO. (In this USB
networking case, it appears that would mean it should be set unless
the DMA mask for the device is set to NULL.) On configurations like
x86_64 where there's no highmem, it has no effect at all.

Unfortunately it appears that a lot of networking drivers' authors had
similar confusion and use it to indicate 64-bit DMA support, which
means the flag's not set in a lot of cases where it should be. Ugh..
think I'll start a new thread about that one.
