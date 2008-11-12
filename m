Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbYKLLZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbYKLLZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYKLLZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:25:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2588 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYKLLZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:25:31 -0500
Date: Wed, 12 Nov 2008 11:25:27 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Message-ID: <20081112112525.GA8767@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200811100743.34741.david-b@pacbell.net> <20081110165625.GE12804@sirena.org.uk> <200811102056.20008.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811102056.20008.david-b@pacbell.net>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 08:56:19PM -0800, David Brownell wrote:
> On Monday 10 November 2008, Mark Brown wrote:

> > > imply REGULATOR_MODE_OFF ... another CPU may need to keep
> > > it in some other state.

> > regulator_disable() needn't imply that the regulator will actually be
> > off -

> Would you say that also for regulator_ops.disable() though?

If we ignore regulator_force_disable() (which isn't used yet) for the
moment I'd actually say that in your case with non-software enables it's
reasonable for it to still be powered by some other part of the system.
Mainly because it's proably easier to just ignore the other enables than
it is to explain to the rest of the system that there are others it
can't know about.

> Less surprising/confusing would be if regulator_{en,dis}able() did
> its own refcounting and called down to regulator_dev when changing
> a per-client refcount to/from zero.  (Easy patch, for later.)

Yeah, either way is fine for me - don't know if Liam has a strong
opinion.  The main benefit of not doing it is that encourages people to
avoid consumers sharing the clients which causes problems when clients
share the regulator.

> And, hrm, kerneldoc for regulator_is_enabled() says it returns
> a refcount, not boolean; but the refcount is unavailable to the
> regulator_ops method returning that value.

Easiest to just update the documentation to reflect reality.

> > > So for example when any of the three requestors asks for the
> > > regulator to go ACTIVE it will do so.  This means you can have
> > > cases like:

> > ...this sounds like the same thing done in hardware.

> Seems to me more like a three input OR gate.  No counters.  ;)
> At least, if you ignore the additional arbitration between
> ACTIVE, STANDBY, and OFF modes.  (Highest one wins...)

Logically that's what the regulator API is doing, it's just that
currently it doesn't support reconfiguration of shared regulators.  If
you remember the pre-submission versions you looked at they had support
for computing the most restrictive voltage constraint from multiple
clients, this sounds like the same thing done in hardware for the
regulator mode.

> > > So you see why enable/disable is orthogonal to MODE_OFF.

> > Not really.  The mode reflects the characteristics of the regulator when
> > it is enabled ...

> That answer doesn't make much sense to me; plus, kerneldoc
> for regulator_get_mode() -- which essentially just calls down
> to regulator_ops.get_mode() -- says it returns the "current"
> mode.  NOT some potential future mode.  Giving the "current"
> mode implies asking the hardware what it's doing right now.

This is because you are viewing the mode as including the enabled state
while the regulator API views the mode as being largely orthogonal to
the operating mode.  This is the key point, most of what you're saying
here seems to spring from this disconnect.

The view of the regulator API is that the operating configuration of the
regulator (including not only the mode but also the voltage or current)
is done separately to enabling or disabling it.  For most clients the
configuration will be done statically by the machine driver, they will
never consider the configuration of the regulator at all and will simply
enable or disable it.  This is partly because the configuration is often
system specific and partly because a large proportion of consumers
aren't interested in any more detail than that.  

It is true that the configuration is largely irrelevant when a regulator
isn't enabled but this isn't unusual.

The kerneldoc should be updated to say "the mode currently configured by
Linux when the regulator is enabled" or similar, I guess.  A similar
issue applies to the documentation for all the other configuration
readback functions.  The expectation when writing this was that anything
software controlled would be fully software controlled.

> Consider also the scenario above, where Linux calls enable()
> and has requested STANDBY mode.  The regulator will instead
> be in ACTIVE state; answering STANDBY seems quite wrong.

Depends who's asking, really.  If you want to know what Linux is doing
for making operational decisions or software debugging then reporting
standby is reasonable - the fact that it's getting higher quality
regulation shouldn't upset it at all.  If you want to know what the
hardware is doing it's less so.

> (Just like answering STANDBY when it's really OFF...)

This is the same issue with enable/mode separation.

> > The issue you see here is a divergence between the software-requested
> > state and the actual physical state of the regulator.

> In a general sense, yes ... but this framework splits that
> state into a "mode" and an "enable" flag (called "state" in

Right, as discussed previously.

> sysfs, which doesn't reduce confusion at all).

It's in there now, unfortunately.

> > > It's true that it won't be OFF unless the Linux CPU is
> > > not requesting it ("disabled" its request) ... but the
> > > converse is false, because of the non-Linux requestor(s).

> > My first instinct here would be to have the software simply reflect the
> > state requested by the CPU and ignore the other enable sources.

> Mine is to have get_mode() report the actual hardware state,

Again, this comes back to the mode/enable merging.

> matching kerneldoc ... and thus the $SUBJECT patch.  Also, I
> have no set_mode(), and thus no mode "requested by the CPU"
> through this framework.

If you're not going to allow anything in Linux to configure the mode of
the regulator then the mode is only going to be useful for diagnostic
purposes (this is mostly what the readback is useful for anyway) so it's
all relatively academic.

> > My 
> > second instinct would be to have is_enabled() report the actual state
> > and leave it at that.

> But *which* actual state?  I'd say that reporting this CPU's
> enable/request bit *is* reporting actual hardware state:  the
> request line managed by regulator_ops.disable()/enable().

I had meant the physical state of the regulator since you were very keen
on exposing that (as opposed to simply ignoring the other enables which
had been the first option).

> > I'm having a hard time thinking of a hardware 
> > design that could tolerate too much uncoordinated control of the
> > regulators.

> True; the coordination here is done in hardware.  There
> are "scripts" that get downloaded into the hardware, and
> which update things on various hardware state changes.

Indeed.  That is pretty much standard for these parts - you obviously
need configuration for initial power up at least and normally there will
be a set of alternative settings activated on suspend too.  The unusual
thing is having something else controlling the power states while the OS
is active.

> > I'm also wondering if part of what we need to do is add separate out the
> > reporting paths for the actual and requested status?  At the minute we
> > only report the actual status and there's no indication of the logical
> > status which does create some confusion here.

> Makes sense.  Record "requested_mode" in "struct regulator_dev"
> and expose a new sysfs attribute for it.  Should I update
> the $SUBJECT patch to do that too?

It should be a separate patch, I'd say.

Thinking about it I'm not sure if the hardware or logical state should
be the primary.  In terms of debugging power consumption and so on the
physical state is probably the more important one but from the point of
view of Linux it's the logical state that matters most since that's what
Linux is actually doing (IYSWIM).
