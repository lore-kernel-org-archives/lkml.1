Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZCBVAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZCBVAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZCBVAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:00:03 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51396 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZCBVAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:00:00 -0500
Date: Mon, 2 Mar 2009 21:59:56 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc6+misc] MMC: regulator utilities
Message-ID: <20090302215956.3f355eee@mjolnir.ossman.eu>
In-Reply-To: <200902261348.30617.david-b@pacbell.net>
References: <200902081037.06645.david-b@pacbell.net>
	<20090226202055.GE8595@sirena.org.uk>
	<200902261312.42720.david-b@pacbell.net>
	<200902261348.30617.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 13:48:30 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Add optional glue between MMC and regulator stacks, using a new
> regulator interface to learn what voltages are available.
> 
> This is intended to be selected and driven by MMC host adapters.
> It only handles reusable parts of the regulator-to-MMC glue; the
> adapter drivers will have access to details that affect how this
> is used.  Examples include when to use multiple voltage rails or
> configure (internal or external) level shifters.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> Changes from previous version:  adapter must select this, and
> callers now pass in the regulator.  mmc_regulator_set_ocr()
> is still not tested, mmc_regulator_get_ocrmask() passed sanity
> testing.
> 
> Pierre:  Mark may have a need for this soonish.  The omap_hsmmc
> code will want it at some point.
> 

I have no insight into the regulator stuff, so I'm going to have to
trust you on this. :)

Some nitpicking though:

> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -14,3 +14,10 @@ config MMC_UNSAFE_RESUME
>  	  This option is usually just for embedded systems which use
>  	  a MMC/SD card for rootfs. Most people should say N here.
>  
> +config MMC_REGULATOR
> +	bool
> +	depends on REGULATOR
> +	help
> +	  Select this if your MMC host adapter driver wants helper
> +	  utilities for accessing power rails.
> +

Is there a need for a special Kconfig for this? Can't we just build
these two whenever REGULATOR is defined? Or always, provided the
regulator API is present even when the code isn't.

> +/**
> + * mmc_regulator_set_ocr - set regulator to match host->ios voltage
> + * @host: mmc host whose supply voltage will be changed
> + * @supply: regulator to use
> + *
> + * MMC host drivers may use this to enable or disable a regulator using
> + * a particular supply voltage.  This would normally be called from the
> + * set_ios() method.
> + */
> +int mmc_regulator_set_ocr(struct mmc_host *host, struct regulator *supply)
> +{

Why not pass the vdd directly? Saves a few dereferences if nothing else.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
