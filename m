Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZA2Ka2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZA2Ka2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZA2KaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:30:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40167 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZA2KaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:30:13 -0500
Date: Thu, 29 Jan 2009 10:30:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH C 06/13] OMAP3 clock: DPLLs should enter bypass if new rate is sys_ck
Message-ID: <20090129103003.GA12627@n2100.arm.linux.org.uk>
References: <20090128190724.12092.22239.stgit@localhost.localdomain> <20090128190823.12092.2638.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128190823.12092.2638.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:08:26PM -0700, Paul Walmsley wrote:
>  static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
>  {
>  	u16 freqsel;
>  	struct dpll_data *dd;
> +	int ret;

So 'ret' is a new variable...

>  
>  	if (!clk || !rate)
>  		return -EINVAL;
> @@ -389,18 +393,32 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
>  	if (rate == omap2_get_dpll_rate(clk))
>  		return 0;
>  
> -	if (dd->last_rounded_rate != rate)
> -		omap2_dpll_round_rate(clk, rate);
> +	if (dd->bypass_clk->rate == rate &&
> +	    (clk->dpll_data->modes & (1 << DPLL_LOW_POWER_BYPASS))) {
>  
> -	if (dd->last_rounded_rate == 0)
> -		return -EINVAL;
> +		pr_debug("clock: %s: set rate: entering bypass.\n", clk->name);
> +
> +		ret = _omap3_noncore_dpll_bypass(clk);

which is assigned to...

> +

Additional noise.

> +	} else {
> +

More noise.

> +		if (dd->last_rounded_rate != rate)
> +			omap2_dpll_round_rate(clk, rate);
>  
> -	freqsel = _omap3_dpll_compute_freqsel(clk, dd->last_rounded_n);
> -	if (!freqsel)
> -		WARN_ON(1);
> +		if (dd->last_rounded_rate == 0)
> +			return -EINVAL;
>  
> -	omap3_noncore_dpll_program(clk, dd->last_rounded_m, dd->last_rounded_n,
> -				   freqsel);
> +		freqsel = _omap3_dpll_compute_freqsel(clk, dd->last_rounded_n);
> +		if (!freqsel)
> +			WARN_ON(1);
> +
> +		pr_debug("clock: %s: set rate: locking rate to %lu.\n",
> +			 clk->name, rate);
> +
> +		ret = omap3_noncore_dpll_program(clk, dd->last_rounded_m,
> +						 dd->last_rounded_n, freqsel);

Assigned to again...

> +

More noise.

> +	}
>  
>  	omap3_dpll_recalc(clk);
>  

But ret is never actually used.
