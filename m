Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbYFEQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbYFEQkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYFEQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:40:28 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57809 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbYFEQk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:40:27 -0400
Date: Thu, 5 Jun 2008 18:40:37 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080605184037.3e1f447d@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080605152228.GA24014@rakim.wolfsonmicro.main>
References: <200806050851.47319.geoffrey@pager.net>
	<20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
	<20080605152228.GA24014@rakim.wolfsonmicro.main>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2008 16:40:02.0441 (UTC) FILETIME=[CD25A790:01C8C72A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jun 05, 2008 at 04:22:06PM +0200, Haavard Skinnemoen wrote:
> 
> > I have to admit I don't understand the current sound situation at all.
> > With this driver, we now have:
> >   * A "regular" ALSA driver for the AC97C (not based on ASoC)
> >   * Two different "generic" AC97 layers: one in sound/pci/ac97 and one
> >     in sound/soc/ac97 (the AC97C driver uses the former)
> 
> There is AC97 support in ASoC but there's no sound/soc/ac97?

Whoops, that should have been sound/soc/codecs/ac97.c.

>  Briefly,
> the generic ALSA AC97 support is focused on handling standard AC97 parts
> without additional features while the ASoC layer requires more per-board
> setup but supports codecs with large extensions to the AC97 standard
> such as the additional of secondary I2S interfaces that can't readily be
> accomodated in the vanilla AC97 driver.

Ok, but why write a whole new driver instead of extending the existing
one to support the missing features?

> For systems using only AC97 codecs with only small non-standard features
> the vanilla AC97 driver provides a turnkey solution with no machine
> specific code at all.  It should be possible to implement it in terms of
> ASoC but nobody has tried yet and it's not 100% clear that it's worth
> the code churn.

Sounds like it could be solved by a thin adapter layer on top of a more
flexible AC97 driver.

> >   * An OSS driver for the AP7000 Audio Bitstream DAC
> >   * An i2s driver for the AT73C213 chip using the SSC controller and SPI
> 
> These drivers will be working in the way people were doing embedded
> audio prior to ASoC.  Support for each system was provided by a
> monolithic driver which implemented support for the codec, the audio
> controller on the SoC and any other components on the board.  This
> resulted in a lot of redundancy since multiple systems using the same
> components would find it hard to share code for them and the
> abstractions providing the reuse that did exist often ended up getting
> done multiple times.

Right, so ALSA really did need a common codec abstraction.

> ASoC improves code reuse here by separating out the support for codecs
> and SoC CPUs from the machine drivers, providing a layer for gluing them
> together and fitting them into the ALSA core.  An ASoC machine driver
> can be little more than the equivalent of "I have a codec of this type
> connected to this I2S interface on my CPU and clocked in this way" but
> it can support more complex scenarios.

But why is it only useful on SoCs?

> It also provides a generic power management infrastructure for these
> systems, allowing unused parts of the audio subsystem to be put into low
> power states when they are not being used as part of an active audio
> path.

Again, that sounds very useful in general, not only for SoCs. Power
consumption is perhaps _more_ important on embedded systems than PCs,
but I very much doubt that anyone would complain if their laptop
battery lasted a few minutes longer ;-)

> >   * Another SSC driver based on the ASoC layer
> >   * Some sort of "AT32 PCM" layer which apparently can only be used
> >     with the SSC controller
> >   * The above two being essentially identical to similar drivers for
> >     AT91
> 
> These drivers provide the CPU side support for the system within ASoC.
> I suspect from what you are saying that the two Atmel ASoC platform
> driver sets could be implemented with a common core with some per-CPU
> glue to plug them together but I've never looked at either platform in
> sufficient detail.

The SSC hardware is essentially identical on the two platforms, and
there's also a common driver of sorts in drivers/misc/atmel-ssc.c. So
it shouldn't be too hard to have them share the same i2s driver.

This is why I think grouping drivers based on platform, bus type or
whatever is just wrong. It prevents using the same drivers on identical
hardware that just happens to be integrated on a different type of chip
or wired up to a different kind of bus.

Now, I'm not sure what kind of changes that were necessary to make the
at91 driver work on avr32, but if it was only about changing it to use
the atmel-ssc driver, maybe we should just replace the existing at91
driver with the new at32 driver?

> The PCM layer in these drivers represents the DMA controller part of the
> SoC hardware - the DMA control is split out in ASoC because most SoCs
> have generic DMA engines which are shared between multiple audio
> interface controllers (eg, I2S and AC97) so there's no point in
> repeating the code to glue them into ALSA DMA.

Ok, so why not call it "DMA" or something instead of "PCM"?

Btw, there are chips that use a different kind of DMA interface to the
SSC, so I think the split makes sense. I just think the name "at32-pcm"
is confusing. "atmel-ssc-pdc" would have been much better.

> > Can someone please help me out here? In particular, what is ASoC and
> > why should I want to use it?
> 
> Hopefully I answered that above.  There's a more detailed overview in
> Documentation/sound/alsa/soc/overview.txt:

Yes, thanks a lot for explaining. I think the design goals of the ASoC
layer makes sense, it's just that I don't see anything inherently
SoC-specific about them.

Haavard
