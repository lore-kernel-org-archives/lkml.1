Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbZE3K2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbZE3K2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZE3K2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:28:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44039 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZE3K2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:28:42 -0400
Date: Sat, 30 May 2009 11:21:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, timur@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, scottwood@freescale.com,
       yuan-bo.ye@motorola.com, David Miller <davem@davemloft.net>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090530102153.GA6910@n2100.arm.linux.org.uk>
References: <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> <20090528000707.GR6805@pengutronix.de> <20090527.171525.204909140.davem@davemloft.net> <20090528103745.GA19523@sirena.org.uk> <fa686aa40905281532l76996593ocdc36760eb468e04@mail.gmail.com> <20090529123411.GB14650@rakim.wolfsonmicro.main> <1243677166.440.12.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243677166.440.12.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 07:52:46PM +1000, Benjamin Herrenschmidt wrote:
> 
> > Sure.  My only big concern with it is that it compeltely sidesteps
> > clocking decisions so there's a lot of codecs it's not going to be
> > immediately useful with and I don't have a clear idea how it could be
> > extended to be so.  Most other things look like they can be added on
> > fairly easily when required.
> 
> Regarding clocks ...
> 
> Paulus and I had a discussion the other day and he mentioned a very good
> idea to represent the clock net in the device-tree.

I think the first thing to do is to get an accurate description of the
problem before thinking about how to come up with solutions.  I saw
that this kept coming up in Mark's emails, so I asked him about it
in private.

There are several issues surrounding clock stuff which he's seeing:

1. implementers of the clock API which have not been subject to my
   rigorous review abuse it to the point of making the API essentially
   useless, and that causes Mark problems.

   This basically comes down to people trying to uniquely name every
   single clock, and use just the name to do the lookup, ignoring the
   struct device.  This approach, really, does not work and makes the
   API pointless.

2. inter-relationships between several clocks.  To take his example,
   for clocking a DAC and ADC, you may have three clocks (dac_clk,
   adc_clk and bclk).  You may want dac_clk to be xkHz, adc_clk ykHz
   and bclk (which could well be related to both) to be zkHz.  For
   each of these, you might be able to accept an error of so-many-
   percent.

I believe (2) is an entirely separate problem to the device tree, and
really shouldn't concern the device tree beyond, maybe, providing the
contraints for individual clock _sources_.

(1) on the other hand is related, but is not really a device tree problem.
It's a problem with the way people use the API (even though that wrong
usage is explicitly documented as being wrong, this doesn't stop people
being lazy.)

I hadn't been doing the rigorous review of implementations on ARM as they
come in, in the interests of getting platform support into the kernel.
However, earlier this year I came up with a solution to this (clkdev) and
implemented it initially for the platforms I had, and later extended it to
the most complex ARM platform we have - OMAP.

clkdev doesn't stop the abuse per-se, but it _does_ make it damned easy
to change the lookup relationships, even build new relationships at run
time - which I can see will be an advantage to device tree stuff.

To put it another way, the conversion from broken-clk-get implementation
to clkdev is very simple and localised - you can use clkdev to continue
matching by clock connection name.  Once you've made that step, you can
then go through the drivers, one by one, fixing them and updating the
table.

Unlike previous attempts at putting a set of generic code behind the clk
API, clkdev does not place any requirements on the contents of struct clk.
To do so is fundamentally wrong - firstly, a struct clk is merely what the
clk_get API returns to represent the desired clock as a cookie, and
secondly, it has always been intended for there to be a many-to-one
relationship between the arguments to clk_get() and the returned cookie.

At the moment, clkdev lives in the ARM architecture, which seemed like a
sane place while it proves itself.  Moving it out into generic code is
the next step in its evolution - but I'm certainly not going to play
bun-fights with people over non-ARM clk API implementations, so it's
something other people will need to convert over to.

> It may also be useful to define properties in the clock controllers
> themselves mapping clock IDs to actual frequencies or things like that
> but I'm only half convinced here. IE. Let's start by defining the
> -wiring- and leave the -values- (on,off, slewing, freq adjustement,
> spreading) to an API between drivers and clock providers for now.

We have an API for that already (see above).
