Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbXDLN47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbXDLN47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXDLN47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:56:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:3117 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbXDLN45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=peEJoMGgyoJxN/pglwnOqhPfzHzy10CfkHvyuKeS1PKDIi8yTqLz1vSPETKJN8PWmVMtbgbosxBrtoF3iNi3rKpcBAbhFb9inSEF9JwJtJmNgxqzmO5sPR1iPPGbf6+QWMSg9aL+dpLSwGjUWP85DdKMoulOx3PnNUOTTv8fcQc=
Date: Thu, 12 Apr 2007 16:57:02 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1686019041.20070412165702@gmail.com>
To: David Brownell <david-b@pacbell.net>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
In-Reply-To: <200704102152.21287.david-b@pacbell.net>
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704091322.26360.david-b@pacbell.net> <357046193.20070411021107@gmail.com> <200704102152.21287.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Wednesday, April 11, 2007, 7:52:20 AM, you wrote:

> On Tuesday 10 April 2007 4:11 pm, Paul Sokolovsky wrote:
>> 
>> >         /* defined by the platform using array, if/else/..., IDR, or whatever */
>> >         struct gpio_yyy *gpio_to_yyy(unsigned gpio);
>> 
>>    I assume by "platform" you mean CPU architecture.

> Nope.  ARM (v4, v5, v6, etc) is a CPU architecture.  "Platform" is
> fuzzily defined but it's more than the CPU.  It's a "family" notion
> that probably ties better to SOC chip vendor and branding ... things
> work differently on TI OMAP processors than on Intel IOP ones, or than
> the PXA ones (originally from Intel).  For many folk, "platform" is a
> board-level notion ... like "x86_PC with ACPI firmware".


>>        For example, say, ASIC3 appears in both PXA and S3Cxxx
>> devices. Suppose driver which uses ASIC3 works well on PXA, but acts up
>> on S3Cxxx.

> The thing to do with bugs is fix them.  If S3C were to have a failure
> at that level, there'd be a lot more failures than just that one.

  Programmers fix bugs. System designers make systems without
inclination to have bugs at random places. So, let's try to do the
former ;-) (in the sense, let's try to make a framework which will be
devoid of possibility for such variations; note that this doesn't mean
that framework which allows them, but has other benefits, is *not*
outruled by this).

>>                So, let me
>> continue this and ask: how GPIO handling relates to CPU architecture
>> at all (and that's what I assume you mean by "platform")? The answer:
>> it does not.

> Certainly not ... and the interface doesn't.  Any more than IRQs do.
> Implementations most certainly can be platform-specific.  And they
> usually are, of necessity (different controllers, etc).


> So, talking about what an (optional) implementation framework might
> look like (and which could handle the SOC, FPGA, I2C, and MFD cases
> I've looked at):

>> > then you could do something like this (maybe passing "private" not "yyy"):
>> 
>> >         int gpio_get_value(unsigned gpio)
>> >         {
>> >                 struct gpio_yyy *yyy = gpio_to_yyy(gpio);
>> 
>> >                 return yyy->get(yyy, gpio - base);
>> 
>>                         ^^^ this subtraction makes me wonder what
>> exactly it does here - anything useful, or ... ?

> See the next lines:

>> >                 /* where get(yyy, offset) might look like:
>> >                  *      u32 mask = 1 << offset;
>> >                  *      return mask & __raw_readl(yyy->private + GPIO_PIN_READ);
>> >                  */

> Each GPIO controller manages no more than a few pins at a time,
> normally as many as fit into one register.

  Thanks for describing this once again. But I really looked into your
January's code and this code already. And I fully agree that this will
work! And your code could have been long ago in git, but is not, so I
assume that your January's code was an RFC, asking what people think,
and if there're any alternatives. So, we here present exactly an
alternative, and it has its technical merits, I hope it's visible.


>> >         }
>> >                 
>> []
>> 
>> > ... of course, those two might also be wrapped to understand that 
>> > the first N gpios could become inlined accesses to the relevant
>> > platform registers when "gpio" is constant ...
>> 
>>   Why first N could be inlined? What if I need second N inlined?
>> Here, PXA GPIOs have really low-frequency stuff, while ASIC3 does
>> bitbanging,

> What's being bit-banged?  I2C isn't speed-critical.  SPI can be.

  Well, not me started to spoke about bit-banging. It's obviously just
one of usecases for GPIO API.

> My opinion on the inlining is that the API should _allow_ that as
> a source-compatible optimization, for cases where e.g. 1 Mbit/sec
> isn't good enough but 2Mbit/sec is.

  Exactly! For runtime-extensible GPIO API, speed is apparently not
top-level goal, as - well, extensibility is. But if can shave few
cycles off by ditching table lookups and subtraction, let's do that.
For someone, being able to bit-bang on 1.2MHz instead of 1MHz can be
real life-saver.

> Luckily that optimization (to
> make GPIO access into about three instructions, no subroutining, if
> the particular GPIO is known at compile time) can be very easy.

> GPIOs are a really light weight hardware mechanism, and should never
> become fat'n'heavy.  Remember:  GPIO ~= Bit.  Keep it simple.

> If a given implementation doesn't implement inline optimization,
> some drivers may observe suckage but it probably won't matter for
> most cases.  However, if an interface doesn't *ever* allow that
> optimization, that's a sign of something wrong.

  Also fully agree with these passages! But let's exactly keep it
simple and untangled. If your API motivates people to do adhoc
optimizations (by creating per-platform header-file based
inline implementations for example), let's keep it that way, clean and
nice, and don't try to mix it with *runtime* extensibility. As was
pointed out, these two requirement are opposite to some extent, and
trying to merry them can just lead to mess.

>> so that's what should be inlined. And on system X, GPIO 
>> chips #1, #3, #4, #7 needs to be inlined, while the rest could be not.

> So you're arguing about what N is.  That's obviously an implementation
> concern, nothing to do with any decent interface.

  Yeah! We've been talking about implementation for quite some time
now ;-). And my point in writing the above was that it's not going to be
too easy and clean to stuff all the requirements into one implementation.

  That's why, again, GPIODEV does *not* try to supercede Generic GPIO
API, but instead extends (on the meta-interface level, i.e. method
signature change (but in consistent manner), but semantics stays).

> It happens to be especially easy to ensure that if some GPIO controllers
> are always there (e.g. ones built into the platform, like the ones on a
> PXA SOC) then you can inline access to them .. no abstraction functions
> necessary.   And it's impractical to inline when you can't guarantee the
> same controller is always there.  (Absent altinstr style patching ...
> which level of effort is not justifiable here.)

  Yes, and let that's something which can be entailed from your
approach: you argue that it's extensible interface, but kernel is
exactly not C++ classlib, there must be implementation. And that
implementation: a) will contain inline access for CPU SOC GPIO
controllers, just because "they are always there"; b) will not contain
anything else, just because "it's not always there". That's exactly
what implementation will go into 2.6.21.

  Yes, you argue that anyone who needs to extend Generic GPIO API to
