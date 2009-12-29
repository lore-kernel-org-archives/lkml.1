Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZL2TYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZL2TYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZL2TYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:24:13 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58700 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZL2TYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:24:12 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19t8P/uISgQ1SfFDGwcjb0V
Date: Tue, 29 Dec 2009 11:24:07 -0800
From: Tony Lindgren <tony@atomide.com>
To: Luke-Jr <luke@dashjr.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for
 Nokia N800 and N810
Message-ID: <20091229192407.GA3512@atomide.com>
References: <200912290152.16357.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <200912290152.16357.luke@dashjr.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

* Luke-Jr <luke@dashjr.org> [091228 23:51]:
> Add platform data and initialization for USB on Nokia N800 and N810 devices
> via the TUSB6010 chipset.
> 
> Tested on Nokia N810 in Linux-OMAP tree. Mainline is not bootable yet.
> 
> Signed-off-by: Luke Dashjr <luke_linuxkern@dashjr.org>
> ---
>  arch/arm/mach-omap2/Kconfig          |    5 +
>  arch/arm/mach-omap2/Makefile         |    1 +
>  arch/arm/mach-omap2/board-n8x0-usb.c |  173 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-n8x0.c     |    8 ++
>  4 files changed, 187 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-n8x0-usb.c
> 

<snip>

> diff --git a/arch/arm/mach-omap2/board-n8x0-usb.c b/arch/arm/mach-omap2/board-n8x0-usb.c
> new file mode 100644
> index 0000000..2254ebd
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-n8x0-usb.c

<snip>

> +static int		osc_ck_on;
> +
> +static int tusb_set_clock(struct clk *osc_ck, int state)
> +{
> +	if (state) {
> +		if (osc_ck_on > 0)
> +			return -ENODEV;
> +
> +		clk_enable(osc_ck);
> +		osc_ck_on = 1;
> +	} else {
> +		if (osc_ck_on == 0)
> +			return -ENODEV;
> +
> +		clk_disable(osc_ck);
> +		osc_ck_on = 0;
> +	}
> +
> +	return 0;
> +}

Great. The comment from Russell earlier was that we should be now using
clkdev to do things like this and get rid of the _set_clock functions.
In musb_core.c are already using the clk directly if set_clock is NULL.

Can you try the patch below? If it works, just merge it into your
patch.

Regards,

Tony


--1UWUbFP1cBYEclgG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="tusb-clkdev.patch"

>From e84994dccb71c1e01ca0b9f256d9b7496492a4e2 Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Tue, 29 Dec 2009 11:04:58 -0800
Subject: [PATCH] tusb6010: Use clkdev to initialize the clock

Note that in this case the clock is fck, not ick
like for musb.

Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/board-n8x0-usb.c b/arch/arm/mach-omap2/board-n8x0-usb.c
index 2254ebd..e67eabf 100644
--- a/arch/arm/mach-omap2/board-n8x0-usb.c
+++ b/arch/arm/mach-omap2/board-n8x0-usb.c
@@ -25,7 +25,6 @@
 #define GPIO_TUSB_ENABLE	0
 
 static int tusb_set_power(int state);
-static int tusb_set_clock(struct clk *osc_ck, int state);
 
 #if	defined(CONFIG_USB_MUSB_OTG)
 #	define BOARD_MODE	MUSB_OTG
@@ -82,10 +81,8 @@ static struct musb_hdrc_config musb_config = {
 static struct musb_hdrc_platform_data tusb_data = {
 	.mode		= BOARD_MODE,
 	.set_power	= tusb_set_power,
-	.set_clock	= tusb_set_clock,
 	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
 	.power		= 100,	/* Max 100 mA VBUS for host mode */
-	.clock		= "osc_ck",
 	.config		= &musb_config,
 };
 
@@ -121,27 +118,6 @@ static int tusb_set_power(int state)
 	return retval;
 }
 
-static int		osc_ck_on;
-
-static int tusb_set_clock(struct clk *osc_ck, int state)
-{
-	if (state) {
-		if (osc_ck_on > 0)
-			return -ENODEV;
-
-		clk_enable(osc_ck);
-		osc_ck_on = 1;
-	} else {
-		if (osc_ck_on == 0)
-			return -ENODEV;
-
-		clk_disable(osc_ck);
-		osc_ck_on = 0;
-	}
-
-	return 0;
-}
-
 void __init n8x0_usb_init(void)
 {
 	int ret = 0;
@@ -156,6 +132,12 @@ void __init n8x0_usb_init(void)
 	}
 	gpio_direction_output(GPIO_TUSB_ENABLE, 0);
 
+	/*
+	 * REVISIT: This line can be removed once all the platforms using
+	 * musb_core.c have been converted to use use clkdev.
+	 */
+	tusb_data.clock = "fck";
+
 	tusb_set_power(0);
 
 	ret = tusb6010_setup_interface(&tusb_data, TUSB6010_REFCLK_19, 2,
diff --git a/arch/arm/mach-omap2/clock2xxx_data.c b/arch/arm/mach-omap2/clock2xxx_data.c
index 97dc7cf..e9c8f09 100644
--- a/arch/arm/mach-omap2/clock2xxx_data.c
+++ b/arch/arm/mach-omap2/clock2xxx_data.c
@@ -2222,6 +2222,7 @@ static struct omap_clk omap24xx_clks[] = {
 	CLK(NULL,	"aes_ick",	&aes_ick,	CK_243X | CK_242X),
 	CLK(NULL,	"pka_ick",	&pka_ick,	CK_243X | CK_242X),
 	CLK(NULL,	"usb_fck",	&usb_fck,	CK_243X | CK_242X),
+	CLK("musb_hdrc",	"fck",	&osc_ck,	CK_242X),
 	CLK("musb_hdrc",	"ick",	&usbhs_ick,	CK_243X),
 	CLK("mmci-omap-hs.0", "ick",	&mmchs1_ick,	CK_243X),
 	CLK("mmci-omap-hs.0", "fck",	&mmchs1_fck,	CK_243X),

--1UWUbFP1cBYEclgG--
