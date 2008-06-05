Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbYFEPW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbYFEPW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759591AbYFEPWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:22:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46847 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759556AbYFEPWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:22:30 -0400
Date: Thu, 5 Jun 2008 16:22:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080605152228.GA24014@rakim.wolfsonmicro.main>
Mail-Followup-To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
	Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
	linux-kernel@vger.kernel.org
References: <200806050851.47319.geoffrey@pager.net> <20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
X-Cookie: Violence is molding.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 04:22:06PM +0200, Haavard Skinnemoen wrote:

> I have to admit I don't understand the current sound situation at all.
> With this driver, we now have:
>   * A "regular" ALSA driver for the AC97C (not based on ASoC)
>   * Two different "generic" AC97 layers: one in sound/pci/ac97 and one
>     in sound/soc/ac97 (the AC97C driver uses the former)

There is AC97 support in ASoC but there's no sound/soc/ac97?  Briefly,
the generic ALSA AC97 support is focused on handling standard AC97 parts
without additional features while the ASoC layer requires more per-board
setup but supports codecs with large extensions to the AC97 standard
such as the additional of secondary I2S interfaces that can't readily be
accomodated in the vanilla AC97 driver.

For systems using only AC97 codecs with only small non-standard features
the vanilla AC97 driver provides a turnkey solution with no machine
specific code at all.  It should be possible to implement it in terms of
ASoC but nobody has tried yet and it's not 100% clear that it's worth
the code churn.

>   * An OSS driver for the AP7000 Audio Bitstream DAC
>   * An i2s driver for the AT73C213 chip using the SSC controller and SPI

These drivers will be working in the way people were doing embedded
audio prior to ASoC.  Support for each system was provided by a
monolithic driver which implemented support for the codec, the audio
controller on the SoC and any other components on the board.  This
resulted in a lot of redundancy since multiple systems using the same
components would find it hard to share code for them and the
abstractions providing the reuse that did exist often ended up getting
done multiple times.

ASoC improves code reuse here by separating out the support for codecs
and SoC CPUs from the machine drivers, providing a layer for gluing them
together and fitting them into the ALSA core.  An ASoC machine driver
can be little more than the equivalent of "I have a codec of this type
connected to this I2S interface on my CPU and clocked in this way" but
it can support more complex scenarios.

It also provides a generic power management infrastructure for these
systems, allowing unused parts of the audio subsystem to be put into low
power states when they are not being used as part of an active audio
path.

>   * Another SSC driver based on the ASoC layer
>   * Some sort of "AT32 PCM" layer which apparently can only be used
>     with the SSC controller
>   * The above two being essentially identical to similar drivers for
>     AT91

These drivers provide the CPU side support for the system within ASoC.
I suspect from what you are saying that the two Atmel ASoC platform
driver sets could be implemented with a common core with some per-CPU
glue to plug them together but I've never looked at either platform in
sufficient detail.

The PCM layer in these drivers represents the DMA controller part of the
SoC hardware - the DMA control is split out in ASoC because most SoCs
have generic DMA engines which are shared between multiple audio
interface controllers (eg, I2S and AC97) so there's no point in
repeating the code to glue them into ALSA DMA.

> Can someone please help me out here? In particular, what is ASoC and
> why should I want to use it?

Hopefully I answered that above.  There's a more detailed overview in
Documentation/sound/alsa/soc/overview.txt:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/sound/alsa/soc/overview.txt;h=1e4c6d3655f2089c875ff381759ebd5528fe2ad3;hb=HEAD
