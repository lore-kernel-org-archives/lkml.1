Return-Path: <linux-kernel-owner+w=401wt.eu-S1762437AbZBYWMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762437AbZBYWMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZBYWMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:12:33 -0500
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:24551 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752139AbZBYWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:12:31 -0500
X-Greylist: delayed 86527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 17:12:31 EST
X-Yahoo-Newman-Id: 9922.78680.bm@omp414.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MwLLU7PAoED2ilToL+wnYw/rNuua7VysDm7OX8meBWpoSTu1ImC7RUbfn6Sr+zZxlOS/ffH42vl9uE0/9Ytt4coltRA3mvh2ueOTVxUQkb5B/83FZPlA31Dq8rH/n69SNbFUfdoEi0kFgLtjiB4b6n+5JkpN5skx+Tug24rsjvw=  ;
X-YMail-OSG: rTHowKYVM1nD5VXisumN2WnMC9VGsB1Urk4Cq9gFZ6zx5UucC1DDT_pgkvcKXK1AKfHGBNbEAQd5s.GRu0rBobK3CIE3mhBawiBm0fi7vWl8zpzxVDAzKGTuzq3LueDAziG3u1LpQYLScC11A4xmD33miUQk42rA2LORSSPSZ9RSIKrh0z6WYnpa5l0q
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Wed, 25 Feb 2009 14:12:26 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902241617.22643.david-b@pacbell.net> <20090225151721.GA31637@sirena.org.uk>
In-Reply-To: <20090225151721.GA31637@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902251412.26855.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009, Mark Brown wrote:
> On Tue, Feb 24, 2009 at 04:17:22PM -0800, David Brownell wrote:
> 
> > Fixable in an update.  I still think it's better to require less
> > manual configuration, not more ... manual configuration is by
> > definition error prone; requiring more manual configuration makes
> 
> This whole interface is structured around the idea that the consequences
> of getting this wrong include things like lasting hardware damage.  This
> hardware damage may not be immediately obvious but may develop over time
> if components are kept running out of spec, either way it's not likely
> to make users happy.

And as I noted:  *hardware* designers don't like to make
such goofage possible.  So that's not a common scenario.

I'll update the patch to be noisier about such situations,
since you insist.  And since braindamaged hardware designers
have actually been observed in the wild.  ;)


> > > 	 It feels
> > > fairly cumbersome to have to provide two functions to look up what I'd
> > > expect to be static data - I'd be fairly surprised to see it change at
> > > runtime. 
> 
> > It can be a function of configuration, and I didn't want to force
> > such seldom-used data into wasteful standardized-format tables.
> > Notice that with the twl4030 code, a functional interface takes
> > less space ... and is more flexible, since it copes with the
> > voltage options that are defined as "not supported".
> 
> Yeah, TWL4030 is pretty special here :/ .

Those "not supported" cases seem to be mostly fallout from using
four bit voltage selectors, and wanting future family members to
be able to add new "supported" cases.  A slightly more typical
model would be to have those bit values be "undefined".

Part of the space savings comes of course from tables being able
to use milliVolts, not microVolts ... two bytes for each entry
instead of four.  :)


> > Consider also the TPS6235x regulators:  the voltages they support are
> > a simple linear function of an index 0..63, and that driver handles
> > seven such chips.  64 values * 4 bytes * 7 chips == about 2KB of
> > table data ... vs a few dozen bytes of function code.
> 
> That's actually the most common case in the regulators I'd seen

Not for me.  I had seen two and three bit voltage selector fields,
defining fairly irregular sets of voltages.

I think the rationale has to do with getting better system-wide
efficiency, to stretch battery life.  Circuits generating the
reference voltages can be more efficient if they don't need to
be continually adjustable over some range(s).


> As far as hardware requirements go I've seen regulators which provide:
> 
>  - A set of irregularly distributed values (usually fairly small).
>  - A range of regularly distributed values.
>  - A large range of values with several regular ranges in it (usually
>    you get higher resolution at the low end).

