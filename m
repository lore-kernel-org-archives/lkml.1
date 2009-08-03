Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZHCCwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZHCCwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 22:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZHCCwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 22:52:01 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:56312 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZHCCwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 22:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VKzqpxHw3nuWDcV1tMxhKxwQicZjN6rAheXx4lgAKRI/8/bVP9+Mbfrf5DykJi5EXM
         ZmhoX+V51k5j3AyzVVWeWAjuIt8ZujmtT5WyByI+qpi1qXA3xAaGE2xonQhR9wgConaq
         xRKRUl5ZKSwB9QKO5qkDPGRpFeMZt7EA4Dhdw=
MIME-Version: 1.0
In-Reply-To: <4A71F2A5.4060206@mnementh.co.uk>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
	 <4A704777.70001@mnementh.co.uk>
	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
	 <4A7053E8.8050303@mnementh.co.uk>
	 <20090729201702.GA28202@linux-sh.org>
	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
	 <4A716F1C.2050805@mnementh.co.uk>
	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
	 <4A71F2A5.4060206@mnementh.co.uk>
Date: Mon, 3 Aug 2009 11:52:00 +0900
Message-ID: <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 4:21 AM, Ian Molton<ian@mnementh.co.uk> wrote:
> Guennadi Liakhovetski wrote:
>
>> While you're at it, please, consider swapping the two lines in
>> tmio_mmc_probe():
>>
>> -       tmio_mmc_clk_stop(host);
>>        reset(host);
>> +       tmio_mmc_clk_stop(host);
>>
>> Otherwise, I think, reset causes problems trying to access the controller
>> with disabled clock. At least this is needed on SuperH.
>
> Interesting. I'll see what the result of this is on TMIO - This sequence was
> garnered from the WinCE driver for the chip.
>
> I cant see _why_ this should be a problem, as this disables the card clock,
> not HCLK. Could you debug further in tmio_mmc_clk_stop() please and see if
> reordering only one of the two IO accesses cures this?

I wonder if the clock framework patch from Guennadi ties in the clock
that drives the TMIO block, instead of the interface clock that is
used to communicate with the physical media? That would explain the
reordering of the tmio_mmc_clk_stop() function.

In my mind, using the clock framework to control the interface clock
sounds like a good plan. As for the clock that drives the TMIO block
itself (that Guennadi's patch tries to control) - on a second thought
it may make more sense to use the upcoming Runtime PM framework to
control that one.

Making use of the Runtime PM comes with a big advantage - it will
provide use with hooks to allow saving and restoring register context
so the power domain containing the TMIO block can be powered off
during runtime.

I'd be happy to fix up the Runtime PM related parts of the tmio_mmc
driver if you'd like. The Runtime PM changes will of course "just
work" in the MFD case - ie do nothing unless your architecture has
support for it.

The recently posted Runtime PM patch for the SuperH Mobile I2C driver
may serve as an example:
http://patchwork.kernel.org/patch/38514/

Another solution is of course to use two clocks in TMIO driver - one
for the interface clock and one for the hardware block itself. This
may be better if you want to control the hardware block clocks from
the MFD layer in the future. Let me know what you think.

Thanks for your help.

Cheers,

/ magnus
