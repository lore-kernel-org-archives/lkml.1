Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbZCRUif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbZCRUif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZCRUd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:33:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2090 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZCRUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:33:24 -0400
Date: Wed, 18 Mar 2009 20:33:20 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
Message-ID: <20090318203317.GA6299@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903171115.06685.david-b@pacbell.net> <20090317200828.GA7060@sirena.org.uk> <200903181225.11444.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903181225.11444.david-b@pacbell.net>
X-Cookie: Save gas, don't use the shell.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 12:25:11PM -0700, David Brownell wrote:
> On Tuesday 17 March 2009, Mark Brown wrote:

> > The drivers can essentially ignore the physical status of the regulator
> > when they start,

> That is, shared supplies should adopt a different model?

I think that's a bit strong, once we get past init the problem pretty
much goes away AFAICT.

> That approach can't be used with drivers, as for MMC slots,
> which need to ensure they start with a "power off" state as
> part of a clean reset/init sequence.

Pretty much.  They could cope if they used the enable/disable bounce
hack but if they urgently need to have a specific power state they won't
be able to cope with shared regulators anyway so it doesn't really make
any odds.

> Maybe "sharable" should be a regulator constraint flag, so
> the regulator framework can avoid committing nastiness like
> allocating multiple consumer handles for them.

Or vice versa - it's as much a property of the consumer driver that it
requires exclusivity.  From the point of view of the regulator API
there's very little difference between the two cases.

Note that for well behaved consumers that use mapped supply names we
already know about them all in advance anyway...

> > It will also work well with a 
> > late_initcall which disables any unreferenced regulators -

> The $SUBJECT patch will prevent such things from existing.

I sent a patch backing that specific change out along with the
late_initcall() patch.

> Also, regulator use that kicks in before that particular
> late_initcall will still see self-inconsistent state in
> the regulator framework ... of course, $SUBJECT patch (and
> its predecessors) is all about preventing self-inconsistency.

A driver that can cope with sharing the regulator is not going to be
able to observe anything here: it must always enable the regulator when
it is using it even if it is already enabled (since otherwise some other
consumer could cause it to be turned off) and it should expect that the
regulator might be enabled by something else.  It can't do an unbalanced
disable since otherwise it could be reversing an enable something else
did.  It's also not possible for it to inspect the use count.

If a consumer can't play with that model then I'm reasonably happy with
it having to state any additional requirements it has in some way - if
nothing else it gives us a bit of documentation about what's going on.

> That self-inconsistency doesn't seem to concern you much.

I think it's more that I'm viewing the use count as being useful
information which the API can take advantage of ("do any consumers
actually want this on right now?").  I think we should be able to handle
this without changing the use count and that this is preferable because
otherwise we make more work with shared consumers, which should be the
simplest case.

The trick is getting the non-shared regulators into sync with the
internal status, ideally without doing things like bouncing supplies
during init.  I think either using regulator_force_disable() or saying
that the consmer wants exclusive access on get and then bumping the use
count for it if the regulator is already enabled ought to cover it.
I've not thought the latter option through fully, though.
