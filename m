Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZLCNGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZLCNGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZLCNGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:06:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46630 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753688AbZLCNGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:06:22 -0500
Date: Thu, 3 Dec 2009 13:06:27 +0000
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
Message-ID: <20091203130627.GA31254@rakim.wolfsonmicro.main>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
X-Cookie: Pushing 30 is exercise enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 01:46:30PM +0100, Daniel Mack wrote:
> At the moment, regulator operations are done from individual mmc host
> drivers. This is a problem because the regulators are not claimed
> exclusively but the mmc core enables and disables them according to the

This is historical, they can all be converted to regulator_get_exclusive()
so the move to the core (while good) isn't required for this reason.

>  	case MMC_POWER_OFF:
> -		if(host->vcc &&
> -		   regulator_is_enabled(host->vcc))
> -			regulator_disable(host->vcc);
> +		if(mmc->vcc && mmc->vcc_enabled) {
> +			regulator_disable(mmc->vcc);
> +			mmc->vcc_enabled = 0;
> +		}

Can the MMC core actually tolerate the MMC power not getting killed when
expected?  My understanding from previous discussion was that it wasn't
able to do so.  If it is then conversion to using regulator_get_exclusive()
isn't desirable, of course.
