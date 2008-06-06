Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYFFLh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYFFLh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYFFLhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:37:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52452 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753051AbYFFLhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:37:10 -0400
Date: Fri, 6 Jun 2008 12:37:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080606113707.GA32726@rakim.wolfsonmicro.main>
Mail-Followup-To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
	Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
	linux-kernel@vger.kernel.org
References: <200806050851.47319.geoffrey@pager.net> <20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com> <20080605152228.GA24014@rakim.wolfsonmicro.main> <20080605184037.3e1f447d@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605184037.3e1f447d@hskinnemo-gx745.norway.atmel.com>
X-Cookie: You might have mail.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 06:40:37PM +0200, Haavard Skinnemoen wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > For systems using only AC97 codecs with only small non-standard features
> > the vanilla AC97 driver provides a turnkey solution with no machine
> > specific code at all.  It should be possible to implement it in terms of
> > ASoC but nobody has tried yet and it's not 100% clear that it's worth
> > the code churn.

> Sounds like it could be solved by a thin adapter layer on top of a more
> flexible AC97 driver.

That's pretty much exactly what sound/soc/codecs/ac97.c is doing - it
provides a codec driver which lets a machine connect a SoC AC97
controller driver to the generic ALSA AC97 layer, it doesn't actually
have any code of its own.

It can't completely replace the generic AC97 layer at the minute but the
major issue with that currently is the more general one of providing a
machine driver for a standard AC97 subsystem and then working out when
to use it rather than a system-specific one.

> > ASoC improves code reuse here by separating out the support for codecs
> > and SoC CPUs from the machine drivers, providing a layer for gluing them
> > together and fitting them into the ALSA core.  An ASoC machine driver
> > can be little more than the equivalent of "I have a codec of this type
> > connected to this I2S interface on my CPU and clocked in this way" but
> > it can support more complex scenarios.

> But why is it only useful on SoCs?

It's more a case of the way people want to program things than anything
else - if someone were to write the relevant drivers for things other
than SoC systems then ASoC would quite happily glue everything together,
the core really doesn't care about what the drivers are actually
controlling.

What's more of an issue for doing this is that the programming model
that ASoC offers really only fits well with decomposed systems where you
have discrete components offering meaningful control.  That is the rule
in embedded systems but is much less often the case in other
environments and the further you get from that the more you'd have to
shoehorn things to fit into the ASoC model.  If the ASoC model is a good
fit then people may want to use it but it won't be helpful for everyone.

That said, there are also problems due to the current code predating the
device model that prevent you having more than one ASoC card in your
system.  There is a new version of ASoC in the asoc-v2-dev branch of
git://opensource.wolfsonmicro.com/linux-2.6-asoc which addresses this
but it's quite invasive so it's not a trivial merge.  This is all at the
implementation detail level rather than the core concepts level, though,
and should get resolved in the forseeable future.

> > It also provides a generic power management infrastructure for these
> > systems, allowing unused parts of the audio subsystem to be put into low
> > power states when they are not being used as part of an active audio
> > path.

> Again, that sounds very useful in general, not only for SoCs. Power
> consumption is perhaps _more_ important on embedded systems than PCs,
> but I very much doubt that anyone would complain if their laptop
> battery lasted a few minutes longer ;-)

In practice the savings you get from this are very small - at worst
you're looking at things like powering up a high-power amplifier and
playing an audio signal through it when it's not actually connected.
These might consume hundreds of miliwatts (at worst) but you can achieve
an awful lot of the saving DAPM makes by simply muting the relevant
output.  More typically you're looking at savings in the order of single
or double digit miliwatts.

> This is why I think grouping drivers based on platform, bus type or
> whatever is just wrong. It prevents using the same drivers on identical
> hardware that just happens to be integrated on a different type of chip
> or wired up to a different kind of bus.

That's just the convention that's been adopted by people writing
platform support - it's not an ASoC requirement.

> Now, I'm not sure what kind of changes that were necessary to make the
> at91 driver work on avr32, but if it was only about changing it to use
> the atmel-ssc driver, maybe we should just replace the existing at91
> driver with the new at32 driver?

If literally the same driver can be used then you probably want to have
a directory (eg, 'atmel') which is shared between the two platforms.

> > The PCM layer in these drivers represents the DMA controller part of the
> > SoC hardware - the DMA control is split out in ASoC because most SoCs

> Ok, so why not call it "DMA" or something instead of "PCM"?

You can do if you like - the ASoC core actually calls this type of
driver a platform driver (the idea is that it should handle anything
that applies over multiple controllers, but in practice that's usually
just DMA).

> Yes, thanks a lot for explaining. I think the design goals of the ASoC
> layer makes sense, it's just that I don't see anything inherently
> SoC-specific about them.

The subsystem is there and can be used if it makes sense for a given
driver but as outlined above it's not going to work well for everyone.
