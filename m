Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbZBYXBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbZBYXBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZBYXB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:01:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4186 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZBYXB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:01:28 -0500
Date: Wed, 25 Feb 2009 23:01:24 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Message-ID: <20090225230123.GA5715@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902241617.22643.david-b@pacbell.net> <20090225151721.GA31637@sirena.org.uk> <200902251412.26855.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902251412.26855.david-b@pacbell.net>
X-Cookie: In the next world, you're on your own.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:12:26PM -0800, David Brownell wrote:
> On Wednesday 25 February 2009, Mark Brown wrote:

> > This whole interface is structured around the idea that the consequences
> > of getting this wrong include things like lasting hardware damage.  This
> > hardware damage may not be immediately obvious but may develop over time
> > if components are kept running out of spec, either way it's not likely
> > to make users happy.

> And as I noted:  *hardware* designers don't like to make
> such goofage possible.  So that's not a common scenario.

That's often not possible with software controllable regulators - it's
usually hard to stop them being set to any value they support and the
desire for any additional protection needs to be traded off against
power consumption and space and BoM costs.

> Not for me.  I had seen two and three bit voltage selector fields,
> defining fairly irregular sets of voltages.

> I think the rationale has to do with getting better system-wide
> efficiency, to stretch battery life.  Circuits generating the
> reference voltages can be more efficient if they don't need to
> be continually adjustable over some range(s).

It's certainly not the common case for regulators that people are
contributing to the kernel (most of which seem to be intended to be
primary PMICs).  Make of that what you will :)

> > As far as hardware requirements go I've seen regulators which provide:

> >  - A set of irregularly distributed values (usually fairly small).
> >  - A range of regularly distributed values.
> >  - A large range of values with several regular ranges in it (usually
> >    you get higher resolution at the low end).

> All of which model nicely as a mapping { selector --> voltage }.

> Hardware probably even has a register bitfield holding selector
> values.  Maybe in that third case there's a second bitfield to
> hold selector bits which specify the range.

Yes, you can clearly always do selector->voltage since there's going to
be a finite number of register bits that it'll be possible to set.

> > Either way can be made to work for all of these, the concerns I have are
> > that the fact that it's a function based interface makes it look like
> > this might be dynamic data and that it's exposing a bit too much of the
> > implementation details (see below) which made that suggestion seem even
> > stronger.

> That still doesn't make sense to me.  It doesn't say a thing
> about what it *is* ... just how to find the voltage associated
> with a given index/selector.  

A function that return errors suggests something non-static to me.

> > I'd expect the core to deal with unrolling the data rather than the
> > consumers, this is why...

> I don't see why the core should "unroll" anything at all!
> The regulator driver is already doing that for get_voltage:

> 	get_voltage() {
> 		read selector from hardware
> 		map selector to voltage
> 		return that voltage
> 	}

> So it's trivial for similar code to take the selector as
> a function parameter, and do the same thing.  Repackage
> the existing code a bit; bzzt, done!

Yes, that's a reasonable point (though I'd still like to see the maximum
turn into a static value now I think about it).

> > I worry that it's going to catch people 
> > out since relatively few regulator drivers do that (the fact that it's
> > there is an implementation detail for drivers which have holes in the
> > range of register values they can set).

> It will be fairly common for the regulator to support voltages
> that are disallowed by the machine constraints, though.  That
> can produce "holes" too; and not necessarily only for the lowest
> or highest selector codes.

At present only continous ranges are possible, though.  I can't think of
any systems I've seen that'd want discontinous constraints, though I'm
sure there are some.

> > Thinking about it that could be hidden by mapping the invalid values to
> > zero or some value that is actually valid instead of returning an error
> > - not entirely nice but it keeps the pain away from the consumers.

> The test for an invalid voltage is "v <= 0" regardless.

If you're looking for a bound you'd just check for things within that
bound anyway.  It's if there's explicit "this is an error" return that
people start wanting to do something with it rather than silently ignore
it (we hope, anyway).

> > You can either write the loop the way you have by iterating over the
> > voltages offered or you can write it by asking for voltage ranges that
> > the device might want.

> The MMC stack is written to work the way I described.
...
> True, *other* stacks might want something else:

Indeed, I'm not talking about MMC in particular here - other things are
going to want to ask the same questions.

> > It seems like it'd be useful for driver authors 
> > if the core allowed either method so they can use whichever idiom fits
> > more comfortably with their needs.

> A patch could be added later, when some system needs
> some other model.  I'm not exactly sure what would be
> returned by "asking for a voltage range".  That sounds
> like it might be a different regulator capability model
> than the "discrete voltage options" one.

Yes, I'm suggesting something like:

  int regulator_available_voltage(min, max);

It's wrapping the discrete values for consumers that find that idiom
easier.
