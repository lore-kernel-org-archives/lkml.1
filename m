Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbZHRP1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbZHRP1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZHRP1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:27:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58535 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975AbZHRP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:27:20 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Adrian Hunter'" <adrian.hunter@nokia.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.arm.linux.org.uk>
References: <60037.192.168.10.88.1250546653.squirrel@dbdmail.itg.ti.com> <4A8A4FC1.1090206@nokia.com>
Subject: RE: [PATCH] omap_hsmmc: Fix for the db clock failure message
Date: Tue, 18 Aug 2009 10:26:45 -0500
Message-ID: <006501ca2018$4bb7a170$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acof0IIb48bsCq8CSYO0oKRq22IuXQARq5KA
In-Reply-To: <4A8A4FC1.1090206@nokia.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Adrian Hunter [mailto:adrian.hunter@nokia.com]
> Sent: Tuesday, August 18, 2009 1:53 AM
> To: Madhusudhan Chikkature
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; linux-
> omap@vger.kernel.org; linux-arm-kernel@lists.arm.linux.org.uk
> Subject: Re: [PATCH] omap_hsmmc: Fix for the db clock failure message
> 
> Madhusudhan Chikkature wrote:
> > This patch applies on top of the series "[PATCH V2 0/32] mmc and
> omap_hsmmc
> > patches" posted by Adrian Hunter.
> >
> > -------------------------------------------------
> >
> >
> >
> > This patch removes the error message "Failed to get debounce clock.."
> printed
> > out by the HSMMC driver on OMAP3430. The debounce clock needs to be
> handled only
> > for OMAP2430.
> 
> I have a suggestion that may make it tidier.
> 
> What about renaming host->dbclk_enabled to host->got_dbclk and leaving it
> alone
> after it is set in the probe function.  Then create a macro to use in
> conditions:
> 
> #define have_dbclk(host) (cpu_is_omap2430() && (host)->got_dbclk)
> 
> So the following:
> 
> -	if (host->dbclk_enabled)
> +	if (cpu_is_omap2430() && host->dbclk_enabled) {
>  		clk_disable(host->dbclk);
> +		host->dbclk_enabled = 0;
> +	}
> 
> becomes:
> 
> -	if (host->dbclk_enabled)
> +	if (have_dbclk(host))
>  		clk_disable(host->dbclk);
> 
> Or alternatively, forget the macro, and let the code always compile in:
> 
> -	if (host->dbclk_enabled)
> +	if (host->got_dbclk)
>  		clk_disable(host->dbclk);
> 
In both the cases how about the enable path? We want to enable the debounce
clock only for OMAP2430, Right? Otherwise we will still end up throwing an
error message for 3430 if we check the result of clk_enable for db clock. 

Regards,
Madhu

