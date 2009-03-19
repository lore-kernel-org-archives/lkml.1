Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZCSQ77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZCSQ77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZCSQ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:59:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37481 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZCSQ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:59:47 -0400
Date: Thu, 19 Mar 2009 16:59:42 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
Message-ID: <20090319165941.GF1598@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903181225.11444.david-b@pacbell.net> <20090318203317.GA6299@sirena.org.uk> <200903181414.14563.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903181414.14563.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 02:14:14PM -0700, David Brownell wrote:
> On Wednesday 18 March 2009, Mark Brown wrote:

> > I think it's more that I'm viewing the use count as being useful
> > information which the API can take advantage of ("do any consumers
> > actually want this on right now?").

> In that case, I don't understand why you didn't like
> the previous versions of this patch ... which just
> forced the regulator off (at init time) if that count
> was zero.

There are two issues which I raised in response to that patch.  One is
that this is a fairly substantial interface change which will affect
existing constraints without warning and will therefore break people
using the current code.  At the minute you can't rely on boot_on being
set for any regulator which is enabled when Linux starts.  This is the
most serious issue - a quick survey leads me to expect that turning off
regulators without boot_on would break most existing systems somehow.

The other is that I'm fairly sure that we'll end up running into systems
where the setup at startup is not fixed and forcing the regulator state
immediately on regulator registration is likely to cause problems
dealing gracefully with such systems.  You addressed that by adding
devmode, though ideally that should have a clearer name.

> > I think we should be able to handle 
> > this without changing the use count and that this is preferable because
> > otherwise we make more work with shared consumers, which should be the
> > simplest case.

> That's what the earlier versions of this patch did,
> but you rejected that approach ... patches against
> both mainline (which is where the bug hurts TODAY),
> and against regulator-next.

I have given you two suggestions which will allow your MMC driver to use
mainline without impacting other drivers.  I've also provided some
suggestions for how we could introduce changes in the regulator core to
support this better.

> Also, I don't see why you'd think a shared consumer
> would be the "simplest", given all the special rules
> that you've already noted as only needing to kick in
> for those cases.

Simplest for the consumers - they just need to do a get followed by
basic reference counting, they don't need to (and can't, really) worry
about anything else.

> > The trick is getting the non-shared regulators into sync with the
> > internal status,

> I don't see why that should need any tricks.  At
> init time you have that state and the regulator;
> and you know there are no consumers.  Put it into

Realistically we don't have that information at the minute.  For the
most part we have the physical state and we may also have some
constraint information but we can't rely on the constraint information
right now.  The fact that we can't rely on the constraint information
means that we can't tell if a regulator is enabled because something is
using it at the minute or if it's just been left on because that was the
default or similar.

> a self-consistent state at that time ... done.

> There are really only two ways to make that state
> self-consistent.  And you have rejected both.

Both of the approaches you have suggested change the interfaces and
cause problems for existing users with no warning to allow them to
transition.  Changing the reference count does avoid the problems with
powering things off but it causes other problems in doing so, ones that
look harder to resolve.

When looking at bringing the use count in sync with the physical state
during startup we have to deal with the fact that we can't currently
rely on having information about the desired state of the hardware at
the time the regulator is registered.  We need to make an API change of
some kind to get that information.

> > during init. ?I think either using regulator_force_disable() or saying

> The force_disable() thing looks to me like an API design
> botch.  As you said at one point, it has no users.  And
> since the entire point is to bypass the entire usecount
> scheme ... it'd be much better to remove it.

As the documentation says it was originally added for error handling
cases where there is a danger of hardware damage.  In that situation
you really do want to power off immediately without reference to any
other state.

> > that the consmer wants exclusive access on get and then bumping the use
> > count for it if the regulator is already enabled ought to cover it.
> > I've not thought the latter option through fully, though.

> The problem I have with your approach here is that you
> have rejected quite a few alternative bugfixes applying
> to a common (and simple!!) configuration, but you haven't
> provided an alternative that can work for MMC init.

I have given you a number of suggestions which should work for MMC init.
These are:

 - Have the MMC style consumers use regulator_force_disable() to disable
   an enabled regulator on startup.
 - Have the MMC style consumers do an enable()/disable() pair to disable
   an enabled regulator on startup.
 - Changing the way the new behaviours are specified so that they don't
   change the behaviour of existing constraints (eg, by adding a new
   constraint flag or by having consumers request exclusive access).
 - Providing a transition method to warn about a pending change in
   behaviour, ideally along with a way to request that behaviour
   immediately (which could be deprecated and removed once the default
   is changed).

The first two should work with current mainline and continue to work if
either of the other two is implemented, though they could be removed
after that has happened.

The biggest reason for the pushback here is that everything you have
posted so far changes the way the interface works for existing users.
