Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYKMTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYKMTsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYKMTkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:40:21 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:42676 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755804AbYKMTkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:40:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Date:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=B0afWGKCoIlTYxrIYEux0jbYzgoqqpsd9K1UzXhB40+Mppi4k9kgLTHh7gRfpBjnSC9CdhNGOfKKw5jFKxwhFJdbtvVrTFdDWgcK4mp5S/oytk21FnZzBN2vwphB7G0MFXD28LjMM/dksUFYfPW/Wsxyr7oPctCXfc2g48TByhw=  ;
X-YMail-OSG: DrhVNegVM1lMjwj1VdbrOaZF5hVcGIXE9VrlfCLH3zClOms3xL99GZaUQAzeJL3JIxagHfrmwtCXRvVxUInP4dJw8H6eEE1lmrFOEtftc.VNeALDhBCmAJNOWRCgIffwK.9K5hQGiMBIpUHtOm.nrN.VlyMka55PhelAaFg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200811102056.20008.david-b@pacbell.net> <20081112112525.GA8767@sirena.org.uk>
In-Reply-To: <20081112112525.GA8767@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 13 Nov 2008 11:40:15 -0800
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200811131140.15646.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008, Mark Brown wrote:
> On Mon, Nov 10, 2008 at 08:56:19PM -0800, David Brownell wrote:
> > On Monday 10 November 2008, Mark Brown wrote:
>
> > > regulator_disable() needn't imply that the regulator will actually be
> > > off -
> 
> > Would you say that also for regulator_ops.disable() though?
> 
> If we ignore regulator_force_disable() (which isn't used yet) for the
> moment I'd actually say that in your case with non-software enables it's
> reasonable for it to still be powered by some other part of the system.

I'll read that as a "yes"...

... but I don't know what you mean by "non-software enables".  Maybe you
mean "non-Linux"?  One of the other inputs would normally be controlled
by software -- just not from Linux.  Maybe it'd help if you think about
a system structured like:

  - one ARM running Linux for UI, Internet access, etc
  - another one running some realtime cell modem firmware
  - both coordinating through a PMIC

So the regulator's hardware ENABLE signal is is fed by an OR gate from
both CPUs.  Similarly with a signal that's high to put the regulator
in "normal" mode (else it goes into low-current "standby" when enabled).

Those two signals (enable, normal-mode) would be under software control.
Or hardware ... the key point is that some inputs aren't from Linux.


> Mainly because it's proably easier to just ignore the other enables than
> it is to explain to the rest of the system that there are others it
> can't know about.

My recently posted v2 of this patch solves this easily enough.

It suffices to have one method report the actual hardware state
(if that includes OFF as well as NORMAL, STANDBY, etc) ... that
seems to be what you mean by calling one value "primary".  Others
can report what Linux has requested.

And having regulator_ops.get_mode() be the call to report that
hardware state is straightforward.  Especially once you consider
that the actual state *will* be what Linux requested, except in
cases like:  (a) shared regulators, like the scenario above, for
which I suspect twl4030 is the first case in Linux; (b) hardware
fault handling, like overcurrent/overtemp shutdown; and maybe
(c) "smart" regulators that switch modes automatically.

That seems to be a minimal-disruption change.

 
> > > > So for example when any of the three requestors asks for the
> > > > regulator to go ACTIVE it will do so.  This means you can have
> > > > cases like:
> 
> > > ...this sounds like the same thing done in hardware.
> 
> > Seems to me more like a three input OR gate.  No counters.  ;)
> > At least, if you ignore the additional arbitration between
> > ACTIVE, STANDBY, and OFF modes.  (Highest one wins...)
> 
> Logically that's what the regulator API is doing, it's just that
> currently it doesn't support reconfiguration of shared regulators.

Not entirely true.  In this case the issue is exposing regulator
output state ... the regulator_ops suffice for inputs, which would
combine with other inputs to determine the actual regulator state
that's reported using by regulator_ops.get_mode().


> If 
> you remember the pre-submission versions you looked at they had support
> for computing the most restrictive voltage constraint from multiple
> clients, this sounds like the same thing done in hardware for the
> regulator mode.

Yes ... the current "Dynamic Regulator Mode Switching" (DRMS) code
does some of that:  the point of having different client handles
is that those handles can encapsulate different load constraints.
And then when the load changes, the requested mode can change.


> The view of the regulator API is that the operating configuration of the
> regulator (including not only the mode but also the voltage or current)
> is done separately to enabling or disabling it.

OK, but configuration inputs to the regulator drivers are
a different issue from how to expose regulator state.

It seems we've almost converged on the result of get_mode()
being that regulator state output, which is a function of more
than just the inputs from Linux.


> The expectation when writing this was that anything 
> software controlled would be fully software controlled.

The problem is that the current code *also* ignores the fact
that hardware status is a function of more inputs than just
those from Linux.  Like thermal shutdown from overcurrent.
The configuration inputs might be fine, but the output of
a regulator necessarily incorporates other inputs.

The top reason to display system state in sysfs is to support
troubleshooting ... and hiding the actual system state makes
that needlessly difficult.

- Dave
