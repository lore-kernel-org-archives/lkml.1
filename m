Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZHKWhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZHKWhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZHKWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:37:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54269 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZHKWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:37:00 -0400
Date: Tue, 11 Aug 2009 23:36:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org
Message-ID: <20090811223645.GA4691@sirena.org.uk>
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811204914.GB13969@gandalf>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Smart Battery System Design (was: Re: Question about
 userspace-consumer)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 11:49:18PM +0300, Felipe Balbi wrote:
> On Tue, Aug 11, 2009 at 11:30:16AM +0100, Liam Girdwood wrote:
> > On Tue, 2009-08-11 at 10:40 +0100, Mark Brown wrote:

> > > It's more complex than that - those are the limits at the USB port that
> > > define the power that can be drawn by the system.  The actual power

> yeah, I understand quite well the usb standard.

OK, good - it wasn't clear from what you said since obviously one of the
parameters the battery charger has is the current it pushes into the
battery (which is constrained by but very removed from the current
limits on any supplies).

> > > No matter what you're still going to need at least some of the code
> > > in-kernel in order to handle the monitoring daemon exiting.  For
> > > example, if the battery is in fast charge then something will need to
> > > back the charger off at least as the charge completes (if not
> > > immediately user space exits) otherwise the battery or entire system is
> > > likely to be damaged.

> What I mean is that on SBS design, the "charger daemon" doesn't have to
> handle the charging algorithm per se since the battery itself reports to
> charger the best condition for it to be charged, but still we need means
> for a userland application to see that a power source was attached (via
> power supply interface, be it USB, AC or whatever we want) and tell the
> charger to _start_charging_, no ?

This is already handled in kernel by the drivers/power code.  Whenever a
power supply updates its status it notifies the subsystem which will
then notify user space and also notify any other power supplies which
have been configured as being supplied by the changing supply.  This is
used by existing drivers for non-autonomous battery chargers to initiate
charging (usually via a GPIO connected to the charger).

> That's when I thought a call to regulator_enable() would seem plausible.

Yes, that's a good time to kick off a charge (other constraints
permitting) however that's done.

This is all a bit of a sidetrack, though - the issue is if there is an
in-kernel part to the SBS charger support.  With the userspace consumer
there's nothing at all, even an extremely basic stub which does nothing
more than shut the charger off when userspace exits would deal with the
issue I have here.  For dumb chargers we need to make sure that
something is taking responsibility for making sure that the battery is
not mistreated.

> > Generally, I'd expect the kernel side to provide a guaranteed *safe*
> > environment for charging wrt system stability and battery status. A
> > simple state machine would probably suffice.

> and wrt SBS, that would mean basically writing a driver for that Smart
> Batery Charger and the Smart Battery devices creating means for some
> entity to tell _start_charging_ based on the presence of a power source.

For me the critical thing is that we ensure that the charger won't be
left charging at anything more than a trickle charge when there's
nothing monitoring the battery status.  If the charger can do the SBS
charger stuff autononmously it can look after itself (but the use of the
regulator API becomes more questionable for those devices since the
charger will be doing all the management of the regulators).  If the SBS
is done entirely in software the kernel at least needs to be able to
notice the management software exiting and clean up after it, even if
that's all it is able to do for itself.
