Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZA2Kia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZA2Kia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZA2KiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:38:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56456 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZA2KiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:38:19 -0500
Date: Thu, 29 Jan 2009 10:38:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Rick Bronson <rick@efn.org>, Timo Kokkonen <timo.t.kokkonen@nokia.com>,
       Sakari Poussa <sakari.poussa@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH C 09/13] OMAP3 clock: fix non-CORE DPLL rate assignment bugs
Message-ID: <20090129103808.GD12627@n2100.arm.linux.org.uk>
References: <20090128190724.12092.22239.stgit@localhost.localdomain> <20090128190832.12092.37861.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128190832.12092.37861.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:08:35PM -0700, Paul Walmsley wrote:
> diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
> index 424eed6..c943043 100644
> --- a/arch/arm/mach-omap2/clock34xx.c
> +++ b/arch/arm/mach-omap2/clock34xx.c
> @@ -270,7 +270,6 @@ static int _omap3_noncore_dpll_stop(struct clk *clk)
>  static int omap3_noncore_dpll_enable(struct clk *clk)
>  {
>  	int r;
> -	long rate;
>  	struct dpll_data *dd;
>  
>  	if (clk == &dpll3_ck)
> @@ -286,7 +285,7 @@ static int omap3_noncore_dpll_enable(struct clk *clk)
>  		r = _omap3_noncore_dpll_lock(clk);
>  
>  	if (!r)
> -		clk->rate = rate;
> +		clk->rate = omap2_get_dpll_rate(clk);

This whole patch can be viewed as another bug fix to patch 6.

> @@ -429,6 +428,9 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
>  		ret = omap3_noncore_dpll_program(clk, dd->last_rounded_m,
>  						 dd->last_rounded_n, freqsel);
>  
> +		if (!ret)
> +			clk->rate = rate;
> +

So this is creating:

	if (...) {
		ret = something;

		if (!ret)
			clk->rate = rate;
	} else {
		ret = something else;

		if (!ret)
			clk->rate = rate;
	}

So why not make it easier to read and more obvious:

	if (...) {
		ret = something;
	} else {
		ret = something else;
	}

	if (!ret)
		clk->rate = rate;

>  	}
>  
>  	omap3_dpll_recalc(clk);
> 
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
