Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXDJXLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXDJXLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161044AbXDJXLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:11:03 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:10317 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161039AbXDJXK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=eAHgrlqiAkzy9HcYQodSfQzecqvl+glm1xqgRz5atB3Chd/1EIbTxxAdo9K9jLTJ1KecaxDMW+pDc/3urBzYvWtgifYps4vkXT2MusL80uRkAaC6VUJe7TQcEyZ2bytSo9rmcT5GazA7h3siiH8QtwV/6VfkbMck+uzye6fvAx8=
Date: Wed, 11 Apr 2007 02:11:07 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <357046193.20070411021107@gmail.com>
To: David Brownell <david-b@pacbell.net>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
In-Reply-To: <200704091322.26360.david-b@pacbell.net>
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704090822.03338.david-b@pacbell.net> <664892915.20070409201803@gmail.com> <200704091322.26360.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Monday, April 9, 2007, 11:22:25 PM, you wrote:

> On Monday 09 April 2007 10:18 am, Paul Sokolovsky wrote:

>> > Nobody who really wants to have such an implementation framework has yet
>> > ponied up and done the work to make one.
>> 
>>   Well, sorry if it wasn't made clear, but we (handhelds.org) made such
>> an implementation. It is in turn based on low-overhead and flexible
>> patterns of object-oriented virtual methods. It is presented here:
>> http://lkml.org/lkml/2007/3/27/63

> There's a lot of precedent for how to abstract methods in kernel code,
> and unfortunately that approach didn't follow *ANY* of it.  Get rid of
> the VTABLE() and METHOD() macros.  Stop thinking in C++ for kernel code!

  Fixed.


>> 1. Extended API header (uses "gpio_dev" (to be renamed to "gpiodev")
>> prefix instead of "gpio"; such API is intended to be used side by side
>> with your implementation, as the latter has important feature of
>> reducing to direct GPIo register access in case of constant GPIO#).
>> http://handhelds.org/cgi-bin/cvsweb.cgi/linux/kernel26/include/linux/gpio_dev.h?rev=1.2&content-type=text/x-cvsweb-markup

> VTABLE() and METHOD() ... you were already told no way to such
> "crappage".  That's makes reviewing the rest pointless...

  Fixed. Thanks for not stopping on the first parse error ;-)

> Now, translated to more traditional approaches, and looking
> more like I was first thinking about rather than the IDR-based
> thing in

>         http://lkml.org/lkml/2007/1/1/87

[]

>         /* defined by the platform using array, if/else/..., IDR, or whatever */
>         struct gpio_yyy *gpio_to_yyy(unsigned gpio);

   I assume by "platform" you mean CPU architecture. So, well... It
indeed must be very flexible, scalable, maintainable, and completely
not error-prone to let each platform reimplement wheel in its own
special way. For example, say, ASIC3 appears in both PXA and S3Cxxx
devices. Suppose driver which uses ASIC3 works well on PXA, but acts up
on S3Cxxx. Reason? Just because PXA uses "IDR" for its "gpio_to_yyy",
while S3Cxxx uses "whatever".

   But here's a point which made me to cleanup patches and resubmit
