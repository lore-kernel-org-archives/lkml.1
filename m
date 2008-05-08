Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbYEHURB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbYEHURB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764427AbYEHUQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:16:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2340 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764334AbYEHUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:16:46 -0400
Date: Thu, 8 May 2008 21:16:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
Message-ID: <20080508201641.GA16945@sirena.org.uk>
Mail-Followup-To: Harald Welte <laforge@gnumonks.org>,
	Liam Girdwood <lg@opensource.wolfsonmicro.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1209742841.12502.40.camel@odin> <20080508063538.GC6105@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508063538.GC6105@prithivi.gnumonks.org>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 08:35:38AM +0200, Harald Welte wrote:

> The PCF506xx have a concept of global power management states,
> particularly important are the ON and STANDBY states in this context.
> Every regulator has a property whether it is enabled in none, one or
> both of the global power management states.

That's a problem we've encountered - at least the WM8350 and (to a
lesser extent) the WM8400, both of which have had support implemented in
terms of the regulator API, have similar states.

> Do you think it would be worth to export something like this in the
> generic API, too?  It's probably quite hard, since there are devices
> that actually use the PCF506xx STANDBY state during suspend-to-ram, but
> other devices leave the PCF506xx in the ON state and just disable the
> individual regulators using I2C register writes.

Indeed - where a STANDBY-style state is used the likely implementation
is going to be something like setting a GPIO at some point towards the
very end of suspending to activate it (if it's done directly by software
at all).

> I think there's probably no clean way how to integrate this, since the
> question remains: who makes the decision (and manages the contraints) of
> when to transition into the STANDBY state.   Nevertheless a read-only
> sysfs attribute might still be interesting.

At present the regulator API pretty much works on the assumption that
this will be very system specific and probably not amount to much in
software terms since the CPU is likely to be suspended or off while
these modes are active so the transitions can adequately be handled by
machine specific code.

What might be more readily generalisable would be configuration for what
happens in the very low power states.  The WM8350 driver has a
device-specific API which provides access for the soft configuration for
this state since the chip allows the system to set the state of the
regulator when it is suspended.  This gives a second set of settings
that are activated when the system enters a low power state.  This
caters for most cases (where this will be statically configured by the
board setup code) but if it were generalised into the regulator core
then it would allow use in conjunction with the device_*_wakeup() stuff,
letting drivers say which of their supplies they need when suspended.  I
don't know how much demand there would be for that, though, and it'd be
an extension to the API.

This gets rather more interesting when the system has a secondary PMIC -
with multiple PMICs it's much more likely that one of them could be
placed into a low power state while the system is running.  Off the top
of my head that may be adequately handled by having a master regulator
driver in the tree supplying the secondary PMIC which puts it into a low
power state when it is not needed.  It's probably best tackled when we
have some experience with such systems.
