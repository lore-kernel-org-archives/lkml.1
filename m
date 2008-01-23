Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbYAWRdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbYAWRdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYAWR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:28:27 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57503 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756874AbYAWR2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:28:24 -0500
Date: Wed, 23 Jan 2008 18:27:34 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] atmel_lcdfb: backlight control
Message-ID: <20080123182734.45a84e82@dhcp-252-066.norway.atmel.com>
In-Reply-To: <4790BB53.3080407@atmel.com>
References: <4790BB53.3080407@atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 15:44:35 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> On the sam9 EK boards, the LCD backlight is hooked up to a PWM output
> from the LCD controller.  It's controlled by "contrast" registers though.
> 
> This patch lets boards declare that they have that kind of backlight
> control.  The driver can then export this control, letting screenblank
> and other operations actually take effect ... reducing the typically
> substantial power drain from the backlight.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Looks good to me. It won't affect any current AVR32 boards, although
that may change in the future.

A couple of minor comments below.

> +static struct backlight_ops atmel_lcdc_bl_ops = {
> +	.update_status = atmel_bl_update_status,
> +	.get_brightness = atmel_bl_get_brightness,
> +};

This can be const, no?

No it can't, since backlight_device_register() takes a non-const
pointer for some reason...

> +#else
> +
> +static inline void init_backlight(struct atmel_lcdfb_info *sinfo)
> +{
> +	dev_warn(&sinfo->pdev->dev, "backlight control is not available\n");
> +}
> +
> +static inline void exit_contrast(struct atmel_lcdfb_info *sinfo)
> +{
> +}
> +
> +#endif

This looks a bit asymmetric...

> +static inline void init_contrast(struct atmel_lcdfb_info *sinfo)
> +{
> +	/* have some default contrast/backlight settings */
> +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, contrast_ctr);
> +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_VAL, ATMEL_LCDC_CVAL_DEFAULT);
> +
> +	if (sinfo->lcdcon_is_backlight)
> +		init_backlight(sinfo);
> +}
> +
>  
>  static struct fb_fix_screeninfo atmel_lcdfb_fix __initdata = {
>  	.type		= FB_TYPE_PACKED_PIXELS,
> @@ -370,10 +472,6 @@ static int atmel_lcdfb_set_par(struct fb
>  	/* Disable all interrupts */
>  	lcdc_writel(sinfo, ATMEL_LCDC_IDR, ~0UL);
>  
> -	/* Set contrast */
> -	value = ATMEL_LCDC_PS_DIV8 | ATMEL_LCDC_POL_POSITIVE | ATMEL_LCDC_ENA_PWMENABLE;
> -	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, value);
> -	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_VAL, ATMEL_LCDC_CVAL_DEFAULT);
>  	/* ...wait for DMA engine to become idle... */
>  	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
>  		msleep(10);
> @@ -577,6 +675,7 @@ static int __init atmel_lcdfb_probe(stru
>  		sinfo->default_monspecs = pdata_sinfo->default_monspecs;
>  		sinfo->atmel_lcdfb_power_control = pdata_sinfo->atmel_lcdfb_power_control;
>  		sinfo->guard_time = pdata_sinfo->guard_time;
> +		sinfo->lcdcon_is_backlight = pdata_sinfo->lcdcon_is_backlight;
>  	} else {
>  		dev_err(dev, "cannot get default configuration\n");
>  		goto free_info;
> @@ -670,6 +769,9 @@ static int __init atmel_lcdfb_probe(stru
>  		goto release_mem;
>  	}
>  
> +	/* Initialize PWM for contrast or backlight ("off") */
> +	init_contrast(sinfo);
> +
>  	/* interrupt */
>  	ret = request_irq(sinfo->irq_base, atmel_lcdfb_interrupt, 0, pdev->name, info);
>  	if (ret) {
> @@ -755,6 +857,7 @@ static int __exit atmel_lcdfb_remove(str
>  	if (!sinfo)
>  		return 0;
>  
> +	exit_contrast(sinfo);

Missing exit_contrast() in probe() error path?

Haavard
