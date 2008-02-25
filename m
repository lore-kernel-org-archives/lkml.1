Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYBYA1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYBYA1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbYBYA1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:27:15 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53752 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760691AbYBYA1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:27:11 -0500
Date: Mon, 25 Feb 2008 01:26:37 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Message-ID: <20080225012637.1535c95b@siona>
In-Reply-To: <20080224225527.62D5D28E1A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <200802221723.24003.david-b@pacbell.net>
	<20080224184554.2c863f63@siona>
	<20080224225527.62D5D28E1A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 14:55:27 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Sun, 24 Feb 2008 18:45:54 +0100
> Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> >
> > On Fri, 22 Feb 2008 17:23:23 -0800
> > David Brownell <david-b@pacbell.net> wrote:
> >
> > > Note that this won't be usable until the AT91 and AT32 platforms
> > > incorporate patches to configure the relevant platform devices.
> > > Those changes are probably 2.6.26 material.
> 
> More specifically (and all those patches are available now):
> 
>  - AT91 needs clocksource/clockevent support for the SAM9 PIT timer;
>  - AVR32 needs more extensive clocksource/clockevent updates;

Which reminds me...you were talking about a patch that adds oneshot
support for the count/compare clocksource and more cleanups, but I
don't think I've seen it...?

I've probably messed things up enough that it won't apply cleanly
anymore, but if you just send me what you have, I'll rebase and fold it
as necessary.

>  - Both also need platform device setup;

Right. I think I've got both those patches.

> Merging these two patches before those is a perfectly safe NOP.

Right. I just want to get everything properly queued up before the
merge window opens.

> > I see the following possibilities:
> >   * I switch avr32 over to use the new code after it has been merged
> >     into mainline. This means the new code won't be tested on avr32
> >     until near the end of the next merge window -- not good.
> 
> Well, "more widely" tested.  We've both observed it to work; basically
> the same code has worked on AT91 for about a year now, too.

Sure, but a bit more exposure won't hurt.

> And that's why I suggest merging these parts, now that they're known to
> work on both architectures.  The arch-specific bits can follow at their
> own pace, neither one blocking the other.
> 
> >   * I forward the patches that switch avr32 over to Andrew so that they
> >     can be included in -mm right after the tclib support. Not a bad
> >     option, but I'm planning to do more AVR32 PM work before 2.6.26, so
> >     there might be conflicts.
> 
> Conflicts there would be the easy part to deal with.  They're all
> specific to AVR32, and you can merge those in any convenient order.

Assuming the tclib stuff comes first, yes. I'm not worried about me
having to deal with conflicts, I'm worried about Andrew or Stephen
having to fix up my mess.

> >   * I take the whole thing through my avr32 git tree.
> 
> Doesn't work as smoothly for the AT91 side ... but Andrew Victor has
> very limited time any more for such stuff (these AT91 patches will
> go through him first then Russell) so I'm not sure any added delays
> there could hurt much.

Right. I was just mentioning it as one option.

> >   * I (or someone else) set up a new git tree for tclib + AT91 and
> >     AVR32 platform support and ask Stephen to pull it into the -next
> >     tree. Or, once it's stable, rmk and I can both pull it into our
> >     respective trees. But that obviously means no rebasing and funny
> >     games from that point on...
> >
> > I think the last option is the best one. What do you think?
> 
> In effect, I've had that last option as a series of quilt patches,
> and posting these two is the first step in that merge sequence...
> heck, they could merge right now into 2.6.25-rc3 and that would let
> the two arch series merge at their own paces.  (AVR32 direct from
> you, AT91 very indirectly through Andrew then Russell.)

Yes, getting the fundamental stuff into mainline now would help a lot.
But I was thinking about Linus' suggestions that we exploit the
distributed nature of git and do cross-tree merges to synchronize
changes to common code.