their case can do that, and in such way that he won't lose single tick
comparing to using direct low-level methods. That's trait is *much*
appreciated. Actually, so much, that I don't even try to mess up
beauty of it by stuffing implementation for other requirement right
into it.

  But let's face it - most people will not hack mainline-provided
inlinable headers to add efficient handling for their boards'
additional GPIO, or create a new platform, to do that right. Many
people just need to plug in their adhoc GPIOs into system in such way
that it will be used by a generic driver. And they don't want to hack
sacred kernel headers for that. They are not caught by phrases "you
can do it this way, or you can do it that way - just bother to do it".
They need single, and not needlessly inefficient API to register their
GPIO chips at runtime and have them run right away, without thinking
how to snatch extra CPU cycle by constant optimization.

  So, we here think how to give them such ability, and yet not burden
the people with extra cycles than needed (even if those are few
cycles).


>>   So, why don't we handle this in following way: have two different
>> levels of API: one which is concerned with inlinability (as noone
>> disagrees this is important feature), and another - with generality
>> and extensibility? That's why gpiodev API proposed to be on top of
>> gpio API.

> By analogy, irq_chip is not part of the driver API, so gpio_chip
> doesn't need to be either.

  Wonderful. 2 things out of this however:

1) Just consider someone submits non irq_chip implementation of
multiplexed IRQ handling. I bet you will be first to teach one to
stop disfollowing patterns ;-). But we obviously know that few
people will bother anyway - irq_chip *is* implementation pattern,
and it makes no sense to not follow it.

2) Thankfully, we don't have gpio_chip yet. The temptation to clone
irq_chip, irq_desc, and stuff is high. So, what we talk here about is
not only how to implement extensible GPIO, but whether we finally can
break away from need to use in-kernel bureaucracies for handling each
and every (low-level) object. Proposed GPIODEV implementation shows
that it's possible. You say that irq_chip is not part of driver
interface. GPIODEV doesn't have gpio_chip/gpio_desc even as part
of the implementation!


>   All that's *necessary* in the API is
> a single level.

> If there's to be a gpio_chip, it can go neatly _below_ the public
> interface.  I think you didn't notice that what I sketched closely
> resembles the innards of most GPIO implementations in the kernel,
> even those not yet supporting the gpio_*() interfaces...

  Taking into account that GPIO is terribly simple thing, no wonder
