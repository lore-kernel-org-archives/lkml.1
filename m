Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbZCMBib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbZCMBib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZCMBiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:38:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3946 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZCMBiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:38:21 -0400
Date: Fri, 13 Mar 2009 01:38:15 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
Message-ID: <20090313013813.GK24376@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903121335.25368.david-b@pacbell.net> <20090312210545.GJ24376@sirena.org.uk> <200903121602.55570.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903121602.55570.david-b@pacbell.net>
X-Cookie: War is an equal opportunity destroyer.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:02:55PM -0800, David Brownell wrote:
> On Thursday 12 March 2009, Mark Brown wrote:

> > Previously the per-consumer reference count would've meant that they
> > couldn't interfere with other consumers - they could set their own
> > state but not reverse an enable something else had done.

> They still can't ... *unless* they're already buggy.

As previously noted they could've worked happily via bouncing their
state to match the physical state first; it's not nice or a good idea
(which is why I am happy with your patch) but, well, not everyone pays
attention to warnings and errors :(

> And, as a new thing not currently addressed well in code, you
> are talking about "non-shared" handles.

You are missing my point here; this is mostly about documentation.  The
exclusive access issue is with devices that can't tolerate any
arbitration and need the regulator to go into the state they're
requesting - if the consumer is finding itself doing something like turn
off a regulator which it did not enable itself then it's clearly not
able to play nicely with other drivers sharing the same resource without
extra communication.  This may be because the driver is doing things
that aren't really appropriate and perhaps ought to be done via
constraints if at all; it may also be because the hardware that's being
controlled demands it.

If everyone is nice and careful about what they're doing it'll not make
any difference at all either way.  Especially in the hardware
requirements case I'd hope it never even comes up that it'd make a
difference.

> One could as easily have "handle" and "regulator" be the
> same ... so the get/put idioms could work like they do
> elsewhere in the kernel.

I really don't see that there is any meaningful difference here; from
the point of view of the consumer the fact that the thing it gets back
is a handle to a structure the core uses to keep track of the consumer
rather than the underlying hardware object is an implementation detail
that shouldn't make any difference to them.  In terms of the programming
model it seems like a layering violation to know the difference between
one opaque structure and another.

> See above.  Currently constraints are hidden for "consumers",
> behind functional accessors like regulator_set_voltage().
> There are no explicit constraint objects, as there are for
> the machines.

The current interface has been driven by the needs of the users: the
majority of consumers want to do one operation on a regular basis -
normally that's enable/disable, most devices are just powering
themselves up and down, though for some things voltage changes are much
more common (DVFS being the prime example).  Overall it's been fairly
similar to the clock API in terms of usage pattern.

In terms of looking at redesigning the API I feel we're getting ahead of
ourselves here and should be working more for stability until we run
into problems that force us to make big changes.  Right now it seems
better to focus on improving the support for real systems in mainline
and addressing any issues that they see so that we've got something to
learn from when doing any redesign and can minimise the amount of
integration churn that is created.
