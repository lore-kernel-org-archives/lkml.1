Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZF0AUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZF0AUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 20:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZF0AUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 20:20:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39422 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZF0AUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 20:20:42 -0400
Date: Sat, 27 Jun 2009 01:20:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <pierre@ossman.eu>
Message-ID: <20090627002035.GA4379@sirena.org.uk>
References: <1245961793.10360.26.camel@brutus>
 <20090625233723.GA13150@sirena.org.uk>
 <1245996263.10360.122.camel@brutus>
 <20090626105550.GE5415@sirena.org.uk>
 <1246019192.10360.202.camel@brutus>
 <20090626150849.GA5504@sirena.org.uk>
 <1246055215.10360.273.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246055215.10360.273.camel@brutus>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] PCAP regulator driver (for 2.6.32).
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 07:26:55PM -0300, Daniel Ribeiro wrote:
> Em Sex, 2009-06-26 às 16:08 +0100, Mark Brown escreveu:

> > Fundamentally, if your consumer is trying to explicitly force the
> > regulator off then it's not able to cope with the regulator being
> > shared.  I suspect that if someone does add a non-shared API then the

> The consumer (pxamci.c with the logic implemented on mmc/core.c) is not
> trying to explicitly force the regulator off. It is trying to know if
> itself has previously enabled the regulator.

The only previous use case for MMC was the driver was trying to make
sure power was off at startup.  See below...

> The problem is that regulator_is_enabled returns the regulator
> _hardware_ state, and regulator_enable/regulator_disable are used to
> update the use_count. This is an API inconsistency as the consumer
> should keep an internal use_count and _not_ rely on
> regulator_is_enabled.

It's not really an inconsistency - what you're asking for here is for a
boolean result to give a count back.  Things also get confused here as
soon as reference counting from a single consumer comes into play, which
usually means that different bits of the driver are 

Put another way, it's not regulator_was_enabled_by_me().

> I see no point in exporting regulator_is_enabled() as it is now. There
> is no use in a consumer driver to know if the regulator _hardware_ is
> enabled (as it may be shared).

The use cases for this mostly come around boot time - the consumer may
want to initialise the hardware differently if it's already been
powered.  The simplest case is if something like a backlight driver
tries to avoid changing the hardware state as it starts up.

There are also drivers which really can't tolerate shared use and
absolutely do need exclusive use of the regulator - once you have
exclusive use a consumer can, if it never makes use of reference
counting, do what you suggest.

> So, if the regulator framework has no bugs regarding regulators left on
> by the bootloader, then maybe the buggy code is mmc/core.c?

Not quite; the issue here is that the MMC core assumes exclusive use of
the regulator.  My understanding is that there would be actual breakage
if the regulator weren't enabled and disabled when the MMC core requests
it so this isn't just a case of it being buggy, it needs to be sure that
nothing else is changing the regulator state under it.

Since it requires exclusive use it can use the physical state to keep
track of things and in order to ensure that it's boostrapped correctly
it requires that the MMC driver give it a regulator which is disabled
before it starts.

> Anyway, I don't have more time to spend on this issue, so i will just do
> as you request, remove the workaround from pcap_regulator.c and put it
> on pxamci.c, even if I think that this is the ugliest solution so far.

I have mentioned the idea of adding an exclusive use API for a reason
(more properly it'd be the ability to insist on a particular set of
constraints plus an extra bit for exclusive use).
