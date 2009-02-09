Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZBIR1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZBIR1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZBIR1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:27:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3411 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbZBIR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:27:23 -0500
Date: Mon, 9 Feb 2009 17:27:15 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Message-ID: <20090209172714.GA17637@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <20090208232922.GA16966@sirena.org.uk> <200902081604.29905.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902081604.29905.david-b@pacbell.net>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 04:04:29PM -0800, David Brownell wrote:
> On Sunday 08 February 2009, Mark Brown wrote:

> > If we're going to do this I think it'd be better to push it into the
> > core and let the regulators pass in a set of constraints so that the
> > behaviour will be consistent between drivers.

> Maybe, but there is no such mechanism right yet.
> When it's created, then this could switch over.

Since you appear to be writing the code already... :)

> > I'd also expect to have the registration fail or at least issue a
> > warning if the code kicks in since that indicates that the board
> > constraints have been set up incorrectly.

> A warning might make sense in some cases ... that's
> something I would expect to see from the regulator
> core, though.

That's what I'm suggesting should happen - that things like this should
be implemented in the core so that the behaviour of the API remains
consistent for users moving between platforms and everyone benefits from
new features.

>                Example, I see no "max < min" checks
> triggering registration errors.

Not a bad idea, though.  The core currently doesn't do much checking of
the constraints but that's as much because nobody spent the time on it
as anything else.  To the extent it's a deliberate design decision it's
because the constraints and consumer lists are where the information
about what's possible on a given system comes from and so the checking
that can be done by software is relatively minor.

> > There's a reasonable chance 
> > that the fixed up constraints will still need to be changed for the
> > board to be configured properly and things may end up being driven out
> > of spec, potentially causing damage.

> I don't see that happening ... all that code does is
> tighten existing constraints to match what the hardware
> can do.  The result is just a subset of the range the
> board already said was OK.  If no valid subset exists,

The trouble is that this code should only do anything if the board code
provided a configuration that can't be supported by the hardware, which
is a bit of a red flag.  I'd expect it'd end up catching things like the
user typing extra digits by mistake (this has definitely happened when
writing consumer drivers).

Your current patch does also set constraints for the voltages if they
weren't there previously (though this shouldn't matter since voltage
setting shouldn't be enabled without voltage value constraints).

> I can easily imagine having things partially set up, and
> not really caring whether, on a particular board, those
> initial constraints are really the most specific ones
> applicable.  One component tolerates a range of 1V8..3V6
> maybe, but on any given board it can be hooked up to any
> supply that's even partially in-range.

The pattern you're describing is very much that for consumer and
regulator drivers.  They should work with as wide a set of constraints
as possible to allow them to be used on different systems with different
capabilities and needs - allowing this is essential for the API to be
usable since so many chips are flexible about the supplies they can use.

It's different for the machine constraints since they are by definition
specific to a given system.  While it's expected that users (especially
those sensitive to power consumption) may want to optimise the
configuration of their system during development to get the best
performance out of it there is also an expectation that users will be
making decisions based on knowledge of the hardware design.
