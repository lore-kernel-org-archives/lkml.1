Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZBJWtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZBJWtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbZBJWtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:49:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2095 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbZBJWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:49:04 -0500
Date: Tue, 10 Feb 2009 22:48:52 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090210224851.GA6408@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902081604.29905.david-b@pacbell.net> <20090209172714.GA17637@sirena.org.uk> <200902091624.01802.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902091624.01802.david-b@pacbell.net>
X-Cookie: To the landlord belongs the doorknobs.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 04:24:01PM -0800, David Brownell wrote:
> On Monday 09 February 2009, Mark Brown wrote:

> > > Maybe, but there is no such mechanism right yet.
> > > When it's created, then this could switch over.

> > Since you appear to be writing the code already... :)

> Not for the regulator core, though.  Switching from
> a simplistic constraint engine to one that starts to

There's nothing specific to the driver in this code - it's just doing
basic comparisons of two sets of constraints and acting on them and
would work just as well if it were pushed into the core.  You're going
to need this in multiple drivers to use it in a system anyway (it'll
need to be in at least the drivers which might be used on that system).

> handle a more realistic "union of constraints" model
> would be doable, but is a bit more off-topic work than
> I'd want to sign up for just now.

Solving all possible problems is, obviously, a bigger task but I don't
think we need to solve everything in order to avoid having this be
driver specific.

What I would suggest that you do for this is submit a patch allowing the
regulators to supply a set of constraints when they register (but not
doing anything with them), another with a TWL4030 driver using that API
and a third patch making the core do something with that data.  This
would result in something which maintains consistent behaviour over all
regulator drivers, which is my main concern here, and avoids tying up
the TWL4030 driver merge with any debate about how to use information
about the capabilities of the regulator.

I have some regulator API patches I need to test (should be sometime
this week) so I may be inspired to do at least the first patch myself.
I don't think there's any doubt that the core can do something useful
with the information.

> The model you're working with doesn't do a good job of
> component-izing things ... "board" may be "board stack",
> where notions like "the" hardware are fluid.

Most of the development work for the regulator API has been done on
reference platforms with many pluggable boards (often including the PMIC
board) so thought has been given as to how to handle these systems.

For daughtercards other than the primary PMIC (which are vastly more
common in production systems) one approach has been to represent the
daughtercards as a device that gets whatever supplies the daughtercard
has.  The distribution of power within the daughtercard is then be done
by adding child regulators.

> > Your current patch does also set constraints for the voltages if they
> > weren't there previously

> I was thinking that boards which don't need constraints
> shouldn't need to create any ... they could just pass on
> the capabilities of the underlying regulator.

For safety the regulator API won't do anything without being explicitly
told that it's OK to do so - if we were to do this we'd need to have an
explicit flag in the constraints which says that this is what to do.
Constraints are also permission grants.

> Only when that "system" is componentized that way.
> Not all are.

> Modular systems can have plug-in regulator boards;
> constraints on a mainboard would necessarily overlap
> with supported regulator boards ... but the regulators
> themselves would naturally have different constraints.

Indeed.  Like I say, a very large proportion of the development of the
regulator API has been done on reference designs which are built in this
fashion, including both pluggable PMIC boards and other daughtercards.
Normally the primary PMIC cards are handled with conditional code in the
machine file (either compile time or run time) or by registering drivers
for all the PMICs and allowing failed device probes to sort everything
out.  So far handling things this way hasn't been a big deal - there are
usually relatively few PMIC boards out there for a given platform and
the PMIC itself is rarely a major restriction.

This conditional code would normally do the setup that is specific to
each PMIC board, including matching the regulators on the PMIC board
with the rest of the system and any devices on the PMIC board itself
that require supplies.  A lot of the time there is a one to many mapping
between regulators on the PMIC board and power domains in the base
system and there are often additional devices on the PMIC board in
addition to the base board.  It's not unknown for the contraints applied
to not be straight combinations of supply constraints (normally due to a
lack of desire for runtime flexibility on supplies).

At the end of the day board code is still always going to have to at
some point know what regulators are fitted and how they are connected
up.  There are some things we could do to make handling runtime
decisions on this easier, like allowing multiple sets of constraints
and supplies to be supplied so the machine drivers can set up the
various combinations of supplies more easily when that's possible (which
is I think what you were getting at above), but they don't remove the
need for board code to know what's there.

> One way to view this:  what you're calling "regulator"
> constraints are really coming from the "machine".

Yes, of course.  The constraints are applied to the regulator by the
core, they are constraints for the regulator not constraints imposed by
the regulator.

> Those few lines of code that seem to bother you are
> only recognizing that they are, in fact, two very
> different entities.

What's really bothering me is the *location* of the code.  As I've said,
my primary concern is that this introduces what are effectively API
changes which will mean that this driver behaves differently to other
drivers.  Other concerns about precisely what we do with any information
from the regulator driver are very much less important.

> Without changing the regulator core, the only way
> to handle contstraints which come from the actual
> regulators is to force the machine constraints
> to be in-range with respect to whatever regulator
> driver ends up using them.

Modifying the core is, of course, an option.
