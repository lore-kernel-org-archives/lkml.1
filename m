Return-Path: <linux-kernel-owner+w=401wt.eu-S1030799AbXDKEwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030799AbXDKEwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXDKEwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:52:25 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:38885 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030799AbXDKEwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:52:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2+Z97a0XWzxATBiNsl0g8SfwR8JN4/DwJFj6o/tXBdE5QJWWwjVmQgVhOV3cdRohFmPkRCV7f40koQLqD2TIMWhlkEI4Wa4FNpvxEMeun4EVunpGcmX3KCKW3vWKa05OMccVJtb7ZWnUzEiwsOBRkdXEKIfP3v2Sg2K0hwCX6iw=  ;
X-YMail-OSG: oOSOCeUVM1kaZoi_Wr61_jSlHAol6vzdEqbs2xas9RqmagZVRig0zjuZwlpD6_kOdWQ.3IIrAw--
From: David Brownell <david-b@pacbell.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
Date: Tue, 10 Apr 2007 21:52:20 -0700
User-Agent: KMail/1.7.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704091322.26360.david-b@pacbell.net> <357046193.20070411021107@gmail.com>
In-Reply-To: <357046193.20070411021107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704102152.21287.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007 4:11 pm, Paul Sokolovsky wrote:
> 
> >         /* defined by the platform using array, if/else/..., IDR, or whatever */
> >         struct gpio_yyy *gpio_to_yyy(unsigned gpio);
> 
>    I assume by "platform" you mean CPU architecture.

Nope.  ARM (v4, v5, v6, etc) is a CPU architecture.  "Platform" is
fuzzily defined but it's more than the CPU.  It's a "family" notion
that probably ties better to SOC chip vendor and branding ... things
work differently on TI OMAP processors than on Intel IOP ones, or than
the PXA ones (originally from Intel).  For many folk, "platform" is a
board-level notion ... like "x86_PC with ACPI firmware".


>  	 For example, say, ASIC3 appears in both PXA and S3Cxxx
> devices. Suppose driver which uses ASIC3 works well on PXA, but acts up
> on S3Cxxx.

The thing to do with bugs is fix them.  If S3C were to have a failure
at that level, there'd be a lot more failures than just that one.