all implementations are similar. What we lack is exactly common
interfaces. As argued, apparently, interfaces of different levels,
serving different requirements.


>>   In GPIO API, GPIO id's are integers, 4 bytes on 32bit platform,
>> passed by value. In GPIODEV API, GPIO id's are fixed-size structures,
>> 8 bytes, passed by reference, 4 bytes, so the same overhead.

> No; for N GPIOs, it's the difference of N*8 additional bytes per
> GPIO versus zero additonal bytes.  (It's fair to ignore costs of
> the handles, since everyone pays that same cost.)

  Well, that's well-known time vs space tradeoff. And yes,
for GPIODEV, after the first requirement of runtime-extensibility,
the second requirement is speed.

> Note also that your stuff has been omitting large chunks of the
> interface ... IRQ support, directionality, request/free, etc.

  IRQ suport is there - "to_irq" method. Also, as GPIODEV is
implemented via pattern/meta-API (virtual methods), and new operation
can be added easily and cleanly, to be handled only for those devices,
which need it.

> Handling an incoming GPIO IRQ (identified by an integer) involves
> operations which are direct analogues of the ones you suggest are
> too costly when applied to GPIOs not being viewed as IRQ sources.
> That "costly" argument thus looks rather dubious to me ...

  I propose GPIO implementation here. IRQs are a bit different things,
after all. I don't touch their implementation here. But argument "IRQs
do extra operations, so let's do the same for GPIOs" is rather dubious
either.


>>   In GPIODEV API, to execute operation, you take one member of ID,
>> treat that as structure, take pointer from it, and call function by
>> that pointer, passing second member as is.
>> 
>>   With your approach above, you do lookups or even expensive linear
>> searches just to get idea of what code should process the operation,
>> then offset gpio id by some value before passing it to that code.

> Let me rephrase that in a way I think clarifies things ... and adds
> some of the context you've omitted:

>  - What I sketched was (a) a "gpio controller" abstraction, plus
>    mapping of GPIO numbers to (b) controller, e.g. "yyy[gpio >> 5]"
>    and (c) controller-specific gpio index, e.g. "gpio & 0x1f";

>    That's how people have managed GPIOs on Linux for many years now.
>    It plays well with the very common use of GPIOs as IRQ sources.

>    Usually the "gpio controller" is a register bank on a SOC, but as
>    I've pointed out, that could be generalized through the classic
>    "another level of indirection" technology (not patentable) at
>    the cost of a new mandatory indirect function call.

>  - What you sketched essentially says "let's save results (b) and (c)
>    together in a structure and use that instead of GPIO numbers",
>    with the mandatory indirect function call.

     Yes. Except not "save", but use from the beginning, as "master"
identifiers.

>  Also "let's define
>    a new programming interface in terms of that struct".

     As was pointed already, nothing new in Linux kernel. Method
tables in the form of *_ops structures are used since the beginning of
times. It's just my IMHO, that they underused to solve some kind of
problems, so I make noise about that, but it's all mundane under the
hood.

>    And you've not discussed the IRQ side of the equation,

     There's an to_irq() method which accepts GPIO identifier in GPIO
namespace (struct gpio) and returns IRQ identifier in IRQ namespace
(integer). What can be more easy?

>  or
>    the cansleep/irqsafe issues ...

     If they are handled in your implementation, they can be handled
in GPIODEV too. They can be either fully delegated to GPIO device
drivers (i.e. there're gpiodev_*_cansleep() which just call method in
gpiodev_ops directly, or if you insist that there's some commonality,
gpiodev_*_cansleep() can do something themselves).

> your example code built on
>    top of code that uses the integer IDs.

> Note that I'm giving you the benefit of the doubt in several respects
> there.  Your original (a) was quite bizarre, and your updated one isn't
> a lot better because it still needs odd conversions.

  Well, that's why I used macro initially - to assign some sense to
those low-level typecasts. You and other people told macros must get
lost, so they are, and I guess, it's unfair now to say that typecast
sores you eye - I tried to save everyone from that. But in the end,
it's C, not me, or GPIODEV. I can rewrite it in asm, and there won't
be typecasts. But we know why we don't write in asm ;-).


>>   Sorry, but what's less expensive here?

> In terms of data space required, clearly the scheme I described; it
> doesn't need the 8*N bytes per GPIO.

  Well, but it needs some external table. Unless you want to burden
clients with management of that table, it needs to be allocated
conservatively big enough. Then, on typical not GPIO-abound system it
will be sparse, and large part of what you win in shorted GPIO ids
will be lost in this sparsity.

> In terms of instruction count,
> they're comparable ... I think what I described clearly has an edge
> because of all the conversions needed in yours, but that'll probably
> clean up so it's not different enough to matter

  Not probably, but sure - there's no machine code behind casting
