Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZBWVAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZBWVAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZBWVAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:00:15 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:32313 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751416AbZBWVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:00:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=6fjt3eAZwQVbFsbcTbBLyrk/Yp+fJ1YSnzYhvVylHDq8fGfRGvE4YAhHjTMYj0VLf3HCIzWyS2kPls5EoLiJcYKZzfHc3uIPr5H7KpxcOWPECKV9xkEvWPbRrzJ/qoT7eZVyvIOBFV9V/HTBgGA80qGzhJIEXixq9EuFMR+GUpw=  ;
X-YMail-OSG: BVm0bnQVM1lql9G7O8CqXHAgJjbCMjbiagGYv0tbDcQq.5tuqGGOs6_APnLJgmDXGzMeEBvCZPPXBoGv3RshfclZ2UyrfMwZMGBPBTrhMU.lVA3T9iMMqcUoFuZmcQOxEMrLJpnOs5JR6LXRLzsOO.2h
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Mon, 23 Feb 2009 12:45:44 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902091624.01802.david-b@pacbell.net> <20090210224851.GA6408@sirena.org.uk>
In-Reply-To: <20090210224851.GA6408@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902231245.44360.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009, Mark Brown wrote:

> What I would suggest that you do for this is submit a patch allowing the 
> regulators to supply a set of constraints when they register (but not
> doing anything with them),

That pretty much needs to allow a list of discrete
voltages, not just be a range ... and have a way
for clients to retrieve that list.  Else I have a
very hard time imagining how to plug in MMC supplies
without writing the type of regulator-specific code
that this framework is intended to supplant.


> another with a TWL4030 driver using that API 
> and a third patch making the core do something with that data.

Best IMO to switch the last two around.  Effectively
there'd be one patch "add new features to regulator
core", followed by the first of a set of "implement
those new features in the driver for regulator X".

And in fact that's what I've done with the two patches
I'll be sending in a moment.


> This 
> would result in something which maintains consistent behaviour over all
> regulator drivers,

It's already consistent, even without such patches!!

There is no driver which pays attention to regulator(_dev)
constraints that does it any differently than this one.


> > > Your current patch does also set constraints for the voltages if they
> > > weren't there previously
> 
> > I was thinking that boards which don't need constraints
> > shouldn't need to create any ... they could just pass on
> > the capabilities of the underlying regulator.
> 
> For safety the regulator API won't do anything without being explicitly
> told that it's OK to do so - if we were to do this we'd need to have an
> explicit flag in the constraints which says that this is what to do.
> Constraints are also permission grants.

I like to avoid flags unless they're absolutely required.
In this case my initial reaction is to say that hooking up
the components in the first place was the permission grant.

 
> > Only when that "system" is componentized that way.
> > Not all are.
> 
> > Modular systems can have plug-in regulator boards;
> > constraints on a mainboard would necessarily overlap
> > with supported regulator boards ... but the regulators
> > themselves would naturally have different constraints.
> 
> Indeed.  Like I say, a very large proportion of the development of the
> regulator API has been done on reference designs which are built in this
> fashion, including both pluggable PMIC boards and other daughtercards.

That doesn't seem to have escaped its development cage yet.  ;)


> Normally the primary PMIC cards are handled with conditional code in the
> machine file (either compile time or run time) or by registering drivers
> for all the PMICs and allowing failed device probes to sort everything
> out.  So far handling things this way hasn't been a big deal - there are
> usually relatively few PMIC boards out there for a given platform and
> the PMIC itself is rarely a major restriction.

Fair enough.  I'd de-emphasize "conditional", since that sounds
way too much like #ifdeffing.  The source code should just call
something like is_pmic_cardX(), and not care how that works.

 
> > One way to view this:  what you're calling "regulator"
> > constraints are really coming from the "machine".
> 
> Yes, of course.  The constraints are applied to the regulator by the
> core, they are constraints for the regulator not constraints imposed by
> the regulator.

Then what would you call constraints by/from the regulator?

I suggest updating your terminology.  "machine constraints"
would be much more clear for what's there now:  they relate
to the machine.  Other constraints (regulator, consumer)
relate to the other components ... the ones for which they
are an adjective.


> > Those few lines of code that seem to bother you are
> > only recognizing that they are, in fact, two very
> > different entities.
> 
> What's really bothering me is the *location* of the code.  As I've said,
> my primary concern is that this introduces what are effectively API
> changes which will mean that this driver behaves differently to other
> drivers.  Other concerns about precisely what we do with any information
> from the regulator driver are very much less important.

I don't mind moving it ... later, after the regulator
core has proper support for decoupling machine-specific
constraints from regulator-specific ones.  I view that
code as a workaround for a current limitation of that
core, so like all such workarounds it should vanish
when it's no longer relevant.

- Dave

