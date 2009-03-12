Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZCLMBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZCLMBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZCLMB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:01:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2213 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZCLMBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:01:25 -0400
Date: Thu, 12 Mar 2009 12:01:21 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: init fixes
Message-ID: <20090312120119.GB24376@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903111932.16317.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903111932.16317.david-b@pacbell.net>
X-Cookie: War is an equal opportunity destroyer.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 06:32:15PM -0800, David Brownell wrote:

> Make the regulator setup code cope more consistently with
> regulators undesirably left enabled by the bootloader.

First up I'd just like to make it absolutely clear that I agree that
this is a feature we should have - it's obviously useful.

>  * Unless the "boot_on" or "always_on" machine constraints
>    were set, disable() the regulator.  This gives drivers
>    a clean start state:  enable state matches usecount,
>    regardless of boot_on/always_on flag state.

At the minute the regulator constraints have the property that if you
pass a zero-initialised set of constraints the regulator API will not do
anything other than allow you to read the state of the regulator - any
action taken by the regulator API must be explicitly permitted by code.
This change will mean that users will have to explicitly mark any
regulators that are needed as enabled or we'll do unfortunate things.  

It is a particular problem for multi-function devices like pcf50633
which not only register all their regulators by default but also embed
constraints within the general pcf50633 platform data.  If the user
simply turns on the regulator driver in their config they'll get this
behavior if they don't edit the code.  Even with regulator code I'd not
be surprised if people were bitten by this for things like the memory or
a CPU core without regulator based DVFS.

You've addressed some of the use cases for this by providing devmode but
it's still a big incompatible change, especially at this point in the
development cycle where we've got at most a couple of weeks to the merge
window.  We could do this without introducing the incompatibility by
adding a new flag (eg, boot_off) which machine constraints need to
explicitly set to enforce this behaviour or by having something machine
drivers can call to say "now power off any regulators that look idle".

I'm not 100% agaist doing things the way you suggest since there is 
appeal in having boot_on be more of a boolean but I do feel that if
we're going to go this way we should do it more gently.  For example, we
could merge a patch now which warns loudly that this will happen and
then after the 2.6.30 merge window actually implement it.  This would
reduce merge issues for machine support coming in via other trees; we're
rather late in the development cycle to be putting this in right now.
Not everyone will read a warning but there is some chance they might and
there's also a chance they'll test in -next.  We should also provide a
temporary Kconfig which actually enables the behaviour if people request
it.

>  * To help make some integration stages easier, add a new
>    "devmode" machine constraint where state the bootloader
>    left isn't touched, but enable state and usecount may
>    not match.  (System boots but some drivers act odd ...
>    debuggable.  System dies part way through booting ...
>    often painful.)

This also addresses things like the reverse engineering use case where
people genuinely don't know what's going on and want to use the API to
inspect the state of the regulators.

I do wonder if we can't come up with a different way of expressing
devmode - a different name like dont_disable that more directly
expresses what the constraint does might be more obvious.  Something
that can enable this globally may also be convenient.

The code itself is OK.
