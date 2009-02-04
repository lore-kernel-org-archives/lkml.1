Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbZBDX53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbZBDX53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZBDX5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:57:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:58533 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938AbZBDX5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:57:18 -0500
Subject: Re: [patch 07/41] fbdev/atyfb: Fix DSP config on some PowerMacs &
 PowerBooks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Risto Suominen <Risto.Suominen@gmail.com>
In-Reply-To: <20090204184602.GH25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
	 <20090204184602.GH25246@kroah.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 10:51:15 +1100
Message-Id: <1233791475.4612.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 10:46 -0800, Greg KH wrote:
> plain text document attachment
> (fbdev-atyfb-fix-dsp-config-on-some-powermacs-powerbooks.patch)
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.

My only possible worry with that one is the first generation clamshell
iBook which uses a Mobility M1 chip, for which we haven't had anybody
testing whether this would break it or not ... 

So if anybody with such a machine is reading this, please holler...

Cheers,
Ben.

> ------------------
> 
> From: Risto Suominen <Risto.Suominen@gmail.com>
> 
> commit 7fbb7cadd062baf299fd8b26a80ea99da0c3fe01 upstream.
> 
> Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
> and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
> columns in their framebuffer image. This seems to depend on a value (4) read
> from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
> be written to the chip. This patch uses a value calculated by aty_init_pll_ct
> instead, as a starting point.
> 
> There are questions as to whether this should be extended to other platforms
> or maybe made dependent on specific chip types, but in the meantime, this has
> been tested on various powermacs and works for them so let's commit it.
> 
> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
> Tested-by: Michael Pettersson <mike@it.uu.se>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/video/aty/mach64_ct.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> --- a/drivers/video/aty/mach64_ct.c
> +++ b/drivers/video/aty/mach64_ct.c
> @@ -8,6 +8,9 @@
>  #include <asm/io.h>
>  #include <video/mach64.h>
>  #include "atyfb.h"
> +#ifdef CONFIG_PPC
> +#include <asm/machdep.h>
> +#endif
>  
>  #undef DEBUG
>  
> @@ -536,6 +539,14 @@ static int __devinit aty_init_pll_ct(con
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