pointer of one type to another type (oh, I just expect examples of
braindead archs for which this is not true ;-) ).

  Also, let me take a pun on "conversion" - so, both your and my
approach needs conversion, mine just uses static typecast, and yours
employs the whole lookup table for that ;-).

> (given they both
> need indirect function calls).  In terms of API churn, again the
> scheme I described:  no new API needed by drivers,

  That's why I prefer term "API level". GPIODEV introduces only new
level of API, not the whole new API. Users will choose level to use
based on requirements. For example, truly generic drivers will use
GPIODEV level, platform-specific drivers will use GPIO level, and
finally, drivers which have some critical requirements, will still use
"API of zeroth level", i.e. direct access to platform registers.

>  and things can
> easily be made to match chip specs (which mostly use integers).

  Let's don't warp reality here ;-). GPIODEV *does* use integers for
GPIO numbers. It just doesn't try to pretend that next spec continues
numbering where previous spec left ;-).


>> > it's also a direct match to what the underlying code needs.
>> 
>>   Apparently just the opposite - GPIODEV's data structures have what
>> the underlying code needs right away, while you need to do some magic
>> on it.

> See above.  The code implementing the GPIO controllers would more or
> less be the same in both cases.

  Yes! The difference is how client calls GPIO methods.

>> 
>>   So, the code you propose goes to strange, and as was shown,
>> superfluous things like first requiring adding some value to gpio#,
>> then looping/looking up value to subtract from it, etc., etc. Why?

> Because you're constructing a straw man, to make what I'm saying
> look less like a codification of existing practice than it is.  :)
> (Or so it seems to me.)

  No, I do not. Again, you proposed code to handle extra chips yet in
January, supposedly, as RFC. Yet in January other handhelds.org
developer discussed with you idea of using structured namespace for
GPIO. It wasn't random, we had some chore with flat namespaces for
quite some time before that, so to that time understood that there
handling (including need to write support code each time) doesn't
scale.

  We still didn't proceed to implement anything just then. And only
when we faced another problem (I mentioned it in original vtable RFC),
we saw similarities and when for coding solution. So, we had:

1. Case that we use different ADC/TS controller chips, they use
different command set and interface, but the data they produce are
essentially the same in the nature - stream of noisy coordinates,
ranging in some bounds. So, single touchscreen driver would be enough.

2. This GPIO stuff.

  They were then easily identifiable as cases of polymorphism, and we
solved them just like that, and using well-known pattern of inderect
function pointers. Combining that with structured identifiers allowed
to peal shell of the fruit, and decide, what is really required to
handle GPIOs is runtume-extensible manner, and what's only extraneous
bookkeeping code.

  And now we present this solution not only as the implementation of
extensible GPIO handling, but as a reusable solution for other similar
kind of problems. And I don't have ambition to say that it
"introduces" such pattern - at most, reinforces and popularizes.


>> There doesn't seem to be any technical reason for that. The reason it
>> seems to be doing that is paradigmatic: to pretend that the world is
>> flat, and that GPIO's stick not out of specific chips, but out of the
>> whole system, all lined up in a row. 

> Remember that IRQs do in fact "stick out of the whole system, all lined
> up in a row".  And oddly enough, so must GPIOs used as IRQs...  Strange,
> eh?  Go figure.

  A bit strange, indeed. But I may try to imagine why IRQs were
handled that way. IRQs are special things - they are external signals,
generated and pass thru different chips, but only CPU(s) handle them!
So, it would natural next step trying to line up them all in one table
for CPU's view.

  Note that looking deeper, IRQs numbers are not set in stone (one can
easily offset it), and for multiplexed IRQs, they are outright
virtual, as demultiplexing happens in software and any mapping can be
used (even though mostly same offsetting is). That means, that it
would be quite possible to stop thing of IRQ space as flat, but
instead think as structured, with nodes belonging to those
IRQ-processing chip, which gets real interrupt, not multiplexed one.

  But NO, I don't call for rewriting IRQ subsystem in such manner, as
proposed for GPIO! ;-) Let it rest in peace for some time after
Generic IRQ refactor which solved bunch of problems, so there's pretty
idyll in IRQ space now. But who knows, maybe in couple of years, when
dozen of CPUs in desktop machine will be norm, an there will be
multi-sensory systems with thousands of IRQs, maybe idea of structured
IRQ space won't be so off-shot.

  But that's clearly a trend. Systems became more complex, and
not using/ignoring structurization just would give more burden.
As an example of the trend, who would imagine something more flat,
single-dimensional, as RAM? Well, we have NUMA now. And kernel doesn't
try to pretend it's not there - there're API calls which accepts NUMA
node references, etc.

> - Dave



-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

