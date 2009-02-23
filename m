Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZBWPvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZBWPvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZBWPvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:51:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45110 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbZBWPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:51:00 -0500
Date: Mon, 23 Feb 2009 15:50:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 12/14] OMAP clock: unnecessary clock flag removal fiesta
Message-ID: <20090223155049.GA27688@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192759.29333.76642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128192759.29333.76642.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:28:01PM -0700, Paul Walmsley wrote:
> 4. The CONFIG_PARTICIPANT flags indicates to the clock rate and parent
> changing functions that they should not be used on this clock.  Better
> just to remove the clock function pointers that operate on those
> clocks.  The name of the flag is just terrible: its meaning has almost
> nothing to do with its name, and the use of the CONFIG_ prefix makes
> it appear to be a Kconfig option.  Get rid of it.

Hmm.  Completely agree over the naming issue, however I think this
opens a hole.

> @@ -780,12 +772,6 @@ int omap2_clk_set_rate(struct clk *clk, unsigned long rate)
>  
>  	pr_debug("clock: set_rate for clock %s to rate %ld\n", clk->name, rate);
>  
> -	/* CONFIG_PARTICIPANT clocks are changed only in sets via the
> -	   rate table mechanism, driven by mpu_speed  */
> -	if (clk->flags & CONFIG_PARTICIPANT)
> -		return -EINVAL;
> -
> -	/* dpll_ck, core_ck, virt_prcm_set; plus all clksel clocks */
>  	if (clk->set_rate)
>  		ret = clk->set_rate(clk, rate);
>  

The removal of this can be mitigated as indicated; not having a set_rate
method does indeed cause this to return -EINVAL.

> @@ -830,9 +816,6 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
>  {
>  	u32 field_val, v, parent_div;
>  
> -	if (clk->flags & CONFIG_PARTICIPANT)
> -		return -EINVAL;
> -
>  	if (!clk->clksel)
>  		return -EINVAL;
>  

This one, however, is not...

> @@ -1020,16 +1018,13 @@ static struct clk mpu_ck = {	/* Control cpu */
>  	.parent		= &core_ck,
>  	.prcm_mod	= MPU_MOD,
>  	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
> -				ALWAYS_ENABLED | DELAYED_APP |
> -				CONFIG_PARTICIPANT | RATE_PROPAGATES,
> +				ALWAYS_ENABLED | DELAYED_APP,
>  	.clkdm		= { .name = "mpu_clkdm" },
>  	.init		= &omap2_init_clksel_parent,
>  	.clksel_reg	= CM_CLKSEL,
>  	.clksel_mask	= OMAP24XX_CLKSEL_MPU_MASK,
>  	.clksel		= mpu_clksel,
>  	.recalc		= &omap2_clksel_recalc,
> -	.round_rate	= &omap2_clksel_round_rate,
> -	.set_rate	= &omap2_clksel_set_rate
>  };
>  
>  /*

For example, here we have a clock which was previously marked with
CONFIG_PARTICIPANT, and has a non-NULL clksel member.  This means
that clk_set_parent() would return -EINVAL before, but would have
an effect after the removal of this flag.

The same is true of dsp_fck, dsp_irate_ick, iva1_ifck, core_l3_ck,
usb_l4_ick and mdm_ick.

So, is this change safe for these clocks?

(Note: all the other flags have already gone in my tree.)
