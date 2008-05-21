Return-Path: <linux-kernel-owner+w=401wt.eu-S934999AbYEUIKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934999AbYEUIKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762595AbYEUIKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:10:02 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:5912 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761485AbYEUIJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fhJ/tLGFRtwAvz57c5whwmed47XbtXha8Leb5Bi/FXrsG0RsXPN6DVoInOPHHuL+y54LbpH2Vk8IOsJqcV/ZCRBHwcHyVurRTLiHeIC9otxjFOjVAxZiepCLmsiHUxjB0HP4zsMIjdvQGwgJW6/rsnAkOf1jS+PIePzxMNslaPA=
Message-ID: <aec7e5c30805210109p664fd917r32f8dc6aa1c4c746@mail.gmail.com>
Date: Wed, 21 May 2008 17:09:51 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, gregkh@suse.de, linux-sh@vger.kernel.org
In-Reply-To: <20080521064938.GA11580@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
	 <20080520210713.GE3220@local>
	 <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com>
	 <20080521064938.GA11580@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe!

Thanks for your email.

On Wed, May 21, 2008 at 3:49 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> Magnus Damm wrote:
>> The uio_pdrv driver doesn't do what I need at this point, though I may
>> be able to extend it with the following:
>> - Interrupt enable/disable code
>> - Physically contiguous memory support
>>
>> The interrupt code may be placed in the board/cpu code, but I need to
>> share that code between multiple UIO driver instances. We want to use
>> the same UIO driver for many different processor models and hardware
>> blocks.
> What about adding uio_platform_handler (with a different name) to
> uio_pdrv.c?

I'm not sure if it will help. What would such function do? Please explain.

> OTOH I don't see why you want to disable the irq.  Can you describe the
> reason?

Most UIO kernel drivers today contain hardware device specific code to
acknowledge interrupts. In other words, most UIO interrupt handlers
touches some device specific bits so the interrupt gets deasserted.

My uio_platform driver handles interrupts in a different way. The
kernel UIO driver is not aware of the hardware device specific method
to acknowledge the interrupt, instead it simply disables the interrupt
and notifies user space which instead will acknowledge the interrupt.
Next time a read() or poll() call gets made, the interrupt is enabled
again.

This allows us to export a hardware device to user space and allow
user space to handle interrupts without knowing in kernel space how to
acknowledge interrupts.

>>         Extending uio_pdrv driver with a chunk of physically
>> contiguous memory isn't a big deal though.
> I wonder how you use that memory.  Isn't it just some kind of shared
> memory?  If so, why not use normal shared memory?  Do you really need
> that?

Yes, I need that to give the exported hardware device some physically
contiguous memory for DMA. At this point our hardware is missing IOMMU
so physically contiguous memory is needed.

>> To be frank, I have my doubts in adding an extra forwarding-only
>> platform layer on top of UIO compared to using uio_register_device()
>> directly from the board code. I like that the platform layer is using
>> struct resource and handles resource ranges for us automatically, but
>> wouldn't it make more sense to extend the UIO core to always use
>> struct resource instead of struct uio_mem? I'd be happy to help out -
>> just point me in the right direction.
> That alone doesn't help.  You need a struct device to register a uio
> device.  So a platform device is the straight forward approach.

I don't mind that you are using platform devices. Actually, I think
platform devices are great. We use them for all sorts of things on the
SuperH architecture. I'm trying to suggest that maybe it's a good idea
to change the UIO core code to use struct resource instead of struct
uio_mem. Or maybe that's not a good idea, I'm not sure.

>> >> The interrupt handling code in uio_platform assumes the device is the
>> >> only user of the assigned interrupt.
>> >
>> > Uwe's approach doesn't have this limitation.
>>
>> True, but the uio_pdrv driver is choosing to not deal with interrupts
>> at all. I'd like to have shared interrupt handling code. With my
>> driver, you just feed it io memory window parameters and an interrupt
>> number and off you go. No need for any callbacks.
> In my eyes this isn't completly correct.  Just the way you specify your
> handler is a bit different.  You can pass a handler via platform data
> with my driver, too.

I don't want to pass any handler. All devices share the same interrupt
handler, the only thing that differs between multiple uio_platform
devices on one system is memory window information and irq number.

> BTW, you don't need "depends on UIO" (because it's in a if UIO/endif
> block) and "default n" (as this is the default anyhow).  See also
> http://thread.gmane.org/gmane.linux.kernel/663884/focus=683097

Ah, thanks for pointing that out!

Thank you for your feedback!

/ magnus
