Return-Path: <linux-kernel-owner+w=401wt.eu-S1030879AbXDQQF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030879AbXDQQF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031115AbXDQQF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:05:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:58649 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030879AbXDQQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=odIF4hjuoAGbkshASnSVflIiTbIOs9yj6KBiO3fWvdlg4MGYEymx0N0GCMNDJhkv9nY2n+NAfAf9oqm5ChYfjgB1dWiVhROvUq5kDRLryvytlEXJNqghZJ2cZKxj4aTVNdhD9sRnngPUwRRaF4oc3lNYAc56ftWszcvSFDiW518=
Date: Tue, 17 Apr 2007 19:05:35 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <424488534.20070417190535@gmail.com>
To: David Brownell <david-b@pacbell.net>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
In-Reply-To: <200704151247.57724.david-b@pacbell.net>
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704102152.21287.david-b@pacbell.net> <1686019041.20070412165702@gmail.com> <200704151247.57724.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Sunday, April 15, 2007, 10:47:57 PM, you wrote:

> On Thursday 12 April 2007 6:57 am, Paul Sokolovsky wrote:
>> Wednesday, April 11, 2007, 7:52:20 AM, you wrote:

>> > So, talking about what an (optional) implementation framework might
>> > look like (and which could handle the SOC, FPGA, I2C, and MFD cases
>> > I've looked at):

> See patches in following messages ... a preliminary "gpio_chip" core
> for such a framework, plus example support for one SOC family's GPIOs,
> and then updating one board's handling of GPIOs, including over I2C.

        Just to compare, diffstats for GPIODEV:

Core API, 0 bytes of dedicated support code:

diffstat 0001-gpiodev-api.patch
 gpiodev.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

Adding GPIODEV for GPIOs without dedicated device (would be less if
there was struct device already):

diffstat 0002-gpiodev-for-pxa.patch
 generic.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)


        While it's understood that your code contains refactors,
extensive error checking, debugging support, etc. it's clear that
gpiolib.c has some weight to drop into kernel.


        But I'm a bit stumbled by that code. What's that? Is it just
example of implementation of your approach? Or is it code to go into
kernel? In this case, it needs work - it doesn't adhere to your own
optimization scheme by using lookup table instead of list.

        Or is it again example of what should be done by folks who
want to use extensible GPIO at all - specifically, hacking platform
header to plug there such framework?

        In the latter case, we again speak about different things, or
about different levels of such things - you speak about constructor
parts which "anyone" can use to construct whatever GPIO API they like,
whereas I'm speaking about exact API implementation which can be used
right away.

[]

> The fact that there are now three simple generic drivers (i2c-gpio,
> leds-gpio, gpio_keys) and various additional drivers using those same
> interfaces -- working already on multiple platforms! -- illustrates
> that anything more than a programming interface, with support on a
> handful of "seed" platforms, wasn't required initially.

        Well, besides gpio_keys we here have asic3_keys, samcop_keys,
etc. - all that duplication just because the current GPIO API doesn't
allow extensibility to more chips.

>>   Yes, and let that's something which can be entailed from your
>> approach: you argue that it's extensible interface, but kernel is
>> exactly not C++ classlib, there must be implementation.

> I said "implementation choice" not "extensible interface"; those
> are two very different approaches.

> You keep bringing C++ into this. 

        Sorry, how could I? I didn't post a single line of C++ code,
vice-versa, posted patches in plain C, which work for any
platform/architecture/etc. Words like "interface" are used only on
design stage. After that, there's just C code ready for calls. There's
no "one implementation strategy is", "another implementation strategy
is", etc.

> You may not know that doesn't win points in Linux.  

        Why, I believe I know local taboos and labels. ;-)

> If the point is solid, it doesn't need to
> rely on parallels to languages that won't be used in the kernel.
> (Plus, why would you imply C++ class libraries don't need to
> have implementations?)


>> And that 
>> implementation: a) will contain inline access for CPU SOC GPIO
>> controllers, just because "they are always there";

> Not what I said.  You said "will", I said "can"; there's a big
> difference.  Consider that for example the OMAP infrastructure
> for GPIOs already has a fair amount of indirection, while most
> other platforms started more simply ... some of them only
> included inlines, others just had simple accessor functions.

> My "can" allows all those; your "will" disallows most of them.

        Yes, in the same sense as some wheel-producing machine
disallows production of square and hexagon wheels.

        As I told, that was one of the reason I decided to submit
my patches as patches, not just RFC, and argue for them - there're
already bunch of square pegs in ARM Linux, and allowing only round
(or square) ones instead of both seems like refreshing change.

