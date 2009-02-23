Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZBWWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZBWWE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZBWWES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:04:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4751 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZBWWER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:04:17 -0500
Date: Mon, 23 Feb 2009 22:04:06 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090223220359.GA3601@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902091624.01802.david-b@pacbell.net> <20090210224851.GA6408@sirena.org.uk> <200902231245.44360.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231245.44360.david-b@pacbell.net>
X-Cookie: You are as I am with You.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 12:45:44PM -0800, David Brownell wrote:

> > another with a TWL4030 driver using that API 
> > and a third patch making the core do something with that data.

> Best IMO to switch the last two around.  Effectively
> there'd be one patch "add new features to regulator
> core", followed by the first of a set of "implement
> those new features in the driver for regulator X".

> And in fact that's what I've done with the two patches
> I'll be sending in a moment.

The reason I'm suggesting splitting things up the way I am is that it
separates out the TWL4030 driver (which looks very mergable to me right
now) from the behaviour changes.  Ordering things that way makes it
clear what the dependency is.  Another way of splitting it out would be
to remove the new API from the TWL4030, make that the first patch, then
have further patches adding the new API and the TWL4030 code to use it.

I don't see any reason why the TWL4030 regulator support needs to be
blocked on adding the new API and it makes review easier to keep them
separate.

> > This 
> > would result in something which maintains consistent behaviour over all
> > regulator drivers,

> It's already consistent, even without such patches!!

> There is no driver which pays attention to regulator(_dev)
> constraints that does it any differently than this one.

That's because nobody's doing it at all; once we add a custom
implementation in one driver we then need to police each driver
individually for consistency with the new interface.  If the logic is
factored out then that problem doesn't exist and drivers don't need to
reimplement any of it.

> > > > Your current patch does also set constraints for the voltages if they
> > > > weren't there previously

> > > I was thinking that boards which don't need constraints
> > > shouldn't need to create any ... they could just pass on
> > > the capabilities of the underlying regulator.

> > For safety the regulator API won't do anything without being explicitly
> > told that it's OK to do so - if we were to do this we'd need to have an
> > explicit flag in the constraints which says that this is what to do.
> > Constraints are also permission grants.

> I like to avoid flags unless they're absolutely required.
> In this case my initial reaction is to say that hooking up
> the components in the first place was the permission grant.

The trouble is we don't know what's connected to the regulator without
being told - even if some of the components hanging off the supply are
visible to software that's no guarantee that all of them are.  Keeping
the responsibility in the hands of the machine driver helps ensure that
users have made a concious decision that their settings are OK for their
design.

> > Indeed.  Like I say, a very large proportion of the development of the
> > regulator API has been done on reference designs which are built in this
> > fashion, including both pluggable PMIC boards and other daughtercards.

> That doesn't seem to have escaped its development cage yet.  ;)

There's a couple on their way to mainline right now, should make it in
the next merge window hopefully.  Unfortunately they're for systems that
aren't very completely supported in mainline right now which makes them
less useful as examples than they might be.  There's also none of them
where there's any immediate prospect of more than one of the PMIC board
options going into mainline.

> > Normally the primary PMIC cards are handled with conditional code in the
> > machine file (either compile time or run time) or by registering drivers

> Fair enough.  I'd de-emphasize "conditional", since that sounds
> way too much like #ifdeffing.  The source code should just call
> something like is_pmic_cardX(), and not care how that works.

It's normally a combination of the two - normally you don't get any form
of board ID readback and you get things like mutually exclusive options
for I2C or SPI control due to shared multi function pin setup that can't
be autoprobed entirely safely, for example.  Once you've decided on the
control bus it's normally safe to do autoprobing, though.

> Then what would you call constraints by/from the regulator?

They're subsumed within the constraints supplied by the machine driver
at the minute.

> I suggest updating your terminology.  "machine constraints"
> would be much more clear for what's there now:  they relate
> to the machine.  Other constraints (regulator, consumer)
> relate to the other components ... the ones for which they
> are an adjective.

Yeah, I kind of agree.  To avoid confusion from changing the names I'd
be tempted to go for something like "regulator driver constraints" but
it's not desparately nice.

> I don't mind moving it ... later, after the regulator
> core has proper support for decoupling machine-specific
> constraints from regulator-specific ones.  I view that
> code as a workaround for a current limitation of that
> core, so like all such workarounds it should vanish
> when it's no longer relevant.

I'd strongly suggest that if you're adding workarounds like this it's
worth at least calling them out in the changelog.  To be honest I'm not
100% clear why this new feature is essential to supporting the TWL4030 -
I can see that it could be useful but I'm not clear on what makes it
essential for this driver.
