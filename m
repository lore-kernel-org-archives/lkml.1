Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKMVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKMVyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYKMVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:53:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2383 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYKMVx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:53:57 -0500
Date: Thu, 13 Nov 2008 21:53:46 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20081113215346.GA3199@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200811102056.20008.david-b@pacbell.net> <20081112112525.GA8767@sirena.org.uk> <200811131140.15646.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811131140.15646.david-b@pacbell.net>
X-Cookie: May cause drowsiness.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 11:40:15AM -0800, David Brownell wrote:

> ... but I don't know what you mean by "non-software enables".  Maybe you
> mean "non-Linux"?  One of the other inputs would normally be controlled
> by software -- just not from Linux.  Maybe it'd help if you think about
> a system structured like:

Yes, I mean non-Linux.  The fact that there may be some other software
running on the other hardware isn't terribly interesting here - it's an
implementation detail the user may not even be aware of.

> And having regulator_ops.get_mode() be the call to report that
> hardware state is straightforward.  Especially once you consider
> that the actual state *will* be what Linux requested, except in
> cases like:  (a) shared regulators, like the scenario above, for
> which I suspect twl4030 is the first case in Linux; (b) hardware
> fault handling, like overcurrent/overtemp shutdown; and maybe
> (c) "smart" regulators that switch modes automatically.

So.  This does rather assume that the mode should be expected to change
in a software visible fashion and that this should be the main thing
reported.  What the existing drivers are doing is making get_mode() the
inverse of set_mode().  

Of the cases you have above I'd be surprised if there were any devices
that didn't implement (b) and (c) is provided to at least some extent by
the DC-DC convertors in the existing Wolfson drivers (one of the modes
they offer automatically adjusts the regulation mode based on load).

If reporting the full state via get_mode() the error reporting case in
particular would seem to be more involved than adding an off state -
you'd probably want an explicit out of regulation state, for example.
If a regulator goes out of regulation it's clearly neither off nor
functioning properly in the mode the hardware is configured for.

> Not entirely true.  In this case the issue is exposing regulator
> output state ... the regulator_ops suffice for inputs, which would
> combine with other inputs to determine the actual regulator state
> that's reported using by regulator_ops.get_mode().

Right, if we assume that it reports the instantaneous hardware state.

> It seems we've almost converged on the result of get_mode()
> being that regulator state output, which is a function of more
> than just the inputs from Linux.

I'm not sure about that to be honest.  From that point of view it'd seem
we'd also need to consider all the other configuration that the
regulator might have since there's no reason why that couldn't also be
overridden by other sources too.

> > The expectation when writing this was that anything 
> > software controlled would be fully software controlled.

> The problem is that the current code *also* ignores the fact
> that hardware status is a function of more inputs than just
> those from Linux.  Like thermal shutdown from overcurrent.
> The configuration inputs might be fine, but the output of
> a regulator necessarily incorporates other inputs.

That's all good and I agree - what you're saying that the only facility
in the existing API for reporting back the current hardware status is
the error notifier callbacks and that this is really rather too limited.

> The top reason to display system state in sysfs is to support
> troubleshooting ... and hiding the actual system state makes
> that needlessly difficult.

No argument here, either.  What I'm not so sure about is that get_mode()
alone is the ideal way to report this.  It feels to me like we wold be
better off exposing both physical and configured versions of all the
existing status for the regulators (not just mode) plus some additional
information for error conditions.  This caters for any configuration
changes outside of software control and would let errors report without
masking any other physical state.
