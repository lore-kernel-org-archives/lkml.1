Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYCEUwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYCEUwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYCEUwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:52:05 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:53439 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbYCEUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:52:03 -0500
Date: Wed, 5 Mar 2008 22:54:09 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MMC: OMAP: Introduce new multislot structure and
	change driver to use it
Message-ID: <20080305205408.GA16229@kedavra.cpe.vivax.com.br>
Reply-To: me@felipebalbi.com
References: <479E27EB.3040502@indt.org.br> <20080207183744.1491c995@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207183744.1491c995@poseidon.drzeus.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 06:37:44PM +0100, Pierre Ossman wrote:
> On Mon, 28 Jan 2008 15:07:23 -0400
> Carlos Aguiar <carlos.aguiar@indt.org.br> wrote:
> 
> > From: Juha Yrjola <juha.yrjola@solidboot.com>
> > 
> > Introduce new MMC multislot structure and change driver to use it.
> > 
> > Note that MMC clocking is now enabled in mmc_omap_select_slot()
> > and disabled in mmc_omap_release_slot().
> > 
> > Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
> > Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> > Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > ---
> 
> I still think this muxed mmc host thing is a bad idea, but it's your nightmare...

Not nightmare. OMAP1/2 have mmc/sd/sdio controller supporting one or
more mmc cards sharing the same bus.

> 
> > +
> > +/* Access to the R/O switch is required for production testing
> > + * purposes. */
> > +static ssize_t
> > +mmc_omap_show_ro(struct device *dev, struct device_attribute *attr, char *buf)
> > +{
> > +	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
> > +	struct mmc_omap_slot *slot = mmc_priv(mmc);
> > +
> > +	return sprintf(buf, "%d\n", slot->pdata->get_ro(mmc_dev(mmc),
> > +							slot->id));
> > +}
> > +
> > +static DEVICE_ATTR(ro, S_IRUGO, mmc_omap_show_ro, NULL);
> > +
> 
> This is unrelated to the slot stuff and should be in its own patch. Also, it should probably be in the core, not a driver.
> 
> > +
> > +	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_MMC_HIGHSPEED |
> > +		    MMC_CAP_SD_HIGHSPEED;
> 
> This is also unrelated. From what I've seen, the OMAP is a SD controller and does not support high speed MMC. The fact that you also conditionally set the max frequency later also suggests that this code is entirely incorrect.
> 

Not true. I can't show you not even parts of the technical documentation
but OMAP has mmc/sd/sdio controller. On OMAP1/2 it handles several mmc
cards sharing the same bus.

And that's what mmc multislot is doing. Probably it still needs some
tweks though. But that's up to Carlos.

> > +
> > +	r = mmc_add_host(mmc);
> > +	if (r < 0)
> > +		return r;
> > +
> > +	if (slot->pdata->name != NULL) {
> > +		r = device_create_file(&mmc->class_dev,
> > +					&dev_attr_slot_name);
> > +		if (r < 0)
> > +			goto err_remove_host;
> > +	}
> > +
> > +	if (slot->pdata->get_ro != NULL) {
> > +		r = device_create_file(&mmc->class_dev,
> > +					&dev_attr_ro);
> > +	}
> > +
> 
> You have a bit of a race here with userspace in case you use the uevent to trigger things.
> 
> -- 
>      -- Pierre Ossman
> 
>   Linux kernel, MMC maintainer        http://www.kernel.org
>   PulseAudio, core developer          http://pulseaudio.org
>   rdesktop, core developer          http://www.rdesktop.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Best Regards,

Felipe Balbi
me@felipebalbi.com
http://blog.felipebalbi.com
