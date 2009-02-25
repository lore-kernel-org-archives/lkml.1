Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbZBYJpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbZBYJpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZBYJpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:45:30 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37345 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbZBYJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:45:28 -0500
Date: Wed, 25 Feb 2009 02:45:25 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, r-woodruff2@ti.com,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
In-Reply-To: <20090214113640.GB17965@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902250239210.32378@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk> <20090209141156.GB16626@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.0902122345160.14667@utopia.booyaka.com> <20090214112325.GA17965@n2100.arm.linux.org.uk> <20090214113640.GB17965@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sat, 14 Feb 2009, Russell King - ARM Linux wrote:

> On Sat, Feb 14, 2009 at 11:23:25AM +0000, Russell King - ARM Linux wrote:
> > There's also a second issue - the comments before omap2_divisor_to_clksel()
> > indicate that this function returns 0xffffffff on error.  Unfortunately,
> > this is not so, it actually returns zero on error.  Moreover, we test
> > the result of the function against ~0, so we'll never deal with the error
> > case.  This really should be fixed so that we return the right value for
> > the error case.  (Further comments on this in a follow up.)
> 
> The thing I don't like about this is that we have several functions looking
> up clksel_rate entries, some of which return 0 on error and others ~0 on
> error.
> 
> This is very prone to mistakes - and is probably why the original problem
> has occurred.  I'd much prefer to fix the underlying confusion rather
> than letting it persist, by making all these lookup functions return the
> clksel_rate pointer or NULL.
> 
> Not only does that avoid the question about whether the function returns
> 0 or ~0 on error, but it also gets rid of the horrible return-through-pointer
> style of _omap2_clksel_get_src_field() which itself is error prone.
> (The kernel has had a few cases where this kind of thing has lead to
> uninitialized use, so avoiding this where it's easy to do so makes
> sense.)
> 
> One final point:
> 
>         if (parent_div > 0)
>                 clk->rate /= parent_div;
> 
> seems to be impossible to be false - the old code used div == 0 in the
> tables as the end of table sentinel, and if it is encountered, 
> _omap2_clksel_get_src_field (and the newer omap2_clksel_lookup_parent)
> causes failure to occur.  Also, since parent_div is unsigned, the only
> case where the above statement is false is when div == 0.  So, the code
> can be further simplified to:
> 
>  	/* CLKSEL clocks follow their parents' rates, divided by a divisor */
>  	clk->rate = new_parent->rate / clkr->div;
> 
> Agreed?

Agreed on both points -- a few comments on the patch:

