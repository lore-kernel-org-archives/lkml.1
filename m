Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbZHRGws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbZHRGws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZHRGws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:52:48 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18315 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZHRGwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:52:47 -0400
Message-ID: <4A8A4FC1.1090206@nokia.com>
Date: Tue, 18 Aug 2009 09:52:49 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Madhusudhan Chikkature <madhu.cr@ti.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] omap_hsmmc: Fix for the db clock failure message
References: <60037.192.168.10.88.1250546653.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <60037.192.168.10.88.1250546653.squirrel@dbdmail.itg.ti.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Aug 2009 06:52:22.0517 (UTC) FILETIME=[6FF07A50:01CA1FD0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Madhusudhan Chikkature wrote:
> This patch applies on top of the series "[PATCH V2 0/32] mmc and omap_hsmmc
> patches" posted by Adrian Hunter.
> 
> -------------------------------------------------
> 
> 
> 
> This patch removes the error message "Failed to get debounce clock.." printed
> out by the HSMMC driver on OMAP3430. The debounce clock needs to be handled only
> for OMAP2430.

I have a suggestion that may make it tidier.

What about renaming host->dbclk_enabled to host->got_dbclk and leaving it alone
after it is set in the probe function.  Then create a macro to use in conditions:

#define have_dbclk(host) (cpu_is_omap2430() && (host)->got_dbclk)

So the following:

-	if (host->dbclk_enabled)
+	if (cpu_is_omap2430() && host->dbclk_enabled) {
 		clk_disable(host->dbclk);
+		host->dbclk_enabled = 0;
+	}

becomes:

-	if (host->dbclk_enabled)
+	if (have_dbclk(host))
 		clk_disable(host->dbclk);

Or alternatively, forget the macro, and let the code always compile in:

-	if (host->dbclk_enabled)
+	if (host->got_dbclk)
 		clk_disable(host->dbclk);


> 
> Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   63 +++++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/drivers/mmc/host/omap_hsmmc.c
> ===================================================================
> --- linux-2.6.orig/drivers/mmc/host/omap_hsmmc.c
> +++ linux-2.6/drivers/mmc/host/omap_hsmmc.c
> @@ -735,8 +735,10 @@ static int omap_hsmmc_switch_opcond(stru
>  	/* Disable the clocks */
>  	clk_disable(host->fclk);
>  	clk_disable(host->iclk);
> -	if (host->dbclk_enabled)
> +	if (cpu_is_omap2430() && host->dbclk_enabled) {
>  		clk_disable(host->dbclk);
> +		host->dbclk_enabled = 0;
> +	}
> 
>  	/* Turn the power off */
>  	ret = mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
> @@ -746,9 +748,14 @@ static int omap_hsmmc_switch_opcond(stru
>  		ret = mmc_slot(host).set_power(host->dev, host->slot_id, 1,
>  					       vdd);
>  	clk_enable(host->iclk);
> -	if (host->dbclk_enabled)
> -		clk_enable(host->dbclk);
>  	clk_enable(host->fclk);
> +	if (cpu_is_omap2430() && !host->dbclk_enabled) {
> +		if (clk_enable(host->dbclk) != 0)
> +			dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
> +						" clk failed\n");
> +		else
> +			host->dbclk_enabled = 1;
> +	}
> 
>  	if (ret != 0)
>  		goto err;
> @@ -1697,18 +1704,21 @@ static int __init omap_hsmmc_probe(struc
>  		goto err1;
>  	}
> 
> -	host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
> -	/*
> -	 * MMC can still work without debounce clock.
> -	 */
> -	if (IS_ERR(host->dbclk))
> -		dev_warn(mmc_dev(host->mmc), "Failed to get debounce clock\n");
> -	else
> -		if (clk_enable(host->dbclk) != 0)
> -			dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
> -							" clk failed\n");
> +	if (cpu_is_omap2430()) {
> +		host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
> +		/*
> +		 * MMC can still work without debounce clock.
> +		 */
> +		if (IS_ERR(host->dbclk))
> +			dev_warn(mmc_dev(host->mmc),
> +				"Failed to get debounce clock\n");
>  		else
> -			host->dbclk_enabled = 1;
> +			if (clk_enable(host->dbclk) != 0)
> +				dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
> +							" clk failed\n");
> +			else
> +				host->dbclk_enabled = 1;
> +	}
> 
>  	/* Since we do only SG emulation, we can have as many segs
>  	 * as we want. */
> @@ -1825,8 +1835,9 @@ err_irq:
>  	clk_disable(host->iclk);
>  	clk_put(host->fclk);
>  	clk_put(host->iclk);
> -	if (host->dbclk_enabled) {
> -		clk_disable(host->dbclk);
> +	if (cpu_is_omap2430()) {
> +		if (host->dbclk_enabled)
> +			clk_disable(host->dbclk);
>  		clk_put(host->dbclk);
>  	}
> 
> @@ -1859,8 +1870,9 @@ static int omap_hsmmc_remove(struct plat
>  		clk_disable(host->iclk);
>  		clk_put(host->fclk);
>  		clk_put(host->iclk);
> -		if (host->dbclk_enabled) {
> -			clk_disable(host->dbclk);
> +		if (cpu_is_omap2430()) {
> +			if (host->dbclk_enabled)
> +				clk_disable(host->dbclk);
>  			clk_put(host->dbclk);
>  		}
> 
> @@ -1910,8 +1922,10 @@ static int omap_hsmmc_suspend(struct pla
>  				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
>  			mmc_host_disable(host->mmc);
>  			clk_disable(host->iclk);
> -			if (host->dbclk_enabled)
> +			if (cpu_is_omap2430() && host->dbclk_enabled) {
>  				clk_disable(host->dbclk);
> +				host->dbclk_enabled = 0;
> +			}
>  		} else {
>  			host->suspended = 0;
>  			if (host->pdata->resume) {
> @@ -1942,14 +1956,19 @@ static int omap_hsmmc_resume(struct plat
>  		if (ret)
>  			goto clk_en_err;
> 
> -		if (host->dbclk_enabled)
> -			clk_enable(host->dbclk);
> -
>  		if (mmc_host_enable(host->mmc) != 0) {
>  			clk_disable(host->iclk);
>  			goto clk_en_err;
>  		}
> 
> +		if (cpu_is_omap2430() && !host->dbclk_enabled) {
> +			if (clk_enable(host->dbclk) != 0)
> +				dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
> +							" clk failed\n");
> +			else
> +				host->dbclk_enabled = 1;
> +		}
> +
>  		omap_hsmmc_conf_bus_power(host);
> 
>  		if (host->pdata->resume) {
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

