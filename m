Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZA2OXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZA2OXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZA2OXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:23:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57484 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbZA2OXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:23:13 -0500
Date: Thu, 29 Jan 2009 14:23:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH A 01/10] OMAP2/3: Add non-CORE DPLL rate set code and M, N programming
Message-ID: <20090129142303.GA18233@n2100.arm.linux.org.uk>
References: <20090128020447.7244.80496.stgit@localhost.localdomain> <20090128021243.7244.6362.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128021243.7244.6362.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:12:47PM -0700, Paul Walmsley wrote:
> +/* Non-CORE DPLL rate set code */
> +
> +/*
> + * omap3_noncore_dpll_program - set non-core DPLL M,N values directly
> + * @clk: struct clk * of DPLL to set
> + * @m: DPLL multiplier to set
> + * @n: DPLL divider to set
> + * @freqsel: FREQSEL value to set
> + *
> + * Program the DPLL with the supplied M, N values, and wait for the DPLL to
> + * lock..  Returns -EINVAL upon error, or 0 upon success.
> + */
> +static int omap3_noncore_dpll_program(struct clk *clk, u16 m, u8 n, u16 freqsel)
> +{
> +	struct dpll_data *dd;
> +	u32 v;
> +
> +	if (!clk)
> +		return -EINVAL;
> +
> +	dd = clk->dpll_data;
> +	if (!dd)
> +		return -EINVAL;

Final point... this is only called from the function below, which also
checks that clk and clk->dpll_data are both non-NULL.  So these checks
are unnecessary.

> +static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	u16 freqsel;
> +	struct dpll_data *dd;
> +
> +	if (!clk || !rate)
> +		return -EINVAL;
> +
> +	dd = clk->dpll_data;
> +	if (!dd)
> +		return -EINVAL;
> +
> +	if (rate == omap2_get_dpll_rate(clk))
> +		return 0;
> +
> +	if (dd->last_rounded_rate != rate)
> +		omap2_dpll_round_rate(clk, rate);
> +
> +	if (dd->last_rounded_rate == 0)
> +		return -EINVAL;
> +
> +	freqsel = _omap3_dpll_compute_freqsel(clk, dd->last_rounded_n);
> +	if (!freqsel)
> +		WARN_ON(1);
> +
> +	omap3_noncore_dpll_program(clk, dd->last_rounded_m, dd->last_rounded_n,
> +				   freqsel);
> +
> +	omap3_dpll_recalc(clk);
> +
> +	return 0;
> +}