Setting up a separate git tree would allow the changes to go into the
arm tree without littering it with possibly unstable avr32 changes as
well, and it would allow me to merge them and put more stuff on top.
And if the patches are ready for mainline, there should be no need to
fix up the history of the "tclib" tree later, so it should be perfectly
safe to merge into several trees (assuming those trees don't rebase and
make them appear as different commits.)

> My personal priority is to get these patches into the merge queue(s)
> so that they're no longer sitting on my disks and so that when I
> want those platforms to have HRT and/or NO_HZ, it's already there. 

Which goes nicely along with my priority of reducing the overall power
consumption on avr32 :)

> > > +/* we "know" that there will be either one or two TC blocks */
> > > +static struct platform_device *blocks[2];
> >
> > You seem to know more about future Atmel chips than I do :-P
> 
> I only "know" about currently announced ones.  ;)

Yeah, I didn't actually check how many TC blocks are planned on other
chips. I just want this to be a bit future-proof.

> > I'm not a huge fan of such static limitations.
> 
> Me either, but at this point doing more than that seems to me
> to land in that "overengineering" category...

I don't entirely agree. Most drivers I've dealt with can handle an
arbitrary number of devices. I don't see why this one should be
different.

> > Any reason why it can't ioremap() the registers as well? Most drivers
> > probably want that.
> 
> An earlier version of the code did that.  If you want to modify the
> patch series to work that way, feel free.  (Right now it'd be only
> these two patches posted to LKML ... nobody's posted a driver for
> e.g. 3-phase motor control, or servos with feedback loops, yet.)

Right, that's why it's probably best to change it now rather than later.

> I take it you don't have any real problem with non-support for
> allocating a single TC channel.  These TC blocks are quirky, and
> it's a bit awkward to use just one at at time.  (And that's not
> only because having just sixteen bits for a timer is Not Enough!)

No, I have no problems with that.

> In that case the platform setup code handed a block of data to
> the TC library code.  That was more complicated than I wanted.
> You're suggesting the TC library code does that instead, and
> shift that issue to a mid-layer?

I'm suggesting that the mid-layer returns a nice struct with all the
information that the driver needs. atmel_tc_alloc() already returns two
separate values, and it might be useful to provide even more.

As an added bonus, the struct may contain a list_head so that we can
support an arbitrary number of devices as well.

> In practice, this version didn't end up being hard to use.  All
> I really noticed was the much-simplified platform support, which
> came from using platform_device resources in the "usual way".

I'm not suggesting we change the platform interface. That part looks
good to me.

> > Shouldn't you use the real resource size instead of some magic number?
> 
> The chip specs say there are only 256 bytes of registers there,
> no matter how the address decoding works.  It could be argued either
> way, but computing the "real resource size' involves avoidable math.

Good point.

> > > +#define ATMEL_TC_BMR	0xc4		/* TC Block Mode Register */
> > > +#define     ATMEL_TC_TC0XC0S	(3 << 0)	/* external clock 0 source */
> > > +#define        ATMEL_TC_TC0XC0S_TCLK0	(0 << 0)
> >
> > Hmm. Indentation using spaces? I didn't know you were into that sort of
> > thing ;-)
> 
> It's way better than indenting off the right margin of the page!

I've never really seen the point of indenting those defines at all.

> > Anyway, my main issue is that I think we should add a data structure
> > with information about each device, similar to struct ssc_device in the
> > atmel-ssc driver. How about something like this?
> >
> > struct atmel_tc_block {
> > 	void __iomem		*regs;	/* non-NULL when busy */
> > 	struct platform_device	*pdev;
> > 	struct clk		*clk[3];
> > 	struct list_head	node;
> > };
> 
> And per-channel IRQs too...

I thought about that, but while the driver can safely call clk_enable()
on the same clock several times, I'm not sure if it's such a great idea
to call request_irq() on the same interrupt several times. So the
driver probably needs to know how many irqs there really are and might
as well use platform_get_irq() to find out.

> Well, if you want to take these patches off my hands and then be
> responsible for merging them upstream, I won't object.  :)

I can do that.

It's getting late around here...I'll reply to your other mail tomorrow.

Haavard