> 
> >
> > Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
> > ---
> >  drivers/mmc/host/omap_hsmmc.c |   63 +++++++++++++++++++++++++++-------
> --------
> >  1 file changed, 41 insertions(+), 22 deletions(-)
> >
> > Index: linux-2.6/drivers/mmc/host/omap_hsmmc.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/mmc/host/omap_hsmmc.c
> > +++ linux-2.6/drivers/mmc/host/omap_hsmmc.c
> > @@ -735,8 +735,10 @@ static int omap_hsmmc_switch_opcond(stru
> >  	/* Disable the clocks */
> >  	clk_disable(host->fclk);
> >  	clk_disable(host->iclk);
> > -	if (host->dbclk_enabled)
> > +	if (cpu_is_omap2430() && host->dbclk_enabled) {
> >  		clk_disable(host->dbclk);
> > +		host->dbclk_enabled = 0;
> > +	}
> >
> >  	/* Turn the power off */
> >  	ret = mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
> > @@ -746,9 +748,14 @@ static int omap_hsmmc_switch_opcond(stru
> >  		ret = mmc_slot(host).set_power(host->dev, host->slot_id, 1,
> >  					       vdd);
> >  	clk_enable(host->iclk);
> > -	if (host->dbclk_enabled)
> > -		clk_enable(host->dbclk);
> >  	clk_enable(host->fclk);
> > +	if (cpu_is_omap2430() && !host->dbclk_enabled) {
> > +		if (clk_enable(host->dbclk) != 0)
> > +			dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
> > +						" clk failed\n");
> > +		else
> > +			host->dbclk_enabled = 1;
> > +	}
> >
> >  	if (ret != 0)
> >  		goto err;
> > @@ -1697,18 +1704,21 @@ static int __init omap_hsmmc_probe(struc
> >  		goto err1;
> >  	}
> >
> > -	host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
> > -	/*
> > -	 * MMC can still work without debounce clock.
> > -	 */
> > -	if (IS_ERR(host->dbclk))
> > -		dev_warn(mmc_dev(host->mmc), "Failed to get debounce
> clock\n");
> > -	else
> > -		if (clk_enable(host->dbclk) != 0)
> > -			dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
> > -							" clk failed\n");
> > +	if (cpu_is_omap2430()) {
> > +		host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
> > +		/*
> > +		 * MMC can still work without debounce clock.
> > +		 */
> > +		if (IS_ERR(host->dbclk))
> > +			dev_warn(mmc_dev(host->mmc),
> > +				"Failed to get debounce clock\n");
> >  		else
> > -			host->dbclk_enabled = 1;
> > +			if (clk_enable(host->dbclk) != 0)
> > +				dev_dbg(mmc_dev(host->mmc), "Enabling
debounce"
> > +							" clk failed\n");
> > +			else
> > +				host->dbclk_enabled = 1;
> > +	}
> >
> >  	/* Since we do only SG emulation, we can have as many segs
> >  	 * as we want. */
> > @@ -1825,8 +1835,9 @@ err_irq:
> >  	clk_disable(host->iclk);
> >  	clk_put(host->fclk);
> >  	clk_put(host->iclk);
> > -	if (host->dbclk_enabled) {
> > -		clk_disable(host->dbclk);
> > +	if (cpu_is_omap2430()) {
> > +		if (host->dbclk_enabled)
> > +			clk_disable(host->dbclk);
> >  		clk_put(host->dbclk);
> >  	}
> >
> > @@ -1859,8 +1870,9 @@ static int omap_hsmmc_remove(struct plat
> >  		clk_disable(host->iclk);
> >  		clk_put(host->fclk);
> >  		clk_put(host->iclk);
> > -		if (host->dbclk_enabled) {
> > -			clk_disable(host->dbclk);
> > +		if (cpu_is_omap2430()) {
> > +			if (host->dbclk_enabled)
> > +				clk_disable(host->dbclk);
> >  			clk_put(host->dbclk);
> >  		}
> >
> > @@ -1910,8 +1922,10 @@ static int omap_hsmmc_suspend(struct pla
> >  				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
> >  			mmc_host_disable(host->mmc);
> >  			clk_disable(host->iclk);
> > -			if (host->dbclk_enabled)
> > +			if (cpu_is_omap2430() && host->dbclk_enabled) {
> >  				clk_disable(host->dbclk);
> > +				host->dbclk_enabled = 0;
> > +			}
> >  		} else {
> >  			host->suspended = 0;
> >  			if (host->pdata->resume) {
> > @@ -1942,14 +1956,19 @@ static int omap_hsmmc_resume(struct plat
> >  		if (ret)
> >  			goto clk_en_err;
> >
> > -		if (host->dbclk_enabled)
> > -			clk_enable(host->dbclk);
> > -
> >  		if (mmc_host_enable(host->mmc) != 0) {
> >  			clk_disable(host->iclk);
> >  			goto clk_en_err;
> >  		}
> >
> > +		if (cpu_is_omap2430() && !host->dbclk_enabled) {
> > +			if (clk_enable(host->dbclk) != 0)
> > +				dev_dbg(mmc_dev(host->mmc), "Enabling
debounce"
> > +							" clk failed\n");
> > +			else
> > +				host->dbclk_enabled = 1;
> > +		}
> > +
> >  		omap_hsmmc_conf_bus_power(host);
> >
> >  		if (host->pdata->resume) {
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 


