Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYKJQ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYKJQ4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYKJQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:56:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1414 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbYKJQ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:56:32 -0500
Date: Mon, 10 Nov 2008 16:56:27 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Message-ID: <20081110165625.GE12804@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <1226322857.6727.117.camel@vega.slimlogic.co.uk> <200811100743.34741.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811100743.34741.david-b@pacbell.net>
X-Cookie: f u cn rd ths, itn tyg h myxbl cd.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 07:43:34AM -0800, David Brownell wrote:

> The regulator itself supports exactly three states/modes.

> You seem to imply that the programming interface should be
> exposing four -- {ACTIVE, STANDBY } x { ON, OFF } -- which

Yes, that's expected model.

> doesn't reflect how the hardware works.

Most hardware has a similar level of squashing in it and certainly the
functional effect is always the same.  It's done this way partly to
allow a complete configuration to be done before enabling the regulator
and partly because most clients don't need to worry about the modes used
and just care about enabling and disabling - for most things the
operating modes are fixed in the board constraints.

> See below; the key conceptual problem in this interface is
> probably the assumption that the Linux CPU isn't sharing
> control over the regulator.  So regulator_disable() can't
> imply REGULATOR_MODE_OFF ... another CPU may need to keep
> it in some other state.

regulator_disable() needn't imply that the regulator will actually be
off - regulator API already does internal reference counting for shared
regulators and...

> So for example when any of the three requestors asks for the
> regulator to go ACTIVE it will do so.  This means you can have
> cases like:

...this sounds like the same thing done in hardware.

>  - One CPU (running Linux, say) asks to disable() the regulator
>     * implemented by clearing that CPU's bit in a mask
>     * is_enabled() tests that bit and says "no, not enabled"
>  - Another CPU needs it active
>     * request might be coupled to the nSLEEP2 signal
>     * thus get_mode() will say it's ACTIVE

> So you see why enable/disable is orthogonal to MODE_OFF.

Not really.  The mode reflects the characteristics of the regulator when
it is enabled (things like the quality of the output, efficiency and the
amount of power that can be delivered) rather than the regulator being
turned on or off.  In both cases I'd expect that get_mode() would report
ACTIVE.

The issue you see here is a divergence between the software-requested
state and the actual physical state of the regulator.

> It's true that it won't be OFF unless the Linux CPU is
> not requesting it ("disabled" its request) ... but the
> converse is false, because of the non-Linux requestor(s).

My first instinct here would be to have the software simply reflect the
state requested by the CPU and ignore the other enable sources.  My
second instinct would be to have is_enabled() report the actual state
and leave it at that.  I'm having a hard time thinking of a hardware
design that could tolerate too much uncoordinated control of the
regulators.

I'm also wondering if part of what we need to do is add separate out the
reporting paths for the actual and requested status?  At the minute we
only report the actual status and there's no indication of the logical
status which does create some confusion here.
