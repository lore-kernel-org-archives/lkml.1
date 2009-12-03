Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZLCNWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZLCNWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZLCNWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:22:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42126 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755570AbZLCNWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:22:37 -0500
Date: Thu, 3 Dec 2009 13:22:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Cliff Brake <cbrake@bec-systems.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-mmc@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: move regulator handling to core
Message-ID: <20091203132241.GB31533@rakim.wolfsonmicro.main>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
 <20091203130627.GA31254@rakim.wolfsonmicro.main>
 <20091203131423.GV14091@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203131423.GV14091@buzzloop.caiaq.de>
X-Cookie: Sign here without admitting guilt.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 02:14:23PM +0100, Daniel Mack wrote:
> On Thu, Dec 03, 2009 at 01:06:27PM +0000, Mark Brown wrote:

> > This is historical, they can all be converted to regulator_get_exclusive()
> > so the move to the core (while good) isn't required for this reason.

> Is it? What if you share one regulator for two slots? While this isn't a
> problem I have met in real life, this should still be considered.

I agree, this is a configuration which I have also seen, but there was a
strong insistence that the power off had to function as expected.  An
approach which allows shared regulators is generally always preferable
since it copes with a wider range of system designs.

> The problem I _did_ see, however, was a warning when the regulator was
> marked as always_on in its constraints. What happens then is that
> regulator_is_enabled() will always return 1, causing the pxamci code to

...

> Making those drivers claim their regulators exclusively _does_ solve the
> first problem, but not the latter.

Yeah, there's currently an assumption that the constraints will be
suitable for the driver there.  A driver that can handle sharing should
always cope here, it's one reason to prefer them.

> > >  	case MMC_POWER_OFF:
> > > -		if(host->vcc &&
> > > -		   regulator_is_enabled(host->vcc))
> > > -			regulator_disable(host->vcc);
> > > +		if(mmc->vcc && mmc->vcc_enabled) {
> > > +			regulator_disable(mmc->vcc);
> > > +			mmc->vcc_enabled = 0;
> > > +		}

> > Can the MMC core actually tolerate the MMC power not getting killed when
> > expected?  My understanding from previous discussion was that it wasn't
> > able to do so.  If it is then conversion to using regulator_get_exclusive()
> > isn't desirable, of course.

> I would expect the power to be killed when the last user stops using it.
> Which should result in the same effect if you only have one host, one
> regulator, and one user.

Yes, it's always fine in that case (modulo always_on and/or regulators
without power control).  This goes back to the thing about using
regulator_get_exclusive(), the message given was that the MMC drivers
really needed to be able to guarantee that the power would be removed
when that was requested.

Like I say, if there isn't a *strict* requirement but it's only
desirable (possibly strongly desirable) then your approach is obviously
preferable.
