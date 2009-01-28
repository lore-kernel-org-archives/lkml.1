Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZA1XdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZA1XdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbZA1X2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52093 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbZA1X2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:42 -0500
Date: Wed, 28 Jan 2009 23:28:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH A 09/10] OMAP2/3: Remove OMAP_PRM_REGADDR, OMAP_CM_REGADDR
Message-ID: <20090128232831.GL23301@n2100.arm.linux.org.uk>
References: <20090128020447.7244.80496.stgit@localhost.localdomain> <20090128021312.7244.2415.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128021312.7244.2415.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:13:16PM -0700, Paul Walmsley wrote:
> diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
> index c4b80a4..55c5d67 100644
> --- a/arch/arm/mach-omap2/clock.c
> +++ b/arch/arm/mach-omap2/clock.c
> @@ -27,6 +27,7 @@
>  #include <mach/clock.h>
>  #include <mach/clockdomain.h>
>  #include <mach/cpu.h>
> +#include <mach/prcm.h>
>  #include <asm/div64.h>
>  
>  #include "memory.h"
> @@ -247,9 +248,9 @@ static void omap2_clk_wait_ready(struct clk *clk)
>  	/* REVISIT: What are the appropriate exclusions for 34XX? */
>  	/* OMAP3: ignore DSS-mod clocks */
>  	if (cpu_is_omap34xx() &&
> -	    (((u32)reg & ~0xff) == (u32)OMAP_CM_REGADDR(OMAP3430_DSS_MOD, 0) ||
> -	     ((((u32)reg & ~0xff) == (u32)OMAP_CM_REGADDR(CORE_MOD, 0)) &&
> -	     clk->enable_bit == OMAP3430_EN_SSI_SHIFT)))
> +	    (((u32)reg & ~0xff) == cm_read_mod_reg(OMAP3430_DSS_MOD, 0) ||
> +	     ((((u32)reg & ~0xff) == cm_read_mod_reg(CORE_MOD, 0)) &&
> +	      clk->enable_bit == OMAP3430_EN_SSI_SHIFT)))
>  		return;

As suggested in patch 2, I hate this approach.  It's far better to deal
with this by changing the way we handle enabling and disabling clocks,
hence my

"[ARM] omap: eliminate unnecessary conditionals in omap2_clk_wait_ready"

> @@ -476,6 +466,37 @@ static int __init omap2_clk_arch_init(void)
>  }
>  arch_initcall(omap2_clk_arch_init);
>  
> +static u32 prm_base;
> +static u32 cm_base;
> +
> +/*
> + * Since we share clock data for 242x and 243x, we need to rewrite some
> + * some register base offsets. Assume offset is at prm_base if flagged,
> + * else assume it's cm_base.
> + */
> +static inline void omap2_clk_check_reg(u32 flags, void __iomem **reg)
> +{
> +	u32 tmp = (__force u32)*reg;
> +
> +	if ((tmp >> 24) != 0)
> +		return;
> +
> +	if (flags & OFFSET_GR_MOD)
> +		tmp += prm_base;
> +	else
> +		tmp += cm_base;
> +
> +	*reg = (__force void __iomem *)tmp;
> +}
> +
> +void __init omap2_clk_rewrite_base(struct clk *clk)
> +{
> +	omap2_clk_check_reg(clk->flags, &clk->clksel_reg);
> +	omap2_clk_check_reg(clk->flags, &clk->enable_reg);
> +	if (clk->dpll_data)
> +		omap2_clk_check_reg(0, &clk->dpll_data->mult_div1_reg);
> +}
> +
>  int __init omap2_clk_init(void)
>  {
>  	struct prcm_config *prcm;
> @@ -487,6 +508,12 @@ int __init omap2_clk_init(void)
>  	else if (cpu_is_omap2430())
>  		cpu_mask = RATE_IN_243X;
>  
> +	for (clkp = onchip_24xx_clks;
> +	     clkp < onchip_24xx_clks + ARRAY_SIZE(onchip_24xx_clks);
> +	     clkp++) {
> +			omap2_clk_rewrite_base(*clkp);
> +	}
> +

I'm afraid this also fails to satisfy my decency filter.  Let's summarise
what's going on here.

- the structure initializers are setup to cast integer register offsets
  to void __iomem *.
- the code above walks all clock structures, looking for what could be
  considered an offset (iow, bits 31-24 of the pointer being zero).
- it looks at the OFFSET_GR_MOD flag to determine which base to add in
- the base address is not 'void __iomem *' but 'u32'.
- we update the void __iomem * pointers in the structure.

So, we have a base address which is an integer, and an offset which is
an void __iomem *.

I can see why you want to do this, but I think it needs more thought.
I'll sit on this patch for a while.

In the mean time, I've fixed up patches 1-8,10 to apply on top of my
patch set.

However, still waiting for a few to come through: D6, E2 and F2.  No,
these aren't suck in any of my mail spools or list admin queues.
