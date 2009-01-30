Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZA3Dnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZA3Dnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZA3Dne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:43:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:40127 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZA3Dnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:43:33 -0500
Subject: Re: [PATCH] atyfb: fix distorted image on PowerMacs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: Alex Kern <alex.kern@gmx.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
References: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 14:42:50 +1100
Message-Id: <1233286970.18767.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 20:22 +0200, Risto Suominen wrote:
> Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
> and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
> columns in their framebuffer image. This seems to depend on a value (4) read
> from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
> be written to the chip. This patch uses a value calculated by aty_init_pll_ct
> instead, as a starting point.
> 
> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
> ---
> The testing is done on kernel version 2.6.18.

This also fixes my oooold wallstreet powerbook.

Andrew, do you mind if I include that in the powerpc tree ?

Cheers,
Ben.

> --- a/drivers/video/aty/mach64_ct.c.org	2006-09-20 06:42:06.000000000 +0300
> +++ b/drivers/video/aty/mach64_ct.c	2009-01-22 14:28:13.000000000 +0200
> @@ -7,6 +7,7 @@
>  #include <linux/delay.h>
>  #include <asm/io.h>
>  #include <video/mach64.h>
> +#include <asm/machdep.h>
>  #include "atyfb.h"
> 
>  #undef DEBUG
> @@ -536,6 +537,14 @@ static int __init aty_init_pll_ct(const
>  	pll->ct.xclk_post_div_real = postdividers[xpost_div];
>  	pll->ct.mclk_fb_div = q * pll->ct.xclk_post_div_real / 8;
> 
> +#ifdef CONFIG_PPC
> +	if (machine_is(powermac)) {
> +		/* Override PLL_EXT_CNTL & 0x07. */
> +		pll->ct.xclk_post_div = xpost_div;
> +		pll->ct.xclk_ref_div = 1;
> +	}
> +#endif
> +
>  #ifdef DEBUG
>  	pllmclk = (1000000 * pll->ct.mclk_fb_mult * pll->ct.mclk_fb_div) /
>  			(par->ref_clk_per * pll->ct.pll_ref_div);

