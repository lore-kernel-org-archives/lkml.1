Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbZHLKFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbZHLKFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbZHLKFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:05:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33105 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbZHLKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:05:22 -0400
Date: Wed, 12 Aug 2009 11:05:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
	userspace-consumer)
Message-ID: <20090812100517.GA11227@sirena.org.uk>
References: <20090810200553.GB4652@gandalf> <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf> <20090811094020.GA6762@rakim.wolfsonmicro.main> <1249986616.5807.28.camel@odin> <20090811204914.GB13969@gandalf> <20090811223645.GA4691@sirena.org.uk> <20090812064745.GA17285@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812064745.GA17285@gandalf>
X-Cookie: One FISHWICH coming up!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 09:47:50AM +0300, Felipe Balbi wrote:
> On Tue, Aug 11, 2009 at 11:36:46PM +0100, Mark Brown wrote:

> > This is already handled in kernel by the drivers/power code.  Whenever a
> > power supply updates its status it notifies the subsystem which will
> > then notify user space and also notify any other power supplies which
> > have been configured as being supplied by the changing supply.  This is
> > used by existing drivers for non-autonomous battery chargers to initiate
> > charging (usually via a GPIO connected to the charger).

> but that'll depend very much on the chip being used. Check bq24150, for
> example. We cannot rely on a gpio since we have to tell the charger if

You actually get notification on any change the supply chooses to notify
the core on IIRC.

> it can charger with up to 100mA, up to 500mA or more (in case of a
> dedicated usb charger we can draw up to 2.5A if I'm not wrong, but most
> chargers I've seen source up to 1.5A). A gpio would only be able to tell
> the charger is present or not.

Well, that's just the addition of a second GPIO to put it into fast
charge mode (which has other constraints beyond the system supply
current).  It'd probably help clarity to not refer so directly to the
USB current limits here due to all the stuff in between the USB supply
and the charger.

> > This is all a bit of a sidetrack, though - the issue is if there is an
> > in-kernel part to the SBS charger support.  With the userspace consumer
> > there's nothing at all, even an extremely basic stub which does nothing

> sure, but where do we draw the line between kernel and userspace in this
> case ?

> do we just be sure that information goes to userland and in case there's
> no application monitoring battery we stop charging ? Or do we monitor
> the battery in-kernel ?

I'd be inclined to put at least some of the basic charge cycle into the
kernel but it doesn't concern me too much so long as the user/kernel
interface doesn't expose us to the risk of damaging the battery through
inattention.

> I'd go for monitoring in userland since we might have way too many
> points to be tracking. One might be:

> 1. doing ADC conversions for fetching battery voltage (not so used since most
>    battery chips can report that)
> 2. checking whether we're connect to a usb host or a usb dedicated
>    charger (have to kick usb charger detection as per USB Battery Charger
>    Spec 1.1

Or a wall supply.  The best you can get from the 100mA limit is that
it's not even worth trying a fast charge but that's not the same thing
as being able to do one, having more than that isn't that much of a
reliable guide.

> 3. Priotizing one or other charger (imagine a system with both usb and
>    AC charger support)

It's probably more interesting to think of prioritising between multiple
batteries here - most systems I've seen have power path management which
handles all the incoming power sources and uses them to maintain an
unregulated power domain which is then used as the root supply for the
rest of the system, including the battery chargers.  This takes the
supply selection well out of the domain of charging.

> 4. enabling the charger after figuring out how much current we can draw
>    from that supply

This is the really tricky bit since you need some idea of the load from
the rest of the system if the charger really is able to draw current.
Normally there's a combination of checking various gates to see if it's
possible to start charging with the current parameters and then things
like monitoring the supply voltage to the charger to make sure it's not
drooping and taking corrective action if it does.

My feeling is that in addition to what you're saying the in-kernel side
of things should also describe how the system is wired together since
that's the sort of task the kernel is doing anyway, it's something
that is fixed in the hardware and it's potentially dangerous to get
wrong.

> enabling the charger could be regulator_enable() call.

Assuming the charger also has things like voltage and current control
exposed.  I think I'd expect to see some sort of charger class which
abstracts out the functionality of the charger so that the same user
applications can also be used to set policy for more autonomous
chargers.  Those chargers may require contortions to fit them into the
regulator API depending on the control they provide to the system.  More
simple chargers may well fit cleanly into the regulator API (they're
regulators after all) but that'd be just one example of this class.

Quite how much I'd expect such a soft charger to be able to do for
itself I'm less sure about but I'd be inclined to at least look at doing
the stuff that can be done with only information from the battery in
kernel to make things more consistent for user space.

> > charger will be doing all the management of the regulators).  If the SBS
> > is done entirely in software the kernel at least needs to be able to
> > notice the management software exiting and clean up after it, even if
> > that's all it is able to do for itself.

> ok, now I got your point. Your concerned with the case where a userland
> application, say, crashes and the battery is left for overcharging and
> overheating.

Yes, exactly - there's a real danger of catastrophic system failure if
that happens.
