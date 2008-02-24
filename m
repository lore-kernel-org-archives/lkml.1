Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYBXWzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYBXWzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbYBXWzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:55:31 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:29681 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753849AbYBXWz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:55:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=BTlGOC1gKDwSbsD+LsH0tqMfgW781XqyAbGoeXjjgDadT0fChwWmroITl4Q3BsiOXojvB3zTPkm4ZOcaPQYJgcXJINEzbY8vRHbdkG8UKLz9LpJNK8BjFsTGUK47u9hDapCKrWiwqoa7345ji56OWH01WL5VbKnd8ZqMNsFw56Q=  ;
X-YMail-OSG: mP9._csVM1ngFAhJ60X1LgsasHCv9w._DRliyd5M6lcL9BJPt6qp2jvqCX58TtdaAGA9mQPJNw--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 24 Feb 2008 14:55:27 -0800
From: David Brownell <david-b@pacbell.net>
To: hskinnemoen@atmel.com
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200802221723.24003.david-b@pacbell.net>
 <20080224184554.2c863f63@siona>
In-Reply-To: <20080224184554.2c863f63@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080224225527.62D5D28E1A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 18:45:54 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
>
> On Fri, 22 Feb 2008 17:23:23 -0800
> David Brownell <david-b@pacbell.net> wrote:
>
> > Create <linux/atmel_tc.h> based on <asm-arm/arch-at91/at91-tc.h> and the
> > at91sam9263 and at32ap7000 datasheets.  Most AT91 and AT32 SOCs have one
> > or two of these TC blocks, which include three 16-bit timers that can be
> > interconnected in various ways.
> > 
> > These TC blocks can be used for external interfacing (such as PWM and
> > measurement), or used as somewhat quirky sixteen-bit timers.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
>
> Sorry for the delay...some late comments coming up.

Happens.  :)


> > Note that this won't be usable until the AT91 and AT32 platforms
> > incorporate patches to configure the relevant platform devices.
> > Those changes are probably 2.6.26 material.

More specifically (and all those patches are available now):

 - AT91 needs clocksource/clockevent support for the SAM9 PIT timer;
 - AVR32 needs more extensive clocksource/clockevent updates;
 - Both also need platform device setup;

Merging these two patches before those is a perfectly safe NOP.


> Right...and there are a few funny dependencies we need to watch out
> for. AVR32 currently uses one of the TC blocks as a system timer. That
> code needs to be ripped out, but that will cause a fourfold increase in
> the power consumption of the AP7000 CPU.

Because the AVR32 count/compare clocksource (architectural registers)
precludes using the "idle" state in the idle loop ... it counts CPU
cycles, which don't happen in the "idle" state.


>	So I want to keep the window
> between ripping out the old code and using the new code as small as
> possible.

Right.


> I see the following possibilities:
>   * I switch avr32 over to use the new code after it has been merged
>     into mainline. This means the new code won't be tested on avr32
>     until near the end of the next merge window -- not good.

Well, "more widely" tested.  We've both observed it to work; basically
the same code has worked on AT91 for about a year now, too.

And that's why I suggest merging these parts, now that they're known to
work on both architectures.  The arch-specific bits can follow at their
own pace, neither one blocking the other.


>   * I forward the patches that switch avr32 over to Andrew so that they
>     can be included in -mm right after the tclib support. Not a bad
>     option, but I'm planning to do more AVR32 PM work before 2.6.26, so
>     there might be conflicts.

Conflicts there would be the easy part to deal with.  They're all
specific to AVR32, and you can merge those in any convenient order.


>   * I take the whole thing through my avr32 git tree.

Doesn't work as smoothly for the AT91 side ... but Andrew Victor has
very limited time any more for such stuff (these AT91 patches will
go through him first then Russell) so I'm not sure any added delays
there could hurt much.


>   * I (or someone else) set up a new git tree for tclib + AT91 and
>     AVR32 platform support and ask Stephen to pull it into the -next
>     tree. Or, once it's stable, rmk and I can both pull it into our
>     respective trees. But that obviously means no rebasing and funny
>     games from that point on...
>
> I think the last option is the best one. What do you think?

In effect, I've had that last option as a series of quilt patches,
and posting these two is the first step in that merge sequence...
heck, they could merge right now into 2.6.25-rc3 and that would let
the two arch series merge at their own paces.  (AVR32 direct from
you, AT91 very indirectly through Andrew then Russell.)


My personal priority is to get these patches into the merge queue(s)
so that they're no longer sitting on my disks and so that when I
want those platforms to have HRT and/or NO_HZ, it's already there. 


