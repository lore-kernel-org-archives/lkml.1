Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZAVUbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZAVUbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZAVUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:31:33 -0500
Received: from smtp5.welho.com ([213.243.153.39]:33008 "EHLO smtp5.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZAVUbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:31:32 -0500
X-Greylist: delayed 1163 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 15:31:32 EST
Date: Thu, 22 Jan 2009 22:12:04 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: Alex Kern <alex.kern@gmx.de>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] atyfb: fix distorted image on PowerMacs
Message-ID: <20090122201204.GD4996@sci.fi>
Mail-Followup-To: Risto Suominen <risto.suominen@gmail.com>,
	Alex Kern <alex.kern@gmx.de>, linux-kernel@vger.kernel.org,
	benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net
References: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 08:22:48PM +0200, Risto Suominen wrote:
> Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
> and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
> columns in their framebuffer image. This seems to depend on a value (4) read
> from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
> be written to the chip. This patch uses a value calculated by aty_init_pll_ct
> instead, as a starting point.

AFAICS it should be the right thing to do on other systems too. I have
a good collection of mach64 pci cards and laptops so I'll try to find
some time next week to test that theory on x86.

Also cc:ing fbdev-devel...

> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
> ---
> The testing is done on kernel version 2.6.18.
> 
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

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