All of which model nicely as a mapping { selector --> voltage }.

Hardware probably even has a register bitfield holding selector
values.  Maybe in that third case there's a second bitfield to
hold selector bits which specify the range.


> Either way can be made to work for all of these, the concerns I have are
> that the fact that it's a function based interface makes it look like
> this might be dynamic data and that it's exposing a bit too much of the
> implementation details (see below) which made that suggestion seem even
> stronger.

That still doesn't make sense to me.  It doesn't say a thing
about what it *is* ... just how to find the voltage associated
with a given index/selector.  

 
> [ALSA dB scale style]
> > Another virtue of functional interfaces for enumeration is
> > they avoid the need for callers to see and handle a variety
> > of different models, like that!!
> 
> I'd expect the core to deal with unrolling the data rather than the
> consumers, this is why...

I don't see why the core should "unroll" anything at all!
The regulator driver is already doing that for get_voltage:

	get_voltage() {
		read selector from hardware
		map selector to voltage
		return that voltage
	}

So it's trivial for similar code to take the selector as
a function parameter, and do the same thing.  Repackage
the existing code a bit; bzzt, done!


> > > This mostly applies to the driver interface - on the consumer side it
> > > feels a bit cumbersome to use but I can't think of anything that's
> > > particularly better. 
> 
> > There's a LONG history of functional iterator models, such as
> > the one I used.  I think they are clearly better, and don't
> > understand why you'd prefer that more cumbersome approach.
> 
> ...I am, as I say, reasonably OK with it on the consumer side.
> 
> The only issue I have with it on the consumer side is that the invalid
> slots in the array are visible to users since it feels icky to have
> error conditions be part of the normal iteration process for what should
> be well known constant data.

They are "fault" conditions (like "page fault"), not errors.  ;)


> I worry that it's going to catch people 
> out since relatively few regulator drivers do that (the fact that it's
> there is an implementation detail for drivers which have holes in the
> range of register values they can set).

It will be fairly common for the regulator to support voltages
that are disallowed by the machine constraints, though.  That
can produce "holes" too; and not necessarily only for the lowest
or highest selector codes.

IMO it's reasonable to expect users of a programming interface
to handle common cases like that.  :)

 
> Thinking about it that could be hidden by mapping the invalid values to
> zero or some value that is actually valid instead of returning an error
> - not entirely nice but it keeps the pain away from the consumers.

The test for an invalid voltage is "v <= 0" regardless.

I'll switch the return code for those out-of-range cases to
use zero, and update the spec for regulator_list_voltage()
to include that third outcome.


> > MMC doesn't want to "check" like that.  It wants to get
> > a mask of supported voltages, then AND it with the mask
> > reported by the MMC/SD/SDIO/eMMC/CE-ATA/... device to
> > pick a voltage supported by both host and card.
> 
> You can either write the loop the way you have by iterating over the
> voltages offered or you can write it by asking for voltage ranges that
> the device might want.

The MMC stack is written to work the way I described.
I don't see that model changing any time soon; most MMC
adapters don't seem to have a switchable Vdd rail, so
they've got a fixed mask reporting 3.2-3.4V support and
won't have any reason to use (or depend on) the regulator
framework.


True, *other* stacks might want something else:

> It seems like it'd be useful for driver authors 
> if the core allowed either method so they can use whichever idiom fits
> more comfortably with their needs.

A patch could be added later, when some system needs
some other model.  I'm not exactly sure what would be
returned by "asking for a voltage range".  That sounds
like it might be a different regulator capability model
than the "discrete voltage options" one.


My focus this time around was on exposing the regulator
capabilities to the core to support two simple use cases:
(a) validating machine constraints, (b) supporting MMC/SD
usage idiom, so the omap_hsmmc driver can fully decouple
from the twl4030-family regulators.

I'll send an updated version of this patch in a bit.

- Dave