> > +#if defined(CONFIG_AVR32)
> > +/* AVR32 has these divide PBB */
> > +const u8 atmel_tc_divisors[5] = { 0, 4, 8, 16, 32, };
> > +EXPORT_SYMBOL(atmel_tc_divisors);
> > +
> > +#elif defined(CONFIG_ARCH_AT91)
> > +/* AT91 has these divide MCK */
> > +const u8 atmel_tc_divisors[5] = { 2, 8, 32, 128, 0, };
> > +EXPORT_SYMBOL(atmel_tc_divisors);
> > +
> > +#endif
> > +
> > +/* we "know" that there will be either one or two TC blocks */
> > +static struct platform_device *blocks[2];
>
> You seem to know more about future Atmel chips than I do :-P

I only "know" about currently announced ones.  ;)


> I'm not a huge fan of such static limitations.

Me either, but at this point doing more than that seems to me
to land in that "overengineering" category...


> > +/**
> > + * atmel_tc_alloc - allocate a specified TC block
> > + * @block: which block to allocate
> > + * @iomem: used to return its IO memory resource
> > + *
> > + * Caller allocates a block.  If it is available, its I/O space is requested
> > + * and returned through the iomem pointer, and the device node for the block
> > + * is returned.  When it is not available, NULL is returned.
>
> Any reason why it can't ioremap() the registers as well? Most drivers
> probably want that.

An earlier version of the code did that.  If you want to modify the
patch series to work that way, feel free.  (Right now it'd be only
these two patches posted to LKML ... nobody's posted a driver for
e.g. 3-phase motor control, or servos with feedback loops, yet.)

I take it you don't have any real problem with non-support for
allocating a single TC channel.  These TC blocks are quirky, and
it's a bit awkward to use just one at at time.  (And that's not
only because having just sixteen bits for a timer is Not Enough!)


> > + * On some platforms, each TC channel has its own clocks and IRQs.  Drivers
> > + * should clk_get() and clk_enable() "t0_clk", "t1_clk, and "t2_clk".
> > + * In the same vein, they should platform_get_irq() for irqs 0, 1, and 2.
> > + * On other platforms, only irq 0 and "t0_clk" will be available; drivers
> > + * should handle with both configurations.
>
> Sounds complicated. I think it would be better if tclib did all the
> clk_get() calls and stored each clock into the atmel_tc struct so that
> the driver can simply clk_enable() each channel (which may point to the
> same clock.)

An earlier version of the code did something like that ... ;)

In that case the platform setup code handed a block of data to
the TC library code.  That was more complicated than I wanted.
You're suggesting the TC library code does that instead, and
shift that issue to a mid-layer?

In practice, this version didn't end up being hard to use.  All
I really noticed was the much-simplified platform support, which
came from using platform_device resources in the "usual way".


> > +struct platform_device *atmel_tc_alloc(unsigned block, struct resource **iomem)
> > +{
> > +	struct platform_device	*tc;
> > +	struct resource		*r;
> > +
> > +	if (block >= ARRAY_SIZE(blocks) || !iomem)
> > +		return NULL;
> > +
> > +	tc = blocks[block];
> > +	if (tc) {
> > +		r = platform_get_resource(tc, IORESOURCE_MEM, 0);
> > +		if (r)
> > +			r = request_mem_region(r->start, 256, NULL);
>
> Shouldn't you use the real resource size instead of some magic number?

The chip specs say there are only 256 bytes of registers there,
no matter how the address decoding works.  It could be argued either
way, but computing the "real resource size' involves avoidable math.


> > +static struct platform_driver tc_driver = {
> > +	.driver.name	= "atmel_tcb",
>
> Wow, I didn't know that was possible...

Concision is my friend.  ;)


> > +#define ATMEL_TC_BMR	0xc4		/* TC Block Mode Register */
> > +#define     ATMEL_TC_TC0XC0S	(3 << 0)	/* external clock 0 source */
> > +#define        ATMEL_TC_TC0XC0S_TCLK0	(0 << 0)
>
> Hmm. Indentation using spaces? I didn't know you were into that sort of
> thing ;-)

It's way better than indenting off the right margin of the page!


> Anyway, my main issue is that I think we should add a data structure
> with information about each device, similar to struct ssc_device in the
> atmel-ssc driver. How about something like this?
>
> struct atmel_tc_block {
> 	void __iomem		*regs;	/* non-NULL when busy */
> 	struct platform_device	*pdev;
> 	struct clk		*clk[3];
> 	struct list_head	node;
> };

And per-channel IRQs too...

Well, if you want to take these patches off my hands and then be
responsible for merging them upstream, I won't object.  :)

- Dave

