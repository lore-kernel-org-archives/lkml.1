Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbZAWOWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbZAWOWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZAWOWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:22:00 -0500
Received: from aun.it.uu.se ([130.238.12.36]:32914 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240AbZAWOV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:21:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18809.53887.67378.673723@harpo.it.uu.se>
Date: Fri, 23 Jan 2009 15:21:51 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: Alex Kern <alex.kern@gmx.de>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] atyfb: fix distorted image on PowerMacs
In-Reply-To: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
References: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Risto Suominen writes:
 > Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
 > and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
 > columns in their framebuffer image. This seems to depend on a value (4) read
 > from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
 > be written to the chip. This patch uses a value calculated by aty_init_pll_ct
 > instead, as a starting point.
 > 
 > Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>

Thank you. I reported this issue way back in March 2005
<http://marc.info/?l=linux-kernel&m=111175371705665&w=2>
but nothing ever came out of that. Your patch applies
cleanly to 2.6.29-rc2 and fixes the issue on my Beige G3.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>


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
