Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbYEUKuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbYEUKuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbYEUKuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:50:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:52553 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYEUKug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MALO/QCpa0jaCYg/VuuyKaZASh2ykH/UIN/yXp5NAuY6YVRw3Szr5p6fBuzVj//xJQDQghvSvxiAKFxoi8guqc1CPBwruMBMFpV/Gey0IfOAPo6ET/rhhYZS4OTaMMoBN4f3VHSfqS8AYfvIsz76IZZZZnm7N9aVL0NvrDB2+0g=
Message-ID: <aec7e5c30805210350l41b537c3n70cfef2e10b54548@mail.gmail.com>
Date: Wed, 21 May 2008 19:50:29 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, gregkh@suse.de, linux-sh@vger.kernel.org
In-Reply-To: <20080521092533.GB29607@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
	 <20080520210713.GE3220@local>
	 <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com>
	 <20080521064938.GA11580@digi.com>
	 <aec7e5c30805210109p664fd917r32f8dc6aa1c4c746@mail.gmail.com>
	 <20080521092533.GB29607@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 6:25 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> Magnus Damm wrote:
>> On Wed, May 21, 2008 at 3:49 PM, Uwe Kleine-König
>> > What about adding uio_platform_handler (with a different name) to
>> > uio_pdrv.c?
>>
>> I'm not sure if it will help. What would such function do? Please explain.
> Just add irq_disabled to struct uio_platdata and define
>
>        irqreturn_t uio_pdrv_disirq(int irq, struct uio_info *dev_info)
>        {
>                struct uio_platdata *pdata = container_of(dev_info, struct uio_platdata, uio_info);
>
>                disable_irq(irq);
>                pdata->irq_disabled = 1;
>                return IRQ_HANDLED;
>        }
>        EXPORT_SYMBOL(uio_pdrv_disirq);
>
>        void uio_pdrv_enirq(struct uio_info *dev_info)
>        {
>                ...
>        }
>        EXPORT_SYMBOL(uio_pdrv_enirq);
>
> and then you can do
>
>        info->handler = uio_pdrv_disirq;
>        info->enable_irq = uio_pdrv_enirq;
>
> in the arch specific code.  I just realize that you need to compile UIO
> statically then :-(

I understand now. Thanks for the clear description.

What about letting the uio_pdrv code override info->handler and
info->enable_irq with the above functions if info->handler is NULL?
That would be one step closer to a shared driver in my opinion. And it
would remove the need for symbol exports and solve the
static-compile-only issue.

The physically contiguous memory issue still needs to be solved
somehow though. What about using struct resouce flagged as
IORESOURCE_DMA to pass the amount of memory that should be allocated?

> IMHO something like prep_read_poll is a better name than enable_irq for
> the new member of uio_info.

That's fine.

>> > OTOH I don't see why you want to disable the irq.  Can you describe the
>> > reason?
>>
>> Most UIO kernel drivers today contain hardware device specific code to
>> acknowledge interrupts. In other words, most UIO interrupt handlers
>> touches some device specific bits so the interrupt gets deasserted.
>>
>> My uio_platform driver handles interrupts in a different way. The
>> kernel UIO driver is not aware of the hardware device specific method
>> to acknowledge the interrupt, instead it simply disables the interrupt
>> and notifies user space which instead will acknowledge the interrupt.
>> Next time a read() or poll() call gets made, the interrupt is enabled
>> again.
>>
>> This allows us to export a hardware device to user space and allow
>> user space to handle interrupts without knowing in kernel space how to
>> acknowledge interrupts.
> OK, got it.  The down-side is that you can only get a single interrupt
> between two calls to read() (or poll()).  So you might or might not
> loose information.  And you might run into problems if your device or
> your interrupt goes berserk as your handler always returns IRQ_HANDLED.
> With a functional handler you can rely on existing mechanisms in the
> kernel.

I agree that I only get a single interrupt, but I'm not agreeing
regarding the problems. =)

In my mind, disabling interrupts and acking them from user space only
leads to increased interrupt latencies. People may dislike increased
interrupt latencies, but if so they shouldn't have their driver in
user space. And you may of course choose to ack interrupts in kernel
space and queue information there which user space later reads out.
But that sounds more like a specialized kernel driver. And that is not
what i'm trying to do.

Regarding loosing information, if your hardware device can't cope with
long latencies and drops things on the floor then improve your
latency, increase buffer size or design better hardware. Also, I don't
think the interrupt can go berserk since it will be disabled directly
by the interrupt handler.

>> >> To be frank, I have my doubts in adding an extra forwarding-only
>> >> platform layer on top of UIO compared to using uio_register_device()
>> >> directly from the board code. I like that the platform layer is using
>> >> struct resource and handles resource ranges for us automatically, but
>> >> wouldn't it make more sense to extend the UIO core to always use
>> >> struct resource instead of struct uio_mem? I'd be happy to help out -
>> >> just point me in the right direction.
>> > That alone doesn't help.  You need a struct device to register a uio
>> > device.  So a platform device is the straight forward approach.
>>
>> I don't mind that you are using platform devices. Actually, I think
>> platform devices are great. We use them for all sorts of things on the
>> SuperH architecture. I'm trying to suggest that maybe it's a good idea
>> to change the UIO core code to use struct resource instead of struct
>> uio_mem. Or maybe that's not a good idea, I'm not sure.
> struct resource alone doesn't provide enough information.  At least
> memtype is needed.  And you don't need the pointers *parent, *sibling,
> *child, so in my eyes it's fine to have a dedicated structure for uio.

Maybe the flags member of struct resource together with IORESOURCE_xxx
can be used instead of memtype. But there is no point in changing
things just for the sake of it, so it is fine as-is in my opinion.

Thank you!

/ magnus