>   		 So, let me
> continue this and ask: how GPIO handling relates to CPU architecture
> at all (and that's what I assume you mean by "platform")? The answer:
> it does not.

Certainly not ... and the interface doesn't.  Any more than IRQs do.
Implementations most certainly can be platform-specific.  And they
usually are, of necessity (different controllers, etc).


So, talking about what an (optional) implementation framework might
look like (and which could handle the SOC, FPGA, I2C, and MFD cases
I've looked at):

> > then you could do something like this (maybe passing "private" not "yyy"):
> 
> >         int gpio_get_value(unsigned gpio)
> >         {
> >                 struct gpio_yyy *yyy = gpio_to_yyy(gpio);
> 
> >                 return yyy->get(yyy, gpio - base);
> 
>                         ^^^ this subtraction makes me wonder what
> exactly it does here - anything useful, or ... ?

See the next lines:

> >                 /* where get(yyy, offset) might look like:
> >                  *      u32 mask = 1 << offset;
> >                  *      return mask & __raw_readl(yyy->private + GPIO_PIN_READ);
> >                  */

Each GPIO controller manages no more than a few pins at a time,
normally as many as fit into one register.


> >         }
> >                 
> []
> 
> > ... of course, those two might also be wrapped to understand that 
> > the first N gpios could become inlined accesses to the relevant
> > platform registers when "gpio" is constant ...
> 
>   Why first N could be inlined? What if I need second N inlined?
> Here, PXA GPIOs have really low-frequency stuff, while ASIC3 does
> bitbanging,

What's being bit-banged?  I2C isn't speed-critical.  SPI can be.

My opinion on the inlining is that the API should _allow_ that as
a source-compatible optimization, for cases where e.g. 1 Mbit/sec
isn't good enough but 2Mbit/sec is.  Luckily that optimization (to
make GPIO access into about three instructions, no subroutining, if
the particular GPIO is known at compile time) can be very easy.

GPIOs are a really light weight hardware mechanism, and should never
become fat'n'heavy.  Remember:  GPIO ~= Bit.  Keep it simple.

If a given implementation doesn't implement inline optimization,
some drivers may observe suckage but it probably won't matter for
most cases.  However, if an interface doesn't *ever* allow that
optimization, that's a sign of something wrong.


> so that's what should be inlined. And on system X, GPIO 
> chips #1, #3, #4, #7 needs to be inlined, while the rest could be not.

So you're arguing about what N is.  That's obviously an implementation
concern, nothing to do with any decent interface.

It happens to be especially easy to ensure that if some GPIO controllers
are always there (e.g. ones built into the platform, like the ones on a
PXA SOC) then you can inline access to them .. no abstraction functions
necessary.   And it's impractical to inline when you can't guarantee the
same controller is always there.  (Absent altinstr style patching ...
which level of effort is not justifiable here.)


>   So, why don't we handle this in following way: have two different
> levels of API: one which is concerned with inlinability (as noone
> disagrees this is important feature), and another - with generality
> and extensibility? That's why gpiodev API proposed to be on top of
> gpio API.

By analogy, irq_chip is not part of the driver API, so gpio_chip
doesn't need to be either.  All that's *necessary* in the API is
a single level.

If there's to be a gpio_chip, it can go neatly _below_ the public
interface.  I think you didn't notice that what I sketched closely
resembles the innards of most GPIO implementations in the kernel,
even those not yet supporting the gpio_*() interfaces...


>   In GPIO API, GPIO id's are integers, 4 bytes on 32bit platform,
> passed by value. In GPIODEV API, GPIO id's are fixed-size structures,
> 8 bytes, passed by reference, 4 bytes, so the same overhead.

No; for N GPIOs, it's the difference of N*8 additional bytes per
GPIO versus zero additonal bytes.  (It's fair to ignore costs of
the handles, since everyone pays that same cost.)

Note also that your stuff has been omitting large chunks of the
interface ... IRQ support, directionality, request/free, etc.

Handling an incoming GPIO IRQ (identified by an integer) involves
operations which are direct analogues of the ones you suggest are
too costly when applied to GPIOs not being viewed as IRQ sources.
That "costly" argument thus looks rather dubious to me ...


>   In GPIODEV API, to execute operation, you take one member of ID,
> treat that as structure, take pointer from it, and call function by
> that pointer, passing second member as is.
> 
>   With your approach above, you do lookups or even expensive linear
> searches just to get idea of what code should process the operation,
> then offset gpio id by some value before passing it to that code.

Let me rephrase that in a way I think clarifies things ... and adds
some of the context you've omitted:

 - What I sketched was (a) a "gpio controller" abstraction, plus
   mapping of GPIO numbers to (b) controller, e.g. "yyy[gpio >> 5]"
   and (c) controller-specific gpio index, e.g. "gpio & 0x1f";

   That's how people have managed GPIOs on Linux for many years now.
   It plays well with the very common use of GPIOs as IRQ sources.

   Usually the "gpio controller" is a register bank on a SOC, but as
   I've pointed out, that could be generalized through the classic
   "another level of indirection" technology (not patentable) at
   the cost of a new mandatory indirect function call.

 - What you sketched essentially says "let's save results (b) and (c)
   together in a structure and use that instead of GPIO numbers",
   with the mandatory indirect function call.  Also "let's define
   a new programming interface in terms of that struct".

   And you've not discussed the IRQ side of the equation, or
   the cansleep/irqsafe issues ... your example code built on
   top of code that uses the integer IDs.

Note that I'm giving you the benefit of the doubt in several respects
there.  Your original (a) was quite bizarre, and your updated one isn't
a lot better because it still needs odd conversions.


>   Sorry, but what's less expensive here?

In terms of data space required, clearly the scheme I described; it
doesn't need the 8*N bytes per GPIO.  In terms of instruction count,
they're comparable ... I think what I described clearly has an edge
because of all the conversions needed in yours, but that'll probably
clean up so it's not different enough to matter (given they both
need indirect function calls).  In terms of API churn, again the
scheme I described:  no new API needed by drivers, and things can
easily be made to match chip specs (which mostly use integers).


> > it's also a direct match to what the underlying code needs.
> 
>   Apparently just the opposite - GPIODEV's data structures have what
> the underlying code needs right away, while you need to do some magic
> on it.

See above.  The code implementing the GPIO controllers would more or
less be the same in both cases.  

> 
>   So, the code you propose goes to strange, and as was shown,
> superfluous things like first requiring adding some value to gpio#,
> then looping/looking up value to subtract from it, etc., etc. Why?

Because you're constructing a straw man, to make what I'm saying
look less like a codification of existing practice than it is.  :)
(Or so it seems to me.)


> There doesn't seem to be any technical reason for that. The reason it
> seems to be doing that is paradigmatic: to pretend that the world is
> flat, and that GPIO's stick not out of specific chips, but out of the
> whole system, all lined up in a row. 

Remember that IRQs do in fact "stick out of the whole system, all lined
up in a row".  And oddly enough, so must GPIOs used as IRQs...  Strange,
eh?  Go figure.

- Dave