them again, and continue this discussion (because I really don't feel
like fighting against the tide) - I read "Re: Any possible to split
the pxa-regs.h?" thread, and see some fresh trend in it. So, let me
continue this and ask: how GPIO handling relates to CPU architecture
at all (and that's what I assume you mean by "platform")? The answer:
it does not.

   We for long time took for granted that the whole system world spins
around plastic package with label "CPU". Apparently, that's wrong, it
spins only around the CPU core which happens to be in that plastic.
Anything else in that plastic is just that - external devices. So sorry,
why do we need to define external device access in terms of what CPU
controls them? Maybe it makes sense to define that access just in the same
way as for any other external device - using a driver and a framework
a driver should follow? (And yes, plain vanilla LDM is not enough here,
a minuscule extension needs to be applied.)

> then you could do something like this (maybe passing "private" not "yyy"):

>         int gpio_get_value(unsigned gpio)
>         {
>                 struct gpio_yyy *yyy = gpio_to_yyy(gpio);

>                 return yyy->get(yyy, gpio - base);

                        ^^^ this subtraction makes me wonder what
exactly it does here - anything useful, or ... ?

>                 /* where get(yyy, offset) might look like:
>                  *      u32 mask = 1 << offset;
>                  *      return mask & __raw_readl(yyy->private + GPIO_PIN_READ);
>                  */
>         }
>                 
[]

> ... of course, those two might also be wrapped to understand that 
> the first N gpios could become inlined accesses to the relevant
> platform registers when "gpio" is constant ...

  Why first N could be inlined? What if I need second N inlined?
Here, PXA GPIOs have really low-frequency stuff, while ASIC3 does
bitbanging, so that's what should be inlined. And on system X, GPIO
chips #1, #3, #4, #7 needs to be inlined, while the rest could be not.

  So, why don't we handle this in following way: have two different
levels of API: one which is concerned with inlinability (as noone
disagrees this is important feature), and another - with generality
and extensibility? That's why gpiodev API proposed to be on top of
gpio API.


[]

> Fair enough?  You were making a few other implementation choices
> too,

  Yes, that's true. There're always some choices and compromises
among different requirements, but I and other handhelds.org developers
argue that the proposed "gpiodev" is more scalable.

> especially for the "gpiodev" thingies which I dropped here
> in the interest of having exactly ONE struct gpio_yyy per controller,
> instead of one per GPIO,

  This is not correct presentation. Comparing your per-contoller
struct's with my per-gpio structs are comparing apples and oranges.
GPIODEV just uses structured id's instead of scalar, that's all.
And they have it because that allows to automagically solve many
issues your approach outlined above solves "manually".

> since that's not only less expensive but

  In GPIO API, GPIO id's are integers, 4 bytes on 32bit platform,
passed by value. In GPIODEV API, GPIO id's are fixed-size structures,
8 bytes, passed by reference, 4 bytes, so the same overhead.

  In GPIODEV API, to execute operation, you take one member of ID,
treat that as structure, take pointer from it, and call function by
that pointer, passing second member as is.

  With your approach above, you do lookups or even expensive linear
searches just to get idea of what code should process the operation,
then offset gpio id by some value before passing it to that code.

  Sorry, but what's less expensive here?

> it's also a direct match to what the underlying code needs.

  Apparently just the opposite - GPIODEV's data structures have what
the underlying code needs right away, while you need to do some magic
on it.


  So, the code you propose goes to strange, and as was shown,
superfluous things like first requiring adding some value to gpio#,
then looping/looking up value to subtract from it, etc., etc. Why?
There doesn't seem to be any technical reason for that. The reason it
seems to be doing that is paradigmatic: to pretend that the world is
flat, and that GPIO's stick not out of specific chips, but out of the
whole system, all lined up in a row. Proposal: let's leave such outlook
behind, accept that world is 3D, and have bunch of problems solved for
us automagically (and what's not less important, such new outlook can
be reused for few other problems too).


>> 4. Example of a driver taking advantage of gpiodev API: simple shim to
>> extend pxa2xx_udc driver to arbitrary GPIOs (not only those builtin to
>> PXA):
>> http://handhelds.org/cgi-bin/cvsweb.cgi/linux/kernel26/drivers/usb/gadget/pxa2xx_udc_gpio.c?rev=1.1&content-type=text/x-cvsweb-markup&f=h
>> (note that it makes use of simple superstructure on top of gpiodev API,
>> and abstraction of power-controlling GPIO:
>> http://handhelds.org/cgi-bin/cvsweb.cgi/linux/kernel26/include/linux/dpm.h?rev=1.3&content-type=text/x-cvsweb-markup&f=h
>> )

> But there are already patches in the queue to update that UDC to use the
> generic GPIO interface ...

  Wonderful. It only means that patches for generic GPIODEV interface
can be done a bit later ;-).

> the delay merging the asm-arm/arch-ixp4xx code
> seems to be the main holdup.  At this point I don't much want to muddy
> those waters any furher, it's taken long enough to integrate the ixp4xx
> fixes.  (And if I'm getting impatient, I hate to think about what Milan
> must be feeling!)

  I of course have no intention to delay already existing patches, or
anything. I'd be glad if there was any runtime-extensible GPIO API at
all. I just happen to get a feeling that there can be gained momentum
to resolve some issues of ARM Linux (and few of Linux at all), so just
hope that discussion and proposed implementation can be found useful.

> - Dave



-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

