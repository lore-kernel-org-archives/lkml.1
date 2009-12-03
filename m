Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZLCNO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZLCNO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZLCNO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:14:27 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:35765 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbZLCNO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:14:26 -0500
Date: Thu, 3 Dec 2009 14:14:23 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
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
Message-ID: <20091203131423.GV14091@buzzloop.caiaq.de>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
 <20091203130627.GA31254@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203130627.GA31254@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 01:06:27PM +0000, Mark Brown wrote:
> On Thu, Dec 03, 2009 at 01:46:30PM +0100, Daniel Mack wrote:
> > At the moment, regulator operations are done from individual mmc host
> > drivers. This is a problem because the regulators are not claimed
> > exclusively but the mmc core enables and disables them according to the
> 
> This is historical, they can all be converted to regulator_get_exclusive()
> so the move to the core (while good) isn't required for this reason.

Is it? What if you share one regulator for two slots? While this isn't a
problem I have met in real life, this should still be considered.

The problem I _did_ see, however, was a warning when the regulator was
marked as always_on in its constraints. What happens then is that
regulator_is_enabled() will always return 1, causing the pxamci code to

 - call regulator_disable() on power off, but
 - _not_ call regulator_enable() in the oposite case

and that brings the regulator's reference count out of sync.

Making those drivers claim their regulators exclusively _does_ solve the
first problem, but not the latter.

> >  	case MMC_POWER_OFF:
> > -		if(host->vcc &&
> > -		   regulator_is_enabled(host->vcc))
> > -			regulator_disable(host->vcc);
> > +		if(mmc->vcc && mmc->vcc_enabled) {
> > +			regulator_disable(mmc->vcc);
> > +			mmc->vcc_enabled = 0;
> > +		}
> 
> Can the MMC core actually tolerate the MMC power not getting killed when
> expected?  My understanding from previous discussion was that it wasn't
> able to do so.  If it is then conversion to using regulator_get_exclusive()
> isn't desirable, of course.

I would expect the power to be killed when the last user stops using it.
Which should result in the same effect if you only have one host, one
regulator, and one user.

Daniel

