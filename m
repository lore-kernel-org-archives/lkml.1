Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbYEUDcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbYEUDcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbYEUDcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:32:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:49411 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbYEUDcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YxCD58ScRY8bFLRJKG65wgJDJE/4tvAmeUJTwU4dHAtLWLR+KZeC69B/HEqAfdCKgALyidjel3TJz2WZ1Zr603olJ88n5soLZdc0K0KNU+HHQbfaFYGu7m59nwaapgA7FJsa7aOT3Hu6+V2mu5w/vyYuZDzCvZl62GFGnegGqp4=
Message-ID: <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com>
Date: Wed, 21 May 2008 12:31:59 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, gregkh@suse.de,
       linux-sh@vger.kernel.org, Uwe.Kleine-Koenig@digi.com
In-Reply-To: <20080520210713.GE3220@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
	 <20080520210713.GE3220@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans!

On Wed, May 21, 2008 at 6:07 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Tue, May 20, 2008 at 07:51:32PM +0900, Magnus Damm wrote:
>> These patches implement a reusable UIO platform driver.
>
> Uwe Kleine-Koenig already submitted such a framework:
>
> http://lkml.org/lkml/2008/5/20/94
>
> It's his third version, and it looks good. I presume you didn't know
> about his work. The main difference is that he leaves interrupt handling
> to platform code. That might look strange (it did to me first), but it
> has the advantage that you can put hardware dependent stuff in your
> board support (which depends on hardware anyway).

I was not aware of this driver, thanks for the pointer!

> Could you have a look at his patch and tell me if that does what you
> need?

The uio_pdrv driver doesn't do what I need at this point, though I may
be able to extend it with the following:
- Interrupt enable/disable code
- Physically contiguous memory support

The interrupt code may be placed in the board/cpu code, but I need to
share that code between multiple UIO driver instances. We want to use
the same UIO driver for many different processor models and hardware
blocks. Extending uio_pdrv driver with a chunk of physically
contiguous memory isn't a big deal though.

To be frank, I have my doubts in adding an extra forwarding-only
platform layer on top of UIO compared to using uio_register_device()
directly from the board code. I like that the platform layer is using
struct resource and handles resource ranges for us automatically, but
wouldn't it make more sense to extend the UIO core to always use
struct resource instead of struct uio_mem? I'd be happy to help out -
just point me in the right direction.

>> The interrupt handling code in uio_platform assumes the device is the
>> only user of the assigned interrupt.
>
> Uwe's approach doesn't have this limitation.

True, but the uio_pdrv driver is choosing to not deal with interrupts
at all. I'd like to have shared interrupt handling code. With my
driver, you just feed it io memory window parameters and an interrupt
number and off you go. No need for any callbacks.

>> If anyone is interested then I have a proof of concept vidix driver
>> for mplayer that is interfacing using UIO to the VEU on a sh7722 to
>> provide accelerated color space conversion and stretching.
>
> This sounds quite interesting. Unfortunately, I'm not familiar with the
> SuperH architecture. Could you also do this with Uwe's approach?

I could handle things by extending Uwe's uio_pdrv driver, but I still
need the enable_irq() callback. I wonder if it makes sense to let the
two drivers coexist side by side, since they are solving different
problems. I can rename my driver to uio_pdrv_unique_irq or something,
or maybe uio_superh.c. I dislike the latter since my driver doesn't do
anything SuperH specific and that I suspect it can be useful for other
architectures as well.

> I'm about to sign-off Uwe's patch, and we'll possibly have that in
> mainline soon. I don't mind having a second "generic platform" driver,
> but you'll need to have good technical arguments.

I'd like to have this driver upstream as well, and sharing the code
with the uio_pdrv driver is one way, but I suspect that adding another
reusable layer on top of that driver will just complicate things. The
uio-specific part of my patches is less than 200 lines of code. From
the top of my head I can think of at least 10 different SuperH
hardware devices that can reuse this driver.

Please let me know what you prefer and I'll update the code and repost.

Thanks for your help!

/ magnus
