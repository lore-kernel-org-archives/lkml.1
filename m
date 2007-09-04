Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXIFMG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXIFMG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbXIFMGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:06:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:59745 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137AbXIFMGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:06:14 -0400
Subject: Re: [PATCH 2/4] radeonfb: add new module parameter to force PLL
	calculation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: aherrman@arcor.de
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070904105908.GF7320@devil>
References: <20070904105908.GF7320@devil>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 15:46:29 +0200
Message-Id: <1188913589.5972.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 12:59 +0200, aherrman@arcor.de wrote:
> On my Acer Aspire 5100 (with 0x5975) I need to force PLL caclulation.
> Most probably the BIOS dividers are incorrect/insufficient. Without pll
> calculation console goes blank.
> 
> Signed-off-by: Andreas Herrmann <aherrman@arcor.de>

I don't like those tunables. First we should get a look at what values
we obtain from the BIOS. Could be something with the parsing of ATOM
BIOS. In any case, we might be able to detect we got wrong values or use
subsystem vendor/device ID to blacklist.

Ben.

> ---
>  drivers/video/aty/radeon_base.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
> index 90a3957..f672c0c 100644
> --- a/drivers/video/aty/radeon_base.c
> +++ b/drivers/video/aty/radeon_base.c
> @@ -268,6 +268,7 @@ static int mirror = 0;
>  static int panel_yres = 0;
>  static int force_dfp = 0;
>  static int force_measure_pll = 0;
> +static int force_pll_calc = 0;
>  #ifdef CONFIG_MTRR
>  static int nomtrr = 0;
>  #endif
> @@ -1590,7 +1591,7 @@ static int radeonfb_set_par(struct fb_info *info)
>  
>  		pixClock = 100000000 / rinfo->panel_info.clock;
>  
> -		if (rinfo->panel_info.use_bios_dividers) {
> +		if (rinfo->panel_info.use_bios_dividers && !force_pll_calc) {
>  			nopllcalc = 1;
>  			newmode->ppll_div_3 = rinfo->panel_info.fbk_divider |
>  				(rinfo->panel_info.post_divider << 16);
> @@ -2495,6 +2496,8 @@ static int __init radeonfb_setup (char *options)
>  			nomodeset = 1;
>  		} else if (!strncmp(this_opt, "force_measure_pll", 17)) {
>  			force_measure_pll = 1;
> +		} else if (!strncmp(this_opt, "force_pll_calc", 17)) {
> +			force_pll_calc = 1;
>  		} else if (!strncmp(this_opt, "ignore_edid", 11)) {
>  			ignore_edid = 1;
>  #if defined(CONFIG_PM) && defined(CONFIG_X86)
> @@ -2550,6 +2553,8 @@ module_param(monitor_layout, charp, 0);
>  MODULE_PARM_DESC(monitor_layout, "Specify monitor mapping (like XFree86)");
>  module_param(force_measure_pll, bool, 0);
>  MODULE_PARM_DESC(force_measure_pll, "Force measurement of PLL (debug)");
> +module_param(force_pll_calc, bool, 0400);
> +MODULE_PARM_DESC(force_pll_calc, "Force calculation of PLL");
>  #ifdef CONFIG_MTRR
>  module_param(nomtrr, bool, 0);
>  MODULE_PARM_DESC(nomtrr, "bool: disable use of MTRR registers");