> And none of them unified that model with non-SOC GPIOs.

[]

>>   Yes, you argue that anyone who needs to extend Generic GPIO API to
>> their case can do that, and in such way that he won't lose single tick
>> comparing to using direct low-level methods. 

> Again, not what I said ... I've discouraged changing/extending the
> programming interface.  But I've certainly pointed out ways that
> existing performance expectations can be preserved without changing
> that programming interface.

        Ok, so this, IMHO, keeps to be the most valid point in favor
of continuing to use flat GPIO namespace. Challenging that would mean
to challenge original requirements for API, and that was done in
January, and I don't want to return to that.

[]

>> 2) Thankfully, we don't have gpio_chip yet. The temptation to clone
>> irq_chip, irq_desc, and stuff is high. So, what we talk here about is
>> not only how to implement extensible GPIO, but whether we finally can
>> break away from need to use in-kernel bureaucracies for handling each
>> and every (low-level) object.

> By "bureaucracy" I presume you mean the existence of opaque cookies?
> Or do you mean the implied resource tracking? 

        No, just requirement to do superflous operations, like, first
adding something to something, then storing what was added somewhere in
the table, just to substract it later then.
 
> (Remember that one of
> the most basic tasks of an operating system is resource management...)

        Yes, and simple resources can be even managed efficiently, as
GPIODEV API shows ;-).

[]

> So you're agreeing that, at a technical level, what I described
> could be augmented by a "caching" facility ... giving a programming
> interface with all the characteristics of your "GPIODEV" thingie.

> All you're really disagreeing with is bootstrapping issues; and
> whether there is in fact a need for such a layer.  The only argument
> I could possibly buy is that it avoids the lookup of (b) ... but
> that doesn't seem to matter in most cases I've looked at.

        So, yes, I disagree that using scalar identifiers is the most
efficient method. I however hardly can disagree that it's still a
suitable method. My other arguments are of wider scope than GPIO API
per se.

        One thing I obviously agree is that we need standard extensible
GPIO API, no matter what it is. And of course, you, as the API maintainer,
have better insight into this topic, and need to preserve its local
consistency (even if that, per my view, follows things which deserve
nomination of anti-patterns).

        So, now the most important question is what we all would get
with your approach in the end.

        So, if you could make sure gpiolib.c doesn't contain inefficient
implementation, and make such extensible implementation available by
default for ARM PXA/S3Cxxx/OMAP, then it's for sure cover Handhelds.org's,
and many other peoples' usecases, and that would be highly
appreciated.

        If you could do it for 2.6.22 merge window, that would
straight ideal.


[]

> Most of those don't get looked up in GPIO tables even once
> a week after the system boots ... the exceptions being the
> various LEDs, which obviously aren't performance-critical.
> IRQs go another path, and the various power controls don't
> change often after boot either.

        I would agree with this from pragmatical approach -
our usecase for handhelds.org is the same, we don't do
bitbanging on GPIOs. Other thing is when people would need
it, but ... - everything was said in that respect already.

> FWIW, GPIO 37 is ttyS0.RXD used to wake up from sleep,
> IRQ-164 is the touchscreen IRQ, and GPIO-6 is a busy signal
> from the touchscreen that's not actually used.  They don't
> yet use gpio_request(), which is why they're not labeled.


>> > Note that I'm giving you the benefit of the doubt in several respects
>> > there.  Your original (a) was quite bizarre, and your updated one isn't
>> > a lot better because it still needs odd conversions.
>> 
>>   Well, that's why I used macro initially - to assign some sense to
>> those low-level typecasts. You and other people told macros must get
>> lost, so they are, and I guess, it's unfair now to say that typecast
>> sores you eye - I tried to save everyone from that. But in the end,
>> it's C, not me, or GPIODEV. I can rewrite it in asm, and there won't
>> be typecasts. But we know why we don't write in asm ;-).

> The issue I was referring to was abuse of "void *" pointers when
> you should have been using typesafe ones. 

        My argument stays the same - it's C, so that's why it's
written that way. If that was Perl or Java, I would use hash to
convert from identifier to reference, but with C, it's optional.

>  And the association
> with devices was wierd too.

        Why? There's already abstraction of a device - struct
device. A device provides GPIO operations, so the operations are
attached to struct device. Otherwise, for how long there will be
parallel structure proliferation? Almost all devices are already
struct device, but some of them also require separately maintained
structure - irq_chip, gpio_chip, etc. Merging of classdev vs dev
structures and their trees is on TODO, but in the meantime we'll
spawn bunch more parallel structures...

> - Dave



-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

