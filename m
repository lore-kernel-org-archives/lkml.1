Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYFFJ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYFFJ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYFFJ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:29:05 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34126 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYFFJ3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:29:03 -0400
Date: Fri, 6 Jun 2008 11:29:15 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Geoffrey Wossum <geoffrey@pager.net>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080606112915.4b1d5d42@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200806051210.47986.geoffrey@pager.net>
References: <200806050851.47319.geoffrey@pager.net>
	<200806051000.56969.geoffrey@pager.net>
	<20080605182409.6285ee4b@hskinnemo-gx745.norway.atmel.com>
	<200806051210.47986.geoffrey@pager.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2008 09:28:38.0102 (UTC) FILETIME=[B34AB760:01C8C7B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geoffrey Wossum <geoffrey@pager.net> wrote:
> On Thursday 05 June 2008 11:24:09 am Haavard Skinnemoen wrote:
> > Geoffrey Wossum <geoffrey@pager.net> wrote:
> > > On Thursday 05 June 2008 09:22:06 am Haavard Skinnemoen wrote:
> > > > Geoffrey Wossum <geoffrey@pager.net> wrote:
> 
> > > To paraphrase Andy Tanenbaum, the great thing about standards is there's
> > > so many to choose from.
> >
> > Heh.
> 
> I quote that a lot.  Along with Philip K. Dicks's "Sometimes an appropriate 
> response to reality is to go insane."

That's a good one too.

> > Hmm...I take it you're talking about the SSC driver? That is supposed
> > to be usable on AT91 as well, so perhaps the right thing to do is
> > porting the AT91 driver over to use it.
> 
> Yes, the SSC code.  It'd be cool if it abstracted out even more, but I 
> understand the difficulties in making that happen.

Ok. Since the SSC module is a multi-purpose module, the SSC driver was
designed to be as thin and flexible as possible. So we just added some
platform_driver glue and a request/free interface and left everything
else up to the higher-level driver.

I suppose we could add a few more helper functions. Suggestions are
welcome.

> > I see you've added a few SSC-related constants...those should probably
> > go into include/linux/atmel-ssc.h.
> 
> I wasn't sure if having these in atmel-ssc.h fit with ya'lls plans for it, but 
> if it does, great.

I think the constants look very useful in general, so it makes sense to
put them in atmel-ssc.h. Doing i2s is pretty much all the plans we have
for it at the moment, but if someone comes up with a different use case,
that would be cool too.

> > >  But I needed an AT32 layer quickly, and I don't
> > > have any AT91 hardware, so I couldn't really go mucking about in the AT91
> > > code since I wouldn't be able to test it.  I don't feel especially bad,
> > > though, since at91_mci.c and atmel-mci.c commit essentially the same sin.
> >
> > Yeah, I guess you're right. I do have a long-term goal merging those
> > two drivers, but it will be a bit difficult because the DMA interface
> > is quite different.
> 
> The PDC interface is closer (if not exactly the same).

The MMC controller on AP7000 isn't hooked up to the PDC, it's hooked up
to a more complex DMA controller. I'm working on extending the DMA
subsystem to handle peripheral DMA, but I had to delay that work for
some time now. Hopefully I'll get back to working on it very soon.

>  One issue is the SSC 
> interface, which you have said could be used on the AT91.  After that, the 
> main differences are that the DMA buffer has to be allocated differently, and 
> the mmap() implementation is different.

Oh. That's a bit surprising to me...can you elaborate on the
differences?

> > That's certainly a good reason, though I don't understand why reusing
> > code isn't important on non-SoC platforms.
> 
> Please don't take my answer as authoritative, but I think it's because on a 
> typical PC the exact CODEC being used tends to be hidden from you.  And you 
> normally don't use I2S or PCM directly.  A PC sound card is more of a black 
> box.

But I would have thought that if you have a PC sound card with an
on-board i2s bus and a standard codec, you could create a board driver
by simply hooking the different parts together, possibly with a custom
i2s bus driver?

That will still make it look like a black box to the user (just load
the card driver, and it will take care of everything), but you can
share code between the PC platform and various embedded platforms.

> > Another good reason, but again I don't understand why power management
> > isn't important on PCs.
> 
> It is important, and becoming more important all the time.  I think the main 
> reasons this isn't a priority on a PC right now are:
>  - I think PC sound cards tend to be black boxes regarding power consumption, 
> especially those white box cards you can get at Fry's and similar places.   

Right...so it's a matter of documentation. I suspect those white box
cards still use cheap, standard hardware under the hood, though maybe
that fact is pretty well hidden.

>  - A few extra mA aren't as important when you're plugged in, or you have a 
> laptop, which has a honkin' big battery compared to a PDA type device
>  - A few extra mA are dwarfed by other things in a PC, like the processor.  My 
> Intel T7200 burns 34 W at full tilt.  The AT32AP7000 is going to be something 
> like, what, 250 mW?  Even throttled all the way down my T7200 is going to be 
> 13 W.  Turning off all or part of the CODEC and saving 15 - 30 mW is a lot 
> bigger deal on the AVR32 than it would be on my laptop.

True, but if you combine it with better power management in other
subsystems as well, the end result may be worthwhile. In any case, it
certainly doesn't _hurt_ to have better power management on PC sound
cards.

>  - As you say, there is more code due to the power management, which requires 
> modifying a lot of working drivers, for little benefit in the forseeable 
> future.

Don't get me wrong -- I didn't intend to NAK the driver, and I
certainly appreciate that you took the effort to implement proper power
management. I just felt a bit confused about the whole ASoC thing. I
think I see why it is useful now, though I still don't really
understand why it's limited to SoC devices.

What really bothers me about the ASoC layer is that it is a framework
designed for embedded systems only. One of the great things about Linux
on embedded systems is that you get to use a lot of code that has been
thoroughly tested on commodity PC hardware. When you introduce
frameworks specifically for embedded systems, you throw that advantage
away. For example, a particular AC97 codec chip may be used with a
different driver depending on whether it's soldered on a PC motherboard
or some embedded board. That feels wrong to me.

Haavard
