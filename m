Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbZBYP1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbZBYP1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762981AbZBYPVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:21:11 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3834 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762971AbZBYPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:21:08 -0500
Date: Wed, 25 Feb 2009 15:17:28 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Message-ID: <20090225151721.GA31637@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902231252.01980.david-b@pacbell.net> <20090224222328.GA21553@sirena.org.uk> <200902241617.22643.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902241617.22643.david-b@pacbell.net>
X-Cookie: Your code should be more efficient!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 04:17:22PM -0800, David Brownell wrote:
> On Tuesday 24 February 2009, Mark Brown wrote:

> > > +	/* maybe force machine-wide voltage constraints to match the
> > > +	 * voltages supported by this regulator.  use the regulator's
> > > +	 * entire range for boards with no particular constraints.
> > > +	 */

> > I'd really rather the second bit weren't here.  I'd like to see a
> > warning for the first part.

> Fixable in an update.  I still think it's better to require less
> manual configuration, not more ... manual configuration is by
> definition error prone; requiring more manual configuration makes

This whole interface is structured around the idea that the consequences
of getting this wrong include things like lasting hardware damage.  This
hardware damage may not be immediately obvious but may develop over time
if components are kept running out of spec, either way it's not likely
to make users happy.

> systems be more fragile.  Which is why I wouldn't naturally want
> to see a warning:  it implies manual configuration is desirable.

If we weren't so reliant on the machine driver getting things right I'd
agree with you.  My thought here is that because there is room for human
error here it'd be good to use the information we do have to flag
potential problems to people, helping catch any mistakes that they make.

> > I'm having a hard time loving this interface for the driver.  It feels
> > fairly cumbersome to have to provide two functions to look up what I'd
> > expect to be static data - I'd be fairly surprised to see it change at
> > runtime. 

> It can be a function of configuration, and I didn't want to force
> such seldom-used data into wasteful standardized-format tables.
> Notice that with the twl4030 code, a functional interface takes
> less space ... and is more flexible, since it copes with the
> voltage options that are defined as "not supported".

Yeah, TWL4030 is pretty special here :/ .  The only gotcha I can see is
having to have a second table with only supported values in it for the
case where you're not allowing the out of spec values but TBH I don't
see that as a big deal.

> Consider also the TPS6235x regulators:  the voltages they support are
> a simple linear function of an index 0..63, and that driver handles
> seven such chips.  64 values * 4 bytes * 7 chips == about 2KB of
> table data ... vs a few dozen bytes of function code.

That's actually the most common case in the regulators I'd seen and is
why I'd suggested doing something like the ALSA dB scales which handle
this nicely - you don't need to actually have a table with all the
values, you just provide parmeters that expresses each sub range.  You
say things like

   DECLARE_TLV_DB_SCALE(mix_tlv, -1500, 300, 0);

As far as hardware requirements go I've seen regulators which provide:

 - A set of irregularly distributed values (usually fairly small).
 - A range of regularly distributed values.
 - A large range of values with several regular ranges in it (usually
   you get higher resolution at the low end).

Either way can be made to work for all of these, the concerns I have are
that the fact that it's a function based interface makes it look like
this might be dynamic data and that it's exposing a bit too much of the
implementation details (see below) which made that suggestion seem even
stronger.

[ALSA dB scale style]
> Another virtue of functional interfaces for enumeration is
> they avoid the need for callers to see and handle a variety
> of different models, like that!!

I'd expect the core to deal with unrolling the data rather than the
consumers, this is why...

> > This mostly applies to the driver interface - on the consumer side it
> > feels a bit cumbersome to use but I can't think of anything that's
> > particularly better. 

> There's a LONG history of functional iterator models, such as
> the one I used.  I think they are clearly better, and don't
> understand why you'd prefer that more cumbersome approach.

...I am, as I say, reasonably OK with it on the consumer side.

The only issue I have with it on the consumer side is that the invalid
slots in the array are visible to users since it feels icky to have
error conditions be part of the normal iteration process for what should
be well known constant data.  I worry that it's going to catch people
out since relatively few regulator drivers do that (the fact that it's
there is an implementation detail for drivers which have holes in the
range of register values they can set).

Thinking about it that could be hidden by mapping the invalid values to
zero or some value that is actually valid instead of returning an error
- not entirely nice but it keeps the pain away from the consumers.

> > An interface that also allows consumers to ask if 
> > particular ranges can be satisfied might help here - it'd be nice for
> > things like MMC that want to check for a relatively small set of
> > voltages or voltage ranges (which I'd expect is the common case).

> Umm, did you look at the MMC patch I sent?  It shows
> how the $SUBJECT interface fits nicely with what the
> MMC framework needs.  mmc_regulator_get_ocrmask() took
> just thirty (ARM) instructions.

> MMC doesn't want to "check" like that.  It wants to get
> a mask of supported voltages, then AND it with the mask
> reported by the MMC/SD/SDIO/eMMC/CE-ATA/... device to
> pick a voltage supported by both host and card.

You can either write the loop the way you have by iterating over the
voltages offered or you can write it by asking for voltage ranges that
the device might want.  It seems like it'd be useful for driver authors
if the core allowed either method so they can use whichever idiom fits
more comfortably with their needs.
