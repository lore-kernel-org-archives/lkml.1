Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYFEQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYFEQYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYFEQYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:24:37 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57547 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbYFEQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:24:35 -0400
Date: Thu, 5 Jun 2008 18:24:09 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Geoffrey Wossum <geoffrey@pager.net>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080605182409.6285ee4b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200806051000.56969.geoffrey@pager.net>
References: <200806050851.47319.geoffrey@pager.net>
	<20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
	<200806051000.56969.geoffrey@pager.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2008 16:23:34.0224 (UTC) FILETIME=[801FB500:01C8C728]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geoffrey Wossum <geoffrey@pager.net> wrote:
> On Thursday 05 June 2008 09:22:06 am Haavard Skinnemoen wrote:
> > Geoffrey Wossum <geoffrey@pager.net> wrote:
> > > For anyone that's interested, there's patches to add ALSA System-on-Chip
> > > sound platform drivers for the AVR32 being discussed on the alsa-devel
> > > mailing list right now.
> >
> > Hmm. For something that depends on a metric shitload of middle layers,
> > it is surprisingly large...
> 
> Partly because the code attempts to handle every contingency an application 
> might throw at (different sample rates, formats, clocking options, etc.).  
> Partly because it also has some concern for power management.

But if the low-level driver has to handle all that, what are all the
middle layers for?

> > I have to admit I don't understand the current sound situation at all.
> > With this driver, we now have:
> 
> To paraphrase Andy Tanenbaum, the great thing about standards is there's so 
> many to choose from.

Heh.

> >   * An OSS driver for the AP7000 Audio Bitstream DAC
> OSS <shudder>

Well, I did try to implement it as an ALSA driver, but a) it didn't
work, b) it was impossible to debug, and c) it ended up at about 10x
the size of the OSS driver. So I figured it wasn't really worth the
trouble.

> >   * A "regular" ALSA driver for the AC97C (not based on ASoC)
> I don't have an AC97 CODEC.
> 
> 
> >   * An i2s driver for the AT73C213 chip using the SSC controller and SPI
> Strongly coupled to the AT73C213, not the chip I'm using, although it did 
> provide a good example of working code.  This is where I figured out I needed 
> to use big endian.

Right, splitting out the i2s-related bits would have been a good thing.

> >   * Some sort of "AT32 PCM" layer which apparently can only be used
> >     with the SSC controller
> This IS sort of confusing.  It's really more of a generic SSC / PDC driver 
> than a "PCM layer".  Its existence is largely an artifact of it being in the 
> AT91 ASoC platform code, which I "ported" to get the AT32 platform code.  Its 
> existence in the AT91 platform driver is an artifact of the AT91 driver being 
> based on the PXA platform driver.  In other words, I'm not really the one to 
> explain the design rationale behind it.
> 
>  
> >   * The above two being essentially identical to similar drivers for
> >     AT91
> Yes, I didn't particularly like making the AT32 code almost exactly like the 
> AT91 code, and most of the differences are due to changes in some kernel APIs 
> rather than the peripherals really being different (BTW, the changes in the 
> AT32 are an improvement!).

Hmm...I take it you're talking about the SSC driver? That is supposed
to be usable on AT91 as well, so perhaps the right thing to do is
porting the AT91 driver over to use it.

I see you've added a few SSC-related constants...those should probably
go into include/linux/atmel-ssc.h.

>  But I needed an AT32 layer quickly, and I don't 
> have any AT91 hardware, so I couldn't really go mucking about in the AT91 
> code since I wouldn't be able to test it.  I don't feel especially bad, 
> though, since at91_mci.c and atmel-mci.c commit essentially the same sin.

Yeah, I guess you're right. I do have a long-term goal merging those
two drivers, but it will be a bit difficult because the DMA interface
is quite different.

> > Can someone please help me out here? In particular, what is ASoC and
> > why should I want to use it?
> 
> Number 1 reason (for me):  The only driver for my CODEC (WM8510) was an ASoC 
> driver.  Using sound system other than ASoC would require porting / rewriting 
> this driver.  Since an AT91 ASoC platform driver already existed, and would 
> be virtually the same as the AT32 platform driver, this was the best choice 
> for getting sound quickly.  So this essentially boils down to code reuse.  
> And if we switch CODEC's for some reason, it's less work.

That's certainly a good reason, though I don't understand why reusing
code isn't important on non-SoC platforms.

> Another highly compelling reason: power consumption.  Only powers up parts of 
> the audio pathway that are currently needed.

Another good reason, but again I don't understand why power management
isn't important on PCs.

> For more reasons:  http://alsa-project.org/main/index.php/ASoC

The reasons are all good, but yet again, I don't understand why those
design goals aren't appropriate for ALSA as a whole.

Haavard