> diff -u a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
> --- a/arch/arm/mach-omap2/clock.c
> +++ b/arch/arm/mach-omap2/clock.c
> @@ -596,23 +596,24 @@
>  }
>  
>  /**
> - * omap2_clksel_to_divisor() - turn clksel field value into integer divider
> + * omap2_clksel_lookup_field() - lookup clksel_rate for clksel field value
>   * @clk: OMAP struct clk to use
>   * @field_val: register field value to find
>   *
>   * Given a struct clk of a rate-selectable clksel clock, and a register field
> - * value to search for, find the corresponding clock divisor.  The register
> + * value to search for, find the corresponding clksel_rate entry.  The register
>   * field value should be pre-masked and shifted down so the LSB is at bit 0
> - * before calling.  Returns 0 on error
> + * before calling.  Returns NULL on error.
>   */
> -u32 omap2_clksel_to_divisor(struct clk *clk, u32 field_val)
> +static const
> +struct clksel_rate *omap2_clksel_lookup_field(struct clk *clk, u32 field_val)
>  {
>  	const struct clksel *clks;
>  	const struct clksel_rate *clkr;
>  
>  	clks = omap2_get_clksel_by_parent(clk, clk->parent);
>  	if (!clks)
> -		return 0;
> +		return NULL;
>  
>  	for (clkr = clks->rates; clkr->div; clkr++) {
>  		if ((clkr->flags & cpu_mask) && (clkr->val == field_val))
> @@ -623,22 +624,22 @@
>  		printk(KERN_ERR "clock: Could not find fieldval %d for "
>  		       "clock %s parent %s\n", field_val, clk->name,
>  		       clk->parent->name);
> -		return 0;
> +		return NULL;
>  	}
>  
> -	return clkr->div;
> +	return clkr;
>  }
>  
>  /**
> - * omap2_divisor_to_clksel() - turn clksel integer divisor into a field value
> + * omap2_clksel_lookup_divisor() - lookup clksel_rate for integer divisor
>   * @clk: OMAP struct clk to use
>   * @div: integer divisor to search for
>   *
> - * Given a struct clk of a rate-selectable clksel clock, and a clock divisor,
> - * find the corresponding register field value.  The return register value is
> - * the value before left-shifting.  Returns ~0 on error
> + * Given a struct clk of a rate-selectable clksel clock and a clock divisor,
> + * find the corresponding clksel_rate entry.  Returns NULL on error.
>   */
> -u32 omap2_divisor_to_clksel(struct clk *clk, u32 div)
> +static const
> +struct clksel_rate *omap2_clksel_lookup_divisor(struct clk *clk, u32 div)
>  {
>  	const struct clksel *clks;
>  	const struct clksel_rate *clkr;
> @@ -648,7 +649,7 @@
>  
>  	clks = omap2_get_clksel_by_parent(clk, clk->parent);
>  	if (!clks)
> -		return ~0;
> +		return NULL;
>  
>  	for (clkr = clks->rates; clkr->div; clkr++) {
>  		if ((clkr->flags & cpu_mask) && (clkr->div == div))
> @@ -659,10 +660,10 @@
>  		printk(KERN_ERR "clock: Could not find divisor %d for "
>  		       "clock %s parent %s\n", div, clk->name,
>  		       clk->parent->name);
> -		return ~0;
> +		return NULL;
>  	}
>  
> -	return clkr->val;
> +	return clkr;
>  }
>  
>  /**
> @@ -673,6 +674,7 @@
>   */
>  u32 omap2_clksel_get_divisor(struct clk *clk)
>  {
> +	const struct clksel_rate *clkr;
>  	u32 v;
>  
>  	if (!clk->clksel_mask)
> @@ -681,11 +683,14 @@
>  	v = __raw_readl(clk->clksel_reg) & clk->clksel_mask;
>  	v >>= __ffs(clk->clksel_mask);
>  
> -	return omap2_clksel_to_divisor(clk, v);
> +	clkr = omap2_clksel_lookup_field(clk, v);
> +
> +	return clkr ? clkr->val : 0;
>  }
>  
>  int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
>  {
> +	const struct clksel_rate *clkr;
>  	u32 v, field_val, validrate, new_div = 0;
>  
>  	if (!clk->clksel_mask)
> @@ -695,17 +700,17 @@
>  	if (validrate != rate)
>  		return -EINVAL;
>  
> -	field_val = omap2_divisor_to_clksel(clk, new_div);
> -	if (field_val == ~0)
> +	clkr = omap2_clksel_lookup_divisor(clk, new_div);
> +	if (!clkr)
>  		return -EINVAL;
>  
>  	v = __raw_readl(clk->clksel_reg);
>  	v &= ~clk->clksel_mask;
> -	v |= field_val << __ffs(clk->clksel_mask);
> +	v |= clkr->val << __ffs(clk->clksel_mask);
>  	__raw_writel(v, clk->clksel_reg);
>  	v = __raw_readl(clk->clksel_reg); /* OCP barrier */
>  
> -	clk->rate = clk->parent->rate / new_div;
> +	clk->rate = clk->parent->rate / clkr->div;
>  
>  	_omap2xxx_clk_commit(clk);
>  
> @@ -733,18 +738,18 @@
>  }
>  
>  /*
> - * Converts encoded control register address into a full address
> - * On error, the return value (parent_div) will be 0.
> + * Given a struct clk of a rate-selectable clksel clock and a parent clock,
> + * find the default clksel_rate entry.  Returns NULL on error.
>   */
> -static u32 _omap2_clksel_get_src_field(struct clk *src_clk, struct clk *clk,
> -				       u32 *field_val)
> +static const
> +struct clksel_rate *omap2_clksel_lookup_parent(struct clk *clk, struct clk *parent)
>  {
>  	const struct clksel *clks;
>  	const struct clksel_rate *clkr;
>  
> -	clks = omap2_get_clksel_by_parent(clk, src_clk);
> +	clks = omap2_get_clksel_by_parent(clk, parent);
>  	if (!clks)
> -		return 0;
> +		return NULL;
>  
>  	for (clkr = clks->rates; clkr->div; clkr++) {
>  		if (clkr->flags & cpu_mask && clkr->flags & DEFAULT_RATE)
> @@ -755,20 +760,19 @@
>  		printk(KERN_ERR "clock: Could not find default rate for "
>  		       "clock %s parent %s\n", clk->name,
>  		       src_clk->parent->name);
> -		return 0;
> +		return NULL;
>  	}
>  
>  	/* Should never happen.  Add a clksel mask to the struct clk. */
>  	WARN_ON(clk->clksel_mask == 0);
>  
> -	*field_val = clkr->val;
> -
> -	return clkr->div;
> +	return NULL;

This should return clkr.

>  }
>  
>  int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
>  {
> -	u32 field_val, v, parent_div;
> +	const struct clksel_rate *clkr;
> +	u32 v;
>  
>  	if (clk->flags & CONFIG_PARTICIPANT)
>  		return -EINVAL;
> @@ -776,8 +780,8 @@
>  	if (!clk->clksel)
>  		return -EINVAL;
>  
> -	parent_div = _omap2_clksel_get_src_field(new_parent, clk, &field_val);
> -	if (!parent_div)
> +	clkr = omap2_clksel_lookup_parent(clk, new_parent);
> +	if (!clkr)
>  		return -EINVAL;
>  
>  	if (clk->usecount > 0)
> @@ -786,7 +790,7 @@
>  	/* Set new source value (previous dividers if any in effect) */
>  	v = __raw_readl(clk->clksel_reg);
>  	v &= ~clk->clksel_mask;
> -	v |= field_val << __ffs(clk->clksel_mask);
> +	v |= clkr->val << __ffs(clk->clksel_mask);
>  	__raw_writel(v, clk->clksel_reg);
>  	v = __raw_readl(clk->clksel_reg);    /* OCP barrier */
>  
> @@ -800,8 +804,8 @@
>  	/* CLKSEL clocks follow their parents' rates, divided by a divisor */
>  	clk->rate = new_parent->rate;
>  
> -	if (parent_div > 0)
> -		clk->rate /= parent_div;
> +	if (clkr->div > 0)
> +		clk->rate /= clkr->div;

The conditional can be removed, per your second point above.

>  
>  	pr_debug("clock: set parent of %s to %s (new rate %ld)\n",
>  		 clk->name, clk->parent->name, clk->rate);
> diff -u a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
> --- a/arch/arm/mach-omap2/clock.h
> +++ b/arch/arm/mach-omap2/clock.h
> @@ -42,8 +42,6 @@ void omap2_init_clksel_parent(struct clk *clk);
>  u32 omap2_clksel_get_divisor(struct clk *clk);
>  u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
>  				u32 *new_div);
> -u32 omap2_clksel_to_divisor(struct clk *clk, u32 field_val);
> -u32 omap2_divisor_to_clksel(struct clk *clk, u32 div);
>  unsigned long omap2_fixed_divisor_recalc(struct clk *clk);
>  long omap2_clksel_round_rate(struct clk *clk, unsigned long target_rate);
>  int omap2_clksel_set_rate(struct clk *clk, unsigned long rate);
> 


- Paul
