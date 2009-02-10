Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZBJAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZBJAYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZBJAYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:24:06 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:25116 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752223AbZBJAYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:24:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2+ueorLrFnjfGFSkeZzbLLvVD7rqsdO2Tx1hAXtfEBkU1LogKZl3it/UxywdRLskP2PDM/p6c2yvMcvLkj3Wbo6BVtyJvAavDkVrDk9wyixBPVSWoIsfB3ISDCNDa7kVNWCV74fJiRd+2sey62zevP+k8vJh3ZabTG9eCAP6w0c=  ;
X-YMail-OSG: L2IQqOIVM1mpMcMpBmJiZG87Urcu6BK0WudHtCmCD6DOXf2kGi1ILGHymagXNGBHv61Aa0GYZhK4d9CD7B1ZWAI2vnb6VeB7Eco_kSCohKiUUqikIB2uwA6KgMxIr3JRKCeekTcZMorEj_LCfOSRrh4zYVOATkSgRUvB84wiejy6iaWVcnuUoEd31eHB
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Mon, 9 Feb 2009 16:24:01 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902081604.29905.david-b@pacbell.net> <20090209172714.GA17637@sirena.org.uk>
In-Reply-To: <20090209172714.GA17637@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091624.01802.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, Mark Brown wrote:
> On Sun, Feb 08, 2009 at 04:04:29PM -0800, David Brownell wrote:
> > On Sunday 08 February 2009, Mark Brown wrote:
> 
> > > If we're going to do this I think it'd be better to push it into the
> > > core and let the regulators pass in a set of constraints so that the
> > > behaviour will be consistent between drivers.
> 
> > Maybe, but there is no such mechanism right yet.
> > When it's created, then this could switch over.
> 
> Since you appear to be writing the code already... :)

Not for the regulator core, though.  Switching from
a simplistic constraint engine to one that starts to
handle a more realistic "union of constraints" model
would be doable, but is a bit more off-topic work than
I'd want to sign up for just now.


> > > I'd also expect to have the registration fail or at least issue a
> > > warning if the code kicks in since that indicates that the board
> > > constraints have been set up incorrectly.
> 
> > A warning might make sense in some cases ... that's
> > something I would expect to see from the regulator
> > core, though.
> 
> That's what I'm suggesting should happen - that things like this should
> be implemented in the core so that the behaviour of the API remains
> consistent for users moving between platforms and everyone benefits from
> new features.
> 
> >                Example, I see no "max < min" checks
> > triggering registration errors.
> 
> Not a bad idea, though.  The core currently doesn't do much checking of
> the constraints but that's as much because nobody spent the time on it
> as anything else.  To the extent it's a deliberate design decision it's
> because the constraints and consumer lists are where the information
> about what's possible on a given system comes from and so the checking
> that can be done by software is relatively minor.

Or as I put it earlier:  the current constraint model is
a bit simplistic.

Such things can *EASILY* be over-done; starting under-done
isn't a bad model.  Better to collect a few real examples of
how/why "under-done" needs to be improved, than overdesign
from the start.  (And I've seen some power "constraint"
frameworks that seemed way overdone.)

 
> > > There's a reasonable chance 
> > > that the fixed up constraints will still need to be changed for the
> > > board to be configured properly and things may end up being driven out
> > > of spec, potentially causing damage.
> 
> > I don't see that happening ... all that code does is
> > tighten existing constraints to match what the hardware
> > can do.  The result is just a subset of the range the
> > board already said was OK.  If no valid subset exists,
> 
> The trouble is that this code should only do anything if the board code
> provided a configuration that can't be supported by the hardware, which
> is a bit of a red flag.  I'd expect it'd end up catching things like the
> user typing extra digits by mistake (this has definitely happened when
> writing consumer drivers).

The model you're working with doesn't do a good job of
component-izing things ... "board" may be "board stack",
where notions like "the" hardware are fluid.

And in particular, "can't be supported" was NOT an issue
in the scenarios I gave.  The same mainboard could easily
support two regulators with different selections of output
voltages.  The problem was the model where the constraints
from the mainboard would be specific to one regulator,
instead of just to the mainboard.


> Your current patch does also set constraints for the voltages if they
> weren't there previously

I was thinking that boards which don't need constraints
shouldn't need to create any ... they could just pass on
the capabilities of the underlying regulator.


> > I can easily imagine having things partially set up, and
> > not really caring whether, on a particular board, those
> > initial constraints are really the most specific ones
> > applicable.  One component tolerates a range of 1V8..3V6
> > maybe, but on any given board it can be hooked up to any
> > supply that's even partially in-range.
> 
> The pattern you're describing is very much that for consumer and
> regulator drivers.  They should work with as wide a set of constraints
> as possible to allow them to be used on different systems with different
> capabilities and needs - allowing this is essential for the API to be
> usable since so many chips are flexible about the supplies they can use.
> 
> It's different for the machine constraints since they are by definition
> specific to a given system.

Only when that "system" is componentized that way.
Not all are.

Modular systems can have plug-in regulator boards;
constraints on a mainboard would necessarily overlap
with supported regulator boards ... but the regulators
themselves would naturally have different constraints.

One way to view this:  what you're calling "regulator"
constraints are really coming from the "machine".

Those few lines of code that seem to bother you are
only recognizing that they are, in fact, two very
different entities.

Without changing the regulator core, the only way
to handle contstraints which come from the actual
regulators is to force the machine constraints
to be in-range with respect to whatever regulator
driver ends up using them.

- Dave

