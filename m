Return-Path: <linux-kernel-owner+w=401wt.eu-S934387AbZHENdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbZHENdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934356AbZHENdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:33:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:42548 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934335AbZHENdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:33:03 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18reUYqxQsr+Wbg4R26qf4rri/gOEpLNSscdUyC2D
	ltHfo11NFmi/Cw
Date: Wed, 5 Aug 2009 15:33:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian@mnementh.co.uk>
cc: pHilipp Zabel <philipp.zabel@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: MMC: Make the configuration memory resource optional
In-Reply-To: <4A7731C8.9040407@mnementh.co.uk>
Message-ID: <Pine.LNX.4.64.0908051445120.5802@axis700.grange>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> 
 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com> 
 <20090729115817.GA12223@rakim.wolfsonmicro.main> 
 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com> 
 <20090729124233.GA12802@rakim.wolfsonmicro.main> 
 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com> 
 <4A704777.70001@mnementh.co.uk>  <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
  <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org>
 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
 <4A716F1C.2050805@mnementh.co.uk> <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
 <4A71F2A5.4060206@mnementh.co.uk> <Pine.LNX.4.64.0907310853470.4541@axis700.grange>
 <4A7731C8.9040407@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian

On Mon, 3 Aug 2009, Ian Molton wrote:

> Guennadi Liakhovetski wrote:
> 
> > > I cant see _why_ this should be a problem, as this disables the card
> > > clock,
> > > not HCLK. Could you debug further in tmio_mmc_clk_stop() please and see if
> > > reordering only one of the two IO accesses cures this?
> > 
> > Not sure I understood the "reordering only one of the two IO accesses"
> > correctly, but I swapped the two sd_ctrl_write16() calls in
> > tmio_mmc_clk_stop() and no, it didn't cure the problem.
> 
> I meant can you reorder them so that only one or the other is after the reset.
> Thus eliminating one  (perhaps) as the cause of the problem.

With my patches the tmio_mmc_clk_stop() function looked like this 
(pseudocode):

tmio_mmc_clk_stop()
{
	CTL_CLK_AND_WAIT_CTL = 0x0000;
	msleep(10);
	CTL_SD_CARD_CLK_CTL &= ~0x0100;
	msleep(10);
	clk_disable(clk);
}

I splitted the clk_disable() call out in a separate function and moved 
_only_ it after the reset() call - it worked too. Does this answer your 
question?

> Does your chip actually use the tmio-type reset, or has it a hard reset line
> or something?

No idea. As you know, this is not a separate chip, it is a built in 
controller into the sh7722 (probably, also other) SuperH SoC, so, I doubt 
it has a separate external reset line. Just like Magnus I have no 
datasheet for that block in SoC.

> Also is your issue that the driver doesnt work, or that you cant access
> registers from something like userspace ?

The driver doesn't work. Which means in this case - no interrupts, the mmc 
tasklet in in "D."

Thanks
Guennadi
---
Guennadi Liakhovetski
